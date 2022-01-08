Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C598D488497
	for <lists+stable@lfdr.de>; Sat,  8 Jan 2022 17:44:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232038AbiAHQoa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Jan 2022 11:44:30 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:50246 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234698AbiAHQo0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Jan 2022 11:44:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E34E60DD7;
        Sat,  8 Jan 2022 16:44:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8EB3C36AEF;
        Sat,  8 Jan 2022 16:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641660265;
        bh=nCJ6JL8IVos0CgiyyAGe15m3ZdsuNKsEv9GJVjhwIOI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WtHuJMx7z0eKUfRVr+x8ybkHoQH5R7jphHS4lUHOVZi4MG9PdHrBL9P0lyvCaSaIH
         1EkYq/MwLrm81oeFXOYQblb7oQVYh1/gidhXADq0+Wyq1LReeiV2H7p5p7yI+7c3o1
         0Vr1Lq+hGO6rgLqtctcq8b/Fk1I/9k/ybOzc2qkMjkVsNu5T9gzTBfGhkpIhD8fVPW
         Y4PB3RuJZwBSuUxn1RzK/aXpei0NaV9vsRwFI+hnxmcCYTrh7c7pAFUa8EvpmB49sd
         dVNQNxJv1gZjDjYnff2yjZK2OTJwPVe9QtRy6WJUYBkSjz8CjlxtdivNGFs6Vsgpqi
         RIi+11VU5yWcA==
From:   Andy Lutomirski <luto@kernel.org>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Anton Blanchard <anton@ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-arch <linux-arch@vger.kernel.org>, x86@kernel.org,
        Rik van Riel <riel@surriel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Nadav Amit <nadav.amit@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andy Lutomirski <luto@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
Subject: [PATCH 07/23] membarrier: Rewrite sync_core_before_usermode() and improve documentation
Date:   Sat,  8 Jan 2022 08:43:52 -0800
Message-Id: <d2f76c148fa039d2dea404c03e5fcd2f3dbf3750.1641659630.git.luto@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1641659630.git.luto@kernel.org>
References: <cover.1641659630.git.luto@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The old sync_core_before_usermode() comments suggested that a
non-icache-syncing return-to-usermode instruction is x86-specific and that
all other architectures automatically notice cross-modified code on return
to userspace.

This is misleading.  The incantation needed to modify code from one
CPU and execute it on another CPU is highly architecture dependent.
On x86, according to the SDM, one must modify the code, issue SFENCE
if the modification was WC or nontemporal, and then issue a "serializing
instruction" on the CPU that will execute the code.  membarrier() can do
the latter.

On arm, arm64 and powerpc, one must flush the icache and then flush the
pipeline on the target CPU, although the CPU manuals don't necessarily use
this language.

So let's drop any pretense that we can have a generic way to define or
implement membarrier's SYNC_CORE operation and instead require all
architectures to define the helper and supply their own documentation as to
how to use it.  This means x86, arm64, and powerpc for now.  Let's also
rename the function from sync_core_before_usermode() to
membarrier_sync_core_before_usermode() because the precise flushing details
may very well be specific to membarrier, and even the concept of
"sync_core" in the kernel is mostly an x86-ism.

(It may well be the case that, on real x86 processors, synchronizing the
 icache (which requires no action at all) and "flushing the pipeline" is
 sufficient, but trying to use this language would be confusing at best.
 LFENCE does something awfully like "flushing the pipeline", but the SDM
 does not permit LFENCE as an alternative to a "serializing instruction"
 for this purpose.)

Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@lists.ozlabs.org
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: x86@kernel.org
Cc: stable@vger.kernel.org
Acked-by: Will Deacon <will@kernel.org> # for arm64
Fixes: 70216e18e519 ("membarrier: Provide core serializing command, *_SYNC_CORE")
Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 .../membarrier-sync-core/arch-support.txt     | 69 ++++++-------------
 arch/arm/include/asm/membarrier.h             | 21 ++++++
 arch/arm64/include/asm/membarrier.h           | 19 +++++
 arch/powerpc/include/asm/membarrier.h         | 10 +++
 arch/x86/Kconfig                              |  1 -
 arch/x86/include/asm/membarrier.h             | 25 +++++++
 arch/x86/include/asm/sync_core.h              | 20 ------
 arch/x86/kernel/alternative.c                 |  2 +-
 arch/x86/kernel/cpu/mce/core.c                |  2 +-
 arch/x86/mm/tlb.c                             |  3 +-
 drivers/misc/sgi-gru/grufault.c               |  2 +-
 drivers/misc/sgi-gru/gruhandles.c             |  2 +-
 drivers/misc/sgi-gru/grukservices.c           |  2 +-
 include/linux/sched/mm.h                      |  1 -
 include/linux/sync_core.h                     | 21 ------
 init/Kconfig                                  |  3 -
 kernel/sched/membarrier.c                     | 14 +++-
 17 files changed, 115 insertions(+), 102 deletions(-)
 create mode 100644 arch/arm/include/asm/membarrier.h
 create mode 100644 arch/arm64/include/asm/membarrier.h
 create mode 100644 arch/x86/include/asm/membarrier.h
 delete mode 100644 include/linux/sync_core.h

