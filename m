Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCA70137F69
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:19:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730128AbgAKKTk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:19:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:39546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728998AbgAKKTj (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:19:39 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D62D20848;
        Sat, 11 Jan 2020 10:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578737978;
        bh=4pzCguaSA3GA/NKWEPxGAZQFJ/n6JIRy5P0TBnlxuC0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vSitBDcgWnuk8/SX9rymSm02eCwy39GbOpc8pbKEC9BM1BGtuCEeghgITxp1RGt+G
         r/CRyNbbUWMLP3RJLMANAgmQLTG2LvU7POXQnh0zz5SF49hOuSJB5L7ow2G85NQxUE
         zArksWhA1w9lK4efq5CAALq/SbmDKgipCkUC9Os8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 4.19 65/84] arm64: KVM: Trap VM ops when ARM64_WORKAROUND_CAVIUM_TX2_219_TVM is set
Date:   Sat, 11 Jan 2020 10:50:42 +0100
Message-Id: <20200111094910.328555272@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094845.328046411@linuxfoundation.org>
References: <20200111094845.328046411@linuxfoundation.org>
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
@@ -53,7 +53,8 @@
 #define ARM64_HAS_STAGE2_FWB			32
 #define ARM64_WORKAROUND_1463225		33
 #define ARM64_SSBS				34
+#define ARM64_WORKAROUND_CAVIUM_TX2_219_TVM	35
 
-#define ARM64_NCAPS				35
+#define ARM64_NCAPS				36
 
 #endif /* __ASM_CPUCAPS_H */
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -130,6 +130,9 @@ static void __hyp_text __activate_traps(
 {
 	u64 hcr = vcpu->arch.hcr_el2;
 
+	if (cpus_have_const_cap(ARM64_WORKAROUND_CAVIUM_TX2_219_TVM))
+		hcr |= HCR_TVM;
+
 	write_sysreg(hcr, hcr_el2);
 
 	if (cpus_have_const_cap(ARM64_HAS_RAS_EXTN) && (hcr & HCR_VSE))
@@ -172,8 +175,10 @@ static void __hyp_text __deactivate_trap
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
@@ -379,6 +384,61 @@ static bool __hyp_text __hyp_switch_fpsi
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
@@ -398,6 +458,11 @@ static bool __hyp_text fixup_guest_exit(
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


