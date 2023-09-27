require "sinatra"
require "sinatra/reloader"
require "http"
require "json"

get("/") do

  erb(:front_page)
end

get("/slowbaits") do

  erb(:slow)
end

get("/movebaits") do

  erb(:move)
end

get("/topwaterbaits") do

  erb(:top)
end

get("/baitfinder") do

gmaps_key = ENV["GMAPS_KEY"]
location = params.fetch("location")
gmaps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{location}&key=#{gmaps_key}"
raw_gmaps = HTTP.get(gmaps_url)
parsed_gmaps = JSON.parse(raw_gmaps)
gmaps_array = parsed_gmaps.fetch("results");
first_hash_results = gmaps_array.at(0)
geo_hash = first_hash_results.fetch("geometry")
location_hash = geo_hash.fetch("location")
long = location_hash.fetch("lng")
lat = location_hash.fetch("lat");
@loc = location
@loc2 = location

pirate_key = ENV["PIRATE_WEATHER_KEY"]
pirate_url = "https://api.pirateweather.net/forecast/#{pirate_key}/#{lat},#{long}"
raw_pirate_data = HTTP.get(pirate_url)
parsed_pirate_data = JSON.parse(raw_pirate_data)
current_pirate = parsed_pirate_data.fetch("currently")
current_temp = current_pirate.fetch("temperature")
@temp = current_temp

if @temp >= 80 
  @a = "slow moving baits." 
elsif @temp < 60
  @a = "slow moving baits." 
elsif @temp < 80
  @a = "moving baits or top water baits! Get out there, this is the best and most fun time to fish."
else 
  @a = "worms"
end

if @loc2 == "Alaska"
  @b = "You can throw just about anything because you live in the best state that has extremely good fishing! Try for salmon and salt water fish, too!"
elsif @loc2 == "Florida"
  @b = "You can throw just about anything because you live in a that has extremely good fishing!"
elsif @loc2 == "Texas"
  @b = "You can throw just about anything because you live in a that has extremely good fishing! Try for bass!"
elsif @loc2 == "Minnesota"
  @b = "You can throw just about anything because you live in a that has extremely good fishing! Fry up those walleyes!"
elsif @loc2 == "Wisconsin"
  @b = "You can throw just about anything because you live in a that has extremely good fishing! Musky should be your choice!"
elsif @loc2 == "Montana"
  @b = "You can throw just about anything because you live in a that has extremely good fishing! Try fly fishing for trout!"
elsif @loc2 == "Michigan"
  @b = "You can throw just about anything because you live in a that has extremely good fishing!"
else
  @b = "Good luck!"
end

erb(:baitfind)
end
