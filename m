Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C04B328884
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:45:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238321AbhCARls (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:41:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:56326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238596AbhCAReP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:34:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0252B64FB5;
        Mon,  1 Mar 2021 16:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617631;
        bh=zALidLivyhGJzurLP3RgXTjQv++DahGtOpqvB+1aiRQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tYJHks0ErVMJcYICq2izSoA532+feRhvBceCGOQqUBUaMqO4YJxSVk+1Qe4j9nBhe
         P+C9q7jVRU3Z+zVMV10KYrje0TACRwIQLx0jS+QmwLZ9jvh6Rqe/7xLHqIh2h0sRxI
         4fkfr9/vdUtqwIW766XwutgNS7wkXdwd755ZwPXo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ferry Toth <ftoth@exalondelft.nl>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 142/340] dmaengine: hsu: disable spurious interrupt
Date:   Mon,  1 Mar 2021 17:11:26 +0100
Message-Id: <20210301161055.305736328@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ferry Toth <ftoth@exalondelft.nl>

[ Upstream commit 035b73b2b3b2e074a56489a7bf84b6a8012c0e0d ]

On Intel Tangier B0 and Anniedale the interrupt line, disregarding
to have different numbers, is shared between HSU DMA and UART IPs.
Thus on such SoCs we are expecting that IRQ handler is called in
UART driver only. hsu_pci_irq was handling the spurious interrupt
from HSU DMA by returning immediately. This wastes CPU time and
since HSU DMA and HSU UART interrupt occur simultaneously they race
to be handled causing delay to the HSU UART interrupt handling.
Fix this by disabling the interrupt entirely.

Fixes: 4831e0d9054c ("serial: 8250_mid: handle interrupt correctly in DMA case")
Signed-off-by: Ferry Toth <ftoth@exalondelft.nl>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20210112223749.97036-1-ftoth@exalondelft.nl
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/hsu/pci.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/dma/hsu/pci.c b/drivers/dma/hsu/pci.c
index 07cc7320a614f..9045a6f7f5893 100644
--- a/drivers/dma/hsu/pci.c
+++ b/drivers/dma/hsu/pci.c
@@ -26,22 +26,12 @@
 static irqreturn_t hsu_pci_irq(int irq, void *dev)
 {
 	struct hsu_dma_chip *chip = dev;
-	struct pci_dev *pdev = to_pci_dev(chip->dev);
 	u32 dmaisr;
 	u32 status;
 	unsigned short i;
 	int ret = 0;
 	int err;
 
-	/*
-	 * On Intel Tangier B0 and Anniedale the interrupt line, disregarding
-	 * to have different numbers, is shared between HSU DMA and UART IPs.
-	 * Thus on such SoCs we are expecting that IRQ handler is called in
-	 * UART driver only.
-	 */
-	if (pdev->device == PCI_DEVICE_ID_INTEL_MRFLD_HSU_DMA)
-		return IRQ_HANDLED;
-
 	dmaisr = readl(chip->regs + HSU_PCI_DMAISR);
 	for (i = 0; i < chip->hsu->nr_channels; i++) {
 		if (dmaisr & 0x1) {
@@ -105,6 +95,17 @@ static int hsu_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (ret)
 		goto err_register_irq;
 
+	/*
+	 * On Intel Tangier B0 and Anniedale the interrupt line, disregarding
+	 * to have different numbers, is shared between HSU DMA and UART IPs.
+	 * Thus on such SoCs we are expecting that IRQ handler is called in
+	 * UART driver only. Instead of handling the spurious interrupt
+	 * from HSU DMA here and waste CPU time and delay HSU UART interrupt
+	 * handling, disable the interrupt entirely.
+	 */
+	if (pdev->device == PCI_DEVICE_ID_INTEL_MRFLD_HSU_DMA)
+		disable_irq_nosync(chip->irq);
+
 	pci_set_drvdata(pdev, chip);
 
 	return 0;
-- 
2.27.0



