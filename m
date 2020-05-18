Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C83D1D82E0
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732184AbgERSAK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:00:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:41162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732177AbgERSAF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:00:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0FC2207D3;
        Mon, 18 May 2020 18:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824804;
        bh=3x6xQBKul6lic3SYWWK86gh27r2mBGPwt15bnf9Gi+Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NLSKhV+2yVJSepnoj82d1Hg3uu7rKAcCPrHM6sktkQVlFhDwFToEyr3oLKLiCdJhE
         NnWLzLkBrvhtDr1rUFU0P+Sy+RaWsZiZLM3Tyiqu5jOdwvP0CEdCgbTzGwRgey4Jc8
         V9RWuO7wTTXioDC9zZso3/vHos95mwF/cZrXfznM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Morse <james.morse@arm.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 011/194] KVM: arm: vgic-v2: Only use the virtual state when userspace accesses pending bits
Date:   Mon, 18 May 2020 19:35:01 +0200
Message-Id: <20200518173532.573433551@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit ba1ed9e17b581c9a204ec1d72d40472dd8557edd ]

There is no point in accessing the HW when writing to any of the
ISPENDR/ICPENDR registers from userspace, as only the guest should
be allowed to change the HW state.

Introduce new userspace-specific accessors that deal solely with
the virtual state. Note that the API differs from that of GICv3,
where userspace exclusively uses ISPENDR to set the state. Too
bad we can't reuse it.

Fixes: 82e40f558de56 ("KVM: arm/arm64: vgic-v2: Handle SGI bits in GICD_I{S,C}PENDR0 as WI")
Reviewed-by: James Morse <james.morse@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 virt/kvm/arm/vgic/vgic-mmio-v2.c |  6 ++-
 virt/kvm/arm/vgic/vgic-mmio.c    | 87 ++++++++++++++++++++++++--------
 virt/kvm/arm/vgic/vgic-mmio.h    |  8 +++
 3 files changed, 77 insertions(+), 24 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
