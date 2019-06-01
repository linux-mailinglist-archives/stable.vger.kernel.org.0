Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8681731F0A
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 15:41:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728087AbfFANTF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 09:19:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:46252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728079AbfFANTF (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Jun 2019 09:19:05 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1B00251C3;
        Sat,  1 Jun 2019 13:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559395144;
        bh=+8uuVNjuBh7liJ4Th6IHfsUlFZoyaK4mlZ2hkJpQeEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BoBd/7jFS+npDi512HfVOUfYRpTZ/buMGC3iJHbw5BdIimvoGyCacxmTOWma+loIZ
         UGBsMujrm3AHag34iob5M8oCB6IO9meL+21T+weM1OjMxGSEj5+b8oi5SD/ab0Qo9T
         jMCdMKslmEZB6u5Cs5sV2paGKp24TanJ9Ph8ApTc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jisheng Zhang <Jisheng.Zhang@synaptics.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Gustavo Pimentel <gustavo.pimentel@synopsys.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 064/186] PCI: dwc: Free MSI IRQ page in dw_pcie_free_msi()
Date:   Sat,  1 Jun 2019 09:14:40 -0400
Message-Id: <20190601131653.24205-64-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190601131653.24205-1-sashal@kernel.org>
References: <20190601131653.24205-1-sashal@kernel.org>
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
index acd185b4661e1..9d22b19b76f2d 100644
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
index 377f4c0b52da5..6fb0a18799324 100644
--- a/drivers/pci/controller/dwc/pcie-designware.h
+++ b/drivers/pci/controller/dwc/pcie-designware.h
@@ -179,6 +179,7 @@ struct pcie_port {
 	struct irq_domain	*irq_domain;
 	struct irq_domain	*msi_domain;
 	dma_addr_t		msi_data;
+	struct page		*msi_page;
 	u32			num_vectors;
 	u32			irq_mask[MAX_MSI_CTRLS];
 	raw_spinlock_t		lock;
-- 
2.20.1

