Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0DC1A3428
	for <lists+stable@lfdr.de>; Fri, 30 Aug 2019 11:39:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727307AbfH3Jjw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Aug 2019 05:39:52 -0400
Received: from foss.arm.com ([217.140.110.172]:57218 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726480AbfH3Jjv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Aug 2019 05:39:51 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3D48F344;
        Fri, 30 Aug 2019 02:39:51 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DC1A33F718;
        Fri, 30 Aug 2019 02:39:49 -0700 (PDT)
Date:   Fri, 30 Aug 2019 10:39:44 +0100
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
Subject: Re: [PATCH ARM64 v4.4 V3 01/44] arm64: barrier: Add CSDB macros to
 control data-value prediction
Message-ID: <20190830093943.GA46475@lakrids.cambridge.arm.com>
References: <cover.1567077734.git.viresh.kumar@linaro.org>
 <4ba4e0d015f2e044e3eaf57e1239ae3e12d5a80e.1567077734.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ba4e0d015f2e044e3eaf57e1239ae3e12d5a80e.1567077734.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 29, 2019 at 05:03:46PM +0530, Viresh Kumar wrote:
> From: Will Deacon <will.deacon@arm.com>
> 
> commit 669474e772b952b14f4de4845a1558fd4c0414a4 upstream.
> 
> For CPUs capable of data value prediction, CSDB waits for any outstanding
> predictions to architecturally resolve before allowing speculative execution
> to continue. Provide macros to expose it to the arch code.
> 
> Reviewed-by: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Reviewed-by: Mark Rutland <mark.rutland@arm.com> [v4.4 backport]

Mark.

> ---
>  arch/arm64/include/asm/assembler.h | 7 +++++++
>  arch/arm64/include/asm/barrier.h   | 2 ++
>  2 files changed, 9 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
> index f68abb17aa4b..683c2875278f 100644
> --- a/arch/arm64/include/asm/assembler.h
> +++ b/arch/arm64/include/asm/assembler.h
> @@ -95,6 +95,13 @@
>  	dmb	\opt
>  	.endm
>  
> +/*
> + * Value prediction barrier
> + */
> +	.macro	csdb
> +	hint	#20
> +	.endm
> +
>  #define USER(l, x...)				\
>  9999:	x;					\
>  	.section __ex_table,"a";		\
> diff --git a/arch/arm64/include/asm/barrier.h b/arch/arm64/include/asm/barrier.h
> index f2d2c0bbe21b..574486634c62 100644
> --- a/arch/arm64/include/asm/barrier.h
> +++ b/arch/arm64/include/asm/barrier.h
> @@ -28,6 +28,8 @@
>  #define dmb(opt)	asm volatile("dmb " #opt : : : "memory")
>  #define dsb(opt)	asm volatile("dsb " #opt : : : "memory")
>  
> +#define csdb()		asm volatile("hint #20" : : : "memory")
> +
>  #define mb()		dsb(sy)
>  #define rmb()		dsb(ld)
>  #define wmb()		dsb(st)
> -- 
> 2.21.0.rc0.269.g1a574e7a288b
> 
