Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 056B54E28CA
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 14:59:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348533AbiCUOAf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 10:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349085AbiCUN7B (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 09:59:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1646E10CC;
        Mon, 21 Mar 2022 06:57:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9BD8D611D5;
        Mon, 21 Mar 2022 13:57:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2678C340E8;
        Mon, 21 Mar 2022 13:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647871055;
        bh=0bmJK8z0fj0E3oh/iZJlbDdOWYBHggOw8AGflckOr1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Y9VwbqXJ8DGaVRpZQUgFCCGfoCN37CStpxXiTBAifgaZznBSKYXuWnRs+rU5Z28Z
         GN3oKbho1Md+a39xByXmMiiuloetaeOAfFbCua+MNGo+pKaohgUSnkyrtBAZLuDWr1
         kA7d6ElhPpjtTqnExs1aFhfts7jch/GSrOZ9qMms=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        James Morse <james.morse@arm.com>
Subject: [PATCH 4.19 40/57] KVM: arm64: Add templates for BHB mitigation sequences
Date:   Mon, 21 Mar 2022 14:52:21 +0100
Message-Id: <20220321133223.156318885@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220321133221.984120927@linuxfoundation.org>
References: <20220321133221.984120927@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Morse <james.morse@arm.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/cpucaps.h |    3 +
 arch/arm64/include/asm/kvm_mmu.h |    6 ++-
 arch/arm64/include/asm/mmu.h     |    6 +++
 arch/arm64/kernel/cpu_errata.c   |   65 ++++++++++++++++++++++++++++++++++++++-
 arch/arm64/kvm/hyp/hyp-entry.S   |   54 ++++++++++++++++++++++++++++++++
 5 files changed, 130 insertions(+), 4 deletions(-)

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
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -438,7 +438,8 @@ static inline void *kvm_get_hyp_vector(v
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
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -97,6 +97,14 @@ DEFINE_PER_CPU_READ_MOSTLY(struct bp_har
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
@@ -110,11 +118,11 @@ static void __copy_hyp_vect_bpi(int slot
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
@@ -133,6 +141,7 @@ static void install_bp_hardening_cb(bp_h
 
 	__this_cpu_write(bp_hardening_data.hyp_vectors_slot, slot);
 	__this_cpu_write(bp_hardening_data.fn, fn);
+	__this_cpu_write(bp_hardening_data.template_start, hyp_vecs_start);
 	spin_unlock(&bp_lock);
 }
 #else
@@ -935,3 +944,57 @@ enum mitigation_state arm64_get_spectre_
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


