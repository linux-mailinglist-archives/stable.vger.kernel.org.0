Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 579AECA6CD
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392220AbfJCQr3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:47:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:32814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405180AbfJCQr3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:47:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28A6220867;
        Thu,  3 Oct 2019 16:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570121248;
        bh=SSaj6SjOpAnKNqQCHy7fYhMvKgjaL7iwdNhua4vxOJw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MshQKUxkK5iFU9pa+r+O66z/c8pOnE0Z7U4icDEAC8zXVsKRBIuUgxxIDjSy5GkIU
         TqE+wXxND0lnw/MnlYphk04Iu2dF6tzHxEHBTmsB4KPb4wy2JX64sQZQHjP8CgBwgp
         WoEDfKYSjQgbNW9clbRJ8qJZi0kSe65EdavyLOqA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Hou Tao <houtao1@huawei.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 209/344] block: make rq sector size accessible for block stats
Date:   Thu,  3 Oct 2019 17:52:54 +0200
Message-Id: <20191003154600.901705699@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hou Tao <houtao1@huawei.com>

[ Upstream commit 3d24430694077313c75c6b89f618db09943621e4 ]

Currently rq->data_len will be decreased by partial completion or
zeroed by completion, so when blk_stat_add() is invoked, data_len
will be zero and there will never be samples in poll_cb because
blk_mq_poll_stats_bkt() will return -1 if data_len is zero.

We could move blk_stat_add() back to __blk_mq_complete_request(),
but that would make the effort of trying to call ktime_get_ns()
once in vain. Instead we can reuse throtl_size field, and use
it for both block stats and block throttle, and adjust the
logic in blk_mq_poll_stats_bkt() accordingly.

Fixes: 4bc6339a583c ("block: move blk_stat_add() to __blk_mq_end_request()")
Tested-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Hou Tao <houtao1@huawei.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c         | 11 +++++------
 block/blk-throttle.c   |  3 ++-
 include/linux/blkdev.h | 15 ++++++++++++---
 3 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index a38ebb2a380c2..9b56428cad0e7 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -44,12 +44,12 @@ static void blk_mq_poll_stats_fn(struct blk_stat_callback *cb);
 
 static int blk_mq_poll_stats_bkt(const struct request *rq)
 {
-	int ddir, bytes, bucket;
+	int ddir, sectors, bucket;
 
 	ddir = rq_data_dir(rq);
-	bytes = blk_rq_bytes(rq);
+	sectors = blk_rq_stats_sectors(rq);
 
-	bucket = ddir + 2*(ilog2(bytes) - 9);
+	bucket = ddir + 2 * ilog2(sectors);
 
 	if (bucket < 0)
 		return -1;
@@ -330,6 +330,7 @@ static struct request *blk_mq_rq_ctx_init(struct blk_mq_alloc_data *data,
 	else
 		rq->start_time_ns = 0;
 	rq->io_start_time_ns = 0;
+	rq->stats_sectors = 0;
 	rq->nr_phys_segments = 0;
 #if defined(CONFIG_BLK_DEV_INTEGRITY)
 	rq->nr_integrity_segments = 0;
@@ -673,9 +674,7 @@ void blk_mq_start_request(struct request *rq)
 
 	if (test_bit(QUEUE_FLAG_STATS, &q->queue_flags)) {
 		rq->io_start_time_ns = ktime_get_ns();
-#ifdef CONFIG_BLK_DEV_THROTTLING_LOW
-		rq->throtl_size = blk_rq_sectors(rq);
-#endif
+		rq->stats_sectors = blk_rq_sectors(rq);
 		rq->rq_flags |= RQF_STATS;
 		rq_qos_issue(q, rq);
 	}
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 8ab6c81532236..ee74bffe3504d 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -2246,7 +2246,8 @@ void blk_throtl_stat_add(struct request *rq, u64 time_ns)
 	struct request_queue *q = rq->q;
 	struct throtl_data *td = q->td;
 
-	throtl_track_latency(td, rq->throtl_size, req_op(rq), time_ns >> 10);
+	throtl_track_latency(td, blk_rq_stats_sectors(rq), req_op(rq),
+			     time_ns >> 10);
 }
 
 void blk_throtl_bio_endio(struct bio *bio)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 1ef375dafb1c1..ae51050c50949 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -202,9 +202,12 @@ struct request {
 #ifdef CONFIG_BLK_WBT
 	unsigned short wbt_flags;
 #endif
-#ifdef CONFIG_BLK_DEV_THROTTLING_LOW
-	unsigned short throtl_size;
-#endif
+	/*
+	 * rq sectors used for blk stats. It has the same value
+	 * with blk_rq_sectors(rq), except that it never be zeroed
+	 * by completion.
+	 */
+	unsigned short stats_sectors;
 
 	/*
 	 * Number of scatter-gather DMA addr+len pairs after
@@ -903,6 +906,7 @@ static inline struct request_queue *bdev_get_queue(struct block_device *bdev)
  * blk_rq_err_bytes()		: bytes left till the next error boundary
  * blk_rq_sectors()		: sectors left in the entire request
  * blk_rq_cur_sectors()		: sectors left in the current segment
+ * blk_rq_stats_sectors()	: sectors of the entire request used for stats
  */
 static inline sector_t blk_rq_pos(const struct request *rq)
 {
@@ -931,6 +935,11 @@ static inline unsigned int blk_rq_cur_sectors(const struct request *rq)
 	return blk_rq_cur_bytes(rq) >> SECTOR_SHIFT;
 }
 
+static inline unsigned int blk_rq_stats_sectors(const struct request *rq)
+{
+	return rq->stats_sectors;
+}
+
 #ifdef CONFIG_BLK_DEV_ZONED
 static inline unsigned int blk_rq_zone_no(struct request *rq)
 {
-- 
2.20.1



