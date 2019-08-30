Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B07B6A3430
	for <lists+stable@lfdr.de>; Fri, 30 Aug 2019 11:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727434AbfH3Jkd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Aug 2019 05:40:33 -0400
Received: from foss.arm.com ([217.140.110.172]:57286 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726480AbfH3Jkd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Aug 2019 05:40:33 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 37BA3344;
        Fri, 30 Aug 2019 02:40:32 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D2DCD3F718;
        Fri, 30 Aug 2019 02:40:30 -0700 (PDT)
Date:   Fri, 30 Aug 2019 10:40:28 +0100
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
Subject: Re: [PATCH ARM64 v4.4 V3 05/44] arm64: Use pointer masking to limit
 uaccess speculation
Message-ID: <20190830094028.GE46475@lakrids.cambridge.arm.com>
References: <cover.1567077734.git.viresh.kumar@linaro.org>
 <f26c719baa5df560360fb3bbb7483385dd5cb821.1567077734.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f26c719baa5df560360fb3bbb7483385dd5cb821.1567077734.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 29, 2019 at 05:03:50PM +0530, Viresh Kumar wrote:
> From: Robin Murphy <robin.murphy@arm.com>
> 
> commit 4d8efc2d5ee4c9ccfeb29ee8afd47a8660d0c0ce upstream.
> 
> Similarly to x86, mitigate speculation past an access_ok() check by
> masking the pointer against the address limit before use.
> 
> Even if we don't expect speculative writes per se, it is plausible that
> a CPU may still speculate at least as far as fetching a cache line for
> writing, hence we also harden put_user() and clear_user() for peace of
> mind.
> 
> Signed-off-by: Robin Murphy <robin.murphy@arm.com>
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Reviewed-by: Mark Rutland <mark.rutland@arm.com> [v4.4 backport]

Mark.

> ---
>  arch/arm64/include/asm/uaccess.h | 26 +++++++++++++++++++++++---
>  1 file changed, 23 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/uaccess.h b/arch/arm64/include/asm/uaccess.h
> index c625cc5531fc..75363d723262 100644
> --- a/arch/arm64/include/asm/uaccess.h
> +++ b/arch/arm64/include/asm/uaccess.h
> @@ -121,6 +121,26 @@ static inline unsigned long __range_ok(unsigned long addr, unsigned long size)
>  #define access_ok(type, addr, size)	__range_ok((unsigned long)(addr), size)
>  #define user_addr_max			get_fs
>  
> +/*
> + * Sanitise a uaccess pointer such that it becomes NULL if above the
> + * current addr_limit.
> + */
> +#define uaccess_mask_ptr(ptr) (__typeof__(ptr))__uaccess_mask_ptr(ptr)
> +static inline void __user *__uaccess_mask_ptr(const void __user *ptr)
> +{
> +	void __user *safe_ptr;
> +
> +	asm volatile(
> +	"	bics	xzr, %1, %2\n"
> +	"	csel	%0, %1, xzr, eq\n"
> +	: "=&r" (safe_ptr)
> +	: "r" (ptr), "r" (current_thread_info()->addr_limit)
> +	: "cc");
> +
> +	csdb();
> +	return safe_ptr;
> +}
> +
>  /*
>   * The "__xxx" versions of the user access functions do not verify the address
>   * space - it must have been done previously with a separate "access_ok()"
> @@ -193,7 +213,7 @@ do {									\
>  	__typeof__(*(ptr)) __user *__p = (ptr);				\
>  	might_fault();							\
>  	access_ok(VERIFY_READ, __p, sizeof(*__p)) ?			\
> -		__get_user((x), __p) :					\
> +		__p = uaccess_mask_ptr(__p), __get_user((x), __p) :	\
>  		((x) = 0, -EFAULT);					\
>  })
>  
> @@ -259,7 +279,7 @@ do {									\
>  	__typeof__(*(ptr)) __user *__p = (ptr);				\
>  	might_fault();							\
>  	access_ok(VERIFY_WRITE, __p, sizeof(*__p)) ?			\
> -		__put_user((x), __p) :					\
> +		__p = uaccess_mask_ptr(__p), __put_user((x), __p) :	\
>  		-EFAULT;						\
>  })
>  
> @@ -297,7 +317,7 @@ static inline unsigned long __must_check copy_in_user(void __user *to, const voi
>  static inline unsigned long __must_check clear_user(void __user *to, unsigned long n)
>  {
>  	if (access_ok(VERIFY_WRITE, to, n))
> -		n = __clear_user(to, n);
> +		n = __clear_user(__uaccess_mask_ptr(to), n);
>  	return n;
>  }
>  
> -- 
> 2.21.0.rc0.269.g1a574e7a288b
> 
