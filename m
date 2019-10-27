Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA61E62BC
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 14:53:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbfJ0NxO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 09:53:14 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:55139 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726687AbfJ0NxO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Oct 2019 09:53:14 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 709E621C08;
        Sun, 27 Oct 2019 09:53:13 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 27 Oct 2019 09:53:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=wMypLS
        zO4PFAIFSCr6Lnta8H68HfXHWNdqseXIuMDZY=; b=eYmf4vTOHCabOJkZonqruX
        d+0fTOoE6Qpxk/zA+V9KwASZrchBO3CvqZBwXFgcMSlSGvVTjgJgHYv81dAZrpTK
        aeV35FiHaHQkwsEH3q0iwMrrEIOd1LxqcbewYxkxWJTPWXAhMnWGv5cXeJVR0tJc
        6vMdQVHbLtlJkA/6YY/7MqgL4TLYuH8bO5F3xBLzLdYuL8WgWiSD6Xdjmv4HA48s
        xm5ksW12TBom2TezWzgPijrDD8pEMWf4NouMUCX/4128dQW5wy6nl0rg+MHcEn9l
        T3aCK2tXAuYlbNL6064NlwD+KVSwLFrOaFLvN6LiTvvKeV5g0xKUFAWQm0UYu0eg
        ==
X-ME-Sender: <xms:SaG1XeSlEngCQ9whxRo9aEZsIZcncN_GRBX4G8VEwyjV3QKf0yBsjw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrleejgdeitdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepjeejrddvgedurddvvdelrddvfedvnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:SaG1XZ5kYBOSFaut-aJGrTJI6lJS3elxHmVoOxPho8z7j_5tkO6wag>
    <xmx:SaG1XegbdJqjmO5zwKkoD5hMuS_6dbkbeXFqJStLVPNOCOucqDKusA>
    <xmx:SaG1XX1gvU4tk_bzXP_M-722dH8Nh3I4p9Hp36w9AF4SEqNRJU67Dw>
    <xmx:SaG1Xfb1RCv3n_sQ_VykzgO8RoWlLm5KxKoOI_Rhgs4zbOkLM4f9nA>
Received: from localhost (unknown [77.241.229.232])
        by mail.messagingengine.com (Postfix) with ESMTPA id D313E80060;
        Sun, 27 Oct 2019 09:53:12 -0400 (EDT)
Subject: FAILED: patch "[PATCH] arm64: KVM: Trap VM ops when" failed to apply to 4.19-stable tree
To:     maz@kernel.org, marc.zyngier@arm.com, stable@vger.kernel.org,
        will@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 27 Oct 2019 14:53:10 +0100
Message-ID: <157218439011424@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d3ec3a08fa700c8b46abb137dce4e2514a6f9668 Mon Sep 17 00:00:00 2001
From: Marc Zyngier <maz@kernel.org>
Date: Thu, 7 Feb 2019 16:01:21 +0000
Subject: [PATCH] arm64: KVM: Trap VM ops when
 ARM64_WORKAROUND_CAVIUM_TX2_219_TVM is set

In order to workaround the TX2-219 erratum, it is necessary to trap
TTBRx_EL1 accesses to EL2. This is done by setting HCR_EL2.TVM on
guest entry, which has the side effect of trapping all the other
VM-related sysregs as well.

To minimize the overhead, a fast path is used so that we don't
have to go all the way back to the main sysreg handling code,
unless the rest of the hypervisor expects to see these accesses.

Cc: <stable@vger.kernel.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>

diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index f19fe4b9acc4..e81e0cbd728f 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -52,7 +52,8 @@
 #define ARM64_HAS_IRQ_PRIO_MASKING		42
 #define ARM64_HAS_DCPODP			43
 #define ARM64_WORKAROUND_1463225		44
+#define ARM64_WORKAROUND_CAVIUM_TX2_219_TVM	45
 
