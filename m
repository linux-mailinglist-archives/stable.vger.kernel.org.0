Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6CCE67D2
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:25:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732549AbfJ0VYg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:24:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:46228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732543AbfJ0VYf (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:24:35 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E9F421848;
        Sun, 27 Oct 2019 21:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211474;
        bh=Xq9KU1AaD3YXp8m1yI2+LyCjoRIwmgbYZasbLkrCLEo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MGNeh7UXgA2MAWBbZBOU22/ctSdXWyf8hUQV9NA3iSjFaCLJ0loNHzg8Vfpki6S2D
         +AxKKRNppDmR/jZ8RpdPAKTCfn8/zPNEQKKm8/zFWremFbQ+4jetwvawFuEIpEKe92
         OMdPJLQ3/yv/rSkn/TzZubTISeYB836GKFiUfU/o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 5.3 163/197] arm64: KVM: Trap VM ops when ARM64_WORKAROUND_CAVIUM_TX2_219_TVM is set
Date:   Sun, 27 Oct 2019 22:01:21 +0100
Message-Id: <20191027203402.719521287@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <marc.zyngier@arm.com>

commit d3ec3a08fa700c8b46abb137dce4e2514a6f9668 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/include/asm/cpucaps.h |    3 +
 arch/arm64/kvm/hyp/switch.c      |   69 +++++++++++++++++++++++++++++++++++++--
 2 files changed, 69 insertions(+), 3 deletions(-)

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
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -124,6 +124,9 @@ static void __hyp_text __activate_traps(
 {
 	u64 hcr = vcpu->arch.hcr_el2;
 
+	if (cpus_have_const_cap(ARM64_WORKAROUND_CAVIUM_TX2_219_TVM))
+		hcr |= HCR_TVM;
+
 	write_sysreg(hcr, hcr_el2);
 
 	if (cpus_have_const_cap(ARM64_HAS_RAS_EXTN) && (hcr & HCR_VSE))
@@ -174,8 +177,10 @@ static void __hyp_text __deactivate_trap
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
@@ -393,6 +398,61 @@ static bool __hyp_text __hyp_handle_fpsi
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
@@ -412,6 +472,11 @@ static bool __hyp_text fixup_guest_exit(
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


