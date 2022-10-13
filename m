Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CA595FCFC7
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 02:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbiJMAWF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 20:22:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbiJMAVZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 20:21:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AE6212344B;
        Wed, 12 Oct 2022 17:18:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1A8A6B81CCC;
        Thu, 13 Oct 2022 00:18:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 769D0C433D7;
        Thu, 13 Oct 2022 00:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620291;
        bh=GhQcifaJLHmSWV1FJcckCCWe5jRuznAVJImLAHQm4YM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=StF+L++WCzSkRTBHIiFgpICXinMNQSLJ+HnjyLHK4D4JiSkAv8OOEnoOzrHmNfDKk
         qZL72uKS3IvFWx3l21dee8KS7a4G1P7egBzP9pZTk4WxFzJTobGBTQR427d2XWLDjX
         w0mU9fcqRYoulPQPQ+UETWozS1ntC7Pm23qAkt8xS3UPCndNnSwY/87aMzLhtPmQTM
         05xVOjaW1+1bmoWqB1bZl0XB0gTHjbf3tihq4i0CbmBtwFPXpzJx5EVHChrhVRi83u
         4arIuDSdeSCSlINeDz5xTuSQi3nGK35C6vN2w721s8Yj1vUpEhLGEsaoO483u7a0rZ
         NRFEUVmGfDW+Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        Pankaj Raghav <p.raghav@samsung.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        agk@redhat.com, snitzer@kernel.org, dm-devel@redhat.com,
        song@kernel.org, linux-block@vger.kernel.org,
        linux-raid@vger.kernel.org, io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 56/67] block: replace blk_queue_nowait with bdev_nowait
Date:   Wed, 12 Oct 2022 20:15:37 -0400
Message-Id: <20221013001554.1892206-56-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221013001554.1892206-1-sashal@kernel.org>
References: <20221013001554.1892206-1-sashal@kernel.org>
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
index 651057c4146b..4ec669b0eadc 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -717,7 +717,7 @@ void submit_bio_noacct(struct bio *bio)
 	 * For a REQ_NOWAIT based request, return -EOPNOTSUPP
 	 * if queue does not support NOWAIT.
 	 */
-	if ((bio->bi_opf & REQ_NOWAIT) && !blk_queue_nowait(q))
+	if ((bio->bi_opf & REQ_NOWAIT) && !bdev_nowait(bdev))
 		goto not_supported;
 
 	if (should_fail_bio(bio))
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 332f96b58252..d8034ff0cb24 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1856,9 +1856,7 @@ static bool dm_table_supports_write_zeroes(struct dm_table *t)
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
index 729be2c5296c..72ad352cb41a 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5845,7 +5845,7 @@ int md_run(struct mddev *mddev)
 			}
 		}
 		sysfs_notify_dirent_safe(rdev->sysfs_state);
-		nowait = nowait && blk_queue_nowait(bdev_get_queue(rdev->bdev));
+		nowait = nowait && bdev_nowait(rdev->bdev);
 	}
 
 	if (!bioset_initialized(&mddev->bio_set)) {
@@ -6982,7 +6982,7 @@ static int hot_add_disk(struct mddev *mddev, dev_t dev)
 	 * If the new disk does not support REQ_NOWAIT,
 	 * disable on the whole MD.
 	 */
-	if (!blk_queue_nowait(bdev_get_queue(rdev->bdev))) {
+	if (!bdev_nowait(rdev->bdev)) {
 		pr_info("%s: Disabling nowait because %pg does not support nowait\n",
 			mdname(mddev), rdev->bdev);
 		blk_queue_flag_clear(QUEUE_FLAG_NOWAIT, mddev->queue);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 84b13fdd34a7..4750772ef228 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -618,7 +618,6 @@ bool blk_queue_flag_test_and_set(unsigned int flag, struct request_queue *q);
 #define blk_queue_quiesced(q)	test_bit(QUEUE_FLAG_QUIESCED, &(q)->queue_flags)
 #define blk_queue_pm_only(q)	atomic_read(&(q)->pm_only)
 #define blk_queue_registered(q)	test_bit(QUEUE_FLAG_REGISTERED, &(q)->queue_flags)
-#define blk_queue_nowait(q)	test_bit(QUEUE_FLAG_NOWAIT, &(q)->queue_flags)
 #define blk_queue_sq_sched(q)	test_bit(QUEUE_FLAG_SQ_SCHED, &(q)->queue_flags)
 
 extern void blk_set_pm_only(struct request_queue *q);
@@ -1280,6 +1279,11 @@ static inline bool bdev_fua(struct block_device *bdev)
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
index 13af6b56ebd2..c13122a87c40 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1384,7 +1384,7 @@ static void io_iopoll_req_issued(struct io_kiocb *req, unsigned int issue_flags)
 
 static bool io_bdev_nowait(struct block_device *bdev)
 {
-	return !bdev || blk_queue_nowait(bdev_get_queue(bdev));
+	return !bdev || bdev_nowait(bdev);
 }
 
 /*
-- 
2.35.1

