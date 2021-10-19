Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32298432B73
	for <lists+stable@lfdr.de>; Tue, 19 Oct 2021 03:21:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbhJSBX2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 21:23:28 -0400
Received: from alexa-out.qualcomm.com ([129.46.98.28]:29777 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbhJSBX2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Oct 2021 21:23:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1634606477; x=1666142477;
  h=subject:from:to:cc:references:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=Zx89XVWdlmsCKxuiWsRLKdDqOfRlsYCYIwY3y4DKaYE=;
  b=dZfohoTi/OLt/ASIv1zK8ExaFZeSl8pm+vhWZ+NrdcwOyS+QfZf5zKq+
   s7tgCfRBSvnijEToXorJ+Mi7ECT4+ImSCk/7i8A9bAkBvgwFArtLxMoeH
   DV1bzlue6TKDOLOsiiZ/2ajUbwEQlUzMEK0BB7SwAxzUWIKXHDuBaCqDx
   s=;
Received: from ironmsg08-lv.qualcomm.com ([10.47.202.152])
  by alexa-out.qualcomm.com with ESMTP; 18 Oct 2021 18:21:16 -0700
X-QCInternal: smtphost
Received: from nalasex01a.na.qualcomm.com ([10.47.209.196])
  by ironmsg08-lv.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2021 18:21:15 -0700
Received: from [10.47.233.232] (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.922.7; Mon, 18 Oct 2021
 18:21:15 -0700
Subject: Re: [PATCH v2] thermal: Fix a NULL pointer dereference
From:   Subbaraman Narayanamurthy <quic_subbaram@quicinc.com>
To:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Amit Kucheria <amitk@kernel.org>
CC:     <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        David Collins <quic_collinsd@quicinc.com>,
        Manaf Meethalavalappu Pallikunhi <manafm@codeaurora.org>,
        Ram Chandrasekar <rkumbako@codeaurora.org>,
        <stable@vger.kernel.org>
References: <1631041289-11804-1-git-send-email-quic_subbaram@quicinc.com>
 <003252f2-510f-e9ea-0032-6034f26aad11@linaro.org>
 <16af9946-b662-0bbf-206f-278b7ef98123@quicinc.com>
Message-ID: <8cda69a6-907b-e09e-ba64-011b0216a4df@quicinc.com>
Date:   Mon, 18 Oct 2021 18:21:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <16af9946-b662-0bbf-206f-278b7ef98123@quicinc.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.49.16.6]
X-ClientProxiedBy: nalasex01a.na.qualcomm.com (10.47.209.196) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/8/21 12:50 PM, Subbaraman Narayanamurthy wrote:
> On 10/6/21 4:08 AM, Daniel Lezcano wrote:
>> On 07/09/2021 21:01, Subbaraman Narayanamurthy wrote:
>>> of_parse_thermal_zones() parses the thermal-zones node and registers a
>>> thermal_zone device for each subnode. However, if a thermal zone is
>>> consuming a thermal sensor and that thermal sensor device hasn't probed
>>> yet, an attempt to set trip_point_*_temp for that thermal zone device
>>> can cause a NULL pointer dereference. Fix it.
>>>
>>>  console:/sys/class/thermal/thermal_zone87 # echo 120000 > trip_point_0_temp
>>>  ...
>>>  Unable to handle kernel NULL pointer dereference at virtual address 0000000000000020
>> I'm still not convinced by the changes.
>>
>> Could please tell the commit-id where this is happening and give the
>> procedure to reproduce the bug ?
>>
> Here is the commit id where this problem was reported.
> https://android.googlesource.com/kernel/common/+/997d24a932a9b6e2040f39a8dd76e873e6519a1c
>
> BTW, this problem was not 100% reproducible but seems to be a race condition when vendor modules are loaded and thermal HAL or userspace thermal SW is attempting to set trip points on one of the thermal zones and that sensor driver supplying that thermal zone have not completed probing.
>
> I was able to reproduce the problem manually by disabling the pmk8350_adc_tm device in device tree which supplies to some thermal zone devices (e.g. xo-therm below).
>
> pmk8350_adc_tm: adc_tm@3400 {                                  
>     compatible = "qcom,adc-tm7";                           
>     reg = <0x3400>;                                        
>     interrupts = <0x0 0x34 0x0 IRQ_TYPE_EDGE_RISING>;         
>     interrupt-names = "threshold";                         
>     #address-cells = <1>;                                  
>     #size-cells = <0>;                                     
>     #thermal-sensor-cells = <1>;                           
>     status = "disabled"; /* This is what I've added to simulate the problem */                                  
> };
>
> &thermal_zones {
> ...
>         xo-therm {                                                             
>                 polling-delay-passive = <0>;                                   
>                 polling-delay = <0>;                                           
>                 thermal-sensors = <&pmk8350_adc_tm PMK8350_ADC7_AMUX_THM1_100K_PU>;
>                 trips {
>                     ...
>                 };
> };
>
> With this and reverting my change (which got picked up in internal tree), I can see this.
>
> /sys/class/thermal # cat thermal_zone87/type                                   
> xo-therm
>                                                                        
> /sys/class/thermal # cd thermal_zone87                                         
> /sys/devices/virtual/thermal/thermal_zone87 # ls                               
> available_policies  cdev5_trip_point  mode               trip_point_4_hyst        
> cdev0               cdev5_weight      offset             trip_point_4_temp        
> cdev0_trip_point    cdev6             policy             trip_point_4_type        
> cdev0_weight        cdev6_trip_point  power              trip_point_5_hyst        
> cdev1               cdev6_weight      slope              trip_point_5_temp        
> cdev10              cdev7             subsystem          trip_point_5_type        
> cdev10_trip_point   cdev7_trip_point  sustainable_power  trip_point_6_hyst        
> cdev10_weight       cdev7_weight      temp               trip_point_6_temp        
> cdev1_trip_point    cdev8             trip_point_0_hyst  trip_point_6_type        
> cdev1_weight        cdev8_trip_point  trip_point_0_temp  trip_point_7_hyst        
> cdev2               cdev8_weight      trip_point_0_type  trip_point_7_temp        
> cdev2_trip_point    cdev9             trip_point_1_hyst  trip_point_7_type        
> cdev2_weight        cdev9_trip_point  trip_point_1_temp  trip_point_8_hyst        
> cdev3               cdev9_weight      trip_point_1_type  trip_point_8_temp        
> cdev3_trip_point    emul_temp         trip_point_2_hyst  trip_point_8_type        
> cdev3_weight        integral_cutoff   trip_point_2_temp  type                  
> cdev4               k_d               trip_point_2_type  uevent                
> cdev4_trip_point    k_i               trip_point_3_hyst                        
> cdev4_weight        k_po              trip_point_3_temp                        
> cdev5               k_pu              trip_point_3_type
>                         
> /sys/devices/virtual/thermal/thermal_zone87 # cat trip_point_0_temp            
> 125000                                                                         
>
> /sys/devices/virtual/thermal/thermal_zone87 # echo 120000 > trip_point_0_temp  
> [  184.290964][  T211] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000020
> [  184.300896][  T211] Mem abort info:                                         
> [  184.304486][  T211]   ESR = 0x96000006                                      
> [  184.308348][  T211]   EC = 0x25: DABT (current EL), IL = 32 bits            
> [  184.314531][  T211]   SET = 0, FnV = 0                                      
> [  184.318384][  T211]   EA = 0, S1PTW = 0                                     
> [  184.322323][  T211] Data abort info:                                        
> [  184.325993][  T211]   ISV = 0, ISS = 0x00000006                             
> [  184.330655][  T211]   CM = 0, WnR = 0                                       
> [  184.334425][  T211] user pgtable: 4k pages, 39-bit VAs, pgdp=000000081a7a2000
> [  184.341750][  T211] [0000000000000020] pgd=000000081a7a7003, p4d=000000081a7a7003, pud=000000081a7a7003, pmd=0000000000000000
> [  184.353359][  T211] Internal error: Oops: 96000006 [#1] PREEMPT SMP         
> [  184.359797][  T211] Dumping ftrace buffer:                                  
> [  184.364001][  T211]    (ftrace buffer empty)
>
> Hope this helps.

Hi Daniel,
Have you got a chance to look at this?

Thanks,
Subbaraman

>
>>>  ...
>>>  Call trace:
>>>   of_thermal_set_trip_temp+0x40/0xc4
>>>   trip_point_temp_store+0xc0/0x1dc
>>>   dev_attr_store+0x38/0x88
>>>   sysfs_kf_write+0x64/0xc0
>>>   kernfs_fop_write_iter+0x108/0x1d0
>>>   vfs_write+0x2f4/0x368
>>>   ksys_write+0x7c/0xec
>>>   __arm64_sys_write+0x20/0x30
>>>   el0_svc_common.llvm.7279915941325364641+0xbc/0x1bc
>>>   do_el0_svc+0x28/0xa0
>>>   el0_svc+0x14/0x24
>>>   el0_sync_handler+0x88/0xec
>>>   el0_sync+0x1c0/0x200
>>>
>>> While at it, fix the possible NULL pointer dereference in other
>>> functions as well: of_thermal_get_temp(), of_thermal_set_emul_temp(),
>>> of_thermal_get_trend().
>>>
>>> Cc: stable@vger.kernel.org
>>> Suggested-by: David Collins <quic_collinsd@quicinc.com>
>>> Signed-off-by: Subbaraman Narayanamurthy <quic_subbaram@quicinc.com>
>>> ---
>>> Changes for v2:
>>> - Added checks in of_thermal_get_temp(), of_thermal_set_emul_temp(), of_thermal_get_trend().
>>>
>>>  drivers/thermal/thermal_of.c | 9 ++++++---
>>>  1 file changed, 6 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/thermal/thermal_of.c b/drivers/thermal/thermal_of.c
>>> index 6379f26..9233f7e 100644
>>> --- a/drivers/thermal/thermal_of.c
>>> +++ b/drivers/thermal/thermal_of.c
>>> @@ -89,7 +89,7 @@ static int of_thermal_get_temp(struct thermal_zone_device *tz,
>>>  {
>>>  	struct __thermal_zone *data = tz->devdata;
>>>  
>>> -	if (!data->ops->get_temp)
>>> +	if (!data->ops || !data->ops->get_temp)
>>>  		return -EINVAL;
>>>  
>>>  	return data->ops->get_temp(data->sensor_data, temp);
>>> @@ -186,6 +186,9 @@ static int of_thermal_set_emul_temp(struct thermal_zone_device *tz,
>>>  {
>>>  	struct __thermal_zone *data = tz->devdata;
>>>  
>>> +	if (!data->ops || !data->ops->set_emul_temp)
>>> +		return -EINVAL;
>>> +
>>>  	return data->ops->set_emul_temp(data->sensor_data, temp);
>>>  }
>>>  
>>> @@ -194,7 +197,7 @@ static int of_thermal_get_trend(struct thermal_zone_device *tz, int trip,
>>>  {
>>>  	struct __thermal_zone *data = tz->devdata;
>>>  
>>> -	if (!data->ops->get_trend)
>>> +	if (!data->ops || !data->ops->get_trend)
>>>  		return -EINVAL;
>>>  
>>>  	return data->ops->get_trend(data->sensor_data, trip, trend);
>>> @@ -301,7 +304,7 @@ static int of_thermal_set_trip_temp(struct thermal_zone_device *tz, int trip,
>>>  	if (trip >= data->ntrips || trip < 0)
>>>  		return -EDOM;
>>>  
>>> -	if (data->ops->set_trip_temp) {
>>> +	if (data->ops && data->ops->set_trip_temp) {
>>>  		int ret;
>>>  
>>>  		ret = data->ops->set_trip_temp(data->sensor_data, trip, temp);
>>>

