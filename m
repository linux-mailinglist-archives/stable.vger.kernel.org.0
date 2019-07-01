Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10B9E1F443
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbfEOK6C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 06:58:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:54066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726554AbfEOK6B (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 06:58:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 653E92084F;
        Wed, 15 May 2019 10:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557917879;
        bh=4nYzT3hBUW6dJrK0dpt1StN4Zm2BHi/HabEiP2xWb/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZNnGy9wA6zJDpXr9Tsih6ynkUXcand5YtXLytikAZi+gHNEyRxuU+ikafd7Ce3KL2
         wNzLIWK5P7Dij1ui3Ry+dmm7B6+rklLF/kMLWADELSE0eMK3Mk25XjvvAfIui3cEP/
         A4alOHOuKBRA8mlpWpAzNu8YtpU8KDvmM/aTaW0E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Salvatore Bonaccorso <carnil@debian.org>,
        Jan Kara <jack@suse.cz>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3.18 10/86] Revert "block/loop: Use global lock for ioctl() operation."
Date:   Wed, 15 May 2019 12:54:47 +0200
Message-Id: <20190515090644.528795270@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090642.339346723@linuxfoundation.org>
References: <20190515090642.339346723@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit a17189a0e107ee316b3fff61217f5a037357d65e which is
commit 310ca162d779efee8a2dc3731439680f3e9c1e86 upstream.

Jan Kara has reported seeing problems with this patch applied, as has
Salvatore Bonaccorso, so let's drop it for now.

Reported-by: Salvatore Bonaccorso <carnil@debian.org>
Reported-by: Jan Kara <jack@suse.cz>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/loop.c |   47 +++++++++++++++++++++++------------------------
 drivers/block/loop.h |    1 +
 2 files changed, 24 insertions(+), 24 deletions(-)

--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -81,7 +81,6 @@
 
 static DEFINE_IDR(loop_index_idr);
 static DEFINE_MUTEX(loop_index_mutex);
-static DEFINE_MUTEX(loop_ctl_mutex);
 
 static int max_part;
 static int part_shift;
@@ -1013,7 +1012,7 @@ static int loop_clr_fd(struct loop_devic
 	 */
 	if (lo->lo_refcnt > 1) {
 		lo->lo_flags |= LO_FLAGS_AUTOCLEAR;
-		mutex_unlock(&loop_ctl_mutex);
+		mutex_unlock(&lo->lo_ctl_mutex);
 		return 0;
 	}
 
@@ -1062,12 +1061,12 @@ static int loop_clr_fd(struct loop_devic
 	lo->lo_flags = 0;
 	if (!part_shift)
 		lo->lo_disk->flags |= GENHD_FL_NO_PART_SCAN;
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
@@ -1301,7 +1300,7 @@ static int lo_ioctl(struct block_device
 	struct loop_device *lo = bdev->bd_disk->private_data;
 	int err;
 
-	mutex_lock_nested(&loop_ctl_mutex, 1);
+	mutex_lock_nested(&lo->lo_ctl_mutex, 1);
 	switch (cmd) {
 	case LOOP_SET_FD:
 		err = loop_set_fd(lo, mode, bdev, arg);
@@ -1310,7 +1309,7 @@ static int lo_ioctl(struct block_device
 		err = loop_change_fd(lo, bdev, arg);
 		break;
 	case LOOP_CLR_FD:
-		/* loop_clr_fd would have unlocked loop_ctl_mutex on success */
+		/* loop_clr_fd would have unlocked lo_ctl_mutex on success */
 		err = loop_clr_fd(lo);
 		if (!err)
 			goto out_unlocked;
@@ -1341,7 +1340,7 @@ static int lo_ioctl(struct block_device
 	default:
 		err = lo->ioctl ? lo->ioctl(lo, cmd, arg) : -EINVAL;
 	}
-	mutex_unlock(&loop_ctl_mutex);
+	mutex_unlock(&lo->lo_ctl_mutex);
 
 out_unlocked:
 	return err;
@@ -1474,16 +1473,16 @@ static int lo_compat_ioctl(struct block_
 
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
-		mutex_unlock(&loop_ctl_mutex);
+		mutex_unlock(&lo->lo_ctl_mutex);
 		break;
 	case LOOP_SET_CAPACITY:
 	case LOOP_CLR_FD:
@@ -1514,9 +1513,9 @@ static int lo_open(struct block_device *
 		goto out;
 	}
 
-	mutex_lock(&loop_ctl_mutex);
+	mutex_lock(&lo->lo_ctl_mutex);
 	lo->lo_refcnt++;
-	mutex_unlock(&loop_ctl_mutex);
+	mutex_unlock(&lo->lo_ctl_mutex);
 out:
 	mutex_unlock(&loop_index_mutex);
 	return err;
@@ -1526,7 +1525,7 @@ static void __lo_release(struct loop_dev
 {
 	int err;
 
-	mutex_lock(&loop_ctl_mutex);
+	mutex_lock(&lo->lo_ctl_mutex);
 
 	if (--lo->lo_refcnt)
 		goto out;
@@ -1548,7 +1547,7 @@ static void __lo_release(struct loop_dev
 	}
 
 out:
-	mutex_unlock(&loop_ctl_mutex);
+	mutex_unlock(&lo->lo_ctl_mutex);
 }
 
 static void lo_release(struct gendisk *disk, fmode_t mode)
@@ -1594,10 +1593,10 @@ static int unregister_transfer_cb(int id
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
 
@@ -1678,7 +1677,7 @@ static int loop_add(struct loop_device *
 	if (!part_shift)
 		disk->flags |= GENHD_FL_NO_PART_SCAN;
 	disk->flags |= GENHD_FL_EXT_DEVT;
-	mutex_init(&loop_ctl_mutex);
+	mutex_init(&lo->lo_ctl_mutex);
 	lo->lo_number		= i;
 	lo->lo_thread		= NULL;
 	init_waitqueue_head(&lo->lo_event);
@@ -1790,19 +1789,19 @@ static long loop_control_ioctl(struct fi
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
 		if (lo->lo_refcnt > 0) {
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
@@ -55,6 +55,7 @@ struct loop_device {
 	struct bio_list		lo_bio_list;
 	unsigned int		lo_bio_count;
 	int			lo_state;
+	struct mutex		lo_ctl_mutex;
 	struct task_struct	*lo_thread;
 	wait_queue_head_t	lo_event;
 	/* wait queue for incoming requests */


