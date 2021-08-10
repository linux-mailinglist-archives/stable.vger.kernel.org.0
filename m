Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 597543E80AC
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233218AbhHJRvV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:51:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:60058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237114AbhHJRuE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:50:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D68F961246;
        Tue, 10 Aug 2021 17:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617333;
        bh=XPIPr8HMYWDQSJ38I9bk1STF7YY6ywUD2T1o7vn+VuI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yFfNbCTWL+GBd0W/SmFvK3PJJTuE3SedqGJa/iHFqasNWtlUjEUYgCsq3Fy4aj2F9
         8sPHP7ZXX2+BRFA09klvz4ixmqa3mVgOOmxrOoJkXQ3KDMAi30As2tUuKO0ooQGkWz
         zKy7wa9zK6hczr2TJCIqvTMa4DFxtC/uRhe8jmKk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 013/175] dmaengine: idxd: fix sequence for pci driver remove() and shutdown()
Date:   Tue, 10 Aug 2021 19:28:41 +0200
Message-Id: <20210810173001.383847801@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 7eb25da161befbc9a80e94e1bd90d6c06aa645cf ]

->shutdown() call should only be responsible for quiescing the device.
Currently it is doing PCI device tear down. This causes issue when things
like MMIO mapping is removed while idxd_unregister_devices() will trigger
removal of idxd device sub-driver and still initiates MMIO writes to the
device. Another issue is with the unregistering of idxd 'struct device',
the memory context gets freed. So the teardown calls are accessing freed
memory and can cause kernel oops. Move all the teardown bits that doesn't
belong in shutdown to ->remove() call. Move unregistering of the idxd
conf_dev 'struct device' to after doing all the teardown to free all
the memory that's no longer needed.

Fixes: 47c16ac27d4c ("dmaengine: idxd: fix idxd conf_dev 'struct device' lifetime")
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/162629983901.395844.17964803190905549615.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/init.c  | 26 +++++++++++++++++---------
 drivers/dma/idxd/sysfs.c |  2 --
 2 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/dma/idxd/init.c b/drivers/dma/idxd/init.c
index 4bc80eb6b9e7..32cca6a0e66a 100644
--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -759,32 +759,40 @@ static void idxd_shutdown(struct pci_dev *pdev)
 	for (i = 0; i < msixcnt; i++) {
 		irq_entry = &idxd->irq_entries[i];
 		synchronize_irq(irq_entry->vector);
-		free_irq(irq_entry->vector, irq_entry);
 		if (i == 0)
 			continue;
 		idxd_flush_pending_llist(irq_entry);
 		idxd_flush_work_list(irq_entry);
 	}
-
-	idxd_msix_perm_clear(idxd);
-	idxd_release_int_handles(idxd);
-	pci_free_irq_vectors(pdev);
-	pci_iounmap(pdev, idxd->reg_base);
-	pci_disable_device(pdev);
-	destroy_workqueue(idxd->wq);
+	flush_workqueue(idxd->wq);
 }
 
 static void idxd_remove(struct pci_dev *pdev)
 {
 	struct idxd_device *idxd = pci_get_drvdata(pdev);
+	struct idxd_irq_entry *irq_entry;
+	int msixcnt = pci_msix_vec_count(pdev);
+	int i;
 
 	dev_dbg(&pdev->dev, "%s called\n", __func__);
 	idxd_shutdown(pdev);
 	if (device_pasid_enabled(idxd))
 		idxd_disable_system_pasid(idxd);
 	idxd_unregister_devices(idxd);
-	perfmon_pmu_remove(idxd);
+
+	for (i = 0; i < msixcnt; i++) {
+		irq_entry = &idxd->irq_entries[i];
+		free_irq(irq_entry->vector, irq_entry);
+	}
+	idxd_msix_perm_clear(idxd);
+	idxd_release_int_handles(idxd);
+	pci_free_irq_vectors(pdev);
+	pci_iounmap(pdev, idxd->reg_base);
 	iommu_dev_disable_feature(&pdev->dev, IOMMU_DEV_FEAT_SVA);
+	pci_disable_device(pdev);
+	destroy_workqueue(idxd->wq);
+	perfmon_pmu_remove(idxd);
+	device_unregister(&idxd->conf_dev);
 }
 
 static struct pci_driver idxd_pci_driver = {
diff --git a/drivers/dma/idxd/sysfs.c b/drivers/dma/idxd/sysfs.c
index 0460d58e3941..bb4df63906a7 100644
--- a/drivers/dma/idxd/sysfs.c
+++ b/drivers/dma/idxd/sysfs.c
@@ -1744,8 +1744,6 @@ void idxd_unregister_devices(struct idxd_device *idxd)
 
 		device_unregister(&group->conf_dev);
 	}
-
-	device_unregister(&idxd->conf_dev);
 }
 
 int idxd_register_bus_type(void)
-- 
2.30.2



