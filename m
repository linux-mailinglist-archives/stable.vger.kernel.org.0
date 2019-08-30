Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 633EAA343B
	for <lists+stable@lfdr.de>; Fri, 30 Aug 2019 11:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727620AbfH3JlH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Aug 2019 05:41:07 -0400
Received: from foss.arm.com ([217.140.110.172]:57356 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726480AbfH3JlG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Aug 2019 05:41:06 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 39120344;
        Fri, 30 Aug 2019 02:41:06 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D989D3F718;
        Fri, 30 Aug 2019 02:41:04 -0700 (PDT)
Date:   Fri, 30 Aug 2019 10:41:02 +0100
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
Subject: Re: [PATCH ARM64 v4.4 V3 08/44] arm64: uaccess: Don't bother eliding
 access_ok checks in __{get, put}_user
Message-ID: <20190830094102.GH46475@lakrids.cambridge.arm.com>
References: <cover.1567077734.git.viresh.kumar@linaro.org>
 <40fe1d91c9cd8d78ae952b821185681621f92b10.1567077734.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40fe1d91c9cd8d78ae952b821185681621f92b10.1567077734.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 29, 2019 at 05:03:53PM +0530, Viresh Kumar wrote:
> From: Will Deacon <will.deacon@arm.com>
> 
> commit 84624087dd7e3b482b7b11c170ebc1f329b3a218 upstream.
> 
> access_ok isn't an expensive operation once the addr_limit for the current
> thread has been loaded into the cache. Given that the initial access_ok
> check preceding a sequence of __{get,put}_user operations will take
> the brunt of the miss, we can make the __* variants identical to the
> full-fat versions, which brings with it the benefits of address masking.
> 
> The likely cost in these sequences will be from toggling PAN/UAO, which
> we can address later by implementing the *_unsafe versions.
> 
> Reviewed-by: Robin Murphy <robin.murphy@arm.com>
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> [ v4.4: Fixed conflicts around {__get_user|__put_user}_unaligned macros ]
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---

Reviewed-by: Mark Rutland <mark.rutland@arm.com> [v4.4 backport]

Mark.

>  arch/arm64/include/asm/uaccess.h | 62 ++++++++++++++++++--------------
>  1 file changed, 36 insertions(+), 26 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/uaccess.h b/arch/arm64/include/asm/uaccess.h
> index fc11c50af558..a34324436ce1 100644
> --- a/arch/arm64/include/asm/uaccess.h
> +++ b/arch/arm64/include/asm/uaccess.h
> @@ -200,30 +200,35 @@ do {									\
>  			CONFIG_ARM64_PAN));				\
>  } while (0)
>  
> -#define __get_user(x, ptr)						\
> +#define __get_user_check(x, ptr, err)					\
>  ({									\
> -	int __gu_err = 0;						\
> -	__get_user_err((x), (ptr), __gu_err);				\
> -	__gu_err;							\
> +	__typeof__(*(ptr)) __user *__p = (ptr);				\
> +	might_fault();							\
> +	if (access_ok(VERIFY_READ, __p, sizeof(*__p))) {		\
> +		__p = uaccess_mask_ptr(__p);				\
> +		__get_user_err((x), __p, (err));			\
> +	} else {							\
> +		(x) = 0; (err) = -EFAULT;				\
> +	}								\
>  })
>  
>  #define __get_user_error(x, ptr, err)					\
>  ({									\
> -	__get_user_err((x), (ptr), (err));				\
> +	__get_user_check((x), (ptr), (err));				\
>  	(void)0;							\
>  })
>  
> -#define __get_user_unaligned __get_user
> -
> -#define get_user(x, ptr)						\
> +#define __get_user(x, ptr)						\
>  ({									\
> -	__typeof__(*(ptr)) __user *__p = (ptr);				\
> -	might_fault();							\
> -	access_ok(VERIFY_READ, __p, sizeof(*__p)) ?			\
> -		__p = uaccess_mask_ptr(__p), __get_user((x), __p) :	\
> -		((x) = 0, -EFAULT);					\
> +	int __gu_err = 0;						\
> +	__get_user_check((x), (ptr), __gu_err);				\
> +	__gu_err;							\
>  })
>  
> +#define __get_user_unaligned __get_user
> +
> +#define get_user	__get_user
> +
>  #define __put_user_asm(instr, reg, x, addr, err)			\
>  	asm volatile(							\
>  	"1:	" instr "	" reg "1, [%2]\n"			\
> @@ -266,30 +271,35 @@ do {									\
>  			CONFIG_ARM64_PAN));				\
>  } while (0)
>  
> -#define __put_user(x, ptr)						\
> +#define __put_user_check(x, ptr, err)					\
>  ({									\
> -	int __pu_err = 0;						\
> -	__put_user_err((x), (ptr), __pu_err);				\
> -	__pu_err;							\
> +	__typeof__(*(ptr)) __user *__p = (ptr);				\
> +	might_fault();							\
> +	if (access_ok(VERIFY_WRITE, __p, sizeof(*__p))) {		\
> +		__p = uaccess_mask_ptr(__p);				\
> +		__put_user_err((x), __p, (err));			\
> +	} else	{							\
> +		(err) = -EFAULT;					\
> +	}								\
>  })
>  
>  #define __put_user_error(x, ptr, err)					\
>  ({									\
> -	__put_user_err((x), (ptr), (err));				\
> +	__put_user_check((x), (ptr), (err));				\
>  	(void)0;							\
>  })
>  
> -#define __put_user_unaligned __put_user
> -
> -#define put_user(x, ptr)						\
> +#define __put_user(x, ptr)						\
>  ({									\
> -	__typeof__(*(ptr)) __user *__p = (ptr);				\
> -	might_fault();							\
> -	access_ok(VERIFY_WRITE, __p, sizeof(*__p)) ?			\
> -		__p = uaccess_mask_ptr(__p), __put_user((x), __p) :	\
> -		-EFAULT;						\
> +	int __pu_err = 0;						\
> +	__put_user_check((x), (ptr), __pu_err);				\
> +	__pu_err;							\
>  })
>  
> +#define __put_user_unaligned __put_user
> +
> +#define put_user	__put_user
> +
>  extern unsigned long __must_check __copy_from_user(void *to, const void __user *from, unsigned long n);
>  extern unsigned long __must_check __copy_to_user(void __user *to, const void *from, unsigned long n);
>  extern unsigned long __must_check __copy_in_user(void __user *to, const void __user *from, unsigned long n);
> -- 
> 2.21.0.rc0.269.g1a574e7a288b
> 
