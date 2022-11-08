Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18E526215F3
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:17:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235368AbiKHORI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:17:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235384AbiKHOQ7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:16:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8975869DFF
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:16:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1FD1D60025
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:16:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E07DC433C1;
        Tue,  8 Nov 2022 14:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667917017;
        bh=2x/Bge969e9gjoVgSJ+j7Zsap4/QlhCOcxjW+sUBxXc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WsPFPYokdIsnLl06wbv0EaRl21CXvABuM+KXXAJvn0LtqlwrZMUNIBCugiE70TRns
         LPeVxpR70RvhOL8pe5r1cQpF4WyuTKWvUiVLwnJrBwxEQrJwDrlaFpgzdN+I7V7Alg
         SS3FIxg56latzv8IUAiisyd1eZ0gDIGZR3WBYDOY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mark Brown <broonie@kernel.org>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.0 182/197] KVM: arm64: Fix SMPRI_EL1/TPIDR2_EL0 trapping on VHE
Date:   Tue,  8 Nov 2022 14:40:20 +0100
Message-Id: <20221108133403.169002189@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

commit 4151bb636acf32bb2e6126cec8216b023117c0e9 upstream.

The trapping of SMPRI_EL1 and TPIDR2_EL0 currently only really
work on nVHE, as only this mode uses the fine-grained trapping
that controls these two registers.

Move the trapping enable/disable code into
__{de,}activate_traps_common(), allowing it to be called when it
actually matters on VHE, and remove the flipping of EL2 control
for TPIDR2_EL0, which only affects the host access of this
register.

Fixes: 861262ab8627 ("KVM: arm64: Handle SME host state when running guests")
Reported-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/86bkpqer4z.wl-maz@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 20 +++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/switch.c        | 26 -------------------------
 arch/arm64/kvm/hyp/vhe/switch.c         |  8 --------
 3 files changed, 20 insertions(+), 34 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 6cbbb6c02f66..3330d1b76bdd 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -87,6 +87,17 @@ static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.mdcr_el2_host = read_sysreg(mdcr_el2);
 	write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
+
+	if (cpus_have_final_cap(ARM64_SME)) {
+		sysreg_clear_set_s(SYS_HFGRTR_EL2,
+				   HFGxTR_EL2_nSMPRI_EL1_MASK |
+				   HFGxTR_EL2_nTPIDR2_EL0_MASK,
+				   0);
+		sysreg_clear_set_s(SYS_HFGWTR_EL2,
+				   HFGxTR_EL2_nSMPRI_EL1_MASK |
+				   HFGxTR_EL2_nTPIDR2_EL0_MASK,
+				   0);
+	}
 }
 
 static inline void __deactivate_traps_common(struct kvm_vcpu *vcpu)
@@ -96,6 +107,15 @@ static inline void __deactivate_traps_common(struct kvm_vcpu *vcpu)
 	write_sysreg(0, hstr_el2);
 	if (kvm_arm_support_pmu_v3())
 		write_sysreg(0, pmuserenr_el0);
+
+	if (cpus_have_final_cap(ARM64_SME)) {
+		sysreg_clear_set_s(SYS_HFGRTR_EL2, 0,
+				   HFGxTR_EL2_nSMPRI_EL1_MASK |
+				   HFGxTR_EL2_nTPIDR2_EL0_MASK);
+		sysreg_clear_set_s(SYS_HFGWTR_EL2, 0,
+				   HFGxTR_EL2_nSMPRI_EL1_MASK |
+				   HFGxTR_EL2_nTPIDR2_EL0_MASK);
+	}
 }
 
 static inline void ___activate_traps(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 8e9d49a964be..c2cb46ca4fb6 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -55,18 +55,6 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 	write_sysreg(val, cptr_el2);
 	write_sysreg(__this_cpu_read(kvm_hyp_vector), vbar_el2);
 
-	if (cpus_have_final_cap(ARM64_SME)) {
-		val = read_sysreg_s(SYS_HFGRTR_EL2);
-		val &= ~(HFGxTR_EL2_nTPIDR2_EL0_MASK |
-			 HFGxTR_EL2_nSMPRI_EL1_MASK);
-		write_sysreg_s(val, SYS_HFGRTR_EL2);
-
-		val = read_sysreg_s(SYS_HFGWTR_EL2);
-		val &= ~(HFGxTR_EL2_nTPIDR2_EL0_MASK |
-			 HFGxTR_EL2_nSMPRI_EL1_MASK);
-		write_sysreg_s(val, SYS_HFGWTR_EL2);
-	}
-
 	if (cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
 		struct kvm_cpu_context *ctxt = &vcpu->arch.ctxt;
 
@@ -110,20 +98,6 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
 
 	write_sysreg(this_cpu_ptr(&kvm_init_params)->hcr_el2, hcr_el2);
 
-	if (cpus_have_final_cap(ARM64_SME)) {
-		u64 val;
-
-		val = read_sysreg_s(SYS_HFGRTR_EL2);
-		val |= HFGxTR_EL2_nTPIDR2_EL0_MASK |
-			HFGxTR_EL2_nSMPRI_EL1_MASK;
-		write_sysreg_s(val, SYS_HFGRTR_EL2);
-
-		val = read_sysreg_s(SYS_HFGWTR_EL2);
-		val |= HFGxTR_EL2_nTPIDR2_EL0_MASK |
-			HFGxTR_EL2_nSMPRI_EL1_MASK;
-		write_sysreg_s(val, SYS_HFGWTR_EL2);
-	}
-
 	cptr = CPTR_EL2_DEFAULT;
 	if (vcpu_has_sve(vcpu) && (vcpu->arch.fp_state == FP_STATE_GUEST_OWNED))
 		cptr |= CPTR_EL2_TZ;
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 7acb87eaa092..1a97391fedd2 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -63,10 +63,6 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 		__activate_traps_fpsimd32(vcpu);
 	}
 
-	if (cpus_have_final_cap(ARM64_SME))
-		write_sysreg(read_sysreg(sctlr_el2) & ~SCTLR_ELx_ENTP2,
-			     sctlr_el2);
-
 	write_sysreg(val, cpacr_el1);
 
 	write_sysreg(__this_cpu_read(kvm_hyp_vector), vbar_el1);
@@ -88,10 +84,6 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
 	 */
 	asm(ALTERNATIVE("nop", "isb", ARM64_WORKAROUND_SPECULATIVE_AT));
 
-	if (cpus_have_final_cap(ARM64_SME))
-		write_sysreg(read_sysreg(sctlr_el2) | SCTLR_ELx_ENTP2,
-			     sctlr_el2);
-
 	write_sysreg(CPACR_EL1_DEFAULT, cpacr_el1);
 
 	if (!arm64_kernel_unmapped_at_el0())
-- 
2.38.1



