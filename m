Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68C02341C23
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 13:19:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbhCSMTH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 08:19:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:56402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229912AbhCSMSu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Mar 2021 08:18:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5DADC64F6A;
        Fri, 19 Mar 2021 12:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616156318;
        bh=5CsTMcn3v44sIFL1IS2cb4O7xu4wo6KSRHC8DCYwOkk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gASIP4ZlDLGjG6CU3WsrqYi7KV9e5VjEY8F+35J+GtnFOhUoe6hvQBoSr8VSIjGjk
         khTvEoLd3LiK/2bi+xgg9cYGqJ5K5lQ6zQxgniMSEfxTQxnE8yokFs+cnJ1DiFdBN5
         rNRvc+Ec7P+RCgcZdlxhq4XiZpO2kfYsDNGEVhlM=
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
Subject: [PATCH 4.19 2/8] KVM: arm64: nvhe: Save the SPE context early
Date:   Fri, 19 Mar 2021 13:18:21 +0100
Message-Id: <20210319121744.191089441@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210319121744.114946147@linuxfoundation.org>
References: <20210319121744.114946147@linuxfoundation.org>
User-Agent: quilt/0.66
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

Cc: stable@vger.kernel.org # v4.19
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
 arch/arm64/include/asm/kvm_hyp.h |  3 +++
 arch/arm64/kvm/hyp/debug-sr.c    | 24 +++++++++++++++---------
 arch/arm64/kvm/hyp/switch.c      |  4 +++-
 3 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 384c34397619..5f52d6d670e9 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -144,6 +144,9 @@ void __sysreg32_restore_state(struct kvm_vcpu *vcpu);
 
 void __debug_switch_to_guest(struct kvm_vcpu *vcpu);
 void __debug_switch_to_host(struct kvm_vcpu *vcpu);
+void __debug_save_host_buffers_nvhe(struct kvm_vcpu *vcpu);
+void __debug_restore_host_buffers_nvhe(struct kvm_vcpu *vcpu);
+
 
 void __fpsimd_save_state(struct user_fpsimd_state *fp_regs);
 void __fpsimd_restore_state(struct user_fpsimd_state *fp_regs);
diff --git a/arch/arm64/kvm/hyp/debug-sr.c b/arch/arm64/kvm/hyp/debug-sr.c
index 50009766e5e5..3c5414633bb7 100644
--- a/arch/arm64/kvm/hyp/debug-sr.c
+++ b/arch/arm64/kvm/hyp/debug-sr.c
@@ -149,6 +149,21 @@ static void __hyp_text __debug_restore_state(struct kvm_vcpu *vcpu,
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
@@ -156,13 +171,6 @@ void __hyp_text __debug_switch_to_guest(struct kvm_vcpu *vcpu)
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
 
@@ -182,8 +190,6 @@ void __hyp_text __debug_switch_to_host(struct kvm_vcpu *vcpu)
 	struct kvm_guest_debug_arch *host_dbg;
 	struct kvm_guest_debug_arch *guest_dbg;
 
-	if (!has_vhe())
-		__debug_restore_spe_nvhe(vcpu->arch.host_debug_state.pmscr_el1);
 
 	if (!(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY))
 		return;
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 15312e429b7d..1d16ce0b7e0d 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -560,6 +560,7 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 	guest_ctxt = &vcpu->arch.ctxt;
 
 	__sysreg_save_state_nvhe(host_ctxt);
+	__debug_save_host_buffers_nvhe(vcpu);
 
 	__activate_traps(vcpu);
 	__activate_vm(kern_hyp_va(vcpu->kvm));
@@ -599,11 +600,12 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED)
 		__fpsimd_save_fpexc32(vcpu);
 
+	__debug_switch_to_host(vcpu);
 	/*
 	 * This must come after restoring the host sysregs, since a non-VHE
 	 * system may enable SPE here and make use of the TTBRs.
 	 */
-	__debug_switch_to_host(vcpu);
+	__debug_restore_host_buffers_nvhe(vcpu);
 
 	return exit_code;
 }
-- 
2.30.1



