Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 681372C597
	for <lists+stable@lfdr.de>; Tue, 28 May 2019 13:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbfE1Lli (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 May 2019 07:41:38 -0400
Received: from foss.arm.com ([217.140.101.70]:55684 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726631AbfE1Lli (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 May 2019 07:41:38 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A51A0341;
        Tue, 28 May 2019 04:41:37 -0700 (PDT)
Received: from fuggles.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.72.51.249])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B8CFD3F59C;
        Tue, 28 May 2019 04:41:36 -0700 (PDT)
Date:   Tue, 28 May 2019 12:41:34 +0100
From:   Will Deacon <will.deacon@arm.com>
To:     gregkh@linuxfoundation.org
Cc:     catalin.marinas@arm.com, marc.zyngier@arm.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] arm64: errata: Add workaround for
 Cortex-A76 erratum #1463225" failed to apply to 4.19-stable tree
Message-ID: <20190528114134.GE20809@fuggles.cambridge.arm.com>
References: <1558965280174196@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1558965280174196@kroah.com>
User-Agent: Mutt/1.11.1+86 (6f28e57d73f2) ()
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 27, 2019 at 03:54:40PM +0200, gregkh@linuxfoundation.org wrote:
> The patch below does not apply to the 4.19-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Backport for 4.19 *only* below.

Will

--->8

From 6d5e076c1f75bdc20398cb6312690cfa877166e9 Mon Sep 17 00:00:00 2001
From: Will Deacon <will.deacon@arm.com>
Date: Mon, 29 Apr 2019 13:03:57 +0100
Subject: [PATCH] arm64: errata: Add workaround for Cortex-A76 erratum #1463225

Commit 969f5ea627570e91c9d54403287ee3ed657f58fe upstream.

Revisions of the Cortex-A76 CPU prior to r4p0 are affected by an erratum
that can prevent interrupts from being taken when single-stepping.

This patch implements a software workaround to prevent userspace from
effectively being able to disable interrupts.

Cc: <stable@vger.kernel.org> # 4.19
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 Documentation/arm64/silicon-errata.txt |  1 +
 arch/arm64/Kconfig                     | 18 +++++++++++++++++
 arch/arm64/include/asm/cpucaps.h       |  3 ++-
 arch/arm64/include/asm/cputype.h       |  2 ++
 arch/arm64/kernel/cpu_errata.c         | 24 ++++++++++++++++++++++
 arch/arm64/kernel/syscall.c            | 31 ++++++++++++++++++++++++++++
 arch/arm64/mm/fault.c                  | 37 ++++++++++++++++++++++++++++++++--
 7 files changed, 113 insertions(+), 3 deletions(-)

diff --git a/Documentation/arm64/silicon-errata.txt b/Documentation/arm64/silicon-errata.txt
index 3c6fc2e08d04..eeb3fc9d777b 100644
--- a/Documentation/arm64/silicon-errata.txt
+++ b/Documentation/arm64/silicon-errata.txt
@@ -58,6 +58,7 @@ stable kernels.
 | ARM            | Cortex-A72      | #853709         | N/A                         |
 | ARM            | Cortex-A73      | #858921         | ARM64_ERRATUM_858921        |
 | ARM            | Cortex-A55      | #1024718        | ARM64_ERRATUM_1024718       |
+| ARM            | Cortex-A76      | #1463225        | ARM64_ERRATUM_1463225       |
 | ARM            | MMU-500         | #841119,#826419 | N/A                         |
 |                |                 |                 |                             |
 | Cavium         | ThunderX ITS    | #22375, #24313  | CAVIUM_ERRATUM_22375        |
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 1b1a0e95c751..8790a29d0af4 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -479,6 +479,24 @@ config ARM64_ERRATUM_1024718
 
 	  If unsure, say Y.
 
