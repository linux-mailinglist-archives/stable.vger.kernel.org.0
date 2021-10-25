Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB99C439C3D
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 18:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234196AbhJYRCN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 13:02:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:54512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234151AbhJYRCJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 13:02:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C1D8660F92;
        Mon, 25 Oct 2021 16:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635181186;
        bh=3TFO/T2EnCi4p90u8EHPpy5i/lZnFyiAgAbYZ9zQVOU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bZ/D5NEVZKaNlUKxKVF5u77OqL2+z31cTN6+SG8/LWYjSAn70mj78XAS9MGinvrbh
         U/PVyzNnyxRDFOBZDPl8eGTHQqGDFerFlRGwvHLZff/ENANNRkR3PScT5Kk4FO6e/7
         LEEpKNnDP/cFWoINj3AgdrrZYdo2uzVn6wM3x2pvN44Bf+ybIJqMLG/a3+n5W2Q1yZ
         PLL8U9Hr2Ow10YD7GDPAJsSCVIHDaoGo0xp9HRRim37yA0wg3co3nbtKGJe4zK8bXu
         qNob7pnaTz2smk4bQXLd1atDZZstcmVPRrHawosTLZeVLKXwSM7QGvovilxrI6TfyU
         T3L6IJhVZMrdw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Changhui Zhong <czhong@redhat.com>,
        Yi Zhang <yi.zhang@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 04/18] scsi: core: Put LLD module refcnt after SCSI device is released
Date:   Mon, 25 Oct 2021 12:59:17 -0400
Message-Id: <20211025165939.1393655-4-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211025165939.1393655-1-sashal@kernel.org>
References: <20211025165939.1393655-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit f2b85040acec9a928b4eb1b57a989324e8e38d3f ]

SCSI host release is triggered when SCSI device is freed. We have to make
sure that the low-level device driver module won't be unloaded before SCSI
host instance is released because shost->hostt is required in the release
handler.

Make sure to put LLD module refcnt after SCSI device is released.

Fixes a kernel panic of 'BUG: unable to handle page fault for address'
reported by Changhui and Yi.

Link: https://lore.kernel.org/r/20211008050118.1440686-1-ming.lei@redhat.com
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reported-by: Changhui Zhong <czhong@redhat.com>
Reported-by: Yi Zhang <yi.zhang@redhat.com>
Tested-by: Yi Zhang <yi.zhang@redhat.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi.c       | 4 +++-
 drivers/scsi/scsi_sysfs.c | 9 +++++++++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index d26025cf5de3..71dd0989c78a 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -553,8 +553,10 @@ EXPORT_SYMBOL(scsi_device_get);
  */
 void scsi_device_put(struct scsi_device *sdev)
 {
-	module_put(sdev->host->hostt->module);
+	struct module *mod = sdev->host->hostt->module;
+
 	put_device(&sdev->sdev_gendev);
+	module_put(mod);
 }
 EXPORT_SYMBOL(scsi_device_put);
 
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index c0d31119d6d7..ed05c3565e83 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -448,9 +448,12 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 	struct scsi_vpd *vpd_pg80 = NULL, *vpd_pg83 = NULL;
 	struct scsi_vpd *vpd_pg0 = NULL, *vpd_pg89 = NULL;
 	unsigned long flags;
+	struct module *mod;
 
 	sdev = container_of(work, struct scsi_device, ew.work);
 
+	mod = sdev->host->hostt->module;
+
 	scsi_dh_release_device(sdev);
 
 	parent = sdev->sdev_gendev.parent;
@@ -501,11 +504,17 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 
 	if (parent)
 		put_device(parent);
+	module_put(mod);
 }
 
 static void scsi_device_dev_release(struct device *dev)
 {
 	struct scsi_device *sdp = to_scsi_device(dev);
+
+	/* Set module pointer as NULL in case of module unloading */
+	if (!try_module_get(sdp->host->hostt->module))
+		sdp->host->hostt->module = NULL;
+
 	execute_in_process_context(scsi_device_dev_release_usercontext,
 				   &sdp->ew);
 }
-- 
2.33.0

