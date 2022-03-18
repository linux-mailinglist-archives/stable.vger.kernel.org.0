Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 223AC4DE056
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 18:51:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239895AbiCRRvR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 13:51:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239836AbiCRRvJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Mar 2022 13:51:09 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9B5FD1760C8;
        Fri, 18 Mar 2022 10:49:49 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6843F1515;
        Fri, 18 Mar 2022 10:49:49 -0700 (PDT)
Received: from eglon.cambridge.arm.com (eglon.cambridge.arm.com [10.1.196.218])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BC5FA3F7B4;
        Fri, 18 Mar 2022 10:49:48 -0700 (PDT)
From:   James Morse <james.morse@arm.com>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, james.morse@arm.com,
        catalin.marinas@arm.com
Subject: [stable:PATCH v4.19.235 18/22] KVM: arm64: Add templates for BHB mitigation sequences
Date:   Fri, 18 Mar 2022 17:48:38 +0000
Message-Id: <20220318174842.2321061-19-james.morse@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220318174842.2321061-1-james.morse@arm.com>
References: <20220318174842.2321061-1-james.morse@arm.com>
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
at runtime. As the KVM template code is intertwined with the bp-hardening
callbacks, all templates must have a bp-hardening callback.

Add templates for calling ARCH_WORKAROUND_3 and one for each value of K
in the brancy-loop. Identify these sequences by a new parameter
template_start, and add a copy of install_bp_hardening_cb() that is able to
install them.

Signed-off-by: James Morse <james.morse@arm.com>
---
 arch/arm64/include/asm/cpucaps.h |  3 +-
 arch/arm64/include/asm/kvm_mmu.h |  6 ++-
 arch/arm64/include/asm/mmu.h     |  6 +++
 arch/arm64/kernel/cpu_errata.c   | 65 +++++++++++++++++++++++++++++++-
 arch/arm64/kvm/hyp/hyp-entry.S   | 54 ++++++++++++++++++++++++++
 5 files changed, 130 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index df8fe8ecc37e..64ae14371cae 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -54,7 +54,8 @@
 #define ARM64_WORKAROUND_1463225		33
 #define ARM64_SSBS				34
 #define ARM64_WORKAROUND_1542419		35
+#define ARM64_SPECTRE_BHB			36
 
-#define ARM64_NCAPS				36
+#define ARM64_NCAPS				37
 
 #endif /* __ASM_CPUCAPS_H */
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index b2558447c67d..44d3fdbcdf62 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -438,7 +438,8 @@ static inline void *kvm_get_hyp_vector(void)
 	void *vect = kern_hyp_va(kvm_ksym_ref(__kvm_hyp_vector));
 	int slot = -1;
 
-	if (cpus_have_const_cap(ARM64_HARDEN_BRANCH_PREDICTOR) && data->fn) {
+	if ((cpus_have_const_cap(ARM64_HARDEN_BRANCH_PREDICTOR) ||
+	     cpus_have_const_cap(ARM64_SPECTRE_BHB)) && data->template_start) {
 		vect = kern_hyp_va(kvm_ksym_ref(__bp_harden_hyp_vecs_start));
 		slot = data->hyp_vectors_slot;
 	}
@@ -467,7 +468,8 @@ static inline int kvm_map_vectors(void)
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
index 1f61519fc23f..b37d185e0e84 100644
--- a/arch/arm64/include/asm/mmu.h
+++ b/arch/arm64/include/asm/mmu.h
@@ -49,6 +49,12 @@ typedef void (*bp_hardening_cb_t)(void);
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
index d055ed21eeeb..791dd8dadd9e 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -97,6 +97,14 @@ DEFINE_PER_CPU_READ_MOSTLY(struct bp_hardening_data, bp_hardening_data);
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
@@ -110,11 +118,11 @@ static void __copy_hyp_vect_bpi(int slot, const char *hyp_vecs_start,
 	__flush_icache_range((uintptr_t)dst, (uintptr_t)dst + SZ_2K);
 }
 
+static DEFINE_SPINLOCK(bp_lock);
 static void install_bp_hardening_cb(bp_hardening_cb_t fn,
 				    const char *hyp_vecs_start,
 				    const char *hyp_vecs_end)
 {
-	static DEFINE_SPINLOCK(bp_lock);
 	int cpu, slot = -1;
 
 	spin_lock(&bp_lock);
@@ -133,6 +141,7 @@ static void install_bp_hardening_cb(bp_hardening_cb_t fn,
 
 	__this_cpu_write(bp_hardening_data.hyp_vectors_slot, slot);
 	__this_cpu_write(bp_hardening_data.fn, fn);
+	__this_cpu_write(bp_hardening_data.template_start, hyp_vecs_start);
 	spin_unlock(&bp_lock);
 }
 #else
@@ -935,3 +944,57 @@ enum mitigation_state arm64_get_spectre_bhb_state(void)
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
+	spin_lock(&bp_lock);
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
+	spin_unlock(&bp_lock);
+}
+#else
+#define __smccc_workaround_3_smc_start NULL
+#define __spectre_bhb_loop_k8_start NULL
+#define __spectre_bhb_loop_k24_start NULL
+#define __spectre_bhb_loop_k32_start NULL
+
+void kvm_setup_bhb_slot(const char *hyp_vecs_start) { };
+#endif
diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index ea063312bca1..05593f631eca 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -334,4 +334,58 @@ ENTRY(__smccc_workaround_1_smc_start)
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

