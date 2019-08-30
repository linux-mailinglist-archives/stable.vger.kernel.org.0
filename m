Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF8E6A3435
	for <lists+stable@lfdr.de>; Fri, 30 Aug 2019 11:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727522AbfH3Jkl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Aug 2019 05:40:41 -0400
Received: from foss.arm.com ([217.140.110.172]:57306 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726480AbfH3Jkl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Aug 2019 05:40:41 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B037E344;
        Fri, 30 Aug 2019 02:40:40 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5A7FA3F718;
        Fri, 30 Aug 2019 02:40:39 -0700 (PDT)
Date:   Fri, 30 Aug 2019 10:40:37 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     Viresh Kumar <viresh.kumar@linaro.org>
Cc:     stable@vger.kernel.org, Julien Thierry <Julien.Thierry@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com
Subject: Re: [PATCH ARM64 v4.4 V3 06/44] arm64: entry: Ensure branch through
 syscall table is bounded under speculation
Message-ID: <20190830094036.GF46475@lakrids.cambridge.arm.com>
References: <cover.1567077734.git.viresh.kumar@linaro.org>
 <093a9777605bdd2ab2c33948a4e7a3fbb275de4d.1567077734.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <093a9777605bdd2ab2c33948a4e7a3fbb275de4d.1567077734.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 29, 2019 at 05:03:51PM +0530, Viresh Kumar wrote:
> From: Will Deacon <will.deacon@arm.com>
> 
> commit 6314d90e64936c584f300a52ef173603fb2461b5 upstream.
> 
> In a similar manner to array_index_mask_nospec, this patch introduces an
> assembly macro (mask_nospec64) which can be used to bound a value under
> speculation. This macro is then used to ensure that the indirect branch
> through the syscall table is bounded under speculation, with out-of-range
> addresses speculating as calls to sys_io_setup (0).
> 
> Reviewed-by: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> [ v4.4: use existing scno & sc_nr definitions ]
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Reviewed-by: Mark Rutland <mark.rutland@arm.com> [v4.4 backport]

Mark.

> ---
>  arch/arm64/include/asm/assembler.h | 11 +++++++++++
>  arch/arm64/kernel/entry.S          |  1 +
>  2 files changed, 12 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
> index 683c2875278f..2b30363a3a89 100644
> --- a/arch/arm64/include/asm/assembler.h
> +++ b/arch/arm64/include/asm/assembler.h
> @@ -102,6 +102,17 @@
>  	hint	#20
>  	.endm
>  
> +/*
> + * Sanitise a 64-bit bounded index wrt speculation, returning zero if out
> + * of bounds.
> + */
> +	.macro	mask_nospec64, idx, limit, tmp
> +	sub	\tmp, \idx, \limit
> +	bic	\tmp, \tmp, \idx
> +	and	\idx, \idx, \tmp, asr #63
> +	csdb
> +	.endm
> +
>  #define USER(l, x...)				\
>  9999:	x;					\
>  	.section __ex_table,"a";		\
> diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
> index 4c5013b09dcb..e6aec982dea9 100644
> --- a/arch/arm64/kernel/entry.S
> +++ b/arch/arm64/kernel/entry.S
> @@ -697,6 +697,7 @@ el0_svc_naked:					// compat entry point
>  	b.ne	__sys_trace
>  	cmp     scno, sc_nr                     // check upper syscall limit
>  	b.hs	ni_sys
> +	mask_nospec64 scno, sc_nr, x19	// enforce bounds for syscall number
>  	ldr	x16, [stbl, scno, lsl #3]	// address in the syscall table
>  	blr	x16				// call sys_* routine
>  	b	ret_fast_syscall
> -- 
> 2.21.0.rc0.269.g1a574e7a288b
> 
