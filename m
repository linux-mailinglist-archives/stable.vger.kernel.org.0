Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08583439C69
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 19:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234344AbhJYRDM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 13:03:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:55374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234349AbhJYRCt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 13:02:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57AF261029;
        Mon, 25 Oct 2021 17:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635181227;
        bh=Kj1AWzlEik0VbFuSbn4xzFtV2LhJyru6NbK7llG2Gu0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MLzwtSjM2/ejzFIxGhkRmRW5RhyJ9EZZQbt3gWvUrfBgbcuf/iWTN+tRTmvx8KcKW
         FcphAF9z6bORmLufhQG4YGhYW6buujQCq2PbRYuu0jchabz+I+Wnt9sB3I22BDszFH
         xefTwsieeu6W6+CtGlANQkDcVQqLCPo1zLqf/U3iJ0KnqNDU4UVeDof79kpnpJ2av3
         fXESbJ5OMy/bGXcIeVDfW4izGnkzdvNke4etZkdvHNLe1DJ0sgdbPDlxB0FVNvttL/
         kMpXDKjBp5oU5YzqfIZnfBgS4X3/ZGpO10EdN/JFa2GskOkrEgCBOhLkesqK+ddV32
         y0/baR1eo3RgA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Changhui Zhong <czhong@redhat.com>,
        Yi Zhang <yi.zhang@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 02/13] scsi: core: Put LLD module refcnt after SCSI device is released
Date:   Mon, 25 Oct 2021 13:00:11 -0400
Message-Id: <20211025170023.1394358-2-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211025170023.1394358-1-sashal@kernel.org>
References: <20211025170023.1394358-1-sashal@kernel.org>
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
index 24619c3bebd5..6ad834d61d4c 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -545,8 +545,10 @@ EXPORT_SYMBOL(scsi_device_get);
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
index 8173b67ec7b0..1378bb1a7371 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -450,9 +450,12 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
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

