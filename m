Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7E93A8F4D
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 05:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbhFPDX2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 23:23:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:42962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230267AbhFPDX0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 23:23:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D051F613C7;
        Wed, 16 Jun 2021 03:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623813681;
        bh=c1mW/zRWUMzz2nK2JXBUnfYw2Qug1l+u6NJy058tCKU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B70I5bf52TGkG4s1VVE6Hd7Y7ayRYIqoQY+VCilqwGmR637HAkxETW5LDO2WUAU41
         JPrMUMhJxEVryOCY1LLy6bILDYQkRx/Up5OfTCeWH1y8+ocLCbPZKDINW09hhWUMhf
         x/iKZE8FCbJ1rxisppx4MLiLiEzDxLiSKnuAbNbxuObVxTQGxiJsQwt8JbAwy86JJb
         5d2zQrZFSt6N3/cbRkVui0tket2wwvCsLk4YOXvILUCJUWirQLDg8Frqib8KziXQLk
         ysBwfFSYxXKB/Jb9ME6MVI7PetyyF1uTaBSC8eXu4Av1hnsrGlkvApjo+ZhKswSnv/
         m6AaPR7Pa2FhA==
From:   Andy Lutomirski <luto@kernel.org>
To:     x86@kernel.org
Cc:     Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, Nicholas Piggin <npiggin@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Peter Zijlstra <peterz@infradead.org>, stable@vger.kernel.org
Subject: [PATCH 8/8] membarrier: Rewrite sync_core_before_usermode() and improve documentation
Date:   Tue, 15 Jun 2021 20:21:13 -0700
Message-Id: <07a8b963002cb955b7516e61bad19514a3acaa82.1623813516.git.luto@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1623813516.git.luto@kernel.org>
References: <cover.1623813516.git.luto@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The old sync_core_before_usermode() comments suggested that a non-icache-syncing
return-to-usermode instruction is x86-specific and that all other
architectures automatically notice cross-modified code on return to
userspace.

This is misleading.  The incantation needed to modify code from one
CPU and execute it on another CPU is highly architecture dependent.
On x86, according to the SDM, one must modify the code, issue SFENCE
if the modification was WC or nontemporal, and then issue a "serializing
instruction" on the CPU that will execute the code.  membarrier() can do
the latter.

On arm64 and powerpc, one must flush the icache and then flush the pipeline
on the target CPU, although the CPU manuals don't necessarily use this
language.

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
Fixes: 70216e18e519 ("membarrier: Provide core serializing command, *_SYNC_CORE")
Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 .../membarrier-sync-core/arch-support.txt     | 68 ++++++-------------
 arch/arm64/include/asm/sync_core.h            | 19 ++++++
 arch/powerpc/include/asm/sync_core.h          | 14 ++++
 arch/x86/Kconfig                              |  1 -
 arch/x86/include/asm/sync_core.h              |  7 +-
 arch/x86/kernel/alternative.c                 |  2 +-
 arch/x86/kernel/cpu/mce/core.c                |  2 +-
 arch/x86/mm/tlb.c                             |  3 +-
 drivers/misc/sgi-gru/grufault.c               |  2 +-
 drivers/misc/sgi-gru/gruhandles.c             |  2 +-
 drivers/misc/sgi-gru/grukservices.c           |  2 +-
 include/linux/sched/mm.h                      |  1 -
 include/linux/sync_core.h                     | 21 ------
 init/Kconfig                                  |  3 -
 kernel/sched/membarrier.c                     | 15 ++--
 15 files changed, 75 insertions(+), 87 deletions(-)
 create mode 100644 arch/arm64/include/asm/sync_core.h
 create mode 100644 arch/powerpc/include/asm/sync_core.h
 delete mode 100644 include/linux/sync_core.h

diff --git a/Documentation/features/sched/membarrier-sync-core/arch-support.txt b/Documentation/features/sched/membarrier-sync-core/arch-support.txt
index 883d33b265d6..41c9ebcb275f 100644
--- a/Documentation/features/sched/membarrier-sync-core/arch-support.txt
+++ b/Documentation/features/sched/membarrier-sync-core/arch-support.txt
@@ -5,51 +5,25 @@
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
+# Kconfig.Unfortunately, MEMBARRIER_CMD_PRIVATE_EXPEDITED_SYNC_CORE is not a
+# fantastic API and may not make sense on all architectures.  Once an
+# architecture meets these requirements,
+#
+# On x86, a program can safely modify code, issue
+# MEMBARRIER_CMD_PRIVATE_EXPEDITED_SYNC_CORE, and then execute that code, via
+# the modified address or an alias, from any thread in the calling process.
+#
+# On arm64, a program can modify code, flush the icache as needed, and issue
+# MEMBARRIER_CMD_PRIVATE_EXPEDITED_SYNC_CORE to force a "context synchronizing
+# event", aka pipeline flush on all CPUs that might run the calling process.
+# Then the program can execute the modified code as long as it is executed
+# from an address consistent with the icache flush and the CPU's cache type.
+#
+# On powerpc, a program can use MEMBARRIER_CMD_PRIVATE_EXPEDITED_SYNC_CORE
+# similarly to arm64.  It would be nice if the powerpc maintainers could
+# add a more clear explanantion.
diff --git a/arch/arm64/include/asm/sync_core.h b/arch/arm64/include/asm/sync_core.h
new file mode 100644
index 000000000000..74996bf533bb
--- /dev/null
+++ b/arch/arm64/include/asm/sync_core.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_ARM64_SYNC_CORE_H
+#define _ASM_ARM64_SYNC_CORE_H
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
+#endif /* _ASM_ARM64_SYNC_CORE_H */
diff --git a/arch/powerpc/include/asm/sync_core.h b/arch/powerpc/include/asm/sync_core.h
new file mode 100644
index 000000000000..589fdb34beab
--- /dev/null
+++ b/arch/powerpc/include/asm/sync_core.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_POWERPC_SYNC_CORE_H
+#define _ASM_POWERPC_SYNC_CORE_H
+
+#include <asm/barrier.h>
+
+/*
+ * XXX: can a powerpc person put an appropriate comment here?
+ */
+static inline void membarrier_sync_core_before_usermode(void)
+{
+}
+
+#endif /* _ASM_POWERPC_SYNC_CORE_H */
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 0045e1b44190..f010897a1e8a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -89,7 +89,6 @@ config X86
 	select ARCH_HAS_SET_DIRECT_MAP
 	select ARCH_HAS_STRICT_KERNEL_RWX
 	select ARCH_HAS_STRICT_MODULE_RWX
