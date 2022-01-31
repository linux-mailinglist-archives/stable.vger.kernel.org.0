Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E7AC4A4044
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 11:33:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358201AbiAaKc7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 05:32:59 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:42332 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358202AbiAaKc5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 05:32:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5DA80CE10F0
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 10:32:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21E39C340E8;
        Mon, 31 Jan 2022 10:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643625173;
        bh=G6bGvWLMjLJgBqxlXhVNyyUTLEfD/qLTdI0EOsSzFpk=;
        h=Subject:To:Cc:From:Date:From;
        b=Hjcmzm996SxD7NcoWTVFLRe21i3iN9PrxyDh6DtfRl2lVuNO90V7Al/1DLv+t2XYb
         Czj3Gzqnq/EJpDUpUncU1ZdFokMzSXpmEM+DqqceFgfpTk+Bn0XrFYlZ9/uFJ5wkve
         Jf8V2ucMFId6d/OQFGr6oMbjE37yzvCW/d1ES+Vo=
Subject: FAILED: patch "[PATCH] loop: make autoclear operation asynchronous" failed to apply to 5.4-stable tree
To:     penguin-kernel@i-love.sakura.ne.jp, axboe@kernel.dk,
        hch@infradead.org, hch@lst.de, jack@suse.cz,
        penguin-kernel@I-love.SAKURA.ne.jp,
        syzbot+643e4ce4b6ad1347d372@syzkaller.appspotmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 31 Jan 2022 11:32:37 +0100
Message-ID: <16436251578591@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 322c4293ecc58110227b49d7e47ae37b9b03566f Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Date: Mon, 13 Dec 2021 21:55:27 +0900
Subject: [PATCH] loop: make autoclear operation asynchronous

syzbot is reporting circular locking problem at __loop_clr_fd() [1], for
commit 87579e9b7d8dc36e ("loop: use worker per cgroup instead of kworker")
is calling destroy_workqueue() with disk->open_mutex held.

This circular dependency cannot be broken unless we call __loop_clr_fd()
without holding disk->open_mutex. Therefore, defer __loop_clr_fd() from
lo_release() to a WQ context.

Link: https://syzkaller.appspot.com/bug?extid=643e4ce4b6ad1347d372 [1]
Reported-by: syzbot <syzbot+643e4ce4b6ad1347d372@syzkaller.appspotmail.com>
Suggested-by: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Tested-by: syzbot+643e4ce4b6ad1347d372@syzkaller.appspotmail.com
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/1ed7df28-ebd6-71fb-70e5-1c2972e05ddb@i-love.sakura.ne.jp
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index ba76319b5544..7f4ea06534c2 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1082,7 +1082,7 @@ static int loop_configure(struct loop_device *lo, fmode_t mode,
 	return error;
 }
 
