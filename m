Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D51F133DCA0
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 19:35:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236941AbhCPSea (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 14:34:30 -0400
Received: from foss.arm.com ([217.140.110.172]:55918 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240031AbhCPSeH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 14:34:07 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 79A2931B;
        Tue, 16 Mar 2021 11:34:06 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 772B03F70D;
        Tue, 16 Mar 2021 11:34:05 -0700 (PDT)
From:   Suzuki K Poulose <suzuki.poulose@arm.com>
To:     stable@vger.kernel.org
Cc:     suzuki.poulose@arm.com, maz@kernel.org, catalin.marinas@arm.com,
        will@kernel.org, alexandru.elisei@arm.com, christoffer.dall@arm.com
Subject: [PATCH] KVM: arm64: nvhe: Save the SPE context early
Date:   Tue, 16 Mar 2021 18:33:53 +0000
Message-Id: <20210316183353.4081445-1-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <16157981451454@kroah.com>
References: <16157981451454@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit b96b0c5de685df82019e16826a282d53d86d112c upstream

The nVHE KVM hyp drains and disables the SPE buffer, before
entering the guest, as the EL1&0 translation regime
is going to be loaded with that of the guest.

But this operation is performed way too late, because :
 - The owning translation regime of the SPE buffer
   is transferred to EL2. (MDCR_EL2_E2PB == 0)
 - The guest Stage1 is loaded.

Thus the flush could use the host EL1 virtual address,
but use the EL2 translations instead of host EL1, for writing
out any cached data.

Fix this by moving the SPE buffer handling early enough.
The restore path is doing the right thing.

Cc: stable@vger.kernel.org # v5.4-
Cc: Christoffer Dall <christoffer.dall@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm64/include/asm/kvm_hyp.h |  3 +++
 arch/arm64/kvm/hyp/debug-sr.c    | 24 +++++++++++++++---------
 arch/arm64/kvm/hyp/switch.c      | 13 ++++++++++++-
 3 files changed, 30 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 97f21cc66657..7f7fdb16bb96 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -71,6 +71,9 @@ void __sysreg32_restore_state(struct kvm_vcpu *vcpu);
 
 void __debug_switch_to_guest(struct kvm_vcpu *vcpu);
 void __debug_switch_to_host(struct kvm_vcpu *vcpu);
+void __debug_save_host_buffers_nvhe(struct kvm_vcpu *vcpu);
+void __debug_restore_host_buffers_nvhe(struct kvm_vcpu *vcpu);
+
 
 void __fpsimd_save_state(struct user_fpsimd_state *fp_regs);
 void __fpsimd_restore_state(struct user_fpsimd_state *fp_regs);
diff --git a/arch/arm64/kvm/hyp/debug-sr.c b/arch/arm64/kvm/hyp/debug-sr.c
index 0fc9872a1467..aead8a5fbe91 100644
--- a/arch/arm64/kvm/hyp/debug-sr.c
+++ b/arch/arm64/kvm/hyp/debug-sr.c
@@ -168,6 +168,21 @@ static void __hyp_text __debug_restore_state(struct kvm_vcpu *vcpu,
 	write_sysreg(ctxt->sys_regs[MDCCINT_EL1], mdccint_el1);
 }
 
+void __hyp_text __debug_save_host_buffers_nvhe(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * Non-VHE: Disable and flush SPE data generation
+	 * VHE: The vcpu can run, but it can't hide.
+	 */
+	__debug_save_spe_nvhe(&vcpu->arch.host_debug_state.pmscr_el1);
+
+}
+
+void __hyp_text __debug_restore_host_buffers_nvhe(struct kvm_vcpu *vcpu)
+{
+	__debug_restore_spe_nvhe(vcpu->arch.host_debug_state.pmscr_el1);
+}
+
 void __hyp_text __debug_switch_to_guest(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *host_ctxt;
@@ -175,13 +190,6 @@ void __hyp_text __debug_switch_to_guest(struct kvm_vcpu *vcpu)
 	struct kvm_guest_debug_arch *host_dbg;
 	struct kvm_guest_debug_arch *guest_dbg;
 
-	/*
-	 * Non-VHE: Disable and flush SPE data generation
-	 * VHE: The vcpu can run, but it can't hide.
-	 */
-	if (!has_vhe())
-		__debug_save_spe_nvhe(&vcpu->arch.host_debug_state.pmscr_el1);
-
 	if (!(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY))
 		return;
 
@@ -201,8 +209,6 @@ void __hyp_text __debug_switch_to_host(struct kvm_vcpu *vcpu)
 	struct kvm_guest_debug_arch *host_dbg;
 	struct kvm_guest_debug_arch *guest_dbg;
 
-	if (!has_vhe())
-		__debug_restore_spe_nvhe(vcpu->arch.host_debug_state.pmscr_el1);
 
 	if (!(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY))
 		return;
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 84964983198e..14607fac7ca3 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -682,6 +682,15 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 
 	__sysreg_save_state_nvhe(host_ctxt);
 
+	/*
+	 * We must flush and disable the SPE buffer for nVHE, as
+	 * the translation regime(EL1&0) is going to be loaded with
+	 * that of the guest. And we must do this before we change the
+	 * translation regime to EL2 (via MDCR_EL2_EPB == 0) and
+	 * before we load guest Stage1.
+	 */
+	__debug_save_host_buffers_nvhe(vcpu);
+
 	__activate_vm(kern_hyp_va(vcpu->kvm));
 	__activate_traps(vcpu);
 
@@ -720,11 +729,13 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED)
 		__fpsimd_save_fpexc32(vcpu);
 
+	__debug_switch_to_host(vcpu);
+
 	/*
 	 * This must come after restoring the host sysregs, since a non-VHE
 	 * system may enable SPE here and make use of the TTBRs.
 	 */
-	__debug_switch_to_host(vcpu);
+	__debug_restore_host_buffers_nvhe(vcpu);
 
 	if (pmu_switch_needed)
 		__pmu_switch_to_host(host_ctxt);
-- 
2.24.1

