Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB4694D4BF7
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 16:01:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244175AbiCJOdD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 09:33:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245258AbiCJOaS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 09:30:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CAF5172271;
        Thu, 10 Mar 2022 06:25:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C29961D23;
        Thu, 10 Mar 2022 14:25:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24701C340F5;
        Thu, 10 Mar 2022 14:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646922314;
        bh=J6wXw2OY/SEj7WgYtzb95YfVux64kBMGaFrb3rNLZiI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bsVMsMkHBB06gIq1L+/d6oNjRHQvaXlce9iwUY168Y6J3hIMNtRfpN/TKz0y7Dcya
         PTK0TJ+5ctCg7aT0KLwqzz7IadcAaKipGk666W3F8aFPlMLMfe7pD71etQxHUNJuXU
         bPTjPn0Fj5A+KGQvgcSdHufgTFyygsBdWz4y+MR4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>
Subject: [PATCH 5.10 38/58] KVM: arm64: Allow indirect vectors to be used without SPECTRE_V3A
Date:   Thu, 10 Mar 2022 15:18:58 +0100
Message-Id: <20220310140813.956533242@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220310140812.869208747@linuxfoundation.org>
References: <20220310140812.869208747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Morse <james.morse@arm.com>

commit 5bdf3437603d4af87f9c7f424b0c8aeed2420745 upstream.

CPUs vulnerable to Spectre-BHB either need to make an SMC-CC firmware
call from the vectors, or run a sequence of branches. This gets added
to the hyp vectors. If there is no support for arch-workaround-1 in
firmware, the indirect vector will be used.

kvm_init_vector_slots() only initialises the two indirect slots if
the platform is vulnerable to Spectre-v3a. pKVM's hyp_map_vectors()
only initialises __hyp_bp_vect_base if the platform is vulnerable to
Spectre-v3a.

As there are about to more users of the indirect vectors, ensure
their entries in hyp_spectre_vector_selector[] are always initialised,
and __hyp_bp_vect_base defaults to the regular VA mapping.

The Spectre-v3a check is moved to a helper
kvm_system_needs_idmapped_vectors(), and merged with the code
that creates the hyp mappings.

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/cpucaps.h |    3 +
 arch/arm64/include/asm/kvm_asm.h |    6 +++
 arch/arm64/include/asm/kvm_mmu.h |    3 +
 arch/arm64/include/asm/mmu.h     |    6 +++
 arch/arm64/kernel/proton-pack.c  |   47 +++++++++++++++++++++++++++
 arch/arm64/kvm/arm.c             |    3 +
 arch/arm64/kvm/hyp/smccc_wa.S    |   66 +++++++++++++++++++++++++++++++++++++++
 7 files changed, 130 insertions(+), 4 deletions(-)

--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -66,7 +66,8 @@
 #define ARM64_HAS_TLB_RANGE			56
 #define ARM64_MTE				57
 #define ARM64_WORKAROUND_1508412		58
+#define ARM64_SPECTRE_BHB			59
 
-#define ARM64_NCAPS				59
+#define ARM64_NCAPS				60
 
 #endif /* __ASM_CPUCAPS_H */
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -35,6 +35,8 @@
 #define KVM_VECTOR_PREAMBLE	(2 * AARCH64_INSN_SIZE)
 
 #define __SMCCC_WORKAROUND_1_SMC_SZ 36
+#define __SMCCC_WORKAROUND_3_SMC_SZ 36
+#define __SPECTRE_BHB_LOOP_SZ       44
 
 #define KVM_HOST_SMCCC_ID(id)						\
 	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
@@ -199,6 +201,10 @@ extern void __vgic_v3_init_lrs(void);
 extern u32 __kvm_get_mdcr_el2(void);
 
 extern char __smccc_workaround_1_smc[__SMCCC_WORKAROUND_1_SMC_SZ];
