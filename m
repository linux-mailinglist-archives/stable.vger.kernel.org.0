Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCE2A4F694A
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 20:19:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239899AbiDFSIL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 14:08:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240372AbiDFSHt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 14:07:49 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4169F140DF2;
        Wed,  6 Apr 2022 09:46:05 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0D8D323A;
        Wed,  6 Apr 2022 09:46:05 -0700 (PDT)
Received: from eglon.cambridge.arm.com (eglon.cambridge.arm.com [10.1.196.218])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 45D3B3F73B;
        Wed,  6 Apr 2022 09:46:04 -0700 (PDT)
From:   James Morse <james.morse@arm.com>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [stable:PATCH v4.9.309 04/43] arm64: capabilities: Update prototype for enable call back
Date:   Wed,  6 Apr 2022 17:45:07 +0100
Message-Id: <20220406164546.1888528-4-james.morse@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220406164546.1888528-1-james.morse@arm.com>
References: <0220406164217.1888053-1-james.morse@arm.com>
 <20220406164546.1888528-1-james.morse@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
Signed-off-by: James Morse <james.morse@arm.com>
---
 arch/arm64/include/asm/cpufeature.h |  7 ++++-
 arch/arm64/include/asm/processor.h  |  5 ++--
 arch/arm64/kernel/cpu_errata.c      | 44 ++++++++++++++---------------
 arch/arm64/kernel/cpufeature.c      | 34 +++++++++++++---------
 arch/arm64/kernel/fpsimd.c          |  1 +
 arch/arm64/kernel/traps.c           |  4 +--
 arch/arm64/mm/fault.c               |  3 +-
 7 files changed, 56 insertions(+), 42 deletions(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index e7bef3d936d8..984a9c81d65a 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -77,7 +77,12 @@ struct arm64_cpu_capabilities {
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
diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
index d27e472bbbf1..367141e05c34 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -37,6 +37,7 @@
 #include <linux/string.h>
 
 #include <asm/alternative.h>
+#include <asm/cpufeature.h>
 #include <asm/fpsimd.h>
 #include <asm/hw_breakpoint.h>
 #include <asm/lse.h>
@@ -219,8 +220,8 @@ static inline void spin_lock_prefetch(const void *ptr)
 
 #endif
 
-int cpu_enable_pan(void *__unused);
-int cpu_enable_cache_maint_trap(void *__unused);
+void cpu_enable_pan(const struct arm64_cpu_capabilities *__unused);
+void cpu_enable_cache_maint_trap(const struct arm64_cpu_capabilities *__unused);
 
 #endif /* __ASSEMBLY__ */
 #endif /* __ASM_PROCESSOR_H */
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index bf4da33d77e3..cc62e3376345 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -48,11 +48,11 @@ has_mismatched_cache_type(const struct arm64_cpu_capabilities *entry,
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
@@ -152,25 +152,25 @@ static void call_hvc_arch_workaround_1(void)
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
@@ -180,19 +180,19 @@ static int enable_smccc_arch_workaround_1(void *data)
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
 #endif	/* CONFIG_HARDEN_BRANCH_PREDICTOR */
 
@@ -391,7 +391,7 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		.desc = "ARM errata 826319, 827319, 824069",
 		.capability = ARM64_WORKAROUND_CLEAN_CACHE,
 		MIDR_RANGE(MIDR_CORTEX_A53, 0x00, 0x02),
-		.enable = cpu_enable_cache_maint_trap,
+		.cpu_enable = cpu_enable_cache_maint_trap,
 	},
 #endif
 #ifdef CONFIG_ARM64_ERRATUM_819472
@@ -400,7 +400,7 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		.desc = "ARM errata 819472",
 		.capability = ARM64_WORKAROUND_CLEAN_CACHE,
 		MIDR_RANGE(MIDR_CORTEX_A53, 0x00, 0x01),
-		.enable = cpu_enable_cache_maint_trap,
+		.cpu_enable = cpu_enable_cache_maint_trap,
 	},
 #endif
 #ifdef CONFIG_ARM64_ERRATUM_832075
@@ -460,45 +460,45 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
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
 #ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
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
@@ -524,8 +524,8 @@ void verify_local_cpu_errata_workarounds(void)
 
 	for (; caps->matches; caps++) {
 		if (cpus_have_cap(caps->capability)) {
-			if (caps->enable)
-				caps->enable((void *)caps);
+			if (caps->cpu_enable)
+				caps->cpu_enable(caps);
 		} else if (caps->matches(caps, SCOPE_LOCAL_CPU)) {
 			pr_crit("CPU%d: Requires work around for %s, not detected"
 					" at boot time\n",
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 6601dd4005c3..8e037a519e02 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -800,7 +800,8 @@ static bool unmap_kernel_at_el0(const struct arm64_cpu_capabilities *entry,
 						     ID_AA64PFR0_CSV3_SHIFT);
 }
 
-static int kpti_install_ng_mappings(void *__unused)
+static void
+kpti_install_ng_mappings(const struct arm64_cpu_capabilities *__unused)
 {
 	typedef void (kpti_remap_fn)(int, int, phys_addr_t);
 	extern kpti_remap_fn idmap_kpti_install_ng_mappings;
@@ -810,7 +811,7 @@ static int kpti_install_ng_mappings(void *__unused)
 	int cpu = smp_processor_id();
 
 	if (kpti_applied)
-		return 0;
+		return;
 
 	remap_fn = (void *)__pa_symbol(idmap_kpti_install_ng_mappings);
 
@@ -821,7 +822,7 @@ static int kpti_install_ng_mappings(void *__unused)
 	if (!cpu)
 		kpti_applied = true;
 
-	return 0;
+	return;
 }
 
 static int __init parse_kpti(char *str)
@@ -838,7 +839,7 @@ static int __init parse_kpti(char *str)
 early_param("kpti", parse_kpti);
 #endif	/* CONFIG_UNMAP_KERNEL_AT_EL0 */
 
-static int cpu_copy_el2regs(void *__unused)
+static void cpu_copy_el2regs(const struct arm64_cpu_capabilities *__unused)
 {
 	/*
 	 * Copy register values that aren't redirected by hardware.
@@ -850,8 +851,6 @@ static int cpu_copy_el2regs(void *__unused)
 	 */
 	if (!alternatives_applied)
 		write_sysreg(read_sysreg(tpidr_el1), tpidr_el2);
-
-	return 0;
 }
 
 static const struct arm64_cpu_capabilities arm64_features[] = {
@@ -875,7 +874,7 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.field_pos = ID_AA64MMFR1_PAN_SHIFT,
 		.sign = FTR_UNSIGNED,
 		.min_field_value = 1,
-		.enable = cpu_enable_pan,
+		.cpu_enable = cpu_enable_pan,
 	},
 #endif /* CONFIG_ARM64_PAN */
 #if defined(CONFIG_AS_LSE) && defined(CONFIG_ARM64_LSE_ATOMICS)
@@ -923,7 +922,7 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.capability = ARM64_HAS_VIRT_HOST_EXTN,
 		.def_scope = SCOPE_SYSTEM,
 		.matches = runs_at_el2,
-		.enable = cpu_copy_el2regs,
+		.cpu_enable = cpu_copy_el2regs,
 	},
 	{
 		.desc = "32-bit EL0 Support",
@@ -947,7 +946,7 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.capability = ARM64_UNMAP_KERNEL_AT_EL0,
 		.def_scope = SCOPE_SYSTEM,
 		.matches = unmap_kernel_at_el0,
-		.enable = kpti_install_ng_mappings,
+		.cpu_enable = kpti_install_ng_mappings,
 	},
 #endif
 	{},
@@ -1075,6 +1074,14 @@ void update_cpu_capabilities(const struct arm64_cpu_capabilities *caps,
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
@@ -1090,14 +1097,15 @@ void __init enable_cpu_capabilities(const struct arm64_cpu_capabilities *caps)
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
@@ -1155,8 +1163,8 @@ verify_local_cpu_features(const struct arm64_cpu_capabilities *caps_list)
 					smp_processor_id(), caps->desc);
 			cpu_die_early();
 		}
-		if (caps->enable)
-			caps->enable((void *)caps);
+		if (caps->cpu_enable)
+			caps->cpu_enable(caps);
 	}
 }
 
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 1d5890f19ca3..ee34be8bed03 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -26,6 +26,7 @@
 #include <linux/hardirq.h>
 
 #include <asm/fpsimd.h>