-	select ARCH_HAS_SYNC_CORE_BEFORE_USERMODE
 	select ARCH_HAS_SYSCALL_WRAPPER
 	select ARCH_HAS_UBSAN_SANITIZE_ALL
 	select ARCH_HAS_DEBUG_WX
diff --git a/arch/x86/include/asm/sync_core.h b/arch/x86/include/asm/sync_core.h
index ab7382f92aff..c665b453969a 100644
--- a/arch/x86/include/asm/sync_core.h
+++ b/arch/x86/include/asm/sync_core.h
@@ -89,11 +89,10 @@ static inline void sync_core(void)
 }
 
 /*
- * Ensure that a core serializing instruction is issued before returning
- * to user-mode. x86 implements return to user-space through sysexit,
- * sysrel, and sysretq, which are not core serializing.
+ * Ensure that the CPU notices any instruction changes before the next time
+ * it returns to usermode.
  */
-static inline void sync_core_before_usermode(void)
+static inline void membarrier_sync_core_before_usermode(void)
 {
 	/* With PTI, we unconditionally serialize before running user code. */
 	if (static_cpu_has(X86_FEATURE_PTI))
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 6974b5174495..52ead5f4fcdc 100644
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
index bf7fe87a7e88..4a577980d4d1 100644
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
index 59488d663e68..35b622fd2ed1 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -11,6 +11,7 @@
 #include <linux/sched/mm.h>
 
 #include <asm/tlbflush.h>
+#include <asm/sync_core.h>
 #include <asm/mmu_context.h>
 #include <asm/nospec-branch.h>
 #include <asm/cache.h>
@@ -538,7 +539,7 @@ void switch_mm_irqs_off(struct mm_struct *prev, struct mm_struct *next,
 			 */
 			if (unlikely(atomic_read(&next->membarrier_state) &
 				     MEMBARRIER_STATE_PRIVATE_EXPEDITED_SYNC_CORE))
-				sync_core_before_usermode();
+				membarrier_sync_core_before_usermode();
 #endif
 
 			return;
diff --git a/drivers/misc/sgi-gru/grufault.c b/drivers/misc/sgi-gru/grufault.c
index 723825524ea0..48fd5b101de1 100644
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
index c6eebbafadb0..845db11190cd 100644
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
index 1ea12c64e4c9..e5d552b0823e 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -2377,9 +2377,6 @@ source "kernel/Kconfig.locks"
 config ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
 	bool
 
-config ARCH_HAS_SYNC_CORE_BEFORE_USERMODE
-	bool
-
 # It may be useful for an architecture to override the definitions of the
 # SYSCALL_DEFINE() and __SYSCALL_DEFINEx() macros in <linux/syscalls.h>
 # and the COMPAT_ variants in <linux/compat.h>, in particular to use a
diff --git a/kernel/sched/membarrier.c b/kernel/sched/membarrier.c
index c32c32a2441e..f72a6ab3fac2 100644
--- a/kernel/sched/membarrier.c
+++ b/kernel/sched/membarrier.c
@@ -5,6 +5,9 @@
  * membarrier system call
  */
 #include "sched.h"
+#ifdef CONFIG_ARCH_HAS_MEMBARRIER_SYNC_CORE
+#include <asm/sync_core.h>
+#endif
 
 /*
  * The basic principle behind the regular memory barrier mode of membarrier()
@@ -221,6 +224,7 @@ static void ipi_mb(void *info)
 	smp_mb();	/* IPIs should be serializing but paranoid. */
 }
 
+#ifdef CONFIG_ARCH_HAS_MEMBARRIER_SYNC_CORE
 static void ipi_sync_core(void *info)
 {
 	/*
@@ -230,13 +234,14 @@ static void ipi_sync_core(void *info)
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
+#endif
 
 static void ipi_rseq(void *info)
 {
@@ -368,12 +373,14 @@ static int membarrier_private_expedited(int flags, int cpu_id)
 	smp_call_func_t ipi_func = ipi_mb;
 
 	if (flags == MEMBARRIER_FLAG_SYNC_CORE) {
-		if (!IS_ENABLED(CONFIG_ARCH_HAS_MEMBARRIER_SYNC_CORE))
+#ifndef CONFIG_ARCH_HAS_MEMBARRIER_SYNC_CORE
 			return -EINVAL;
+#else
 		if (!(atomic_read(&mm->membarrier_state) &
 		      MEMBARRIER_STATE_PRIVATE_EXPEDITED_SYNC_CORE_READY))
 			return -EPERM;
 		ipi_func = ipi_sync_core;
+#endif
 	} else if (flags == MEMBARRIER_FLAG_RSEQ) {
 		if (!IS_ENABLED(CONFIG_RSEQ))
 			return -EINVAL;
-- 
2.31.1

