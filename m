Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36F8E382FC8
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237425AbhEQOUl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:20:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:36020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239131AbhEQOSs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:18:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C4636141E;
        Mon, 17 May 2021 14:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260636;
        bh=pY+RD4Yo4N+SEXfeQnpzB1pdPfmtbJXl5JfqBLwPEZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1GIoCjQUS9Nse/JDs0AWmy2WSO75c/7WRPBygiVCx1MOED+2v9E10KtgAQE6n5k41
         VxxMjVtd+tPqcHQEN52JFKnq3ZP1vQ4JKD5YCjyAcXSBKRVtKXwVWirMXo0mb2D3o8
         k9Vhl7yY8UTaBEvSbttIP0LWamFhzJK0G9Szd2Ss=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 170/363] dmaengine: idxd: cleanup pci interrupt vector allocation management
Date:   Mon, 17 May 2021 16:00:36 +0200
Message-Id: <20210517140308.350482157@linuxfoundation.org>
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

[ Upstream commit 5fc8e85ff12ce0530ac658686902a0ee64600f56 ]

The devm managed lifetime is incompatible with 'struct device' objects that
resides in idxd context. This is one of the series that clean up the idxd
driver 'struct device' lifetime. Remove devm managed pci interrupt vectors
and replace with unmanged allocators.

Reported-by: Jason Gunthorpe <jgg@nvidia.com>
Fixes: bfe1d56091c1 ("dmaengine: idxd: Init and probe for Intel data accelerators")
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Link: https://lore.kernel.org/r/161852983563.2203940.8116028229124776669.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/device.c |  4 +--
 drivers/dma/idxd/idxd.h   |  2 +-
 drivers/dma/idxd/init.c   | 64 +++++++++++++++++----------------------
 3 files changed, 30 insertions(+), 40 deletions(-)

diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index d255bb016c4d..3f696abd74ac 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -19,7 +19,7 @@ static void idxd_cmd_exec(struct idxd_device *idxd, int cmd_code, u32 operand,
 /* Interrupt control bits */
 void idxd_mask_msix_vector(struct idxd_device *idxd, int vec_id)
 {
-	struct irq_data *data = irq_get_irq_data(idxd->msix_entries[vec_id].vector);
+	struct irq_data *data = irq_get_irq_data(idxd->irq_entries[vec_id].vector);
 
 	pci_msi_mask_irq(data);
 }
@@ -36,7 +36,7 @@ void idxd_mask_msix_vectors(struct idxd_device *idxd)
 
 void idxd_unmask_msix_vector(struct idxd_device *idxd, int vec_id)
 {
-	struct irq_data *data = irq_get_irq_data(idxd->msix_entries[vec_id].vector);
+	struct irq_data *data = irq_get_irq_data(idxd->irq_entries[vec_id].vector);
 
 	pci_msi_unmask_irq(data);
 }
diff --git a/drivers/dma/idxd/idxd.h b/drivers/dma/idxd/idxd.h
index 80e534680c9a..401b035e42b1 100644
--- a/drivers/dma/idxd/idxd.h
+++ b/drivers/dma/idxd/idxd.h
@@ -36,6 +36,7 @@ struct idxd_device_driver {
 struct idxd_irq_entry {
 	struct idxd_device *idxd;
 	int id;
+	int vector;
 	struct llist_head pending_llist;
 	struct list_head work_list;
 	/*
@@ -219,7 +220,6 @@ struct idxd_device {
 
 	union sw_err_reg sw_err;
 	wait_queue_head_t cmd_waitq;
-	struct msix_entry *msix_entries;
 	int num_wq_irqs;
 	struct idxd_irq_entry *irq_entries;
 
diff --git a/drivers/dma/idxd/init.c b/drivers/dma/idxd/init.c
index 6584b0ec07d5..5cf1bf095ae1 100644
--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -61,7 +61,6 @@ static int idxd_setup_interrupts(struct idxd_device *idxd)
 {
 	struct pci_dev *pdev = idxd->pdev;
 	struct device *dev = &pdev->dev;
-	struct msix_entry *msix;
 	struct idxd_irq_entry *irq_entry;
 	int i, msixcnt;
 	int rc = 0;
@@ -69,23 +68,13 @@ static int idxd_setup_interrupts(struct idxd_device *idxd)
 	msixcnt = pci_msix_vec_count(pdev);
 	if (msixcnt < 0) {
 		dev_err(dev, "Not MSI-X interrupt capable.\n");
-		goto err_no_irq;
+		return -ENOSPC;
 	}
 
-	idxd->msix_entries = devm_kzalloc(dev, sizeof(struct msix_entry) *
-			msixcnt, GFP_KERNEL);
-	if (!idxd->msix_entries) {
-		rc = -ENOMEM;
-		goto err_no_irq;
-	}
-
-	for (i = 0; i < msixcnt; i++)
-		idxd->msix_entries[i].entry = i;
-
-	rc = pci_enable_msix_exact(pdev, idxd->msix_entries, msixcnt);
-	if (rc) {
-		dev_err(dev, "Failed enabling %d MSIX entries.\n", msixcnt);
-		goto err_no_irq;
+	rc = pci_alloc_irq_vectors(pdev, msixcnt, msixcnt, PCI_IRQ_MSIX);
+	if (rc != msixcnt) {
+		dev_err(dev, "Failed enabling %d MSIX entries: %d\n", msixcnt, rc);
+		return -ENOSPC;
 	}
 	dev_dbg(dev, "Enabled %d msix vectors\n", msixcnt);
 
@@ -98,58 +87,57 @@ static int idxd_setup_interrupts(struct idxd_device *idxd)
 					 GFP_KERNEL);
 	if (!idxd->irq_entries) {
 		rc = -ENOMEM;
-		goto err_no_irq;
+		goto err_irq_entries;
 	}
 
 	for (i = 0; i < msixcnt; i++) {
 		idxd->irq_entries[i].id = i;
 		idxd->irq_entries[i].idxd = idxd;
+		idxd->irq_entries[i].vector = pci_irq_vector(pdev, i);
 		spin_lock_init(&idxd->irq_entries[i].list_lock);
 	}
 
-	msix = &idxd->msix_entries[0];
 	irq_entry = &idxd->irq_entries[0];
-	rc = devm_request_threaded_irq(dev, msix->vector, idxd_irq_handler,
-				       idxd_misc_thread, 0, "idxd-misc",
-				       irq_entry);
+	rc = request_threaded_irq(irq_entry->vector, idxd_irq_handler, idxd_misc_thread,
+				  0, "idxd-misc", irq_entry);
 	if (rc < 0) {
 		dev_err(dev, "Failed to allocate misc interrupt.\n");
-		goto err_no_irq;
+		goto err_misc_irq;
 	}
 
-	dev_dbg(dev, "Allocated idxd-misc handler on msix vector %d\n",
-		msix->vector);
+	dev_dbg(dev, "Allocated idxd-misc handler on msix vector %d\n", irq_entry->vector);
 
 	/* first MSI-X entry is not for wq interrupts */
 	idxd->num_wq_irqs = msixcnt - 1;
 
 	for (i = 1; i < msixcnt; i++) {
-		msix = &idxd->msix_entries[i];
 		irq_entry = &idxd->irq_entries[i];
 
 		init_llist_head(&idxd->irq_entries[i].pending_llist);
 		INIT_LIST_HEAD(&idxd->irq_entries[i].work_list);
-		rc = devm_request_threaded_irq(dev, msix->vector,
-					       idxd_irq_handler,
-					       idxd_wq_thread, 0,
-					       "idxd-portal", irq_entry);
+		rc = request_threaded_irq(irq_entry->vector, idxd_irq_handler,
+					  idxd_wq_thread, 0, "idxd-portal", irq_entry);
 		if (rc < 0) {
-			dev_err(dev, "Failed to allocate irq %d.\n",
-				msix->vector);
-			goto err_no_irq;
+			dev_err(dev, "Failed to allocate irq %d.\n", irq_entry->vector);
+			goto err_wq_irqs;
 		}
-		dev_dbg(dev, "Allocated idxd-msix %d for vector %d\n",
-			i, msix->vector);
+		dev_dbg(dev, "Allocated idxd-msix %d for vector %d\n", i, irq_entry->vector);
 	}
 
 	idxd_unmask_error_interrupts(idxd);
 	idxd_msix_perm_setup(idxd);
 	return 0;
 
- err_no_irq:
+ err_wq_irqs:
+	while (--i >= 0) {
+		irq_entry = &idxd->irq_entries[i];
+		free_irq(irq_entry->vector, irq_entry);
+	}
+ err_misc_irq:
 	/* Disable error interrupt generation */
 	idxd_mask_error_interrupts(idxd);
-	pci_disable_msix(pdev);
+ err_irq_entries:
+	pci_free_irq_vectors(pdev);
 	dev_err(dev, "No usable interrupts\n");
 	return rc;
 }
@@ -495,7 +483,8 @@ static void idxd_shutdown(struct pci_dev *pdev)
 
 	for (i = 0; i < msixcnt; i++) {
 		irq_entry = &idxd->irq_entries[i];
-		synchronize_irq(idxd->msix_entries[i].vector);
+		synchronize_irq(irq_entry->vector);
+		free_irq(irq_entry->vector, irq_entry);
 		if (i == 0)
 			continue;
 		idxd_flush_pending_llist(irq_entry);
@@ -503,6 +492,7 @@ static void idxd_shutdown(struct pci_dev *pdev)
 	}
 
 	idxd_msix_perm_clear(idxd);
+	pci_free_irq_vectors(pdev);
 	destroy_workqueue(idxd->wq);
 }
 
-- 
2.30.2



