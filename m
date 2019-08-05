Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1F2581CC2
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:27:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730631AbfHENZc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:25:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:34026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730801AbfHENZ3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:25:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CEF5120644;
        Mon,  5 Aug 2019 13:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565011528;
        bh=ue8M6fAPwJ2UPAAvXxZMUClM5SYWBiQ6eKDMyOYP5vc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FayOv8xXTQQDXU2pf01zCj8e9Ka9cY5u7jbh9B86SeTRl3wc6P3owFoDZdc0MIfgA
         77BtyiQ6H8HCvFYZB8eKeMsZBRQISOI6cPRXlwqast6ytnEz+PT5YGWpRpuiU4pOZt
         seGtMpLuQfJ5lAN7jV/tTx6Y3zKbN+CDoG8saOgY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.2 105/131] loop: Fix mount(2) failure due to race with LOOP_SET_FD
Date:   Mon,  5 Aug 2019 15:03:12 +0200
Message-Id: <20190805124959.005408571@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124951.453337465@linuxfoundation.org>
References: <20190805124951.453337465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit 89e524c04fa966330e2e80ab2bc50b9944c5847a upstream.

Commit 33ec3e53e7b1 ("loop: Don't change loop device under exclusive
opener") made LOOP_SET_FD ioctl acquire exclusive block device reference
while it updates loop device binding. However this can make perfectly
valid mount(2) fail with EBUSY due to racing LOOP_SET_FD holding
temporarily the exclusive bdev reference in cases like this:

for i in {a..z}{a..z}; do
        dd if=/dev/zero of=$i.image bs=1k count=0 seek=1024
        mkfs.ext2 $i.image
        mkdir mnt$i
done

echo "Run"
for i in {a..z}{a..z}; do
        mount -o loop -t ext2 $i.image mnt$i &
done

Fix the problem by not getting full exclusive bdev reference in
LOOP_SET_FD but instead just mark the bdev as being claimed while we
update the binding information. This just blocks new exclusive openers
instead of failing them with EBUSY thus fixing the problem.

Fixes: 33ec3e53e7b1 ("loop: Don't change loop device under exclusive opener")
Cc: stable@vger.kernel.org
Tested-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/loop.c |   16 +++++----
 fs/block_dev.c       |   83 +++++++++++++++++++++++++++++++++++----------------
 include/linux/fs.h   |    6 +++
 3 files changed, 73 insertions(+), 32 deletions(-)

--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -932,6 +932,7 @@ static int loop_set_fd(struct loop_devic
 	struct file	*file;
 	struct inode	*inode;
 	struct address_space *mapping;
+	struct block_device *claimed_bdev = NULL;
 	int		lo_flags = 0;
 	int		error;
 	loff_t		size;
@@ -950,10 +951,11 @@ static int loop_set_fd(struct loop_devic
 	 * here to avoid changing device under exclusive owner.
 	 */
 	if (!(mode & FMODE_EXCL)) {
-		bdgrab(bdev);
-		error = blkdev_get(bdev, mode | FMODE_EXCL, loop_set_fd);
-		if (error)
+		claimed_bdev = bd_start_claiming(bdev, loop_set_fd);
+		if (IS_ERR(claimed_bdev)) {
+			error = PTR_ERR(claimed_bdev);
 			goto out_putf;
+		}
 	}
 
 	error = mutex_lock_killable(&loop_ctl_mutex);
@@ -1023,15 +1025,15 @@ static int loop_set_fd(struct loop_devic
 	mutex_unlock(&loop_ctl_mutex);
 	if (partscan)
 		loop_reread_partitions(lo, bdev);
-	if (!(mode & FMODE_EXCL))
-		blkdev_put(bdev, mode | FMODE_EXCL);
+	if (claimed_bdev)
+		bd_abort_claiming(bdev, claimed_bdev, loop_set_fd);
 	return 0;
 
 out_unlock:
 	mutex_unlock(&loop_ctl_mutex);
 out_bdev:
-	if (!(mode & FMODE_EXCL))
-		blkdev_put(bdev, mode | FMODE_EXCL);
+	if (claimed_bdev)
+		bd_abort_claiming(bdev, claimed_bdev, loop_set_fd);
 out_putf:
 	fput(file);
 out:
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1151,8 +1151,7 @@ static struct gendisk *bdev_get_gendisk(
  * Pointer to the block device containing @bdev on success, ERR_PTR()
  * value on failure.
  */
-static struct block_device *bd_start_claiming(struct block_device *bdev,
-					      void *holder)
+struct block_device *bd_start_claiming(struct block_device *bdev, void *holder)
 {
 	struct gendisk *disk;
 	struct block_device *whole;
@@ -1199,6 +1198,62 @@ static struct block_device *bd_start_cla
 		return ERR_PTR(err);
 	}
 }
+EXPORT_SYMBOL(bd_start_claiming);
+
+static void bd_clear_claiming(struct block_device *whole, void *holder)
+{
+	lockdep_assert_held(&bdev_lock);
+	/* tell others that we're done */
+	BUG_ON(whole->bd_claiming != holder);
+	whole->bd_claiming = NULL;
+	wake_up_bit(&whole->bd_claiming, 0);
+}
+
+/**
+ * bd_finish_claiming - finish claiming of a block device
+ * @bdev: block device of interest
+ * @whole: whole block device (returned from bd_start_claiming())
+ * @holder: holder that has claimed @bdev
+ *
+ * Finish exclusive open of a block device. Mark the device as exlusively
+ * open by the holder and wake up all waiters for exclusive open to finish.
+ */
+void bd_finish_claiming(struct block_device *bdev, struct block_device *whole,
+			void *holder)
+{
+	spin_lock(&bdev_lock);
+	BUG_ON(!bd_may_claim(bdev, whole, holder));
+	/*
+	 * Note that for a whole device bd_holders will be incremented twice,
+	 * and bd_holder will be set to bd_may_claim before being set to holder
+	 */
+	whole->bd_holders++;
+	whole->bd_holder = bd_may_claim;
+	bdev->bd_holders++;
+	bdev->bd_holder = holder;
+	bd_clear_claiming(whole, holder);
+	spin_unlock(&bdev_lock);
+}
+EXPORT_SYMBOL(bd_finish_claiming);
+
+/**
+ * bd_abort_claiming - abort claiming of a block device
+ * @bdev: block device of interest
+ * @whole: whole block device (returned from bd_start_claiming())
+ * @holder: holder that has claimed @bdev
+ *
+ * Abort claiming of a block device when the exclusive open failed. This can be
+ * also used when exclusive open is not actually desired and we just needed
+ * to block other exclusive openers for a while.
+ */
+void bd_abort_claiming(struct block_device *bdev, struct block_device *whole,
+		       void *holder)
+{
+	spin_lock(&bdev_lock);
+	bd_clear_claiming(whole, holder);
+	spin_unlock(&bdev_lock);
+}
+EXPORT_SYMBOL(bd_abort_claiming);
 
 #ifdef CONFIG_SYSFS
 struct bd_holder_disk {
@@ -1668,29 +1723,7 @@ int blkdev_get(struct block_device *bdev
 
 		/* finish claiming */
 		mutex_lock(&bdev->bd_mutex);
-		spin_lock(&bdev_lock);
-
-		if (!res) {
-			BUG_ON(!bd_may_claim(bdev, whole, holder));
-			/*
-			 * Note that for a whole device bd_holders
-			 * will be incremented twice, and bd_holder
-			 * will be set to bd_may_claim before being
-			 * set to holder
-			 */
-			whole->bd_holders++;
-			whole->bd_holder = bd_may_claim;
-			bdev->bd_holders++;
-			bdev->bd_holder = holder;
-		}
-
-		/* tell others that we're done */
-		BUG_ON(whole->bd_claiming != holder);
-		whole->bd_claiming = NULL;
-		wake_up_bit(&whole->bd_claiming, 0);
-
-		spin_unlock(&bdev_lock);
-
+		bd_finish_claiming(bdev, whole, holder);
 		/*
 		 * Block event polling for write claims if requested.  Any
 		 * write holder makes the write_holder state stick until
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2615,6 +2615,12 @@ extern struct block_device *blkdev_get_b
 					       void *holder);
 extern struct block_device *blkdev_get_by_dev(dev_t dev, fmode_t mode,
 					      void *holder);
+extern struct block_device *bd_start_claiming(struct block_device *bdev,
+					      void *holder);
+extern void bd_finish_claiming(struct block_device *bdev,
+			       struct block_device *whole, void *holder);
+extern void bd_abort_claiming(struct block_device *bdev,
+			      struct block_device *whole, void *holder);
 extern void blkdev_put(struct block_device *bdev, fmode_t mode);
 extern int __blkdev_reread_part(struct block_device *bdev);
 extern int blkdev_reread_part(struct block_device *bdev);


