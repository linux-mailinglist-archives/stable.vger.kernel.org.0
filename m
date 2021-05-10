Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEF173792C6
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 17:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233616AbhEJPdD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 11:33:03 -0400
Received: from foss.arm.com ([217.140.110.172]:32776 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234452AbhEJPcy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 11:32:54 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DE7F91688;
        Mon, 10 May 2021 08:31:49 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.4.9])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B7D013F719;
        Mon, 10 May 2021 08:31:47 -0700 (PDT)
Date:   Mon, 10 May 2021 16:31:44 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     Peter Collingbourne <pcc@google.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Will Deacon <will@kernel.org>,
        Evgenii Stepanov <eugenis@google.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] arm64: mte: initialize RGSR_EL1.SEED in __cpu_setup
Message-ID: <20210510153144.GC92897@C02TD0UTHF1T.local>
References: <20210507185905.1745402-1-pcc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210507185905.1745402-1-pcc@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 07, 2021 at 11:59:05AM -0700, Peter Collingbourne wrote:
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
> Fixes: 3b714d24ef17 ("arm64: mte: CPU feature detection and initial sysreg configuration")
> Cc: <stable@vger.kernel.org> # 5.10
> Link: https://linux-review.googlesource.com/id/I2b089b6c7d6f17ee37e2f0db7df5ad5bcc04526c

FWIW:

Acked-by: Mark Rutland <mark.rutland@arm.com>

Mark.

> ---
>  arch/arm64/mm/proc.S | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
> index 0a48191534ff..97d7bcd8d4f2 100644
> --- a/arch/arm64/mm/proc.S
> +++ b/arch/arm64/mm/proc.S
> @@ -447,6 +447,18 @@ SYM_FUNC_START(__cpu_setup)
>  	mov	x10, #(SYS_GCR_EL1_RRND | SYS_GCR_EL1_EXCL_MASK)
>  	msr_s	SYS_GCR_EL1, x10
>  
> +	/*
> +	 * If GCR_EL1.RRND=1 is implemented the same way as RRND=0, then
> +	 * RGSR_EL1.SEED must be non-zero for IRG to produce
> +	 * pseudorandom numbers. As RGSR_EL1 is UNKNOWN out of reset, we
> +	 * must initialize it.
> +	 */
> +	mrs	x10, CNTVCT_EL0
> +	ands	x10, x10, #SYS_RGSR_EL1_SEED_MASK
> +	csinc	x10, x10, xzr, ne
> +	lsl	x10, x10, #SYS_RGSR_EL1_SEED_SHIFT
> +	msr_s	SYS_RGSR_EL1, x10
> +
>  	/* clear any pending tag check faults in TFSR*_EL1 */
>  	msr_s	SYS_TFSR_EL1, xzr
>  	msr_s	SYS_TFSRE0_EL1, xzr
> -- 
> 2.31.1.607.g51e8a6a459-goog
> 
