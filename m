Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4CA9F614
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 13:42:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728629AbfD3Lmt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:42:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:52294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728610AbfD3Lms (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:42:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA75121670;
        Tue, 30 Apr 2019 11:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624567;
        bh=9VG826kIq7rBLo7qqOLamDLfS1qpQgl0cL8diUkFHEI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F5S62vBxA5BJ8R0tpXo0exwdgA+FfLQpYSqXQXHRMDIWMe+N5sgyp//Nz6Nan30RL
         0JTJXMP2/XMsUn/G+TwxRTg7S6hu4MDTOb7/3xBpCs4KhtzwIL7lwrLiuuT16H86Cx
         rATi6m+hNw3TmQfrzMXdWySdt/rJ1ZxuwN7/1id0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Salvatore Bonaccorso <carnil@debian.org>,
        Jan Kara <jack@suse.cz>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4.14 43/53] Revert "block/loop: Use global lock for ioctl() operation."
Date:   Tue, 30 Apr 2019 13:38:50 +0200
Message-Id: <20190430113558.423604801@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113549.400132183@linuxfoundation.org>
References: <20190430113549.400132183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 57da9a9742200f391d1cf93fea389f7ddc25ec9a which is
commit 310ca162d779efee8a2dc3731439680f3e9c1e86 upstream.

Jan Kara has reported seeing problems with this patch applied, as has
Salvatore Bonaccorso, so let's drop it for now.

Reported-by: Salvatore Bonaccorso <carnil@debian.org>
Reported-by: Jan Kara <jack@suse.cz>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/loop.c |   58 +++++++++++++++++++++++++--------------------------
 drivers/block/loop.h |    1 
 2 files changed, 30 insertions(+), 29 deletions(-)

--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -82,7 +82,6 @@
 
 static DEFINE_IDR(loop_index_idr);
 static DEFINE_MUTEX(loop_index_mutex);
-static DEFINE_MUTEX(loop_ctl_mutex);
 
 static int max_part;
 static int part_shift;