-static void __loop_clr_fd(struct loop_device *lo, bool release)
+static void __loop_clr_fd(struct loop_device *lo)
 {
 	struct file *filp;
 	gfp_t gfp = lo->old_gfp_mask;
@@ -1144,8 +1144,6 @@ static void __loop_clr_fd(struct loop_device *lo, bool release)
 	/* let user-space know about this change */
 	kobject_uevent(&disk_to_dev(lo->lo_disk)->kobj, KOBJ_CHANGE);
 	mapping_set_gfp_mask(filp->f_mapping, gfp);
-	/* This is safe: open() is still holding a reference. */
-	module_put(THIS_MODULE);
 	blk_mq_unfreeze_queue(lo->lo_queue);
 
 	disk_force_media_change(lo->lo_disk, DISK_EVENT_MEDIA_CHANGE);
@@ -1153,44 +1151,52 @@ static void __loop_clr_fd(struct loop_device *lo, bool release)
 	if (lo->lo_flags & LO_FLAGS_PARTSCAN) {
 		int err;
 
-		/*
-		 * open_mutex has been held already in release path, so don't
-		 * acquire it if this function is called in such case.
-		 *
-		 * If the reread partition isn't from release path, lo_refcnt
-		 * must be at least one and it can only become zero when the
-		 * current holder is released.
-		 */
-		if (!release)
-			mutex_lock(&lo->lo_disk->open_mutex);
+		mutex_lock(&lo->lo_disk->open_mutex);
 		err = bdev_disk_changed(lo->lo_disk, false);
-		if (!release)
-			mutex_unlock(&lo->lo_disk->open_mutex);
+		mutex_unlock(&lo->lo_disk->open_mutex);
 		if (err)
 			pr_warn("%s: partition scan of loop%d failed (rc=%d)\n",
 				__func__, lo->lo_number, err);
 		/* Device is gone, no point in returning error */
 	}
 
-	/*
-	 * lo->lo_state is set to Lo_unbound here after above partscan has
-	 * finished. There cannot be anybody else entering __loop_clr_fd() as
-	 * Lo_rundown state protects us from all the other places trying to
-	 * change the 'lo' device.
-	 */
 	lo->lo_flags = 0;
 	if (!part_shift)
 		lo->lo_disk->flags |= GENHD_FL_NO_PART;
+
+	fput(filp);
+}
+
+static void loop_rundown_completed(struct loop_device *lo)
+{
 	mutex_lock(&lo->lo_mutex);
 	lo->lo_state = Lo_unbound;
 	mutex_unlock(&lo->lo_mutex);
+	module_put(THIS_MODULE);
+}
 
-	/*
-	 * Need not hold lo_mutex to fput backing file. Calling fput holding
-	 * lo_mutex triggers a circular lock dependency possibility warning as
-	 * fput can take open_mutex which is usually taken before lo_mutex.
-	 */
-	fput(filp);
+static void loop_rundown_workfn(struct work_struct *work)
+{
+	struct loop_device *lo = container_of(work, struct loop_device,
+					      rundown_work);
+	struct block_device *bdev = lo->lo_device;
+	struct gendisk *disk = lo->lo_disk;
+
+	__loop_clr_fd(lo);
+	kobject_put(&bdev->bd_device.kobj);
+	module_put(disk->fops->owner);
+	loop_rundown_completed(lo);
+}
+
+static void loop_schedule_rundown(struct loop_device *lo)
+{
+	struct block_device *bdev = lo->lo_device;
+	struct gendisk *disk = lo->lo_disk;
+
+	__module_get(disk->fops->owner);
+	kobject_get(&bdev->bd_device.kobj);
+	INIT_WORK(&lo->rundown_work, loop_rundown_workfn);
+	queue_work(system_long_wq, &lo->rundown_work);
 }
 
 static int loop_clr_fd(struct loop_device *lo)
@@ -1222,7 +1228,8 @@ static int loop_clr_fd(struct loop_device *lo)
 	lo->lo_state = Lo_rundown;
 	mutex_unlock(&lo->lo_mutex);
 
-	__loop_clr_fd(lo, false);
+	__loop_clr_fd(lo);
+	loop_rundown_completed(lo);
 	return 0;
 }
 
@@ -1747,7 +1754,7 @@ static void lo_release(struct gendisk *disk, fmode_t mode)
 		 * In autoclear mode, stop the loop thread
 		 * and remove configuration after last close.
 		 */
-		__loop_clr_fd(lo, true);
+		loop_schedule_rundown(lo);
 		return;
 	} else if (lo->lo_state == Lo_bound) {
 		/*
diff --git a/drivers/block/loop.h b/drivers/block/loop.h
index 082d4b6bfc6a..918a7a2dc025 100644
--- a/drivers/block/loop.h
+++ b/drivers/block/loop.h
@@ -56,6 +56,7 @@ struct loop_device {
 	struct gendisk		*lo_disk;
 	struct mutex		lo_mutex;
 	bool			idr_visible;
+	struct work_struct      rundown_work;
 };
 
 struct loop_cmd {