diff --git a/Documentation/features/sched/membarrier-sync-core/arch-support.txt b/Documentation/features/sched/membarrier-sync-core/arch-support.txt
index 883d33b265d6..4009b26bf5c3 100644
--- a/Documentation/features/sched/membarrier-sync-core/arch-support.txt
+++ b/Documentation/features/sched/membarrier-sync-core/arch-support.txt
@@ -5,51 +5,26 @@
 #
 # Architecture requirements
 #
-# * arm/arm64/powerpc
 #
-# Rely on implicit context synchronization as a result of exception return
-# when returning from IPI handler, and when returning to user-space.
-#
-# * x86
-#
-# x86-32 uses IRET as return from interrupt, which takes care of the IPI.
-# However, it uses both IRET and SYSEXIT to go back to user-space. The IRET
-# instruction is core serializing, but not SYSEXIT.
-#
-# x86-64 uses IRET as return from interrupt, which takes care of the IPI.
-# However, it can return to user-space through either SYSRETL (compat code),
-# SYSRETQ, or IRET.
-#
-# Given that neither SYSRET{L,Q}, nor SYSEXIT, are core serializing, we rely
-# instead on write_cr3() performed by switch_mm() to provide core serialization
-# after changing the current mm, and deal with the special case of kthread ->
-# uthread (temporarily keeping current mm into active_mm) by issuing a
-# sync_core_before_usermode() in that specific case.
-#
-    -----------------------
-    |         arch |status|
-    -----------------------
-    |       alpha: | TODO |
-    |         arc: | TODO |
-    |         arm: |  ok  |
-    |       arm64: |  ok  |
-    |        csky: | TODO |
-    |       h8300: | TODO |
-    |     hexagon: | TODO |
-    |        ia64: | TODO |
-    |        m68k: | TODO |
-    |  microblaze: | TODO |
-    |        mips: | TODO |
-    |       nds32: | TODO |
-    |       nios2: | TODO |
-    |    openrisc: | TODO |
-    |      parisc: | TODO |
-    |     powerpc: |  ok  |
-    |       riscv: | TODO |
-    |        s390: | TODO |
-    |          sh: | TODO |
-    |       sparc: | TODO |
-    |          um: | TODO |
-    |         x86: |  ok  |
-    |      xtensa: | TODO |
-    -----------------------
+# An architecture that wants to support
+# MEMBARRIER_CMD_PRIVATE_EXPEDITED_SYNC_CORE needs to define precisely what it
+# is supposed to do and implement membarrier_sync_core_before_usermode() to
+# make it do that.  Then it can select ARCH_HAS_MEMBARRIER_SYNC_CORE via
+# Kconfig and document what SYNC_CORE does on that architecture in this
+# list.
+#
+# On x86, a program can safely modify code, issue
+# MEMBARRIER_CMD_PRIVATE_EXPEDITED_SYNC_CORE, and then execute that code, via
+# the modified address or an alias, from any thread in the calling process.
+#
+# On arm and arm64, a program can modify code, flush the icache as needed,
+# and issue MEMBARRIER_CMD_PRIVATE_EXPEDITED_SYNC_CORE to force a "context
+# synchronizing event", aka pipeline flush on all CPUs that might run the
+# calling process.  Then the program can execute the modified code as long
+# as it is executed from an address consistent with the icache flush and
+# the CPU's cache type.  On arm, cacheflush(2) can be used for the icache
+# flushing operation.
+#
+# On powerpc, a program can use MEMBARRIER_CMD_PRIVATE_EXPEDITED_SYNC_CORE
+# similarly to arm64.  It would be nice if the powerpc maintainers could
+# add a more clear explanantion.
diff --git a/arch/arm/include/asm/membarrier.h b/arch/arm/include/asm/membarrier.h
new file mode 100644
index 000000000000..c162a0758657
--- /dev/null
+++ b/arch/arm/include/asm/membarrier.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_ARM_MEMBARRIER_H
+#define _ASM_ARM_MEMBARRIER_H
+
+#include <asm/barrier.h>
+
+/*
+ * On arm, anyone trying to use membarrier() to handle JIT code is required
+ * to first flush the icache (most likely by using cacheflush(2) and then
+ * do SYNC_CORE.  All that's needed after the icache flush is to execute a
+ * "context synchronization event".
+ *
+ * Returning to user mode is a context synchronization event, so no
+ * specific action by the kernel is needed other than ensuring that the
+ * kernel is entered.
+ */
+static inline void membarrier_sync_core_before_usermode(void)
+{
+}
+
+#endif /* _ASM_ARM_MEMBARRIER_H */
diff --git a/arch/arm64/include/asm/membarrier.h b/arch/arm64/include/asm/membarrier.h
new file mode 100644
index 000000000000..db8e0ea57253
--- /dev/null
+++ b/arch/arm64/include/asm/membarrier.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_ARM64_MEMBARRIER_H
+#define _ASM_ARM64_MEMBARRIER_H
+
+#include <asm/barrier.h>
+
+/*
+ * On arm64, anyone trying to use membarrier() to handle JIT code is
+ * required to first flush the icache and then do SYNC_CORE.  All that's
+ * needed after the icache flush is to execute a "context synchronization
+ * event".  Right now, ERET does this, and we are guaranteed to ERET before
+ * any user code runs.  If Linux ever programs the CPU to make ERET stop
+ * being a context synchronizing event, then this will need to be adjusted.
+ */
+static inline void membarrier_sync_core_before_usermode(void)
+{
+}
+
+#endif /* _ASM_ARM64_MEMBARRIER_H */
diff --git a/arch/powerpc/include/asm/membarrier.h b/arch/powerpc/include/asm/membarrier.h
index b90766e95bd1..466abe6fdcea 100644
--- a/arch/powerpc/include/asm/membarrier.h
+++ b/arch/powerpc/include/asm/membarrier.h
@@ -1,4 +1,14 @@
 #ifndef _ASM_POWERPC_MEMBARRIER_H
 #define _ASM_POWERPC_MEMBARRIER_H
 
