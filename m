Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC6542E32AE
	for <lists+stable@lfdr.de>; Sun, 27 Dec 2020 21:19:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbgL0US6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Dec 2020 15:18:58 -0500
Received: from mail.efficios.com ([167.114.26.124]:49710 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbgL0US6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Dec 2020 15:18:58 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id C7CA2305BAF;
        Sun, 27 Dec 2020 15:18:15 -0500 (EST)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id AXzPCzJ3e22e; Sun, 27 Dec 2020 15:18:15 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 129E43059AD;
        Sun, 27 Dec 2020 15:18:15 -0500 (EST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 129E43059AD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1609100295;
        bh=I8aAHitxmqhk5rdBoColHeqpMTpuFdP9NH3DDxaSBeg=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=KuG3RldEwq9yvvz8rSpL7X5HUNIfvlI/qoQOAq70LTfM3V2hqdH7AD0FhvCisXwZI
         yiBxzRf/pyUkKXO6Im7W08EJJs4jvZ76VWWoXXB/uZN3V62zzvYXm0UbAnnyx3SB31
         x024jzhK2+ir1TEMLz9SyZVbOjHoTidwlYP3jAjDKDhiK+EYj7dm1q/pBQ64WkkXkd
         eCT1b0zrh7vKNKmUn1aD8/TPJM8NO3VfyKFqS08dGkNowkkka5y6U4GvnCCvd3uB+M
         6Xm5ddm/mj625371EaXRhRyKYlLf28v+V8lpRmLWdBJDxFsEdCRZ50MK92xqZ+zG+U
         Xf/Gqr6azC+ag==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id g8Hr4VplI7N5; Sun, 27 Dec 2020 15:18:15 -0500 (EST)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id E50173057E4;
        Sun, 27 Dec 2020 15:18:14 -0500 (EST)
Date:   Sun, 27 Dec 2020 15:18:14 -0500 (EST)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     x86 <x86@kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        stable <stable@vger.kernel.org>
Message-ID: <1836294649.3345.1609100294833.JavaMail.zimbra@efficios.com>
In-Reply-To: <bf59ecb5487171a852bcc8cdd553ec797aedc485.1609093476.git.luto@kernel.org>
References: <bf59ecb5487171a852bcc8cdd553ec797aedc485.1609093476.git.luto@kernel.org>
Subject: Re: [RFC please help] membarrier: Rewrite
 sync_core_before_usermode()
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_3991 (ZimbraWebClient - FF84 (Linux)/8.8.15_GA_3980)
Thread-Topic: membarrier: Rewrite sync_core_before_usermode()
Thread-Index: wVjb4qw6DS/7a1RRn40TSjnjQ0QjaA==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

----- On Dec 27, 2020, at 1:28 PM, Andy Lutomirski luto@kernel.org wrote:

> The old sync_core_before_usermode() comments said that a non-icache-syncing
> return-to-usermode instruction is x86-specific and that all other
> architectures automatically notice cross-modified code on return to
> userspace.  Based on my general understanding of how CPUs work and based on
> my atttempt to read the ARM manual, this is not true at all.  In fact, x86
> seems to be a bit of an anomaly in the other direction: x86's IRET is
> unusually heavyweight for a return-to-usermode instruction.
> 
> So let's drop any pretense that we can have a generic way implementation
> behind membarrier's SYNC_CORE flush and require all architectures that opt
> in to supply their own.

Removing the generic implementation is OK with me, as this will really require
architecture maintainers to think hard about it when porting this feature.

> This means x86, arm64, and powerpc for now.  Let's
> also rename the function from sync_core_before_usermode() to
> membarrier_sync_core_before_usermode() because the precise flushing details
> may very well be specific to membarrier, and even the concept of
> "sync_core" in the kernel is mostly an x86-ism.

Work for me too.

> 
> I admit that I'm rather surprised that the code worked at all on arm64,
> and I'm suspicious that it has never been very well tested.  My apologies
> for not reviewing this more carefully in the first place.

Please refer to Documentation/features/sched/membarrier-sync-core/arch-support.txt

It clearly states that only arm, arm64, powerpc and x86 support the membarrier
sync core feature as of now:


# Architecture requirements
#
# * arm/arm64/powerpc
#
# Rely on implicit context synchronization as a result of exception return
# when returning from IPI handler, and when returning to user-space.
#
# * x86
#
# x86-32 uses IRET as return from interrupt, which takes care of the IPI.
# However, it uses both IRET and SYSEXIT to go back to user-space. The IRET
# instruction is core serializing, but not SYSEXIT.
#
# x86-64 uses IRET as return from interrupt, which takes care of the IPI.
# However, it can return to user-space through either SYSRETL (compat code),
# SYSRETQ, or IRET.
#
# Given that neither SYSRET{L,Q}, nor SYSEXIT, are core serializing, we rely
# instead on write_cr3() performed by switch_mm() to provide core serialization
# after changing the current mm, and deal with the special case of kthread ->
# uthread (temporarily keeping current mm into active_mm) by issuing a
# sync_core_before_usermode() in that specific case.

This is based on direct feedback from the architecture maintainers.

You seem to have noticed odd cases on arm64 where this guarantee does not
match reality. Where exactly can we find this in the code, and which part
of the architecture manual can you point us to which supports your concern ?

Based on the notes I have, use of `eret` on aarch64 guarantees a context synchronizing
instruction when returning to user-space.

Thanks,

Mathieu

> 
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: linuxppc-dev@lists.ozlabs.org
> Cc: Nicholas Piggin <npiggin@gmail.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: x86@kernel.org
> Cc: stable@vger.kernel.org
> Fixes: 70216e18e519 ("membarrier: Provide core serializing command,
> *_SYNC_CORE")
> Signed-off-by: Andy Lutomirski <luto@kernel.org>
> ---
> 
> Hi arm64 and powerpc people-
> 
> This is part of a series here:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/luto/linux.git/log/?h=x86/fixes
> 
> Before I send out the whole series, I'm hoping that some arm64 and powerpc
> people can help me verify that I did this patch right.  Once I get
> some feedback on this patch, I'll send out the whole pile.  And once
> *that's* done, I'll start giving the mm lazy stuff some serious thought.
> 
> The x86 part is already fixed in Linus' tree.
> 
> Thanks,
> Andy
> 
> arch/arm64/include/asm/sync_core.h   | 21 +++++++++++++++++++++
> arch/powerpc/include/asm/sync_core.h | 20 ++++++++++++++++++++
> arch/x86/Kconfig                     |  1 -
> arch/x86/include/asm/sync_core.h     |  7 +++----
> include/linux/sched/mm.h             |  1 -
> include/linux/sync_core.h            | 21 ---------------------
> init/Kconfig                         |  3 ---
> kernel/sched/membarrier.c            | 15 +++++++++++----
> 8 files changed, 55 insertions(+), 34 deletions(-)
> create mode 100644 arch/arm64/include/asm/sync_core.h
> create mode 100644 arch/powerpc/include/asm/sync_core.h
> delete mode 100644 include/linux/sync_core.h
> 
> diff --git a/arch/arm64/include/asm/sync_core.h
> b/arch/arm64/include/asm/sync_core.h
> new file mode 100644
> index 000000000000..5be4531caabd
> --- /dev/null
> +++ b/arch/arm64/include/asm/sync_core.h
> @@ -0,0 +1,21 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _ASM_ARM64_SYNC_CORE_H
> +#define _ASM_ARM64_SYNC_CORE_H
> +
> +#include <asm/barrier.h>
> +
> +/*
> + * Ensure that the CPU notices any instruction changes before the next time
> + * it returns to usermode.
> + */
> +static inline void membarrier_sync_core_before_usermode(void)
> +{
> +	/*
> +	 * XXX: is this enough or do we need a DMB first to make sure that
> +	 * writes from other CPUs become visible to this CPU?  We have an
> +	 * smp_mb() already, but that's not quite the same thing.
> +	 */
> +	isb();
> +}
> +
> +#endif /* _ASM_ARM64_SYNC_CORE_H */
> diff --git a/arch/powerpc/include/asm/sync_core.h
> b/arch/powerpc/include/asm/sync_core.h
> new file mode 100644
> index 000000000000..71dfbe7794e5
> --- /dev/null
> +++ b/arch/powerpc/include/asm/sync_core.h
> @@ -0,0 +1,20 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _ASM_POWERPC_SYNC_CORE_H
> +#define _ASM_POWERPC_SYNC_CORE_H
> +
> +#include <asm/barrier.h>
> +
> +/*
> + * Ensure that the CPU notices any instruction changes before the next time
> + * it returns to usermode.
> + */
> +static inline void membarrier_sync_core_before_usermode(void)
> +{
> +	/*
> +	 * XXX: I know basically nothing about powerpc cache management.
> +	 * Is this correct?
> +	 */
> +	isync();
> +}
> +
> +#endif /* _ASM_POWERPC_SYNC_CORE_H */
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index b5137cc5b7b4..895f70fd4a61 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -81,7 +81,6 @@ config X86
> 	select ARCH_HAS_SET_DIRECT_MAP
> 	select ARCH_HAS_STRICT_KERNEL_RWX
> 	select ARCH_HAS_STRICT_MODULE_RWX
> -	select ARCH_HAS_SYNC_CORE_BEFORE_USERMODE
> 	select ARCH_HAS_SYSCALL_WRAPPER
> 	select ARCH_HAS_UBSAN_SANITIZE_ALL
> 	select ARCH_HAS_DEBUG_WX
> diff --git a/arch/x86/include/asm/sync_core.h b/arch/x86/include/asm/sync_core.h
> index ab7382f92aff..c665b453969a 100644
> --- a/arch/x86/include/asm/sync_core.h
> +++ b/arch/x86/include/asm/sync_core.h
> @@ -89,11 +89,10 @@ static inline void sync_core(void)
> }
> 
> /*
> - * Ensure that a core serializing instruction is issued before returning
> - * to user-mode. x86 implements return to user-space through sysexit,
> - * sysrel, and sysretq, which are not core serializing.
> + * Ensure that the CPU notices any instruction changes before the next time
> + * it returns to usermode.
>  */
> -static inline void sync_core_before_usermode(void)
> +static inline void membarrier_sync_core_before_usermode(void)
> {
> 	/* With PTI, we unconditionally serialize before running user code. */
> 	if (static_cpu_has(X86_FEATURE_PTI))
> diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
> index 48640db6ca86..81ba47910a73 100644
> --- a/include/linux/sched/mm.h
> +++ b/include/linux/sched/mm.h
> @@ -7,7 +7,6 @@
> #include <linux/sched.h>
> #include <linux/mm_types.h>
> #include <linux/gfp.h>
> -#include <linux/sync_core.h>
> 
> /*
>  * Routines for handling mm_structs
> diff --git a/include/linux/sync_core.h b/include/linux/sync_core.h
> deleted file mode 100644
> index 013da4b8b327..000000000000
> --- a/include/linux/sync_core.h
> +++ /dev/null
> @@ -1,21 +0,0 @@
> -/* SPDX-License-Identifier: GPL-2.0 */
> -#ifndef _LINUX_SYNC_CORE_H
> -#define _LINUX_SYNC_CORE_H
> -
> -#ifdef CONFIG_ARCH_HAS_SYNC_CORE_BEFORE_USERMODE
> -#include <asm/sync_core.h>
> -#else
> -/*
> - * This is a dummy sync_core_before_usermode() implementation that can be used
> - * on all architectures which return to user-space through core serializing
> - * instructions.
> - * If your architecture returns to user-space through non-core-serializing
> - * instructions, you need to write your own functions.
> - */
> -static inline void sync_core_before_usermode(void)
> -{
> -}
> -#endif
> -
> -#endif /* _LINUX_SYNC_CORE_H */
> -
> diff --git a/init/Kconfig b/init/Kconfig
> index c9446911cf41..eb9772078cd4 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -2334,9 +2334,6 @@ source "kernel/Kconfig.locks"
> config ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
> 	bool
> 
> -config ARCH_HAS_SYNC_CORE_BEFORE_USERMODE
> -	bool
> -
> # It may be useful for an architecture to override the definitions of the
> # SYSCALL_DEFINE() and __SYSCALL_DEFINEx() macros in <linux/syscalls.h>
> # and the COMPAT_ variants in <linux/compat.h>, in particular to use a
> diff --git a/kernel/sched/membarrier.c b/kernel/sched/membarrier.c
> index b3a82d7635da..db4945e1ec94 100644
> --- a/kernel/sched/membarrier.c
> +++ b/kernel/sched/membarrier.c
> @@ -5,6 +5,9 @@
>  * membarrier system call
>  */
> #include "sched.h"
> +#ifdef CONFIG_ARCH_HAS_MEMBARRIER_SYNC_CORE
> +#include <asm/sync_core.h>
> +#endif
> 
> /*
>  * The basic principle behind the regular memory barrier mode of membarrier()
> @@ -221,6 +224,7 @@ static void ipi_mb(void *info)
> 	smp_mb();	/* IPIs should be serializing but paranoid. */
> }
> 
> +#ifdef CONFIG_ARCH_HAS_MEMBARRIER_SYNC_CORE
> static void ipi_sync_core(void *info)
> {
> 	/*
> @@ -230,13 +234,14 @@ static void ipi_sync_core(void *info)
> 	 * the big comment at the top of this file.
> 	 *
> 	 * A sync_core() would provide this guarantee, but
> -	 * sync_core_before_usermode() might end up being deferred until
> -	 * after membarrier()'s smp_mb().
> +	 * membarrier_sync_core_before_usermode() might end up being deferred
> +	 * until after membarrier()'s smp_mb().
> 	 */
> 	smp_mb();	/* IPIs should be serializing but paranoid. */
> 
> -	sync_core_before_usermode();
> +	membarrier_sync_core_before_usermode();
> }
> +#endif
> 
> static void ipi_rseq(void *info)
> {
> @@ -368,12 +373,14 @@ static int membarrier_private_expedited(int flags, int
> cpu_id)
> 	smp_call_func_t ipi_func = ipi_mb;
> 
> 	if (flags == MEMBARRIER_FLAG_SYNC_CORE) {
> -		if (!IS_ENABLED(CONFIG_ARCH_HAS_MEMBARRIER_SYNC_CORE))
> +#ifndef CONFIG_ARCH_HAS_MEMBARRIER_SYNC_CORE
> 			return -EINVAL;
> +#else
> 		if (!(atomic_read(&mm->membarrier_state) &
> 		      MEMBARRIER_STATE_PRIVATE_EXPEDITED_SYNC_CORE_READY))
> 			return -EPERM;
> 		ipi_func = ipi_sync_core;
> +#endif
> 	} else if (flags == MEMBARRIER_FLAG_RSEQ) {
> 		if (!IS_ENABLED(CONFIG_RSEQ))
> 			return -EINVAL;
> --
> 2.29.2

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
