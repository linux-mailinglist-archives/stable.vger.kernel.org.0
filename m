Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09AC33D29D6
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235072AbhGVQGc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:06:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:43580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234023AbhGVQFq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:05:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C78361D25;
        Thu, 22 Jul 2021 16:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972381;
        bh=ClKqhxh63/KL5dvy9Ju188rB/9pOpU1JyXHhdXapmKw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0S9otOejZORxhNMD+K0y39XnLsl/t/0285Cq+YR//vCge2VBphZUQCrdCiveJkEvU
         xv+QDpOwe5BBpBePj2gIHrvaMPgq/xnMyNJkqysc9sPdR2j2kM7MZ9mMw/lDqP0f/9
         0Hk2bSIEMS1zAM2nOqEhbb+BllSNU+0+EZMXCWZo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wu Bo <wubo40@huawei.com>,
        John Garry <john.garry@huawei.com>,
        Jason Yan <yanaijie@huawei.com>, Yufen Yu <yuyufen@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 092/156] scsi: libsas: Add LUN number check in .slave_alloc callback
Date:   Thu, 22 Jul 2021 18:31:07 +0200
Message-Id: <20210722155631.352812745@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155628.371356843@linuxfoundation.org>
References: <20210722155628.371356843@linuxfoundation.org>
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
index a195bfe9eccc..7a78606598c4 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -53,6 +53,7 @@ static struct scsi_host_template aic94xx_sht = {
 	.max_sectors		= SCSI_DEFAULT_MAX_SECTORS,
 	.eh_device_reset_handler	= sas_eh_device_reset_handler,
 	.eh_target_reset_handler	= sas_eh_target_reset_handler,
+	.slave_alloc		= sas_slave_alloc,
 	.target_destroy		= sas_target_destroy,
 	.ioctl			= sas_ioctl,
 #ifdef CONFIG_COMPAT
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index 3cba7bfba296..30199663c7d8 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -1771,6 +1771,7 @@ static struct scsi_host_template sht_v1_hw = {
 	.max_sectors		= SCSI_DEFAULT_MAX_SECTORS,
 	.eh_device_reset_handler = sas_eh_device_reset_handler,
 	.eh_target_reset_handler = sas_eh_target_reset_handler,
+	.slave_alloc		= sas_slave_alloc,
 	.target_destroy		= sas_target_destroy,
 	.ioctl			= sas_ioctl,
 #ifdef CONFIG_COMPAT
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 46f60fc2a069..9df1639ffa65 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -3584,6 +3584,7 @@ static struct scsi_host_template sht_v2_hw = {
 	.max_sectors		= SCSI_DEFAULT_MAX_SECTORS,
 	.eh_device_reset_handler = sas_eh_device_reset_handler,
 	.eh_target_reset_handler = sas_eh_target_reset_handler,
+	.slave_alloc		= sas_slave_alloc,
 	.target_destroy		= sas_target_destroy,
 	.ioctl			= sas_ioctl,
 #ifdef CONFIG_COMPAT
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index e95408314078..36ec3901cfd4 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -3155,6 +3155,7 @@ static struct scsi_host_template sht_v3_hw = {
 	.max_sectors		= SCSI_DEFAULT_MAX_SECTORS,
 	.eh_device_reset_handler = sas_eh_device_reset_handler,
 	.eh_target_reset_handler = sas_eh_target_reset_handler,
+	.slave_alloc		= sas_slave_alloc,
 	.target_destroy		= sas_target_destroy,
 	.ioctl			= sas_ioctl,
 #ifdef CONFIG_COMPAT
diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index c452849e7bb4..ffd33e5decae 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -167,6 +167,7 @@ static struct scsi_host_template isci_sht = {
 	.eh_abort_handler		= sas_eh_abort_handler,
 	.eh_device_reset_handler        = sas_eh_device_reset_handler,
 	.eh_target_reset_handler        = sas_eh_target_reset_handler,
+	.slave_alloc			= sas_slave_alloc,
 	.target_destroy			= sas_target_destroy,
 	.ioctl				= sas_ioctl,
 #ifdef CONFIG_COMPAT
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 1bf939818c98..ee44a0d7730b 100644
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
index 6aa2697c4a15..b03c0f35d7b0 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -46,6 +46,7 @@ static struct scsi_host_template mvs_sht = {
 	.max_sectors		= SCSI_DEFAULT_MAX_SECTORS,
 	.eh_device_reset_handler = sas_eh_device_reset_handler,
 	.eh_target_reset_handler = sas_eh_target_reset_handler,
+	.slave_alloc		= sas_slave_alloc,
 	.target_destroy		= sas_target_destroy,
 	.ioctl			= sas_ioctl,
 #ifdef CONFIG_COMPAT
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index af09bd282cb9..313248c7bab9 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -101,6 +101,7 @@ static struct scsi_host_template pm8001_sht = {
 	.max_sectors		= SCSI_DEFAULT_MAX_SECTORS,
 	.eh_device_reset_handler = sas_eh_device_reset_handler,
 	.eh_target_reset_handler = sas_eh_target_reset_handler,
+	.slave_alloc		= sas_slave_alloc,
 	.target_destroy		= sas_target_destroy,
 	.ioctl			= sas_ioctl,
 #ifdef CONFIG_COMPAT
-- 
2.30.2



