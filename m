Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F1D63C8D31
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236362AbhGNTn4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:43:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:36706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235990AbhGNTnS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:43:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 291B6613EC;
        Wed, 14 Jul 2021 19:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291623;
        bh=arHhlv75PWValrmuk/WCpBZK1wamtBOUkyMBJFqpF0w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HiIOT7oYHzUkdThz5Hw3/o89F39CMDTNZbriJjnhtJ7730snilOYweIZ+uAL5wZWo
         8y5FRguRPKEe8qunPKxvheOGP5BPwCo0k8zRGvv0AtAPIIJrmTa5CwxuOoCaAEhsBh
         k73uI7Jju1vhKzkcfJTZd5XfXLozTOPuRlzwqUs3R1exRBdlnAxzoeBOio65baA5Qa
         6gKH1QMNHBZ/8Y6nCmejn3sXr6JCp+AVWuVCDR8wcILxIriEXaHf46TnNO1rJA3cJ0
         AKn+mpxtqKdWULy74N0XAFGmFIorhM5U+6eoDJUDwIUS5N+ZtLJ4oer/Ab5cKakR4o
         z9/Va1J2VAasA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yufen Yu <yuyufen@huawei.com>, Wu Bo <wubo40@huawei.com>,
        John Garry <john.garry@huawei.com>,
        Jason Yan <yanaijie@huawei.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 099/108] scsi: libsas: Add LUN number check in .slave_alloc callback
Date:   Wed, 14 Jul 2021 15:37:51 -0400
Message-Id: <20210714193800.52097-99-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714193800.52097-1-sashal@kernel.org>
References: <20210714193800.52097-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 3e359ac752fd..15eaac3a4eb6 100644
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

