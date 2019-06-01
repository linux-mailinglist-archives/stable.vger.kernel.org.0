Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8573431EA1
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 15:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727735AbfFANh7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 09:37:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:49144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728576AbfFANVk (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Jun 2019 09:21:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8349B272FC;
        Sat,  1 Jun 2019 13:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559395300;
        bh=FgMFEcTVwa74AVoDLLyLM/uFPRGeAP3wLj1aXlqq6GY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mjz7jWbCvNp7F1s/lg2zBH8tigaF166tnmg9CTAwMVUSsSsRS6Gdc9rPeIrdgsyuG
         zdvHSaDyqSonykWZ4QKKIwGscfkISMOks8G+eUhF3IH0ey2siYPen79KlKVwcVnFjZ
         lyaAro99w2GjYIxdPkuffiQAXR8uUKK+C5X4fcJM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jisheng Zhang <Jisheng.Zhang@synaptics.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Gustavo Pimentel <gustavo.pimentel@synopsys.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 060/173] PCI: dwc: Free MSI IRQ page in dw_pcie_free_msi()
Date:   Sat,  1 Jun 2019 09:17:32 -0400
Message-Id: <20190601131934.25053-60-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190601131934.25053-1-sashal@kernel.org>
References: <20190601131934.25053-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jisheng Zhang <Jisheng.Zhang@synaptics.com>

[ Upstream commit dc69a3d567941784c3d00e1d0834582b42b0b3e7 ]

To avoid a memory leak, free the page allocated for MSI IRQ in
dw_pcie_free_msi().

Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Gustavo Pimentel <gustavo.pimentel@synopsys.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-designware-host.c | 12 ++++++++----
 drivers/pci/controller/dwc/pcie-designware.h      |  1 +
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-designware-host.c b/drivers/pci/controller/dwc/pcie-designware-host.c
index d14a6237bdf5a..86ee6d1888d75 100644
--- a/drivers/pci/controller/dwc/pcie-designware-host.c
+++ b/drivers/pci/controller/dwc/pcie-designware-host.c
@@ -303,20 +303,24 @@ void dw_pcie_free_msi(struct pcie_port *pp)
 
 	irq_domain_remove(pp->msi_domain);
 	irq_domain_remove(pp->irq_domain);
+
+	if (pp->msi_page)
+		__free_page(pp->msi_page);
 }
 
 void dw_pcie_msi_init(struct pcie_port *pp)
 {
 	struct dw_pcie *pci = to_dw_pcie_from_pp(pp);
 	struct device *dev = pci->dev;
-	struct page *page;
 	u64 msi_target;
 
-	page = alloc_page(GFP_KERNEL);
-	pp->msi_data = dma_map_page(dev, page, 0, PAGE_SIZE, DMA_FROM_DEVICE);
+	pp->msi_page = alloc_page(GFP_KERNEL);
+	pp->msi_data = dma_map_page(dev, pp->msi_page, 0, PAGE_SIZE,
+				    DMA_FROM_DEVICE);
 	if (dma_mapping_error(dev, pp->msi_data)) {
 		dev_err(dev, "Failed to map MSI data\n");
-		__free_page(page);
+		__free_page(pp->msi_page);
+		pp->msi_page = NULL;
 		return;
 	}
 	msi_target = (u64)pp->msi_data;
diff --git a/drivers/pci/controller/dwc/pcie-designware.h b/drivers/pci/controller/dwc/pcie-designware.h
index 9943d8c68335d..0cede55a7bcc1 100644
--- a/drivers/pci/controller/dwc/pcie-designware.h
+++ b/drivers/pci/controller/dwc/pcie-designware.h
@@ -176,6 +176,7 @@ struct pcie_port {
 	struct irq_domain	*irq_domain;
 	struct irq_domain	*msi_domain;
 	dma_addr_t		msi_data;
+	struct page		*msi_page;
 	u32			num_vectors;
 	u32			irq_status[MAX_MSI_CTRLS];
 	raw_spinlock_t		lock;
-- 
2.20.1

