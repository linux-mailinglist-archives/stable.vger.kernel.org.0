Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9AD4A403D
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 11:32:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358194AbiAaKce (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 05:32:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345599AbiAaKcd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 05:32:33 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC08FC061714
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 02:32:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 266F3CE10F0
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 10:32:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1D83C340E8;
        Mon, 31 Jan 2022 10:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643625149;
        bh=QgZuUE/FX1by2jEQQ4ZEDPuXFHBXeIyEpQc77xCZzzw=;
        h=Subject:To:Cc:From:Date:From;
        b=KT3bKjD0BZ4QpjDyumhlBSRUZJRNKV0qwZRNnsC6ywlNQTU/H2QEMgHVqcy/mn/UE
         0r185JD68I3O6FFdDXv/DjkR95BIXJtz4FuK4hGyfN9/y2HteVP/HHXZDDsx0L9Wrv
         B2P71J9ZFSuoOPbEDzE6uNdwR9+tEVjKiAB7anMo=
Subject: FAILED: patch "[PATCH] loop: don't hold lo_mutex during __loop_clr_fd()" failed to apply to 5.16-stable tree
To:     penguin-kernel@i-love.sakura.ne.jp, axboe@kernel.dk, hch@lst.de,
        penguin-kernel@I-love.SAKURA.ne.jp,
        syzbot+63614029dfb79abd4383@syzkaller.appspotmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 31 Jan 2022 11:32:26 +0100
Message-ID: <16436251461061@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.16-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6050fa4c84cc93ae509f5105f585a429dffc5633 Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Date: Wed, 24 Nov 2021 19:47:40 +0900
Subject: [PATCH] loop: don't hold lo_mutex during __loop_clr_fd()

syzbot is reporting circular locking problem at __loop_clr_fd() [1], for
commit 87579e9b7d8dc36e ("loop: use worker per cgroup instead of kworker")
is calling destroy_workqueue() with lo->lo_mutex held.

Since all functions where lo->lo_state matters are already checking
lo->lo_state with lo->lo_mutex held (in order to avoid racing with e.g.
ioctl(LOOP_CTL_REMOVE)), and __loop_clr_fd() can be called from either
ioctl(LOOP_CLR_FD) xor close(), lo->lo_state == Lo_rundown is considered
as an exclusive lock for __loop_clr_fd(). Therefore, hold lo->lo_mutex
inside __loop_clr_fd() only when asserting/updating lo->lo_state.

Since ioctl(LOOP_CLR_FD) depends on lo->lo_state == Lo_bound, a valid
lo->lo_backing_file must have been assigned by ioctl(LOOP_SET_FD) or
ioctl(LOOP_CONFIGURE). Thus, we can remove lo->lo_backing_file test,
and convert __loop_clr_fd() into a void function.

Link: https://syzkaller.appspot.com/bug?extid=63614029dfb79abd4383 [1]
Reported-by: syzbot <syzbot+63614029dfb79abd4383@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/8ebe3b2e-8975-7f26-0620-7144a3b8b8cd@i-love.sakura.ne.jp
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 0954ea8cf9e3..ba76319b5544 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1082,13 +1082,10 @@ static int loop_configure(struct loop_device *lo, fmode_t mode,
 	return error;
 }
 
-static int __loop_clr_fd(struct loop_device *lo, bool release)
+static void __loop_clr_fd(struct loop_device *lo, bool release)
 {
-	struct file *filp = NULL;
+	struct file *filp;
 	gfp_t gfp = lo->old_gfp_mask;
-	int err = 0;
-	bool partscan = false;
-	int lo_number;
 	struct loop_worker *pos, *worker;
 
 	/*
@@ -1103,17 +1100,14 @@ static int __loop_clr_fd(struct loop_device *lo, bool release)
 	 * became visible.
 	 */
 
+	/*
+	 * Since this function is called upon "ioctl(LOOP_CLR_FD)" xor "close()
+	 * after ioctl(LOOP_CLR_FD)", it is a sign of something going wrong if
+	 * lo->lo_state has changed while waiting for lo->lo_mutex.
+	 */
 	mutex_lock(&lo->lo_mutex);
-	if (WARN_ON_ONCE(lo->lo_state != Lo_rundown)) {
-		err = -ENXIO;
-		goto out_unlock;
-	}
-
-	filp = lo->lo_backing_file;
-	if (filp == NULL) {
-		err = -EINVAL;
-		goto out_unlock;
-	}
+	BUG_ON(lo->lo_state != Lo_rundown);
+	mutex_unlock(&lo->lo_mutex);
 
 	if (test_bit(QUEUE_FLAG_WC, &lo->lo_queue->queue_flags))
 		blk_queue_write_cache(lo->lo_queue, false, false);
@@ -1134,6 +1128,7 @@ static int __loop_clr_fd(struct loop_device *lo, bool release)
 	del_timer_sync(&lo->timer);
 
 	spin_lock_irq(&lo->lo_lock);
+	filp = lo->lo_backing_file;
 	lo->lo_backing_file = NULL;
 	spin_unlock_irq(&lo->lo_lock);
 
@@ -1153,12 +1148,11 @@ static int __loop_clr_fd(struct loop_device *lo, bool release)
 	module_put(THIS_MODULE);
 	blk_mq_unfreeze_queue(lo->lo_queue);
 
-	partscan = lo->lo_flags & LO_FLAGS_PARTSCAN;
-	lo_number = lo->lo_number;
 	disk_force_media_change(lo->lo_disk, DISK_EVENT_MEDIA_CHANGE);
-out_unlock:
-	mutex_unlock(&lo->lo_mutex);
-	if (partscan) {
+
+	if (lo->lo_flags & LO_FLAGS_PARTSCAN) {
+		int err;
+
 		/*
 		 * open_mutex has been held already in release path, so don't
 		 * acquire it if this function is called in such case.
@@ -1174,24 +1168,20 @@ static int __loop_clr_fd(struct loop_device *lo, bool release)
 			mutex_unlock(&lo->lo_disk->open_mutex);
 		if (err)
 			pr_warn("%s: partition scan of loop%d failed (rc=%d)\n",
-				__func__, lo_number, err);
+				__func__, lo->lo_number, err);
 		/* Device is gone, no point in returning error */
-		err = 0;
 	}
 
 	/*
 	 * lo->lo_state is set to Lo_unbound here after above partscan has
-	 * finished.
-	 *
-	 * There cannot be anybody else entering __loop_clr_fd() as
-	 * lo->lo_backing_file is already cleared and Lo_rundown state
-	 * protects us from all the other places trying to change the 'lo'
-	 * device.
+	 * finished. There cannot be anybody else entering __loop_clr_fd() as
+	 * Lo_rundown state protects us from all the other places trying to
+	 * change the 'lo' device.
 	 */
-	mutex_lock(&lo->lo_mutex);
 	lo->lo_flags = 0;
 	if (!part_shift)
 		lo->lo_disk->flags |= GENHD_FL_NO_PART;
+	mutex_lock(&lo->lo_mutex);
 	lo->lo_state = Lo_unbound;
 	mutex_unlock(&lo->lo_mutex);
 
@@ -1200,9 +1190,7 @@ static int __loop_clr_fd(struct loop_device *lo, bool release)
 	 * lo_mutex triggers a circular lock dependency possibility warning as
 	 * fput can take open_mutex which is usually taken before lo_mutex.
 	 */
-	if (filp)
-		fput(filp);
-	return err;
+	fput(filp);
 }
 
 static int loop_clr_fd(struct loop_device *lo)
@@ -1234,7 +1222,8 @@ static int loop_clr_fd(struct loop_device *lo)
 	lo->lo_state = Lo_rundown;
 	mutex_unlock(&lo->lo_mutex);
 
-	return __loop_clr_fd(lo, false);
+	__loop_clr_fd(lo, false);
+	return 0;
 }
 
 static int

