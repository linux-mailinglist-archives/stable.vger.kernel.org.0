Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55D47A904F
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388865AbfIDSIy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:08:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:51876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389864AbfIDSIw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:08:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD50C206B8;
        Wed,  4 Sep 2019 18:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620531;
        bh=JEiG6Dy27j7ZODpzmrYkgxRrMO3t6AHP83ZMOOZ8TH4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xn3NcSd2oDHauucnabC/byQbxonYebZiHMVTVZZU4WZHb2Nl6v0V0j2RostSW8YyG
         wXoJg4w40BUMKiPrDuHN+Uq3Jg8gKYXpftJKx5B4b4emC6qDNJqeghta6mY6dzsNSn
         oA8lTOzCwNnhCMDpnsE8YPpH4YjQO/yh4D5OI/o0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 86/93] KVM: arm/arm64: vgic-v2: Handle SGI bits in GICD_I{S,C}PENDR0 as WI
Date:   Wed,  4 Sep 2019 19:54:28 +0200
Message-Id: <20190904175310.545595742@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175302.845828956@linuxfoundation.org>
References: <20190904175302.845828956@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 82e40f558de566fdee214bec68096bbd5e64a6a4 ]

A guest is not allowed to inject a SGI (or clear its pending state)
by writing to GICD_ISPENDR0 (resp. GICD_ICPENDR0), as these bits are
defined as WI (as per ARM IHI 0048B 4.3.7 and 4.3.8).

Make sure we correctly emulate the architecture.

Fixes: 96b298000db4 ("KVM: arm/arm64: vgic-new: Add PENDING registers handlers")
Cc: stable@vger.kernel.org # 4.7+
Reported-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 virt/kvm/arm/vgic/vgic-mmio.c | 18 ++++++++++++++++++
 virt/kvm/arm/vgic/vgic-v2.c   |  5 ++++-
 virt/kvm/arm/vgic/vgic-v3.c   |  5 ++++-
 3 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
index ceeda7e04a4d9..762f81900529e 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -203,6 +203,12 @@ static void vgic_hw_irq_spending(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
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
@@ -215,6 +221,12 @@ void vgic_mmio_write_spending(struct kvm_vcpu *vcpu,
 	for_each_set_bit(i, &val, len * 8) {
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
 
+		/* GICD_ISPENDR0 SGI bits are WI */
+		if (is_vgic_v2_sgi(vcpu, irq)) {
+			vgic_put_irq(vcpu->kvm, irq);
+			continue;
+		}
+
 		spin_lock_irqsave(&irq->irq_lock, flags);
 		if (irq->hw)
 			vgic_hw_irq_spending(vcpu, irq, is_uaccess);
@@ -262,6 +274,12 @@ void vgic_mmio_write_cpending(struct kvm_vcpu *vcpu,
 	for_each_set_bit(i, &val, len * 8) {
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
 
+		/* GICD_ICPENDR0 SGI bits are WI */
+		if (is_vgic_v2_sgi(vcpu, irq)) {
+			vgic_put_irq(vcpu->kvm, irq);
+			continue;
+		}
+
 		spin_lock_irqsave(&irq->irq_lock, flags);
 
 		if (irq->hw)
diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
index 57281c1594d0f..91b14dfacd1dd 100644
--- a/virt/kvm/arm/vgic/vgic-v2.c
+++ b/virt/kvm/arm/vgic/vgic-v2.c
@@ -195,7 +195,10 @@ void vgic_v2_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
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
index 5c55995a1a164..8b958ed05306e 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -179,7 +179,10 @@ void vgic_v3_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
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
-- 
2.20.1