+config ARM64_ERRATUM_1463225
+	bool "Cortex-A76: Software Step might prevent interrupt recognition"
+	default y
+	help
+	  This option adds a workaround for Arm Cortex-A76 erratum 1463225.
+
+	  On the affected Cortex-A76 cores (r0p0 to r3p1), software stepping
+	  of a system call instruction (SVC) can prevent recognition of
+	  subsequent interrupts when software stepping is disabled in the
+	  exception handler of the system call and either kernel debugging
+	  is enabled or VHE is in use.
+
+	  Work around the erratum by triggering a dummy step exception
+	  when handling a system call from a task that is being stepped
+	  in a VHE configuration of the kernel.
+
+	  If unsure, say Y.
+
 config CAVIUM_ERRATUM_22375
 	bool "Cavium erratum 22375, 24313"
 	default y
diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index ae1f70450fb2..25ce9056cf64 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -51,7 +51,8 @@
 #define ARM64_SSBD				30
 #define ARM64_MISMATCHED_CACHE_TYPE		31
 #define ARM64_HAS_STAGE2_FWB			32
+#define ARM64_WORKAROUND_1463225		33
 
-#define ARM64_NCAPS				33
+#define ARM64_NCAPS				34
 
 #endif /* __ASM_CPUCAPS_H */
diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index ea690b3562af..b4a48419769f 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -86,6 +86,7 @@
 #define ARM_CPU_PART_CORTEX_A75		0xD0A
 #define ARM_CPU_PART_CORTEX_A35		0xD04
 #define ARM_CPU_PART_CORTEX_A55		0xD05
+#define ARM_CPU_PART_CORTEX_A76		0xD0B
 
 #define APM_CPU_PART_POTENZA		0x000
 
@@ -110,6 +111,7 @@
 #define MIDR_CORTEX_A75 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A75)
 #define MIDR_CORTEX_A35 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A35)
 #define MIDR_CORTEX_A55 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A55)
+#define MIDR_CORTEX_A76 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A76)
 #define MIDR_THUNDERX	MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX)
 #define MIDR_THUNDERX_81XX MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX_81XX)
 #define MIDR_THUNDERX_83XX MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX_83XX)
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index dec10898d688..dc6c535cbd13 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -411,6 +411,22 @@ static bool has_ssbd_mitigation(const struct arm64_cpu_capabilities *entry,
 }
 #endif	/* CONFIG_ARM64_SSBD */
 
+#ifdef CONFIG_ARM64_ERRATUM_1463225
+DEFINE_PER_CPU(int, __in_cortex_a76_erratum_1463225_wa);
+
+static bool
+has_cortex_a76_erratum_1463225(const struct arm64_cpu_capabilities *entry,
+			       int scope)
+{
+	u32 midr = read_cpuid_id();
+	/* Cortex-A76 r0p0 - r3p1 */
+	struct midr_range range = MIDR_RANGE(MIDR_CORTEX_A76, 0, 0, 3, 1);
+
+	WARN_ON(scope != SCOPE_LOCAL_CPU || preemptible());
+	return is_midr_in_range(midr, &range) && is_kernel_in_hyp_mode();
+}
+#endif
+
 #define CAP_MIDR_RANGE(model, v_min, r_min, v_max, r_max)	\
 	.matches = is_affected_midr_range,			\
 	.midr_range = MIDR_RANGE(model, v_min, r_min, v_max, r_max)
@@ -680,6 +696,14 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		.matches = has_ssbd_mitigation,
 	},
 #endif
+#ifdef CONFIG_ARM64_ERRATUM_1463225
+	{
+		.desc = "ARM erratum 1463225",
+		.capability = ARM64_WORKAROUND_1463225,
+		.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,
+		.matches = has_cortex_a76_erratum_1463225,
+	},
+#endif
 	{
 	}
 };
diff --git a/arch/arm64/kernel/syscall.c b/arch/arm64/kernel/syscall.c
index 5610ac01c1ec..871c739f060a 100644
--- a/arch/arm64/kernel/syscall.c
+++ b/arch/arm64/kernel/syscall.c
@@ -8,6 +8,7 @@
 #include <linux/syscalls.h>
 
 #include <asm/daifflags.h>
