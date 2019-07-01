Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C832E2F17F
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730671AbfE3ENJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:13:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:41614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729472AbfE3DQX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:16:23 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6FF6E2449A;
        Thu, 30 May 2019 03:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186182;
        bh=j0dlAoLur82D1+YxWJZQYbmS/2yzEpnrSLMWWUIoKIQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wACgOgQev+iAhBCuWxoPhkJZ559wvNHsED2MmNweSW0YpwmWbL9xOAWky2fHJRYvf
         GN2FnEejAbbfZOKCNEQbBjzMUGy5ugJcx7KqSwQ9mdPxQBCwjdRMl0qjGWW4NX1Fh4
         oL3sAl43NZgux2lf/Tx8R0mVYXRtkva3183Rfj6w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH 4.19 030/276] arm64: errata: Add workaround for Cortex-A76 erratum #1463225
Date:   Wed, 29 May 2019 20:03:08 -0700
Message-Id: <20190530030526.033339430@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030523.133519668@linuxfoundation.org>
References: <20190530030523.133519668@linuxfoundation.org>
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
 arch/arm64/include/asm/cputype.h       |    2 +
 arch/arm64/kernel/cpu_errata.c         |   24 +++++++++++++++++++++
 arch/arm64/kernel/syscall.c            |   31 +++++++++++++++++++++++++++
 arch/arm64/mm/fault.c                  |   37 +++++++++++++++++++++++++++++++--
 7 files changed, 113 insertions(+), 3 deletions(-)

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
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -411,6 +411,22 @@ static bool has_ssbd_mitigation(const st
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
@@ -680,6 +696,14 @@ const struct arm64_cpu_capabilities arm6
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
@@ -827,14 +827,47 @@ void __init hook_debug_fault_code(int nr
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


