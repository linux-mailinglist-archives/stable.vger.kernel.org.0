Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB48F38A562
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233849AbhETKQJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:16:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:47686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236162AbhETKO3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:14:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B74D261981;
        Thu, 20 May 2021 09:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503885;
        bh=72ha+gYMhAcliFBt4NMsvBwPz+2xQexHO7nuNCtNCoM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ijuvOOsHYMXVpkN8asRtftDug0GqAmCpnfsxDzf+7tKQVxZIFULB94FPEtOw5skDx
         rhqAzE63Q+AqpLXSeNKeN+5cU4Sb+KD/dvffFnei6KWo/qcXRsNpLQacW3oHfIRbcw
         K7HOr3t9ajTaAmwZHVUtaxYbt6DJI/Jh/5ZM/J6I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 4.19 423/425] KVM: arm64: Initialize VCPU mdcr_el2 before loading it
Date:   Thu, 20 May 2021 11:23:12 +0200
Message-Id: <20210520092145.297833136@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandru Elisei <alexandru.elisei@arm.com>

commit 263d6287da1433aba11c5b4046388f2cdf49675c upstream.

When a VCPU is created, the kvm_vcpu struct is initialized to zero in
kvm_vm_ioctl_create_vcpu(). On VHE systems, the first time
vcpu.arch.mdcr_el2 is loaded on hardware is in vcpu_load(), before it is
set to a sensible value in kvm_arm_setup_debug() later in the run loop. The
result is that KVM executes for a short time with MDCR_EL2 set to zero.

This has several unintended consequences:

* Setting MDCR_EL2.HPMN to 0 is constrained unpredictable according to ARM
  DDI 0487G.a, page D13-3820. The behavior specified by the architecture
  in this case is for the PE to behave as if MDCR_EL2.HPMN is set to a
  value less than or equal to PMCR_EL0.N, which means that an unknown
  number of counters are now disabled by MDCR_EL2.HPME, which is zero.

* The host configuration for the other debug features controlled by
  MDCR_EL2 is temporarily lost. This has been harmless so far, as Linux
  doesn't use the other fields, but that might change in the future.

Let's avoid both issues by initializing the VCPU's mdcr_el2 field in
kvm_vcpu_vcpu_first_run_init(), thus making sure that the MDCR_EL2 register
has a consistent value after each vcpu_load().

Fixes: d5a21bcc2995 ("KVM: arm64: Move common VHE/non-VHE trap config in separate functions")
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20210407144857.199746-3-alexandru.elisei@arm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/include/asm/kvm_host.h   |    1 
 arch/arm64/include/asm/kvm_host.h |    1 
 arch/arm64/kvm/debug.c            |   88 +++++++++++++++++++++++++-------------
 virt/kvm/arm/arm.c                |    2 
 4 files changed, 64 insertions(+), 28 deletions(-)

