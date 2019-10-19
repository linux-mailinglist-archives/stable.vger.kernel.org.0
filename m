Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE41DDAE7
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 22:35:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbfJSUfu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Oct 2019 16:35:50 -0400
Received: from 216-12-86-13.cv.mvl.ntelos.net ([216.12.86.13]:48790 "EHLO
        brightrain.aerifal.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726129AbfJSUfu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Oct 2019 16:35:50 -0400
X-Greylist: delayed 345 seconds by postgrey-1.27 at vger.kernel.org; Sat, 19 Oct 2019 16:35:49 EDT
Received: from dalias by brightrain.aerifal.cx with local (Exim 3.15 #2)
        id 1iLvME-0002wa-00; Sat, 19 Oct 2019 20:29:50 +0000
Date:   Sat, 19 Oct 2019 16:29:50 -0400
From:   Rich Felker <dalias@libc.org>
To:     Hauke Mehrtens <hauke@hauke-m.de>
Cc:     catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, musl@lists.openwall.com,
        stable@vger.kernel.org
Subject: Re: [musl] [PATCH] arm64: uapi: Fix user space compile with musl libc
Message-ID: <20191019202950.GC16318@brightrain.aerifal.cx>
References: <20191019201717.15358-1-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191019201717.15358-1-hauke@hauke-m.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Oct 19, 2019 at 10:17:17PM +0200, Hauke Mehrtens wrote:
> musl libc also defines the structures in their arch/aarch64/bits/signal.h
> header file. Some applications like strace and gdb include both of them
> and then the structure definitions are clashing and the build of these
> user space applications fails.
> 
> This patch allows a libc to define a constant which tells the kernel
> header file that the libc already defined these structures and that they
> should not be defined by the kernel uapi header files any more to
> prevent clashes. This is done in a similar way as it is already done for
> other header files.
> 
> When this patch was accepted into the kernel I will also update musl
> libc to define these constants.

I don't entirely object to this outright, but I'd really like to avoid
adding further __UAPI_DEF_* suppressions. AIUI asm/sigcontext.h is not
intended to be used with userspace headers. Is it still being
indirectly included via some other uapi headers? (I thought that was
fixed..) If so, that should really be fixed first, and then we can see
if there's still motivation for the patch here.

Rich


> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> Cc: stable@vger.kernel.org
> ---
>  arch/arm64/include/uapi/asm/sigcontext.h | 13 +++++++++++++
>  include/uapi/linux/libc-compat.h         | 20 ++++++++++++++++++++
>  2 files changed, 33 insertions(+)
> 
> diff --git a/arch/arm64/include/uapi/asm/sigcontext.h b/arch/arm64/include/uapi/asm/sigcontext.h
> index 8b0ebce92427..92d911146137 100644
> --- a/arch/arm64/include/uapi/asm/sigcontext.h
> +++ b/arch/arm64/include/uapi/asm/sigcontext.h
> @@ -20,7 +20,9 @@
>  #ifndef __ASSEMBLY__
>  
>  #include <linux/types.h>
> +#include <linux/libc-compat.h>
>  
> +#if __UAPI_DEF_SIGCONTEXT
>  /*
>   * Signal context structure - contains all info to do with the state
>   * before the signal handler was invoked.
> @@ -35,6 +37,7 @@ struct sigcontext {
>  	/* 4K reserved for FP/SIMD state and future expansion */
>  	__u8 __reserved[4096] __attribute__((__aligned__(16)));
>  };
> +#endif
>  
>  /*
>   * Allocation of __reserved[]:
> @@ -57,6 +60,7 @@ struct sigcontext {
>   * generated when userspace does not opt in for any such extension.
>   */
>  
> +#if __UAPI_DEF_AARCH64_CTX
>  /*
>   * Header to be used at the beginning of structures extending the user
>   * context. Such structures must be placed after the rt_sigframe on the stack
> @@ -67,7 +71,9 @@ struct _aarch64_ctx {
>  	__u32 magic;
>  	__u32 size;
>  };
> +#endif
>  
> +#if __UAPI_DEF_FPSIMD_CONTEXT
>  #define FPSIMD_MAGIC	0x46508001
>  
>  struct fpsimd_context {
> @@ -76,7 +82,9 @@ struct fpsimd_context {
>  	__u32 fpcr;
>  	__uint128_t vregs[32];
>  };
> +#endif
>  
> +#if __UAPI_DEF_ESR_CONTEXT
>  /*
>   * Note: similarly to all other integer fields, each V-register is stored in an
>   * endianness-dependent format, with the byte at offset i from the start of the
> @@ -93,7 +101,9 @@ struct esr_context {
>  	struct _aarch64_ctx head;
>  	__u64 esr;
>  };
> +#endif
>  
> +#if __UAPI_DEF_EXTRA_CONTEXT
>  /*
>   * extra_context: describes extra space in the signal frame for
>   * additional structures that don't fit in sigcontext.__reserved[].
> @@ -128,7 +138,9 @@ struct extra_context {
>  	__u32 size; /* size in bytes of the extra space */
>  	__u32 __reserved[3];
>  };
> +#endif
>  
> +#if __UAPI_DEF_SVE_CONTEXT
>  #define SVE_MAGIC	0x53564501
>  
>  struct sve_context {
> @@ -136,6 +148,7 @@ struct sve_context {
>  	__u16 vl;
>  	__u16 __reserved[3];
>  };
> +#endif
>  
>  #endif /* !__ASSEMBLY__ */
>  
> diff --git a/include/uapi/linux/libc-compat.h b/include/uapi/linux/libc-compat.h
> index 8254c937c9f4..a863130f4638 100644
> --- a/include/uapi/linux/libc-compat.h
> +++ b/include/uapi/linux/libc-compat.h
> @@ -264,4 +264,24 @@
>  
>  #endif /* __GLIBC__ */
>  
> +/* Definitions for arch/arm64/include/uapi/asm/sigcontext.h */
> +#ifndef __UAPI_DEF_SIGCONTEXT
> +#define __UAPI_DEF_SIGCONTEXT		1
> +#endif
> +#ifndef __UAPI_DEF_AARCH64_CTX
> +#define __UAPI_DEF_AARCH64_CTX		1
> +#endif
> +#ifndef __UAPI_DEF_FPSIMD_CONTEXT
> +#define __UAPI_DEF_FPSIMD_CONTEXT	1
> +#endif
> +#ifndef __UAPI_DEF_ESR_CONTEXT
> +#define __UAPI_DEF_ESR_CONTEXT		1
> +#endif
> +#ifndef __UAPI_DEF_EXTRA_CONTEXT
> +#define __UAPI_DEF_EXTRA_CONTEXT	1
> +#endif
> +#ifndef __UAPI_DEF_SVE_CONTEXT
> +#define __UAPI_DEF_SVE_CONTEXT		1
> +#endif
> +
>  #endif /* _UAPI_LIBC_COMPAT_H */
> -- 
> 2.20.1