@@ -1019,7 +1018,7 @@ static int loop_clr_fd(struct loop_devic
 	 */
 	if (atomic_read(&lo->lo_refcnt) > 1) {
 		lo->lo_flags |= LO_FLAGS_AUTOCLEAR;
-		mutex_unlock(&loop_ctl_mutex);
+		mutex_unlock(&lo->lo_ctl_mutex);
 		return 0;
 	}
 
@@ -1071,12 +1070,12 @@ static int loop_clr_fd(struct loop_devic
 	if (!part_shift)
 		lo->lo_disk->flags |= GENHD_FL_NO_PART_SCAN;
 	loop_unprepare_queue(lo);
-	mutex_unlock(&loop_ctl_mutex);
+	mutex_unlock(&lo->lo_ctl_mutex);
 	/*
-	 * Need not hold loop_ctl_mutex to fput backing file.
-	 * Calling fput holding loop_ctl_mutex triggers a circular
+	 * Need not hold lo_ctl_mutex to fput backing file.
+	 * Calling fput holding lo_ctl_mutex triggers a circular
 	 * lock dependency possibility warning as fput can take
-	 * bd_mutex which is usually taken before loop_ctl_mutex.
+	 * bd_mutex which is usually taken before lo_ctl_mutex.
 	 */
 	fput(filp);
 	return 0;
@@ -1195,7 +1194,7 @@ loop_get_status(struct loop_device *lo,
 	int ret;
 
 	if (lo->lo_state != Lo_bound) {
-		mutex_unlock(&loop_ctl_mutex);
+		mutex_unlock(&lo->lo_ctl_mutex);
 		return -ENXIO;
 	}
 
@@ -1214,10 +1213,10 @@ loop_get_status(struct loop_device *lo,
 		       lo->lo_encrypt_key_size);
 	}
 
-	/* Drop loop_ctl_mutex while we call into the filesystem. */
+	/* Drop lo_ctl_mutex while we call into the filesystem. */
 	path = lo->lo_backing_file->f_path;
 	path_get(&path);
-	mutex_unlock(&loop_ctl_mutex);
+	mutex_unlock(&lo->lo_ctl_mutex);
 	ret = vfs_getattr(&path, &stat, STATX_INO, AT_STATX_SYNC_AS_STAT);
 	if (!ret) {
 		info->lo_device = huge_encode_dev(stat.dev);
@@ -1309,7 +1308,7 @@ loop_get_status_old(struct loop_device *
 	int err;
 
 	if (!arg) {
-		mutex_unlock(&loop_ctl_mutex);
+		mutex_unlock(&lo->lo_ctl_mutex);
 		return -EINVAL;
 	}
 	err = loop_get_status(lo, &info64);
@@ -1327,7 +1326,7 @@ loop_get_status64(struct loop_device *lo
 	int err;
 
 	if (!arg) {
-		mutex_unlock(&loop_ctl_mutex);
+		mutex_unlock(&lo->lo_ctl_mutex);
 		return -EINVAL;
 	}
 	err = loop_get_status(lo, &info64);
@@ -1402,7 +1401,7 @@ static int lo_ioctl(struct block_device
 	struct loop_device *lo = bdev->bd_disk->private_data;
 	int err;
 
-	mutex_lock_nested(&loop_ctl_mutex, 1);
+	mutex_lock_nested(&lo->lo_ctl_mutex, 1);
 	switch (cmd) {
 	case LOOP_SET_FD:
 		err = loop_set_fd(lo, mode, bdev, arg);
@@ -1411,7 +1410,7 @@ static int lo_ioctl(struct block_device
 		err = loop_change_fd(lo, bdev, arg);
 		break;
 	case LOOP_CLR_FD:
-		/* loop_clr_fd would have unlocked loop_ctl_mutex on success */
+		/* loop_clr_fd would have unlocked lo_ctl_mutex on success */
 		err = loop_clr_fd(lo);
 		if (!err)
 			goto out_unlocked;
@@ -1424,7 +1423,7 @@ static int lo_ioctl(struct block_device
 		break;
 	case LOOP_GET_STATUS:
 		err = loop_get_status_old(lo, (struct loop_info __user *) arg);
-		/* loop_get_status() unlocks loop_ctl_mutex */
+		/* loop_get_status() unlocks lo_ctl_mutex */
 		goto out_unlocked;
 	case LOOP_SET_STATUS64:
 		err = -EPERM;
@@ -1434,7 +1433,7 @@ static int lo_ioctl(struct block_device
 		break;
 	case LOOP_GET_STATUS64:
 		err = loop_get_status64(lo, (struct loop_info64 __user *) arg);
-		/* loop_get_status() unlocks loop_ctl_mutex */
+		/* loop_get_status() unlocks lo_ctl_mutex */
 		goto out_unlocked;
 	case LOOP_SET_CAPACITY:
 		err = -EPERM;
@@ -1454,7 +1453,7 @@ static int lo_ioctl(struct block_device
 	default:
 		err = lo->ioctl ? lo->ioctl(lo, cmd, arg) : -EINVAL;
 	}
-	mutex_unlock(&loop_ctl_mutex);
+	mutex_unlock(&lo->lo_ctl_mutex);
 
 out_unlocked:
 	return err;
@@ -1571,7 +1570,7 @@ loop_get_status_compat(struct loop_devic
 	int err;
 
 	if (!arg) {
-		mutex_unlock(&loop_ctl_mutex);
+		mutex_unlock(&lo->lo_ctl_mutex);
 		return -EINVAL;
 	}
 	err = loop_get_status(lo, &info64);
@@ -1588,16 +1587,16 @@ static int lo_compat_ioctl(struct block_
 
 	switch(cmd) {
 	case LOOP_SET_STATUS:
-		mutex_lock(&loop_ctl_mutex);
+		mutex_lock(&lo->lo_ctl_mutex);
 		err = loop_set_status_compat(
 			lo, (const struct compat_loop_info __user *) arg);
-		mutex_unlock(&loop_ctl_mutex);
+		mutex_unlock(&lo->lo_ctl_mutex);
 		break;
 	case LOOP_GET_STATUS:
-		mutex_lock(&loop_ctl_mutex);
+		mutex_lock(&lo->lo_ctl_mutex);
 		err = loop_get_status_compat(
 			lo, (struct compat_loop_info __user *) arg);
-		/* loop_get_status() unlocks loop_ctl_mutex */
+		/* loop_get_status() unlocks lo_ctl_mutex */
 		break;
 	case LOOP_SET_CAPACITY:
 	case LOOP_CLR_FD:
@@ -1641,7 +1640,7 @@ static void __lo_release(struct loop_dev
 	if (atomic_dec_return(&lo->lo_refcnt))
 		return;
 
-	mutex_lock(&loop_ctl_mutex);
+	mutex_lock(&lo->lo_ctl_mutex);
 	if (lo->lo_flags & LO_FLAGS_AUTOCLEAR) {
 		/*
 		 * In autoclear mode, stop the loop thread
@@ -1659,7 +1658,7 @@ static void __lo_release(struct loop_dev
 		blk_mq_unfreeze_queue(lo->lo_queue);
 	}
 
-	mutex_unlock(&loop_ctl_mutex);
+	mutex_unlock(&lo->lo_ctl_mutex);
 }
 
 static void lo_release(struct gendisk *disk, fmode_t mode)
@@ -1705,10 +1704,10 @@ static int unregister_transfer_cb(int id
 	struct loop_device *lo = ptr;
 	struct loop_func_table *xfer = data;
 
-	mutex_lock(&loop_ctl_mutex);
+	mutex_lock(&lo->lo_ctl_mutex);
 	if (lo->lo_encryption == xfer)
 		loop_release_xfer(lo);
-	mutex_unlock(&loop_ctl_mutex);
+	mutex_unlock(&lo->lo_ctl_mutex);
 	return 0;
 }
 
@@ -1881,6 +1880,7 @@ static int loop_add(struct loop_device *
 	if (!part_shift)
 		disk->flags |= GENHD_FL_NO_PART_SCAN;
 	disk->flags |= GENHD_FL_EXT_DEVT;
+	mutex_init(&lo->lo_ctl_mutex);
 	atomic_set(&lo->lo_refcnt, 0);
 	lo->lo_number		= i;
 	spin_lock_init(&lo->lo_lock);
@@ -1993,19 +1993,19 @@ static long loop_control_ioctl(struct fi
 		ret = loop_lookup(&lo, parm);
 		if (ret < 0)
 			break;
-		mutex_lock(&loop_ctl_mutex);
+		mutex_lock(&lo->lo_ctl_mutex);
 		if (lo->lo_state != Lo_unbound) {
 			ret = -EBUSY;
-			mutex_unlock(&loop_ctl_mutex);
+			mutex_unlock(&lo->lo_ctl_mutex);
 			break;
 		}
 		if (atomic_read(&lo->lo_refcnt) > 0) {
 			ret = -EBUSY;
-			mutex_unlock(&loop_ctl_mutex);
+			mutex_unlock(&lo->lo_ctl_mutex);
 			break;
 		}
 		lo->lo_disk->private_data = NULL;
-		mutex_unlock(&loop_ctl_mutex);
+		mutex_unlock(&lo->lo_ctl_mutex);
 		idr_remove(&loop_index_idr, lo->lo_number);
 		loop_remove(lo);
 		break;
--- a/drivers/block/loop.h
+++ b/drivers/block/loop.h
@@ -54,6 +54,7 @@ struct loop_device {
 
 	spinlock_t		lo_lock;
 	int			lo_state;
+	struct mutex		lo_ctl_mutex;
 	struct kthread_worker	worker;
 	struct task_struct	*worker_task;
 	bool			use_dio;