--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -303,6 +303,7 @@ static inline void kvm_arch_sched_in(str
 static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
 
 static inline void kvm_arm_init_debug(void) {}
+static inline void kvm_arm_vcpu_init_debug(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arm_setup_debug(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arm_clear_debug(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu) {}
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -455,6 +455,7 @@ static inline void kvm_arch_sched_in(str
 static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
 
 void kvm_arm_init_debug(void);
+void kvm_arm_vcpu_init_debug(struct kvm_vcpu *vcpu);
 void kvm_arm_setup_debug(struct kvm_vcpu *vcpu);
 void kvm_arm_clear_debug(struct kvm_vcpu *vcpu);
 void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu);
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -80,6 +80,64 @@ void kvm_arm_init_debug(void)
 }
 
 /**
+ * kvm_arm_setup_mdcr_el2 - configure vcpu mdcr_el2 value
+ *
+ * @vcpu:	the vcpu pointer
+ *
+ * This ensures we will trap access to:
+ *  - Performance monitors (MDCR_EL2_TPM/MDCR_EL2_TPMCR)
+ *  - Debug ROM Address (MDCR_EL2_TDRA)
+ *  - OS related registers (MDCR_EL2_TDOSA)
+ *  - Statistical profiler (MDCR_EL2_TPMS/MDCR_EL2_E2PB)
+ *  - Self-hosted Trace Filter controls (MDCR_EL2_TTRF)
+ */
+static void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * This also clears MDCR_EL2_E2PB_MASK to disable guest access
+	 * to the profiling buffer.
+	 */
+	vcpu->arch.mdcr_el2 = __this_cpu_read(mdcr_el2) & MDCR_EL2_HPMN_MASK;
+	vcpu->arch.mdcr_el2 |= (MDCR_EL2_TPM |
+				MDCR_EL2_TPMS |
+				MDCR_EL2_TTRF |
+				MDCR_EL2_TPMCR |
+				MDCR_EL2_TDRA |
+				MDCR_EL2_TDOSA);
+
+	/* Is the VM being debugged by userspace? */
+	if (vcpu->guest_debug)
+		/* Route all software debug exceptions to EL2 */
+		vcpu->arch.mdcr_el2 |= MDCR_EL2_TDE;
+
+	/*
+	 * Trap debug register access when one of the following is true:
+	 *  - Userspace is using the hardware to debug the guest
+	 *  (KVM_GUESTDBG_USE_HW is set).
+	 *  - The guest is not using debug (KVM_ARM64_DEBUG_DIRTY is clear).
+	 */
+	if ((vcpu->guest_debug & KVM_GUESTDBG_USE_HW) ||
+	    !(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY))
+		vcpu->arch.mdcr_el2 |= MDCR_EL2_TDA;
+
+	trace_kvm_arm_set_dreg32("MDCR_EL2", vcpu->arch.mdcr_el2);
+}
+
+/**
+ * kvm_arm_vcpu_init_debug - setup vcpu debug traps
+ *
+ * @vcpu:	the vcpu pointer
+ *
+ * Set vcpu initial mdcr_el2 value.
+ */
+void kvm_arm_vcpu_init_debug(struct kvm_vcpu *vcpu)
+{
+	preempt_disable();
+	kvm_arm_setup_mdcr_el2(vcpu);
+	preempt_enable();
+}
+
+/**
  * kvm_arm_reset_debug_ptr - reset the debug ptr to point to the vcpu state
  */
 
@@ -94,13 +152,7 @@ void kvm_arm_reset_debug_ptr(struct kvm_
  * @vcpu:	the vcpu pointer
  *
  * This is called before each entry into the hypervisor to setup any
- * debug related registers. Currently this just ensures we will trap
- * access to:
- *  - Performance monitors (MDCR_EL2_TPM/MDCR_EL2_TPMCR)
- *  - Debug ROM Address (MDCR_EL2_TDRA)
- *  - OS related registers (MDCR_EL2_TDOSA)
- *  - Statistical profiler (MDCR_EL2_TPMS/MDCR_EL2_E2PB)
- *  - Self-hosted Trace Filter controls (MDCR_EL2_TTRF)
+ * debug related registers.
  *
  * Additionally, KVM only traps guest accesses to the debug registers if
  * the guest is not actively using them (see the KVM_ARM64_DEBUG_DIRTY
@@ -112,28 +164,14 @@ void kvm_arm_reset_debug_ptr(struct kvm_
 
 void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
 {
-	bool trap_debug = !(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY);
 	unsigned long mdscr, orig_mdcr_el2 = vcpu->arch.mdcr_el2;
 
 	trace_kvm_arm_setup_debug(vcpu, vcpu->guest_debug);
 
-	/*
-	 * This also clears MDCR_EL2_E2PB_MASK to disable guest access
-	 * to the profiling buffer.
-	 */
-	vcpu->arch.mdcr_el2 = __this_cpu_read(mdcr_el2) & MDCR_EL2_HPMN_MASK;
-	vcpu->arch.mdcr_el2 |= (MDCR_EL2_TPM |
-				MDCR_EL2_TPMS |
-				MDCR_EL2_TTRF |
-				MDCR_EL2_TPMCR |
-				MDCR_EL2_TDRA |
-				MDCR_EL2_TDOSA);
+	kvm_arm_setup_mdcr_el2(vcpu);
 
 	/* Is Guest debugging in effect? */
 	if (vcpu->guest_debug) {
-		/* Route all software debug exceptions to EL2 */
-		vcpu->arch.mdcr_el2 |= MDCR_EL2_TDE;
-
 		/* Save guest debug state */
 		save_guest_debug_regs(vcpu);
 
@@ -187,7 +225,6 @@ void kvm_arm_setup_debug(struct kvm_vcpu
 
 			vcpu->arch.debug_ptr = &vcpu->arch.external_debug_state;
 			vcpu->arch.flags |= KVM_ARM64_DEBUG_DIRTY;
-			trap_debug = true;
 
 			trace_kvm_arm_set_regset("BKPTS", get_num_brps(),
 						&vcpu->arch.debug_ptr->dbg_bcr[0],
@@ -202,10 +239,6 @@ void kvm_arm_setup_debug(struct kvm_vcpu
 	BUG_ON(!vcpu->guest_debug &&
 		vcpu->arch.debug_ptr != &vcpu->arch.vcpu_debug_state);
 
-	/* Trap debug register access */
-	if (trap_debug)
-		vcpu->arch.mdcr_el2 |= MDCR_EL2_TDA;
-
 	/* If KDE or MDE are set, perform a full save/restore cycle. */
 	if (vcpu_read_sys_reg(vcpu, MDSCR_EL1) & (DBG_MDSCR_KDE | DBG_MDSCR_MDE))
 		vcpu->arch.flags |= KVM_ARM64_DEBUG_DIRTY;
@@ -214,7 +247,6 @@ void kvm_arm_setup_debug(struct kvm_vcpu
 	if (has_vhe() && orig_mdcr_el2 != vcpu->arch.mdcr_el2)
 		write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
 
-	trace_kvm_arm_set_dreg32("MDCR_EL2", vcpu->arch.mdcr_el2);
 	trace_kvm_arm_set_dreg32("MDSCR_EL1", vcpu_read_sys_reg(vcpu, MDSCR_EL1));
 }
 
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -574,6 +574,8 @@ static int kvm_vcpu_first_run_init(struc
 
 	vcpu->arch.has_run_once = true;
 
+	kvm_arm_vcpu_init_debug(vcpu);
+
 	if (likely(irqchip_in_kernel(kvm))) {
 		/*
 		 * Map the VGIC hardware resources before running a vcpu the