-#define ARM64_NCAPS				45
+#define ARM64_NCAPS				46
 
 #endif /* __ASM_CPUCAPS_H */
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 3d3815020e36..799e84a40335 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -124,6 +124,9 @@ static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
 {
 	u64 hcr = vcpu->arch.hcr_el2;
 
+	if (cpus_have_const_cap(ARM64_WORKAROUND_CAVIUM_TX2_219_TVM))
+		hcr |= HCR_TVM;
+
 	write_sysreg(hcr, hcr_el2);
 
 	if (cpus_have_const_cap(ARM64_HAS_RAS_EXTN) && (hcr & HCR_VSE))
@@ -174,8 +177,10 @@ static void __hyp_text __deactivate_traps(struct kvm_vcpu *vcpu)
 	 * the crucial bit is "On taking a vSError interrupt,
 	 * HCR_EL2.VSE is cleared to 0."
 	 */
-	if (vcpu->arch.hcr_el2 & HCR_VSE)
-		vcpu->arch.hcr_el2 = read_sysreg(hcr_el2);
+	if (vcpu->arch.hcr_el2 & HCR_VSE) {
+		vcpu->arch.hcr_el2 &= ~HCR_VSE;
+		vcpu->arch.hcr_el2 |= read_sysreg(hcr_el2) & HCR_VSE;
+	}
 
 	if (has_vhe())
 		deactivate_traps_vhe();
@@ -380,6 +385,61 @@ static bool __hyp_text __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
 	return true;
 }
 
+static bool __hyp_text handle_tx2_tvm(struct kvm_vcpu *vcpu)
+{
+	u32 sysreg = esr_sys64_to_sysreg(kvm_vcpu_get_hsr(vcpu));
+	int rt = kvm_vcpu_sys_get_rt(vcpu);
+	u64 val = vcpu_get_reg(vcpu, rt);
+
+	/*
+	 * The normal sysreg handling code expects to see the traps,
+	 * let's not do anything here.
+	 */
+	if (vcpu->arch.hcr_el2 & HCR_TVM)
+		return false;
+
+	switch (sysreg) {
+	case SYS_SCTLR_EL1:
+		write_sysreg_el1(val, SYS_SCTLR);
+		break;
+	case SYS_TTBR0_EL1:
+		write_sysreg_el1(val, SYS_TTBR0);
+		break;
+	case SYS_TTBR1_EL1:
+		write_sysreg_el1(val, SYS_TTBR1);
+		break;
+	case SYS_TCR_EL1:
+		write_sysreg_el1(val, SYS_TCR);
+		break;
+	case SYS_ESR_EL1:
+		write_sysreg_el1(val, SYS_ESR);
+		break;
+	case SYS_FAR_EL1:
+		write_sysreg_el1(val, SYS_FAR);
+		break;
+	case SYS_AFSR0_EL1:
+		write_sysreg_el1(val, SYS_AFSR0);
+		break;
+	case SYS_AFSR1_EL1:
+		write_sysreg_el1(val, SYS_AFSR1);
+		break;
+	case SYS_MAIR_EL1:
+		write_sysreg_el1(val, SYS_MAIR);
+		break;
+	case SYS_AMAIR_EL1:
+		write_sysreg_el1(val, SYS_AMAIR);
+		break;
+	case SYS_CONTEXTIDR_EL1:
+		write_sysreg_el1(val, SYS_CONTEXTIDR);
+		break;
+	default:
+		return false;
+	}
+
+	__kvm_skip_instr(vcpu);
+	return true;
+}
+
 /*
  * Return true when we were able to fixup the guest exit and should return to
  * the guest, false when we should restore the host state and return to the
@@ -399,6 +459,11 @@ static bool __hyp_text fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 	if (*exit_code != ARM_EXCEPTION_TRAP)
 		goto exit;
 
+	if (cpus_have_const_cap(ARM64_WORKAROUND_CAVIUM_TX2_219_TVM) &&
+	    kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_SYS64 &&
+	    handle_tx2_tvm(vcpu))
+		return true;
+
 	/*
 	 * We trap the first access to the FP/SIMD to save the host context
 	 * and restore the guest context lazily.