+extern char __smccc_workaround_3_smc[__SMCCC_WORKAROUND_3_SMC_SZ];
+extern char __spectre_bhb_loop_k8[__SPECTRE_BHB_LOOP_SZ];
+extern char __spectre_bhb_loop_k24[__SPECTRE_BHB_LOOP_SZ];
+extern char __spectre_bhb_loop_k32[__SPECTRE_BHB_LOOP_SZ];
 
 /*
  * Obtain the PC-relative address of a kernel symbol
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -237,7 +237,8 @@ static inline void *kvm_get_hyp_vector(v
 	void *vect = kern_hyp_va(kvm_ksym_ref(__kvm_hyp_vector));
 	int slot = -1;
 
-	if (cpus_have_const_cap(ARM64_SPECTRE_V2) && data->fn) {
+	if ((cpus_have_const_cap(ARM64_SPECTRE_V2) ||
+	     cpus_have_const_cap(ARM64_SPECTRE_BHB)) && data->template_start) {
 		vect = kern_hyp_va(kvm_ksym_ref(__bp_harden_hyp_vecs));
 		slot = data->hyp_vectors_slot;
 	}
--- a/arch/arm64/include/asm/mmu.h
+++ b/arch/arm64/include/asm/mmu.h
@@ -67,6 +67,12 @@ typedef void (*bp_hardening_cb_t)(void);
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
 
 DECLARE_PER_CPU_READ_MOSTLY(struct bp_hardening_data, bp_hardening_data);
--- a/arch/arm64/kernel/proton-pack.c
+++ b/arch/arm64/kernel/proton-pack.c
@@ -220,9 +220,9 @@ static void __copy_hyp_vect_bpi(int slot
 	__flush_icache_range((uintptr_t)dst, (uintptr_t)dst + SZ_2K);
 }
 
+static DEFINE_RAW_SPINLOCK(bp_lock);
 static void install_bp_hardening_cb(bp_hardening_cb_t fn)
 {
-	static DEFINE_RAW_SPINLOCK(bp_lock);
 	int cpu, slot = -1;
 	const char *hyp_vecs_start = __smccc_workaround_1_smc;
 	const char *hyp_vecs_end = __smccc_workaround_1_smc +
@@ -253,6 +253,7 @@ static void install_bp_hardening_cb(bp_h
 
 	__this_cpu_write(bp_hardening_data.hyp_vectors_slot, slot);
 	__this_cpu_write(bp_hardening_data.fn, fn);
+	__this_cpu_write(bp_hardening_data.template_start, hyp_vecs_start);
 	raw_spin_unlock(&bp_lock);
 }
 #else
@@ -819,3 +820,47 @@ enum mitigation_state arm64_get_spectre_
 {
 	return spectre_bhb_state;
 }
+
+static int kvm_bhb_get_vecs_size(const char *start)
+{
+	if (start == __smccc_workaround_3_smc)
+		return __SMCCC_WORKAROUND_3_SMC_SZ;
+	else if (start == __spectre_bhb_loop_k8 ||
+		 start == __spectre_bhb_loop_k24 ||
+		 start == __spectre_bhb_loop_k32)
+		return __SPECTRE_BHB_LOOP_SZ;
+
+	return 0;
+}
+
+void kvm_setup_bhb_slot(const char *hyp_vecs_start)
+{
+	int cpu, slot = -1, size;
+	const char *hyp_vecs_end;
+
+	if (!IS_ENABLED(CONFIG_KVM) || !is_hyp_mode_available())
+		return;
+
+	size = kvm_bhb_get_vecs_size(hyp_vecs_start);
+	if (WARN_ON_ONCE(!hyp_vecs_start || !size))
+		return;
+	hyp_vecs_end = hyp_vecs_start + size;
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
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1337,7 +1337,8 @@ static int kvm_map_vectors(void)
 	 * !SV2 +  HEL2 -> allocate one vector slot and use exec mapping
 	 *  SV2 +  HEL2 -> use hardened vectors and use exec mapping
 	 */
-	if (cpus_have_const_cap(ARM64_SPECTRE_V2)) {
+	if (cpus_have_const_cap(ARM64_SPECTRE_V2) ||
+	    cpus_have_const_cap(ARM64_SPECTRE_BHB)) {
 		__kvm_bp_vect_base = kvm_ksym_ref(__bp_harden_hyp_vecs);
 		__kvm_bp_vect_base = kern_hyp_va(__kvm_bp_vect_base);
 	}
--- a/arch/arm64/kvm/hyp/smccc_wa.S
+++ b/arch/arm64/kvm/hyp/smccc_wa.S
@@ -30,3 +30,69 @@ SYM_DATA_START(__smccc_workaround_1_smc)
 1:	.org __smccc_workaround_1_smc + __SMCCC_WORKAROUND_1_SMC_SZ
 	.org 1b
 SYM_DATA_END(__smccc_workaround_1_smc)
+
+	.global		__smccc_workaround_3_smc
+SYM_DATA_START(__smccc_workaround_3_smc)
+	esb
+	sub	sp, sp, #(8 * 4)
+	stp	x2, x3, [sp, #(8 * 0)]
+	stp	x0, x1, [sp, #(8 * 2)]
+	mov	w0, #ARM_SMCCC_ARCH_WORKAROUND_3
+	smc	#0
+	ldp	x2, x3, [sp, #(8 * 0)]
+	ldp	x0, x1, [sp, #(8 * 2)]
+	add	sp, sp, #(8 * 4)
+1:	.org __smccc_workaround_3_smc + __SMCCC_WORKAROUND_3_SMC_SZ
+	.org 1b
+SYM_DATA_END(__smccc_workaround_3_smc)
+
+	.global	__spectre_bhb_loop_k8
+SYM_DATA_START(__spectre_bhb_loop_k8)
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
+1:	.org __spectre_bhb_loop_k8 + __SPECTRE_BHB_LOOP_SZ
+	.org 1b
+SYM_DATA_END(__spectre_bhb_loop_k8)
+
+	.global	__spectre_bhb_loop_k24
+SYM_DATA_START(__spectre_bhb_loop_k24)
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
+1:	.org __spectre_bhb_loop_k24 + __SPECTRE_BHB_LOOP_SZ
+	.org 1b
+SYM_DATA_END(__spectre_bhb_loop_k24)
+
+	.global	__spectre_bhb_loop_k32
+SYM_DATA_START(__spectre_bhb_loop_k32)
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
+1:	.org __spectre_bhb_loop_k32 + __SPECTRE_BHB_LOOP_SZ
+	.org 1b
+SYM_DATA_END(__spectre_bhb_loop_k32)


