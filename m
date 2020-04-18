Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE8E1AEF55
	for <lists+stable@lfdr.de>; Sat, 18 Apr 2020 16:44:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728290AbgDROmY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Apr 2020 10:42:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:52390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728320AbgDROmX (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 18 Apr 2020 10:42:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67CE8221F4;
        Sat, 18 Apr 2020 14:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587220942;
        bh=yQ6aID271zdK9xX3B67e6G0sAZgVThLB4LeaZjRwPu8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IvN/eqq0QmxA5Z7GJnX4tc31KSnzAvxWYjaOHEOKRs2X+cRCpahkPcoOuBewsC/Bj
         sC991lwqmC2HoOtBWssrQwXNoBC76HxiSNBhKj4onV0gvgPa2fSBFeE+MW39h7ilYq
         WltBs56h5wM9l+M3vQkZ51RZeRl/FovuqerFp2VQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kevin Barnett <kevin.barnett@microsemi.com>,
        Scott Benesh <scott.benesh@microsemi.com>,
        Scott Teel <scott.teel@microsemi.com>,
        Don Brace <don.brace@microsemi.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, esc.storagedev@microsemi.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 76/78] scsi: smartpqi: fix problem with unique ID for physical device
Date:   Sat, 18 Apr 2020 10:40:45 -0400
Message-Id: <20200418144047.9013-76-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200418144047.9013-1-sashal@kernel.org>
References: <20200418144047.9013-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microsemi.com>

[ Upstream commit 5b083b305b49f65269b888885455b8c0cf1a52e4 ]

Obtain the unique IDs from the RLL and RPL instead of VPD page 83h.

Link: https://lore.kernel.org/r/157048751833.11757.11996314786914610803.stgit@brunhilda
Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/smartpqi/smartpqi.h      |  1 -
 drivers/scsi/smartpqi/smartpqi_init.c | 99 ++++-----------------------
 2 files changed, 12 insertions(+), 88 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index 2aa81b22f2695..7a3a942b40df0 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -907,7 +907,6 @@ struct pqi_scsi_dev {
 	u8	scsi3addr[8];
 	__be64	wwid;
 	u8	volume_id[16];
-	u8	unique_id[16];
 	u8	is_physical_device : 1;
 	u8	is_external_raid_device : 1;
 	u8	is_expander_smp_device : 1;
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 793793343950e..5ae074505386a 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -648,79 +648,6 @@ static inline int pqi_scsi_inquiry(struct pqi_ctrl_info *ctrl_info,
 		buffer, buffer_length, vpd_page, NULL, NO_TIMEOUT);
 }
 
-static bool pqi_vpd_page_supported(struct pqi_ctrl_info *ctrl_info,
-	u8 *scsi3addr, u16 vpd_page)
-{
-	int rc;
-	int i;
-	int pages;
-	unsigned char *buf, bufsize;
-
-	buf = kzalloc(256, GFP_KERNEL);
-	if (!buf)
-		return false;
-
-	/* Get the size of the page list first */
-	rc = pqi_scsi_inquiry(ctrl_info, scsi3addr,
-				VPD_PAGE | SCSI_VPD_SUPPORTED_PAGES,
-				buf, SCSI_VPD_HEADER_SZ);
-	if (rc != 0)
-		goto exit_unsupported;
-
-	pages = buf[3];
-	if ((pages + SCSI_VPD_HEADER_SZ) <= 255)
-		bufsize = pages + SCSI_VPD_HEADER_SZ;
-	else
-		bufsize = 255;
-
-	/* Get the whole VPD page list */
-	rc = pqi_scsi_inquiry(ctrl_info, scsi3addr,
-				VPD_PAGE | SCSI_VPD_SUPPORTED_PAGES,
-				buf, bufsize);
-	if (rc != 0)
-		goto exit_unsupported;
-
-	pages = buf[3];
-	for (i = 1; i <= pages; i++)
-		if (buf[3 + i] == vpd_page)
-			goto exit_supported;
-
-exit_unsupported:
-	kfree(buf);
-	return false;
-
-exit_supported:
-	kfree(buf);
-	return true;
-}
-
-static int pqi_get_device_id(struct pqi_ctrl_info *ctrl_info,
-	u8 *scsi3addr, u8 *device_id, int buflen)
-{
-	int rc;
-	unsigned char *buf;
-
-	if (!pqi_vpd_page_supported(ctrl_info, scsi3addr, SCSI_VPD_DEVICE_ID))
-		return 1; /* function not supported */
-
-	buf = kzalloc(64, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
-
-	rc = pqi_scsi_inquiry(ctrl_info, scsi3addr,
-				VPD_PAGE | SCSI_VPD_DEVICE_ID,
-				buf, 64);
-	if (rc == 0) {
-		if (buflen > 16)
-			buflen = 16;
-		memcpy(device_id, &buf[SCSI_VPD_DEVICE_ID_IDX], buflen);
-	}
-
-	kfree(buf);
-
-	return rc;
-}
-
 static int pqi_identify_physical_device(struct pqi_ctrl_info *ctrl_info,
 	struct pqi_scsi_dev *device,
 	struct bmic_identify_physical_device *buffer,
@@ -1405,14 +1332,6 @@ static int pqi_get_device_info(struct pqi_ctrl_info *ctrl_info,
 		}
 	}
 
-	if (pqi_get_device_id(ctrl_info, device->scsi3addr,
-		device->unique_id, sizeof(device->unique_id)) < 0)
-		dev_warn(&ctrl_info->pci_dev->dev,
-			"Can't get device id for scsi %d:%d:%d:%d\n",
-			ctrl_info->scsi_host->host_no,
-			device->bus, device->target,
-			device->lun);
-
 out:
 	kfree(buffer);
 
@@ -6319,7 +6238,7 @@ static ssize_t pqi_unique_id_show(struct device *dev,
 	struct scsi_device *sdev;
 	struct pqi_scsi_dev *device;
 	unsigned long flags;
-	unsigned char uid[16];
+	u8 unique_id[16];
 
 	sdev = to_scsi_device(dev);
 	ctrl_info = shost_to_hba(sdev->host);
@@ -6332,16 +6251,22 @@ static ssize_t pqi_unique_id_show(struct device *dev,
 			flags);
 		return -ENODEV;
 	}
-	memcpy(uid, device->unique_id, sizeof(uid));
+
+	if (device->is_physical_device) {
+		memset(unique_id, 0, 8);
+		memcpy(unique_id + 8, &device->wwid, sizeof(device->wwid));
+	} else {
+		memcpy(unique_id, device->volume_id, sizeof(device->volume_id));
+	}
 
 	spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
 
 	return snprintf(buffer, PAGE_SIZE,
 		"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X\n",
-		uid[0], uid[1], uid[2], uid[3],
-		uid[4], uid[5], uid[6], uid[7],
-		uid[8], uid[9], uid[10], uid[11],
-		uid[12], uid[13], uid[14], uid[15]);
+		unique_id[0], unique_id[1], unique_id[2], unique_id[3],
+		unique_id[4], unique_id[5], unique_id[6], unique_id[7],
+		unique_id[8], unique_id[9], unique_id[10], unique_id[11],
+		unique_id[12], unique_id[13], unique_id[14], unique_id[15]);
 }
 
 static ssize_t pqi_lunid_show(struct device *dev,
-- 
2.20.1

