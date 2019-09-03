Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97CE4A72A9
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 20:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726027AbfICSlH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 14:41:07 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:54287 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725883AbfICSlH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Sep 2019 14:41:07 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 98D7422267;
        Tue,  3 Sep 2019 14:41:06 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 03 Sep 2019 14:41:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=6TCRA2
        XxLnpu7dlikiHqVvs1A02WwdrqYfp85yivxX8=; b=w0DBSAr6wjEnxJGhomGQC5
        B8SFSAGDrDvgHzOBDAGa9r8VlKcm1MZ+ZkYGWbBdOE6DATpYKcnkFUsuZFjyW9ho
        lJIGHXYsGjd6kys9W0i8y3Fy3bL7SrNQ08u/eOuVL29VaPfSImUUZ1QbBhIoAcM1
        45gysis3pqB8GR13+eyDZPrbPC17Ldi/PogkwA2LYeXEdvQlO0kT0tR6eJYDNLal
        9Zt9NU6B4nK3E4M78akaM+bGjYkFDMS+uI+6bWxXEZP5kTTlwtuDEduNOL7AFsoI
        2xXAQ1CfItQKRVE05/X7EGhoj/jgzBo9gZcZpLxNy/LJb6nn+CoPHXeLaWPOJGqA
        ==
X-ME-Sender: <xms:wrNuXcPtNs4jz7xMzI4tieY8xFerVZ4iujiySdA2JZTLcRWPABhZxg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudejfedgleekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepie
X-ME-Proxy: <xmx:wrNuXVNykm_svfaY9pdrKQLVto_X1fRsZ6esG6UAXA94rNa8XTR6NQ>
    <xmx:wrNuXVgb2V12DYdBNsJjcWP5sI0NvrPbmt38pPvJqns8wF6ck8h1gA>
    <xmx:wrNuXasi0RdrBLvR3JqKWDUi_ZJpaJ4X6i1POWJGMgUF9DsKyUKoDw>
    <xmx:wrNuXdp_kTU2MlZe0Y992s2WKmQk88NlXuIBkjTfaHZXBS24EfmSmQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 393DED60057;
        Tue,  3 Sep 2019 14:41:06 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: arm/arm64: vgic-v2: Handle SGI bits in GICD_I{S,C}PENDR0" failed to apply to 4.9-stable tree
To:     maz@kernel.org, andre.przywara@arm.com, will@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Sep 2019 20:40:56 +0200
Message-ID: <15675360569187@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 82e40f558de566fdee214bec68096bbd5e64a6a4 Mon Sep 17 00:00:00 2001
From: Marc Zyngier <maz@kernel.org>
Date: Wed, 28 Aug 2019 11:10:16 +0100
Subject: [PATCH] KVM: arm/arm64: vgic-v2: Handle SGI bits in GICD_I{S,C}PENDR0
 as WI

A guest is not allowed to inject a SGI (or clear its pending state)
by writing to GICD_ISPENDR0 (resp. GICD_ICPENDR0), as these bits are
defined as WI (as per ARM IHI 0048B 4.3.7 and 4.3.8).

Make sure we correctly emulate the architecture.

Fixes: 96b298000db4 ("KVM: arm/arm64: vgic-new: Add PENDING registers handlers")
Cc: stable@vger.kernel.org # 4.7+
Reported-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Will Deacon <will@kernel.org>

diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
index 3ba7278fb533..b249220025bc 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -195,6 +195,12 @@ static void vgic_hw_irq_spending(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
 	vgic_irq_set_phys_active(irq, true);
 }
 
+static bool is_vgic_v2_sgi(struct kvm_vcpu *vcpu, struct vgic_irq *irq)
+{
+	return (vgic_irq_is_sgi(irq->intid) &&
+		vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V2);
+}
+
 void vgic_mmio_write_spending(struct kvm_vcpu *vcpu,
 			      gpa_t addr, unsigned int len,
 			      unsigned long val)
@@ -207,6 +213,12 @@ void vgic_mmio_write_spending(struct kvm_vcpu *vcpu,
 	for_each_set_bit(i, &val, len * 8) {
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
 
+		/* GICD_ISPENDR0 SGI bits are WI */
+		if (is_vgic_v2_sgi(vcpu, irq)) {
+			vgic_put_irq(vcpu->kvm, irq);
+			continue;
+		}
+
 		raw_spin_lock_irqsave(&irq->irq_lock, flags);
 		if (irq->hw)
 			vgic_hw_irq_spending(vcpu, irq, is_uaccess);
@@ -254,6 +266,12 @@ void vgic_mmio_write_cpending(struct kvm_vcpu *vcpu,
 	for_each_set_bit(i, &val, len * 8) {
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
 
+		/* GICD_ICPENDR0 SGI bits are WI */
+		if (is_vgic_v2_sgi(vcpu, irq)) {
+			vgic_put_irq(vcpu->kvm, irq);
+			continue;
+		}
+
 		raw_spin_lock_irqsave(&irq->irq_lock, flags);
 
 		if (irq->hw)
diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
index 6dd5ad706c92..1059ce2ebfdf 100644
--- a/virt/kvm/arm/vgic/vgic-v2.c
+++ b/virt/kvm/arm/vgic/vgic-v2.c
@@ -184,7 +184,10 @@ void vgic_v2_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
 		if (vgic_irq_is_sgi(irq->intid)) {
 			u32 src = ffs(irq->source);
 
-			BUG_ON(!src);
+			if (WARN_RATELIMIT(!src, "No SGI source for INTID %d\n",
+					   irq->intid))
+				return;
+
 			val |= (src - 1) << GICH_LR_PHYSID_CPUID_SHIFT;
 			irq->source &= ~(1 << (src - 1));
 			if (irq->source) {
diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index c2c9ce009f63..f7a4219f4617 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -167,7 +167,10 @@ void vgic_v3_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
 		    model == KVM_DEV_TYPE_ARM_VGIC_V2) {
 			u32 src = ffs(irq->source);
 
-			BUG_ON(!src);
+			if (WARN_RATELIMIT(!src, "No SGI source for INTID %d\n",
+					   irq->intid))
+				return;
+
 			val |= (src - 1) << GICH_LR_PHYSID_CPUID_SHIFT;
 			irq->source &= ~(1 << (src - 1));
 			if (irq->source) {

