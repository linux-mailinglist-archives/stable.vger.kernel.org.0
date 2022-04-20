Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4B15085F3
	for <lists+stable@lfdr.de>; Wed, 20 Apr 2022 12:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351637AbiDTKfM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Apr 2022 06:35:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348216AbiDTKfL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Apr 2022 06:35:11 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D51B93FBC4;
        Wed, 20 Apr 2022 03:32:25 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9E7F123A;
        Wed, 20 Apr 2022 03:32:25 -0700 (PDT)
Received: from [10.57.12.48] (unknown [10.57.12.48])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C71933F766;
        Wed, 20 Apr 2022 03:32:23 -0700 (PDT)
Message-ID: <281fd0f0-d2fc-95cf-d183-31ca8c25830e@arm.com>
Date:   Wed, 20 Apr 2022 11:32:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] thermal: devfreq_cooling: use local ops instead of global
 ops
Content-Language: en-US
To:     Kant Fan <kant@allwinnertech.com>
Cc:     amitk@kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        allwinner-opensource-support@allwinnertech.com,
        stable@vger.kernel.org, orjan.eide@arm.com, edubezval@gmail.com,
        javi.merino@kernel.org, daniel.lezcano@linaro.org,
        rui.zhang@intel.com
References: <20220325094436.101419-1-kant@allwinnertech.com>
 <4db6b25c-dd78-a6ba-02a5-ac2e49996be1@arm.com>
 <6b89fa96-07f0-19bb-2e18-22afa27554a1@allwinnertech.com>
From:   Lukasz Luba <lukasz.luba@arm.com>
In-Reply-To: <6b89fa96-07f0-19bb-2e18-22afa27554a1@allwinnertech.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-11.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Kant,

On 4/19/22 16:49, Kant Fan wrote:
> On 29/03/2022 14:59, Lukasz Luba wrote:
>>
>>
>> On 3/25/22 09:44, Kant Fan wrote:
>>> commit 7b62935828266658714f81d4e9176edad808dc70 upstream.
>>>
>>> Fix access illegal address problem in following condition:
>>> There are muti devfreq cooling devices in system, some of them register
>>> with dfc_power but other does not, power model ops such as 
>>> state2power will
>>> append to global devfreq_cooling_ops when the cooling device with
>>> dfc_power register. It makes the cooling device without dfc_power
>>> also use devfreq_cooling_ops after appending when register later by
>>> of_devfreq_cooling_register_power() or of_devfreq_cooling_register().
>>>
>>> IPA governor regards the cooling devices without dfc_power as a power 
>>> actor
>>> because they also have power model ops, and will access illegal 
>>> address at
>>> dfc->power_ops when execute cdev->ops->get_requested_power or
>>> cdev->ops->power2state. As the calltrace below shows:
>>>
>>> Unable to handle kernel NULL pointer dereference at virtual address
>>> 00000008
>>> ...
>>> calltrace:
>>> [<c06e5488>] devfreq_cooling_power2state+0x24/0x184
>>> [<c06df420>] power_actor_set_power+0x54/0xa8
>>> [<c06e3774>] power_allocator_throttle+0x770/0x97c
>>> [<c06dd120>] handle_thermal_trip+0x1b4/0x26c
>>> [<c06ddb48>] thermal_zone_device_update+0x154/0x208
>>> [<c014159c>] process_one_work+0x1ec/0x36c
>>> [<c0141c58>] worker_thread+0x204/0x2ec
>>> [<c0146788>] kthread+0x140/0x154
>>> [<c01010e8>] ret_from_fork+0x14/0x2c
>>>
>>> Fixes: a76caf55e5b35 ("thermal: Add devfreq cooling")
>>> Cc: stable@vger.kernel.org # 4.4+
>>> Signed-off-by: Kant Fan <kant@allwinnertech.com>
>>> ---
>>>   drivers/thermal/devfreq_cooling.c | 25 ++++++++++++++++++-------
>>>   1 file changed, 18 insertions(+), 7 deletions(-)
>>>
>>
>> Looks good. So this patch should be applied for all stable
>> kernels starting from v4.4 to v5.12 (the v5.13 and later need
>> other patch).
>>
>> Next time you might use in the subject something like:
>> [PATCH 4.4] thermal: devfreq_cooling: use local ops instead of global ops
>> It would be better distinguished from your other patch with the
>> same subject, which was for mainline and v5.13+
> 
> Hi Lukasz,
> Thank you for the guidance. I want to know if I'm understanding you in a 
> right way. Could you confirm the following information?
> 
> 1. The stable patches
> After the patch is merged into mainline later, I'll submit the following 
> patches individually for v4.4 ~ v5.12:

Correct, after it gets mainline you can point to that commit hash and
process with those patches. I don't now which of those older stable
kernels are still maintained, since some of them have longer support
and the rest had shorter and might already ended. You can check the
end of life for those 'Longterm' here [1]. AFAICS the 4.4 is not in that
table, so you can start from 4.9, should be OK.
So the list of needed patches would be for those stable kernels:
4.9, 4.14, 4.19, 5.4, 5.10
I can see that last release for 5.11.x was in May 2021, so it's probably
ended, similar for 5.12.x (Jul 2021). That's why I suggested that list
for the long support kernels.

> 
> [PATCH 4.4] thermal: devfreq_cooling: use local ops instead of global ops
> [PATCH 4.5] thermal: devfreq_cooling: use local ops instead of global ops
> ...
> [PATCH 5.12] thermal: devfreq_cooling: use local ops instead of global ops
> 
> And also the following patches individually for v5.13+ :

For this, you probably don't have to. You have added 'v5.13+' in the
original patch v2, so it will be picked correctly. It should apply
on those stable kernels w/o issues. If there will be, stable kernel
engineers will ping us.

> [PATCH 5.13] thermal: devfreq_cooling: use local ops instead of global ops
> [PATCH 5.14] thermal: devfreq_cooling: use local ops instead of global ops
> ...
> [PATCH 5.17] thermal: devfreq_cooling: use local ops instead of global ops
> 
> 2. The mainline patch
> I saw your mail with Rafael, seems there are conflicts... I wonder if 
> there's anything wrong with my patch, or anything I can help?
> 

Thank you for offering help. Rafael solved that correctly, so it doesn't
need any more work.

Thank you for doing that work!

Regards,
Lukasz

[1] https://www.kernel.org/category/releases.html