+#include <asm/barrier.h>
+
+/*
+ * The RFI family of instructions are context synchronising, and
+ * that is how we return to userspace, so nothing is required here.
+ */
+static inline void membarrier_sync_core_before_usermode(void)
+{
+}
+
 #endif /* _ASM_POWERPC_MEMBARRIER_H */
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index d9830e7e1060..5060c38bf560 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -90,7 +90,6 @@ config X86
 	select ARCH_HAS_SET_DIRECT_MAP
 	select ARCH_HAS_STRICT_KERNEL_RWX
 	select ARCH_HAS_STRICT_MODULE_RWX
-	select ARCH_HAS_SYNC_CORE_BEFORE_USERMODE
 	select ARCH_HAS_SYSCALL_WRAPPER
 	select ARCH_HAS_UBSAN_SANITIZE_ALL
 	select ARCH_HAS_DEBUG_WX
diff --git a/arch/x86/include/asm/membarrier.h b/arch/x86/include/asm/membarrier.h
new file mode 100644
index 000000000000..9b72a1b49359
--- /dev/null
+++ b/arch/x86/include/asm/membarrier.h
@@ -0,0 +1,25 @@
+#ifndef _ASM_X86_MEMBARRIER_H
+#define _ASM_X86_MEMBARRIER_H
+
+#include <asm/sync_core.h>
+
+/*
+ * Ensure that the CPU notices any instruction changes before the next time
+ * it returns to usermode.
+ */
+static inline void membarrier_sync_core_before_usermode(void)
+{
+	/* With PTI, we unconditionally serialize before running user code. */
+	if (static_cpu_has(X86_FEATURE_PTI))
+		return;
+
+	/*
+	 * Even if we're in an interrupt, we might reschedule before returning,
+	 * in which case we could switch to a different thread in the same mm
+	 * and return using SYSRET or SYSEXIT.  Instead of trying to keep
+	 * track of our need to sync the core, just sync right away.
+	 */
+	sync_core();
+}
+
+#endif /* _ASM_X86_MEMBARRIER_H */
diff --git a/arch/x86/include/asm/sync_core.h b/arch/x86/include/asm/sync_core.h
index ab7382f92aff..bfe4ac4e6be2 100644
--- a/arch/x86/include/asm/sync_core.h
+++ b/arch/x86/include/asm/sync_core.h
@@ -88,24 +88,4 @@ static inline void sync_core(void)
 	iret_to_self();
 }
 
