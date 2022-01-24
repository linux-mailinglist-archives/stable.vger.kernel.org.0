Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C40349A973
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:24:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1322591AbiAYDWH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:22:07 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:36736 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385026AbiAXUbZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:31:25 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53A44B8124F;
        Mon, 24 Jan 2022 20:31:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D6A9C340E7;
        Mon, 24 Jan 2022 20:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056277;
        bh=9OYIhp4tcNcPNdnDiXHPbH5wBCGJndxbPgN1unI9o3Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QJ6r4500TUFeery9Tq0UIkLbuCZ5feWFHAepEMI8k5045lkNigc5QH1Yx3VmyxtoL
         sjnP2EdxaVTenoY8ovOcRDNb+ymHScedvKFmDdN2MdzVlM6tY+CxUvDQ8AbTRjC2uF
         bZNROn3XHOzyV3k88PRvX8rzayLnVdOojGpV4LAg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH 5.15 429/846] scsi: block: pm: Always set request queue runtime active in blk_post_runtime_resume()
Date:   Mon, 24 Jan 2022 19:39:06 +0100
Message-Id: <20220124184115.776860952@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

[ Upstream commit 6e1fcab00a23f7fe9f4fe9704905a790efa1eeab ]

John Garry reported a deadlock that occurs when trying to access a
runtime-suspended SATA device.  For obscure reasons, the rescan procedure
causes the link to be hard-reset, which disconnects the device.

The rescan tries to carry out a runtime resume when accessing the device.
scsi_rescan_device() holds the SCSI device lock and won't release it until
it can put commands onto the device's block queue.  This can't happen until
the queue is successfully runtime-resumed or the device is unregistered.
But the runtime resume fails because the device is disconnected, and
__scsi_remove_device() can't do the unregistration because it can't get the
device lock.

The best way to resolve this deadlock appears to be to allow the block
queue to start running again even after an unsuccessful runtime resume.
The idea is that the driver or the SCSI error handler will need to be able
to use the queue to resolve the runtime resume failure.

This patch removes the err argument to blk_post_runtime_resume() and makes
the routine act as though the resume was successful always.  This fixes the
deadlock.

Link: https://lore.kernel.org/r/1639999298-244569-4-git-send-email-chenxiang66@hisilicon.com
Fixes: e27829dc92e5 ("scsi: serialize ->rescan against ->remove")
Reported-and-tested-by: John Garry <john.garry@huawei.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-pm.c         | 22 +++++++---------------
 drivers/scsi/scsi_pm.c |  2 +-
 include/linux/blk-pm.h |  2 +-
 3 files changed, 9 insertions(+), 17 deletions(-)

diff --git a/block/blk-pm.c b/block/blk-pm.c
index 17bd020268d42..2dad62cc15727 100644
--- a/block/blk-pm.c
+++ b/block/blk-pm.c
@@ -163,27 +163,19 @@ EXPORT_SYMBOL(blk_pre_runtime_resume);
 /**
  * blk_post_runtime_resume - Post runtime resume processing
  * @q: the queue of the device
- * @err: return value of the device's runtime_resume function
  *
  * Description:
- *    Update the queue's runtime status according to the return value of the
- *    device's runtime_resume function. If the resume was successful, call
- *    blk_set_runtime_active() to do the real work of restarting the queue.
+ *    For historical reasons, this routine merely calls blk_set_runtime_active()
+ *    to do the real work of restarting the queue.  It does this regardless of
+ *    whether the device's runtime-resume succeeded; even if it failed the
+ *    driver or error handler will need to communicate with the device.
  *
  *    This function should be called near the end of the device's
  *    runtime_resume callback.
  */
-void blk_post_runtime_resume(struct request_queue *q, int err)
+void blk_post_runtime_resume(struct request_queue *q)
 {
-	if (!q->dev)
-		return;
-	if (!err) {
-		blk_set_runtime_active(q);
-	} else {
-		spin_lock_irq(&q->queue_lock);
-		q->rpm_status = RPM_SUSPENDED;
-		spin_unlock_irq(&q->queue_lock);
-	}
+	blk_set_runtime_active(q);
 }
 EXPORT_SYMBOL(blk_post_runtime_resume);
 
@@ -201,7 +193,7 @@ EXPORT_SYMBOL(blk_post_runtime_resume);
  * runtime PM status and re-enable peeking requests from the queue. It
  * should be called before first request is added to the queue.
  *
- * This function is also called by blk_post_runtime_resume() for successful
+ * This function is also called by blk_post_runtime_resume() for
  * runtime resumes.  It does everything necessary to restart the queue.
  */
 void blk_set_runtime_active(struct request_queue *q)
diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
index 3717eea37ecb3..e91a0a5bc7a3e 100644
--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -262,7 +262,7 @@ static int sdev_runtime_resume(struct device *dev)
 	blk_pre_runtime_resume(sdev->request_queue);
 	if (pm && pm->runtime_resume)
 		err = pm->runtime_resume(dev);
-	blk_post_runtime_resume(sdev->request_queue, err);
+	blk_post_runtime_resume(sdev->request_queue);
 
 	return err;
 }
diff --git a/include/linux/blk-pm.h b/include/linux/blk-pm.h
index b80c65aba2493..2580e05a8ab67 100644
--- a/include/linux/blk-pm.h
+++ b/include/linux/blk-pm.h
@@ -14,7 +14,7 @@ extern void blk_pm_runtime_init(struct request_queue *q, struct device *dev);
 extern int blk_pre_runtime_suspend(struct request_queue *q);
 extern void blk_post_runtime_suspend(struct request_queue *q, int err);
 extern void blk_pre_runtime_resume(struct request_queue *q);
-extern void blk_post_runtime_resume(struct request_queue *q, int err);
+extern void blk_post_runtime_resume(struct request_queue *q);
 extern void blk_set_runtime_active(struct request_queue *q);
 #else
 static inline void blk_pm_runtime_init(struct request_queue *q,
-- 
2.34.1