+#include <asm/cpufeature.h>
 #include <asm/cputype.h>
 
 #define FPEXC_IOF	(1 << 0)
diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index b6fd2a21b015..adf18b9a2c03 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -34,6 +34,7 @@
 
 #include <asm/atomic.h>
 #include <asm/bug.h>
+#include <asm/cpufeature.h>
 #include <asm/debug-monitors.h>
 #include <asm/esr.h>
 #include <asm/insn.h>
@@ -432,10 +433,9 @@ asmlinkage void __exception do_undefinstr(struct pt_regs *regs)
 	force_signal_inject(SIGILL, ILL_ILLOPC, regs, 0);
 }
 
-int cpu_enable_cache_maint_trap(void *__unused)
+void cpu_enable_cache_maint_trap(const struct arm64_cpu_capabilities *__unused)
 {
 	config_sctlr_el1(SCTLR_EL1_UCI, 0);
-	return 0;
 }
 
 #define __user_cache_maint(insn, address, res)			\
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index e973002530de..a0c3efbc3717 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -727,7 +727,7 @@ asmlinkage int __exception do_debug_exception(unsigned long addr_if_watchpoint,
 NOKPROBE_SYMBOL(do_debug_exception);
 
 #ifdef CONFIG_ARM64_PAN
-int cpu_enable_pan(void *__unused)
+void cpu_enable_pan(const struct arm64_cpu_capabilities *__unused)
 {
 	/*
 	 * We modify PSTATE. This won't work from irq context as the PSTATE
@@ -737,6 +737,5 @@ int cpu_enable_pan(void *__unused)
 
 	config_sctlr_el1(SCTLR_EL1_SPAN, 0);
 	asm(SET_PSTATE_PAN(1));
-	return 0;
 }
 #endif /* CONFIG_ARM64_PAN */
-- 
2.30.2

