Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1126D2C9D6A
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729475AbgLAJXH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:23:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:43506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389107AbgLAJG4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:06:56 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C89E220671;
        Tue,  1 Dec 2020 09:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813600;
        bh=rN6gPxUS8DRh8+1qK/T7s4B5UJo6x7C1PlbAEhkXmnw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A4BMXd7FYKKSjr4JggeLr+AHhGMPALRRs3gJj5WBOw0Jz4e8IMELklAL76gkohMsm
         8v9and35TMvp03cwKeJ7/HutdLe7GLFL3VSnp2a7cRvcIA/xuZvVszgIF5fX+pg82L
         zvrepaMHispl6dvojHRosqg6aUtf97betan9oP7I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Cui <mikecui@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        Shay Agroskin <shayagr@amazon.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 64/98] net: ena: set initial DMA width to avoid intel iommu issue
Date:   Tue,  1 Dec 2020 09:53:41 +0100
Message-Id: <20201201084658.225580358@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084652.827177826@linuxfoundation.org>
References: <20201201084652.827177826@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shay Agroskin <shayagr@amazon.com>

[ Upstream commit 09323b3bca95181c0da79daebc8b0603e500f573 ]

The ENA driver uses the readless mechanism, which uses DMA, to find
out what the DMA mask is supposed to be.

If DMA is used without setting the dma_mask first, it causes the
Intel IOMMU driver to think that ENA is a 32-bit device and therefore
disables IOMMU passthrough permanently.

This patch sets the dma_mask to be ENA_MAX_PHYS_ADDR_SIZE_BITS=48
before readless initialization in
ena_device_init()->ena_com_mmio_reg_read_request_init(),
which is large enough to workaround the intel_iommu issue.

DMA mask is set again to the correct value after it's received from the
device after readless is initialized.

The patch also changes the driver to use dma_set_mask_and_coherent()
function instead of the two pci_set_dma_mask() and
pci_set_consistent_dma_mask() ones. Both methods achieve the same
effect.

Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")
Signed-off-by: Mike Cui <mikecui@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
Signed-off-by: Shay Agroskin <shayagr@amazon.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 635345bced313..2e5348ec2a2e9 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -2622,16 +2622,9 @@ static int ena_device_init(struct ena_com_dev *ena_dev, struct pci_dev *pdev,
 		goto err_mmio_read_less;
 	}
 
-	rc = pci_set_dma_mask(pdev, DMA_BIT_MASK(dma_width));
+	rc = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(dma_width));
 	if (rc) {
-		dev_err(dev, "pci_set_dma_mask failed 0x%x\n", rc);
-		goto err_mmio_read_less;
-	}
-
-	rc = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(dma_width));
-	if (rc) {
-		dev_err(dev, "err_pci_set_consistent_dma_mask failed 0x%x\n",
-			rc);
+		dev_err(dev, "dma_set_mask_and_coherent failed %d\n", rc);
 		goto err_mmio_read_less;
 	}
 
@@ -3450,6 +3443,12 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		return rc;
 	}
 
+	rc = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(ENA_MAX_PHYS_ADDR_SIZE_BITS));
+	if (rc) {
+		dev_err(&pdev->dev, "dma_set_mask_and_coherent failed %d\n", rc);
+		goto err_disable_device;
+	}
+
 	pci_set_master(pdev);
 
 	ena_dev = vzalloc(sizeof(*ena_dev));
-- 
2.27.0



