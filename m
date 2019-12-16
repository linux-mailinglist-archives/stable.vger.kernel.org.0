Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E64F121886
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:44:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728617AbfLPR6c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 12:58:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:58322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728001AbfLPR6b (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 12:58:31 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE0B421582;
        Mon, 16 Dec 2019 17:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519110;
        bh=8SZW3rTA8io7BWtFP9Tek6UH24tOYQpNUhhqUpw4tf0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JReg8zzbI6fytj9yZyiurTIGRnjB+BByDyAJIDQ3vZdH7HvViuEAIRmjkEjvqzbmX
         rzJ9YD4/E13W9WCu7KfMExPOK0CEtecV5bciWvAFcJYQv5scFP5eOYOfSyB5jyrxSQ
         zMBbgC4D5nWBwT6UREvgQO/vcJh39mFMYc6TMtxs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, zhangxiaoxu <zhangxiaoxu5@huawei.com>,
        Dmitry Fomichev <dmitry.fomichev@wdc.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 4.14 200/267] dm zoned: reduce overhead of backing device checks
Date:   Mon, 16 Dec 2019 18:48:46 +0100
Message-Id: <20191216174913.491643559@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
References: <20191216174848.701533383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Fomichev <dmitry.fomichev@wdc.com>

commit e7fad909b68aa37470d9f2d2731b5bec355ee5d6 upstream.

Commit 75d66ffb48efb3 added backing device health checks and as a part
of these checks, check_events() block ops template call is invoked in
dm-zoned mapping path as well as in reclaim and flush path. Calling
check_events() with ATA or SCSI backing devices introduces a blocking
scsi_test_unit_ready() call being made in sd_check_events(). Even though
the overhead of calling scsi_test_unit_ready() is small for ATA zoned
devices, it is much larger for SCSI and it affects performance in a very
negative way.

Fix this performance regression by executing check_events() only in case
of any I/O errors. The function dmz_bdev_is_dying() is modified to call
only blk_queue_dying(), while calls to check_events() are made in a new
helper function, dmz_check_bdev().

Reported-by: zhangxiaoxu <zhangxiaoxu5@huawei.com>
Fixes: 75d66ffb48efb3 ("dm zoned: properly handle backing device failure")
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-zoned-metadata.c |   29 ++++++++++++++--------
 drivers/md/dm-zoned-reclaim.c  |    8 +-----
 drivers/md/dm-zoned-target.c   |   54 ++++++++++++++++++++++++++++-------------
 drivers/md/dm-zoned.h          |    2 +
 4 files changed, 61 insertions(+), 32 deletions(-)

--- a/drivers/md/dm-zoned-metadata.c
+++ b/drivers/md/dm-zoned-metadata.c
@@ -552,6 +552,7 @@ static struct dmz_mblock *dmz_get_mblock
 		       TASK_UNINTERRUPTIBLE);
 	if (test_bit(DMZ_META_ERROR, &mblk->state)) {
 		dmz_release_mblock(zmd, mblk);
+		dmz_check_bdev(zmd->dev);
 		return ERR_PTR(-EIO);
 	}
 
@@ -623,6 +624,8 @@ static int dmz_rdwr_block(struct dmz_met
 	ret = submit_bio_wait(bio);
 	bio_put(bio);
 
+	if (ret)
+		dmz_check_bdev(zmd->dev);
 	return ret;
 }
 
@@ -689,6 +692,7 @@ static int dmz_write_dirty_mblocks(struc
 			       TASK_UNINTERRUPTIBLE);
 		if (test_bit(DMZ_META_ERROR, &mblk->state)) {
 			clear_bit(DMZ_META_ERROR, &mblk->state);
+			dmz_check_bdev(zmd->dev);
 			ret = -EIO;
 		}
 		nr_mblks_submitted--;
