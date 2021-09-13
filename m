Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E56F7408A33
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 13:29:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239364AbhIMLa5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 07:30:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:34332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239238AbhIMLa5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 07:30:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 494BE60F44;
        Mon, 13 Sep 2021 11:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631532581;
        bh=SVl6ekSOvUZ/cmivE2WvxAPa3QKISbOuKMA1UQctfE8=;
        h=Subject:To:Cc:From:Date:From;
        b=uu2MGxD5SSSsa0lZwd2tJ3RmOglM28bCvPRYBbVQjhwB7X5cBIXOnC1zTO0xiE7WF
         yo8SUEtStOYN3ds6qV0opGkh2m/hDEJsBuiowmFnTjDgjw/0Toj9iBW2wOsBLdfFhf
         uq12Shm5r6WG1jEQjue1Curoa7bNqCaNSeLAVStE=
Subject: FAILED: patch "[PATCH] KVM: arm64: vgic: Resample HW pending state on deactivation" failed to apply to 5.10-stable tree
To:     maz@kernel.org, oupton@google.com, rananta@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 13 Sep 2021 13:29:31 +0200
Message-ID: <163153257160153@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3134cc8beb69d0db9de651081707c4651c011621 Mon Sep 17 00:00:00 2001
From: Marc Zyngier <maz@kernel.org>
Date: Thu, 19 Aug 2021 19:03:05 +0100
Subject: [PATCH] KVM: arm64: vgic: Resample HW pending state on deactivation

When a mapped level interrupt (a timer, for example) is deactivated
by the guest, the corresponding host interrupt is equally deactivated.
However, the fate of the pending state still needs to be dealt
with in SW.

This is specially true when the interrupt was in the active+pending
state in the virtual distributor at the point where the guest
was entered. On exit, the pending state is potentially stale
(the guest may have put the interrupt in a non-pending state).

If we don't do anything, the interrupt will be spuriously injected
in the guest. Although this shouldn't have any ill effect (spurious
interrupts are always possible), we can improve the emulation by
detecting the deactivation-while-pending case and resample the
interrupt.

While we're at it, move the logic into a common helper that can
be shared between the two GIC implementations.

Fixes: e40cc57bac79 ("KVM: arm/arm64: vgic: Support level-triggered mapped interrupts")
Reported-by: Raghavendra Rao Ananta <rananta@google.com>
Tested-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: Oliver Upton <oupton@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210819180305.1670525-1-maz@kernel.org

diff --git a/arch/arm64/kvm/vgic/vgic-v2.c b/arch/arm64/kvm/vgic/vgic-v2.c
index 2c580204f1dc..95a18cec14a3 100644
--- a/arch/arm64/kvm/vgic/vgic-v2.c
+++ b/arch/arm64/kvm/vgic/vgic-v2.c
@@ -60,6 +60,7 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
 		u32 val = cpuif->vgic_lr[lr];
 		u32 cpuid, intid = val & GICH_LR_VIRTUALID;
 		struct vgic_irq *irq;
+		bool deactivated;
 
 		/* Extract the source vCPU id from the LR */
 		cpuid = val & GICH_LR_PHYSID_CPUID;
@@ -75,7 +76,8 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
 
 		raw_spin_lock(&irq->irq_lock);
 
-		/* Always preserve the active bit */
+		/* Always preserve the active bit, note deactivation */
+		deactivated = irq->active && !(val & GICH_LR_ACTIVE_BIT);
 		irq->active = !!(val & GICH_LR_ACTIVE_BIT);
 
 		if (irq->active && vgic_irq_is_sgi(intid))
@@ -96,36 +98,8 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
 		if (irq->config == VGIC_CONFIG_LEVEL && !(val & GICH_LR_STATE))
 			irq->pending_latch = false;
 
-		/*
-		 * Level-triggered mapped IRQs are special because we only
-		 * observe rising edges as input to the VGIC.
-		 *
-		 * If the guest never acked the interrupt we have to sample
-		 * the physical line and set the line level, because the
-		 * device state could have changed or we simply need to
-		 * process the still pending interrupt later.
-		 *
-		 * If this causes us to lower the level, we have to also clear
-		 * the physical active state, since we will otherwise never be
-		 * told when the interrupt becomes asserted again.
-		 *
-		 * Another case is when the interrupt requires a helping hand
-		 * on deactivation (no HW deactivation, for example).
-		 */
-		if (vgic_irq_is_mapped_level(irq)) {
-			bool resample = false;
-
-			if (val & GICH_LR_PENDING_BIT) {
-				irq->line_level = vgic_get_phys_line_level(irq);
-				resample = !irq->line_level;
-			} else if (vgic_irq_needs_resampling(irq) &&
-				   !(irq->active || irq->pending_latch)) {
-				resample = true;
-			}
-
-			if (resample)
-				vgic_irq_set_phys_active(irq, false);
-		}
+		/* Handle resampling for mapped interrupts if required */
+		vgic_irq_handle_resampling(irq, deactivated, val & GICH_LR_PENDING_BIT);
 
 		raw_spin_unlock(&irq->irq_lock);
 		vgic_put_irq(vcpu->kvm, irq);
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 66004f61cd83..21a6207fb2ee 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -46,6 +46,7 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
 		u32 intid, cpuid;
 		struct vgic_irq *irq;
 		bool is_v2_sgi = false;
