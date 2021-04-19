Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 311D5364263
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237772AbhDSNIY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:08:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:43060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238724AbhDSNIX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:08:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E525561279;
        Mon, 19 Apr 2021 13:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618837673;
        bh=XLnnCY8YIp2ACfXcFqpnxbiLw4rhWnfdYrkt+K/tEM0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VlrkB+nzu8c/icak0Kkk/nDad3eUq8GZirXaBL6gcdqao6B5kzpfAz0HXJVY9ymGN
         Zd+5+/PGMMe4dfScXZ7h2iQD5ZpPwPQ6U6LC/yiXH4xGuaS5lYOvAoy7d/LWDaztw3
         eTFWI2foSNlXwrCabBMMs2Q9SEZ+Bd+A9C/MxBKo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 014/122] dmaengine: idxd: clear MSIX permission entry on shutdown
Date:   Mon, 19 Apr 2021 15:04:54 +0200
Message-Id: <20210419130530.651252575@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130530.166331793@linuxfoundation.org>
References: <20210419130530.166331793@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 6df0e6c57dfc064af330071f372f11aa8c584997 ]

Add disabling/clearing of MSIX permission entries on device shutdown to
mirror the enabling of the MSIX entries on probe. Current code left the
MSIX enabled and the pasid entries still programmed at device shutdown.

Fixes: 8e50d392652f ("dmaengine: idxd: Add shared workqueue support")
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/161824457969.882533.6020239898682672311.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/device.c | 30 ++++++++++++++++++++++++++++++
 drivers/dma/idxd/idxd.h   |  2 ++
 drivers/dma/idxd/init.c   | 11 ++---------
 3 files changed, 34 insertions(+), 9 deletions(-)

diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index 84a6ea60ecf0..c09687013d29 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -574,6 +574,36 @@ void idxd_device_drain_pasid(struct idxd_device *idxd, int pasid)
 }
 
 /* Device configuration bits */
+void idxd_msix_perm_setup(struct idxd_device *idxd)
+{
+	union msix_perm mperm;
+	int i, msixcnt;
+
+	msixcnt = pci_msix_vec_count(idxd->pdev);
+	if (msixcnt < 0)
+		return;
+
+	mperm.bits = 0;
+	mperm.pasid = idxd->pasid;
+	mperm.pasid_en = device_pasid_enabled(idxd);
+	for (i = 1; i < msixcnt; i++)
+		iowrite32(mperm.bits, idxd->reg_base + idxd->msix_perm_offset + i * 8);
+}
+
+void idxd_msix_perm_clear(struct idxd_device *idxd)
+{
+	union msix_perm mperm;
+	int i, msixcnt;
+
+	msixcnt = pci_msix_vec_count(idxd->pdev);
+	if (msixcnt < 0)
+		return;
+
+	mperm.bits = 0;
+	for (i = 1; i < msixcnt; i++)
+		iowrite32(mperm.bits, idxd->reg_base + idxd->msix_perm_offset + i * 8);
+}
+
 static void idxd_group_config_write(struct idxd_group *group)
 {
 	struct idxd_device *idxd = group->idxd;
diff --git a/drivers/dma/idxd/idxd.h b/drivers/dma/idxd/idxd.h
index 81a0e65fd316..eda2ee10501f 100644
--- a/drivers/dma/idxd/idxd.h
+++ b/drivers/dma/idxd/idxd.h
@@ -316,6 +316,8 @@ void idxd_unregister_driver(void);
 struct bus_type *idxd_get_bus_type(struct idxd_device *idxd);
 
 /* device interrupt control */
+void idxd_msix_perm_setup(struct idxd_device *idxd);
+void idxd_msix_perm_clear(struct idxd_device *idxd);
 irqreturn_t idxd_irq_handler(int vec, void *data);
 irqreturn_t idxd_misc_thread(int vec, void *data);
 irqreturn_t idxd_wq_thread(int irq, void *data);
diff --git a/drivers/dma/idxd/init.c b/drivers/dma/idxd/init.c
index fa04acd5582a..8f3df64aa1be 100644
--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -61,7 +61,6 @@ static int idxd_setup_interrupts(struct idxd_device *idxd)
 	struct idxd_irq_entry *irq_entry;
 	int i, msixcnt;
 	int rc = 0;
-	union msix_perm mperm;
 
 	msixcnt = pci_msix_vec_count(pdev);
 	if (msixcnt < 0) {
@@ -140,14 +139,7 @@ static int idxd_setup_interrupts(struct idxd_device *idxd)
 	}
 
 	idxd_unmask_error_interrupts(idxd);
-
-	/* Setup MSIX permission table */
-	mperm.bits = 0;
-	mperm.pasid = idxd->pasid;
-	mperm.pasid_en = device_pasid_enabled(idxd);
-	for (i = 1; i < msixcnt; i++)
-		iowrite32(mperm.bits, idxd->reg_base + idxd->msix_perm_offset + i * 8);
-
+	idxd_msix_perm_setup(idxd);
 	return 0;
 
  err_no_irq:
@@ -504,6 +496,7 @@ static void idxd_shutdown(struct pci_dev *pdev)
 		idxd_flush_work_list(irq_entry);
 	}
 
+	idxd_msix_perm_clear(idxd);
 	destroy_workqueue(idxd->wq);
 }
 
-- 
2.30.2



