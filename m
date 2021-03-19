Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4342341C21
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 13:19:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbhCSMTI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 08:19:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:56712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229927AbhCSMS7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Mar 2021 08:18:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80BBB64E6B;
        Fri, 19 Mar 2021 12:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616156339;
        bh=vNtx8cgjKdf/xhZ3hd9sIN85Vr13yTXF3L7bwA5bR4A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gYBY+OioC0UdgdzeH1pOQi4bBGeGFGtcIfxe9Fcm8tPmgZc+ZDJNAxQtz2M7RbPZE
         8emQTnsaffqGZ8u6NWR8KQdfrjwgm2o95KnKsRY3RFryhhdU7wCMI+mWYJ+wuft/lg
         JZmpNqRJ6JHnYbUV33v104CEvgx28+1quHkbLeEo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christoffer Dall <christoffer.dall@arm.com>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 01/18] KVM: arm64: nvhe: Save the SPE context early
Date:   Fri, 19 Mar 2021 13:18:39 +0100
Message-Id: <20210319121745.495601039@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210319121745.449875976@linuxfoundation.org>
References: <20210319121745.449875976@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suzuki K Poulose <suzuki.poulose@arm.com>

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
Acked-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/kvm_hyp.h |    3 +++
 arch/arm64/kvm/hyp/debug-sr.c    |   24 +++++++++++++++---------
 arch/arm64/kvm/hyp/switch.c      |   13 ++++++++++++-
 3 files changed, 30 insertions(+), 10 deletions(-)

--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -71,6 +71,9 @@ void __sysreg32_restore_state(struct kvm
 
 void __debug_switch_to_guest(struct kvm_vcpu *vcpu);
 void __debug_switch_to_host(struct kvm_vcpu *vcpu);
+void __debug_save_host_buffers_nvhe(struct kvm_vcpu *vcpu);
+void __debug_restore_host_buffers_nvhe(struct kvm_vcpu *vcpu);
+
 
 void __fpsimd_save_state(struct user_fpsimd_state *fp_regs);
 void __fpsimd_restore_state(struct user_fpsimd_state *fp_regs);
--- a/arch/arm64/kvm/hyp/debug-sr.c
+++ b/arch/arm64/kvm/hyp/debug-sr.c
@@ -168,6 +168,21 @@ static void __hyp_text __debug_restore_s
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
@@ -175,13 +190,6 @@ void __hyp_text __debug_switch_to_guest(
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
 
@@ -201,8 +209,6 @@ void __hyp_text __debug_switch_to_host(s
 	struct kvm_guest_debug_arch *host_dbg;
 	struct kvm_guest_debug_arch *guest_dbg;
 
-	if (!has_vhe())
-		__debug_restore_spe_nvhe(vcpu->arch.host_debug_state.pmscr_el1);
 
 	if (!(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY))
 		return;
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -682,6 +682,15 @@ int __hyp_text __kvm_vcpu_run_nvhe(struc
 
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
 
@@ -720,11 +729,13 @@ int __hyp_text __kvm_vcpu_run_nvhe(struc
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


