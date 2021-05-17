Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A36A6382FC9
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237444AbhEQOUm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:20:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:36022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239132AbhEQOSs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:18:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7CBA6135C;
        Mon, 17 May 2021 14:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260638;
        bh=JpDUeprsjKlfBMz1CXq7XKtzVol5HwPWf7W0ae9Xz/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rpv/s54EB6+cWaFlG2+ShH+6Eshn1MhUub+jg2R6wgtxpmHG1xv9vZpy8AxxXpRsV
         BJMg3iTdA5umB46/K/eGuoaQZOVGaOjhpX1DhcGUDmoyBhGENkEfssyytq6Pp25IKx
         Vg09700eoccCkpASXoCWCEakHA4jLxiNoXrrLqgA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 171/363] dmaengine: idxd: removal of pcim managed mmio mapping
Date:   Mon, 17 May 2021 16:00:37 +0200
Message-Id: <20210517140308.380545206@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit a39c7cd0438ee2f0b859ee1eb86cdc52217d2223 ]

The devm managed lifetime is incompatible with 'struct device' objects that
resides in idxd context. This is one of the series that clean up the idxd
driver 'struct device' lifetime. Remove pcim_* management of the PCI device
and the ioremap of MMIO BAR and replace with unmanaged versions. This is
for consistency of removing all the pcim/devm based calls.

Reported-by: Jason Gunthorpe <jgg@nvidia.com>
Fixes: bfe1d56091c1 ("dmaengine: idxd: Init and probe for Intel data accelerators")
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Link: https://lore.kernel.org/r/161852984150.2203940.8043988289748519056.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/init.c | 33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff --git a/drivers/dma/idxd/init.c b/drivers/dma/idxd/init.c
index 5cf1bf095ae1..11a2e14b5b80 100644
--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -384,32 +384,36 @@ static int idxd_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	struct idxd_device *idxd;
 	int rc;
 
-	rc = pcim_enable_device(pdev);
+	rc = pci_enable_device(pdev);
 	if (rc)
 		return rc;
 
 	dev_dbg(dev, "Alloc IDXD context\n");
 	idxd = idxd_alloc(pdev);
-	if (!idxd)
-		return -ENOMEM;
+	if (!idxd) {
+		rc = -ENOMEM;
+		goto err_idxd_alloc;
+	}
 
 	dev_dbg(dev, "Mapping BARs\n");
-	idxd->reg_base = pcim_iomap(pdev, IDXD_MMIO_BAR, 0);
-	if (!idxd->reg_base)
-		return -ENOMEM;
+	idxd->reg_base = pci_iomap(pdev, IDXD_MMIO_BAR, 0);
+	if (!idxd->reg_base) {
+		rc = -ENOMEM;
+		goto err_iomap;
+	}
 
 	dev_dbg(dev, "Set DMA masks\n");
 	rc = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
 	if (rc)
 		rc = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 	if (rc)
-		return rc;
+		goto err;
 
 	rc = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
 	if (rc)
 		rc = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 	if (rc)
-		return rc;
+		goto err;
 
 	idxd_set_type(idxd);
 
@@ -423,13 +427,13 @@ static int idxd_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	rc = idxd_probe(idxd);
 	if (rc) {
 		dev_err(dev, "Intel(R) IDXD DMA Engine init failed\n");
-		return -ENODEV;
+		goto err;
 	}
 
 	rc = idxd_setup_sysfs(idxd);
 	if (rc) {
 		dev_err(dev, "IDXD sysfs setup failed\n");
-		return -ENODEV;
+		goto err;
 	}
 
 	idxd->state = IDXD_DEV_CONF_READY;
@@ -438,6 +442,13 @@ static int idxd_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		 idxd->hw.version);
 
 	return 0;
+
+ err:
+	pci_iounmap(pdev, idxd->reg_base);
+ err_iomap:
+ err_idxd_alloc:
+	pci_disable_device(pdev);
+	return rc;
 }
 
 static void idxd_flush_pending_llist(struct idxd_irq_entry *ie)
@@ -493,6 +504,8 @@ static void idxd_shutdown(struct pci_dev *pdev)
 
 	idxd_msix_perm_clear(idxd);
 	pci_free_irq_vectors(pdev);
+	pci_iounmap(pdev, idxd->reg_base);
+	pci_disable_device(pdev);
 	destroy_workqueue(idxd->wq);
 }
 
-- 
2.30.2



