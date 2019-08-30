Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1ED9A344B
	for <lists+stable@lfdr.de>; Fri, 30 Aug 2019 11:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727857AbfH3Jmy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Aug 2019 05:42:54 -0400
Received: from foss.arm.com ([217.140.110.172]:57504 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727521AbfH3Jmy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Aug 2019 05:42:54 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 761D0344;
        Fri, 30 Aug 2019 02:42:53 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 22A413F718;
        Fri, 30 Aug 2019 02:42:52 -0700 (PDT)
Date:   Fri, 30 Aug 2019 10:42:50 +0100
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
Subject: Re: [PATCH ARM64 v4.4 V3 44/44] arm64: futex: Mask __user pointers
 prior to dereference
Message-ID: <20190830094249.GL46475@lakrids.cambridge.arm.com>
References: <cover.1567077734.git.viresh.kumar@linaro.org>
 <965d727955b4a45ac1f12e67c6a433110ef94871.1567077734.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <965d727955b4a45ac1f12e67c6a433110ef94871.1567077734.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 29, 2019 at 05:04:29PM +0530, Viresh Kumar wrote:
> From: Will Deacon <will.deacon@arm.com>
> 
> commit 91b2d3442f6a44dce875670d702af22737ad5eff upstream.
> 
> The arm64 futex code has some explicit dereferencing of user pointers
> where performing atomic operations in response to a futex command. This
> patch uses masking to limit any speculative futex operations to within
> the user address space.
> 
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

This would have made more sense immediately following patch 11, as in
mainline and the v4.9 backport. Having things applied in the same order
makes it much easier to compare and verify.

Regardless:

Reviewed-by: Mark Rutland <mark.rutland@arm.com> [v4.4 backport]

Mark.

> ---
>  arch/arm64/include/asm/futex.h | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/futex.h b/arch/arm64/include/asm/futex.h
> index 34d4d2e2f561..8ab6e83cb629 100644
> --- a/arch/arm64/include/asm/futex.h
> +++ b/arch/arm64/include/asm/futex.h
> @@ -53,9 +53,10 @@
>  	: "memory")
>  
>  static inline int
> -arch_futex_atomic_op_inuser(int op, int oparg, int *oval, u32 __user *uaddr)
> +arch_futex_atomic_op_inuser(int op, int oparg, int *oval, u32 __user *_uaddr)
>  {
>  	int oldval = 0, ret, tmp;
> +	u32 __user *uaddr = __uaccess_mask_ptr(_uaddr);
>  
>  	pagefault_disable();
>  
> @@ -93,15 +94,17 @@ arch_futex_atomic_op_inuser(int op, int oparg, int *oval, u32 __user *uaddr)
>  }
>  
>  static inline int
> -futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
> +futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *_uaddr,
>  			      u32 oldval, u32 newval)
>  {
>  	int ret = 0;
>  	u32 val, tmp;
> +	u32 __user *uaddr;
>  
> -	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u32)))
> +	if (!access_ok(VERIFY_WRITE, _uaddr, sizeof(u32)))
>  		return -EFAULT;
>  
> +	uaddr = __uaccess_mask_ptr(_uaddr);
>  	asm volatile("// futex_atomic_cmpxchg_inatomic\n"
>  ALTERNATIVE("nop", SET_PSTATE_PAN(0), ARM64_HAS_PAN, CONFIG_ARM64_PAN)
>  "	prfm	pstl1strm, %2\n"
> -- 
> 2.21.0.rc0.269.g1a574e7a288b
> 
