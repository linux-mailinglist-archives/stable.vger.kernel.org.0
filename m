Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E06259A202
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350975AbiHSQCu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:02:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351326AbiHSQBT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:01:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65C094A10B;
        Fri, 19 Aug 2022 08:53:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 37BC8616FD;
        Fri, 19 Aug 2022 15:52:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DB23C433C1;
        Fri, 19 Aug 2022 15:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924350;
        bh=icOeO67jf30iUkeKSnGqA5Y9dJqj1lids9faoy7k2nM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cM7lmkICsHDfaHnE1T6Ut5XCbQYLxySWpsWGs28wMC3DxamerAgVcHRQFCqk1aUu2
         amryv3CCLdxWVZ2OCFtDYf2oSofxbG7Qq4UyMhLGV9fgaB9QZOfZlr9osbfukqud9J
         AUHfsbGhB+mE3tTL4BpMcbYj8FQBLCFuR2nSFVFg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 141/545] block: remove the request_queue to argument request based tracepoints
Date:   Fri, 19 Aug 2022 17:38:31 +0200
Message-Id: <20220819153835.647666306@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit a54895fa057c67700270777f7661d8d3c7fda88a ]

The request_queue can trivially be derived from the request.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-merge.c            |  2 +-
 block/blk-mq-sched.c         |  2 +-
 block/blk-mq.c               |  8 +++----
 drivers/md/dm-rq.c           |  2 +-
 drivers/s390/scsi/zfcp_fsf.c |  3 +--
 include/linux/blktrace_api.h |  5 ++--
 include/trace/events/block.h | 30 ++++++++++--------------
 kernel/trace/blktrace.c      | 44 ++++++++++++++----------------------
 8 files changed, 39 insertions(+), 57 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 006b1f0a59bc..fbba277364f0 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -806,7 +806,7 @@ static struct request *attempt_merge(struct request_queue *q,
 	 */
 	blk_account_io_merge_request(next);
 
-	trace_block_rq_merge(q, next);
+	trace_block_rq_merge(next);
 
 	/*
 	 * ownership of bio passed from next to req, return 'next' for
diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
index e0117f5f969d..72e64ba661fc 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -396,7 +396,7 @@ EXPORT_SYMBOL_GPL(blk_mq_sched_try_insert_merge);
 
 void blk_mq_sched_request_inserted(struct request *rq)
 {
-	trace_block_rq_insert(rq->q, rq);
+	trace_block_rq_insert(rq);
 }
 EXPORT_SYMBOL_GPL(blk_mq_sched_request_inserted);
 
diff --git a/block/blk-mq.c b/block/blk-mq.c
index c5d82b21a1cc..90f64bb42fbd 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -733,7 +733,7 @@ void blk_mq_start_request(struct request *rq)
 {
 	struct request_queue *q = rq->q;
 
-	trace_block_rq_issue(q, rq);
+	trace_block_rq_issue(rq);
 
 	if (test_bit(QUEUE_FLAG_STATS, &q->queue_flags)) {
 		rq->io_start_time_ns = ktime_get_ns();
@@ -760,7 +760,7 @@ static void __blk_mq_requeue_request(struct request *rq)
 
 	blk_mq_put_driver_tag(rq);
 
-	trace_block_rq_requeue(q, rq);
+	trace_block_rq_requeue(rq);
 	rq_qos_requeue(q, rq);
 
 	if (blk_mq_request_started(rq)) {
@@ -1806,7 +1806,7 @@ static inline void __blk_mq_insert_req_list(struct blk_mq_hw_ctx *hctx,
 
 	lockdep_assert_held(&ctx->lock);
 
-	trace_block_rq_insert(hctx->queue, rq);
+	trace_block_rq_insert(rq);
 
 	if (at_head)
 		list_add(&rq->queuelist, &ctx->rq_lists[type]);
@@ -1863,7 +1863,7 @@ void blk_mq_insert_requests(struct blk_mq_hw_ctx *hctx, struct blk_mq_ctx *ctx,
 	 */
 	list_for_each_entry(rq, list, queuelist) {
 		BUG_ON(rq->mq_ctx != ctx);
-		trace_block_rq_insert(hctx->queue, rq);
+		trace_block_rq_insert(rq);
 	}
 
 	spin_lock(&ctx->lock);
diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index 4833f4b20b2c..5f933dbb0152 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -397,7 +397,7 @@ static int map_request(struct dm_rq_target_io *tio)
 		}
 
 		/* The target has remapped the I/O so dispatch it */
