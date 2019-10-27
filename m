Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA5BE6942
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:35:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728033AbfJ0VI5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:08:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:55244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728376AbfJ0VIz (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:08:55 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DD602064A;
        Sun, 27 Oct 2019 21:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210534;
        bh=DFBDX2o+e4nTPAuliNaTnHS+fX4dZnsAQfoZJkiDcko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IhxHU81XI440tLwNs9kJHNsarmB0BD4xazrDphN37wZR5s1TKTVdFcXnYe/n1ZBDn
         /xFW7/89fXAExsgk2vqMt6Am/X+eWH/1UktGQubFnrWSa0b/rwLBvzkAUj+EQWFaHg
         aVmbX7gjgXBcFb9iRfaetLAvrN4eT5sj5Pl765kg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        James Morse <james.morse@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Julien Thierry <julien.thierry@arm.com>,
        Dave Martin <dave.martin@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 4.14 046/119] arm64: capabilities: Update prototype for enable call back
Date:   Sun, 27 Oct 2019 22:00:23 +0100
Message-Id: <20191027203318.437844762@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203259.948006506@linuxfoundation.org>
References: <20191027203259.948006506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Martin <dave.martin@arm.com>

[ Upstream commit c0cda3b8ee6b4b6851b2fd8b6db91fd7b0e2524a ]

We issue the enable() call back for all CPU hwcaps capabilities
available on the system, on all the CPUs. So far we have ignored
the argument passed to the call back, which had a prototype to
accept a "void *" for use with on_each_cpu() and later with
stop_machine(). However, with commit 0a0d111d40fd1
("arm64: cpufeature: Pass capability structure to ->enable callback"),
there are some users of the argument who wants the matching capability
struct pointer where there are multiple matching criteria for a single
capability. Clean up the declaration of the call back to make it clear.

 1) Renamed to cpu_enable(), to imply taking necessary actions on the
    called CPU for the entry.
 2) Pass const pointer to the capability, to allow the call back to
    check the entry. (e.,g to check if any action is needed on the CPU)
 3) We don't care about the result of the call back, turning this to
    a void.

Cc: Will Deacon <will.deacon@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Andre Przywara <andre.przywara@arm.com>
Cc: James Morse <james.morse@arm.com>
Acked-by: Robin Murphy <robin.murphy@arm.com>
Reviewed-by: Julien Thierry <julien.thierry@arm.com>
Signed-off-by: Dave Martin <dave.martin@arm.com>
[suzuki: convert more users, rename call back and drop results]
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/cpufeature.h |    7 +++-
 arch/arm64/include/asm/processor.h  |    5 +--
 arch/arm64/kernel/cpu_errata.c      |   55 +++++++++++++++++-------------------
 arch/arm64/kernel/cpufeature.c      |   34 +++++++++++++---------
 arch/arm64/kernel/fpsimd.c          |    1 
 arch/arm64/kernel/traps.c           |    4 +-
 arch/arm64/mm/fault.c               |    3 -
 7 files changed, 60 insertions(+), 49 deletions(-)

