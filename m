Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60A1B4DA25A
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 19:25:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351039AbiCOS0C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 14:26:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351033AbiCOS0C (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 14:26:02 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A53F02DAA3
        for <stable@vger.kernel.org>; Tue, 15 Mar 2022 11:24:49 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8A6D51476;
        Tue, 15 Mar 2022 11:24:49 -0700 (PDT)
Received: from eglon.cambridge.arm.com (eglon.cambridge.arm.com [10.1.196.218])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C415D3F73D;
        Tue, 15 Mar 2022 11:24:48 -0700 (PDT)
From:   James Morse <james.morse@arm.com>
To:     stable@vger.kernel.org
Cc:     catalin.marinas@arm.com, linux-arm-kernel@lists.infradead.org,
        james.morse@arm.com
Subject: [stable:PATCH v5.4.184 19/22] KVM: arm64: Add templates for BHB mitigation sequences
Date:   Tue, 15 Mar 2022 18:24:12 +0000
Message-Id: <20220315182415.3900464-20-james.morse@arm.com>
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

KVM writes the Spectre-v2 mitigation template at the beginning of each
vector when a CPU requires a specific sequence to run.

Because the template is copied, it can not be modified by the alternatives
at runtime.

Add templates for calling ARCH_WORKAROUND_3 and one for each value of K
in the brancy-loop. Instead of adding dummy functions for 'fn', which would
disable the Spectre-v2 mitigation, add template_start to indicate that a
template (and which one) is in use. Finally add a copy of
install_bp_hardening_cb() that is able to install these.

Signed-off-by: James Morse <james.morse@arm.com>
---
 arch/arm64/include/asm/cpucaps.h |  3 +-
 arch/arm64/include/asm/kvm_mmu.h |  6 ++-
 arch/arm64/include/asm/mmu.h     |  6 +++
 arch/arm64/kernel/cpu_errata.c   | 65 +++++++++++++++++++++++++++++++-
 arch/arm64/kvm/hyp/hyp-entry.S   | 54 ++++++++++++++++++++++++++
 5 files changed, 130 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index 1dc3c762fdcb..4ffa86149d28 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -55,7 +55,8 @@
 #define ARM64_WORKAROUND_CAVIUM_TX2_219_TVM	45
 #define ARM64_WORKAROUND_CAVIUM_TX2_219_PRFM	46
 #define ARM64_WORKAROUND_1542419		47
+#define ARM64_SPECTRE_BHB			48
 
-#define ARM64_NCAPS				48
+#define ARM64_NCAPS				49
 
 #endif /* __ASM_CPUCAPS_H */
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index befe37d4bc0e..78d110667c0c 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -478,7 +478,8 @@ static inline void *kvm_get_hyp_vector(void)
 	void *vect = kern_hyp_va(kvm_ksym_ref(__kvm_hyp_vector));
 	int slot = -1;
 
-	if (cpus_have_const_cap(ARM64_HARDEN_BRANCH_PREDICTOR) && data->fn) {
+	if ((cpus_have_const_cap(ARM64_HARDEN_BRANCH_PREDICTOR) ||
+	     cpus_have_const_cap(ARM64_SPECTRE_BHB)) && data->template_start) {
 		vect = kern_hyp_va(kvm_ksym_ref(__bp_harden_hyp_vecs_start));
 		slot = data->hyp_vectors_slot;
 	}
@@ -507,7 +508,8 @@ static inline int kvm_map_vectors(void)
 	 * !HBP +  HEL2 -> allocate one vector slot and use exec mapping
 	 *  HBP +  HEL2 -> use hardened vertors and use exec mapping
 	 */
-	if (cpus_have_const_cap(ARM64_HARDEN_BRANCH_PREDICTOR)) {
+	if (cpus_have_const_cap(ARM64_HARDEN_BRANCH_PREDICTOR) ||
+	    cpus_have_const_cap(ARM64_SPECTRE_BHB)) {
 		__kvm_bp_vect_base = kvm_ksym_ref(__bp_harden_hyp_vecs_start);
 		__kvm_bp_vect_base = kern_hyp_va(__kvm_bp_vect_base);
 	}
diff --git a/arch/arm64/include/asm/mmu.h b/arch/arm64/include/asm/mmu.h
index 353450011e3d..1b9e49fb0e1b 100644
--- a/arch/arm64/include/asm/mmu.h
+++ b/arch/arm64/include/asm/mmu.h
@@ -82,6 +82,12 @@ typedef void (*bp_hardening_cb_t)(void);
 struct bp_hardening_data {
 	int			hyp_vectors_slot;
 	bp_hardening_cb_t	fn;
+
+	/*
+	 * template_start is only used by the BHB mitigation to identify the
+	 * hyp_vectors_slot sequence.
+	 */
+	const char *template_start;
 };
 
 #if (defined(CONFIG_HARDEN_BRANCH_PREDICTOR) ||	\
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 182305000de3..30818b757d51 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -116,6 +116,14 @@ DEFINE_PER_CPU_READ_MOSTLY(struct bp_hardening_data, bp_hardening_data);
 #ifdef CONFIG_KVM_INDIRECT_VECTORS
 extern char __smccc_workaround_1_smc_start[];
 extern char __smccc_workaround_1_smc_end[];
+extern char __smccc_workaround_3_smc_start[];
+extern char __smccc_workaround_3_smc_end[];
+extern char __spectre_bhb_loop_k8_start[];
+extern char __spectre_bhb_loop_k8_end[];
+extern char __spectre_bhb_loop_k24_start[];
+extern char __spectre_bhb_loop_k24_end[];
+extern char __spectre_bhb_loop_k32_start[];
+extern char __spectre_bhb_loop_k32_end[];
 
 static void __copy_hyp_vect_bpi(int slot, const char *hyp_vecs_start,
 				const char *hyp_vecs_end)
@@ -129,11 +137,11 @@ static void __copy_hyp_vect_bpi(int slot, const char *hyp_vecs_start,
 	__flush_icache_range((uintptr_t)dst, (uintptr_t)dst + SZ_2K);
 }
 
+static DEFINE_RAW_SPINLOCK(bp_lock);
 static void install_bp_hardening_cb(bp_hardening_cb_t fn,
 				    const char *hyp_vecs_start,
 				    const char *hyp_vecs_end)
 {
-	static DEFINE_RAW_SPINLOCK(bp_lock);
 	int cpu, slot = -1;
 
 	/*
@@ -161,6 +169,7 @@ static void install_bp_hardening_cb(bp_hardening_cb_t fn,
 
 	__this_cpu_write(bp_hardening_data.hyp_vectors_slot, slot);
 	__this_cpu_write(bp_hardening_data.fn, fn);
+	__this_cpu_write(bp_hardening_data.template_start, hyp_vecs_start);
 	raw_spin_unlock(&bp_lock);
 }
 #else
@@ -1052,3 +1061,57 @@ enum mitigation_state arm64_get_spectre_bhb_state(void)
 {
 	return spectre_bhb_state;
 }
+
+#ifdef CONFIG_KVM_INDIRECT_VECTORS
+static const char *kvm_bhb_get_vecs_end(const char *start)
+{
+	if (start == __smccc_workaround_3_smc_start)
+		return __smccc_workaround_3_smc_end;
+	else if (start == __spectre_bhb_loop_k8_start)
+		return __spectre_bhb_loop_k8_end;
+	else if (start == __spectre_bhb_loop_k24_start)
+		return __spectre_bhb_loop_k24_end;
+	else if (start == __spectre_bhb_loop_k32_start)
+		return __spectre_bhb_loop_k32_end;
+
+	return NULL;
+}
+
+void kvm_setup_bhb_slot(const char *hyp_vecs_start)
+{
+	int cpu, slot = -1;
+	const char *hyp_vecs_end;
+
+	if (!IS_ENABLED(CONFIG_KVM) || !is_hyp_mode_available())
+		return;
+
+	hyp_vecs_end = kvm_bhb_get_vecs_end(hyp_vecs_start);
+	if (WARN_ON_ONCE(!hyp_vecs_start || !hyp_vecs_end))
+		return;
+
+	raw_spin_lock(&bp_lock);
+	for_each_possible_cpu(cpu) {
+		if (per_cpu(bp_hardening_data.template_start, cpu) == hyp_vecs_start) {
+			slot = per_cpu(bp_hardening_data.hyp_vectors_slot, cpu);
+			break;
+		}
+	}
+
+	if (slot == -1) {
+		slot = atomic_inc_return(&arm64_el2_vector_last_slot);
+		BUG_ON(slot >= BP_HARDEN_EL2_SLOTS);
+		__copy_hyp_vect_bpi(slot, hyp_vecs_start, hyp_vecs_end);
+	}
+
+	__this_cpu_write(bp_hardening_data.hyp_vectors_slot, slot);
+	__this_cpu_write(bp_hardening_data.template_start, hyp_vecs_start);
+	raw_spin_unlock(&bp_lock);
+}
+#else
+#define __smccc_workaround_3_smc_start NULL
+#define __spectre_bhb_loop_k8_start NULL
+#define __spectre_bhb_loop_k24_start NULL
+#define __spectre_bhb_loop_k32_start NULL
+
+void kvm_setup_bhb_slot(const char *hyp_vecs_start) { }
+#endif
diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index f36aad0f207b..2ad750208e33 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -347,4 +347,58 @@ ENTRY(__smccc_workaround_1_smc_start)
 	ldp	x0, x1, [sp, #(8 * 2)]
 	add	sp, sp, #(8 * 4)
 ENTRY(__smccc_workaround_1_smc_end)
+
+ENTRY(__smccc_workaround_3_smc_start)
+	esb
+	sub	sp, sp, #(8 * 4)
+	stp	x2, x3, [sp, #(8 * 0)]
+	stp	x0, x1, [sp, #(8 * 2)]
+	mov	w0, #ARM_SMCCC_ARCH_WORKAROUND_3
+	smc	#0
+	ldp	x2, x3, [sp, #(8 * 0)]
+	ldp	x0, x1, [sp, #(8 * 2)]
+	add	sp, sp, #(8 * 4)
+ENTRY(__smccc_workaround_3_smc_end)
+
+ENTRY(__spectre_bhb_loop_k8_start)
+	esb
+	sub	sp, sp, #(8 * 2)
+	stp	x0, x1, [sp, #(8 * 0)]
+	mov	x0, #8
+2:	b	. + 4
+	subs	x0, x0, #1
+	b.ne	2b
+	dsb	nsh
+	isb
+	ldp	x0, x1, [sp, #(8 * 0)]
+	add	sp, sp, #(8 * 2)
+ENTRY(__spectre_bhb_loop_k8_end)
+
+ENTRY(__spectre_bhb_loop_k24_start)
+	esb
+	sub	sp, sp, #(8 * 2)
+	stp	x0, x1, [sp, #(8 * 0)]
+	mov	x0, #24
+2:	b	. + 4
+	subs	x0, x0, #1
+	b.ne	2b
+	dsb	nsh
+	isb
+	ldp	x0, x1, [sp, #(8 * 0)]
+	add	sp, sp, #(8 * 2)
+ENTRY(__spectre_bhb_loop_k24_end)
+
+ENTRY(__spectre_bhb_loop_k32_start)
+	esb
+	sub	sp, sp, #(8 * 2)
+	stp	x0, x1, [sp, #(8 * 0)]
+	mov     x0, #32
+2:	b	. + 4
+	subs	x0, x0, #1
+	b.ne	2b
+	dsb	nsh
+	isb
+	ldp	x0, x1, [sp, #(8 * 0)]
+	add	sp, sp, #(8 * 2)
+ENTRY(__spectre_bhb_loop_k32_end)
 #endif
-- 
2.30.2

