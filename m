Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07B5D9E0D2
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733001AbfH0IGQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:06:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:36272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732235AbfH0IGP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 04:06:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3DD92206BF;
        Tue, 27 Aug 2019 08:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566893175;
        bh=p7ade5icDIxCWWzT8Cs0yTD8e4vkUPHBASVu+datN6w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=flEKsjQgAi9iYiLMPLoiM3TOvTAZZhnDohv7jt4y7e9+4XFauHnp/si2jwRHzcaKY
         GNHH5Ukw15jfL+XvIkaqzteGzmtXEYL83FsRiJ5lVvkb+uVlFJg6tyT7dwadYSL7Ez
         Qna+Ibk3iM9heiLGVVgjhQI2HOnWLhtV4K2lrAWs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Fomichev <dmitry.fomichev@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.2 144/162] dm zoned: properly handle backing device failure
Date:   Tue, 27 Aug 2019 09:51:12 +0200
Message-Id: <20190827072743.708091391@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072738.093683223@linuxfoundation.org>
References: <20190827072738.093683223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Fomichev <dmitry.fomichev@wdc.com>

commit 75d66ffb48efb30f2dd42f041ba8b39c5b2bd115 upstream.

dm-zoned is observed to lock up or livelock in case of hardware
failure or some misconfiguration of the backing zoned device.

This patch adds a new dm-zoned target function that checks the status of
the backing device. If the request queue of the backing device is found
to be in dying state or the SCSI backing device enters offline state,
the health check code sets a dm-zoned target flag prompting all further
incoming I/O to be rejected. In order to detect backing device failures
timely, this new function is called in the request mapping path, at the
beginning of every reclaim run and before performing any metadata I/O.

The proper way out of this situation is to do

dmsetup remove <dm-zoned target>

and recreate the target when the problem with the backing device
is resolved.

Fixes: 3b1a94c88b79 ("dm zoned: drive-managed zoned block device target")
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-zoned-metadata.c |   51 ++++++++++++++++++++++++++++++++---------
 drivers/md/dm-zoned-reclaim.c  |   18 ++++++++++++--
 drivers/md/dm-zoned-target.c   |   45 ++++++++++++++++++++++++++++++++++--
 drivers/md/dm-zoned.h          |   10 ++++++++
 4 files changed, 110 insertions(+), 14 deletions(-)

--- a/drivers/md/dm-zoned-metadata.c
+++ b/drivers/md/dm-zoned-metadata.c
@@ -401,15 +401,18 @@ static struct dmz_mblock *dmz_get_mblock
 	sector_t block = zmd->sb[zmd->mblk_primary].block + mblk_no;
 	struct bio *bio;
 
+	if (dmz_bdev_is_dying(zmd->dev))
+		return ERR_PTR(-EIO);
+
 	/* Get a new block and a BIO to read it */
 	mblk = dmz_alloc_mblock(zmd, mblk_no);
 	if (!mblk)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	bio = bio_alloc(GFP_NOIO, 1);
 	if (!bio) {
 		dmz_free_mblock(zmd, mblk);
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 	}
 
 	spin_lock(&zmd->mblk_lock);
@@ -540,8 +543,8 @@ static struct dmz_mblock *dmz_get_mblock
 	if (!mblk) {
 		/* Cache miss: read the block from disk */
 		mblk = dmz_get_mblock_slow(zmd, mblk_no);
-		if (!mblk)
-			return ERR_PTR(-ENOMEM);
+		if (IS_ERR(mblk))
+			return mblk;
 	}
 
 	/* Wait for on-going read I/O and check for error */
