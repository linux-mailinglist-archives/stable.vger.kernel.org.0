Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A90F04DA256
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 19:24:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351037AbiCOS0B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 14:26:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351036AbiCOS0A (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 14:26:00 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D248A2CCBB
        for <stable@vger.kernel.org>; Tue, 15 Mar 2022 11:24:47 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ABF791515;
        Tue, 15 Mar 2022 11:24:47 -0700 (PDT)
Received: from eglon.cambridge.arm.com (eglon.cambridge.arm.com [10.1.196.218])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0C00B3F73D;
        Tue, 15 Mar 2022 11:24:46 -0700 (PDT)
From:   James Morse <james.morse@arm.com>
To:     stable@vger.kernel.org
Cc:     catalin.marinas@arm.com, linux-arm-kernel@lists.infradead.org,
        james.morse@arm.com
Subject: [stable:PATCH v5.4.184 17/22] arm64: Add percpu vectors for EL1
Date:   Tue, 15 Mar 2022 18:24:10 +0000
Message-Id: <20220315182415.3900464-18-james.morse@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220315182415.3900464-1-james.morse@arm.com>
References: <20220315182415.3900464-1-james.morse@arm.com>
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

commit bd09128d16fac3c34b80bd6a29088ac632e8ce09 upstream.

The Spectre-BHB workaround adds a firmware call to the vectors. This
is needed on some CPUs, but not others. To avoid the unaffected CPU in
a big/little pair from making the firmware call, create per cpu vectors.

The per-cpu vectors only apply when returning from EL0.

Systems using KPTI can use the canonical 'full-fat' vectors directly at
EL1, the trampoline exit code will switch to this_cpu_vector on exit to
EL0. Systems not using KPTI should always use this_cpu_vector.

this_cpu_vector will point at a vector in tramp_vecs or
__bp_harden_el1_vectors, depending on whether KPTI is in use.

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: James Morse <james.morse@arm.com>
---
 arch/arm64/include/asm/mmu.h     |  2 +-
 arch/arm64/include/asm/vectors.h | 27 +++++++++++++++++++++++++++
 arch/arm64/kernel/cpufeature.c   | 11 +++++++++++
 arch/arm64/kernel/entry.S        | 16 ++++++++++------
 arch/arm64/kvm/hyp/switch.c      |  8 ++++++--
 5 files changed, 55 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/mmu.h b/arch/arm64/include/asm/mmu.h
index f217e3292919..353450011e3d 100644
--- a/arch/arm64/include/asm/mmu.h
+++ b/arch/arm64/include/asm/mmu.h
@@ -29,7 +29,7 @@ typedef struct {
  */
 #define ASID(mm)	((mm)->context.id.counter & 0xffff)
 
-static inline bool arm64_kernel_unmapped_at_el0(void)
+static __always_inline bool arm64_kernel_unmapped_at_el0(void)
 {
 	return IS_ENABLED(CONFIG_UNMAP_KERNEL_AT_EL0) &&
 	       cpus_have_const_cap(ARM64_UNMAP_KERNEL_AT_EL0);
diff --git a/arch/arm64/include/asm/vectors.h b/arch/arm64/include/asm/vectors.h
index 16ca74260375..3f76dfd9e074 100644
--- a/arch/arm64/include/asm/vectors.h
+++ b/arch/arm64/include/asm/vectors.h
@@ -5,6 +5,15 @@
 #ifndef __ASM_VECTORS_H
 #define __ASM_VECTORS_H
 
+#include <linux/bug.h>
+#include <linux/percpu.h>
+
+#include <asm/fixmap.h>
+
+extern char vectors[];
+extern char tramp_vectors[];
+extern char __bp_harden_el1_vectors[];
+
 /*
  * Note: the order of this enum corresponds to two arrays in entry.S:
  * tramp_vecs and __bp_harden_el1_vectors. By default the canonical
@@ -31,4 +40,22 @@ enum arm64_bp_harden_el1_vectors {
 	EL1_VECTOR_KPTI,
 };
 
+/* The vectors to use on return from EL0. e.g. to remap the kernel */
+DECLARE_PER_CPU_READ_MOSTLY(const char *, this_cpu_vector);
+
+#ifndef CONFIG_UNMAP_KERNEL_AT_EL0
+#define TRAMP_VALIAS	0
+#endif
+
+static inline const char *
+arm64_get_bp_hardening_vector(enum arm64_bp_harden_el1_vectors slot)
+{
+	if (arm64_kernel_unmapped_at_el0())
+		return (char *)TRAMP_VALIAS + SZ_2K * slot;
+
+	WARN_ON_ONCE(slot == EL1_VECTOR_KPTI);
+
+	return __bp_harden_el1_vectors + SZ_2K * slot;
+}
+
 #endif /* __ASM_VECTORS_H */
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 6b77e4942495..0d89d535720f 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -10,11 +10,13 @@
 #include <linux/bsearch.h>
 #include <linux/cpumask.h>
 #include <linux/crash_dump.h>
+#include <linux/percpu.h>
 #include <linux/sort.h>
 #include <linux/stop_machine.h>
 #include <linux/types.h>
 #include <linux/mm.h>
 #include <linux/cpu.h>
+
 #include <asm/cpu.h>
 #include <asm/cpufeature.h>
 #include <asm/cpu_ops.h>
@@ -23,6 +25,7 @@
 #include <asm/processor.h>
 #include <asm/sysreg.h>
 #include <asm/traps.h>
+#include <asm/vectors.h>
 #include <asm/virt.h>
 
 /* Kernel representation of AT_HWCAP and AT_HWCAP2 */
@@ -45,6 +48,8 @@ static struct arm64_cpu_capabilities const __ro_after_init *cpu_hwcaps_ptrs[ARM6
 /* Need also bit for ARM64_CB_PATCH */
 DECLARE_BITMAP(boot_capabilities, ARM64_NPATCHABLE);
 
+DEFINE_PER_CPU_READ_MOSTLY(const char *, this_cpu_vector) = vectors;
+
 /*
  * Flag to indicate if we have computed the system wide
  * capabilities based on the boot time active CPUs. This
@@ -1047,6 +1052,12 @@ kpti_install_ng_mappings(const struct arm64_cpu_capabilities *__unused)
 	static bool kpti_applied = false;
 	int cpu = smp_processor_id();
 
+	if (__this_cpu_read(this_cpu_vector) == vectors) {
+		const char *v = arm64_get_bp_hardening_vector(EL1_VECTOR_KPTI);
+
+		__this_cpu_write(this_cpu_vector, v);
+	}
+
 	/*
 	 * We don't need to rewrite the page-tables if either we've done
 	 * it already or we have KASLR enabled and therefore have not
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index e4b5a15c2e2e..fcfbb2b009e2 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -60,7 +60,6 @@
 	.macro kernel_ventry, el, label, regsize = 64
 	.align 7
 .Lventry_start\@:
-#ifdef CONFIG_UNMAP_KERNEL_AT_EL0
 	.if	\el == 0
 	/*
 	 * This must be the first instruction of the EL0 vector entries. It is
@@ -75,7 +74,6 @@
 	.endif
 .Lskip_tramp_vectors_cleanup\@:
 	.endif
-#endif
 
 	sub	sp, sp, #S_FRAME_SIZE
 #ifdef CONFIG_VMAP_STACK
@@ -1129,10 +1127,14 @@ alternative_else_nop_endif
 	.endm
 
 	.macro tramp_exit, regsize = 64
-	adr	x30, tramp_vectors
-#ifdef CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY
-	add	x30, x30, SZ_4K
-#endif
+	tramp_data_read_var	x30, this_cpu_vector
+alternative_if_not ARM64_HAS_VIRT_HOST_EXTN
+	mrs	x29, tpidr_el1
+alternative_else
+	mrs	x29, tpidr_el2
+alternative_endif
+	ldr	x30, [x30, x29]
+
 	msr	vbar_el1, x30
 	ldr	lr, [sp, #S_LR]
 	tramp_unmap_kernel	x29
@@ -1193,6 +1195,8 @@ __entry_tramp_data_vectors:
 __entry_tramp_data___sdei_asm_trampoline_next_handler:
 	.quad	__sdei_asm_handler
 #endif /* CONFIG_ARM_SDE_INTERFACE */
+__entry_tramp_data_this_cpu_vector:
+	.quad	this_cpu_vector
 	.popsection				// .rodata
 #endif /* CONFIG_RANDOMIZE_BASE */
 #endif /* CONFIG_UNMAP_KERNEL_AT_EL0 */
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 14607fac7ca3..768983bd2326 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -25,6 +25,7 @@
 #include <asm/debug-monitors.h>
 #include <asm/processor.h>
 #include <asm/thread_info.h>
+#include <asm/vectors.h>
 
 extern struct exception_table_entry __start___kvm_ex_table;
 extern struct exception_table_entry __stop___kvm_ex_table;
@@ -152,7 +153,7 @@ static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
 
 static void deactivate_traps_vhe(void)
 {
-	extern char vectors[];	/* kernel exception vectors */
+	const char *host_vectors = vectors;
 	write_sysreg(HCR_HOST_VHE_FLAGS, hcr_el2);
 
 	/*
@@ -163,7 +164,10 @@ static void deactivate_traps_vhe(void)
 	asm(ALTERNATIVE("nop", "isb", ARM64_WORKAROUND_1165522));
 
 	write_sysreg(CPACR_EL1_DEFAULT, cpacr_el1);
-	write_sysreg(vectors, vbar_el1);
+
+	if (!arm64_kernel_unmapped_at_el0())
+		host_vectors = __this_cpu_read(this_cpu_vector);
+	write_sysreg(host_vectors, vbar_el1);
 }
 NOKPROBE_SYMBOL(deactivate_traps_vhe);
 
-- 
2.30.2

