Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5904EE86E
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 08:39:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245624AbiDAGlE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 02:41:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245650AbiDAGjo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 02:39:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D91C7264F41;
        Thu, 31 Mar 2022 23:37:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2A5AAB82373;
        Fri,  1 Apr 2022 06:37:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 771E0C340EE;
        Fri,  1 Apr 2022 06:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648795042;
        bh=HSlJTl4Z/spWeKGNCRNSSAH4Y2lLeoWNUuDsdR0Yf6I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gsGPe/u6neYcV0DM3WGQhXC9wTWrzSj9FLL5M0gfxCaFJ8BJRPbbXK4VMeDPYA5Gh
         /JYBNyKzpUjDvVFhP89KjEwHQPbyt6igIFeYBkQsuKSAAEHfPEx0VPLQoboAEDoPTq
         0YgwQnT1jRdJszS7WlbmWYBQYQbK76A6RtK0PklA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Morse <james.morse@arm.com>
Subject: [PATCH 4.14 23/27] KVM: arm64: Add templates for BHB mitigation sequences
Date:   Fri,  1 Apr 2022 08:36:33 +0200
Message-Id: <20220401063624.888839258@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220401063624.232282121@linuxfoundation.org>
References: <20220401063624.232282121@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 arch/arm64/include/asm/kvm_mmu.h |    2 -
 arch/arm64/include/asm/mmu.h     |    6 +++
 arch/arm64/kernel/bpi.S          |   50 +++++++++++++++++++++++++++
 arch/arm64/kernel/cpu_errata.c   |   71 +++++++++++++++++++++++++++++++++++++--
 5 files changed, 128 insertions(+), 4 deletions(-)

--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -46,7 +46,8 @@
 #define ARM64_MISMATCHED_CACHE_TYPE		26
 #define ARM64_SSBS				27
 #define ARM64_WORKAROUND_1188873		28
+#define ARM64_SPECTRE_BHB			29
 
-#define ARM64_NCAPS				29
+#define ARM64_NCAPS				30
 
 #endif /* __ASM_CPUCAPS_H */
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -358,7 +358,7 @@ static inline void *kvm_get_hyp_vector(v
 	struct bp_hardening_data *data = arm64_get_bp_hardening_data();
 	void *vect = kvm_ksym_ref(__kvm_hyp_vector);
 
-	if (data->fn) {
+	if (data->template_start) {
 		vect = __bp_harden_hyp_vecs_start +
 		       data->hyp_vectors_slot * SZ_2K;
 
--- a/arch/arm64/include/asm/mmu.h
+++ b/arch/arm64/include/asm/mmu.h
@@ -46,6 +46,12 @@ typedef void (*bp_hardening_cb_t)(void);
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
--- a/arch/arm64/kernel/bpi.S
+++ b/arch/arm64/kernel/bpi.S
@@ -66,3 +66,53 @@ ENTRY(__smccc_workaround_1_smc_start)
 	ldp	x0, x1, [sp, #(8 * 2)]
 	add	sp, sp, #(8 * 4)
 ENTRY(__smccc_workaround_1_smc_end)
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
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -85,6 +85,14 @@ DEFINE_PER_CPU_READ_MOSTLY(struct bp_har
 #ifdef CONFIG_KVM
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
@@ -98,12 +106,14 @@ static void __copy_hyp_vect_bpi(int slot
 	flush_icache_range((uintptr_t)dst, (uintptr_t)dst + SZ_2K);
 }
 
+static DEFINE_SPINLOCK(bp_lock);
+static int last_slot = -1;
+
 static void install_bp_hardening_cb(bp_hardening_cb_t fn,
 				    const char *hyp_vecs_start,
 				    const char *hyp_vecs_end)
 {
-	static int last_slot = -1;
-	static DEFINE_SPINLOCK(bp_lock);
+
 	int cpu, slot = -1;
 
 	spin_lock(&bp_lock);
@@ -124,6 +134,7 @@ static void install_bp_hardening_cb(bp_h
 
 	__this_cpu_write(bp_hardening_data.hyp_vectors_slot, slot);
 	__this_cpu_write(bp_hardening_data.fn, fn);
+	__this_cpu_write(bp_hardening_data.template_start, hyp_vecs_start);
 	spin_unlock(&bp_lock);
 }
 #else
@@ -790,3 +801,59 @@ enum mitigation_state arm64_get_spectre_
 {
 	return spectre_bhb_state;
 }
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


