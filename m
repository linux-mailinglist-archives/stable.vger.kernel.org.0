Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 242B63DD9E7
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 16:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235367AbhHBOFL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 10:05:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:48968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235486AbhHBODO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 10:03:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17FC360551;
        Mon,  2 Aug 2021 13:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912631;
        bh=N8TZwqxWv/Mj7Nctq8My+V1fSQrRPpj02DnZFc4aXxY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2OT+Zku+VdYJKQB3f1ETii3QiinuDb5XuAkjCsERil3p9zOVGqJNEtUyuVR3KQhof
         9z0WpwyP/RK9qeKUHdjyUP31oBfYG0PBJBM89iyrqijDgaCc5f0cwyNpPulN8txuVr
         xpyWSdKEVziSI6Vh3fKVu3qTkg/OtpnGYaQOzuZI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 053/104] loop: reintroduce global lock for safe loop_validate_file() traversal
Date:   Mon,  2 Aug 2021 15:44:50 +0200
Message-Id: <20210802134345.762851793@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134344.028226640@linuxfoundation.org>
References: <20210802134344.028226640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>

[ Upstream commit 3ce6e1f662a910970880188ea7bfd00542bd3934 ]

Commit 6cc8e7430801fa23 ("loop: scale loop device by introducing per
device lock") re-opened a race window for NULL pointer dereference at
loop_validate_file() where commit 310ca162d779efee ("block/loop: Use
global lock for ioctl() operation.") has closed.

Although we need to guarantee that other loop devices will not change
during traversal, we can't take remote "struct loop_device"->lo_mutex
inside loop_validate_file() in order to avoid AB-BA deadlock. Therefore,
introduce a global lock dedicated for loop_validate_file() which is
conditionally taken before local "struct loop_device"->lo_mutex is taken.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Fixes: 6cc8e7430801fa23 ("loop: scale loop device by introducing per device lock")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/loop.c | 128 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 97 insertions(+), 31 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 8271df125153..e81298b91227 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -86,6 +86,47 @@
 
 static DEFINE_IDR(loop_index_idr);
 static DEFINE_MUTEX(loop_ctl_mutex);
+static DEFINE_MUTEX(loop_validate_mutex);
+
+/**
+ * loop_global_lock_killable() - take locks for safe loop_validate_file() test
+ *
+ * @lo: struct loop_device
+ * @global: true if @lo is about to bind another "struct loop_device", false otherwise
+ *
+ * Returns 0 on success, -EINTR otherwise.
+ *
+ * Since loop_validate_file() traverses on other "struct loop_device" if
+ * is_loop_device() is true, we need a global lock for serializing concurrent
+ * loop_configure()/loop_change_fd()/__loop_clr_fd() calls.
+ */
+static int loop_global_lock_killable(struct loop_device *lo, bool global)
+{
+	int err;
+
+	if (global) {
+		err = mutex_lock_killable(&loop_validate_mutex);
+		if (err)
+			return err;
+	}
+	err = mutex_lock_killable(&lo->lo_mutex);
+	if (err && global)
+		mutex_unlock(&loop_validate_mutex);
+	return err;
+}
+
+/**
+ * loop_global_unlock() - release locks taken by loop_global_lock_killable()
+ *
+ * @lo: struct loop_device
+ * @global: true if @lo was about to bind another "struct loop_device", false otherwise
+ */
+static void loop_global_unlock(struct loop_device *lo, bool global)
+{
+	mutex_unlock(&lo->lo_mutex);
+	if (global)
+		mutex_unlock(&loop_validate_mutex);
+}
 
 static int max_part;
 static int part_shift;
@@ -676,13 +717,15 @@ static int loop_validate_file(struct file *file, struct block_device *bdev)
 	while (is_loop_device(f)) {
 		struct loop_device *l;
 
+		lockdep_assert_held(&loop_validate_mutex);
 		if (f->f_mapping->host->i_rdev == bdev->bd_dev)
 			return -EBADF;
 
 		l = I_BDEV(f->f_mapping->host)->bd_disk->private_data;
-		if (l->lo_state != Lo_bound) {
+		if (l->lo_state != Lo_bound)
 			return -EINVAL;
-		}
+		/* Order wrt setting lo->lo_backing_file in loop_configure(). */
+		rmb();
 		f = l->lo_backing_file;
 	}
 	if (!S_ISREG(inode->i_mode) && !S_ISBLK(inode->i_mode))
@@ -701,13 +744,18 @@ static int loop_validate_file(struct file *file, struct block_device *bdev)
 static int loop_change_fd(struct loop_device *lo, struct block_device *bdev,
 			  unsigned int arg)
 {
-	struct file	*file = NULL, *old_file;
-	int		error;
-	bool		partscan;
+	struct file *file = fget(arg);
+	struct file *old_file;
+	int error;
+	bool partscan;
+	bool is_loop;
 
-	error = mutex_lock_killable(&lo->lo_mutex);
+	if (!file)
+		return -EBADF;
+	is_loop = is_loop_device(file);
+	error = loop_global_lock_killable(lo, is_loop);
 	if (error)
-		return error;
+		goto out_putf;
 	error = -ENXIO;
 	if (lo->lo_state != Lo_bound)
 		goto out_err;
@@ -717,11 +765,6 @@ static int loop_change_fd(struct loop_device *lo, struct block_device *bdev,
 	if (!(lo->lo_flags & LO_FLAGS_READ_ONLY))
 		goto out_err;
 
-	error = -EBADF;
-	file = fget(arg);
-	if (!file)
-		goto out_err;
-
 	error = loop_validate_file(file, bdev);
 	if (error)
 		goto out_err;
@@ -744,7 +787,16 @@ static int loop_change_fd(struct loop_device *lo, struct block_device *bdev,
 	loop_update_dio(lo);
 	blk_mq_unfreeze_queue(lo->lo_queue);
 	partscan = lo->lo_flags & LO_FLAGS_PARTSCAN;
-	mutex_unlock(&lo->lo_mutex);
+	loop_global_unlock(lo, is_loop);
+
+	/*
+	 * Flush loop_validate_file() before fput(), for l->lo_backing_file
+	 * might be pointing at old_file which might be the last reference.
+	 */
+	if (!is_loop) {
+		mutex_lock(&loop_validate_mutex);
+		mutex_unlock(&loop_validate_mutex);
+	}
 	/*
 	 * We must drop file reference outside of lo_mutex as dropping
 	 * the file ref can take bd_mutex which creates circular locking
@@ -756,9 +808,9 @@ static int loop_change_fd(struct loop_device *lo, struct block_device *bdev,
 	return 0;
 
 out_err:
-	mutex_unlock(&lo->lo_mutex);
-	if (file)
-		fput(file);
+	loop_global_unlock(lo, is_loop);
+out_putf:
+	fput(file);
 	return error;
 }
 
@@ -1067,22 +1119,22 @@ static int loop_configure(struct loop_device *lo, fmode_t mode,
 			  struct block_device *bdev,
 			  const struct loop_config *config)
 {
-	struct file	*file;
-	struct inode	*inode;
+	struct file *file = fget(config->fd);
+	struct inode *inode;
 	struct address_space *mapping;
-	int		error;
-	loff_t		size;
-	bool		partscan;
-	unsigned short  bsize;
+	int error;
+	loff_t size;
+	bool partscan;
+	unsigned short bsize;
+	bool is_loop;
+
+	if (!file)
+		return -EBADF;
+	is_loop = is_loop_device(file);
 
 	/* This is safe, since we have a reference from open(). */
 	__module_get(THIS_MODULE);
 
-	error = -EBADF;
-	file = fget(config->fd);
-	if (!file)
-		goto out;
-
 	/*
 	 * If we don't hold exclusive handle for the device, upgrade to it
 	 * here to avoid changing device under exclusive owner.
@@ -1093,7 +1145,7 @@ static int loop_configure(struct loop_device *lo, fmode_t mode,
 			goto out_putf;
 	}
 
-	error = mutex_lock_killable(&lo->lo_mutex);
+	error = loop_global_lock_killable(lo, is_loop);
 	if (error)
 		goto out_bdev;
 
@@ -1162,6 +1214,9 @@ static int loop_configure(struct loop_device *lo, fmode_t mode,
 	size = get_loop_size(lo, file);
 	loop_set_size(lo, size);
 
+	/* Order wrt reading lo_state in loop_validate_file(). */
+	wmb();
+
 	lo->lo_state = Lo_bound;
 	if (part_shift)
 		lo->lo_flags |= LO_FLAGS_PARTSCAN;
@@ -1173,7 +1228,7 @@ static int loop_configure(struct loop_device *lo, fmode_t mode,
 	 * put /dev/loopXX inode. Later in __loop_clr_fd() we bdput(bdev).
 	 */
 	bdgrab(bdev);
-	mutex_unlock(&lo->lo_mutex);
+	loop_global_unlock(lo, is_loop);
 	if (partscan)
 		loop_reread_partitions(lo, bdev);
 	if (!(mode & FMODE_EXCL))
@@ -1181,13 +1236,12 @@ static int loop_configure(struct loop_device *lo, fmode_t mode,
 	return 0;
 
 out_unlock:
-	mutex_unlock(&lo->lo_mutex);
+	loop_global_unlock(lo, is_loop);
 out_bdev:
 	if (!(mode & FMODE_EXCL))
 		bd_abort_claiming(bdev, loop_configure);
 out_putf:
 	fput(file);
-out:
 	/* This is safe: open() is still holding a reference. */
 	module_put(THIS_MODULE);
 	return error;
@@ -1202,6 +1256,18 @@ static int __loop_clr_fd(struct loop_device *lo, bool release)
 	bool partscan = false;
 	int lo_number;
 
+	/*
+	 * Flush loop_configure() and loop_change_fd(). It is acceptable for
+	 * loop_validate_file() to succeed, for actual clear operation has not
+	 * started yet.
+	 */
+	mutex_lock(&loop_validate_mutex);
+	mutex_unlock(&loop_validate_mutex);
+	/*
+	 * loop_validate_file() now fails because l->lo_state != Lo_bound
+	 * became visible.
+	 */
+
 	mutex_lock(&lo->lo_mutex);
 	if (WARN_ON_ONCE(lo->lo_state != Lo_rundown)) {
 		err = -ENXIO;
-- 
2.30.2