+#include <asm/debug-monitors.h>
 #include <asm/fpsimd.h>
 #include <asm/syscall.h>
 #include <asm/thread_info.h>
@@ -60,6 +61,35 @@ static inline bool has_syscall_work(unsigned long flags)
 int syscall_trace_enter(struct pt_regs *regs);
 void syscall_trace_exit(struct pt_regs *regs);
 
+#ifdef CONFIG_ARM64_ERRATUM_1463225
+DECLARE_PER_CPU(int, __in_cortex_a76_erratum_1463225_wa);
+
+static void cortex_a76_erratum_1463225_svc_handler(void)
+{
+	u32 reg, val;
+
+	if (!unlikely(test_thread_flag(TIF_SINGLESTEP)))
+		return;
+
+	if (!unlikely(this_cpu_has_cap(ARM64_WORKAROUND_1463225)))
+		return;
+
+	__this_cpu_write(__in_cortex_a76_erratum_1463225_wa, 1);
+	reg = read_sysreg(mdscr_el1);
+	val = reg | DBG_MDSCR_SS | DBG_MDSCR_KDE;
+	write_sysreg(val, mdscr_el1);
+	asm volatile("msr daifclr, #8");
+	isb();
+
+	/* We will have taken a single-step exception by this point */
+
+	write_sysreg(reg, mdscr_el1);
+	__this_cpu_write(__in_cortex_a76_erratum_1463225_wa, 0);
+}
+#else
+static void cortex_a76_erratum_1463225_svc_handler(void) { }
+#endif /* CONFIG_ARM64_ERRATUM_1463225 */
+
 static void el0_svc_common(struct pt_regs *regs, int scno, int sc_nr,
 			   const syscall_fn_t syscall_table[])
 {
@@ -68,6 +98,7 @@ static void el0_svc_common(struct pt_regs *regs, int scno, int sc_nr,
 	regs->orig_x0 = regs->regs[0];
 	regs->syscallno = scno;
 
+	cortex_a76_erratum_1463225_svc_handler();
 	local_daif_restore(DAIF_PROCCTX);
 	user_exit();
 
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index a4c134677285..88cf0a0cb616 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -827,14 +827,47 @@ void __init hook_debug_fault_code(int nr,
 	debug_fault_info[nr].name	= name;
 }
 
+#ifdef CONFIG_ARM64_ERRATUM_1463225
+DECLARE_PER_CPU(int, __in_cortex_a76_erratum_1463225_wa);
+
+static int __exception
+cortex_a76_erratum_1463225_debug_handler(struct pt_regs *regs)
+{
+	if (user_mode(regs))
+		return 0;
+
+	if (!__this_cpu_read(__in_cortex_a76_erratum_1463225_wa))
+		return 0;
+
+	/*
+	 * We've taken a dummy step exception from the kernel to ensure
+	 * that interrupts are re-enabled on the syscall path. Return back
+	 * to cortex_a76_erratum_1463225_svc_handler() with debug exceptions
+	 * masked so that we can safely restore the mdscr and get on with
+	 * handling the syscall.
+	 */
+	regs->pstate |= PSR_D_BIT;
+	return 1;
+}
+#else
+static int __exception
+cortex_a76_erratum_1463225_debug_handler(struct pt_regs *regs)
+{
+	return 0;
+}
+#endif /* CONFIG_ARM64_ERRATUM_1463225 */
+
 asmlinkage int __exception do_debug_exception(unsigned long addr_if_watchpoint,
-					      unsigned int esr,
-					      struct pt_regs *regs)
+					       unsigned int esr,
+					       struct pt_regs *regs)
 {
 	const struct fault_info *inf = debug_fault_info + DBG_ESR_EVT(esr);
 	unsigned long pc = instruction_pointer(regs);
 	int rv;
 
+	if (cortex_a76_erratum_1463225_debug_handler(regs))
+		return 0;
+
 	/*
 	 * Tell lockdep we disabled irqs in entry.S. Do nothing if they were
 	 * already disabled to preserve the last enabled/disabled addresses.
-- 
2.11.0

