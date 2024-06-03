#!/bin/sh

# Color codes (we can cook something here)
# RED='\033[0;31m'
# BOLDRED='\033[1;31m'
# GREEN='\033[0;32m'
# BOLDGREEN='\033[1;32m'
# ORANGE='\033[0;33m'
# YELLOW='\033[1;33m'
# BLUE='\033[0;34m'
# BOLDBLUE='\033[1;34m'
# PURPLE='\033[0;35m'
# BOLDPURPLE='\033[1;35m'
# CYAN='\033[0;36m'
# BOLDCYAN='\033[1;36m'
# WHITE='\033[0;37m'
# BOLDWHITE='\033[1;37m'
# NC='\033[0m'

# Function to format and display time using figlet with bold green color and basic font
display_time() {
  local time_string=$1
  local hours_digit1="${time_string:0:1}"
  local hours_digit2="${time_string:1:1}"
  local minutes_digit1="${time_string:3:1}"
  local minutes_digit2="${time_string:4:1}"
  local seconds_digit1="${time_string:6:1}"
  local seconds_digit2="${time_string:7:1}"
  
  local formatted_time="$hours_digit1 $hours_digit2 : $minutes_digit1 $minutes_digit2 : $seconds_digit1 $seconds_digit2"
  echo "$(figlet -f basic "$formatted_time")"
  #   echo -e "${BOLDGREEN}$(figlet -f basic "$formatted_time")${NC}" - If we want to color it
}

# Function to calculate the difference between now and the target date
time_difference() {
  local target_date=$1
  local target_time=$2
  
  local current_seconds=$(date +%s)
  local target_seconds=$(date -j -f "%Y/%m/%d %H:%M:%S" "$target_date $target_time" +%s)
  local diff_seconds=$((target_seconds - current_seconds))
  
  if ((diff_seconds < 0)); then
    echo "Target date and time have already passed"
    exit 1
  fi
  
  local hours=$((diff_seconds / 3600))
  local minutes=$(((diff_seconds % 3600) / 60))
  local seconds=$((diff_seconds % 60))
  
  echo $(printf "%02d:%02d:%02d" $hours $minutes $seconds)
}

# Infinite loop to update every second
while true; do
  if [[ $1 == "c" ]]; then
    current_time=$(date +%H:%M:%S)
    display_time "$current_time"
  elif [[ $1 == "t" && $# -eq 3 ]]; then
    countdown_time=$(time_difference $2 $3)
    display_time "$countdown_time"
  else
    echo "Invalid parameters. Usage: clock.sh [c|t] [YYYY/MM/DD] [HH:MM:SS]"
    exit 1
  fi
  sleep 1
  clear
done
