Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6D524F68AE
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 20:18:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240201AbiDFSKD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 14:10:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240105AbiDFSIz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 14:08:55 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E95171A4D6D;
        Wed,  6 Apr 2022 09:46:36 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D01D41516;
        Wed,  6 Apr 2022 09:46:36 -0700 (PDT)
Received: from eglon.cambridge.arm.com (eglon.cambridge.arm.com [10.1.196.218])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2EE443F73B;
        Wed,  6 Apr 2022 09:46:36 -0700 (PDT)
From:   James Morse <james.morse@arm.com>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [stable:PATCH v4.9.309 39/43] KVM: arm64: Add templates for BHB mitigation sequences
Date:   Wed,  6 Apr 2022 17:45:42 +0100
Message-Id: <20220406164546.1888528-39-james.morse@arm.com>
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
 arch/arm64/include/asm/kvm_mmu.h |  2 +-
 arch/arm64/include/asm/mmu.h     |  6 +++
 arch/arm64/kernel/bpi.S          | 50 ++++++++++++++++++++++
 arch/arm64/kernel/cpu_errata.c   | 71 +++++++++++++++++++++++++++++++-
 5 files changed, 128 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index d4a46764c1ad..9935e55a3cc7 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -39,7 +39,8 @@
 #define ARM64_SSBD				18
 #define ARM64_MISMATCHED_CACHE_TYPE		19
 #define ARM64_WORKAROUND_1188873		20
+#define ARM64_SPECTRE_BHB			21
 
-#define ARM64_NCAPS				21
+#define ARM64_NCAPS				22
 
 #endif /* __ASM_CPUCAPS_H */
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index ff721659eb94..4a2c95854856 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -362,7 +362,7 @@ static inline void *kvm_get_hyp_vector(void)
 	struct bp_hardening_data *data = arm64_get_bp_hardening_data();
 	void *vect = kvm_ksym_ref(__kvm_hyp_vector);
 
-	if (data->fn) {
+	if (data->template_start) {
 		vect = __bp_harden_hyp_vecs_start +
 		       data->hyp_vectors_slot * SZ_2K;
 
diff --git a/arch/arm64/include/asm/mmu.h b/arch/arm64/include/asm/mmu.h
index 5eff1c49270d..f4377b005cba 100644
--- a/arch/arm64/include/asm/mmu.h
+++ b/arch/arm64/include/asm/mmu.h
@@ -45,6 +45,12 @@ typedef void (*bp_hardening_cb_t)(void);
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
 
 #ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
diff --git a/arch/arm64/kernel/bpi.S b/arch/arm64/kernel/bpi.S
index dc4eb154e33b..313f2b59eef9 100644
--- a/arch/arm64/kernel/bpi.S
+++ b/arch/arm64/kernel/bpi.S
@@ -73,3 +73,53 @@ ENTRY(__smccc_workaround_1_smc_end)
 ENTRY(__smccc_workaround_1_hvc_start)
 	smccc_workaround_1	hvc
 ENTRY(__smccc_workaround_1_hvc_end)
+
+ENTRY(__smccc_workaround_3_smc_start)
+	sub     sp, sp, #(8 * 4)
+	stp     x2, x3, [sp, #(8 * 0)]
+	stp     x0, x1, [sp, #(8 * 2)]
+	mov     w0, #ARM_SMCCC_ARCH_WORKAROUND_3
+	smc     #0
+	ldp     x2, x3, [sp, #(8 * 0)]
+	ldp     x0, x1, [sp, #(8 * 2)]
+	add     sp, sp, #(8 * 4)
+ENTRY(__smccc_workaround_3_smc_end)
+
+ENTRY(__spectre_bhb_loop_k8_start)
+	sub     sp, sp, #(8 * 2)
+	stp     x0, x1, [sp, #(8 * 0)]
+	mov     x0, #8
+2:	b       . + 4
+	subs    x0, x0, #1
+	b.ne    2b
+	dsb     nsh
+	isb
+	ldp     x0, x1, [sp, #(8 * 0)]
+	add     sp, sp, #(8 * 2)
+ENTRY(__spectre_bhb_loop_k8_end)
+
+ENTRY(__spectre_bhb_loop_k24_start)
+	sub     sp, sp, #(8 * 2)
+	stp     x0, x1, [sp, #(8 * 0)]
+	mov     x0, #24
+2:	b       . + 4
+	subs    x0, x0, #1
+	b.ne    2b
+	dsb     nsh
+	isb
+	ldp     x0, x1, [sp, #(8 * 0)]
+	add     sp, sp, #(8 * 2)
+ENTRY(__spectre_bhb_loop_k24_end)
+
+ENTRY(__spectre_bhb_loop_k32_start)
+	sub     sp, sp, #(8 * 2)
+	stp     x0, x1, [sp, #(8 * 0)]
+	mov     x0, #32
+2:	b       . + 4
+	subs    x0, x0, #1
+	b.ne    2b
+	dsb     nsh
+	isb
+	ldp     x0, x1, [sp, #(8 * 0)]
+	add     sp, sp, #(8 * 2)
+ENTRY(__spectre_bhb_loop_k32_end)
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 0d08249cbdab..acccc685b670 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -74,6 +74,14 @@ extern char __smccc_workaround_1_smc_start[];
 extern char __smccc_workaround_1_smc_end[];
 extern char __smccc_workaround_1_hvc_start[];
 extern char __smccc_workaround_1_hvc_end[];
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
@@ -87,12 +95,14 @@ static void __copy_hyp_vect_bpi(int slot, const char *hyp_vecs_start,
 	flush_icache_range((uintptr_t)dst, (uintptr_t)dst + SZ_2K);
 }
 
+static DEFINE_SPINLOCK(bp_lock);
+static int last_slot = -1;
+
 static void __install_bp_hardening_cb(bp_hardening_cb_t fn,
 				      const char *hyp_vecs_start,
 				      const char *hyp_vecs_end)
 {
-	static int last_slot = -1;
-	static DEFINE_SPINLOCK(bp_lock);
+
 	int cpu, slot = -1;
 
 	spin_lock(&bp_lock);
@@ -113,6 +123,7 @@ static void __install_bp_hardening_cb(bp_hardening_cb_t fn,
 
 	__this_cpu_write(bp_hardening_data.hyp_vectors_slot, slot);
 	__this_cpu_write(bp_hardening_data.fn, fn);
+	__this_cpu_write(bp_hardening_data.template_start, hyp_vecs_start);
 	spin_unlock(&bp_lock);
 }
 #else
@@ -544,3 +555,59 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 	{
 	}
 };
+
+#ifdef CONFIG_KVM
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
+		last_slot++;
+		BUG_ON(((__bp_harden_hyp_vecs_end - __bp_harden_hyp_vecs_start)
+			/ SZ_2K) <= last_slot);
+		slot = last_slot;
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
-- 
2.30.2

