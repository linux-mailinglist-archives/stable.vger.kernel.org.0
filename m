Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46BC8439CEF
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 19:07:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234522AbhJYRHe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 13:07:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:56224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234799AbhJYREc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 13:04:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 33217610C8;
        Mon, 25 Oct 2021 17:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635181295;
        bh=N4jTZEiCI/fgjQxxjR1nGSDTqF4wAhBvJtiTVgB91UM=;
        h=From:To:Cc:Subject:Date:From;
        b=mcfDnVD+Dpzl9H4spCwbTijo9wgf+WiZyIIN7BqgBDx73cHJHEL511VRdllQlIhJ6
         M17ePP93azGets8Lg/OlawJX9XHYHfeSPcR7awCNeLUXxure11jW9om6O1Whwi7rwa
         PHA/1SGA19ZNTX2BElbY+9pmbi0sqq25UbayuFJMIyUCPejYIlnxYhoJqQ8WIcRrQt
         EtNGqeEyDuycoYooEqbLiO0ej3mUKDeiVwAGVb4ZUQ3XVzY3vK+Haj8PyG68aZmgNZ
         50eqhEjWIAuax/kx6Buuns1PrCggMdw8z3E6KJ7ndLQcBc+jM0mm5fLq6QN4P8bKgp
         W4hhq2OFPehMg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Changhui Zhong <czhong@redhat.com>,
        Yi Zhang <yi.zhang@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 1/4] scsi: core: Put LLD module refcnt after SCSI device is released
Date:   Mon, 25 Oct 2021 13:01:29 -0400
Message-Id: <20211025170132.1394887-1-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
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
index 1deb6adc411f..4c9c1a8db8c3 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -951,8 +951,10 @@ EXPORT_SYMBOL(scsi_device_get);
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
index 38830818bfb6..eae43a85e9b0 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -427,9 +427,12 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 	struct device *parent;
 	struct list_head *this, *tmp;
 	unsigned long flags;
+	struct module *mod;
 
 	sdev = container_of(work, struct scsi_device, ew.work);
 
+	mod = sdev->host->hostt->module;
+
 	scsi_dh_release_device(sdev);
 
 	parent = sdev->sdev_gendev.parent;
@@ -461,11 +464,17 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 
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

