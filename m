Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9B62383842
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244472AbhEQPvA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:51:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:42410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243444AbhEQPsK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:48:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 036936195C;
        Mon, 17 May 2021 14:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262692;
        bh=zBHHWhLgllJGLTbzNhuSJSbIf2igLrVp3+rPxVwSzdA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jjckKRFmdeyLLPtUlYNONCa+qi0A8TsOnwjeufZ2gWNStgQKHQ2Lt6woRjIw77PvC
         cFKT3iu8RjjtWDKRiRFnSt023i7UUdCRl0sCxaqXh86bnOhECfbvSem6suIm2flX1K
         sdR9BWemylRa4CNy/RqRgmgly/0hFPI7QEM8fdmc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Omar Sandoval <osandov@fb.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 230/289] kyber: fix out of bounds access when preempted
Date:   Mon, 17 May 2021 16:02:35 +0200
Message-Id: <20210517140312.914247339@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

[ Upstream commit efed9a3337e341bd0989161b97453b52567bc59d ]

__blk_mq_sched_bio_merge() gets the ctx and hctx for the current CPU and
passes the hctx to ->bio_merge(). kyber_bio_merge() then gets the ctx
for the current CPU again and uses that to get the corresponding Kyber
context in the passed hctx. However, the thread may be preempted between
the two calls to blk_mq_get_ctx(), and the ctx returned the second time
may no longer correspond to the passed hctx. This "works" accidentally
most of the time, but it can cause us to read garbage if the second ctx
came from an hctx with more ctx's than the first one (i.e., if
ctx->index_hw[hctx->type] > hctx->nr_ctx).

This manifested as this UBSAN array index out of bounds error reported
by Jakub:

UBSAN: array-index-out-of-bounds in ../kernel/locking/qspinlock.c:130:9
index 13106 is out of range for type 'long unsigned int [128]'
Call Trace:
 dump_stack+0xa4/0xe5
 ubsan_epilogue+0x5/0x40
 __ubsan_handle_out_of_bounds.cold.13+0x2a/0x34
 queued_spin_lock_slowpath+0x476/0x480
 do_raw_spin_lock+0x1c2/0x1d0
 kyber_bio_merge+0x112/0x180
 blk_mq_submit_bio+0x1f5/0x1100
 submit_bio_noacct+0x7b0/0x870
 submit_bio+0xc2/0x3a0
 btrfs_map_bio+0x4f0/0x9d0
 btrfs_submit_data_bio+0x24e/0x310
 submit_one_bio+0x7f/0xb0
 submit_extent_page+0xc4/0x440
 __extent_writepage_io+0x2b8/0x5e0
 __extent_writepage+0x28d/0x6e0
 extent_write_cache_pages+0x4d7/0x7a0
 extent_writepages+0xa2/0x110
 do_writepages+0x8f/0x180
 __writeback_single_inode+0x99/0x7f0
 writeback_sb_inodes+0x34e/0x790
 __writeback_inodes_wb+0x9e/0x120
 wb_writeback+0x4d2/0x660
 wb_workfn+0x64d/0xa10
 process_one_work+0x53a/0xa80
 worker_thread+0x69/0x5b0
 kthread+0x20b/0x240
 ret_from_fork+0x1f/0x30

Only Kyber uses the hctx, so fix it by passing the request_queue to
->bio_merge() instead. BFQ and mq-deadline just use that, and Kyber can
map the queues itself to avoid the mismatch.

Fixes: a6088845c2bf ("block: kyber: make kyber more friendly with merging")
Reported-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Omar Sandoval <osandov@fb.com>
Link: https://lore.kernel.org/r/c7598605401a48d5cfeadebb678abd10af22b83f.1620691329.git.osandov@fb.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bfq-iosched.c      | 3 +--
 block/blk-mq-sched.c     | 8 +++++---
 block/kyber-iosched.c    | 5 +++--
 block/mq-deadline.c      | 3 +--
 include/linux/elevator.h | 2 +-
 5 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 5720978e4d09..c91dca641eb4 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -2210,10 +2210,9 @@ static void bfq_remove_request(struct request_queue *q,
 
 }
 
