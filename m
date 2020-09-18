Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D320626F1FD
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727913AbgIRCz1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:55:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:57220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727851AbgIRCHI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:07:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17FB423A04;
        Fri, 18 Sep 2020 02:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394822;
        bh=Srm+hnaDUGZZ9CJvWHJmxDLBzqgEQgsXkNGyMr+BVQc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TqEdsCWjUtwOLky90LMOECPryU4ywTwMq3x7Vx3tcMRVjOEhivgVu68neE41Jow4k
         BBDuUtrdtNeCVFr8p0rSmsm0brMUS5zVzGWpVrHH2kpyelbPaOA6hljxyYwWL12PF8
         wSoZde0annpcIp8GgrnQ9SWx8E3eVEACyRbVSgY8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Omar Sandoval <osandov@fb.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 287/330] btrfs: fix double __endio_write_update_ordered in direct I/O
Date:   Thu, 17 Sep 2020 22:00:27 -0400
Message-Id: <20200918020110.2063155-287-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

[ Upstream commit c36cac28cb94e58f7e21ff43bdc6064346dab32c ]

In btrfs_submit_direct(), if we fail to allocate the btrfs_dio_private,
we complete the ordered extent range. However, we don't mark that the
range doesn't need to be cleaned up from btrfs_direct_IO() until later.
Therefore, if we fail to allocate the btrfs_dio_private, we complete the
ordered extent range twice. We could fix this by updating
unsubmitted_oe_range earlier, but it's cleaner to reorganize the code so
that creating the btrfs_dio_private and submitting the bios are
separate, and once the btrfs_dio_private is created, cleanup always
happens through the btrfs_dio_private.

The logic around unsubmitted_oe_range_end and unsubmitted_oe_range_start
is really subtle. We have the following:

  1. btrfs_direct_IO sets those two to the same value.

  2. When we call __blockdev_direct_IO unless
     btrfs_get_blocks_direct->btrfs_get_blocks_direct_write is called to
     modify unsubmitted_oe_range_start so that start < end. Cleanup
     won't happen.

  3. We come into btrfs_submit_direct - if it dip allocation fails we'd
     return with oe_range_end now modified so cleanup will happen.

  4. If we manage to allocate the dip we reset the unsubmitted range
     members to be equal so that cleanup happens from
     btrfs_endio_direct_write.

This 4-step logic is not really obvious, especially given it's scattered
across 3 functions.

Fixes: f28a49287817 ("Btrfs: fix leaking of ordered extents after direct IO write error")
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Omar Sandoval <osandov@fb.com>
[ add range start/end logic explanation from Nikolay ]
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 178 +++++++++++++++++++----------------------------
 1 file changed, 70 insertions(+), 108 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 9ac40991a6405..e9787b7b943a2 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8586,14 +8586,64 @@ err:
 	return ret;
 }
 
