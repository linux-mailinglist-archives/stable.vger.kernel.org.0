Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F040C3D2800
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 18:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231992AbhGVPyR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 11:54:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:57092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231510AbhGVPyE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:54:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0043A6136D;
        Thu, 22 Jul 2021 16:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626971678;
        bh=uZFE7/eVO8vGPnPWOUFbONzJHAKGm2H3A0fVe65kaGU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MJdUpjhEpORsnkgtlX0H88CTnlt3jvkgt6OFq1Xuq8Dw8fZZgJgWCecHKk5DFaGBI
         HkbHsLU86m0v6xagFJZZ4DH7/ZWx8wfcxw3iim5NrzT5UKjlSvGy17xzxQoULs6A+h
         vJJo7Io0gt+KZ0Nx1AhOF7VlUHZoHujOv2ZO36CA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wu Bo <wubo40@huawei.com>,
        John Garry <john.garry@huawei.com>,
        Jason Yan <yanaijie@huawei.com>, Yufen Yu <yuyufen@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 39/71] scsi: libsas: Add LUN number check in .slave_alloc callback
Date:   Thu, 22 Jul 2021 18:31:14 +0200
Message-Id: <20210722155619.163941708@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155617.865866034@linuxfoundation.org>
References: <20210722155617.865866034@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yufen Yu <yuyufen@huawei.com>

[ Upstream commit 49da96d77938db21864dae6b7736b71e96c1d203 ]

Offlining a SATA device connected to a hisi SAS controller and then
scanning the host will result in detecting 255 non-existent devices:

  # lsscsi
  [2:0:0:0]    disk    ATA      Samsung SSD 860  2B6Q  /dev/sda
  [2:0:1:0]    disk    ATA      WDC WD2003FYYS-3 1D01  /dev/sdb
  [2:0:2:0]    disk    SEAGATE  ST600MM0006      B001  /dev/sdc
  # echo "offline" > /sys/block/sdb/device/state
  # echo "- - -" > /sys/class/scsi_host/host2/scan
  # lsscsi
  [2:0:0:0]    disk    ATA      Samsung SSD 860  2B6Q  /dev/sda
  [2:0:1:0]    disk    ATA      WDC WD2003FYYS-3 1D01  /dev/sdb
  [2:0:1:1]    disk    ATA      WDC WD2003FYYS-3 1D01  /dev/sdh
  ...
  [2:0:1:255]  disk    ATA      WDC WD2003FYYS-3 1D01  /dev/sdjb

After a REPORT LUN command issued to the offline device fails, the SCSI
midlayer tries to do a sequential scan of all devices whose LUN number is
not 0. However, SATA does not support LUN numbers at all.

Introduce a generic sas_slave_alloc() handler which will return -ENXIO for
SATA devices if the requested LUN number is larger than 0 and make libsas
drivers use this function as their .slave_alloc callback.

Link: https://lore.kernel.org/r/20210622034037.1467088-1-yuyufen@huawei.com
Reported-by: Wu Bo <wubo40@huawei.com>
Suggested-by: John Garry <john.garry@huawei.com>
Reviewed-by: John Garry <john.garry@huawei.com>
Reviewed-by: Jason Yan <yanaijie@huawei.com>
Signed-off-by: Yufen Yu <yuyufen@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/aic94xx/aic94xx_init.c    | 1 +
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 1 +
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 1 +
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 1 +
 drivers/scsi/isci/init.c               | 1 +
 drivers/scsi/libsas/sas_scsi_host.c    | 9 +++++++++
 drivers/scsi/mvsas/mv_init.c           | 1 +
 drivers/scsi/pm8001/pm8001_init.c      | 1 +
 8 files changed, 16 insertions(+)

diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
index f5781e31f57c..b68dfeb952ee 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -52,6 +52,7 @@ static struct scsi_host_template aic94xx_sht = {
 	.max_sectors		= SCSI_DEFAULT_MAX_SECTORS,
 	.eh_device_reset_handler	= sas_eh_device_reset_handler,
 	.eh_target_reset_handler	= sas_eh_target_reset_handler,
+	.slave_alloc		= sas_slave_alloc,
 	.target_destroy		= sas_target_destroy,
 	.ioctl			= sas_ioctl,
 	.track_queue_depth	= 1,
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index 9f6534bd354b..1443c803d8f7 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -1768,6 +1768,7 @@ static struct scsi_host_template sht_v1_hw = {
 	.max_sectors		= SCSI_DEFAULT_MAX_SECTORS,
 	.eh_device_reset_handler = sas_eh_device_reset_handler,
 	.eh_target_reset_handler = sas_eh_target_reset_handler,
+	.slave_alloc		= sas_slave_alloc,
 	.target_destroy		= sas_target_destroy,
 	.ioctl			= sas_ioctl,
 	.shost_attrs		= host_attrs_v1_hw,
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 8e96a257e439..11c75881bd89 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -3542,6 +3542,7 @@ static struct scsi_host_template sht_v2_hw = {
 	.max_sectors		= SCSI_DEFAULT_MAX_SECTORS,
 	.eh_device_reset_handler = sas_eh_device_reset_handler,
 	.eh_target_reset_handler = sas_eh_target_reset_handler,
+	.slave_alloc		= sas_slave_alloc,
 	.target_destroy		= sas_target_destroy,
 	.ioctl			= sas_ioctl,
 	.shost_attrs		= host_attrs_v2_hw,
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 916447f3c607..13f314fa757e 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -3064,6 +3064,7 @@ static struct scsi_host_template sht_v3_hw = {
 	.max_sectors		= SCSI_DEFAULT_MAX_SECTORS,
 	.eh_device_reset_handler = sas_eh_device_reset_handler,
 	.eh_target_reset_handler = sas_eh_target_reset_handler,
+	.slave_alloc		= sas_slave_alloc,
 	.target_destroy		= sas_target_destroy,
 	.ioctl			= sas_ioctl,
 	.shost_attrs		= host_attrs_v3_hw,
diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index 1727d0c71b12..c33bcf85fb21 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -166,6 +166,7 @@ static struct scsi_host_template isci_sht = {
 	.eh_abort_handler		= sas_eh_abort_handler,
 	.eh_device_reset_handler        = sas_eh_device_reset_handler,
 	.eh_target_reset_handler        = sas_eh_target_reset_handler,
+	.slave_alloc			= sas_slave_alloc,
 	.target_destroy			= sas_target_destroy,
 	.ioctl				= sas_ioctl,
 	.shost_attrs			= isci_host_attrs,
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index bec83eb8ab87..081f3145fe14 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -911,6 +911,14 @@ void sas_task_abort(struct sas_task *task)
 		blk_abort_request(sc->request);
 }
 
+int sas_slave_alloc(struct scsi_device *sdev)
+{
+	if (dev_is_sata(sdev_to_domain_dev(sdev)) && sdev->lun)
+		return -ENXIO;
+
+	return 0;
+}
+
 void sas_target_destroy(struct scsi_target *starget)
 {
 	struct domain_device *found_dev = starget->hostdata;
@@ -957,5 +965,6 @@ EXPORT_SYMBOL_GPL(sas_task_abort);
 EXPORT_SYMBOL_GPL(sas_phy_reset);
 EXPORT_SYMBOL_GPL(sas_eh_device_reset_handler);
 EXPORT_SYMBOL_GPL(sas_eh_target_reset_handler);
+EXPORT_SYMBOL_GPL(sas_slave_alloc);
 EXPORT_SYMBOL_GPL(sas_target_destroy);
 EXPORT_SYMBOL_GPL(sas_ioctl);
diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index da719b0694dc..52405ce58ade 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -45,6 +45,7 @@ static struct scsi_host_template mvs_sht = {
 	.max_sectors		= SCSI_DEFAULT_MAX_SECTORS,
 	.eh_device_reset_handler = sas_eh_device_reset_handler,
 	.eh_target_reset_handler = sas_eh_target_reset_handler,
+	.slave_alloc		= sas_slave_alloc,
 	.target_destroy		= sas_target_destroy,
 	.ioctl			= sas_ioctl,
 	.shost_attrs		= mvst_host_attrs,
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 8882ba33ca87..1f41537d52a5 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -86,6 +86,7 @@ static struct scsi_host_template pm8001_sht = {
 	.max_sectors		= SCSI_DEFAULT_MAX_SECTORS,
 	.eh_device_reset_handler = sas_eh_device_reset_handler,
 	.eh_target_reset_handler = sas_eh_target_reset_handler,
+	.slave_alloc		= sas_slave_alloc,
 	.target_destroy		= sas_target_destroy,
 	.ioctl			= sas_ioctl,
 	.shost_attrs		= pm8001_host_attrs,
-- 
2.30.2



