Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E70D4541C5F
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349969AbiFGV7I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:59:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383130AbiFGVwT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:52:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0064D2428D2;
        Tue,  7 Jun 2022 12:10:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D431617DA;
        Tue,  7 Jun 2022 19:10:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BE74C385A5;
        Tue,  7 Jun 2022 19:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629033;
        bh=sbeesrX8k2qss3TrN1ELNXYZUKhfSZzbV0X6jfu5Hrk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=elvsiia+UVhsbSTWLVTgvHniBNin2R8691u6L4oz/9bB8MY6Gt9YrCOEWsdFr7fMF
         yUO80QB0OIcCeDtbld9HSjATIRgx26Fi2uPsRwHEMf9FXVunEY89HQwg9eZQcG3NQh
         m78tz3c7F9sc7+4OWfaKQh8JpLA9qutEDQYA3MXA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yihang Li <liyihang6@hisilicon.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        John Garry <john.garry@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 504/879] scsi: hisi_sas: Fix rescan after deleting a disk
Date:   Tue,  7 Jun 2022 19:00:22 +0200
Message-Id: <20220607165017.504815896@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Garry <john.garry@huawei.com>

[ Upstream commit e9dedc13bb11bc553754abecb322e5e41d1b4fef ]

Removing an ATA device via sysfs means that the device may not be found
through re-scanning:

root@ubuntu:/home/john# lsscsi
[0:0:0:0] disk SanDisk LT0200MO P404 /dev/sda
[0:0:1:0] disk ATA HGST HUS724040AL A8B0 /dev/sdb
[0:0:8:0] enclosu 12G SAS Expander RevB -
root@ubuntu:/home/john# echo 1 > /sys/block/sdb/device/delete
root@ubuntu:/home/john# echo "- - -" > /sys/class/scsi_host/host0/scan
root@ubuntu:/home/john# lsscsi
[0:0:0:0] disk SanDisk LT0200MO P404 /dev/sda
[0:0:8:0] enclosu 12G SAS Expander RevB -
root@ubuntu:/home/john#

The problem is that the rescan of the device may conflict with the device
in being re-initialized, as follows:

 - In the rescan we call hisi_sas_slave_alloc() in store_scan() ->
   sas_user_scan() -> [__]scsi_scan_target() -> scsi_probe_and_add_lunc()
   -> scsi_alloc_sdev() -> hisi_sas_slave_alloc() -> hisi_sas_init_device()
   In hisi_sas_init_device() we issue an IT nexus reset for ATA devices

 - That IT nexus causes the remote PHY to go down and this triggers a bcast
   event

 - In parallel libsas processes the bcast event, finds that the phy is down
   and marks the device as gone

The hard reset issued in hisi_sas_init_device() is unncessary - as
described in the code comment - so remove it. Also set dev status as
HISI_SAS_DEV_NORMAL as the hisi_sas_init_device() call.

Link: https://lore.kernel.org/r/1652354134-171343-4-git-send-email-john.garry@huawei.com
Fixes: 36c6b7613ef1 ("scsi: hisi_sas: Initialise devices in .slave_alloc callback")
Tested-by: Yihang Li <liyihang6@hisilicon.com>
Reviewed-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 47 ++++++++++-----------------
 1 file changed, 18 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 4bda2f6cb352..86cbfab78dfe 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -709,8 +709,6 @@ static int hisi_sas_init_device(struct domain_device *device)
 	struct scsi_lun lun;
 	int retry = HISI_SAS_DISK_RECOVER_CNT;
 	struct hisi_hba *hisi_hba = dev_to_hisi_hba(device);
-	struct device *dev = hisi_hba->dev;
-	struct sas_phy *local_phy;
 
 	switch (device->dev_type) {
 	case SAS_END_DEVICE:
@@ -729,30 +727,18 @@ static int hisi_sas_init_device(struct domain_device *device)
 	case SAS_SATA_PM_PORT:
 	case SAS_SATA_PENDING:
 		/*
-		 * send HARD RESET to clear previous affiliation of
-		 * STP target port
+		 * If an expander is swapped when a SATA disk is attached then
+		 * we should issue a hard reset to clear previous affiliation
+		 * of STP target port, see SPL (chapter 6.19.4).
+		 *
+		 * However we don't need to issue a hard reset here for these
+		 * reasons:
+		 * a. When probing the device, libsas/libata already issues a
+		 * hard reset in sas_probe_sata() -> ata_sas_async_probe().
+		 * Note that in hisi_sas_debug_I_T_nexus_reset() we take care
+		 * to issue a hard reset by checking the dev status (== INIT).
+		 * b. When resetting the controller, this is simply unnecessary.
 		 */
-		local_phy = sas_get_local_phy(device);
-		if (!scsi_is_sas_phy_local(local_phy) &&
-		    !test_bit(HISI_SAS_RESETTING_BIT, &hisi_hba->flags)) {
-			unsigned long deadline = ata_deadline(jiffies, 20000);
-			struct sata_device *sata_dev = &device->sata_dev;
-			struct ata_host *ata_host = sata_dev->ata_host;
-			struct ata_port_operations *ops = ata_host->ops;
-			struct ata_port *ap = sata_dev->ap;
-			struct ata_link *link;
-			unsigned int classes;
-
-			ata_for_each_link(link, ap, EDGE)
-				rc = ops->hardreset(link, &classes,
-						    deadline);
-		}
-		sas_put_local_phy(local_phy);
-		if (rc) {
-			dev_warn(dev, "SATA disk hardreset fail: %d\n", rc);
-			return rc;
-		}
-
 		while (retry-- > 0) {
 			rc = hisi_sas_softreset_ata_disk(device);
 			if (!rc)
@@ -768,15 +754,19 @@ static int hisi_sas_init_device(struct domain_device *device)
 
 int hisi_sas_slave_alloc(struct scsi_device *sdev)
 {
-	struct domain_device *ddev;
+	struct domain_device *ddev = sdev_to_domain_dev(sdev);
+	struct hisi_sas_device *sas_dev = ddev->lldd_dev;
 	int rc;
 
 	rc = sas_slave_alloc(sdev);
 	if (rc)
 		return rc;
-	ddev = sdev_to_domain_dev(sdev);
 
-	return hisi_sas_init_device(ddev);
+	rc = hisi_sas_init_device(ddev);
+	if (rc)
+		return rc;
+	sas_dev->dev_status = HISI_SAS_DEV_NORMAL;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(hisi_sas_slave_alloc);
 
@@ -826,7 +816,6 @@ static int hisi_sas_dev_found(struct domain_device *device)
 	dev_info(dev, "dev[%d:%x] found\n",
 		sas_dev->device_id, sas_dev->dev_type);
 
-	sas_dev->dev_status = HISI_SAS_DEV_NORMAL;
 	return 0;
 
 err_out:
-- 
2.35.1



