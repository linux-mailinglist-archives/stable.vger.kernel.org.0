Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3BA5441FD
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387733AbfFMQS0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:18:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:57758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731114AbfFMIkR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:40:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E75C21473;
        Thu, 13 Jun 2019 08:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415217;
        bh=9QDiZhwmO4zLi7ec8y4uzN+gMC+axulGwP8cLoqMR3Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xYvolUSmNk8cHjdIwIaHirlSormf4ObTlH2/SIedbSo30oEmaL/j3lVYmAfdH1iU8
         bfiT1Yftw6KTWLPbGomZVYYVBxFu1+vjEu5Oge49olunUmWfkP4GgKrZzoetjjK0Zk
         sZiztJOPXz0x1Po/CLetlcb3YpSNm0RgoxlV1VC0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jisheng Zhang <Jisheng.Zhang@synaptics.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Gustavo Pimentel <gustavo.pimentel@synopsys.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 046/118] PCI: dwc: Free MSI IRQ page in dw_pcie_free_msi()
Date:   Thu, 13 Jun 2019 10:33:04 +0200
Message-Id: <20190613075646.483766820@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075643.642092651@linuxfoundation.org>
References: <20190613075643.642092651@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 4eedb2c54ab3..acd50920c2ff 100644
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
index 9f1a5e399b70..14dcf6646699 100644
--- a/drivers/pci/controller/dwc/pcie-designware.h
+++ b/drivers/pci/controller/dwc/pcie-designware.h
@@ -164,6 +164,7 @@ struct pcie_port {
 	struct irq_domain	*irq_domain;
 	struct irq_domain	*msi_domain;
 	dma_addr_t		msi_data;
+	struct page		*msi_page;
 	u32			num_vectors;
 	u32			irq_status[MAX_MSI_CTRLS];
 	raw_spinlock_t		lock;
-- 
2.20.1