-		trace_block_rq_remap(clone->q, clone, disk_devt(dm_disk(md)),
+		trace_block_rq_remap(clone, disk_devt(dm_disk(md)),
 				     blk_rq_pos(rq));
 		ret = dm_dispatch_clone_request(clone, rq);
 		if (ret == BLK_STS_RESOURCE || ret == BLK_STS_DEV_RESOURCE) {
diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index 6cb963a06777..37d450f46952 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -2359,8 +2359,7 @@ static void zfcp_fsf_req_trace(struct zfcp_fsf_req *req, struct scsi_cmnd *scsi)
 		}
 	}
 
-	blk_add_driver_data(scsi->request->q, scsi->request, &blktrc,
-			    sizeof(blktrc));
+	blk_add_driver_data(scsi->request, &blktrc, sizeof(blktrc));
 }
 
 /**
diff --git a/include/linux/blktrace_api.h b/include/linux/blktrace_api.h
index 3b6ff5902edc..05556573b896 100644
--- a/include/linux/blktrace_api.h
+++ b/include/linux/blktrace_api.h
@@ -75,8 +75,7 @@ static inline bool blk_trace_note_message_enabled(struct request_queue *q)
 	return ret;
 }
 
-extern void blk_add_driver_data(struct request_queue *q, struct request *rq,
-				void *data, size_t len);
+extern void blk_add_driver_data(struct request *rq, void *data, size_t len);
 extern int blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
 			   struct block_device *bdev,
 			   char __user *arg);
@@ -90,7 +89,7 @@ extern struct attribute_group blk_trace_attr_group;
 #else /* !CONFIG_BLK_DEV_IO_TRACE */
 # define blk_trace_ioctl(bdev, cmd, arg)		(-ENOTTY)
 # define blk_trace_shutdown(q)				do { } while (0)
-# define blk_add_driver_data(q, rq, data, len)		do {} while (0)
+# define blk_add_driver_data(rq, data, len)		do {} while (0)
 # define blk_trace_setup(q, name, dev, bdev, arg)	(-ENOTTY)
 # define blk_trace_startstop(q, start)			(-ENOTTY)
 # define blk_trace_remove(q)				(-ENOTTY)