index d63881f60e1a5..7b288eb391b84 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
@@ -415,10 +415,12 @@ static const struct vgic_register_region vgic_v2_dist_registers[] = {
 		vgic_mmio_read_enable, vgic_mmio_write_cenable, NULL, NULL, 1,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_PENDING_SET,
-		vgic_mmio_read_pending, vgic_mmio_write_spending, NULL, NULL, 1,
+		vgic_mmio_read_pending, vgic_mmio_write_spending,
+		NULL, vgic_uaccess_write_spending, 1,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_PENDING_CLEAR,
-		vgic_mmio_read_pending, vgic_mmio_write_cpending, NULL, NULL, 1,
+		vgic_mmio_read_pending, vgic_mmio_write_cpending,
+		NULL, vgic_uaccess_write_cpending, 1,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ACTIVE_SET,
 		vgic_mmio_read_active, vgic_mmio_write_sactive,
diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
index f659654b09a83..b6824bba8248b 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -179,17 +179,6 @@ unsigned long vgic_mmio_read_pending(struct kvm_vcpu *vcpu,
 	return value;
 }
 
-/* Must be called with irq->irq_lock held */
-static void vgic_hw_irq_spending(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
-				 bool is_uaccess)
-{
-	if (is_uaccess)
-		return;
-
-	irq->pending_latch = true;
-	vgic_irq_set_phys_active(irq, true);
-}
-
 static bool is_vgic_v2_sgi(struct kvm_vcpu *vcpu, struct vgic_irq *irq)
 {
 	return (vgic_irq_is_sgi(irq->intid) &&
@@ -200,7 +189,6 @@ void vgic_mmio_write_spending(struct kvm_vcpu *vcpu,
 			      gpa_t addr, unsigned int len,
 			      unsigned long val)
 {
-	bool is_uaccess = !kvm_get_running_vcpu();
 	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
 	int i;
 	unsigned long flags;
@@ -215,22 +203,49 @@ void vgic_mmio_write_spending(struct kvm_vcpu *vcpu,
 		}
 
 		raw_spin_lock_irqsave(&irq->irq_lock, flags);
+
+		irq->pending_latch = true;
 		if (irq->hw)
-			vgic_hw_irq_spending(vcpu, irq, is_uaccess);
-		else
-			irq->pending_latch = true;
+			vgic_irq_set_phys_active(irq, true);
+
 		vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
 		vgic_put_irq(vcpu->kvm, irq);
 	}
 }
 
-/* Must be called with irq->irq_lock held */
-static void vgic_hw_irq_cpending(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
-				 bool is_uaccess)
+int vgic_uaccess_write_spending(struct kvm_vcpu *vcpu,
+				gpa_t addr, unsigned int len,
+				unsigned long val)
 {
-	if (is_uaccess)
-		return;
+	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
+	int i;
+	unsigned long flags;
+
+	for_each_set_bit(i, &val, len * 8) {
+		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
+
+		raw_spin_lock_irqsave(&irq->irq_lock, flags);
+		irq->pending_latch = true;
+
+		/*
+		 * GICv2 SGIs are terribly broken. We can't restore
+		 * the source of the interrupt, so just pick the vcpu
+		 * itself as the source...
+		 */
+		if (is_vgic_v2_sgi(vcpu, irq))
+			irq->source |= BIT(vcpu->vcpu_id);
+
+		vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
+
+		vgic_put_irq(vcpu->kvm, irq);
+	}
 
+	return 0;
+}
+
+/* Must be called with irq->irq_lock held */
+static void vgic_hw_irq_cpending(struct kvm_vcpu *vcpu, struct vgic_irq *irq)
+{
 	irq->pending_latch = false;
 
 	/*
@@ -253,7 +268,6 @@ void vgic_mmio_write_cpending(struct kvm_vcpu *vcpu,
 			      gpa_t addr, unsigned int len,
 			      unsigned long val)
 {
-	bool is_uaccess = !kvm_get_running_vcpu();
 	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
 	int i;
 	unsigned long flags;
@@ -270,7 +284,7 @@ void vgic_mmio_write_cpending(struct kvm_vcpu *vcpu,
 		raw_spin_lock_irqsave(&irq->irq_lock, flags);
 
 		if (irq->hw)
-			vgic_hw_irq_cpending(vcpu, irq, is_uaccess);
+			vgic_hw_irq_cpending(vcpu, irq);
 		else
 			irq->pending_latch = false;
 
@@ -279,6 +293,35 @@ void vgic_mmio_write_cpending(struct kvm_vcpu *vcpu,
 	}
 }
 
+int vgic_uaccess_write_cpending(struct kvm_vcpu *vcpu,
+				gpa_t addr, unsigned int len,
+				unsigned long val)
+{
+	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
+	int i;
+	unsigned long flags;
+
+	for_each_set_bit(i, &val, len * 8) {
+		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
+
+		raw_spin_lock_irqsave(&irq->irq_lock, flags);
+		/*
+		 * More fun with GICv2 SGIs! If we're clearing one of them
+		 * from userspace, which source vcpu to clear? Let's not
+		 * even think of it, and blow the whole set.
+		 */
+		if (is_vgic_v2_sgi(vcpu, irq))
+			irq->source = 0;
+
+		irq->pending_latch = false;
+
+		raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
+
+		vgic_put_irq(vcpu->kvm, irq);
+	}
+
+	return 0;
+}
 
 /*
  * If we are fiddling with an IRQ's active state, we have to make sure the IRQ
diff --git a/virt/kvm/arm/vgic/vgic-mmio.h b/virt/kvm/arm/vgic/vgic-mmio.h
index 30713a44e3faa..b127f889113ed 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.h
+++ b/virt/kvm/arm/vgic/vgic-mmio.h
@@ -149,6 +149,14 @@ void vgic_mmio_write_cpending(struct kvm_vcpu *vcpu,
 			      gpa_t addr, unsigned int len,
 			      unsigned long val);
 
+int vgic_uaccess_write_spending(struct kvm_vcpu *vcpu,
+				gpa_t addr, unsigned int len,
+				unsigned long val);
+
+int vgic_uaccess_write_cpending(struct kvm_vcpu *vcpu,
+				gpa_t addr, unsigned int len,
+				unsigned long val);
+
 unsigned long vgic_mmio_read_active(struct kvm_vcpu *vcpu,
 				    gpa_t addr, unsigned int len);
 
-- 
2.20.1