--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -96,7 +96,12 @@ struct arm64_cpu_capabilities {
 	u16 capability;
 	int def_scope;			/* default scope */
 	bool (*matches)(const struct arm64_cpu_capabilities *caps, int scope);
-	int (*enable)(void *);		/* Called on all active CPUs */
+	/*
+	 * Take the appropriate actions to enable this capability for this CPU.
+	 * For each successfully booted CPU, this method is called for each
+	 * globally detected capability.
+	 */
+	void (*cpu_enable)(const struct arm64_cpu_capabilities *cap);
 	union {
 		struct {	/* To be used for erratum handling only */
 			u32 midr_model;
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -37,6 +37,7 @@
 #include <linux/string.h>
 
 #include <asm/alternative.h>
+#include <asm/cpufeature.h>
 #include <asm/fpsimd.h>
 #include <asm/hw_breakpoint.h>
 #include <asm/lse.h>
@@ -222,8 +223,8 @@ static inline void spin_lock_prefetch(co
 
 #endif
 
-int cpu_enable_pan(void *__unused);
-int cpu_enable_cache_maint_trap(void *__unused);
+void cpu_enable_pan(const struct arm64_cpu_capabilities *__unused);
+void cpu_enable_cache_maint_trap(const struct arm64_cpu_capabilities *__unused);
 
 #endif /* __ASSEMBLY__ */
 #endif /* __ASM_PROCESSOR_H */
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -61,11 +61,11 @@ has_mismatched_cache_type(const struct a
 	       (arm64_ftr_reg_ctrel0.sys_val & mask);
 }
 
-static int cpu_enable_trap_ctr_access(void *__unused)
+static void
+cpu_enable_trap_ctr_access(const struct arm64_cpu_capabilities *__unused)
 {
 	/* Clear SCTLR_EL1.UCT */
 	config_sctlr_el1(SCTLR_EL1_UCT, 0);
-	return 0;
 }
 
 #ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
@@ -169,25 +169,25 @@ static void call_hvc_arch_workaround_1(v
 	arm_smccc_1_1_hvc(ARM_SMCCC_ARCH_WORKAROUND_1, NULL);
 }
 
-static int enable_smccc_arch_workaround_1(void *data)
+static void
+enable_smccc_arch_workaround_1(const struct arm64_cpu_capabilities *entry)
 {
-	const struct arm64_cpu_capabilities *entry = data;
 	bp_hardening_cb_t cb;
 	void *smccc_start, *smccc_end;
 	struct arm_smccc_res res;
 
 	if (!entry->matches(entry, SCOPE_LOCAL_CPU))
-		return 0;
+		return;
 
 	if (psci_ops.smccc_version == SMCCC_VERSION_1_0)
-		return 0;
+		return;
 
 	switch (psci_ops.conduit) {
 	case PSCI_CONDUIT_HVC:
 		arm_smccc_1_1_hvc(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
 				  ARM_SMCCC_ARCH_WORKAROUND_1, &res);
 		if ((int)res.a0 < 0)
-			return 0;
+			return;
 		cb = call_hvc_arch_workaround_1;
 		smccc_start = __smccc_workaround_1_hvc_start;
 		smccc_end = __smccc_workaround_1_hvc_end;
@@ -197,19 +197,19 @@ static int enable_smccc_arch_workaround_
 		arm_smccc_1_1_smc(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
 				  ARM_SMCCC_ARCH_WORKAROUND_1, &res);
 		if ((int)res.a0 < 0)
-			return 0;
+			return;
 		cb = call_smc_arch_workaround_1;
 		smccc_start = __smccc_workaround_1_smc_start;
 		smccc_end = __smccc_workaround_1_smc_end;
 		break;
 
 	default:
-		return 0;
+		return;
 	}
 
 	install_bp_hardening_cb(entry, cb, smccc_start, smccc_end);
 
-	return 0;
+	return;
 }
 
 static void qcom_link_stack_sanitization(void)
@@ -224,15 +224,12 @@ static void qcom_link_stack_sanitization
 		     : "=&r" (tmp));
 }
 
-static int qcom_enable_link_stack_sanitization(void *data)
+static void
+qcom_enable_link_stack_sanitization(const struct arm64_cpu_capabilities *entry)
 {
-	const struct arm64_cpu_capabilities *entry = data;
-
 	install_bp_hardening_cb(entry, qcom_link_stack_sanitization,
 				__qcom_hyp_sanitize_link_stack_start,
 				__qcom_hyp_sanitize_link_stack_end);
-
-	return 0;
 }
 #endif	/* CONFIG_HARDEN_BRANCH_PREDICTOR */
 
@@ -431,7 +428,7 @@ const struct arm64_cpu_capabilities arm6
 		.desc = "ARM errata 826319, 827319, 824069",
 		.capability = ARM64_WORKAROUND_CLEAN_CACHE,
 		MIDR_RANGE(MIDR_CORTEX_A53, 0x00, 0x02),
-		.enable = cpu_enable_cache_maint_trap,
+		.cpu_enable = cpu_enable_cache_maint_trap,
 	},
 #endif
 #ifdef CONFIG_ARM64_ERRATUM_819472
@@ -440,7 +437,7 @@ const struct arm64_cpu_capabilities arm6
 		.desc = "ARM errata 819472",
 		.capability = ARM64_WORKAROUND_CLEAN_CACHE,
 		MIDR_RANGE(MIDR_CORTEX_A53, 0x00, 0x01),
-		.enable = cpu_enable_cache_maint_trap,
+		.cpu_enable = cpu_enable_cache_maint_trap,
 	},
 #endif
 #ifdef CONFIG_ARM64_ERRATUM_832075
