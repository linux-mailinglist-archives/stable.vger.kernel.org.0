Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9898E22100
	for <lists+stable@lfdr.de>; Sat, 18 May 2019 02:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727537AbfERAry (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 20:47:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:33992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726881AbfERAry (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 May 2019 20:47:54 -0400
Received: from localhost (unknown [104.132.1.68])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47DA721883;
        Sat, 18 May 2019 00:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558140473;
        bh=wcJMmid3eNX1fzqE7KShQj339cvq5JIkzCDTKY+6qnQ=;
        h=From:To:Cc:Subject:Date:From;
        b=lLvPLBZDUqi9n30KQHvC+B/mdzOF1Y5E0ax4t8Cu08ZULeWcxxATpwO7pB8BB55/9
         FsB2b1Hjo1kC5w47jpPiqFtz+zJ3zJC2xE0sVxZbLKmCIsRW5t2wkwkQcFeSCycBje
         AhjCZOZ0fjeCPVI+PSkJ8d2nQuzArr8fiL1/HAUw=
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, stable@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH] loop: avoid EAGAIN, if offset or block_size are changed
Date:   Fri, 17 May 2019 17:47:51 -0700
Message-Id: <20190518004751.18962-1-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.19.0.605.g01d371f741-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch tries to avoid EAGAIN due to nrpages!=0 that was originally trying
to drop stale pages resulting in wrong data access.

Report: https://bugs.chromium.org/p/chromium/issues/detail?id=938958#c38

Cc: <stable@vger.kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>
Fixes: 5db470e229e2 ("loop: drop caches if offset or block_size are changed")
Reported-by: Gwendal Grignou <gwendal@chromium.org>
Reported-by: grygorii tertychnyi <gtertych@cisco.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 drivers/block/loop.c | 44 +++++++++++++++++---------------------------
 1 file changed, 17 insertions(+), 27 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 102d79575895..7c7d2d9c47d0 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1212,6 +1212,7 @@ loop_set_status(struct loop_device *lo, const struct loop_info64 *info)
 	kuid_t uid = current_uid();
 	struct block_device *bdev;
 	bool partscan = false;
+	bool drop_caches = false;
 
 	err = mutex_lock_killable(&loop_ctl_mutex);
 	if (err)
@@ -1232,10 +1233,8 @@ loop_set_status(struct loop_device *lo, const struct loop_info64 *info)
 	}
 
 	if (lo->lo_offset != info->lo_offset ||
-	    lo->lo_sizelimit != info->lo_sizelimit) {
-		sync_blockdev(lo->lo_device);
-		kill_bdev(lo->lo_device);
-	}
+	    lo->lo_sizelimit != info->lo_sizelimit)
+		drop_caches = true;
 
 	/* I/O need to be drained during transfer transition */
 	blk_mq_freeze_queue(lo->lo_queue);
@@ -1265,14 +1264,6 @@ loop_set_status(struct loop_device *lo, const struct loop_info64 *info)
 
 	if (lo->lo_offset != info->lo_offset ||
 	    lo->lo_sizelimit != info->lo_sizelimit) {
-		/* kill_bdev should have truncated all the pages */
-		if (lo->lo_device->bd_inode->i_mapping->nrpages) {
-			err = -EAGAIN;
-			pr_warn("%s: loop%d (%s) has still dirty pages (nrpages=%lu)\n",
-				__func__, lo->lo_number, lo->lo_file_name,
-				lo->lo_device->bd_inode->i_mapping->nrpages);
-			goto out_unfreeze;
-		}
 		if (figure_loop_size(lo, info->lo_offset, info->lo_sizelimit)) {
 			err = -EFBIG;
 			goto out_unfreeze;
@@ -1317,6 +1308,12 @@ loop_set_status(struct loop_device *lo, const struct loop_info64 *info)
 		bdev = lo->lo_device;
 		partscan = true;
 	}
+
+	/* truncate stale pages cached by previous operations */
+	if (!err && drop_caches) {
+		sync_blockdev(lo->lo_device);
+		kill_bdev(lo->lo_device);
+	}
 out_unlock:
 	mutex_unlock(&loop_ctl_mutex);
 	if (partscan)
@@ -1498,6 +1495,7 @@ static int loop_set_dio(struct loop_device *lo, unsigned long arg)
 
 static int loop_set_block_size(struct loop_device *lo, unsigned long arg)
 {
+	bool drop_caches = false;
 	int err = 0;
 
 	if (lo->lo_state != Lo_bound)
@@ -1506,23 +1504,10 @@ static int loop_set_block_size(struct loop_device *lo, unsigned long arg)
 	if (arg < 512 || arg > PAGE_SIZE || !is_power_of_2(arg))
 		return -EINVAL;
 
-	if (lo->lo_queue->limits.logical_block_size != arg) {
-		sync_blockdev(lo->lo_device);
-		kill_bdev(lo->lo_device);
-	}
+	if (lo->lo_queue->limits.logical_block_size != arg)
+		drop_caches = true;
 
 	blk_mq_freeze_queue(lo->lo_queue);
-
-	/* kill_bdev should have truncated all the pages */
-	if (lo->lo_queue->limits.logical_block_size != arg &&
-			lo->lo_device->bd_inode->i_mapping->nrpages) {
-		err = -EAGAIN;
-		pr_warn("%s: loop%d (%s) has still dirty pages (nrpages=%lu)\n",
-			__func__, lo->lo_number, lo->lo_file_name,
-			lo->lo_device->bd_inode->i_mapping->nrpages);
-		goto out_unfreeze;
-	}
-
 	blk_queue_logical_block_size(lo->lo_queue, arg);
 	blk_queue_physical_block_size(lo->lo_queue, arg);
 	blk_queue_io_min(lo->lo_queue, arg);
@@ -1530,6 +1515,11 @@ static int loop_set_block_size(struct loop_device *lo, unsigned long arg)
 out_unfreeze:
 	blk_mq_unfreeze_queue(lo->lo_queue);
 
+	/* truncate stale pages cached by previous operations */
+	if (drop_caches) {
+		sync_blockdev(lo->lo_device);
+		kill_bdev(lo->lo_device);
+	}
 	return err;
 }
 
-- 
2.19.0.605.g01d371f741-goog

