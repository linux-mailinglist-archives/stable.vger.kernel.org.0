Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 170511D8571
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:19:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729771AbgERRzG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:55:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:60176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728825AbgERRzE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:55:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 016D620674;
        Mon, 18 May 2020 17:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824502;
        bh=81nyT0KGpUtnfpoIicYrfquw3UI9n/ITzuO8vjPDmWs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NXF2MuxjjKlIzGm7eC7jvmcF3YwQ3gN0enwO9qHeuhR1o/u1BsOiW+/CWpUkdjeyF
         LRhxXLkxUAQpEMvM5Z51IimOHiHes3Vcnqsfy1p/JjYnsC9dqGtBsc7ZqoOuGaDkqy
         bqqGDL1rPCbd8E0s0AtYJJkQpRyByNi64oBorqSA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julien Grall <julien@xen.org>,
        Andre Przywara <andre.przywara@arm.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 004/147] KVM: arm: vgic: Synchronize the whole guest on GIC{D,R}_I{S,C}ACTIVER read
Date:   Mon, 18 May 2020 19:35:27 +0200
Message-Id: <20200518173513.680763880@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173513.009514388@linuxfoundation.org>
References: <20200518173513.009514388@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit 9a50ebbffa9862db7604345f5fd763122b0f6fed ]

When a guest tries to read the active state of its interrupts,
we currently just return whatever state we have in memory. This
means that if such an interrupt lives in a List Register on another
CPU, we fail to obsertve the latest active state for this interrupt.

In order to remedy this, stop all the other vcpus so that they exit
and we can observe the most recent value for the state. This is
similar to what we are doing for the write side of the same
registers, and results in new MMIO handlers for userspace (which
do not need to stop the guest, as it is supposed to be stopped
already).

Reported-by: Julien Grall <julien@xen.org>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 virt/kvm/arm/vgic/vgic-mmio-v2.c |   4 +-
 virt/kvm/arm/vgic/vgic-mmio-v3.c |  12 ++--
 virt/kvm/arm/vgic/vgic-mmio.c    | 100 ++++++++++++++++++++-----------
 virt/kvm/arm/vgic/vgic-mmio.h    |   3 +
 4 files changed, 75 insertions(+), 44 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