@@ -569,16 +572,19 @@ static void dmz_dirty_mblock(struct dmz_
 /*
  * Issue a metadata block write BIO.
  */
-static void dmz_write_mblock(struct dmz_metadata *zmd, struct dmz_mblock *mblk,
-			     unsigned int set)
+static int dmz_write_mblock(struct dmz_metadata *zmd, struct dmz_mblock *mblk,
+			    unsigned int set)
 {
 	sector_t block = zmd->sb[set].block + mblk->no;
 	struct bio *bio;
 
+	if (dmz_bdev_is_dying(zmd->dev))
+		return -EIO;
+
 	bio = bio_alloc(GFP_NOIO, 1);
 	if (!bio) {
 		set_bit(DMZ_META_ERROR, &mblk->state);
-		return;
+		return -ENOMEM;
 	}
 
 	set_bit(DMZ_META_WRITING, &mblk->state);
@@ -590,6 +596,8 @@ static void dmz_write_mblock(struct dmz_
 	bio_set_op_attrs(bio, REQ_OP_WRITE, REQ_META | REQ_PRIO);
 	bio_add_page(bio, mblk->page, DMZ_BLOCK_SIZE, 0);
 	submit_bio(bio);
+
+	return 0;
 }
 
 /*
@@ -601,6 +609,9 @@ static int dmz_rdwr_block(struct dmz_met
 	struct bio *bio;
 	int ret;
 
+	if (dmz_bdev_is_dying(zmd->dev))
+		return -EIO;
+
 	bio = bio_alloc(GFP_NOIO, 1);
 	if (!bio)
 		return -ENOMEM;
@@ -658,22 +669,29 @@ static int dmz_write_dirty_mblocks(struc
 {
 	struct dmz_mblock *mblk;
 	struct blk_plug plug;
-	int ret = 0;
+	int ret = 0, nr_mblks_submitted = 0;
 
 	/* Issue writes */
 	blk_start_plug(&plug);
-	list_for_each_entry(mblk, write_list, link)
-		dmz_write_mblock(zmd, mblk, set);
+	list_for_each_entry(mblk, write_list, link) {
+		ret = dmz_write_mblock(zmd, mblk, set);
+		if (ret)
+			break;
+		nr_mblks_submitted++;
+	}
 	blk_finish_plug(&plug);
 
 	/* Wait for completion */
 	list_for_each_entry(mblk, write_list, link) {
+		if (!nr_mblks_submitted)
+			break;
 		wait_on_bit_io(&mblk->state, DMZ_META_WRITING,
 			       TASK_UNINTERRUPTIBLE);
 		if (test_bit(DMZ_META_ERROR, &mblk->state)) {
 			clear_bit(DMZ_META_ERROR, &mblk->state);
 			ret = -EIO;
 		}
+		nr_mblks_submitted--;
 	}
 
 	/* Flush drive cache (this will also sync data) */
@@ -735,6 +753,11 @@ int dmz_flush_metadata(struct dmz_metada
 	 */
 	dmz_lock_flush(zmd);
 
+	if (dmz_bdev_is_dying(zmd->dev)) {
+		ret = -EIO;
+		goto out;
+	}
+
 	/* Get dirty blocks */
 	spin_lock(&zmd->mblk_lock);
 	list_splice_init(&zmd->mblk_dirty_list, &write_list);
@@ -1623,6 +1646,10 @@ again:
 		/* Alloate a random zone */
 		dzone = dmz_alloc_zone(zmd, DMZ_ALLOC_RND);
 		if (!dzone) {
+			if (dmz_bdev_is_dying(zmd->dev)) {
+				dzone = ERR_PTR(-EIO);
+				goto out;
+			}
 			dmz_wait_for_free_zones(zmd);
 			goto again;
 		}
@@ -1720,6 +1747,10 @@ again:
 	/* Alloate a random zone */
 	bzone = dmz_alloc_zone(zmd, DMZ_ALLOC_RND);
 	if (!bzone) {
+		if (dmz_bdev_is_dying(zmd->dev)) {
+			bzone = ERR_PTR(-EIO);
+			goto out;
+		}
 		dmz_wait_for_free_zones(zmd);
 		goto again;
 	}
--- a/drivers/md/dm-zoned-reclaim.c
+++ b/drivers/md/dm-zoned-reclaim.c
@@ -37,7 +37,7 @@ enum {
 /*
  * Number of seconds of target BIO inactivity to consider the target idle.
  */
-#define DMZ_IDLE_PERIOD		(10UL * HZ)
+#define DMZ_IDLE_PERIOD			(10UL * HZ)
 
 /*
  * Percentage of unmapped (free) random zones below which reclaim starts
@@ -134,6 +134,9 @@ static int dmz_reclaim_copy(struct dmz_r
 		set_bit(DM_KCOPYD_WRITE_SEQ, &flags);
 
 	while (block < end_block) {
+		if (dev->flags & DMZ_BDEV_DYING)
+			return -EIO;
+
 		/* Get a valid region from the source zone */
 		ret = dmz_first_valid_block(zmd, src_zone, &block);
 		if (ret <= 0)
@@ -451,6 +454,9 @@ static void dmz_reclaim_work(struct work
 	unsigned int p_unmap_rnd;
 	int ret;
 
+	if (dmz_bdev_is_dying(zrc->dev))
+		return;
+
 	if (!dmz_should_reclaim(zrc)) {
 		mod_delayed_work(zrc->wq, &zrc->work, DMZ_IDLE_PERIOD);
 		return;
@@ -480,8 +486,16 @@ static void dmz_reclaim_work(struct work
 		      p_unmap_rnd, nr_unmap_rnd, nr_rnd);
 
 	ret = dmz_do_reclaim(zrc);
-	if (ret)
+	if (ret) {
 		dmz_dev_debug(zrc->dev, "Reclaim error %d\n", ret);
+		if (ret == -EIO)
+			/*
+			 * LLD might be performing some error handling sequence
+			 * at the underlying device. To not interfere, do not
+			 * attempt to schedule the next reclaim run immediately.
+			 */
+			return;
+	}
 
 	dmz_schedule_reclaim(zrc);
 }
--- a/drivers/md/dm-zoned-target.c
+++ b/drivers/md/dm-zoned-target.c
@@ -133,6 +133,8 @@ static int dmz_submit_bio(struct dmz_tar
 
 	refcount_inc(&bioctx->ref);
 	generic_make_request(clone);
+	if (clone->bi_status == BLK_STS_IOERR)
+		return -EIO;
 
 	if (bio_op(bio) == REQ_OP_WRITE && dmz_is_seq(zone))
 		zone->wp_block += nr_blocks;
@@ -277,8 +279,8 @@ static int dmz_handle_buffered_write(str
 
 	/* Get the buffer zone. One will be allocated if needed */
 	bzone = dmz_get_chunk_buffer(zmd, zone);
-	if (!bzone)
-		return -ENOSPC;
+	if (IS_ERR(bzone))
+		return PTR_ERR(bzone);
 
 	if (dmz_is_readonly(bzone))
 		return -EROFS;
@@ -389,6 +391,11 @@ static void dmz_handle_bio(struct dmz_ta
 
 	dmz_lock_metadata(zmd);
 
+	if (dmz->dev->flags & DMZ_BDEV_DYING) {
+		ret = -EIO;
+		goto out;
+	}
+
 	/*
 	 * Get the data zone mapping the chunk. There may be no
 	 * mapping for read and discard. If a mapping is obtained,
@@ -493,6 +500,8 @@ static void dmz_flush_work(struct work_s
 
 	/* Flush dirty metadata blocks */
 	ret = dmz_flush_metadata(dmz->metadata);
+	if (ret)
+		dmz_dev_debug(dmz->dev, "Metadata flush failed, rc=%d\n", ret);
 
 	/* Process queued flush requests */
 	while (1) {
@@ -557,6 +566,32 @@ out:
 }
 
 /*
+ * Check the backing device availability. If it's on the way out,
+ * start failing I/O. Reclaim and metadata components also call this
+ * function to cleanly abort operation in the event of such failure.
+ */
+bool dmz_bdev_is_dying(struct dmz_dev *dmz_dev)
+{
+	struct gendisk *disk;
+
+	if (!(dmz_dev->flags & DMZ_BDEV_DYING)) {
+		disk = dmz_dev->bdev->bd_disk;
+		if (blk_queue_dying(bdev_get_queue(dmz_dev->bdev))) {
+			dmz_dev_warn(dmz_dev, "Backing device queue dying");
+			dmz_dev->flags |= DMZ_BDEV_DYING;
+		} else if (disk->fops->check_events) {
+			if (disk->fops->check_events(disk, 0) &
+					DISK_EVENT_MEDIA_CHANGE) {
+				dmz_dev_warn(dmz_dev, "Backing device offline");
+				dmz_dev->flags |= DMZ_BDEV_DYING;
+			}
+		}
+	}
+
+	return dmz_dev->flags & DMZ_BDEV_DYING;
+}
+
+/*
  * Process a new BIO.
  */
 static int dmz_map(struct dm_target *ti, struct bio *bio)
@@ -569,6 +604,9 @@ static int dmz_map(struct dm_target *ti,
 	sector_t chunk_sector;
 	int ret;
 
+	if (dmz_bdev_is_dying(dmz->dev))
+		return DM_MAPIO_KILL;
+
 	dmz_dev_debug(dev, "BIO op %d sector %llu + %u => chunk %llu, block %llu, %u blocks",
 		      bio_op(bio), (unsigned long long)sector, nr_sectors,
 		      (unsigned long long)dmz_bio_chunk(dmz->dev, bio),
@@ -865,6 +903,9 @@ static int dmz_prepare_ioctl(struct dm_t
 {
 	struct dmz_target *dmz = ti->private;
 
+	if (dmz_bdev_is_dying(dmz->dev))
+		return -ENODEV;
+
 	*bdev = dmz->dev->bdev;
 
 	return 0;
--- a/drivers/md/dm-zoned.h
+++ b/drivers/md/dm-zoned.h
@@ -56,6 +56,8 @@ struct dmz_dev {
 
 	unsigned int		nr_zones;
 
+	unsigned int		flags;
+
 	sector_t		zone_nr_sectors;
 	unsigned int		zone_nr_sectors_shift;
 
@@ -67,6 +69,9 @@ struct dmz_dev {
 				 (dev)->zone_nr_sectors_shift)
 #define dmz_chunk_block(dev, b)	((b) & ((dev)->zone_nr_blocks - 1))
 
+/* Device flags. */
+#define DMZ_BDEV_DYING		(1 << 0)
+
 /*
  * Zone descriptor.
  */
@@ -245,4 +250,9 @@ void dmz_resume_reclaim(struct dmz_recla
 void dmz_reclaim_bio_acc(struct dmz_reclaim *zrc);
 void dmz_schedule_reclaim(struct dmz_reclaim *zrc);
 
+/*
+ * Functions defined in dm-zoned-target.c
+ */
+bool dmz_bdev_is_dying(struct dmz_dev *dmz_dev);
+
 #endif /* DM_ZONED_H */


