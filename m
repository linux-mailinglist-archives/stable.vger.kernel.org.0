Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FE0642333F
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 00:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236188AbhJEWLe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 18:11:34 -0400
Received: from alexa-out.qualcomm.com ([129.46.98.28]:46465 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230477AbhJEWLc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Oct 2021 18:11:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1633471781; x=1665007781;
  h=subject:from:to:cc:references:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=zBChwbKdDGyJZU9xC/GNu6BVvU1QLad7EtrmHk6KWEU=;
  b=LejXa83SGeKAcwD+SZMkPB2vaGRKpAVlTS5rCxXRWlTK+5L3HaNUSCcN
   kRq7o9DihdYmVFkntlKJ3qMyWcPMuL+weI1Pfct9AtK08CK9kqWsYb9nk
   2Qs0mi5mz3Pvo/4GtE6GK3zrewD74aHBHnkTVBB6RPJ+32+/3ih2COeFR
   0=;
Received: from ironmsg08-lv.qualcomm.com ([10.47.202.152])
  by alexa-out.qualcomm.com with ESMTP; 05 Oct 2021 15:09:41 -0700
X-QCInternal: smtphost
Received: from nalasex01a.na.qualcomm.com ([10.47.209.196])
  by ironmsg08-lv.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2021 15:09:40 -0700
Received: from [10.47.233.232] (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.922.7; Tue, 5 Oct 2021
 15:09:39 -0700
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
 <55999619-22c7-63fd-7006-f91f144e4a60@linaro.org>
 <7930989e-baf1-04f4-59ad-d65122149b9b@quicinc.com>
Message-ID: <f869ea55-f071-f971-282e-31878a0f0b68@quicinc.com>
Date:   Tue, 5 Oct 2021 15:09:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <7930989e-baf1-04f4-59ad-d65122149b9b@quicinc.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.49.16.6]
X-ClientProxiedBy: nalasex01b.na.qualcomm.com (10.47.209.197) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/17/21 1:06 PM, Subbaraman Narayanamurthy wrote:
> On 9/17/21 2:31 AM, Daniel Lezcano wrote:
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
>> comment (1)
>>
>> AFAICT, if data->ops != NULL then data->ops->get_temp is also != NULL
>> because of the code allocating/freeing the ops structure.
>>
>> The tests can be replaced by (!data->ops), no ?
> Thanks Daniel for reviewing the patch.
>
> I agree that even if a sensor module is unregistered, that would call
> "thermal_zone_of_sensor_unregister" which would eventually set NULL on
> get_temp() and get_trend() and "tzd->ops" as well.
>
> However, of_thermal_get_temp() is trying to call "data->ops->get_temp"
> which comes from a sensor driver when it registers. There is no
> guarantee that it would be non-NULL right?
>
> Thinking of which, I think having both checks would be valid.

Hi Daniel,
Do you still have any concerns with this change?

Thanks,
Subbaraman

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
>> comment (2)
>>
>> The test looks pointless here (I mean both of them).
>>
>> If of_thermal_set_emul_temp() is called it is because the callback was
>> set in thermal_zone_of_add_sensor().
>>
>> This one does:
>>
>> 	tz->ops = ops;
>>
>> and
>> 	if (ops->set_emul_temp)
>>                 tzd->ops->set_emul_temp = of_thermal_set_emul_temp;
>>
>> If I'm not wrong if we are called, then data->ops &&
>> data->ops->set_emul_temp is always true, right ?
>>
> I've not exercised this condition yet. However, the original problem
> we've observed was when thermal HAL was trying to set trip thresholds
> on a thermal zone device for which the sensor device is not probed yet.
> This had happened randomly because of vendor modules taking time to be
> loaded and probed. I don't know if there would be any userspace entity
> that can try to set emulated temperature for a thermal zone even before
> a sensor device is probed.
>
> Without a sensor driver probed, "tz->ops" would not have a valid pointer
> right? So, I think checking for "data->ops" should be good.
>
> Another possibility is, a sensor might not have "set_emul_temp" callback.
> So checking for "ops->set_emul_temp" should be still valid.
>
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
>> Same comment as (1)
> of_thermal_get_trend() is trying to call "data->ops->get_trend" which
> comes from a sensor driver when it registers. From what I can see,
> there are lot of drivers which don't pass "get_trend" in their ops.
> So there is no guarantee that it would be non-NULL right?
>
> Thinking of which, I think having both checks would be valid.
>
>>>  	return data->ops->get_trend(data->sensor_data, trip, trend);
>>> @@ -301,7 +304,7 @@ static int of_thermal_set_trip_temp(struct thermal_zone_device *tz, int trip,
>>>  	if (trip >= data->ntrips || trip < 0)
>>>  		return -EDOM;
>>>  
>>> -	if (data->ops->set_trip_temp) {
>>> +	if (data->ops && data->ops->set_trip_temp) {
>> Same comment as (2)
> Without a sensor driver probed, "tz->ops" would not have a valid pointer right?
> So, I think checking for "data->ops" should be good. Another possibility is, a
> sensor device might not have "set_trip_temp" callback but just "set_trips".
>
> So checking for "data->ops->set_trip_temp" might be still valid.
>
>>>  		int ret;
>>>  
>>>  		ret = data->ops->set_trip_temp(data->sensor_data, trip, temp);
>>>

