Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9691553CC8
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 23:11:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355114AbiFUU5s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 16:57:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355117AbiFUU46 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 16:56:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D395631DD8;
        Tue, 21 Jun 2022 13:50:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D2DCB81B2F;
        Tue, 21 Jun 2022 20:50:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E9FDC385A2;
        Tue, 21 Jun 2022 20:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655844637;
        bh=i4G5Q82COrTziIFpmz6MJgS2uK8zawzwymy0GVB0Sp0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XnYrPm7LIynNYJ5YK503FHrgNUTAJSywvdZfP0/ZebrNdlguelkdS/vkNeSGaOWYI
         yl1AJjle78KF5gLk3QrOOho/LoLw+3faMRHmAK+x4Tyts/uU15Y2P+b9QDnP1SuQLf
         aSii+hOZUxdGNJEJyB/FEFfsYM6YbrH8wDOWcAjeDl8SjTU5OhnGFbo5Aga2KaaVQZ
         S1w/qCo87xDh6uccGkr0an+Xezd6Zj9nuzY50RvKiSWR0qe7seHmMZP2aRNpL85yf/
         BPGmvqQK6bIEciOdwaEqRbx4I28nuzlxY8YryiXd5GXovCdAbf/45Ufyq3RjGyouvr
         XZggdWqddGEPg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, paolo.valente@linaro.org,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 17/20] blk-mq: avoid to touch q->elevator without any protection
Date:   Tue, 21 Jun 2022 16:50:07 -0400
Message-Id: <20220621205010.250185-17-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220621205010.250185-1-sashal@kernel.org>
References: <20220621205010.250185-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 4d337cebcb1c27d9b48c48b9a98e939d4552d584 ]

q->elevator is referred in blk_mq_has_sqsched() without any protection,
no .q_usage_counter is held, no queue srcu and rcu read lock is held,
so potential use-after-free may be triggered.

Fix the issue by adding one queue flag for checking if the elevator
uses single queue style dispatch. Meantime the elevator feature flag
of ELEVATOR_F_MQ_AWARE isn't needed any more.

Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20220616014401.817001-3-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bfq-iosched.c    |  3 +++
 block/blk-mq-sched.c   |  1 +
 block/blk-mq.c         | 18 ++----------------
 block/kyber-iosched.c  |  3 ++-
 block/mq-deadline.c    |  3 +++
 include/linux/blkdev.h |  4 ++--
 6 files changed, 13 insertions(+), 19 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 5d2d3fe65a9d..47ee2e592240 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -7183,6 +7183,9 @@ static int bfq_init_queue(struct request_queue *q, struct elevator_type *e)
 	bfq_init_root_group(bfqd->root_group, bfqd);
 	bfq_init_entity(&bfqd->oom_bfqq.entity, bfqd->root_group);
 
+	/* We dispatch from request queue wide instead of hw queue */
+	blk_queue_flag_set(QUEUE_FLAG_SQ_SCHED, q);
+
 	wbt_disable_default(q);
 	return 0;
 
diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
index 80e0eb26b697..f50f1facd164 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -563,6 +563,7 @@ int blk_mq_init_sched(struct request_queue *q, struct elevator_type *e)
 	int ret;
 
 	if (!e) {
+		blk_queue_flag_clear(QUEUE_FLAG_SQ_SCHED, q);
 		q->elevator = NULL;
 		q->nr_requests = q->tag_set->queue_depth;
 		return 0;
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 5021e8ed2053..8f77023c0f39 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2095,20 +2095,6 @@ void blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx, bool async)
 }
 EXPORT_SYMBOL(blk_mq_run_hw_queue);
 
