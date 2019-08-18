Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1788F9184F
	for <lists+stable@lfdr.de>; Sun, 18 Aug 2019 19:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbfHRRTg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Aug 2019 13:19:36 -0400
Received: from foss.arm.com ([217.140.110.172]:46660 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726005AbfHRRTg (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Aug 2019 13:19:36 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 44577337
        for <stable@vger.kernel.org>; Sun, 18 Aug 2019 10:19:35 -0700 (PDT)
Received: from why.lan (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CD7A83F706
        for <stable@vger.kernel.org>; Sun, 18 Aug 2019 10:19:34 -0700 (PDT)
From:   Marc Zyngier <maz@kernel.org>
To:     stable@vger.kernel.org
Subject: [4.14-stable][PATCH] KVM: arm/arm64: Sync ICH_VMCR_EL2 back when about to block
Date:   Sun, 18 Aug 2019 18:19:30 +0100
Message-Id: <20190818171930.26272-1-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 5eeaf10eec394b28fad2c58f1f5c3a5da0e87d1c upstream.

Since commit commit 328e56647944 ("KVM: arm/arm64: vgic: Defer
touching GICH_VMCR to vcpu_load/put"), we leave ICH_VMCR_EL2 (or
its GICv2 equivalent) loaded as long as we can, only syncing it
back when we're scheduled out.

There is a small snag with that though: kvm_vgic_vcpu_pending_irq(),
which is indirectly called from kvm_vcpu_check_block(), needs to
evaluate the guest's view of ICC_PMR_EL1. At the point were we
call kvm_vcpu_check_block(), the vcpu is still loaded, and whatever
changes to PMR is not visible in memory until we do a vcpu_put().

Things go really south if the guest does the following:

	mov x0, #0	// or any small value masking interrupts
	msr ICC_PMR_EL1, x0

	[vcpu preempted, then rescheduled, VMCR sampled]

	mov x0, #ff	// allow all interrupts
	msr ICC_PMR_EL1, x0
	wfi		// traps to EL2, so samping of VMCR

	[interrupt arrives just after WFI]

Here, the hypervisor's view of PMR is zero, while the guest has enabled
its interrupts. kvm_vgic_vcpu_pending_irq() will then say that no
interrupts are pending (despite an interrupt being received) and we'll
block for no reason. If the guest doesn't have a periodic interrupt
firing once it has blocked, it will stay there forever.

To avoid this unfortuante situation, let's resync VMCR from
kvm_arch_vcpu_blocking(), ensuring that a following kvm_vcpu_check_block()
will observe the latest value of PMR.

This has been found by booting an arm64 Linux guest with the pseudo NMI
feature, and thus using interrupt priorities to mask interrupts instead
of the usual PSTATE masking.

Cc: stable@vger.kernel.org # 4.12
Fixes: 328e56647944 ("KVM: arm/arm64: vgic: Defer touching GICH_VMCR to vcpu_load/put")
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 include/kvm/arm_vgic.h      |  1 +
 virt/kvm/arm/arm.c          | 10 ++++++++++
 virt/kvm/arm/vgic/vgic-v2.c | 11 ++++++++++-
 virt/kvm/arm/vgic/vgic-v3.c |  7 ++++++-
 virt/kvm/arm/vgic/vgic.c    | 11 +++++++++++
 virt/kvm/arm/vgic/vgic.h    |  2 ++
 6 files changed, 40 insertions(+), 2 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 34dba516ef24..d5c6637ed638 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -315,6 +315,7 @@ int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu);
 
 void kvm_vgic_load(struct kvm_vcpu *vcpu);
 void kvm_vgic_put(struct kvm_vcpu *vcpu);
+void kvm_vgic_vmcr_sync(struct kvm_vcpu *vcpu);
 
 #define irqchip_in_kernel(k)	(!!((k)->arch.vgic.in_kernel))
 #define vgic_initialized(k)	((k)->arch.vgic.initialized)
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index f574d02ac860..09ef6260477e 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -317,6 +317,16 @@ int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
 void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)
 {
 	kvm_timer_schedule(vcpu);
+	/*
+	 * If we're about to block (most likely because we've just hit a
+	 * WFI), we need to sync back the state of the GIC CPU interface
+	 * so that we have the lastest PMR and group enables. This ensures
+	 * that kvm_arch_vcpu_runnable has up-to-date data to decide
+	 * whether we have pending interrupts.
+	 */
+	preempt_disable();
+	kvm_vgic_vmcr_sync(vcpu);
+	preempt_enable();
 }
 
 void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
index 841d4b27555a..a2273a5aaece 100644
--- a/virt/kvm/arm/vgic/vgic-v2.c
+++ b/virt/kvm/arm/vgic/vgic-v2.c
@@ -407,10 +407,19 @@ void vgic_v2_load(struct kvm_vcpu *vcpu)
 	writel_relaxed(cpu_if->vgic_vmcr, vgic->vctrl_base + GICH_VMCR);
 }
 
