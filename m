Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60B183256D6
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 20:39:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233738AbhBYTix (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 14:38:53 -0500
Received: from foss.arm.com ([217.140.110.172]:48204 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234339AbhBYTgu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Feb 2021 14:36:50 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 483A8139F;
        Thu, 25 Feb 2021 11:36:05 -0800 (PST)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 803C03F70D;
        Thu, 25 Feb 2021 11:36:03 -0800 (PST)
From:   Suzuki K Poulose <suzuki.poulose@arm.com>
To:     linux-arm-kernel@lists.infradead.org
Cc:     linux-kernel@vger.kernel.org, mathieu.poirier@linaro.org,
        mike.leach@linaro.org, anshuman.khandual@arm.com,
        leo.yan@linaro.org, Suzuki K Poulose <suzuki.poulose@arm.com>,
        stable@vger.kernel.org,
        Christoffer Dall <christoffer.dall@arm.com>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH v4 04/19] kvm: arm64: nvhe: Save the SPE context early
Date:   Thu, 25 Feb 2021 19:35:28 +0000
Message-Id: <20210225193543.2920532-5-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210225193543.2920532-1-suzuki.poulose@arm.com>
References: <20210225193543.2920532-1-suzuki.poulose@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The nvhe hyp saves the SPE context, flushing any unwritten
data before we switch to the guest. But this operation is
performed way too late, because :
  - The ownership of the SPE is transferred to EL2. i.e,
    using EL2 translations. (MDCR_EL2_E2PB == 0)
  - The guest Stage1 is loaded.

Thus the flush could use the host EL1 virtual address,
but use the EL2 translations instead. Fix this by
moving the SPE context save early.
i.e, Save the context before we load the guest stage1
and before we change the ownership to EL2.

The restore path is doing the right thing.

Fixes: 014c4c77aad7 ("KVM: arm64: Improve debug register save/restore flow")
Cc: stable@vger.kernel.org
Cc: Christoffer Dall <christoffer.dall@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
New patch.
---
 arch/arm64/include/asm/kvm_hyp.h   |  5 +++++
 arch/arm64/kvm/hyp/nvhe/debug-sr.c | 12 ++++++++++--
 arch/arm64/kvm/hyp/nvhe/switch.c   | 12 +++++++++++-
 3 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index c0450828378b..385bd7dd3d39 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -83,6 +83,11 @@ void sysreg_restore_guest_state_vhe(struct kvm_cpu_context *ctxt);
 void __debug_switch_to_guest(struct kvm_vcpu *vcpu);
 void __debug_switch_to_host(struct kvm_vcpu *vcpu);
 
+#ifdef __KVM_NVHE_HYPERVISOR__
+void __debug_save_host_buffers_nvhe(struct kvm_vcpu *vcpu);
+void __debug_restore_host_buffers_nvhe(struct kvm_vcpu *vcpu);
+#endif
+
 void __fpsimd_save_state(struct user_fpsimd_state *fp_regs);
 void __fpsimd_restore_state(struct user_fpsimd_state *fp_regs);
 
diff --git a/arch/arm64/kvm/hyp/nvhe/debug-sr.c b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
index 91a711aa8382..f401724f12ef 100644
--- a/arch/arm64/kvm/hyp/nvhe/debug-sr.c
+++ b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
@@ -58,16 +58,24 @@ static void __debug_restore_spe(u64 pmscr_el1)
 	write_sysreg_s(pmscr_el1, SYS_PMSCR_EL1);
 }
 
-void __debug_switch_to_guest(struct kvm_vcpu *vcpu)
+void __debug_save_host_buffers_nvhe(struct kvm_vcpu *vcpu)
 {
 	/* Disable and flush SPE data generation */
 	__debug_save_spe(&vcpu->arch.host_debug_state.pmscr_el1);
+}
+
+void __debug_switch_to_guest(struct kvm_vcpu *vcpu)
+{
 	__debug_switch_to_guest_common(vcpu);
 }
 
-void __debug_switch_to_host(struct kvm_vcpu *vcpu)
+void __debug_restore_host_buffers_nvhe(struct kvm_vcpu *vcpu)
 {
 	__debug_restore_spe(vcpu->arch.host_debug_state.pmscr_el1);
+}
+
+void __debug_switch_to_host(struct kvm_vcpu *vcpu)
+{
 	__debug_switch_to_host_common(vcpu);
 }
 
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index f3d0e9eca56c..10eed66136a0 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -192,6 +192,15 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	pmu_switch_needed = __pmu_switch_to_guest(host_ctxt);
 
 	__sysreg_save_state_nvhe(host_ctxt);
+	/*
+	 * For nVHE, we must save and disable any SPE
+	 * buffers, as the translation regime is going
+	 * to be loaded with that of the guest. And we must
+	 * save host context for SPE, before we change the
+	 * ownership to EL2 (via MDCR_EL2_E2PB == 0)  and before
+	 * we load guest Stage1.
+	 */
+	__debug_save_host_buffers_nvhe(vcpu);
 
 	__adjust_pc(vcpu);
 
@@ -234,11 +243,12 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED)
 		__fpsimd_save_fpexc32(vcpu);
 
+	__debug_switch_to_host(vcpu);
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

