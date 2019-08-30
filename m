Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89F3BA342A
	for <lists+stable@lfdr.de>; Fri, 30 Aug 2019 11:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727635AbfH3JkF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Aug 2019 05:40:05 -0400
Received: from foss.arm.com ([217.140.110.172]:57234 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726480AbfH3JkF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Aug 2019 05:40:05 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4F7D3344;
        Fri, 30 Aug 2019 02:40:04 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F048A3F718;
        Fri, 30 Aug 2019 02:40:02 -0700 (PDT)
Date:   Fri, 30 Aug 2019 10:40:00 +0100
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
Subject: Re: [PATCH ARM64 v4.4 V3 02/44] arm64: Implement
 array_index_mask_nospec()
Message-ID: <20190830094000.GB46475@lakrids.cambridge.arm.com>
References: <cover.1567077734.git.viresh.kumar@linaro.org>
 <a01785b993e2b39864ee0cab09695ae23a02b2f5.1567077734.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a01785b993e2b39864ee0cab09695ae23a02b2f5.1567077734.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 29, 2019 at 05:03:47PM +0530, Viresh Kumar wrote:
> From: Robin Murphy <robin.murphy@arm.com>
> 
> commit 022620eed3d0bc4bf2027326f599f5ad71c2ea3f upstream.
> 
> Provide an optimised, assembly implementation of array_index_mask_nospec()
> for arm64 so that the compiler is not in a position to transform the code
> in ways which affect its ability to inhibit speculation (e.g. by introducing
> conditional branches).
> 
> This is similar to the sequence used by x86, modulo architectural differences
> in the carry/borrow flags.
> 
> Reviewed-by: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Robin Murphy <robin.murphy@arm.com>
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Reviewed-by: Mark Rutland <mark.rutland@arm.com> [v4.4 backport]

Mark.

> ---
>  arch/arm64/include/asm/barrier.h | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/barrier.h b/arch/arm64/include/asm/barrier.h
> index 574486634c62..7c25e3e11b6d 100644
> --- a/arch/arm64/include/asm/barrier.h
> +++ b/arch/arm64/include/asm/barrier.h
> @@ -37,6 +37,27 @@
>  #define dma_rmb()	dmb(oshld)
>  #define dma_wmb()	dmb(oshst)
>  
> +/*
> + * Generate a mask for array_index__nospec() that is ~0UL when 0 <= idx < sz
> + * and 0 otherwise.
> + */
> +#define array_index_mask_nospec array_index_mask_nospec
> +static inline unsigned long array_index_mask_nospec(unsigned long idx,
> +						    unsigned long sz)
> +{
> +	unsigned long mask;
> +
> +	asm volatile(
> +	"	cmp	%1, %2\n"
> +	"	sbc	%0, xzr, xzr\n"
> +	: "=r" (mask)
> +	: "r" (idx), "Ir" (sz)
> +	: "cc");
> +
> +	csdb();
> +	return mask;
> +}
> +
>  #define smp_mb()	dmb(ish)
>  #define smp_rmb()	dmb(ishld)
>  #define smp_wmb()	dmb(ishst)
> -- 
> 2.21.0.rc0.269.g1a574e7a288b
> 
