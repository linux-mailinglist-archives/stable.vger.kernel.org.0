Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA8CA48C7F8
	for <lists+stable@lfdr.de>; Wed, 12 Jan 2022 17:12:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355019AbiALQMD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jan 2022 11:12:03 -0500
Received: from mail.efficios.com ([167.114.26.124]:59366 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355024AbiALQLG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Jan 2022 11:11:06 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 74F892575AE;
        Wed, 12 Jan 2022 11:11:05 -0500 (EST)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id n6a4qlMlEoz8; Wed, 12 Jan 2022 11:11:04 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id D31042574B9;
        Wed, 12 Jan 2022 11:11:04 -0500 (EST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com D31042574B9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1642003864;
        bh=CHSmDKIBS772E6jxc42t8yoSsngTNxSjPK0HHOUA5VA=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=MslA3a46ckR2nV9LVnKj85R1OnbB+uazRPH19QB/LySc0eISWRVEySRMwsKTzK9Y5
         8rFrndyVhIT+Dvw8/iZilkmb5I+PTe9Z2EOJ9u0ud9pedafqFNYfHjKf59LiaWolhm
         FxtFTeFLsTRB/a2WCtALoUFIsTjsaNMBLVvw2MBzDVfWuwpALDEMAfaxXcNEYq+VlU
         zyoFrRKgemGnS6WgHFM0glMU8lg0Uv8AmjlfUWg6rQN7EV9oRVglkM64gUwkORJHXv
         HE5i5UVfJyjeQA9EfuyOqmtcNMcRVnahpK865MtjOTLRTQE24tEvvwLOB4P9cmbxzB
         bdGmpJYRM9dsw==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id GGfJYmmZpaAh; Wed, 12 Jan 2022 11:11:04 -0500 (EST)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id BB4B425734C;
        Wed, 12 Jan 2022 11:11:04 -0500 (EST)
Date:   Wed, 12 Jan 2022 11:11:04 -0500 (EST)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Anton Blanchard <anton@ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-arch <linux-arch@vger.kernel.org>, x86 <x86@kernel.org>,
        riel <riel@surriel.com>, Dave Hansen <dave.hansen@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Nadav Amit <nadav.amit@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        stable <stable@vger.kernel.org>
Message-ID: <1769209086.24770.1642003864649.JavaMail.zimbra@efficios.com>
In-Reply-To: <d2f76c148fa039d2dea404c03e5fcd2f3dbf3750.1641659630.git.luto@kernel.org>
References: <cover.1641659630.git.luto@kernel.org> <d2f76c148fa039d2dea404c03e5fcd2f3dbf3750.1641659630.git.luto@kernel.org>
Subject: Re: [PATCH 07/23] membarrier: Rewrite sync_core_before_usermode()
 and improve documentation
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_4180 (ZimbraWebClient - FF96 (Linux)/8.8.15_GA_4177)
Thread-Topic: membarrier: Rewrite sync_core_before_usermode() and improve documentation
Thread-Index: COsoGErcEE/VA4sBucBykqi2Wwe69g==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

----- On Jan 8, 2022, at 11:43 AM, Andy Lutomirski luto@kernel.org wrote:

> The old sync_core_before_usermode() comments suggested that a
> non-icache-syncing return-to-usermode instruction is x86-specific and that
> all other architectures automatically notice cross-modified code on return
> to userspace.
> 
> This is misleading.  The incantation needed to modify code from one
> CPU and execute it on another CPU is highly architecture dependent.
> On x86, according to the SDM, one must modify the code, issue SFENCE
> if the modification was WC or nontemporal, and then issue a "serializing
> instruction" on the CPU that will execute the code.  membarrier() can do
> the latter.
> 
> On arm, arm64 and powerpc, one must flush the icache and then flush the
> pipeline on the target CPU, although the CPU manuals don't necessarily use
> this language.
> 
> So let's drop any pretense that we can have a generic way to define or
> implement membarrier's SYNC_CORE operation and instead require all
> architectures to define the helper and supply their own documentation as to
> how to use it.  This means x86, arm64, and powerpc for now.  Let's also
> rename the function from sync_core_before_usermode() to
> membarrier_sync_core_before_usermode() because the precise flushing details
> may very well be specific to membarrier, and even the concept of
> "sync_core" in the kernel is mostly an x86-ism.
> 
> (It may well be the case that, on real x86 processors, synchronizing the
> icache (which requires no action at all) and "flushing the pipeline" is
> sufficient, but trying to use this language would be confusing at best.
> LFENCE does something awfully like "flushing the pipeline", but the SDM
> does not permit LFENCE as an alternative to a "serializing instruction"
> for this purpose.)

A few comments below:

[...]

> +# On powerpc, a program can use MEMBARRIER_CMD_PRIVATE_EXPEDITED_SYNC_CORE
> +# similarly to arm64.  It would be nice if the powerpc maintainers could
> +# add a more clear explanantion.

Any thoughts from ppc maintainers ?

[...]

> diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
> index e9da3dc71254..b47cd22b2eb1 100644
> --- a/arch/x86/kernel/alternative.c
> +++ b/arch/x86/kernel/alternative.c
> @@ -17,7 +17,7 @@
> #include <linux/kprobes.h>
> #include <linux/mmu_context.h>
> #include <linux/bsearch.h>
> -#include <linux/sync_core.h>
> +#include <asm/sync_core.h>

All this churn wrt move from linux/sync_core.h to asm/sync_core.h
should probably be moved to a separate cleanup patch.

> #include <asm/text-patching.h>
> #include <asm/alternative.h>
> #include <asm/sections.h>
> diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
> index 193204aee880..a2529e09f620 100644
> --- a/arch/x86/kernel/cpu/mce/core.c
> +++ b/arch/x86/kernel/cpu/mce/core.c
> @@ -41,12 +41,12 @@
> #include <linux/irq_work.h>
> #include <linux/export.h>
> #include <linux/set_memory.h>
> -#include <linux/sync_core.h>
> #include <linux/task_work.h>
> #include <linux/hardirq.h>
> 
> #include <asm/intel-family.h>
> #include <asm/processor.h>
> +#include <asm/sync_core.h>
> #include <asm/traps.h>
> #include <asm/tlbflush.h>
> #include <asm/mce.h>

[...]

> diff --git a/drivers/misc/sgi-gru/grufault.c b/drivers/misc/sgi-gru/grufault.c
> index d7ef61e602ed..462c667bd6c4 100644
> --- a/drivers/misc/sgi-gru/grufault.c
> +++ b/drivers/misc/sgi-gru/grufault.c
> @@ -20,8 +20,8 @@
> #include <linux/io.h>
> #include <linux/uaccess.h>
> #include <linux/security.h>
> -#include <linux/sync_core.h>
> #include <linux/prefetch.h>
> +#include <asm/sync_core.h>
> #include "gru.h"
> #include "grutables.h"
> #include "grulib.h"
> diff --git a/drivers/misc/sgi-gru/gruhandles.c
> b/drivers/misc/sgi-gru/gruhandles.c
> index 1d75d5e540bc..c8cba1c1b00f 100644
> --- a/drivers/misc/sgi-gru/gruhandles.c
> +++ b/drivers/misc/sgi-gru/gruhandles.c
> @@ -16,7 +16,7 @@
> #define GRU_OPERATION_TIMEOUT	(((cycles_t) local_cpu_data->itc_freq)*10)
> #define CLKS2NSEC(c)		((c) *1000000000 / local_cpu_data->itc_freq)
> #else
> -#include <linux/sync_core.h>
> +#include <asm/sync_core.h>
> #include <asm/tsc.h>
> #define GRU_OPERATION_TIMEOUT	((cycles_t) tsc_khz*10*1000)
> #define CLKS2NSEC(c)		((c) * 1000000 / tsc_khz)
> diff --git a/drivers/misc/sgi-gru/grukservices.c
> b/drivers/misc/sgi-gru/grukservices.c
> index 0ea923fe6371..ce03ff3f7c3a 100644
> --- a/drivers/misc/sgi-gru/grukservices.c
> +++ b/drivers/misc/sgi-gru/grukservices.c
> @@ -16,10 +16,10 @@
> #include <linux/miscdevice.h>
> #include <linux/proc_fs.h>
> #include <linux/interrupt.h>
> -#include <linux/sync_core.h>
> #include <linux/uaccess.h>
> #include <linux/delay.h>
> #include <linux/export.h>
> +#include <asm/sync_core.h>
> #include <asm/io_apic.h>
> #include "gru.h"
> #include "grulib.h"
> diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
> index e8919995d8dd..e107f292fc42 100644
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

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
