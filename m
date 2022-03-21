Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 526C14E28A7
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 14:59:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348365AbiCUOAB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 10:00:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348821AbiCUN6V (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 09:58:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0BB3176D01;
        Mon, 21 Mar 2022 06:56:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC8D66125C;
        Mon, 21 Mar 2022 13:56:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9F06C340E8;
        Mon, 21 Mar 2022 13:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647870995;
        bh=Vko4cyW+Nw/R5I8IKKXg5qbSfnjAOoJNf4fSsUB6sdI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Di1oo2VSFklBzNou0mDHe9zXYJR2hjtFYnVGEUCYkL4gJIA1BF75Rzkjw25VZVB+j
         JdUy26Zl+W1RNHt3LXPAmdrftKW0rWRX4hoM7b/uMqsxk9CL8IRz/vS/yOE+L8wzT2
         vgqiMvPu060NlVdvC0ZwUbLjeZs8/jun2Zs8fRso=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>
Subject: [PATCH 4.19 44/57] arm64: Use the clearbhb instruction in mitigations
Date:   Mon, 21 Mar 2022 14:52:25 +0100
Message-Id: <20220321133223.270158349@linuxfoundation.org>
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

commit 228a26b912287934789023b4132ba76065d9491c upstream.

Future CPUs may implement a clearbhb instruction that is sufficient
to mitigate SpectreBHB. CPUs that implement this instruction, but
not CSV2.3 must be affected by Spectre-BHB.

Add support to use this instruction as the BHB mitigation on CPUs
that support it. The instruction is in the hint space, so it will
be treated by a NOP as older CPUs.

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
[ modified for stable: Use a KVM vector template instead of alternatives ]
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/assembler.h  |    7 +++++++
 arch/arm64/include/asm/cpufeature.h |   13 +++++++++++++
 arch/arm64/include/asm/sysreg.h     |    3 +++
 arch/arm64/include/asm/vectors.h    |    7 +++++++
 arch/arm64/kernel/cpu_errata.c      |   14 ++++++++++++++
 arch/arm64/kernel/cpufeature.c      |    1 +
 arch/arm64/kernel/entry.S           |    8 ++++++++
 arch/arm64/kvm/hyp/hyp-entry.S      |    6 ++++++
 8 files changed, 59 insertions(+)

--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -127,6 +127,13 @@
 	.endm
 
 /*
+ * Clear Branch History instruction
+ */
+	.macro clearbhb
+	hint	#22
+	.endm
+
+/*
  * Sanitise a 64-bit bounded index wrt speculation, returning zero if out
  * of bounds.
  */
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -497,6 +497,19 @@ static inline bool supports_csv2p3(int s
 	return csv2_val == 3;
 }
 
+static inline bool supports_clearbhb(int scope)
+{
+	u64 isar2;
+
+	if (scope == SCOPE_LOCAL_CPU)
+		isar2 = read_sysreg_s(SYS_ID_AA64ISAR2_EL1);
+	else
+		isar2 = read_sanitised_ftr_reg(SYS_ID_AA64ISAR2_EL1);
+
+	return cpuid_feature_extract_unsigned_field(isar2,
+						    ID_AA64ISAR2_CLEARBHB_SHIFT);
+}
+
 static inline bool system_supports_32bit_el0(void)
 {
 	return cpus_have_const_cap(ARM64_HAS_32BIT_EL0);
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -527,6 +527,9 @@
 #define ID_AA64ISAR1_JSCVT_SHIFT	12
 #define ID_AA64ISAR1_DPB_SHIFT		0
 
+/* id_aa64isar2 */
+#define ID_AA64ISAR2_CLEARBHB_SHIFT	28
+
 /* id_aa64pfr0 */
 #define ID_AA64PFR0_CSV3_SHIFT		60
 #define ID_AA64PFR0_CSV2_SHIFT		56
--- a/arch/arm64/include/asm/vectors.h
+++ b/arch/arm64/include/asm/vectors.h
@@ -33,6 +33,12 @@ enum arm64_bp_harden_el1_vectors {
 	 * canonical vectors.
 	 */
 	EL1_VECTOR_BHB_FW,
+
+	/*
+	 * Use the ClearBHB instruction, before branching to the canonical
+	 * vectors.
+	 */
+	EL1_VECTOR_BHB_CLEAR_INSN,
 #endif /* CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY */
 
 	/*
@@ -44,6 +50,7 @@ enum arm64_bp_harden_el1_vectors {
 #ifndef CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY
 #define EL1_VECTOR_BHB_LOOP		-1
 #define EL1_VECTOR_BHB_FW		-1
+#define EL1_VECTOR_BHB_CLEAR_INSN	-1
 #endif /* !CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY */
 
 /* The vectors to use on return from EL0. e.g. to remap the kernel */
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -106,6 +106,8 @@ extern char __spectre_bhb_loop_k24_start
 extern char __spectre_bhb_loop_k24_end[];
 extern char __spectre_bhb_loop_k32_start[];
 extern char __spectre_bhb_loop_k32_end[];
+extern char __spectre_bhb_clearbhb_start[];
+extern char __spectre_bhb_clearbhb_end[];
 
 static void __copy_hyp_vect_bpi(int slot, const char *hyp_vecs_start,
 				const char *hyp_vecs_end)
@@ -969,6 +971,7 @@ static void update_mitigation_state(enum
  * - Mitigated by a branchy loop a CPU specific number of times, and listed
  *   in our "loop mitigated list".
  * - Mitigated in software by the firmware Spectre v2 call.
+ * - Has the ClearBHB instruction to perform the mitigation.
  * - Has the 'Exception Clears Branch History Buffer' (ECBHB) feature, so no
  *   software mitigation in the vectors is needed.
  * - Has CSV2.3, so is unaffected.
@@ -1108,6 +1111,9 @@ bool is_spectre_bhb_affected(const struc
 	if (supports_csv2p3(scope))
 		return false;
 
+	if (supports_clearbhb(scope))
+		return true;
+
 	if (spectre_bhb_loop_affected(scope))
 		return true;
 
@@ -1148,6 +1154,8 @@ static const char *kvm_bhb_get_vecs_end(
 		return __spectre_bhb_loop_k24_end;
 	else if (start == __spectre_bhb_loop_k32_start)
 		return __spectre_bhb_loop_k32_end;
+	else if (start == __spectre_bhb_clearbhb_start)
+		return __spectre_bhb_clearbhb_end;
 
 	return NULL;
 }
@@ -1187,6 +1195,7 @@ static void kvm_setup_bhb_slot(const cha
 #define __spectre_bhb_loop_k8_start NULL
 #define __spectre_bhb_loop_k24_start NULL
 #define __spectre_bhb_loop_k32_start NULL
+#define __spectre_bhb_clearbhb_start NULL
 
 static void kvm_setup_bhb_slot(const char *hyp_vecs_start) { };
 #endif
@@ -1206,6 +1215,11 @@ void spectre_bhb_enable_mitigation(const
 		pr_info_once("spectre-bhb mitigation disabled by command line option\n");
 	} else if (supports_ecbhb(SCOPE_LOCAL_CPU)) {
 		state = SPECTRE_MITIGATED;
+	} else if (supports_clearbhb(SCOPE_LOCAL_CPU)) {
+		kvm_setup_bhb_slot(__spectre_bhb_clearbhb_start);
+		this_cpu_set_vectors(EL1_VECTOR_BHB_CLEAR_INSN);
+
+		state = SPECTRE_MITIGATED;
 	} else if (spectre_bhb_loop_affected(SCOPE_LOCAL_CPU)) {
 		switch (spectre_bhb_loop_affected(SCOPE_SYSTEM)) {
 		case 8:
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -151,6 +151,7 @@ static const struct arm64_ftr_bits ftr_i
 };
 
 static const struct arm64_ftr_bits ftr_id_aa64isar2[] = {
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_HIGHER_SAFE, ID_AA64ISAR2_CLEARBHB_SHIFT, 4, 0),
 	ARM64_FTR_END,
 };
 
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -981,6 +981,7 @@ alternative_else_nop_endif
 #define BHB_MITIGATION_NONE	0
 #define BHB_MITIGATION_LOOP	1
 #define BHB_MITIGATION_FW	2
+#define BHB_MITIGATION_INSN	3
 
 	.macro tramp_ventry, vector_start, regsize, kpti, bhb
 	.align	7
@@ -997,6 +998,11 @@ alternative_else_nop_endif
 	__mitigate_spectre_bhb_loop	x30
 	.endif // \bhb == BHB_MITIGATION_LOOP
 
+	.if	\bhb == BHB_MITIGATION_INSN
+	clearbhb
+	isb
+	.endif // \bhb == BHB_MITIGATION_INSN
+
 	.if	\kpti == 1
 	/*
 	 * Defend against branch aliasing attacks by pushing a dummy
@@ -1073,6 +1079,7 @@ ENTRY(tramp_vectors)
 #ifdef CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY
 	generate_tramp_vector	kpti=1, bhb=BHB_MITIGATION_LOOP
 	generate_tramp_vector	kpti=1, bhb=BHB_MITIGATION_FW
+	generate_tramp_vector	kpti=1, bhb=BHB_MITIGATION_INSN
 #endif /* CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY */
 	generate_tramp_vector	kpti=1, bhb=BHB_MITIGATION_NONE
 END(tramp_vectors)
@@ -1135,6 +1142,7 @@ ENTRY(__bp_harden_el1_vectors)
 #ifdef CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY
 	generate_el1_vector	bhb=BHB_MITIGATION_LOOP
 	generate_el1_vector	bhb=BHB_MITIGATION_FW
+	generate_el1_vector	bhb=BHB_MITIGATION_INSN
 #endif /* CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY */
 END(__bp_harden_el1_vectors)
 	.popsection
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -392,4 +392,10 @@ ENTRY(__spectre_bhb_loop_k32_start)
 	ldp	x0, x1, [sp, #(8 * 0)]
 	add	sp, sp, #(8 * 2)
 ENTRY(__spectre_bhb_loop_k32_end)
+
+ENTRY(__spectre_bhb_clearbhb_start)
+	esb
+	clearbhb
+	isb
+ENTRY(__spectre_bhb_clearbhb_end)
 #endif