@@ -766,7 +770,7 @@ int dmz_flush_metadata(struct dmz_metada
 	/* If there are no dirty metadata blocks, just flush the device cache */
 	if (list_empty(&write_list)) {
 		ret = blkdev_issue_flush(zmd->dev->bdev, GFP_NOIO, NULL);
-		goto out;
+		goto err;
 	}
 
 	/*
@@ -776,7 +780,7 @@ int dmz_flush_metadata(struct dmz_metada
 	 */
 	ret = dmz_log_dirty_mblocks(zmd, &write_list);
 	if (ret)
-		goto out;
+		goto err;
 
 	/*
 	 * The log is on disk. It is now safe to update in place
@@ -784,11 +788,11 @@ int dmz_flush_metadata(struct dmz_metada
 	 */
 	ret = dmz_write_dirty_mblocks(zmd, &write_list, zmd->mblk_primary);
 	if (ret)
-		goto out;
+		goto err;
 
 	ret = dmz_write_sb(zmd, zmd->mblk_primary);
 	if (ret)
-		goto out;
+		goto err;
 
 	while (!list_empty(&write_list)) {
 		mblk = list_first_entry(&write_list, struct dmz_mblock, link);
@@ -803,16 +807,20 @@ int dmz_flush_metadata(struct dmz_metada
 
 	zmd->sb_gen++;
 out:
-	if (ret && !list_empty(&write_list)) {
-		spin_lock(&zmd->mblk_lock);
-		list_splice(&write_list, &zmd->mblk_dirty_list);
-		spin_unlock(&zmd->mblk_lock);
-	}
-
 	dmz_unlock_flush(zmd);
 	up_write(&zmd->mblk_sem);
 
 	return ret;
+
+err:
+	if (!list_empty(&write_list)) {
+		spin_lock(&zmd->mblk_lock);
+		list_splice(&write_list, &zmd->mblk_dirty_list);
+		spin_unlock(&zmd->mblk_lock);
+	}
+	if (!dmz_check_bdev(zmd->dev))
+		ret = -EIO;
+	goto out;
 }
 
 /*
@@ -1235,6 +1243,7 @@ static int dmz_update_zone(struct dmz_me
 	if (ret) {
 		dmz_dev_err(zmd->dev, "Get zone %u report failed",
 			    dmz_id(zmd, zone));
+		dmz_check_bdev(zmd->dev);
 		return ret;
 	}
 
--- a/drivers/md/dm-zoned-reclaim.c
+++ b/drivers/md/dm-zoned-reclaim.c
@@ -81,6 +81,7 @@ static int dmz_reclaim_align_wp(struct d
 			    "Align zone %u wp %llu to %llu (wp+%u) blocks failed %d",
 			    dmz_id(zmd, zone), (unsigned long long)wp_block,
 			    (unsigned long long)block, nr_blocks, ret);
+		dmz_check_bdev(zrc->dev);
 		return ret;
 	}
 
@@ -490,12 +491,7 @@ static void dmz_reclaim_work(struct work
 	ret = dmz_do_reclaim(zrc);
 	if (ret) {
 		dmz_dev_debug(zrc->dev, "Reclaim error %d\n", ret);
-		if (ret == -EIO)
-			/*
-			 * LLD might be performing some error handling sequence
-			 * at the underlying device. To not interfere, do not
-			 * attempt to schedule the next reclaim run immediately.
-			 */
+		if (!dmz_check_bdev(zrc->dev))
 			return;
 	}
 
--- a/drivers/md/dm-zoned-target.c
+++ b/drivers/md/dm-zoned-target.c
@@ -79,6 +79,8 @@ static inline void dmz_bio_endio(struct
 
 	if (status != BLK_STS_OK && bio->bi_status == BLK_STS_OK)
 		bio->bi_status = status;
+	if (bio->bi_status != BLK_STS_OK)
+		bioctx->target->dev->flags |= DMZ_CHECK_BDEV;
 
 	if (atomic_dec_and_test(&bioctx->ref)) {
 		struct dm_zone *zone = bioctx->zone;
@@ -564,32 +566,52 @@ out:
 }
 
 /*
- * Check the backing device availability. If it's on the way out,
+ * Check if the backing device is being removed. If it's on the way out,
  * start failing I/O. Reclaim and metadata components also call this
  * function to cleanly abort operation in the event of such failure.
  */
 bool dmz_bdev_is_dying(struct dmz_dev *dmz_dev)
 {
-	struct gendisk *disk;
+	if (dmz_dev->flags & DMZ_BDEV_DYING)
+		return true;
 
-	if (!(dmz_dev->flags & DMZ_BDEV_DYING)) {
-		disk = dmz_dev->bdev->bd_disk;
-		if (blk_queue_dying(bdev_get_queue(dmz_dev->bdev))) {
-			dmz_dev_warn(dmz_dev, "Backing device queue dying");
-			dmz_dev->flags |= DMZ_BDEV_DYING;
-		} else if (disk->fops->check_events) {
-			if (disk->fops->check_events(disk, 0) &
-					DISK_EVENT_MEDIA_CHANGE) {
-				dmz_dev_warn(dmz_dev, "Backing device offline");
-				dmz_dev->flags |= DMZ_BDEV_DYING;
-			}
-		}
+	if (dmz_dev->flags & DMZ_CHECK_BDEV)
+		return !dmz_check_bdev(dmz_dev);
+
+	if (blk_queue_dying(bdev_get_queue(dmz_dev->bdev))) {
+		dmz_dev_warn(dmz_dev, "Backing device queue dying");
+		dmz_dev->flags |= DMZ_BDEV_DYING;
 	}
 
 	return dmz_dev->flags & DMZ_BDEV_DYING;
 }
 
 /*
+ * Check the backing device availability. This detects such events as
+ * backing device going offline due to errors, media removals, etc.
+ * This check is less efficient than dmz_bdev_is_dying() and should
+ * only be performed as a part of error handling.
+ */
+bool dmz_check_bdev(struct dmz_dev *dmz_dev)
+{
+	struct gendisk *disk;
+
+	dmz_dev->flags &= ~DMZ_CHECK_BDEV;
+
+	if (dmz_bdev_is_dying(dmz_dev))
+		return false;
+
+	disk = dmz_dev->bdev->bd_disk;
+	if (disk->fops->check_events &&
+	    disk->fops->check_events(disk, 0) & DISK_EVENT_MEDIA_CHANGE) {
+		dmz_dev_warn(dmz_dev, "Backing device offline");
+		dmz_dev->flags |= DMZ_BDEV_DYING;
+	}
+
+	return !(dmz_dev->flags & DMZ_BDEV_DYING);
+}
+
+/*
  * Process a new BIO.
  */
 static int dmz_map(struct dm_target *ti, struct bio *bio)
@@ -901,8 +923,8 @@ static int dmz_prepare_ioctl(struct dm_t
 {
 	struct dmz_target *dmz = ti->private;
 
-	if (dmz_bdev_is_dying(dmz->dev))
-		return -ENODEV;
+	if (!dmz_check_bdev(dmz->dev))
+		return -EIO;
 
 	*bdev = dmz->dev->bdev;
 
--- a/drivers/md/dm-zoned.h
+++ b/drivers/md/dm-zoned.h
@@ -71,6 +71,7 @@ struct dmz_dev {
 
 /* Device flags. */
 #define DMZ_BDEV_DYING		(1 << 0)
+#define DMZ_CHECK_BDEV		(2 << 0)
 
 /*
  * Zone descriptor.
@@ -254,5 +255,6 @@ void dmz_schedule_reclaim(struct dmz_rec
  * Functions defined in dm-zoned-target.c
  */
 bool dmz_bdev_is_dying(struct dmz_dev *dmz_dev);
+bool dmz_check_bdev(struct dmz_dev *dmz_dev);
 
 #endif /* DM_ZONED_H */


