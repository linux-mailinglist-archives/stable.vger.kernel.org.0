Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4409E402E64
	for <lists+stable@lfdr.de>; Tue,  7 Sep 2021 20:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345848AbhIGSeM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Sep 2021 14:34:12 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:36674 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345850AbhIGSeK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Sep 2021 14:34:10 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1631039584; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=8/bTsEPkNHH3mIi6qPwtnnCgaUulSNkP6mv7djVi7LQ=; b=FyaBGv72bWLVCScOJMyHul9GC6aMKd/BEFvog96Slm1KUKI7DKA19o9urwDRFMk4LNzJLBEU
 AknNN+0juNqkbIGuQ9mCrBgnr6JW3Z487i72z/fmy+1uVXOyN2HBsEi55HFdlZdYEaWWqX7y
 CGrCVEhT7RrK2fq6g0qqiRP+T0Y=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 6137b04db52e91333cccd857 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 07 Sep 2021 18:32:45
 GMT
Sender: quic_subbaram=quicinc.com@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 7F78CC4360D; Tue,  7 Sep 2021 18:32:45 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A,SPF_FAIL,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
        version=3.4.0
Received: from [10.47.233.232] (Global_NAT1.qualcomm.com [129.46.96.20])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: subbaram)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 409C4C4338F;
        Tue,  7 Sep 2021 18:32:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 409C4C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=fail (p=none dis=none) header.from=quicinc.com
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=quicinc.com
Subject: Re: [PATCH] thermal: Fix a NULL pointer dereference
To:     David Collins <quic_collinsd@quicinc.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amitk@kernel.org>
Cc:     linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <1630715659-5058-1-git-send-email-quic_subbaram@quicinc.com>
 <fe7ba5a5-d39a-dd0a-5cd3-f80ff163162a@quicinc.com>
From:   Subbaraman Narayanamurthy <quic_subbaram@quicinc.com>
Message-ID: <fa99e05e-43fd-a737-9fe2-753d9ae70530@quicinc.com>
Date:   Tue, 7 Sep 2021 11:32:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <fe7ba5a5-d39a-dd0a-5cd3-f80ff163162a@quicinc.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/3/21 6:07 PM, David Collins wrote:
> On 9/3/21 5:34 PM, Subbaraman Narayanamurthy wrote:
>> of_parse_thermal_zones() parses the thermal-zones node and registers a
>> thermal_zone device for each subnode. However, if a thermal zone is
>> consuming a thermal sensor and that thermal sensor device hasn't probed
>> yet, an attempt to set trip_point_*_temp for that thermal zone device
>> can cause a NULL pointer dereference. Fix it.
>>
>>   console:/sys/class/thermal/thermal_zone87 # echo 120000 > trip_point_0_temp
>>   ...
>>   Unable to handle kernel NULL pointer dereference at virtual address 0000000000000020
>>   ...
>>   Call trace:
>>    of_thermal_set_trip_temp+0x40/0xc4
>>    trip_point_temp_store+0xc0/0x1dc
>>    dev_attr_store+0x38/0x88
>>    sysfs_kf_write+0x64/0xc0
>>    kernfs_fop_write_iter+0x108/0x1d0
>>    vfs_write+0x2f4/0x368
>>    ksys_write+0x7c/0xec
>>    __arm64_sys_write+0x20/0x30
>>    el0_svc_common.llvm.7279915941325364641+0xbc/0x1bc
>>    do_el0_svc+0x28/0xa0
>>    el0_svc+0x14/0x24
>>    el0_sync_handler+0x88/0xec
>>    el0_sync+0x1c0/0x200
>>
>> Cc: stable@vger.kernel.org
>> Suggested-by: David Collins <quic_collinsd@quicinc.com>
>> Signed-off-by: Subbaraman Narayanamurthy <quic_subbaram@quicinc.com>
>> ---
>>   drivers/thermal/thermal_of.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/thermal/thermal_of.c b/drivers/thermal/thermal_of.c
>> index 6379f26..ba53252 100644
>> --- a/drivers/thermal/thermal_of.c
>> +++ b/drivers/thermal/thermal_of.c
>> @@ -301,7 +301,7 @@ static int of_thermal_set_trip_temp(struct thermal_zone_device *tz, int trip,
>>       if (trip >= data->ntrips || trip < 0)
>>           return -EDOM;
>>   -    if (data->ops->set_trip_temp) {
>> +    if (data->ops && data->ops->set_trip_temp) {
>>           int ret;
>>             ret = data->ops->set_trip_temp(data->sensor_data, trip, temp);
>>
>
> It looks like the same kind of data->ops null pointer dereference issue is present in three other functions within this file: of_thermal_get_temp(), of_thermal_set_emul_temp(), and of_thermal_get_trend().  Should those be fixed along with of_thermal_set_trip_temp() in a single patch?

Sure, I can make those changes in this patch itself.

>
> Thanks,
> David