+		bool deactivated;
 
 		cpuid = val & GICH_LR_PHYSID_CPUID;
 		cpuid >>= GICH_LR_PHYSID_CPUID_SHIFT;
@@ -68,7 +69,8 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
 
 		raw_spin_lock(&irq->irq_lock);
 
-		/* Always preserve the active bit */
+		/* Always preserve the active bit, note deactivation */
+		deactivated = irq->active && !(val & ICH_LR_ACTIVE_BIT);
 		irq->active = !!(val & ICH_LR_ACTIVE_BIT);
 
 		if (irq->active && is_v2_sgi)
@@ -89,36 +91,8 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
 		if (irq->config == VGIC_CONFIG_LEVEL && !(val & ICH_LR_STATE))
 			irq->pending_latch = false;
 
-		/*
-		 * Level-triggered mapped IRQs are special because we only
-		 * observe rising edges as input to the VGIC.
-		 *
-		 * If the guest never acked the interrupt we have to sample
-		 * the physical line and set the line level, because the
-		 * device state could have changed or we simply need to
-		 * process the still pending interrupt later.
-		 *
-		 * If this causes us to lower the level, we have to also clear
-		 * the physical active state, since we will otherwise never be
-		 * told when the interrupt becomes asserted again.
-		 *
-		 * Another case is when the interrupt requires a helping hand
-		 * on deactivation (no HW deactivation, for example).
-		 */
-		if (vgic_irq_is_mapped_level(irq)) {
-			bool resample = false;
-
-			if (val & ICH_LR_PENDING_BIT) {
-				irq->line_level = vgic_get_phys_line_level(irq);
-				resample = !irq->line_level;
-			} else if (vgic_irq_needs_resampling(irq) &&
-				   !(irq->active || irq->pending_latch)) {
-				resample = true;
-			}
-
-			if (resample)
-				vgic_irq_set_phys_active(irq, false);
-		}
+		/* Handle resampling for mapped interrupts if required */
+		vgic_irq_handle_resampling(irq, deactivated, val & ICH_LR_PENDING_BIT);
 
 		raw_spin_unlock(&irq->irq_lock);
 		vgic_put_irq(vcpu->kvm, irq);
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 81cec508d413..5dad4996cfb2 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -1021,3 +1021,41 @@ bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int vintid)
 
 	return map_is_active;
 }
+
+/*
+ * Level-triggered mapped IRQs are special because we only observe rising
+ * edges as input to the VGIC.
+ *
+ * If the guest never acked the interrupt we have to sample the physical
+ * line and set the line level, because the device state could have changed
+ * or we simply need to process the still pending interrupt later.
+ *
+ * We could also have entered the guest with the interrupt active+pending.
+ * On the next exit, we need to re-evaluate the pending state, as it could
+ * otherwise result in a spurious interrupt by injecting a now potentially
+ * stale pending state.
+ *
+ * If this causes us to lower the level, we have to also clear the physical
+ * active state, since we will otherwise never be told when the interrupt
+ * becomes asserted again.
+ *
+ * Another case is when the interrupt requires a helping hand on
+ * deactivation (no HW deactivation, for example).
+ */
+void vgic_irq_handle_resampling(struct vgic_irq *irq,
+				bool lr_deactivated, bool lr_pending)
+{
+	if (vgic_irq_is_mapped_level(irq)) {
+		bool resample = false;
+
+		if (unlikely(vgic_irq_needs_resampling(irq))) {
+			resample = !(irq->active || irq->pending_latch);
+		} else if (lr_pending || (lr_deactivated && irq->line_level)) {
+			irq->line_level = vgic_get_phys_line_level(irq);
+			resample = !irq->line_level;
+		}
+
+		if (resample)
+			vgic_irq_set_phys_active(irq, false);
+	}
+}
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index dc1f3d1657ee..14a9218641f5 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -169,6 +169,8 @@ void vgic_irq_set_phys_active(struct vgic_irq *irq, bool active);
 bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq,
 			   unsigned long flags);
 void vgic_kick_vcpus(struct kvm *kvm);
+void vgic_irq_handle_resampling(struct vgic_irq *irq,
+				bool lr_deactivated, bool lr_pending);
 
 int vgic_check_ioaddr(struct kvm *kvm, phys_addr_t *ioaddr,
 		      phys_addr_t addr, phys_addr_t alignment);

