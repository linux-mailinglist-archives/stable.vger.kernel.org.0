Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFA332F6CF
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 07:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727673AbfE3DJh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:09:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:44694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727663AbfE3DJh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:09:37 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 270462448E;
        Thu, 30 May 2019 03:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185776;
        bh=zSdNoWLi7DzaPV9mNqnkEQ+YTFMlkL5rHOvndssRU3c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rzbe8CsGWsSB4j4nT6lUVrruH+HP0DlFZmafJtmll/GOU2lCYiaxJBGWt4hwZJ9TL
         pu7JsmQHIEyyQAqZaIkQpxTvDWyQEpCAJi6gmOLPMlVaBk9yaXU1UoYibcU24WjRg0
         hAPG5Kg8Y6TVqQbWrVHsKwOy2FrUfFxnOb4pD7tw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH 5.1 031/405] arm64: errata: Add workaround for Cortex-A76 erratum #1463225
Date:   Wed, 29 May 2019 20:00:29 -0700
Message-Id: <20190530030542.291832598@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will.deacon@arm.com>

commit 969f5ea627570e91c9d54403287ee3ed657f58fe upstream.

Revisions of the Cortex-A76 CPU prior to r4p0 are affected by an erratum
that can prevent interrupts from being taken when single-stepping.

This patch implements a software workaround to prevent userspace from
effectively being able to disable interrupts.

Cc: <stable@vger.kernel.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 Documentation/arm64/silicon-errata.txt |    1 
 arch/arm64/Kconfig                     |   18 ++++++++++++++++
 arch/arm64/include/asm/cpucaps.h       |    3 +-
 arch/arm64/kernel/cpu_errata.c         |   24 +++++++++++++++++++++
 arch/arm64/kernel/syscall.c            |   31 +++++++++++++++++++++++++++
 arch/arm64/mm/fault.c                  |   37 +++++++++++++++++++++++++++++++--
 6 files changed, 111 insertions(+), 3 deletions(-)

--- a/Documentation/arm64/silicon-errata.txt
+++ b/Documentation/arm64/silicon-errata.txt
@@ -61,6 +61,7 @@ stable kernels.
 | ARM            | Cortex-A76      | #1188873        | ARM64_ERRATUM_1188873       |
 | ARM            | Cortex-A76      | #1165522        | ARM64_ERRATUM_1165522       |
 | ARM            | Cortex-A76      | #1286807        | ARM64_ERRATUM_1286807       |
+| ARM            | Cortex-A76      | #1463225        | ARM64_ERRATUM_1463225       |
 | ARM            | MMU-500         | #841119,#826419 | N/A                         |
 |                |                 |                 |                             |
 | Cavium         | ThunderX ITS    | #22375, #24313  | CAVIUM_ERRATUM_22375        |
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -517,6 +517,24 @@ config ARM64_ERRATUM_1286807
 
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
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -61,7 +61,8 @@
 #define ARM64_HAS_GENERIC_AUTH_ARCH		40
 #define ARM64_HAS_GENERIC_AUTH_IMP_DEF		41
 #define ARM64_HAS_IRQ_PRIO_MASKING		42
+#define ARM64_WORKAROUND_1463225		43
 
-#define ARM64_NCAPS				43
+#define ARM64_NCAPS				44
 
 #endif /* __ASM_CPUCAPS_H */
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -464,6 +464,22 @@ out_printmsg:
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
 static void __maybe_unused
 cpu_enable_cache_maint_trap(const struct arm64_cpu_capabilities *__unused)
 {
@@ -739,6 +755,14 @@ const struct arm64_cpu_capabilities arm6
 		ERRATA_MIDR_RANGE(MIDR_CORTEX_A76, 0, 0, 2, 0),
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
--- a/arch/arm64/kernel/syscall.c
+++ b/arch/arm64/kernel/syscall.c
@@ -8,6 +8,7 @@
 #include <linux/syscalls.h>
 
 #include <asm/daifflags.h>
+#include <asm/debug-monitors.h>
 #include <asm/fpsimd.h>
 #include <asm/syscall.h>
 #include <asm/thread_info.h>
@@ -60,6 +61,35 @@ static inline bool has_syscall_work(unsi
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
@@ -68,6 +98,7 @@ static void el0_svc_common(struct pt_reg
 	regs->orig_x0 = regs->regs[0];
 	regs->syscallno = scno;
 
+	cortex_a76_erratum_1463225_svc_handler();
 	local_daif_restore(DAIF_PROCCTX);
 	user_exit();
 
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -810,14 +810,47 @@ void __init hook_debug_fault_code(int nr
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
 	const struct fault_info *inf = esr_to_debug_fault_info(esr);
 	unsigned long pc = instruction_pointer(regs);
 	int rv;
 
+	if (cortex_a76_erratum_1463225_debug_handler(regs))
+		return 0;
+
 	/*
 	 * Tell lockdep we disabled irqs in entry.S. Do nothing if they were
 	 * already disabled to preserve the last enabled/disabled addresses.


