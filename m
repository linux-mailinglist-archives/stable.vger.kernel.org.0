Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 797EE10EAC7
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 14:24:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727408AbfLBNY5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 08:24:57 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:35258 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727442AbfLBNY5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Dec 2019 08:24:57 -0500
Received: from hades.home (unknown [IPv6:2a00:23c5:582:9d00:2d93:25f:7679:a491])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: martyn)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id 8F66E28FD50;
        Mon,  2 Dec 2019 13:24:55 +0000 (GMT)
From:   Martyn Welch <martyn.welch@collabora.com>
To:     stable@vger.kernel.org
Cc:     kernel@collabora.com, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Yi Zhang <yi.zhang@redhat.com>,
        kernel test robot <rong.a.chen@intel.com>,
        Jens Axboe <axboe@kernel.dk>,
        Martyn Welch <martyn.welch@collabora.com>
Subject: [PATCH 2/3] block: free sched's request pool in blk_cleanup_queue
Date:   Mon,  2 Dec 2019 13:24:45 +0000
Message-Id: <20191202132446.3623809-3-martyn.welch@collabora.com>
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

commit c3e2219216c92919a6bd1711f340f5faa98695e6 upstream.

In theory, IO scheduler belongs to request queue, and the request pool
of sched tags belongs to the request queue too.

However, the current tags allocation interfaces are re-used for both
driver tags and sched tags, and driver tags is definitely host wide,
and doesn't belong to any request queue, same with its request pool.
So we need tagset instance for freeing request of sched tags.

Meantime, blk_mq_free_tag_set() often follows blk_cleanup_queue() in case
of non-BLK_MQ_F_TAG_SHARED, this way requires that request pool of sched
tags to be freed before calling blk_mq_free_tag_set().

Commit 47cdee29ef9d94e ("block: move blk_exit_queue into __blk_release_queue")
moves blk_exit_queue into __blk_release_queue for simplying the fast
path in generic_make_request(), then causes oops during freeing requests
of sched tags in __blk_release_queue().

Fix the above issue by move freeing request pool of sched tags into
blk_cleanup_queue(), this way is safe becasue queue has been frozen and no any
in-queue requests at that time. Freeing sched tags has to be kept in queue's
release handler becasue there might be un-completed dispatch activity
which might refer to sched tags.

Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@lst.de>
Fixes: 47cdee29ef9d94e485eb08f962c74943023a5271 ("block: move blk_exit_queue into __blk_release_queue")
Tested-by: Yi Zhang <yi.zhang@redhat.com>
Reported-by: kernel test robot <rong.a.chen@intel.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
(cherry picked/backported from commit c3e2219216c92919a6bd1711f340f5faa98695e6)
Signed-off-by: Martyn Welch <martyn.welch@collabora.com>
---
 block/blk-core.c     | 13 +++++++++++++
 block/blk-mq-sched.c | 30 +++++++++++++++++++++++++++---
 block/blk-mq-sched.h |  1 +
 block/blk-sysfs.c    |  2 +-
 block/blk.h          | 10 +++++++++-
 block/elevator.c     |  2 +-
 6 files changed, 52 insertions(+), 6 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 28df78c5db34..747e87816283 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -784,6 +784,19 @@ void blk_cleanup_queue(struct request_queue *q)
 	if (q->mq_ops)
 		blk_mq_exit_queue(q);
 
+	/*
+	 * In theory, request pool of sched_tags belongs to request queue.
+	 * However, the current implementation requires tag_set for freeing
+	 * requests, so free the pool now.
+	 *
+	 * Queue has become frozen, there can't be any in-queue requests, so
+	 * it is safe to free requests now.
+	 */
+	mutex_lock(&q->sysfs_lock);
+	if (q->elevator)
+		blk_mq_sched_free_requests(q);
+	mutex_unlock(&q->sysfs_lock);
+
 	percpu_ref_exit(&q->q_usage_counter);
 
 	spin_lock_irq(lock);
diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
index da1de190a3b1..105f8c124604 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -453,14 +453,18 @@ static int blk_mq_sched_alloc_tags(struct request_queue *q,
 	return ret;
 }
 
+/* called in queue's release handler, tagset has gone away */
 static void blk_mq_sched_tags_teardown(struct request_queue *q)
 {
-	struct blk_mq_tag_set *set = q->tag_set;
 	struct blk_mq_hw_ctx *hctx;
 	int i;
 
-	queue_for_each_hw_ctx(q, hctx, i)
-		blk_mq_sched_free_tags(set, hctx, i);
+	queue_for_each_hw_ctx(q, hctx, i) {
+		if (hctx->sched_tags) {
+			blk_mq_free_rq_map(hctx->sched_tags);
+			hctx->sched_tags = NULL;
+		}
+	}
 }
 
 int blk_mq_init_sched(struct request_queue *q, struct elevator_type *e)