-/*
- * Ensure that a core serializing instruction is issued before returning
- * to user-mode. x86 implements return to user-space through sysexit,
- * sysrel, and sysretq, which are not core serializing.
- */
-static inline void sync_core_before_usermode(void)
-{
-	/* With PTI, we unconditionally serialize before running user code. */
-	if (static_cpu_has(X86_FEATURE_PTI))
-		return;
-
-	/*
-	 * Even if we're in an interrupt, we might reschedule before returning,
-	 * in which case we could switch to a different thread in the same mm
-	 * and return using SYSRET or SYSEXIT.  Instead of trying to keep
-	 * track of our need to sync the core, just sync right away.
-	 */
-	sync_core();
-}
-
 #endif /* _ASM_X86_SYNC_CORE_H */
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index e9da3dc71254..b47cd22b2eb1 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -17,7 +17,7 @@
 #include <linux/kprobes.h>
 #include <linux/mmu_context.h>
 #include <linux/bsearch.h>
-#include <linux/sync_core.h>
+#include <asm/sync_core.h>
 #include <asm/text-patching.h>
 #include <asm/alternative.h>
 #include <asm/sections.h>
diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index 193204aee880..a2529e09f620 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -41,12 +41,12 @@
 #include <linux/irq_work.h>
 #include <linux/export.h>
 #include <linux/set_memory.h>
-#include <linux/sync_core.h>
 #include <linux/task_work.h>
 #include <linux/hardirq.h>
 
 #include <asm/intel-family.h>
 #include <asm/processor.h>
+#include <asm/sync_core.h>
 #include <asm/traps.h>
 #include <asm/tlbflush.h>
 #include <asm/mce.h>
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 1ae15172885e..74b7a615bc15 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -12,6 +12,7 @@
 #include <linux/sched/mm.h>
 
 #include <asm/tlbflush.h>
+#include <asm/membarrier.h>
 #include <asm/mmu_context.h>
 #include <asm/nospec-branch.h>
 #include <asm/cache.h>
@@ -491,7 +492,7 @@ static void sync_core_if_membarrier_enabled(struct mm_struct *next)
 #ifdef CONFIG_MEMBARRIER
 	if (unlikely(atomic_read(&next->membarrier_state) &
 		     MEMBARRIER_STATE_PRIVATE_EXPEDITED_SYNC_CORE))
-		sync_core_before_usermode();
+		membarrier_sync_core_before_usermode();
 #endif
 }
 
diff --git a/drivers/misc/sgi-gru/grufault.c b/drivers/misc/sgi-gru/grufault.c
index d7ef61e602ed..462c667bd6c4 100644
--- a/drivers/misc/sgi-gru/grufault.c
+++ b/drivers/misc/sgi-gru/grufault.c
@@ -20,8 +20,8 @@
 #include <linux/io.h>
 #include <linux/uaccess.h>
 #include <linux/security.h>
-#include <linux/sync_core.h>
 #include <linux/prefetch.h>
+#include <asm/sync_core.h>
 #include "gru.h"
 #include "grutables.h"
 #include "grulib.h"
diff --git a/drivers/misc/sgi-gru/gruhandles.c b/drivers/misc/sgi-gru/gruhandles.c
index 1d75d5e540bc..c8cba1c1b00f 100644
--- a/drivers/misc/sgi-gru/gruhandles.c
+++ b/drivers/misc/sgi-gru/gruhandles.c
@@ -16,7 +16,7 @@
 #define GRU_OPERATION_TIMEOUT	(((cycles_t) local_cpu_data->itc_freq)*10)
 #define CLKS2NSEC(c)		((c) *1000000000 / local_cpu_data->itc_freq)
 #else
