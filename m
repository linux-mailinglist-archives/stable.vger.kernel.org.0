Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1015510EAC6
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 14:24:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727506AbfLBNY5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 08:24:57 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:35244 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727408AbfLBNY5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Dec 2019 08:24:57 -0500
Received: from hades.home (unknown [IPv6:2a00:23c5:582:9d00:2d93:25f:7679:a491])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: martyn)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id 5091C28FD4F;
        Mon,  2 Dec 2019 13:24:55 +0000 (GMT)
From:   Martyn Welch <martyn.welch@collabora.com>
To:     stable@vger.kernel.org
Cc:     kernel@collabora.com, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Martyn Welch <martyn.welch@collabora.com>
Subject: [PATCH 1/3] block: move blk_exit_queue into __blk_release_queue
Date:   Mon,  2 Dec 2019 13:24:44 +0000
Message-Id: <20191202132446.3623809-2-martyn.welch@collabora.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191202132446.3623809-1-martyn.welch@collabora.com>
References: <20191202132446.3623809-1-martyn.welch@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

commit 47cdee29ef9d94e485eb08f962c74943023a5271 upstream.

Commit 498f6650aec8 ("block: Fix a race between the cgroup code and
request queue initialization") moves what blk_exit_queue does into
blk_cleanup_queue() for fixing issue caused by changing back
queue lock.

However, after legacy request IO path is killed, driver queue lock
won't be used at all, and there isn't story for changing back
queue lock. Then the issue addressed by Commit 498f6650aec8 doesn't
exist any more.

So move move blk_exit_queue into __blk_release_queue.

This patch basically reverts the following two commits:

	498f6650aec8 block: Fix a race between the cgroup code and request queue initialization
	24ecc3585348 block: Ensure that a request queue is dissociated from the cgroup controller

Cc: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
(cherry picked/backported from commit 47cdee29ef9d94e485eb08f962c74943023a5271)
Signed-off-by: Martyn Welch <martyn.welch@collabora.com>
---
 block/blk-core.c  | 37 -------------------------------------
 block/blk-sysfs.c | 47 ++++++++++++++++++++++++++++++++---------------
 block/blk.h       |  1 -
 3 files changed, 32 insertions(+), 53 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index ea33d6abdcfc..28df78c5db34 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -716,35 +716,6 @@ void blk_set_queue_dying(struct request_queue *q)
 }
 EXPORT_SYMBOL_GPL(blk_set_queue_dying);
 
-/* Unconfigure the I/O scheduler and dissociate from the cgroup controller. */
-void blk_exit_queue(struct request_queue *q)
-{
-	/*
-	 * Since the I/O scheduler exit code may access cgroup information,
-	 * perform I/O scheduler exit before disassociating from the block
-	 * cgroup controller.
-	 */
-	if (q->elevator) {
-		ioc_clear_queue(q);
-		elevator_exit(q, q->elevator);
-		q->elevator = NULL;
-	}
-
-	/*
-	 * Remove all references to @q from the block cgroup controller before
-	 * restoring @q->queue_lock to avoid that restoring this pointer causes
-	 * e.g. blkcg_print_blkgs() to crash.
-	 */
-	blkcg_exit_queue(q);
-
-	/*
-	 * Since the cgroup code may dereference the @q->backing_dev_info
-	 * pointer, only decrease its reference count after having removed the
-	 * association with the block cgroup controller.
-	 */
-	bdi_put(q->backing_dev_info);
-}
-
 /**
  * blk_cleanup_queue - shutdown a request queue
  * @q: request queue to shutdown
@@ -810,14 +781,6 @@ void blk_cleanup_queue(struct request_queue *q)
 	del_timer_sync(&q->backing_dev_info->laptop_mode_wb_timer);
 	blk_sync_queue(q);
 
-	/*
-	 * I/O scheduler exit is only safe after the sysfs scheduler attribute
-	 * has been removed.
-	 */
-	WARN_ON_ONCE(q->kobj.state_in_sysfs);
-
-	blk_exit_queue(q);
-
 	if (q->mq_ops)
 		blk_mq_exit_queue(q);
 
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 8286640d4d66..1d0e5463f3b6 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -794,6 +794,36 @@ static void blk_free_queue_rcu(struct rcu_head *rcu_head)
 	kmem_cache_free(blk_requestq_cachep, q);
 }
 
+/* Unconfigure the I/O scheduler and dissociate from the cgroup controller. */
+static void blk_exit_queue(struct request_queue *q)
+{
+	/*
+	 * Since the I/O scheduler exit code may access cgroup information,
+	 * perform I/O scheduler exit before disassociating from the block
+	 * cgroup controller.
+	 */
+	if (q->elevator) {
+		ioc_clear_queue(q);
+		elevator_exit(q, q->elevator);
+		q->elevator = NULL;
+	}
+
+	/*
+	 * Remove all references to @q from the block cgroup controller before
+	 * restoring @q->queue_lock to avoid that restoring this pointer causes
+	 * e.g. blkcg_print_blkgs() to crash.
+	 */
+	blkcg_exit_queue(q);
+
+	/*
+	 * Since the cgroup code may dereference the @q->backing_dev_info
+	 * pointer, only decrease its reference count after having removed the
+	 * association with the block cgroup controller.
+	 */
+	bdi_put(q->backing_dev_info);
+}
+
+
 /**
  * __blk_release_queue - release a request queue when it is no longer needed
  * @work: pointer to the release_work member of the request queue to be released
@@ -819,21 +849,6 @@ static void __blk_release_queue(struct work_struct *work)
 		blk_stat_remove_callback(q, q->poll_cb);
 	blk_stat_free_callback(q->poll_cb);
 
-	if (!blk_queue_dead(q)) {
-		/*
-		 * Last reference was dropped without having called
-		 * blk_cleanup_queue().
-		 */
-		WARN_ONCE(blk_queue_init_done(q),
-			  "request queue %p has been registered but blk_cleanup_queue() has not been called for that queue\n",
-			  q);
-		blk_exit_queue(q);
-	}
-
-	WARN(blk_queue_root_blkg(q),
-	     "request queue %p is being released but it has not yet been removed from the blkcg controller\n",
-	     q);
-
 	blk_free_queue_stats(q->stats);
 
 	if (q->mq_ops)
@@ -844,6 +859,8 @@ static void __blk_release_queue(struct work_struct *work)
 	if (q->queue_tags)
 		__blk_queue_free_tags(q);
 
+	blk_exit_queue(q);
+
 	if (!q->mq_ops) {
 		if (q->exit_rq_fn)
 			q->exit_rq_fn(q, q->fq->flush_rq);
diff --git a/block/blk.h b/block/blk.h
index 1a5b67b57e6b..9af0b67ef332 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -137,7 +137,6 @@ void blk_free_flush_queue(struct blk_flush_queue *q);
 int blk_init_rl(struct request_list *rl, struct request_queue *q,
 		gfp_t gfp_mask);
 void blk_exit_rl(struct request_queue *q, struct request_list *rl);
-void blk_exit_queue(struct request_queue *q);
 void blk_rq_bio_prep(struct request_queue *q, struct request *rq,
 			struct bio *bio);
 void blk_queue_bypass_start(struct request_queue *q);
-- 
2.24.0