-/*
- * Is the request queue handled by an IO scheduler that does not respect
- * hardware queues when dispatching?
- */
-static bool blk_mq_has_sqsched(struct request_queue *q)
-{
-	struct elevator_queue *e = q->elevator;
-
-	if (e && e->type->ops.dispatch_request &&
-	    !(e->type->elevator_features & ELEVATOR_F_MQ_AWARE))
-		return true;
-	return false;
-}
-
 /*
  * Return prefered queue to dispatch from (if any) for non-mq aware IO
  * scheduler.
@@ -2141,7 +2127,7 @@ void blk_mq_run_hw_queues(struct request_queue *q, bool async)
 	int i;
 
 	sq_hctx = NULL;
-	if (blk_mq_has_sqsched(q))
+	if (blk_queue_sq_sched(q))
 		sq_hctx = blk_mq_get_sq_hctx(q);
 	queue_for_each_hw_ctx(q, hctx, i) {
 		if (blk_mq_hctx_stopped(hctx))
@@ -2169,7 +2155,7 @@ void blk_mq_delay_run_hw_queues(struct request_queue *q, unsigned long msecs)
 	int i;
 
 	sq_hctx = NULL;
-	if (blk_mq_has_sqsched(q))
+	if (blk_queue_sq_sched(q))
 		sq_hctx = blk_mq_get_sq_hctx(q);
 	queue_for_each_hw_ctx(q, hctx, i) {
 		if (blk_mq_hctx_stopped(hctx))
diff --git a/block/kyber-iosched.c b/block/kyber-iosched.c
index 70ff2a599ef6..8f7c745b4a57 100644
--- a/block/kyber-iosched.c
+++ b/block/kyber-iosched.c
@@ -421,6 +421,8 @@ static int kyber_init_sched(struct request_queue *q, struct elevator_type *e)
 
 	blk_stat_enable_accounting(q);
 
+	blk_queue_flag_clear(QUEUE_FLAG_SQ_SCHED, q);
+
 	eq->elevator_data = kqd;
 	q->elevator = eq;
 
@@ -1033,7 +1035,6 @@ static struct elevator_type kyber_sched = {
 #endif
 	.elevator_attrs = kyber_sched_attrs,
 	.elevator_name = "kyber",
-	.elevator_features = ELEVATOR_F_MQ_AWARE,
 	.elevator_owner = THIS_MODULE,
 };
 
diff --git a/block/mq-deadline.c b/block/mq-deadline.c
index 6ed602b2f80a..1a9e835e816c 100644
--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -642,6 +642,9 @@ static int dd_init_sched(struct request_queue *q, struct elevator_type *e)
 	spin_lock_init(&dd->lock);
 	spin_lock_init(&dd->zone_lock);
 
+	/* We dispatch from request queue wide instead of hw queue */
+	blk_queue_flag_set(QUEUE_FLAG_SQ_SCHED, q);
+
 	q->elevator = eq;
 	return 0;
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 16b47035e4b0..aa4fc2f5defc 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -412,6 +412,7 @@ struct request_queue {
 #define QUEUE_FLAG_RQ_ALLOC_TIME 27	/* record rq->alloc_time_ns */
 #define QUEUE_FLAG_HCTX_ACTIVE	28	/* at least one blk-mq hctx is active */
 #define QUEUE_FLAG_NOWAIT       29	/* device supports NOWAIT */
+#define QUEUE_FLAG_SQ_SCHED     30	/* single queue style io dispatch */
 
 #define QUEUE_FLAG_MQ_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
 				 (1 << QUEUE_FLAG_SAME_COMP) |		\
@@ -457,6 +458,7 @@ bool blk_queue_flag_test_and_set(unsigned int flag, struct request_queue *q);
 #define blk_queue_fua(q)	test_bit(QUEUE_FLAG_FUA, &(q)->queue_flags)
 #define blk_queue_registered(q)	test_bit(QUEUE_FLAG_REGISTERED, &(q)->queue_flags)
 #define blk_queue_nowait(q)	test_bit(QUEUE_FLAG_NOWAIT, &(q)->queue_flags)
+#define blk_queue_sq_sched(q)	test_bit(QUEUE_FLAG_SQ_SCHED, &(q)->queue_flags)
 
 extern void blk_set_pm_only(struct request_queue *q);
 extern void blk_clear_pm_only(struct request_queue *q);
@@ -738,8 +740,6 @@ void disk_set_independent_access_ranges(struct gendisk *disk,
  */
 /* Supports zoned block devices sequential write constraint */
 #define ELEVATOR_F_ZBD_SEQ_WRITE	(1U << 0)
-/* Supports scheduling on multiple hardware queues */
-#define ELEVATOR_F_MQ_AWARE		(1U << 1)
 
 extern void blk_queue_required_elevator_features(struct request_queue *q,
 						 unsigned int features);
-- 
2.35.1

