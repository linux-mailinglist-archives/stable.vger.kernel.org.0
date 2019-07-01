Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBCE95B756
	for <lists+stable@lfdr.de>; Mon,  1 Jul 2019 10:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727905AbfGAI6d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jul 2019 04:58:33 -0400
Received: from foss.arm.com ([217.140.110.172]:57864 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728190AbfGAI6d (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jul 2019 04:58:33 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8CAB92B;
        Mon,  1 Jul 2019 01:58:32 -0700 (PDT)
Received: from [10.1.196.93] (en101.cambridge.arm.com [10.1.196.93])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 698153F718;
        Mon,  1 Jul 2019 01:58:31 -0700 (PDT)
Subject: Re: [PATCH v2 2/5] coresight: etm4x: use explicit barriers on
 enable/disable
To:     leo.yan@linaro.org, andrew.murray@arm.com
Cc:     mathieu.poirier@linaro.org, alexander.shishkin@linux.intel.com,
        coresight@lists.linaro.org, Sudeep.Holla@arm.com,
        stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        mike.leach@linaro.org
References: <20190627083525.37463-1-andrew.murray@arm.com>
 <20190627083525.37463-3-andrew.murray@arm.com>
 <20190628024529.GC20296@leoy-ThinkPad-X240s>
 <20190628083523.GG34530@e119886-lin.cambridge.arm.com>
 <20190628085154.GD32370@leoy-ThinkPad-X240s>
 <20190628090013.GI34530@e119886-lin.cambridge.arm.com>
 <20190628094116.GF32370@leoy-ThinkPad-X240s>
From:   Suzuki K Poulose <suzuki.poulose@arm.com>
Message-ID: <ff3c3659-930a-1572-588b-9cb040f38e4f@arm.com>
Date:   Mon, 1 Jul 2019 09:58:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190628094116.GF32370@leoy-ThinkPad-X240s>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Leo,

On 28/06/2019 10:41, Leo Yan wrote:
> Hi Andrew,
> 
> On Fri, Jun 28, 2019 at 10:00:14AM +0100, Andrew Murray wrote:
>> On Fri, Jun 28, 2019 at 04:51:54PM +0800, Leo Yan wrote:
>>> Hi Andrew,
>>>
>>> On Fri, Jun 28, 2019 at 09:35:24AM +0100, Andrew Murray wrote:
>>>
>>> [...]
>>>
>>>>>> @@ -454,7 +458,8 @@ static void etm4_disable_hw(void *info)
>>>>>>   	control &= ~0x1;
>>>>>>   
>>>>>>   	/* make sure everything completes before disabling */
>>>>>> -	mb();
>>>>>> +	/* As recommended by 7.3.77 of ARM IHI 0064D */
>>>>>> +	dsb(sy);
>>>>>
>>>>> Here the old code should be right, mb() is the same thing with
>>>>> dsb(sy).
>>>>>
>>>>> So we don't need to change at here?
>>>>
>>>> Correct - on arm64 there is no difference between mb and dsb(sy) so no
>>>> functional change on this hunk.
>>>>
>>>> In repsonse to Suzuki's feedback on this patch, I've updated the commit
>>>> message to describe why I've made this change, as follows:
>>>>       
>>>> "On armv8 the mb macro is defined as dsb(sy) - Given that the etm4x is
>>>> only used on armv8 let's directly use dsb(sy) instead of mb(). This
>>>> removes some ambiguity and makes it easier to correlate the code with
>>>> the TRM."
>>>>
>>>> Does that make sense?
>>>
>>> On reason for preferring to use mb() rather than dsb(sy) is for
>>> compatibility cross different architectures (armv7, armv8, and
>>> so on ...).  Seems to me mb() is a general API and transparent for
>>> architecture's difference.
>>>
>>> dsb(sy) is quite dependent on specific Arm architecture, e.g. some old
>>> Arm architecures might don't support dsb(sy); and we are not sure later
>>> it will change for new architectures.
>>
>> Yes but please note that the KConfig for this driver depends on ARM64.
> 
> Understood your point.
> 
> I am a bit suspect it's right thing to always set dependency on ARM64
> for ETMv4 driver.  The reason is Armv8 CPU can also run with aarch32
> mode in EL1.
> 
> If we let ETMv4 driver to support both aarch32 and aarch64, then we
> will see dsb(sy) might break building for some old Arm arches.

If we add support for ETMv4 on aarch32, I would recommend adding a "dsb"
explicitly for aarch32 to make sure, it doesn't default to something else
that the mb() may cover up as. There is no point in creating another level
of indirection when the architecture is clear about it and the ETMv4 supporting
architectures must implement "dsb". Had this been in a generic code, I would
be happy to retain mb(). But this is specific to the ETMv4 driver and we know
that dsb must be there.

Cheers
Suzuki
