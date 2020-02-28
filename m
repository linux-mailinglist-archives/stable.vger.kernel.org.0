Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1EFE172FDD
	for <lists+stable@lfdr.de>; Fri, 28 Feb 2020 05:38:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730849AbgB1EiZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 23:38:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:56048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730802AbgB1EiZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 23:38:25 -0500
Received: from localhost (unknown [104.132.1.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA19D2469D;
        Fri, 28 Feb 2020 04:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582864704;
        bh=HQ7hmvfvnb2OGkhjZtbAEIeMVAGbeP6z+iDoaV29xGg=;
        h=From:To:Cc:Subject:Date:From;
        b=R1JdH66yUYP82IgWNwYtnKp6TJ80AtmtFaMnGZ/ppt73Dd0sHeSZcyQZPOvif2NWz
         M61C7KNWhgVQXHzTz7HTskXmFQftQZOqgAI6oXDzHObSziAc4JpOPqh9tRwgd8kl5G
         1MaKi+uZlnDK4is2WTFDpTdQf+02p7X4EdifKWd4=
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, stable@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Gwendal Grignou <gwendal@chromium.org>,
        grygorii tertychnyi <gtertych@cisco.com>
Subject: [PATCH] loop: avoid EAGAIN, if offset or block_size are changed
Date:   Thu, 27 Feb 2020 20:38:20 -0800
Message-Id: <20200228043820.169288-1-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.25.1.481.gfbce0eb801-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Previously, there was a bug where user could see stale buffer cache (e.g, 512B)
attached in the 4KB-sized pager cache, when the block size was changed from
512B to 4KB. That was fixed by:
commit 5db470e229e2 ("loop: drop caches if offset or block_size are changed")

But, there were some regression reports saying the fix returns EAGAIN easily.
So, this patch removes previously added EAGAIN condition, nrpages != 0.

Instead, it changes the flow like this:
- sync_blockdev()
- blk_mq_freeze_queue()
 : change the loop configuration
- blk_mq_unfreeze_queue()
- sync_blockdev()
- invalidate_bdev()

After invalidating the buffer cache, we must see the full valid 4KB page.

Additional concern came from Bart in which we can lose some data when
changing the lo_offset. In that case, this patch adds:
- sync_blockdev()
- blk_set_queue_dying
- blk_mq_freeze_queue()
 : change the loop configuration
- blk_mq_unfreeze_queue()
- blk_queue_flag_clear(QUEUE_FLAG_DYING);
- sync_blockdev()
- invalidate_bdev()

Report: https://bugs.chromium.org/p/chromium/issues/detail?id=938958#c38

Cc: <stable@vger.kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>
Fixes: 5db470e229e2 ("loop: drop caches if offset or block_size are changed")
Reported-by: Gwendal Grignou <gwendal@chromium.org>
Reported-by: grygorii tertychnyi <gtertych@cisco.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 drivers/block/loop.c | 65 ++++++++++++++++++++++----------------------
 1 file changed, 33 insertions(+), 32 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 739b372a5112..8c9da7f9b1f6 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1245,6 +1245,8 @@ loop_set_status(struct loop_device *lo, const struct loop_info64 *info)
 	kuid_t uid = current_uid();
 	struct block_device *bdev;
 	bool partscan = false;
+	bool drop_request = false;
+	bool drop_cache = false;
 
 	err = mutex_lock_killable(&loop_ctl_mutex);
 	if (err)
@@ -1264,14 +1266,21 @@ loop_set_status(struct loop_device *lo, const struct loop_info64 *info)
 		goto out_unlock;
 	}
 
+	if (lo->lo_offset != info->lo_offset)
+		drop_request = true;
 	if (lo->lo_offset != info->lo_offset ||
-	    lo->lo_sizelimit != info->lo_sizelimit) {
-		sync_blockdev(lo->lo_device);
-		kill_bdev(lo->lo_device);
-	}
+	    lo->lo_sizelimit != info->lo_sizelimit)
+		drop_cache = true;
 
-	/* I/O need to be drained during transfer transition */
-	blk_mq_freeze_queue(lo->lo_queue);
+	sync_blockdev(lo->lo_device);
+
+	if (drop_request) {
+		blk_set_queue_dying(lo->lo_queue);
+		blk_mq_freeze_queue_wait(lo->lo_queue);
+	} else {
+		/* I/O need to be drained during transfer transition */
+		blk_mq_freeze_queue(lo->lo_queue);
+	}
 
 	err = loop_release_xfer(lo);
 	if (err)
@@ -1298,14 +1307,6 @@ loop_set_status(struct loop_device *lo, const struct loop_info64 *info)
 
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
@@ -1342,6 +1343,8 @@ loop_set_status(struct loop_device *lo, const struct loop_info64 *info)
 
 out_unfreeze:
 	blk_mq_unfreeze_queue(lo->lo_queue);
+	if (drop_request)
+		blk_queue_flag_clear(QUEUE_FLAG_DYING, lo->lo_queue);
 
 	if (!err && (info->lo_flags & LO_FLAGS_PARTSCAN) &&
 	     !(lo->lo_flags & LO_FLAGS_PARTSCAN)) {
@@ -1350,6 +1353,12 @@ loop_set_status(struct loop_device *lo, const struct loop_info64 *info)
 		bdev = lo->lo_device;
 		partscan = true;
 	}
+
+	/* truncate stale pages cached by previous operations */
+	if (!err && drop_cache) {
+		sync_blockdev(lo->lo_device);
+		invalidate_bdev(lo->lo_device);
+	}
 out_unlock:
 	mutex_unlock(&loop_ctl_mutex);
 	if (partscan)
@@ -1531,7 +1540,7 @@ static int loop_set_dio(struct loop_device *lo, unsigned long arg)
 
 static int loop_set_block_size(struct loop_device *lo, unsigned long arg)
 {
-	int err = 0;
+	bool drop_cache = false;
 
 	if (lo->lo_state != Lo_bound)
 		return -ENXIO;
@@ -1539,31 +1548,23 @@ static int loop_set_block_size(struct loop_device *lo, unsigned long arg)
 	if (arg < 512 || arg > PAGE_SIZE || !is_power_of_2(arg))
 		return -EINVAL;
 
-	if (lo->lo_queue->limits.logical_block_size != arg) {
-		sync_blockdev(lo->lo_device);
-		kill_bdev(lo->lo_device);
-	}
+	if (lo->lo_queue->limits.logical_block_size != arg)
+		drop_cache = true;
 
+	sync_blockdev(lo->lo_device);
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
 	loop_update_dio(lo);
-out_unfreeze:
 	blk_mq_unfreeze_queue(lo->lo_queue);
 
-	return err;
+	/* truncate stale pages cached by previous operations */
+	if (drop_cache) {
+		sync_blockdev(lo->lo_device);
+		invalidate_bdev(lo->lo_device);
+	}
+	return 0;
 }
 
 static int lo_simple_ioctl(struct loop_device *lo, unsigned int cmd,
-- 
2.25.1.481.gfbce0eb801-goog