-static int btrfs_submit_direct_hook(struct btrfs_dio_private *dip)
+/*
+ * If this succeeds, the btrfs_dio_private is responsible for cleaning up locked
+ * or ordered extents whether or not we submit any bios.
+ */
+static struct btrfs_dio_private *btrfs_create_dio_private(struct bio *dio_bio,
+							  struct inode *inode,
+							  loff_t file_offset)
 {
-	struct inode *inode = dip->inode;
+	const bool write = (bio_op(dio_bio) == REQ_OP_WRITE);
+	struct btrfs_dio_private *dip;
+	struct bio *bio;
+
+	dip = kzalloc(sizeof(*dip), GFP_NOFS);
+	if (!dip)
+		return NULL;
+
+	bio = btrfs_bio_clone(dio_bio);
+	bio->bi_private = dip;
+	btrfs_io_bio(bio)->logical = file_offset;
+
+	dip->private = dio_bio->bi_private;
+	dip->inode = inode;
+	dip->logical_offset = file_offset;
+	dip->bytes = dio_bio->bi_iter.bi_size;
+	dip->disk_bytenr = (u64)dio_bio->bi_iter.bi_sector << 9;
+	dip->orig_bio = bio;
+	dip->dio_bio = dio_bio;
+	atomic_set(&dip->pending_bios, 1);
+
+	if (write) {
+		struct btrfs_dio_data *dio_data = current->journal_info;
+
+		/*
+		 * Setting range start and end to the same value means that
+		 * no cleanup will happen in btrfs_direct_IO
+		 */
+		dio_data->unsubmitted_oe_range_end = dip->logical_offset +
+			dip->bytes;
+		dio_data->unsubmitted_oe_range_start =
+			dio_data->unsubmitted_oe_range_end;
+
+		bio->bi_end_io = btrfs_endio_direct_write;
+	} else {
+		bio->bi_end_io = btrfs_endio_direct_read;
+		dip->subio_endio = btrfs_subio_endio_read;
+	}
+	return dip;
+}
+
+static void btrfs_submit_direct(struct bio *dio_bio, struct inode *inode,
+				loff_t file_offset)
+{
+	const bool write = (bio_op(dio_bio) == REQ_OP_WRITE);
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
+	struct btrfs_dio_private *dip;
 	struct bio *bio;
-	struct bio *orig_bio = dip->orig_bio;
-	u64 start_sector = orig_bio->bi_iter.bi_sector;
-	u64 file_offset = dip->logical_offset;
+	struct bio *orig_bio;
+	u64 start_sector;
 	int async_submit = 0;
 	u64 submit_len;
 	int clone_offset = 0;
@@ -8602,11 +8652,24 @@ static int btrfs_submit_direct_hook(struct btrfs_dio_private *dip)
 	blk_status_t status;
 	struct btrfs_io_geometry geom;
 
+	dip = btrfs_create_dio_private(dio_bio, inode, file_offset);
+	if (!dip) {
+		if (!write) {
+			unlock_extent(&BTRFS_I(inode)->io_tree, file_offset,
+				file_offset + dio_bio->bi_iter.bi_size - 1);
+		}
+		dio_bio->bi_status = BLK_STS_RESOURCE;
+		dio_end_io(dio_bio);
+		return;
+	}
+
+	orig_bio = dip->orig_bio;
+	start_sector = orig_bio->bi_iter.bi_sector;
 	submit_len = orig_bio->bi_iter.bi_size;
 	ret = btrfs_get_io_geometry(fs_info, btrfs_op(orig_bio),
 				    start_sector << 9, submit_len, &geom);
 	if (ret)
-		return -EIO;
+		goto out_err;
 
 	if (geom.len >= submit_len) {
 		bio = orig_bio;
@@ -8669,7 +8732,7 @@ static int btrfs_submit_direct_hook(struct btrfs_dio_private *dip)
 submit:
 	status = btrfs_submit_dio_bio(bio, inode, file_offset, async_submit);
 	if (!status)
-		return 0;
+		return;
 
 	if (bio != orig_bio)
 		bio_put(bio);
@@ -8683,107 +8746,6 @@ out_err:
 	 */
 	if (atomic_dec_and_test(&dip->pending_bios))
 		bio_io_error(dip->orig_bio);
-
-	/* bio_end_io() will handle error, so we needn't return it */
-	return 0;
-}
-
-static void btrfs_submit_direct(struct bio *dio_bio, struct inode *inode,
-				loff_t file_offset)
-{
-	struct btrfs_dio_private *dip = NULL;
-	struct bio *bio = NULL;
-	struct btrfs_io_bio *io_bio;
-	bool write = (bio_op(dio_bio) == REQ_OP_WRITE);
-	int ret = 0;
-
-	bio = btrfs_bio_clone(dio_bio);
-
-	dip = kzalloc(sizeof(*dip), GFP_NOFS);
-	if (!dip) {
-		ret = -ENOMEM;
-		goto free_ordered;
-	}
-
-	dip->private = dio_bio->bi_private;
-	dip->inode = inode;
-	dip->logical_offset = file_offset;
-	dip->bytes = dio_bio->bi_iter.bi_size;
-	dip->disk_bytenr = (u64)dio_bio->bi_iter.bi_sector << 9;
-	bio->bi_private = dip;
-	dip->orig_bio = bio;
-	dip->dio_bio = dio_bio;
-	atomic_set(&dip->pending_bios, 1);
-	io_bio = btrfs_io_bio(bio);
-	io_bio->logical = file_offset;
-
-	if (write) {
-		bio->bi_end_io = btrfs_endio_direct_write;
-	} else {
-		bio->bi_end_io = btrfs_endio_direct_read;
-		dip->subio_endio = btrfs_subio_endio_read;
-	}
-
-	/*
-	 * Reset the range for unsubmitted ordered extents (to a 0 length range)
-	 * even if we fail to submit a bio, because in such case we do the
-	 * corresponding error handling below and it must not be done a second
-	 * time by btrfs_direct_IO().
-	 */
-	if (write) {
-		struct btrfs_dio_data *dio_data = current->journal_info;
-
-		dio_data->unsubmitted_oe_range_end = dip->logical_offset +
-			dip->bytes;
-		dio_data->unsubmitted_oe_range_start =
-			dio_data->unsubmitted_oe_range_end;
-	}
-
-	ret = btrfs_submit_direct_hook(dip);
-	if (!ret)
-		return;
-
-	btrfs_io_bio_free_csum(io_bio);
-
-free_ordered:
-	/*
-	 * If we arrived here it means either we failed to submit the dip
-	 * or we either failed to clone the dio_bio or failed to allocate the
-	 * dip. If we cloned the dio_bio and allocated the dip, we can just
-	 * call bio_endio against our io_bio so that we get proper resource
-	 * cleanup if we fail to submit the dip, otherwise, we must do the
-	 * same as btrfs_endio_direct_[write|read] because we can't call these
-	 * callbacks - they require an allocated dip and a clone of dio_bio.
-	 */
-	if (bio && dip) {
-		bio_io_error(bio);
-		/*
-		 * The end io callbacks free our dip, do the final put on bio
-		 * and all the cleanup and final put for dio_bio (through
-		 * dio_end_io()).
-		 */
-		dip = NULL;
-		bio = NULL;
-	} else {
-		if (write)
-			__endio_write_update_ordered(inode,
-						file_offset,
-						dio_bio->bi_iter.bi_size,
-						false);
-		else
-			unlock_extent(&BTRFS_I(inode)->io_tree, file_offset,
-			      file_offset + dio_bio->bi_iter.bi_size - 1);
-
-		dio_bio->bi_status = BLK_STS_IOERR;
-		/*
-		 * Releases and cleans up our dio_bio, no need to bio_put()
-		 * nor bio_endio()/bio_io_error() against dio_bio.
-		 */
-		dio_end_io(dio_bio);
-	}
-	if (bio)
-		bio_put(bio);
-	kfree(dip);
 }
 
 static ssize_t check_direct_IO(struct btrfs_fs_info *fs_info,
-- 
2.25.1

