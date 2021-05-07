Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E894376355
	for <lists+stable@lfdr.de>; Fri,  7 May 2021 12:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235850AbhEGKMV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 May 2021 06:12:21 -0400
Received: from foss.arm.com ([217.140.110.172]:53730 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235840AbhEGKMU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 May 2021 06:12:20 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E1341106F;
        Fri,  7 May 2021 03:11:19 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.29.54])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5EA963F718;
        Fri,  7 May 2021 03:11:18 -0700 (PDT)
Date:   Fri, 7 May 2021 11:11:15 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     Peter Collingbourne <pcc@google.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Will Deacon <will@kernel.org>,
        Evgenii Stepanov <eugenis@google.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH] arm64: mte: initialize RGSR_EL1.SEED in __cpu_setup
Message-ID: <20210507101115.GB52849@C02TD0UTHF1T.local>
References: <20210507033725.1479129-1-pcc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210507033725.1479129-1-pcc@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Peter,

On Thu, May 06, 2021 at 08:37:25PM -0700, Peter Collingbourne wrote:
> A valid implementation choice for the ChooseRandomNonExcludedTag()
> pseudocode function used by IRG is to behave in the same way as with
> GCR_EL1.RRND=0. This would mean that RGSR_EL1.SEED is used as an LFSR
> which must have a non-zero value in order for IRG to properly produce
> pseudorandom numbers. However, RGSR_EL1 is reset to an UNKNOWN value
> on soft reset and thus may reset to 0. Therefore we must initialize
> RGSR_EL1.SEED to a non-zero value in order to ensure that IRG behaves
> as expected.
> 
> Signed-off-by: Peter Collingbourne <pcc@google.com>
> Cc: stable@vger.kernel.org
> Link: https://linux-review.googlesource.com/id/I2b089b6c7d6f17ee37e2f0db7df5ad5bcc04526c
> ---
>  arch/arm64/mm/proc.S | 17 +++++++++++++++--
>  1 file changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
> index 0a48191534ff..e8e1eaee4b3f 100644
> --- a/arch/arm64/mm/proc.S
> +++ b/arch/arm64/mm/proc.S
> @@ -437,7 +437,7 @@ SYM_FUNC_START(__cpu_setup)
>  	mrs	x10, ID_AA64PFR1_EL1
>  	ubfx	x10, x10, #ID_AA64PFR1_MTE_SHIFT, #4
>  	cmp	x10, #ID_AA64PFR1_MTE
> -	b.lt	1f
> +	b.lt	2f
>  
>  	/* Normal Tagged memory type at the corresponding MAIR index */
>  	mov	x10, #MAIR_ATTR_NORMAL_TAGGED
> @@ -447,6 +447,19 @@ SYM_FUNC_START(__cpu_setup)
>  	mov	x10, #(SYS_GCR_EL1_RRND | SYS_GCR_EL1_EXCL_MASK)
>  	msr_s	SYS_GCR_EL1, x10
>  
> +	/*
> +	 * Initialize RGSR_EL1.SEED to a non-zero value. If the implementation
> +	 * chooses to implement GCR_EL1.RRND=1 in the same way as RRND=0 then
> +	 * the seed will be used as an LFSR, so it should be put onto the MLS.
> +	 */

For those of us not familiar with LFSRs, could we crib a bit from the
commit message to describe why, e.g.

	/*
	 * If GCR_EL1.RRND=1 is implemented the same way as RRND=0, then
	 * RGSR_EL1.SEED must be non-zero for IRG to produce
	 * pseudorandom numbers. As RGSR_EL1 is UNKNOWN out of reset, we
	 * must initialize it.
	 */

> +	mrs	x10, CNTVCT_EL0
> +	and	x10, x10, #SYS_RGSR_EL1_SEED_MASK
> +	cbnz	x10, 1f
> +	mov	x10, #1
> +1:

To minimize the diff and make this more locally contained, we could
avoid the branch and relabelling by using ANDS and CSET:
	
	mrs     x10, CNTVCT_EL0
	ands	x10, x10, #SYS_RGSR_EL1_SEED_MASK
	cset	x10, ne

... or we could unconditionally ORR in 1:

	mrs	x10, CNTVCT_EL0
	orr	x10, x10, #1
	and	x10, x10, #SYS_RGSR_EL1_SEED_MASK

Thanks,
Mark.

> +	lsl	x10, x10, #SYS_RGSR_EL1_SEED_SHIFT
> +	msr_s	SYS_RGSR_EL1, x10
> +
>  	/* clear any pending tag check faults in TFSR*_EL1 */
>  	msr_s	SYS_TFSR_EL1, xzr
>  	msr_s	SYS_TFSRE0_EL1, xzr
> @@ -454,7 +467,7 @@ SYM_FUNC_START(__cpu_setup)
>  	/* set the TCR_EL1 bits */
>  	mov_q	x10, TCR_KASAN_HW_FLAGS
>  	orr	tcr, tcr, x10
> -1:
> +2:
>  #endif
>  	tcr_clear_errata_bits tcr, x9, x5
>  
> -- 
> 2.31.1.607.g51e8a6a459-goog
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