@@ -501,6 +505,7 @@ int blk_mq_init_sched(struct request_queue *q, struct elevator_type *e)
 			ret = e->ops.mq.init_hctx(hctx, i);
 			if (ret) {
 				eq = q->elevator;
+				blk_mq_sched_free_requests(q);
 				blk_mq_exit_sched(q, eq);
 				kobject_put(&eq->kobj);
 				return ret;
@@ -512,11 +517,30 @@ int blk_mq_init_sched(struct request_queue *q, struct elevator_type *e)
 	return 0;
 
 err:
+	blk_mq_sched_free_requests(q);
 	blk_mq_sched_tags_teardown(q);
 	q->elevator = NULL;
 	return ret;
 }
 
+/*
+ * called in either blk_queue_cleanup or elevator_switch, tagset
+ * is required for freeing requests
+ */
+void blk_mq_sched_free_requests(struct request_queue *q)
+{
+	struct blk_mq_hw_ctx *hctx;
+	int i;
+
+	lockdep_assert_held(&q->sysfs_lock);
+	WARN_ON(!q->elevator);
+
+	queue_for_each_hw_ctx(q, hctx, i) {
+		if (hctx->sched_tags)
+			blk_mq_free_rqs(q->tag_set, hctx->sched_tags, i);
+	}
+}
+
 void blk_mq_exit_sched(struct request_queue *q, struct elevator_queue *e)
 {
 	struct blk_mq_hw_ctx *hctx;
diff --git a/block/blk-mq-sched.h b/block/blk-mq-sched.h
index fe660764b8d1..d97e13fe8ece 100644
--- a/block/blk-mq-sched.h
+++ b/block/blk-mq-sched.h
@@ -28,6 +28,7 @@ void blk_mq_sched_dispatch_requests(struct blk_mq_hw_ctx *hctx);
 
 int blk_mq_init_sched(struct request_queue *q, struct elevator_type *e);
 void blk_mq_exit_sched(struct request_queue *q, struct elevator_queue *e);
+void blk_mq_sched_free_requests(struct request_queue *q);
 
 static inline bool
 blk_mq_sched_bio_merge(struct request_queue *q, struct bio *bio)
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 1d0e5463f3b6..718222dc6f83 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -804,7 +804,7 @@ static void blk_exit_queue(struct request_queue *q)
 	 */
 	if (q->elevator) {
 		ioc_clear_queue(q);
-		elevator_exit(q, q->elevator);
+		__elevator_exit(q, q->elevator);
 		q->elevator = NULL;
 	}
 
diff --git a/block/blk.h b/block/blk.h
index 9af0b67ef332..169a2ec6325a 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -5,6 +5,7 @@
 #include <linux/idr.h>
 #include <linux/blk-mq.h>
 #include "blk-mq.h"
+#include "blk-mq-sched.h"
 
 /* Amount of time in which a process may batch requests */
 #define BLK_BATCH_TIME	(HZ/50UL)
@@ -242,10 +243,17 @@ int elevator_init(struct request_queue *);
 int elevator_init_mq(struct request_queue *q);
 int elevator_switch_mq(struct request_queue *q,
 			      struct elevator_type *new_e);
-void elevator_exit(struct request_queue *, struct elevator_queue *);
+void __elevator_exit(struct request_queue *, struct elevator_queue *);
 int elv_register_queue(struct request_queue *q);
 void elv_unregister_queue(struct request_queue *q);
 
+static inline void elevator_exit(struct request_queue *q,
+		struct elevator_queue *e)
+{
+	blk_mq_sched_free_requests(q);
+	__elevator_exit(q, e);
+}
+
 struct hd_struct *__disk_get_part(struct gendisk *disk, int partno);
 
 #ifdef CONFIG_FAIL_IO_TIMEOUT
diff --git a/block/elevator.c b/block/elevator.c
index fae58b2f906f..4dcb925eac13 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -240,7 +240,7 @@ int elevator_init(struct request_queue *q)
 	return err;
 }
 
-void elevator_exit(struct request_queue *q, struct elevator_queue *e)
+void __elevator_exit(struct request_queue *q, struct elevator_queue *e)
 {
 	mutex_lock(&e->sysfs_lock);
 	if (e->uses_mq && e->type->ops.mq.exit_sched)
-- 
2.24.0

