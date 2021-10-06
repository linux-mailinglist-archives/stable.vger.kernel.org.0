Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 743B9424202
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 18:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233070AbhJFQC3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 12:02:29 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3939 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbhJFQC3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Oct 2021 12:02:29 -0400
Received: from fraeml736-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4HPfHK39S1z67NPW;
        Wed,  6 Oct 2021 23:57:49 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml736-chm.china.huawei.com (10.206.15.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 6 Oct 2021 18:00:34 +0200
Received: from [10.47.95.252] (10.47.95.252) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2308.8; Wed, 6 Oct 2021
 17:00:33 +0100
Subject: Re: [PATCH] scsi: storvsc: Cap scsi_driver.can_queue to fix a hang
 issue during boot
To:     Michael Kelley <mikelley@microsoft.com>,
        Dexuan Cui <decui@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "ming.lei@redhat.com" <ming.lei@redhat.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <20211006070345.51713-1-decui@microsoft.com>
 <e36619df-652d-3550-cb4d-9b65b2f5faee@huawei.com>
 <MWHPR21MB159368D7BAAD90E19F31D1C6D7B09@MWHPR21MB1593.namprd21.prod.outlook.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <d9416464-cf0f-2275-2d16-94e81d5b4362@huawei.com>
Date:   Wed, 6 Oct 2021 17:03:09 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <MWHPR21MB159368D7BAAD90E19F31D1C6D7B09@MWHPR21MB1593.namprd21.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.95.252]
X-ClientProxiedBy: lhreml709-chm.china.huawei.com (10.201.108.58) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 06/10/2021 16:01, Michael Kelley wrote:
> From: John Garry <john.garry@huawei.com> Sent: Wednesday, October 6, 2021 1:17 AM
>>
>> On 06/10/2021 08:03, Dexuan Cui wrote:
>>> After commit ea2f0f77538c, a 416-CPU VM running on Hyper-V hangs during
>>> boot because scsi_add_host_with_dma() sets shost->cmd_per_lun to a
>>> negative number:
>>> 	'max_outstanding_req_per_channel' is 352,
>>> 	'max_sub_channels' is (416 - 1) / 4 = 103, so in storvsc_probe(),
>>> scsi_driver.can_queue = 352 * (103 + 1) * (100 - 10) / 100 = 32947, which
>>> is bigger than SHRT_MAX (i.e. 32767).
>>
>> Out of curiosity, are these values realistic? You're capping can_queue
>> just because of a data size issue, so, if these values are realistic,
>> seems a weak reason.
>>
> 
> The calculated value of can_queue is not realistic.  The blk-mq layer
> caps the number of tags at 10240, 

nit: 1024, I think

> so the excessively large value
> calculated here didn't definitively break anything, though it can be
> poor from a performance tuning standpoint. The algorithm used here
> is fairly broken, particularly in VMs with large CPU counts.  I have an
> effort underway to fix it, but its part of a bigger set of changes to also
> do a better job on the perf tuning aspects.
> 
>>>
>>> Fix the hang issue by capping scsi_driver.can_queue.
>>>
>>> Add the below Fixed tag though ea2f0f77538c itself is good.
>>>
>>> Fixes: ea2f0f77538c ("scsi: core: Cap scsi_host cmd_per_lun at can_queue")
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Dexuan Cui <decui@microsoft.com>
>>> ---
>>>    drivers/scsi/storvsc_drv.c | 10 ++++++++++
>>>    1 file changed, 10 insertions(+)
>>>
>>> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
>>> index ebbbc1299c62..ba374908aec2 100644
>>> --- a/drivers/scsi/storvsc_drv.c
>>> +++ b/drivers/scsi/storvsc_drv.c
>>> @@ -1976,6 +1976,16 @@ static int storvsc_probe(struct hv_device *device,
>>>    				(max_sub_channels + 1) *
>>>    				(100 - ring_avail_percent_lowater) / 100;
>>>
>>> +	/*
>>> +	 * v5.14 (see commit ea2f0f77538c) implicitly requires that
>>> +	 * scsi_driver.can_queue should not exceed SHRT_MAX, otherwise
>>> +	 * scsi_add_host_with_dma() sets shost->cmd_per_lun to a negative
>>> +	 * number (note: the type of the "cmd_per_lun" field is "short"), and
>>> +	 * the system may hang during early boot.
>>> +	 */
>>
>> The different data sizes for cmd_per_lun and can_queue are problematic here.
>>
>> I'd be more inclined to set cmd_per_lun to the same data size as
>> can_queue. We did discuss this when ea2f0f77538c was upstreamed
>> (actually it was the other way around - setting can_queue to 16b).
> 
> I can see that making can_queue be 16 bits would make sense.
> And it also seems that both cmd_per_lun and can_queue should be
> unsigned, though I don't the implications of making such a change.
> 
> But in today's world where cmd_per_lun is "short" and can_queue
> is "int",  ea2f0f77538c seems incorrect to me.  The comparison should
> be done as "int", not "short", in order to prevent the truncation
> problem with can_queue that Dexuan's patch is trying to address.

Yeah, right. I think can_queue values > short_max was considered outside 
the realms of what is realistic then, hence my sloppy programming.

> The result will always fit in back into the "short" cmd_per_lun since
> it is calculating a "min" function.
> 
>>
>> Thanks,
>> John
>>
>>
>>> +	if (scsi_driver.can_queue > SHRT_MAX)
>>> +		scsi_driver.can_queue = SHRT_MAX;
>>> +
> 
> This fix works, but is a more of a temporary hack until I can finish
> a larger overhaul of the algorithm. 


> But for now, I think the better
> fix is for ea2f0f77538c to do the comparison as "int" instead of "short".
> 

That seems better to me. But Let's wait for other possible opinion.

Thanks,
John