index 5945f062d7497..d63881f60e1a5 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
@@ -422,11 +422,11 @@ static const struct vgic_register_region vgic_v2_dist_registers[] = {
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ACTIVE_SET,
 		vgic_mmio_read_active, vgic_mmio_write_sactive,
-		NULL, vgic_mmio_uaccess_write_sactive, 1,
+		vgic_uaccess_read_active, vgic_mmio_uaccess_write_sactive, 1,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ACTIVE_CLEAR,
 		vgic_mmio_read_active, vgic_mmio_write_cactive,
-		NULL, vgic_mmio_uaccess_write_cactive, 1,
+		vgic_uaccess_read_active, vgic_mmio_uaccess_write_cactive, 1,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_PRI,
 		vgic_mmio_read_priority, vgic_mmio_write_priority, NULL, NULL,
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index 7dfd15dbb308e..4c5909e38f78a 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -491,11 +491,11 @@ static const struct vgic_register_region vgic_v3_dist_registers[] = {
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ISACTIVER,
 		vgic_mmio_read_active, vgic_mmio_write_sactive,
-		NULL, vgic_mmio_uaccess_write_sactive, 1,
+		vgic_uaccess_read_active, vgic_mmio_uaccess_write_sactive, 1,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ICACTIVER,
 		vgic_mmio_read_active, vgic_mmio_write_cactive,
-		NULL, vgic_mmio_uaccess_write_cactive,
+		vgic_uaccess_read_active, vgic_mmio_uaccess_write_cactive,
 		1, VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_IPRIORITYR,
 		vgic_mmio_read_priority, vgic_mmio_write_priority, NULL, NULL,
@@ -563,12 +563,12 @@ static const struct vgic_register_region vgic_v3_rd_registers[] = {
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH_UACCESS(SZ_64K + GICR_ISACTIVER0,
 		vgic_mmio_read_active, vgic_mmio_write_sactive,
-		NULL, vgic_mmio_uaccess_write_sactive,
-		4, VGIC_ACCESS_32bit),
+		vgic_uaccess_read_active, vgic_mmio_uaccess_write_sactive, 4,
+		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH_UACCESS(SZ_64K + GICR_ICACTIVER0,
 		vgic_mmio_read_active, vgic_mmio_write_cactive,
-		NULL, vgic_mmio_uaccess_write_cactive,
-		4, VGIC_ACCESS_32bit),
+		vgic_uaccess_read_active, vgic_mmio_uaccess_write_cactive, 4,
+		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(SZ_64K + GICR_IPRIORITYR0,
 		vgic_mmio_read_priority, vgic_mmio_write_priority, 32,
 		VGIC_ACCESS_32bit | VGIC_ACCESS_8bit),
diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
index 7eacf00e5abeb..fb1dcd397b93a 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -300,8 +300,39 @@ void vgic_mmio_write_cpending(struct kvm_vcpu *vcpu,
 	}
 }
 
-unsigned long vgic_mmio_read_active(struct kvm_vcpu *vcpu,
-				    gpa_t addr, unsigned int len)
+
+/*
+ * If we are fiddling with an IRQ's active state, we have to make sure the IRQ
+ * is not queued on some running VCPU's LRs, because then the change to the
+ * active state can be overwritten when the VCPU's state is synced coming back
+ * from the guest.
+ *
+ * For shared interrupts as well as GICv3 private interrupts, we have to
+ * stop all the VCPUs because interrupts can be migrated while we don't hold
+ * the IRQ locks and we don't want to be chasing moving targets.
+ *
+ * For GICv2 private interrupts we don't have to do anything because
+ * userspace accesses to the VGIC state already require all VCPUs to be
+ * stopped, and only the VCPU itself can modify its private interrupts
+ * active state, which guarantees that the VCPU is not running.
+ */
+static void vgic_access_active_prepare(struct kvm_vcpu *vcpu, u32 intid)
+{
+	if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3 ||
+	    intid >= VGIC_NR_PRIVATE_IRQS)
+		kvm_arm_halt_guest(vcpu->kvm);
+}
+
+/* See vgic_access_active_prepare */
+static void vgic_access_active_finish(struct kvm_vcpu *vcpu, u32 intid)
+{
+	if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3 ||
+	    intid >= VGIC_NR_PRIVATE_IRQS)
+		kvm_arm_resume_guest(vcpu->kvm);
+}
+
+static unsigned long __vgic_mmio_read_active(struct kvm_vcpu *vcpu,
+					     gpa_t addr, unsigned int len)
 {
 	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
 	u32 value = 0;
@@ -311,6 +342,10 @@ unsigned long vgic_mmio_read_active(struct kvm_vcpu *vcpu,
 	for (i = 0; i < len * 8; i++) {
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
 
+		/*
+		 * Even for HW interrupts, don't evaluate the HW state as
+		 * all the guest is interested in is the virtual state.
+		 */
 		if (irq->active)
 			value |= (1U << i);
 
@@ -320,6 +355,29 @@ unsigned long vgic_mmio_read_active(struct kvm_vcpu *vcpu,
 	return value;
 }
 
+unsigned long vgic_mmio_read_active(struct kvm_vcpu *vcpu,
+				    gpa_t addr, unsigned int len)
+{
+	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
+	u32 val;
+
+	mutex_lock(&vcpu->kvm->lock);
+	vgic_access_active_prepare(vcpu, intid);
+
+	val = __vgic_mmio_read_active(vcpu, addr, len);
+
+	vgic_access_active_finish(vcpu, intid);
+	mutex_unlock(&vcpu->kvm->lock);
+
+	return val;
+}
+
+unsigned long vgic_uaccess_read_active(struct kvm_vcpu *vcpu,
+				    gpa_t addr, unsigned int len)
+{
+	return __vgic_mmio_read_active(vcpu, addr, len);
+}
+
 /* Must be called with irq->irq_lock held */
 static void vgic_hw_irq_change_active(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
 				      bool active, bool is_uaccess)
@@ -371,36 +429,6 @@ static void vgic_mmio_change_active(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
 		raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
 }
 
-/*
- * If we are fiddling with an IRQ's active state, we have to make sure the IRQ
- * is not queued on some running VCPU's LRs, because then the change to the
- * active state can be overwritten when the VCPU's state is synced coming back
- * from the guest.
- *
- * For shared interrupts, we have to stop all the VCPUs because interrupts can
- * be migrated while we don't hold the IRQ locks and we don't want to be
- * chasing moving targets.
- *
- * For private interrupts we don't have to do anything because userspace
- * accesses to the VGIC state already require all VCPUs to be stopped, and
- * only the VCPU itself can modify its private interrupts active state, which
- * guarantees that the VCPU is not running.
- */
-static void vgic_change_active_prepare(struct kvm_vcpu *vcpu, u32 intid)
-{
-	if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3 ||
-	    intid >= VGIC_NR_PRIVATE_IRQS)
-		kvm_arm_halt_guest(vcpu->kvm);
-}
-
-/* See vgic_change_active_prepare */
-static void vgic_change_active_finish(struct kvm_vcpu *vcpu, u32 intid)
-{
-	if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3 ||
-	    intid >= VGIC_NR_PRIVATE_IRQS)
-		kvm_arm_resume_guest(vcpu->kvm);
-}
-
 static void __vgic_mmio_write_cactive(struct kvm_vcpu *vcpu,
 				      gpa_t addr, unsigned int len,
 				      unsigned long val)
@@ -422,11 +450,11 @@ void vgic_mmio_write_cactive(struct kvm_vcpu *vcpu,
 	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
 
 	mutex_lock(&vcpu->kvm->lock);
-	vgic_change_active_prepare(vcpu, intid);
+	vgic_access_active_prepare(vcpu, intid);
 
 	__vgic_mmio_write_cactive(vcpu, addr, len, val);
 
-	vgic_change_active_finish(vcpu, intid);
+	vgic_access_active_finish(vcpu, intid);
 	mutex_unlock(&vcpu->kvm->lock);
 }
 
@@ -459,11 +487,11 @@ void vgic_mmio_write_sactive(struct kvm_vcpu *vcpu,
 	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
 
 	mutex_lock(&vcpu->kvm->lock);
-	vgic_change_active_prepare(vcpu, intid);
+	vgic_access_active_prepare(vcpu, intid);
 
 	__vgic_mmio_write_sactive(vcpu, addr, len, val);
 
-	vgic_change_active_finish(vcpu, intid);
+	vgic_access_active_finish(vcpu, intid);
 	mutex_unlock(&vcpu->kvm->lock);
 }
 
diff --git a/virt/kvm/arm/vgic/vgic-mmio.h b/virt/kvm/arm/vgic/vgic-mmio.h
index 836f418f1ee80..b6aff52524299 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.h
+++ b/virt/kvm/arm/vgic/vgic-mmio.h
@@ -157,6 +157,9 @@ void vgic_mmio_write_cpending(struct kvm_vcpu *vcpu,
 unsigned long vgic_mmio_read_active(struct kvm_vcpu *vcpu,
 				    gpa_t addr, unsigned int len);
 
+unsigned long vgic_uaccess_read_active(struct kvm_vcpu *vcpu,
+				    gpa_t addr, unsigned int len);
+
 void vgic_mmio_write_cactive(struct kvm_vcpu *vcpu,
 			     gpa_t addr, unsigned int len,
 			     unsigned long val);
-- 
2.20.1



