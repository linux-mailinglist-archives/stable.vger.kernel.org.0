Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A9677D583
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 08:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729687AbfHAGa0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 02:30:26 -0400
Received: from foss.arm.com ([217.140.110.172]:58882 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726783AbfHAGa0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 1 Aug 2019 02:30:26 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A7C6C337;
        Wed, 31 Jul 2019 23:30:25 -0700 (PDT)
Received: from [10.1.197.45] (e112298-lin.cambridge.arm.com [10.1.197.45])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9CBC13F694;
        Wed, 31 Jul 2019 23:32:31 -0700 (PDT)
Subject: Re: [PATCH v4.4 V2 25/43] arm64: Move BP hardening to
 check_and_switch_context
To:     Viresh Kumar <viresh.kumar@linaro.org>
Cc:     stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com, julien.thierry.kdev@gmail.com
References: <cover.1562908074.git.viresh.kumar@linaro.org>
 <f655aaa158af070d45a2bd4965852b0c97a08838.1562908075.git.viresh.kumar@linaro.org>
 <59b252cf-9cb7-128b-4887-c21a8b9b92a9@arm.com>
 <20190801050940.h65crfawrdifsrgg@vireshk-i7>
From:   Julien Thierry <julien.thierry@arm.com>
Message-ID: <86354576-fc54-a8b7-4dc9-bc613d59fb17@arm.com>
Date:   Thu, 1 Aug 2019 07:30:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190801050940.h65crfawrdifsrgg@vireshk-i7>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 01/08/2019 06:09, Viresh Kumar wrote:
> On 31-07-19, 14:09, Julien Thierry wrote:
>>
>>
>> On 12/07/2019 06:28, Viresh Kumar wrote:
>>> From: Marc Zyngier <marc.zyngier@arm.com>
>>>
>>> commit a8e4c0a919ae310944ed2c9ace11cf3ccd8a609b upstream.
>>>
>>> We call arm64_apply_bp_hardening() from post_ttbr_update_workaround,
>>> which has the unexpected consequence of being triggered on every
>>> exception return to userspace when ARM64_SW_TTBR0_PAN is selected,
>>> even if no context switch actually occured.
>>>
>>> This is a bit suboptimal, and it would be more logical to only
>>> invalidate the branch predictor when we actually switch to
>>> a different mm.
>>>
>>> In order to solve this, move the call to arm64_apply_bp_hardening()
>>> into check_and_switch_context(), where we're guaranteed to pick
>>> a different mm context.
>>>
>>> Acked-by: Will Deacon <will.deacon@arm.com>
>>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>>> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
>>> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
>>> ---
>>>  arch/arm64/mm/context.c | 4 ++--
>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/arch/arm64/mm/context.c b/arch/arm64/mm/context.c
>>> index be42bd3dca5c..de5afc27b4e6 100644
>>> --- a/arch/arm64/mm/context.c
>>> +++ b/arch/arm64/mm/context.c
>>> @@ -183,6 +183,8 @@ void check_and_switch_context(struct mm_struct *mm, unsigned int cpu)
>>>  	raw_spin_unlock_irqrestore(&cpu_asid_lock, flags);
>>>  
>>>  switch_mm_fastpath:
>>> +	arm64_apply_bp_hardening();
>>> +
>>>  	cpu_switch_mm(mm->pgd, mm);
>>>  }
>>>  
>>> @@ -193,8 +195,6 @@ asmlinkage void post_ttbr_update_workaround(void)
>>>  			"ic iallu; dsb nsh; isb",
>>>  			ARM64_WORKAROUND_CAVIUM_27456,
>>>  			CONFIG_CAVIUM_ERRATUM_27456));
>>> -
>>> -	arm64_apply_bp_hardening();
>>
>> Patches 22 and 23 factorize the post_ttbr_update_workaround() and move
>> it to C code just so we would and a call to arm64_apply_bp_hardening()
>> in patch 24 that now gets moved elsewhere?
>>
>> Is it really worth backporting patches 22 and 23?
> 
> If I can merge patch 24 and 25 into a single patch while backporting,
> then patch 22 and 23 won't be required. I am not sure how should the
> commit log look like in that case though :)
> 
> Is mentioning both the upstream commit ids along with log of the first
> patch (which was more important) enough, like this ?
> 

I must admit I am not familiar with backport/stable process enough. But
personally I think the your suggestion seems more sensible than
backporting 4 patches.

Or you can maybe ignore patch 25 and say in patch 24 that among the
changes made for the 4.4 codebase, the call arm64_apply_bp_hardening()
was moved from post_ttbr_update_workaround as it doesn't exist and
placed in check_and_switch_context() as it is its final destination.

However, I really don't know what's the best way to proceed according to
existing practices. So input from someone else would be welcome.

Thanks,

Julien

> Author: Will Deacon <will.deacon@arm.com>
> Date:   Wed Jan 3 11:17:58 2018 +0000
> 
>     arm64: Add skeleton to harden the branch predictor against aliasing attacks
>     
>     commit 0f15adbb2861ce6f75ccfc5a92b19eae0ef327d0 upstream.
>     commit a8e4c0a919ae310944ed2c9ace11cf3ccd8a609b upstream.
>     
>     Aliasing attacks against CPU branch predictors can allow an attacker to
>     redirect speculative control flow on some CPUs and potentially divulge
>     information from one context to another.
>     
>     This patch adds initial skeleton code behind a new Kconfig option to
>     enable implementation-specific mitigations against these attacks for
>     CPUs that are affected.
>     
>     Co-developed-by: Marc Zyngier <marc.zyngier@arm.com>
>     Signed-off-by: Will Deacon <will.deacon@arm.com>
>     Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
>     [ v4.4: Changes made according to 4.4 codebase ]
>     Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> 

-- 
Julien Thierry