-void vgic_v2_put(struct kvm_vcpu *vcpu)
+void vgic_v2_vmcr_sync(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
 	struct vgic_dist *vgic = &vcpu->kvm->arch.vgic;
 
 	cpu_if->vgic_vmcr = readl_relaxed(vgic->vctrl_base + GICH_VMCR);
 }
+
+void vgic_v2_put(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
+	struct vgic_dist *vgic = &vcpu->kvm->arch.vgic;
+
+	vgic_v2_vmcr_sync(vcpu);
+	cpu_if->vgic_apr = readl_relaxed(vgic->vctrl_base + GICH_APR);
+}
diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index a37b03c25457..094f8ff8f7ba 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -547,10 +547,15 @@ void vgic_v3_load(struct kvm_vcpu *vcpu)
 		kvm_call_hyp(__vgic_v3_write_vmcr, cpu_if->vgic_vmcr);
 }
 
-void vgic_v3_put(struct kvm_vcpu *vcpu)
+void vgic_v3_vmcr_sync(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
 
 	if (likely(cpu_if->vgic_sre))
 		cpu_if->vgic_vmcr = kvm_call_hyp(__vgic_v3_read_vmcr);
 }
+
+void vgic_v3_put(struct kvm_vcpu *vcpu)
+{
+	vgic_v3_vmcr_sync(vcpu);
+}
diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index c9a8e7b7c300..9d4e01f10949 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -764,6 +764,17 @@ void kvm_vgic_put(struct kvm_vcpu *vcpu)
 		vgic_v3_put(vcpu);
 }
 
+void kvm_vgic_vmcr_sync(struct kvm_vcpu *vcpu)
+{
+	if (unlikely(!irqchip_in_kernel(vcpu->kvm)))
+		return;
+
+	if (kvm_vgic_global_state.type == VGIC_V2)
+		vgic_v2_vmcr_sync(vcpu);
+	else
+		vgic_v3_vmcr_sync(vcpu);
+}
+
 int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu)
 {
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 21a2240164f3..ade076da828b 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -168,6 +168,7 @@ int vgic_register_dist_iodev(struct kvm *kvm, gpa_t dist_base_address,
 void vgic_v2_init_lrs(void);
 void vgic_v2_load(struct kvm_vcpu *vcpu);
 void vgic_v2_put(struct kvm_vcpu *vcpu);
+void vgic_v2_vmcr_sync(struct kvm_vcpu *vcpu);
 
 static inline void vgic_get_irq_kref(struct vgic_irq *irq)
 {
@@ -195,6 +196,7 @@ bool vgic_v3_check_base(struct kvm *kvm);
 
 void vgic_v3_load(struct kvm_vcpu *vcpu);
 void vgic_v3_put(struct kvm_vcpu *vcpu);
+void vgic_v3_vmcr_sync(struct kvm_vcpu *vcpu);
 
 bool vgic_has_its(struct kvm *kvm);
 int kvm_vgic_register_its_device(void);
-- 
2.20.1

