Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBC8F40E4B3
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346230AbhIPRFQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:05:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:55310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347682AbhIPRAO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:00:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4FC6961AEE;
        Thu, 16 Sep 2021 16:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809958;
        bh=lQdxppUA1ovEnMMafpb9gz07CK9iTRY7E82vhr2PdRE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pTJD3srWhqz3m9APwHtLZuHdQH3sFdJraaksbVhCu2OPY/waSH+cZFKGt5mPo2mEi
         AcV5jMBVSs0kHojS9HYbUtuTzHDWBoU2lMvmi69ill9j0M1l9ogFPp1mSpgPvF0Ige
         6aaV5Uf1gakkeiN1upiQpctyg9hjgDVK43jCW16c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 345/380] KVM: arm64: vgic: move irq->get_input_level into an ops structure
Date:   Thu, 16 Sep 2021 18:01:42 +0200
Message-Id: <20210916155815.779126002@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit db75f1a33f82ad332b6e139c5960e01999969d2c ]

We already have the option to attach a callback to an interrupt
to retrieve its pending state. As we are planning to expand this
facility, move this callback into its own data structure.

This will limit the size of individual interrupts as the ops
structures can be shared across multiple interrupts.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/arch_timer.c |  8 ++++++--
 arch/arm64/kvm/vgic/vgic.c  | 14 +++++++-------
 include/kvm/arm_vgic.h      | 28 +++++++++++++++++-----------
 3 files changed, 30 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 74e0699661e9..e2288b6bf435 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -1116,6 +1116,10 @@ bool kvm_arch_timer_get_input_level(int vintid)
 	return kvm_timer_should_fire(timer);
 }
 
+static struct irq_ops arch_timer_irq_ops = {
+	.get_input_level = kvm_arch_timer_get_input_level,
+};
+
 int kvm_timer_enable(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_cpu *timer = vcpu_timer(vcpu);
@@ -1143,7 +1147,7 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
 	ret = kvm_vgic_map_phys_irq(vcpu,
 				    map.direct_vtimer->host_timer_irq,
 				    map.direct_vtimer->irq.irq,
-				    kvm_arch_timer_get_input_level);
+				    &arch_timer_irq_ops);
 	if (ret)
 		return ret;
 
@@ -1151,7 +1155,7 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
 		ret = kvm_vgic_map_phys_irq(vcpu,
 					    map.direct_ptimer->host_timer_irq,
 					    map.direct_ptimer->irq.irq,
-					    kvm_arch_timer_get_input_level);
+					    &arch_timer_irq_ops);
 	}
 
 	if (ret)
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 15b666200f0b..111bff47e471 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -182,8 +182,8 @@ bool vgic_get_phys_line_level(struct vgic_irq *irq)
 
 	BUG_ON(!irq->hw);
 
-	if (irq->get_input_level)
-		return irq->get_input_level(irq->intid);
+	if (irq->ops && irq->ops->get_input_level)
+		return irq->ops->get_input_level(irq->intid);
 
 	WARN_ON(irq_get_irqchip_state(irq->host_irq,
 				      IRQCHIP_STATE_PENDING,
@@ -480,7 +480,7 @@ int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
 /* @irq->irq_lock must be held */
 static int kvm_vgic_map_irq(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
 			    unsigned int host_irq,
-			    bool (*get_input_level)(int vindid))
+			    struct irq_ops *ops)
 {
 	struct irq_desc *desc;
 	struct irq_data *data;
@@ -500,7 +500,7 @@ static int kvm_vgic_map_irq(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
 	irq->hw = true;
 	irq->host_irq = host_irq;
 	irq->hwintid = data->hwirq;
-	irq->get_input_level = get_input_level;
+	irq->ops = ops;
 	return 0;
 }
 
@@ -509,11 +509,11 @@ static inline void kvm_vgic_unmap_irq(struct vgic_irq *irq)
 {
 	irq->hw = false;
 	irq->hwintid = 0;
-	irq->get_input_level = NULL;
+	irq->ops = NULL;
 }
 
 int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, unsigned int host_irq,
-			  u32 vintid, bool (*get_input_level)(int vindid))
+			  u32 vintid, struct irq_ops *ops)
 {
 	struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, vintid);
 	unsigned long flags;
@@ -522,7 +522,7 @@ int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, unsigned int host_irq,
 	BUG_ON(!irq);
 
 	raw_spin_lock_irqsave(&irq->irq_lock, flags);
-	ret = kvm_vgic_map_irq(vcpu, irq, host_irq, get_input_level);
+	ret = kvm_vgic_map_irq(vcpu, irq, host_irq, ops);
 	raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
 	vgic_put_irq(vcpu->kvm, irq);
 
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index ec621180ef09..feaffeaffeec 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -89,6 +89,21 @@ enum vgic_irq_config {
 	VGIC_CONFIG_LEVEL
 };
 
+/*
+ * Per-irq ops overriding some common behavious.
+ *
+ * Always called in non-preemptible section and the functions can use
+ * kvm_arm_get_running_vcpu() to get the vcpu pointer for private IRQs.
+ */
+struct irq_ops {
+	/*
+	 * Callback function pointer to in-kernel devices that can tell us the
+	 * state of the input level of mapped level-triggered IRQ faster than
+	 * peaking into the physical GIC.
+	 */
+	bool (*get_input_level)(int vintid);
+};
+
 struct vgic_irq {
 	raw_spinlock_t irq_lock;	/* Protects the content of the struct */
 	struct list_head lpi_list;	/* Used to link all LPIs together */
@@ -126,16 +141,7 @@ struct vgic_irq {
 	u8 group;			/* 0 == group 0, 1 == group 1 */
 	enum vgic_irq_config config;	/* Level or edge */
 
-	/*
-	 * Callback function pointer to in-kernel devices that can tell us the
-	 * state of the input level of mapped level-triggered IRQ faster than
-	 * peaking into the physical GIC.
-	 *
-	 * Always called in non-preemptible section and the functions can use
-	 * kvm_arm_get_running_vcpu() to get the vcpu pointer for private
-	 * IRQs.
-	 */
-	bool (*get_input_level)(int vintid);
+	struct irq_ops *ops;
 
 	void *owner;			/* Opaque pointer to reserve an interrupt
 					   for in-kernel devices. */
@@ -352,7 +358,7 @@ void kvm_vgic_init_cpu_hardware(void);
 int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
 			bool level, void *owner);
 int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, unsigned int host_irq,
-			  u32 vintid, bool (*get_input_level)(int vindid));
+			  u32 vintid, struct irq_ops *ops);
 int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, unsigned int vintid);
 bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int vintid);
 
-- 
2.30.2



