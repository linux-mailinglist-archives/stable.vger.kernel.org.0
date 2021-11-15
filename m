Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71DE7451EEF
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:35:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346813AbhKPAiC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:38:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:45222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344613AbhKOTZH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 573AE6369E;
        Mon, 15 Nov 2021 19:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002858;
        bh=/RWbr0uVzE/gGLArKdCbZsNNoobQUTceSt9Mu2lC6A8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rYQrOtfdZ8jby+RuPnhrWCoREeQLfY+FuhPO/u5CSa+SXSW/IgsEgrf19ZvG9snNy
         oLLNVwUHugOn/bTNxApxWaTBmMp7xSFlnVwdqCXdNTI8T/BuwexHqBQRXRVtGNZ+pi
         AV5sI9Jbxoqow0v+nD8IogOzJ2qsCa8ulke/RL+c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 722/917] PCI: uniphier: Serialize INTx masking/unmasking and fix the bit operation
Date:   Mon, 15 Nov 2021 18:03:37 +0100
Message-Id: <20211115165453.388332809@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>

[ Upstream commit 4caab28a6215da5f3c1b505ff08810bc6acfe365 ]

The condition register PCI_RCV_INTX is used in irq_mask() and irq_unmask()
callbacks. Accesses to register can occur at the same time without a lock.
Add a lock into each callback to prevent the issue.

And INTX mask and unmask fields in PCL_RCV_INTX register should only be
set/reset for each bit. Clearing by PCL_RCV_INTX_ALL_MASK should be
removed.

INTX status fields in PCL_RCV_INTX register only indicates each INTX
interrupt status, so the handler can't clear by writing 1 to the field.
The status is expected to be cleared by the interrupt origin.
The ack function has no meaning, so should remove it.

Suggested-by: Pali Rohár <pali@kernel.org>
Link: https://lore.kernel.org/r/1631924579-24567-1-git-send-email-hayashi.kunihiko@socionext.com
Fixes: 7e6d5cd88a6f ("PCI: uniphier: Add UniPhier PCIe host controller support")
Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Acked-by: Pali Rohár <pali@kernel.org>
Acked-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-uniphier.c | 26 +++++++++-------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-uniphier.c b/drivers/pci/controller/dwc/pcie-uniphier.c
index d842fd0181299..d05be942956e2 100644
--- a/drivers/pci/controller/dwc/pcie-uniphier.c
+++ b/drivers/pci/controller/dwc/pcie-uniphier.c
@@ -168,30 +168,21 @@ static void uniphier_pcie_irq_enable(struct uniphier_pcie_priv *priv)
 	writel(PCL_RCV_INTX_ALL_ENABLE, priv->base + PCL_RCV_INTX);
 }
 
-static void uniphier_pcie_irq_ack(struct irq_data *d)
-{
-	struct pcie_port *pp = irq_data_get_irq_chip_data(d);
-	struct dw_pcie *pci = to_dw_pcie_from_pp(pp);
-	struct uniphier_pcie_priv *priv = to_uniphier_pcie(pci);
-	u32 val;
-
-	val = readl(priv->base + PCL_RCV_INTX);
-	val &= ~PCL_RCV_INTX_ALL_STATUS;
-	val |= BIT(irqd_to_hwirq(d) + PCL_RCV_INTX_STATUS_SHIFT);
-	writel(val, priv->base + PCL_RCV_INTX);
-}
-
 static void uniphier_pcie_irq_mask(struct irq_data *d)
 {
 	struct pcie_port *pp = irq_data_get_irq_chip_data(d);
 	struct dw_pcie *pci = to_dw_pcie_from_pp(pp);
 	struct uniphier_pcie_priv *priv = to_uniphier_pcie(pci);
+	unsigned long flags;
 	u32 val;
 
+	raw_spin_lock_irqsave(&pp->lock, flags);
+
 	val = readl(priv->base + PCL_RCV_INTX);
-	val &= ~PCL_RCV_INTX_ALL_MASK;
 	val |= BIT(irqd_to_hwirq(d) + PCL_RCV_INTX_MASK_SHIFT);
 	writel(val, priv->base + PCL_RCV_INTX);
+
+	raw_spin_unlock_irqrestore(&pp->lock, flags);
 }
 
 static void uniphier_pcie_irq_unmask(struct irq_data *d)
@@ -199,17 +190,20 @@ static void uniphier_pcie_irq_unmask(struct irq_data *d)
 	struct pcie_port *pp = irq_data_get_irq_chip_data(d);
 	struct dw_pcie *pci = to_dw_pcie_from_pp(pp);
 	struct uniphier_pcie_priv *priv = to_uniphier_pcie(pci);
+	unsigned long flags;
 	u32 val;
 
+	raw_spin_lock_irqsave(&pp->lock, flags);
+
 	val = readl(priv->base + PCL_RCV_INTX);
-	val &= ~PCL_RCV_INTX_ALL_MASK;
 	val &= ~BIT(irqd_to_hwirq(d) + PCL_RCV_INTX_MASK_SHIFT);
 	writel(val, priv->base + PCL_RCV_INTX);
+
+	raw_spin_unlock_irqrestore(&pp->lock, flags);
 }
 
 static struct irq_chip uniphier_pcie_irq_chip = {
 	.name = "PCI",
-	.irq_ack = uniphier_pcie_irq_ack,
 	.irq_mask = uniphier_pcie_irq_mask,
 	.irq_unmask = uniphier_pcie_irq_unmask,
 };
-- 
2.33.0