@@ -521,14 +518,14 @@ const struct arm64_cpu_capabilities arm6
 		.capability = ARM64_MISMATCHED_CACHE_LINE_SIZE,
 		.matches = has_mismatched_cache_type,
 		.def_scope = SCOPE_LOCAL_CPU,
-		.enable = cpu_enable_trap_ctr_access,
+		.cpu_enable = cpu_enable_trap_ctr_access,
 	},
 	{
 		.desc = "Mismatched cache type",
 		.capability = ARM64_MISMATCHED_CACHE_TYPE,
 		.matches = has_mismatched_cache_type,
 		.def_scope = SCOPE_LOCAL_CPU,
-		.enable = cpu_enable_trap_ctr_access,
+		.cpu_enable = cpu_enable_trap_ctr_access,
 	},
 #ifdef CONFIG_QCOM_FALKOR_ERRATUM_1003
 	{
@@ -567,27 +564,27 @@ const struct arm64_cpu_capabilities arm6
 	{
 		.capability = ARM64_HARDEN_BRANCH_PREDICTOR,
 		MIDR_ALL_VERSIONS(MIDR_CORTEX_A57),
-		.enable = enable_smccc_arch_workaround_1,
+		.cpu_enable = enable_smccc_arch_workaround_1,
 	},
 	{
 		.capability = ARM64_HARDEN_BRANCH_PREDICTOR,
 		MIDR_ALL_VERSIONS(MIDR_CORTEX_A72),
-		.enable = enable_smccc_arch_workaround_1,
+		.cpu_enable = enable_smccc_arch_workaround_1,
 	},
 	{
 		.capability = ARM64_HARDEN_BRANCH_PREDICTOR,
 		MIDR_ALL_VERSIONS(MIDR_CORTEX_A73),
-		.enable = enable_smccc_arch_workaround_1,
+		.cpu_enable = enable_smccc_arch_workaround_1,
 	},
 	{
 		.capability = ARM64_HARDEN_BRANCH_PREDICTOR,
 		MIDR_ALL_VERSIONS(MIDR_CORTEX_A75),
-		.enable = enable_smccc_arch_workaround_1,
+		.cpu_enable = enable_smccc_arch_workaround_1,
 	},
 	{
 		.capability = ARM64_HARDEN_BRANCH_PREDICTOR,
 		MIDR_ALL_VERSIONS(MIDR_QCOM_FALKOR_V1),
-		.enable = qcom_enable_link_stack_sanitization,
+		.cpu_enable = qcom_enable_link_stack_sanitization,
 	},
 	{
 		.capability = ARM64_HARDEN_BP_POST_GUEST_EXIT,
@@ -596,7 +593,7 @@ const struct arm64_cpu_capabilities arm6
 	{
 		.capability = ARM64_HARDEN_BRANCH_PREDICTOR,
 		MIDR_ALL_VERSIONS(MIDR_QCOM_FALKOR),
-		.enable = qcom_enable_link_stack_sanitization,
+		.cpu_enable = qcom_enable_link_stack_sanitization,
 	},
 	{
 		.capability = ARM64_HARDEN_BP_POST_GUEST_EXIT,
@@ -605,12 +602,12 @@ const struct arm64_cpu_capabilities arm6
 	{
 		.capability = ARM64_HARDEN_BRANCH_PREDICTOR,
 		MIDR_ALL_VERSIONS(MIDR_BRCM_VULCAN),
-		.enable = enable_smccc_arch_workaround_1,
+		.cpu_enable = enable_smccc_arch_workaround_1,
 	},
 	{
 		.capability = ARM64_HARDEN_BRANCH_PREDICTOR,
 		MIDR_ALL_VERSIONS(MIDR_CAVIUM_THUNDERX2),
-		.enable = enable_smccc_arch_workaround_1,
+		.cpu_enable = enable_smccc_arch_workaround_1,
 	},
 #endif
 #ifdef CONFIG_ARM64_SSBD
@@ -636,8 +633,8 @@ void verify_local_cpu_errata_workarounds
 
 	for (; caps->matches; caps++) {
 		if (cpus_have_cap(caps->capability)) {
-			if (caps->enable)
-				caps->enable((void *)caps);
+			if (caps->cpu_enable)
+				caps->cpu_enable(caps);
 		} else if (caps->matches(caps, SCOPE_LOCAL_CPU)) {
 			pr_crit("CPU%d: Requires work around for %s, not detected"
 					" at boot time\n",
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -859,7 +859,8 @@ static bool unmap_kernel_at_el0(const st
 						     ID_AA64PFR0_CSV3_SHIFT);
 }
 
-static int kpti_install_ng_mappings(void *__unused)
+static void
+kpti_install_ng_mappings(const struct arm64_cpu_capabilities *__unused)
 {
 	typedef void (kpti_remap_fn)(int, int, phys_addr_t);
 	extern kpti_remap_fn idmap_kpti_install_ng_mappings;
@@ -869,7 +870,7 @@ static int kpti_install_ng_mappings(void
 	int cpu = smp_processor_id();
 
 	if (kpti_applied)
-		return 0;
+		return;
 
 	remap_fn = (void *)__pa_symbol(idmap_kpti_install_ng_mappings);
 
@@ -880,7 +881,7 @@ static int kpti_install_ng_mappings(void
 	if (!cpu)
 		kpti_applied = true;
 
-	return 0;
+	return;
 }
 
 static int __init parse_kpti(char *str)
@@ -897,7 +898,7 @@ static int __init parse_kpti(char *str)
 early_param("kpti", parse_kpti);
 #endif	/* CONFIG_UNMAP_KERNEL_AT_EL0 */
 
-static int cpu_copy_el2regs(void *__unused)
+static void cpu_copy_el2regs(const struct arm64_cpu_capabilities *__unused)
 {
 	/*
 	 * Copy register values that aren't redirected by hardware.
@@ -909,8 +910,6 @@ static int cpu_copy_el2regs(void *__unus
 	 */
 	if (!alternatives_applied)
 		write_sysreg(read_sysreg(tpidr_el1), tpidr_el2);
-
-	return 0;
 }
 
 static const struct arm64_cpu_capabilities arm64_features[] = {
@@ -934,7 +933,7 @@ static const struct arm64_cpu_capabiliti
 		.field_pos = ID_AA64MMFR1_PAN_SHIFT,
 		.sign = FTR_UNSIGNED,
 		.min_field_value = 1,
-		.enable = cpu_enable_pan,
+		.cpu_enable = cpu_enable_pan,
 	},
 #endif /* CONFIG_ARM64_PAN */
 #if defined(CONFIG_AS_LSE) && defined(CONFIG_ARM64_LSE_ATOMICS)
@@ -982,7 +981,7 @@ static const struct arm64_cpu_capabiliti
 		.capability = ARM64_HAS_VIRT_HOST_EXTN,
 		.def_scope = SCOPE_SYSTEM,
 		.matches = runs_at_el2,
-		.enable = cpu_copy_el2regs,
+		.cpu_enable = cpu_copy_el2regs,
 	},
 	{
 		.desc = "32-bit EL0 Support",
@@ -1006,7 +1005,7 @@ static const struct arm64_cpu_capabiliti
 		.capability = ARM64_UNMAP_KERNEL_AT_EL0,
 		.def_scope = SCOPE_SYSTEM,
 		.matches = unmap_kernel_at_el0,
-		.enable = kpti_install_ng_mappings,
+		.cpu_enable = kpti_install_ng_mappings,
 	},
 #endif
 	{
@@ -1169,6 +1168,14 @@ void update_cpu_capabilities(const struc
 	}
 }
 
+static int __enable_cpu_capability(void *arg)
+{
+	const struct arm64_cpu_capabilities *cap = arg;
+
+	cap->cpu_enable(cap);
+	return 0;
+}
+
 /*
  * Run through the enabled capabilities and enable() it on all active
  * CPUs
@@ -1184,14 +1191,15 @@ void __init enable_cpu_capabilities(cons
 		/* Ensure cpus_have_const_cap(num) works */
 		static_branch_enable(&cpu_hwcap_keys[num]);
 
-		if (caps->enable) {
+		if (caps->cpu_enable) {
 			/*
 			 * Use stop_machine() as it schedules the work allowing
 			 * us to modify PSTATE, instead of on_each_cpu() which
 			 * uses an IPI, giving us a PSTATE that disappears when
 			 * we return.
 			 */
-			stop_machine(caps->enable, (void *)caps, cpu_online_mask);
+			stop_machine(__enable_cpu_capability, (void *)caps,
+				     cpu_online_mask);
 		}
 	}
 }
@@ -1249,8 +1257,8 @@ verify_local_cpu_features(const struct a
 					smp_processor_id(), caps->desc);
 			cpu_die_early();
 		}
-		if (caps->enable)
-			caps->enable((void *)caps);
+		if (caps->cpu_enable)
+			caps->cpu_enable(caps);
 	}
 }
 
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -28,6 +28,7 @@
 #include <linux/signal.h>
 
 #include <asm/fpsimd.h>
+#include <asm/cpufeature.h>
 #include <asm/cputype.h>
 #include <asm/simd.h>
 
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -38,6 +38,7 @@
 
 #include <asm/atomic.h>
 #include <asm/bug.h>
+#include <asm/cpufeature.h>
 #include <asm/debug-monitors.h>
 #include <asm/esr.h>
 #include <asm/insn.h>
@@ -436,10 +437,9 @@ asmlinkage void __exception do_undefinst
 	force_signal_inject(SIGILL, ILL_ILLOPC, regs, 0);
 }
 
-int cpu_enable_cache_maint_trap(void *__unused)
+void cpu_enable_cache_maint_trap(const struct arm64_cpu_capabilities *__unused)
 {
 	config_sctlr_el1(SCTLR_EL1_UCI, 0);
-	return 0;
 }
 
 #define __user_cache_maint(insn, address, res)			\
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -875,7 +875,7 @@ asmlinkage int __exception do_debug_exce
 NOKPROBE_SYMBOL(do_debug_exception);
 
 #ifdef CONFIG_ARM64_PAN
-int cpu_enable_pan(void *__unused)
+void cpu_enable_pan(const struct arm64_cpu_capabilities *__unused)
 {
 	/*
 	 * We modify PSTATE. This won't work from irq context as the PSTATE
@@ -885,6 +885,5 @@ int cpu_enable_pan(void *__unused)
 
 	config_sctlr_el1(SCTLR_EL1_SPAN, 0);
 	asm(SET_PSTATE_PAN(1));
-	return 0;
 }
 #endif /* CONFIG_ARM64_PAN */


