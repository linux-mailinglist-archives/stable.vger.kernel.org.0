Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81E177C2E9
	for <lists+stable@lfdr.de>; Wed, 31 Jul 2019 15:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388334AbfGaNJJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 09:09:09 -0400
Received: from foss.arm.com ([217.140.110.172]:46898 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388329AbfGaNJJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 31 Jul 2019 09:09:09 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CC7FB1570;
        Wed, 31 Jul 2019 06:09:08 -0700 (PDT)
Received: from [10.1.197.45] (e112298-lin.cambridge.arm.com [10.1.197.45])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 750113F575;
        Wed, 31 Jul 2019 06:09:07 -0700 (PDT)
Subject: Re: [PATCH v4.4 V2 25/43] arm64: Move BP hardening to
 check_and_switch_context
To:     Viresh Kumar <viresh.kumar@linaro.org>, stable@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com, julien.thierry.kdev@gmail.com
References: <cover.1562908074.git.viresh.kumar@linaro.org>
 <f655aaa158af070d45a2bd4965852b0c97a08838.1562908075.git.viresh.kumar@linaro.org>
From:   Julien Thierry <julien.thierry@arm.com>
Message-ID: <59b252cf-9cb7-128b-4887-c21a8b9b92a9@arm.com>
Date:   Wed, 31 Jul 2019 14:09:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <f655aaa158af070d45a2bd4965852b0c97a08838.1562908075.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 12/07/2019 06:28, Viresh Kumar wrote:
> From: Marc Zyngier <marc.zyngier@arm.com>
> 
> commit a8e4c0a919ae310944ed2c9ace11cf3ccd8a609b upstream.
> 
> We call arm64_apply_bp_hardening() from post_ttbr_update_workaround,
> which has the unexpected consequence of being triggered on every
> exception return to userspace when ARM64_SW_TTBR0_PAN is selected,
> even if no context switch actually occured.
> 
> This is a bit suboptimal, and it would be more logical to only
> invalidate the branch predictor when we actually switch to
> a different mm.
> 
> In order to solve this, move the call to arm64_apply_bp_hardening()
> into check_and_switch_context(), where we're guaranteed to pick
> a different mm context.
> 
> Acked-by: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  arch/arm64/mm/context.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/mm/context.c b/arch/arm64/mm/context.c
> index be42bd3dca5c..de5afc27b4e6 100644
> --- a/arch/arm64/mm/context.c
> +++ b/arch/arm64/mm/context.c
> @@ -183,6 +183,8 @@ void check_and_switch_context(struct mm_struct *mm, unsigned int cpu)
>  	raw_spin_unlock_irqrestore(&cpu_asid_lock, flags);
>  
>  switch_mm_fastpath:
> +	arm64_apply_bp_hardening();
> +
>  	cpu_switch_mm(mm->pgd, mm);
>  }
>  
> @@ -193,8 +195,6 @@ asmlinkage void post_ttbr_update_workaround(void)
>  			"ic iallu; dsb nsh; isb",
>  			ARM64_WORKAROUND_CAVIUM_27456,
>  			CONFIG_CAVIUM_ERRATUM_27456));
> -
> -	arm64_apply_bp_hardening();

Patches 22 and 23 factorize the post_ttbr_update_workaround() and move
it to C code just so we would and a call to arm64_apply_bp_hardening()
in patch 24 that now gets moved elsewhere?

Is it really worth backporting patches 22 and 23?

Cheers,

-- 
Julien Thierry
