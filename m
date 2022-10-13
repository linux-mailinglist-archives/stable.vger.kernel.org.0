Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 629195FD032
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 02:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230497AbiJMAZC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 20:25:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230513AbiJMAXr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 20:23:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CBC9AC4B6;
        Wed, 12 Oct 2022 17:21:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B01F2616E6;
        Thu, 13 Oct 2022 00:20:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD6F9C433D6;
        Thu, 13 Oct 2022 00:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620459;
        bh=tyzS1ViS9KrTaJvN1d+884IZktdTBQB32Pz7bvn/AqE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kG1nIsMypeoBlagjXuYhrFMQ5BFHLoXFtzl1Zn66BAGNX1uOsRlqcpALCOq7xXEwA
         OasyGipXtZq4ixbfRrNoefs/7c0MpESbWDoxitMXVye/0FLWA3kDaLBL7OQ6z/Fgo/
         kaEd9setU/SKMOdClYwrP3KwJHTSL1nKK/GkZ/+3XpszMe5Z+9xBUyhWUIMlM74zrE
         m7l+DWibuP44BI8gHANYM5IAd5VSgDS09nlPZFYU2pvVfObUPhZ3TfJr8lABEYUuPK
         W0YJAaD6Le8WGtxrXNQtIwmR02P1Mguqrjd0WTSPgBATZP8m8R0qTkkfs7UPkYPo8H
         Bz8d+RqH4IUXw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        Pankaj Raghav <p.raghav@samsung.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        agk@redhat.com, snitzer@kernel.org, dm-devel@redhat.com,
        song@kernel.org, linux-block@vger.kernel.org,
        linux-raid@vger.kernel.org, io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 54/63] block: replace blk_queue_nowait with bdev_nowait
Date:   Wed, 12 Oct 2022 20:18:28 -0400
Message-Id: <20221013001842.1893243-54-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221013001842.1893243-1-sashal@kernel.org>
References: <20221013001842.1893243-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 568ec936bf1384fc15873908c96a9aeb62536edb ]

Replace blk_queue_nowait with a bdev_nowait helpers that takes the
block_device given that the I/O submission path should not have to
look into the request_queue.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>
Link: https://lore.kernel.org/r/20220927075815.269694-1-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-core.c       | 2 +-
 drivers/md/dm-table.c  | 4 +---
 drivers/md/md.c        | 4 ++--
 include/linux/blkdev.h | 6 +++++-
 io_uring/io_uring.c    | 2 +-
 5 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 7743c68177e8..5970c47ae86f 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -727,7 +727,7 @@ void submit_bio_noacct(struct bio *bio)
 	 * For a REQ_NOWAIT based request, return -EOPNOTSUPP
 	 * if queue does not support NOWAIT.
 	 */
-	if ((bio->bi_opf & REQ_NOWAIT) && !blk_queue_nowait(q))
+	if ((bio->bi_opf & REQ_NOWAIT) && !bdev_nowait(bdev))
 		goto not_supported;
 
 	if (should_fail_bio(bio))
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index bd539afbfe88..1f73ce6ac925 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1869,9 +1869,7 @@ static bool dm_table_supports_write_zeroes(struct dm_table *t)
 static int device_not_nowait_capable(struct dm_target *ti, struct dm_dev *dev,
 				     sector_t start, sector_t len, void *data)
 {
-	struct request_queue *q = bdev_get_queue(dev->bdev);
-
-	return !blk_queue_nowait(q);
+	return !bdev_nowait(dev->bdev);
 }
 
 static bool dm_table_supports_nowait(struct dm_table *t)
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 25d18b67a162..cb8eddcd018e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5852,7 +5852,7 @@ int md_run(struct mddev *mddev)
 			}
 		}
 		sysfs_notify_dirent_safe(rdev->sysfs_state);
-		nowait = nowait && blk_queue_nowait(bdev_get_queue(rdev->bdev));
+		nowait = nowait && bdev_nowait(rdev->bdev);
 	}
 
 	if (!bioset_initialized(&mddev->bio_set)) {
@@ -6989,7 +6989,7 @@ static int hot_add_disk(struct mddev *mddev, dev_t dev)
 	 * If the new disk does not support REQ_NOWAIT,
 	 * disable on the whole MD.
 	 */
-	if (!blk_queue_nowait(bdev_get_queue(rdev->bdev))) {
+	if (!bdev_nowait(rdev->bdev)) {
 		pr_info("%s: Disabling nowait because %pg does not support nowait\n",
 			mdname(mddev), rdev->bdev);
 		blk_queue_flag_clear(QUEUE_FLAG_NOWAIT, mddev->queue);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 83eb8869a8c9..a49ea5e19a9b 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -614,7 +614,6 @@ bool blk_queue_flag_test_and_set(unsigned int flag, struct request_queue *q);
 #define blk_queue_quiesced(q)	test_bit(QUEUE_FLAG_QUIESCED, &(q)->queue_flags)
 #define blk_queue_pm_only(q)	atomic_read(&(q)->pm_only)
 #define blk_queue_registered(q)	test_bit(QUEUE_FLAG_REGISTERED, &(q)->queue_flags)
-#define blk_queue_nowait(q)	test_bit(QUEUE_FLAG_NOWAIT, &(q)->queue_flags)
 #define blk_queue_sq_sched(q)	test_bit(QUEUE_FLAG_SQ_SCHED, &(q)->queue_flags)
 
 extern void blk_set_pm_only(struct request_queue *q);
@@ -1314,6 +1313,11 @@ static inline bool bdev_fua(struct block_device *bdev)
 	return test_bit(QUEUE_FLAG_FUA, &bdev_get_queue(bdev)->queue_flags);
 }
 
+static inline bool bdev_nowait(struct block_device *bdev)
+{
+	return test_bit(QUEUE_FLAG_NOWAIT, &bdev_get_queue(bdev)->queue_flags);
+}
+
 static inline enum blk_zoned_model bdev_zoned_model(struct block_device *bdev)
 {
 	struct request_queue *q = bdev_get_queue(bdev);
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 15a6f1e93e5a..5d80229169da 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3348,7 +3348,7 @@ static void io_iopoll_req_issued(struct io_kiocb *req, unsigned int issue_flags)
 
 static bool io_bdev_nowait(struct block_device *bdev)
 {
-	return !bdev || blk_queue_nowait(bdev_get_queue(bdev));
+	return !bdev || bdev_nowait(bdev);
 }
 
 /*
-- 
2.35.1

