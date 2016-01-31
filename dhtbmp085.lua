PIN = 4
OSS = 3 -- oversampling setting (0-3)
SDA_PIN = 6 
SCL_PIN = 5 

function getTemp()
status,temp,humi,temp_dec,humi_dec = dht.read(PIN)
bmp085.init(SDA_PIN, SCL_PIN)
t = bmp085.temperature()
p = bmp085.pressure(OSS)
end

--- Get temp and send data to thingspeak.com
function sendData()
getTemp()
-- conection to thingspeak.com

http.get("https://api.thingspeak.com/update?api_key=xxxxxxxxxxxxxx&field1="..(temp+2).."&field2="..humi.."&field3="..(p/100+20).."&field4="..(t/10), nil, function(code, data)
    if (code < 0) then
      print("HTTP request failed")
    else
      print(code, data)
      print("  Sent data to thingspeak.com ,"..(temp+2)..","..humi..","..(t/10)..","..(p/100+20))
    end
  end)
end
-- send data every X ms to thing speak
tmr.alarm(2, 10000, 1, function() sendData() end )
