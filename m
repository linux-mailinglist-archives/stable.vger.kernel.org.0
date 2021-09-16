Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40B8840E5E0
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344221AbhIPRQJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:16:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:39918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346591AbhIPROE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:14:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B184619F5;
        Thu, 16 Sep 2021 16:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810357;
        bh=m7vPCBLMMITncC2/5ZkL+sgquqHOAF5Ra2HHlUs/WF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=weJ0q1IkwEPWXEj5sFSNYrdPQj1fFYtG0FnjxYqjwx2xHb++E/1JGa70HXbFCAf+F
         9pJxE+10hyBvEo9woqtHj5MhlsA4ZrkHc2Fj28MTN4ad90f/2ANapVnURvesnyz09M
         9tfuuo6WKeRGIBvvErSH0KnPIxtZ/cdPDb4kIFkI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Rafael J. Wysocki" <rafael@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 111/432] scsi: ufshcd: Fix device links when BOOT WLUN fails to probe
Date:   Thu, 16 Sep 2021 17:57:40 +0200
Message-Id: <20210916155814.536279187@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit bf25967ac54129ffb676ee0dbe3b8b34af6c6232 ]

Managed device links are deleted by device_del(). However it is possible to
add a device link to a consumer before device_add(), and then discovering
an error prevents the device from being used. In that case normally
references to the device would be dropped and the device would be deleted.
However the device link holds a reference to the device, so the device link
and device remain indefinitely (unless the supplier is deleted).

For UFSHCD, if a LUN fails to probe (e.g. absent BOOT WLUN), the device
will not have been registered but can still have a device link holding a
reference to the device. The unwanted device link will prevent runtime
suspend indefinitely.

Amend device link removal to accept removal of a link with an unregistered
consumer device (suggested by Rafael), and fix UFSHCD by explicitly
deleting the device link when SCSI destroys the SCSI device.

Link: https://lore.kernel.org/r/a1c9bac8-b560-b662-f0aa-58c7e000cbbd@intel.com
Fixes: b294ff3e3449 ("scsi: ufs: core: Enable power management for wlun")
Reviewed-by: Rafael J. Wysocki <rafael@kernel.org>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/core.c       |  2 ++
 drivers/scsi/ufs/ufshcd.c | 23 +++++++++++++++++++++--
 2 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 6c0ef9d55a34..8c77e14987d4 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -886,6 +886,8 @@ static void device_link_put_kref(struct device_link *link)
 {
 	if (link->flags & DL_FLAG_STATELESS)
 		kref_put(&link->kref, __device_link_del);
+	else if (!device_is_registered(link->consumer))
+		__device_link_del(&link->kref);
 	else
 		WARN(1, "Unable to drop a managed device link reference\n");
 }
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 8275127749d2..15ac5fa14805 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5006,15 +5006,34 @@ static int ufshcd_slave_configure(struct scsi_device *sdev)
 static void ufshcd_slave_destroy(struct scsi_device *sdev)
 {
 	struct ufs_hba *hba;
+	unsigned long flags;
 
 	hba = shost_priv(sdev->host);
 	/* Drop the reference as it won't be needed anymore */
 	if (ufshcd_scsi_to_upiu_lun(sdev->lun) == UFS_UPIU_UFS_DEVICE_WLUN) {
-		unsigned long flags;
-
 		spin_lock_irqsave(hba->host->host_lock, flags);
 		hba->sdev_ufs_device = NULL;
 		spin_unlock_irqrestore(hba->host->host_lock, flags);
+	} else if (hba->sdev_ufs_device) {
+		struct device *supplier = NULL;
+
+		/* Ensure UFS Device WLUN exists and does not disappear */
+		spin_lock_irqsave(hba->host->host_lock, flags);
+		if (hba->sdev_ufs_device) {
+			supplier = &hba->sdev_ufs_device->sdev_gendev;
+			get_device(supplier);
+		}
+		spin_unlock_irqrestore(hba->host->host_lock, flags);
+
+		if (supplier) {
+			/*
+			 * If a LUN fails to probe (e.g. absent BOOT WLUN), the
+			 * device will not have been registered but can still
+			 * have a device link holding a reference to the device.
+			 */
+			device_link_remove(&sdev->sdev_gendev, supplier);
+			put_device(supplier);
+		}
 	}
 }
 
-- 
2.30.2



