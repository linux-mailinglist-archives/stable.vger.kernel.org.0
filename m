Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 057A5A342D
	for <lists+stable@lfdr.de>; Fri, 30 Aug 2019 11:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727626AbfH3JkQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Aug 2019 05:40:16 -0400
Received: from foss.arm.com ([217.140.110.172]:57250 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726480AbfH3JkQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Aug 2019 05:40:16 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3F77E344;
        Fri, 30 Aug 2019 02:40:15 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DFBE43F718;
        Fri, 30 Aug 2019 02:40:13 -0700 (PDT)
Date:   Fri, 30 Aug 2019 10:40:11 +0100
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
Subject: Re: [PATCH ARM64 v4.4 V3 03/44] arm64: move TASK_* definitions to
 <asm/processor.h>
Message-ID: <20190830094011.GC46475@lakrids.cambridge.arm.com>
References: <cover.1567077734.git.viresh.kumar@linaro.org>
 <687d13717c9736bc33b9128bd09371fc0453fbdd.1567077734.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <687d13717c9736bc33b9128bd09371fc0453fbdd.1567077734.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 29, 2019 at 05:03:48PM +0530, Viresh Kumar wrote:
> From: Yury Norov <ynorov@caviumnetworks.com>
> 
> commit eef94a3d09aab437c8c254de942d8b1aa76455e2 upstream.
> 
> ILP32 series [1] introduces the dependency on <asm/is_compat.h> for
> TASK_SIZE macro. Which in turn requires <asm/thread_info.h>, and
> <asm/thread_info.h> include <asm/memory.h>, giving a circular dependency,
> because TASK_SIZE is currently located in <asm/memory.h>.
> 
> In other architectures, TASK_SIZE is defined in <asm/processor.h>, and
> moving TASK_SIZE there fixes the problem.
> 
> Discussion: https://patchwork.kernel.org/patch/9929107/
> 
> [1] https://github.com/norov/linux/tree/ilp32-next
> 
> CC: Will Deacon <will.deacon@arm.com>
> CC: Laura Abbott <labbott@redhat.com>
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: James Morse <james.morse@arm.com>
> Suggested-by: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Yury Norov <ynorov@caviumnetworks.com>
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Reviewed-by: Mark Rutland <mark.rutland@arm.com> [v4.4 backport]

Mark.

> ---
>  arch/arm64/include/asm/memory.h    | 15 ---------------
>  arch/arm64/include/asm/processor.h | 21 +++++++++++++++++++++
>  arch/arm64/kernel/entry.S          |  2 +-
>  3 files changed, 22 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
> index b42b930cc19a..959a1e9188fe 100644
> --- a/arch/arm64/include/asm/memory.h
> +++ b/arch/arm64/include/asm/memory.h
> @@ -43,8 +43,6 @@
>   *		 (VA_BITS - 1))
>   * VA_BITS - the maximum number of bits for virtual addresses.
>   * VA_START - the first kernel virtual address.
> - * TASK_SIZE - the maximum size of a user space task.
> - * TASK_UNMAPPED_BASE - the lower boundary of the mmap VM area.
>   * The module space lives between the addresses given by TASK_SIZE
>   * and PAGE_OFFSET - it must be within 128MB of the kernel text.
>   */
> @@ -58,19 +56,6 @@
>  #define PCI_IO_END		(MODULES_VADDR - SZ_2M)
>  #define PCI_IO_START		(PCI_IO_END - PCI_IO_SIZE)
>  #define FIXADDR_TOP		(PCI_IO_START - SZ_2M)
> -#define TASK_SIZE_64		(UL(1) << VA_BITS)
> -
> -#ifdef CONFIG_COMPAT
> -#define TASK_SIZE_32		UL(0x100000000)
> -#define TASK_SIZE		(test_thread_flag(TIF_32BIT) ? \
> -				TASK_SIZE_32 : TASK_SIZE_64)
> -#define TASK_SIZE_OF(tsk)	(test_tsk_thread_flag(tsk, TIF_32BIT) ? \
> -				TASK_SIZE_32 : TASK_SIZE_64)
> -#else
> -#define TASK_SIZE		TASK_SIZE_64
> -#endif /* CONFIG_COMPAT */
> -
> -#define TASK_UNMAPPED_BASE	(PAGE_ALIGN(TASK_SIZE / 4))
>  
>  /*
>   * Physical vs virtual RAM address space conversion.  These are
> diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
> index d08559528927..75d9ef6c457c 100644
> --- a/arch/arm64/include/asm/processor.h
> +++ b/arch/arm64/include/asm/processor.h
> @@ -19,6 +19,10 @@
>  #ifndef __ASM_PROCESSOR_H
>  #define __ASM_PROCESSOR_H
>  
> +#define TASK_SIZE_64		(UL(1) << VA_BITS)
> +
> +#ifndef __ASSEMBLY__
> +
>  /*
>   * Default implementation of macro that returns current
>   * instruction pointer ("program counter").
> @@ -36,6 +40,22 @@
>  #include <asm/types.h>
>  
>  #ifdef __KERNEL__
> +/*
> + * TASK_SIZE - the maximum size of a user space task.
> + * TASK_UNMAPPED_BASE - the lower boundary of the mmap VM area.
> + */
> +#ifdef CONFIG_COMPAT
> +#define TASK_SIZE_32		UL(0x100000000)
> +#define TASK_SIZE		(test_thread_flag(TIF_32BIT) ? \
> +				TASK_SIZE_32 : TASK_SIZE_64)
> +#define TASK_SIZE_OF(tsk)	(test_tsk_thread_flag(tsk, TIF_32BIT) ? \
> +				TASK_SIZE_32 : TASK_SIZE_64)
> +#else
> +#define TASK_SIZE		TASK_SIZE_64
> +#endif /* CONFIG_COMPAT */
> +
> +#define TASK_UNMAPPED_BASE	(PAGE_ALIGN(TASK_SIZE / 4))
> +
>  #define STACK_TOP_MAX		TASK_SIZE_64
>  #ifdef CONFIG_COMPAT
>  #define AARCH32_VECTORS_BASE	0xffff0000
> @@ -188,4 +208,5 @@ static inline void spin_lock_prefetch(const void *x)
>  
>  int cpu_enable_pan(void *__unused);
>  
> +#endif /* __ASSEMBLY__ */
>  #endif /* __ASM_PROCESSOR_H */
> diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
> index 586326981769..c849be9231bb 100644
> --- a/arch/arm64/kernel/entry.S
> +++ b/arch/arm64/kernel/entry.S
> @@ -27,7 +27,7 @@
>  #include <asm/cpufeature.h>
>  #include <asm/errno.h>
>  #include <asm/esr.h>
> -#include <asm/memory.h>
> +#include <asm/processor.h>
>  #include <asm/thread_info.h>
>  #include <asm/asm-uaccess.h>
>  #include <asm/unistd.h>
> -- 
> 2.21.0.rc0.269.g1a574e7a288b
> 