diff --git a/include/trace/events/block.h b/include/trace/events/block.h
index 34d64ca306b1..76a6b3bbc01f 100644
--- a/include/trace/events/block.h
+++ b/include/trace/events/block.h
@@ -64,7 +64,6 @@ DEFINE_EVENT(block_buffer, block_dirty_buffer,
 
 /**
  * block_rq_requeue - place block IO request back on a queue
- * @q: queue holding operation
  * @rq: block IO operation request
  *
  * The block operation request @rq is being placed back into queue
@@ -73,9 +72,9 @@ DEFINE_EVENT(block_buffer, block_dirty_buffer,
  */
 TRACE_EVENT(block_rq_requeue,
 
-	TP_PROTO(struct request_queue *q, struct request *rq),
+	TP_PROTO(struct request *rq),
 
-	TP_ARGS(q, rq),
+	TP_ARGS(rq),
 
 	TP_STRUCT__entry(
 		__field(  dev_t,	dev			)
@@ -147,9 +146,9 @@ TRACE_EVENT(block_rq_complete,
 
 DECLARE_EVENT_CLASS(block_rq,
 
-	TP_PROTO(struct request_queue *q, struct request *rq),
+	TP_PROTO(struct request *rq),
 
-	TP_ARGS(q, rq),
+	TP_ARGS(rq),
 
 	TP_STRUCT__entry(
 		__field(  dev_t,	dev			)
@@ -181,7 +180,6 @@ DECLARE_EVENT_CLASS(block_rq,
 
 /**
  * block_rq_insert - insert block operation request into queue
- * @q: target queue
  * @rq: block IO operation request
  *
  * Called immediately before block operation request @rq is inserted
@@ -191,14 +189,13 @@ DECLARE_EVENT_CLASS(block_rq,
  */
 DEFINE_EVENT(block_rq, block_rq_insert,
 
-	TP_PROTO(struct request_queue *q, struct request *rq),
+	TP_PROTO(struct request *rq),
 
-	TP_ARGS(q, rq)
+	TP_ARGS(rq)
 );
 
 /**
  * block_rq_issue - issue pending block IO request operation to device driver
- * @q: queue holding operation
  * @rq: block IO operation operation request
  *
  * Called when block operation request @rq from queue @q is sent to a
@@ -206,14 +203,13 @@ DEFINE_EVENT(block_rq, block_rq_insert,
  */
 DEFINE_EVENT(block_rq, block_rq_issue,
 
-	TP_PROTO(struct request_queue *q, struct request *rq),
+	TP_PROTO(struct request *rq),
 
-	TP_ARGS(q, rq)
+	TP_ARGS(rq)
 );
 
 /**
  * block_rq_merge - merge request with another one in the elevator
- * @q: queue holding operation
  * @rq: block IO operation operation request
  *
  * Called when block operation request @rq from queue @q is merged to another
@@ -221,9 +217,9 @@ DEFINE_EVENT(block_rq, block_rq_issue,
  */
 DEFINE_EVENT(block_rq, block_rq_merge,
 
-	TP_PROTO(struct request_queue *q, struct request *rq),
+	TP_PROTO(struct request *rq),
 
-	TP_ARGS(q, rq)
+	TP_ARGS(rq)
 );
 
 /**
@@ -605,7 +601,6 @@ TRACE_EVENT(block_bio_remap,
 
 /**
  * block_rq_remap - map request for a block operation request
- * @q: queue holding the operation
  * @rq: block IO operation request
  * @dev: device for the operation
  * @from: original sector for the operation
@@ -616,10 +611,9 @@ TRACE_EVENT(block_bio_remap,
  */
 TRACE_EVENT(block_rq_remap,
 
-	TP_PROTO(struct request_queue *q, struct request *rq, dev_t dev,
-		 sector_t from),
+	TP_PROTO(struct request *rq, dev_t dev, sector_t from),
 
-	TP_ARGS(q, rq, dev, from),
+	TP_ARGS(rq, dev, from),
 
 	TP_STRUCT__entry(
 		__field( dev_t,		dev		)
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index b89ff188a618..7f625400763b 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -800,12 +800,12 @@ static u64 blk_trace_bio_get_cgid(struct request_queue *q, struct bio *bio)
 #endif
 
 static u64
-blk_trace_request_get_cgid(struct request_queue *q, struct request *rq)
+blk_trace_request_get_cgid(struct request *rq)
 {
 	if (!rq->bio)
 		return 0;
 	/* Use the first bio */
-	return blk_trace_bio_get_cgid(q, rq->bio);
+	return blk_trace_bio_get_cgid(rq->q, rq->bio);
 }
 
 /*
@@ -846,40 +846,35 @@ static void blk_add_trace_rq(struct request *rq, int error,
 	rcu_read_unlock();
 }
 
-static void blk_add_trace_rq_insert(void *ignore,
-				    struct request_queue *q, struct request *rq)
+static void blk_add_trace_rq_insert(void *ignore, struct request *rq)
 {
 	blk_add_trace_rq(rq, 0, blk_rq_bytes(rq), BLK_TA_INSERT,
-			 blk_trace_request_get_cgid(q, rq));
+			 blk_trace_request_get_cgid(rq));
 }
 
-static void blk_add_trace_rq_issue(void *ignore,
-				   struct request_queue *q, struct request *rq)
+static void blk_add_trace_rq_issue(void *ignore, struct request *rq)
 {
 	blk_add_trace_rq(rq, 0, blk_rq_bytes(rq), BLK_TA_ISSUE,
-			 blk_trace_request_get_cgid(q, rq));
+			 blk_trace_request_get_cgid(rq));
 }
 
-static void blk_add_trace_rq_merge(void *ignore,
-				   struct request_queue *q, struct request *rq)
+static void blk_add_trace_rq_merge(void *ignore, struct request *rq)
 {
 	blk_add_trace_rq(rq, 0, blk_rq_bytes(rq), BLK_TA_BACKMERGE,
-			 blk_trace_request_get_cgid(q, rq));
+			 blk_trace_request_get_cgid(rq));
 }
 
-static void blk_add_trace_rq_requeue(void *ignore,
-				     struct request_queue *q,
-				     struct request *rq)
+static void blk_add_trace_rq_requeue(void *ignore, struct request *rq)
 {
 	blk_add_trace_rq(rq, 0, blk_rq_bytes(rq), BLK_TA_REQUEUE,
-			 blk_trace_request_get_cgid(q, rq));
+			 blk_trace_request_get_cgid(rq));
 }
 
 static void blk_add_trace_rq_complete(void *ignore, struct request *rq,
 			int error, unsigned int nr_bytes)
 {
 	blk_add_trace_rq(rq, error, nr_bytes, BLK_TA_COMPLETE,
-			 blk_trace_request_get_cgid(rq->q, rq));
+			 blk_trace_request_get_cgid(rq));
 }
 
 /**
@@ -1087,16 +1082,14 @@ static void blk_add_trace_bio_remap(void *ignore,
  *     Add a trace for that action.
  *
  **/
-static void blk_add_trace_rq_remap(void *ignore,
-				   struct request_queue *q,
-				   struct request *rq, dev_t dev,
+static void blk_add_trace_rq_remap(void *ignore, struct request *rq, dev_t dev,
 				   sector_t from)
 {
 	struct blk_trace *bt;
 	struct blk_io_trace_remap r;
 
 	rcu_read_lock();
-	bt = rcu_dereference(q->blk_trace);
+	bt = rcu_dereference(rq->q->blk_trace);
 	if (likely(!bt)) {
 		rcu_read_unlock();
 		return;
@@ -1108,13 +1101,12 @@ static void blk_add_trace_rq_remap(void *ignore,
 
 	__blk_add_trace(bt, blk_rq_pos(rq), blk_rq_bytes(rq),
 			rq_data_dir(rq), 0, BLK_TA_REMAP, 0,
-			sizeof(r), &r, blk_trace_request_get_cgid(q, rq));
+			sizeof(r), &r, blk_trace_request_get_cgid(rq));
 	rcu_read_unlock();
 }
 
 /**
  * blk_add_driver_data - Add binary message with driver-specific data
- * @q:		queue the io is for
  * @rq:		io request
  * @data:	driver-specific data
  * @len:	length of driver-specific data
@@ -1123,14 +1115,12 @@ static void blk_add_trace_rq_remap(void *ignore,
  *     Some drivers might want to write driver-specific data per request.
  *
  **/
-void blk_add_driver_data(struct request_queue *q,
-			 struct request *rq,
-			 void *data, size_t len)
+void blk_add_driver_data(struct request *rq, void *data, size_t len)
 {
 	struct blk_trace *bt;
 
 	rcu_read_lock();
-	bt = rcu_dereference(q->blk_trace);
+	bt = rcu_dereference(rq->q->blk_trace);
 	if (likely(!bt)) {
 		rcu_read_unlock();
 		return;
@@ -1138,7 +1128,7 @@ void blk_add_driver_data(struct request_queue *q,
 
 	__blk_add_trace(bt, blk_rq_trace_sector(rq), blk_rq_bytes(rq), 0, 0,
 				BLK_TA_DRV_DATA, 0, len, data,
-				blk_trace_request_get_cgid(q, rq));
+				blk_trace_request_get_cgid(rq));
 	rcu_read_unlock();
 }
 EXPORT_SYMBOL_GPL(blk_add_driver_data);
-- 
2.35.1



