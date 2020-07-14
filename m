Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84FB421FBDD
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729718AbgGNTE7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 15:04:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:53224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730245AbgGNSza (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:55:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 420C621D79;
        Tue, 14 Jul 2020 18:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594752929;
        bh=muY5iUHz/BlEr6zV2wNTZnyKKM+IE0t8F954ng1j9G4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2K+JQrDA9drwp62fwENpLJ+axODxxn9SgPonpyc0ncx6+hKpddGwULHUyzxqV2X8b
         t4AViT433CZkO+unXig2CZTsNNo75QchCgqA8ATyRPry2gWCCGyOEJ7L3kwXyW4mEe
         INUePtCBxJvw4jipqBUSwGreunhoZkCFQ1NXSDg8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zenghui Yu <yuzenghui@huawei.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 053/166] KVM: arm64: vgic-v4: Plug race between non-residency and v4.1 doorbell
Date:   Tue, 14 Jul 2020 20:43:38 +0200
Message-Id: <20200714184118.416543229@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184115.844176932@linuxfoundation.org>
References: <20200714184115.844176932@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit a3f574cd65487cd993f79ab235d70229d9302c1e ]

When making a vPE non-resident because it has hit a blocking WFI,
the doorbell can fire at any time after the write to the RD.
Crucially, it can fire right between the write to GICR_VPENDBASER
and the write to the pending_last field in the its_vpe structure.

This means that we would overwrite pending_last with stale data,
and potentially not wakeup until some unrelated event (such as
a timer interrupt) puts the vPE back on the CPU.

GICv4 isn't affected by this as we actively mask the doorbell on
entering the guest, while GICv4.1 automatically manages doorbell
delivery without any hypervisor-driven masking.

Use the vpe_lock to synchronize such update, which solves the
problem altogether.

Fixes: ae699ad348cdc ("irqchip/gic-v4.1: Move doorbell management to the GICv4 abstraction layer")
Reported-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its.c | 8 ++++++++
 virt/kvm/arm/vgic/vgic-v4.c      | 8 ++++++++
 2 files changed, 16 insertions(+)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index b3e16a06c13b7..b99e3105bf9fe 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -3938,16 +3938,24 @@ static void its_vpe_4_1_deschedule(struct its_vpe *vpe,
 	u64 val;
 
 	if (info->req_db) {
+		unsigned long flags;
+
 		/*
 		 * vPE is going to block: make the vPE non-resident with
 		 * PendingLast clear and DB set. The GIC guarantees that if
 		 * we read-back PendingLast clear, then a doorbell will be
 		 * delivered when an interrupt comes.
+		 *
+		 * Note the locking to deal with the concurrent update of
+		 * pending_last from the doorbell interrupt handler that can
+		 * run concurrently.
 		 */
+		raw_spin_lock_irqsave(&vpe->vpe_lock, flags);
 		val = its_clear_vpend_valid(vlpi_base,
 					    GICR_VPENDBASER_PendingLast,
 					    GICR_VPENDBASER_4_1_DB);
 		vpe->pending_last = !!(val & GICR_VPENDBASER_PendingLast);
+		raw_spin_unlock_irqrestore(&vpe->vpe_lock, flags);
 	} else {
 		/*
 		 * We're not blocking, so just make the vPE non-resident
diff --git a/virt/kvm/arm/vgic/vgic-v4.c b/virt/kvm/arm/vgic/vgic-v4.c
index 27ac833e5ec7c..b5fa73c9fd355 100644
--- a/virt/kvm/arm/vgic/vgic-v4.c
+++ b/virt/kvm/arm/vgic/vgic-v4.c
@@ -90,7 +90,15 @@ static irqreturn_t vgic_v4_doorbell_handler(int irq, void *info)
 	    !irqd_irq_disabled(&irq_to_desc(irq)->irq_data))
 		disable_irq_nosync(irq);
 
+	/*
+	 * The v4.1 doorbell can fire concurrently with the vPE being
+	 * made non-resident. Ensure we only update pending_last
+	 * *after* the non-residency sequence has completed.
+	 */
+	raw_spin_lock(&vcpu->arch.vgic_cpu.vgic_v3.its_vpe.vpe_lock);
 	vcpu->arch.vgic_cpu.vgic_v3.its_vpe.pending_last = true;
+	raw_spin_unlock(&vcpu->arch.vgic_cpu.vgic_v3.its_vpe.vpe_lock);
+
 	kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
 	kvm_vcpu_kick(vcpu);
 
-- 
2.25.1



