Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C000436A89
	for <lists+stable@lfdr.de>; Thu, 21 Oct 2021 20:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbhJUSbi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Oct 2021 14:31:38 -0400
Received: from alexa-out.qualcomm.com ([129.46.98.28]:65451 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbhJUSbh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Oct 2021 14:31:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1634840962; x=1666376962;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=SQAoZ11ZnWSeNhTwVlHh0SqRjU4gwrk7g08gzFYTsdA=;
  b=VKVDcVIHwc7DFzb1dxZef/E6A67Jk1WxXRs5imNwsULNQVPB5dzeIIZb
   bFmrJ0FD4RiPrXHSrU0oJWFbkNMSy5buVoiIziqBmGwnnj0VjRWSSi+Bl
   NFQwm2W6M+/bHVBf0Gh18ey7RKRr5YeUIh3dlbwoL0W3RfOzz4CvFiPHv
   Y=;
Received: from ironmsg08-lv.qualcomm.com ([10.47.202.152])
  by alexa-out.qualcomm.com with ESMTP; 21 Oct 2021 11:29:21 -0700
X-QCInternal: smtphost
Received: from nalasex01a.na.qualcomm.com ([10.47.209.196])
  by ironmsg08-lv.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2021 11:29:20 -0700
Received: from [10.47.233.232] (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.922.7; Thu, 21 Oct 2021
 11:29:20 -0700
Subject: Re: [PATCH v2] thermal: Fix a NULL pointer dereference
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
 <8cda69a6-907b-e09e-ba64-011b0216a4df@quicinc.com>
 <dbf9a03f-6c66-dcfe-6158-d93532272a5c@linaro.org>
From:   Subbaraman Narayanamurthy <quic_subbaram@quicinc.com>
Message-ID: <1e0371e7-5c15-a552-870a-a501ec11a8f9@quicinc.com>
Date:   Thu, 21 Oct 2021 11:29:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <dbf9a03f-6c66-dcfe-6158-d93532272a5c@linaro.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.49.16.6]
X-ClientProxiedBy: nalasex01b.na.qualcomm.com (10.47.209.197) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/19/21 12:35 AM, Daniel Lezcano wrote:
> On 19/10/2021 03:21, Subbaraman Narayanamurthy wrote:
>> On 10/8/21 12:50 PM, Subbaraman Narayanamurthy wrote:
>>> On 10/6/21 4:08 AM, Daniel Lezcano wrote:
> [ ... ]
>
>>> /sys/devices/virtual/thermal/thermal_zone87 # echo 120000 > trip_point_0_temp  
>>> [  184.290964][  T211] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000020
>>> [  184.300896][  T211] Mem abort info:                                         
>>> [  184.304486][  T211]   ESR = 0x96000006                                      
>>> [  184.308348][  T211]   EC = 0x25: DABT (current EL), IL = 32 bits            
>>> [  184.314531][  T211]   SET = 0, FnV = 0                                      
>>> [  184.318384][  T211]   EA = 0, S1PTW = 0                                     
>>> [  184.322323][  T211] Data abort info:                                        
>>> [  184.325993][  T211]   ISV = 0, ISS = 0x00000006                             
>>> [  184.330655][  T211]   CM = 0, WnR = 0                                       
>>> [  184.334425][  T211] user pgtable: 4k pages, 39-bit VAs, pgdp=000000081a7a2000
>>> [  184.341750][  T211] [0000000000000020] pgd=000000081a7a7003, p4d=000000081a7a7003, pud=000000081a7a7003, pmd=0000000000000000
>>> [  184.353359][  T211] Internal error: Oops: 96000006 [#1] PREEMPT SMP         
>>> [  184.359797][  T211] Dumping ftrace buffer:                                  
>>> [  184.364001][  T211]    (ftrace buffer empty)
>>>
>>> Hope this helps.
>> Hi Daniel,
>> Have you got a chance to look at this?
> Hi Subbaraman,
>
> Actually, I think the root problem is the thermal zone is showing up
> while there is no sensor associated with it. You can read the
> temperature and get a kernel warning also.
>
> That's what should be fixed IMO.
>

Hi Daniel,

If I understand your statement correctly, are you saying that a thermal_zone device should be created only after a thermal sensor driver supplying it probes?

From what I can see,

thermal_init()
    --> of_parse_thermal_zones()
            --> thermal_zone_device_register()
                    --> thermal_zone_create_device_groups()
                            <followed by>
                        device_register() with thermal_zone%d


This happens way before a thermal sensor driver probes. So, creating a thermal_zone device only after its thermal sensor probes would require more changes to the framework.

Also, I see a similar NULL check exists in the framework code already.

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/thermal/thermal_of.c?h=v5.15-rc6#n103

So, extending the logic for other callsites (below) makes sense to me.

- of_thermal_get_temp()
- of_thermal_set_emul_temp()
- of_thermal_get_trend()
- of_thermal_set_trip_temp()

Thanks,
Subbaraman


