Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0F8D3F1F7F
	for <lists+stable@lfdr.de>; Thu, 19 Aug 2021 20:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232481AbhHSSDu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Aug 2021 14:03:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:52738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233379AbhHSSDt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Aug 2021 14:03:49 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 283066109F;
        Thu, 19 Aug 2021 18:03:13 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mGmNj-006293-CQ; Thu, 19 Aug 2021 19:03:11 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Oliver Upton <oupton@google.com>,
        Ricardo Koller <ricarkol@google.com>, kernel-team@android.com,
        Raghavendra Rao Ananta <rananta@google.com>,
        stable@vger.kernel.org
Subject: [PATCH v2] KVM: arm64: vgic: Resample HW pending state on deactivation
Date:   Thu, 19 Aug 2021 19:03:05 +0100
Message-Id: <20210819180305.1670525-1-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, andre.przywara@arm.com, eric.auger@redhat.com, oupton@google.com, ricarkol@google.com, kernel-team@android.com, rananta@google.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---

Notes:
    * From v1:
      - Moved the resampling into a separate helper, and pointed both
        GIC implementations to it.
      - Collected TB, RB, with thanks.

 arch/arm64/kvm/vgic/vgic-v2.c | 36 +++++----------------------------
 arch/arm64/kvm/vgic/vgic-v3.c | 36 +++++----------------------------
 arch/arm64/kvm/vgic/vgic.c    | 38 +++++++++++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic.h    |  2 ++
 4 files changed, 50 insertions(+), 62 deletions(-)

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
index 111bff47e471..42a6ac78fe95 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -1022,3 +1022,41 @@ bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int vintid)
 
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
-- 
2.30.2