-static bool bfq_bio_merge(struct blk_mq_hw_ctx *hctx, struct bio *bio,
+static bool bfq_bio_merge(struct request_queue *q, struct bio *bio,
 		unsigned int nr_segs)
 {
-	struct request_queue *q = hctx->queue;
 	struct bfq_data *bfqd = q->elevator->elevator_data;
 	struct request *free = NULL;
 	/*
diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
index d1eafe2c045c..581be65a53c1 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -348,14 +348,16 @@ bool __blk_mq_sched_bio_merge(struct request_queue *q, struct bio *bio,
 		unsigned int nr_segs)
 {
 	struct elevator_queue *e = q->elevator;
-	struct blk_mq_ctx *ctx = blk_mq_get_ctx(q);
-	struct blk_mq_hw_ctx *hctx = blk_mq_map_queue(q, bio->bi_opf, ctx);
+	struct blk_mq_ctx *ctx;
+	struct blk_mq_hw_ctx *hctx;
 	bool ret = false;
 	enum hctx_type type;
 
 	if (e && e->type->ops.bio_merge)
-		return e->type->ops.bio_merge(hctx, bio, nr_segs);
+		return e->type->ops.bio_merge(q, bio, nr_segs);
 
+	ctx = blk_mq_get_ctx(q);
+	hctx = blk_mq_map_queue(q, bio->bi_opf, ctx);
 	type = hctx->type;
 	if (!(hctx->flags & BLK_MQ_F_SHOULD_MERGE) ||
 	    list_empty_careful(&ctx->rq_lists[type]))
diff --git a/block/kyber-iosched.c b/block/kyber-iosched.c
index dc89199bc8c6..7f9ef773bf44 100644
--- a/block/kyber-iosched.c
+++ b/block/kyber-iosched.c
@@ -562,11 +562,12 @@ static void kyber_limit_depth(unsigned int op, struct blk_mq_alloc_data *data)
 	}
 }
 
-static bool kyber_bio_merge(struct blk_mq_hw_ctx *hctx, struct bio *bio,
+static bool kyber_bio_merge(struct request_queue *q, struct bio *bio,
 		unsigned int nr_segs)
 {
+	struct blk_mq_ctx *ctx = blk_mq_get_ctx(q);
+	struct blk_mq_hw_ctx *hctx = blk_mq_map_queue(q, bio->bi_opf, ctx);
 	struct kyber_hctx_data *khd = hctx->sched_data;
-	struct blk_mq_ctx *ctx = blk_mq_get_ctx(hctx->queue);
 	struct kyber_ctx_queue *kcq = &khd->kcqs[ctx->index_hw[hctx->type]];
 	unsigned int sched_domain = kyber_sched_domain(bio->bi_opf);
 	struct list_head *rq_list = &kcq->rq_list[sched_domain];
diff --git a/block/mq-deadline.c b/block/mq-deadline.c
index 800ac902809b..2b9635d0dcba 100644
--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -461,10 +461,9 @@ static int dd_request_merge(struct request_queue *q, struct request **rq,
 	return ELEVATOR_NO_MERGE;
 }
 
-static bool dd_bio_merge(struct blk_mq_hw_ctx *hctx, struct bio *bio,
+static bool dd_bio_merge(struct request_queue *q, struct bio *bio,
 		unsigned int nr_segs)
 {
-	struct request_queue *q = hctx->queue;
 	struct deadline_data *dd = q->elevator->elevator_data;
 	struct request *free = NULL;
 	bool ret;
diff --git a/include/linux/elevator.h b/include/linux/elevator.h
index bacc40a0bdf3..bc26b4e11f62 100644
--- a/include/linux/elevator.h
+++ b/include/linux/elevator.h
@@ -34,7 +34,7 @@ struct elevator_mq_ops {
 	void (*depth_updated)(struct blk_mq_hw_ctx *);
 
 	bool (*allow_merge)(struct request_queue *, struct request *, struct bio *);
-	bool (*bio_merge)(struct blk_mq_hw_ctx *, struct bio *, unsigned int);
+	bool (*bio_merge)(struct request_queue *, struct bio *, unsigned int);
 	int (*request_merge)(struct request_queue *q, struct request **, struct bio *);
 	void (*request_merged)(struct request_queue *, struct request *, enum elv_merge);
 	void (*requests_merged)(struct request_queue *, struct request *, struct request *);
-- 
2.30.2



