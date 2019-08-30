Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96C56A343F
	for <lists+stable@lfdr.de>; Fri, 30 Aug 2019 11:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727800AbfH3JlX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Aug 2019 05:41:23 -0400
Received: from foss.arm.com ([217.140.110.172]:57386 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727417AbfH3JlX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Aug 2019 05:41:23 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 442E8344;
        Fri, 30 Aug 2019 02:41:22 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E52933F718;
        Fri, 30 Aug 2019 02:41:20 -0700 (PDT)
Date:   Fri, 30 Aug 2019 10:41:18 +0100
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
Subject: Re: [PATCH ARM64 v4.4 V3 10/44] arm64: kasan: instrument user memory
 access API
Message-ID: <20190830094118.GJ46475@lakrids.cambridge.arm.com>
References: <cover.1567077734.git.viresh.kumar@linaro.org>
 <0e906aabc5057c5e23f1092747eaa842d20dd8b3.1567077734.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0e906aabc5057c5e23f1092747eaa842d20dd8b3.1567077734.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 29, 2019 at 05:03:55PM +0530, Viresh Kumar wrote:
> From: Yang Shi <yang.shi@linaro.org>
> 
> commit bffe1baff5d57521b0c41b6997c41ff1993e9818 upstream.
> 
> The upstream commit 1771c6e1a567ea0ba2cccc0a4ffe68a1419fd8ef
> ("x86/kasan: instrument user memory access API") added KASAN instrument to
> x86 user memory access API, so added such instrument to ARM64 too.
> 
> Define __copy_to/from_user in C in order to add kasan_check_read/write call,
> rename assembly implementation to __arch_copy_to/from_user.
> 
> Tested by test_kasan module.
> 
> Acked-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
> Reviewed-by: Mark Rutland <mark.rutland@arm.com>
> Tested-by: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Yang Shi <yang.shi@linaro.org>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Reviewed-by: Mark Rutland <mark.rutland@arm.com> [v4.4 backport]

Mark.

> ---
>  arch/arm64/include/asm/uaccess.h | 25 +++++++++++++++++++++----
>  arch/arm64/kernel/arm64ksyms.c   |  4 ++--
>  arch/arm64/lib/copy_from_user.S  |  4 ++--
>  arch/arm64/lib/copy_to_user.S    |  4 ++--
>  4 files changed, 27 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/uaccess.h b/arch/arm64/include/asm/uaccess.h
> index a34324436ce1..693a0d784534 100644
> --- a/arch/arm64/include/asm/uaccess.h
> +++ b/arch/arm64/include/asm/uaccess.h
> @@ -22,6 +22,7 @@
>   * User space memory access functions
>   */
>  #include <linux/bitops.h>
> +#include <linux/kasan-checks.h>
>  #include <linux/string.h>
>  #include <linux/thread_info.h>
>  
> @@ -300,15 +301,29 @@ do {									\
>  
>  #define put_user	__put_user
>  
> -extern unsigned long __must_check __copy_from_user(void *to, const void __user *from, unsigned long n);
> -extern unsigned long __must_check __copy_to_user(void __user *to, const void *from, unsigned long n);
> +extern unsigned long __must_check __arch_copy_from_user(void *to, const void __user *from, unsigned long n);
> +extern unsigned long __must_check __arch_copy_to_user(void __user *to, const void *from, unsigned long n);
>  extern unsigned long __must_check __copy_in_user(void __user *to, const void __user *from, unsigned long n);
>  extern unsigned long __must_check __clear_user(void __user *addr, unsigned long n);
>  
> +static inline unsigned long __must_check __copy_from_user(void *to, const void __user *from, unsigned long n)
> +{
> +	kasan_check_write(to, n);
> +	return  __arch_copy_from_user(to, from, n);
> +}
> +
> +static inline unsigned long __must_check __copy_to_user(void __user *to, const void *from, unsigned long n)
> +{
> +	kasan_check_read(from, n);
> +	return  __arch_copy_to_user(to, from, n);
> +}
> +
>  static inline unsigned long __must_check copy_from_user(void *to, const void __user *from, unsigned long n)
>  {
> +	kasan_check_write(to, n);
> +
>  	if (access_ok(VERIFY_READ, from, n))
> -		n = __copy_from_user(to, from, n);
> +		n = __arch_copy_from_user(to, from, n);
>  	else /* security hole - plug it */
>  		memset(to, 0, n);
>  	return n;
> @@ -316,8 +331,10 @@ static inline unsigned long __must_check copy_from_user(void *to, const void __u
>  
>  static inline unsigned long __must_check copy_to_user(void __user *to, const void *from, unsigned long n)
>  {
> +	kasan_check_read(from, n);
> +
>  	if (access_ok(VERIFY_WRITE, to, n))
> -		n = __copy_to_user(to, from, n);
> +		n = __arch_copy_to_user(to, from, n);
>  	return n;
>  }
>  
> diff --git a/arch/arm64/kernel/arm64ksyms.c b/arch/arm64/kernel/arm64ksyms.c
> index 3b6d8cc9dfe0..c654df05b7d7 100644
> --- a/arch/arm64/kernel/arm64ksyms.c
> +++ b/arch/arm64/kernel/arm64ksyms.c
> @@ -33,8 +33,8 @@ EXPORT_SYMBOL(copy_page);
>  EXPORT_SYMBOL(clear_page);
>  
>  	/* user mem (segment) */
> -EXPORT_SYMBOL(__copy_from_user);
> -EXPORT_SYMBOL(__copy_to_user);
> +EXPORT_SYMBOL(__arch_copy_from_user);
> +EXPORT_SYMBOL(__arch_copy_to_user);
>  EXPORT_SYMBOL(__clear_user);
>  EXPORT_SYMBOL(__copy_in_user);
>  
> diff --git a/arch/arm64/lib/copy_from_user.S b/arch/arm64/lib/copy_from_user.S
> index 4699cd74f87e..281e75db899a 100644
> --- a/arch/arm64/lib/copy_from_user.S
> +++ b/arch/arm64/lib/copy_from_user.S
> @@ -66,7 +66,7 @@
>  	.endm
>  
>  end	.req	x5
> -ENTRY(__copy_from_user)
> +ENTRY(__arch_copy_from_user)
>  ALTERNATIVE("nop", __stringify(SET_PSTATE_PAN(0)), ARM64_HAS_PAN, \
>  	    CONFIG_ARM64_PAN)
>  	add	end, x0, x2
> @@ -75,7 +75,7 @@ ALTERNATIVE("nop", __stringify(SET_PSTATE_PAN(1)), ARM64_HAS_PAN, \
>  	    CONFIG_ARM64_PAN)
>  	mov	x0, #0				// Nothing to copy
>  	ret
> -ENDPROC(__copy_from_user)
> +ENDPROC(__arch_copy_from_user)
>  
>  	.section .fixup,"ax"
>  	.align	2
> diff --git a/arch/arm64/lib/copy_to_user.S b/arch/arm64/lib/copy_to_user.S
> index 7512bbbc07ac..db4d187de61f 100644
> --- a/arch/arm64/lib/copy_to_user.S
> +++ b/arch/arm64/lib/copy_to_user.S
> @@ -65,7 +65,7 @@
>  	.endm
>  
>  end	.req	x5
> -ENTRY(__copy_to_user)
> +ENTRY(__arch_copy_to_user)
>  ALTERNATIVE("nop", __stringify(SET_PSTATE_PAN(0)), ARM64_HAS_PAN, \
>  	    CONFIG_ARM64_PAN)
>  	add	end, x0, x2
> @@ -74,7 +74,7 @@ ALTERNATIVE("nop", __stringify(SET_PSTATE_PAN(1)), ARM64_HAS_PAN, \
>  	    CONFIG_ARM64_PAN)
>  	mov	x0, #0
>  	ret
> -ENDPROC(__copy_to_user)
> +ENDPROC(__arch_copy_to_user)
>  
>  	.section .fixup,"ax"
>  	.align	2
> -- 
> 2.21.0.rc0.269.g1a574e7a288b
> 