-#include <linux/sync_core.h>
+#include <asm/sync_core.h>
 #include <asm/tsc.h>
 #define GRU_OPERATION_TIMEOUT	((cycles_t) tsc_khz*10*1000)
 #define CLKS2NSEC(c)		((c) * 1000000 / tsc_khz)
diff --git a/drivers/misc/sgi-gru/grukservices.c b/drivers/misc/sgi-gru/grukservices.c
index 0ea923fe6371..ce03ff3f7c3a 100644
--- a/drivers/misc/sgi-gru/grukservices.c
+++ b/drivers/misc/sgi-gru/grukservices.c
@@ -16,10 +16,10 @@
 #include <linux/miscdevice.h>
 #include <linux/proc_fs.h>
 #include <linux/interrupt.h>
-#include <linux/sync_core.h>
 #include <linux/uaccess.h>
 #include <linux/delay.h>
 #include <linux/export.h>
+#include <asm/sync_core.h>
 #include <asm/io_apic.h>
 #include "gru.h"
 #include "grulib.h"
diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
index e8919995d8dd..e107f292fc42 100644
--- a/include/linux/sched/mm.h
+++ b/include/linux/sched/mm.h
@@ -7,7 +7,6 @@
 #include <linux/sched.h>
 #include <linux/mm_types.h>
 #include <linux/gfp.h>
-#include <linux/sync_core.h>
 
 /*
  * Routines for handling mm_structs
diff --git a/include/linux/sync_core.h b/include/linux/sync_core.h
deleted file mode 100644
index 013da4b8b327..000000000000
--- a/include/linux/sync_core.h
+++ /dev/null
@@ -1,21 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _LINUX_SYNC_CORE_H
-#define _LINUX_SYNC_CORE_H
-
-#ifdef CONFIG_ARCH_HAS_SYNC_CORE_BEFORE_USERMODE
-#include <asm/sync_core.h>
-#else
-/*
- * This is a dummy sync_core_before_usermode() implementation that can be used
- * on all architectures which return to user-space through core serializing
- * instructions.
- * If your architecture returns to user-space through non-core-serializing
- * instructions, you need to write your own functions.
- */
-static inline void sync_core_before_usermode(void)
-{
-}
-#endif
-
-#endif /* _LINUX_SYNC_CORE_H */
-
diff --git a/init/Kconfig b/init/Kconfig
index 11f8a845f259..bbaf93f9438b 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -2364,9 +2364,6 @@ source "kernel/Kconfig.locks"
 config ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
 	bool
 
-config ARCH_HAS_SYNC_CORE_BEFORE_USERMODE
-	bool
-
 # It may be useful for an architecture to override the definitions of the
 # SYSCALL_DEFINE() and __SYSCALL_DEFINEx() macros in <linux/syscalls.h>
 # and the COMPAT_ variants in <linux/compat.h>, in particular to use a
diff --git a/kernel/sched/membarrier.c b/kernel/sched/membarrier.c
index 327830f89c37..eb73eeaedc7d 100644
--- a/kernel/sched/membarrier.c
+++ b/kernel/sched/membarrier.c
@@ -5,6 +5,14 @@
  * membarrier system call
  */
 #include "sched.h"
+#ifdef CONFIG_ARCH_HAS_MEMBARRIER_SYNC_CORE
+#include <asm/membarrier.h>
+#else
+static inline void membarrier_sync_core_before_usermode(void)
+{
+	compiletime_assert(0, "architecture does not implement membarrier_sync_core_before_usermode");
+}
+#endif
 
 /*
  * The basic principle behind the regular memory barrier mode of
@@ -231,12 +239,12 @@ static void ipi_sync_core(void *info)
 	 * the big comment at the top of this file.
 	 *
 	 * A sync_core() would provide this guarantee, but
-	 * sync_core_before_usermode() might end up being deferred until
-	 * after membarrier()'s smp_mb().
+	 * membarrier_sync_core_before_usermode() might end up being deferred
+	 * until after membarrier()'s smp_mb().
 	 */
 	smp_mb();	/* IPIs should be serializing but paranoid. */
 
-	sync_core_before_usermode();
+	membarrier_sync_core_before_usermode();
 }
 
 static void ipi_rseq(void *info)
-- 
2.33.1

