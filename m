Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E005594808
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344821AbiHOXTC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:19:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353579AbiHOXQ6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:16:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 881557C18D;
        Mon, 15 Aug 2022 13:03:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A52861226;
        Mon, 15 Aug 2022 20:03:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D145C433C1;
        Mon, 15 Aug 2022 20:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593814;
        bh=/BFaRg1u6qCe8vxEaMLKAqBdBVsQGZo/dzYZ3T2e9as=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ghoN2hBUO1NQ1Jbx6IAqP7BTFNuTgj8ZLOfIVmiuP9OB9tGOf8kJuSpF28DXfVO76
         h7fMwUUqhNtTF0M/GNuNUsdLcgAr5Oxz9InjT65AzOq+q8SKRTi7jsBhuNQgvJfUgr
         kzAHSDkPjaCH5hmKoBJN8DYpfWQ1EAyfLmpqn/V0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 1010/1095] block: serialize all debugfs operations using q->debugfs_mutex
Date:   Mon, 15 Aug 2022 20:06:49 +0200
Message-Id: <20220815180510.893822245@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

[ Upstream commit 5cf9c91ba927119fc6606b938b1895bb2459d3bc ]

Various places like I/O schedulers or the QOS infrastructure try to
register debugfs files on demans, which can race with creating and
removing the main queue debugfs directory.  Use the existing
debugfs_mutex to serialize all debugfs operations that rely on
q->debugfs_dir or the directories hanging off it.

To make the teardown code a little simpler declare all debugfs dentry
pointers and not just the main one uncoditionally in blkdev.h.

Move debugfs_mutex next to the dentries that it protects and document
what it is used for.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20220614074827.458955-3-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq-debugfs.c  | 25 ++++++++++++++++++++-----
 block/blk-mq-debugfs.h  |  5 -----
 block/blk-mq-sched.c    | 11 +++++++++++
 block/blk-rq-qos.c      |  2 ++
 block/blk-rq-qos.h      |  7 ++++++-
 block/blk-sysfs.c       | 20 +++++++++-----------
 include/linux/blkdev.h  |  8 ++++----
 kernel/trace/blktrace.c |  3 ---
 8 files changed, 52 insertions(+), 29 deletions(-)

diff --git a/block/blk-mq-debugfs.c b/block/blk-mq-debugfs.c
index 34bee263936c..d491b6eb0ab9 100644
--- a/block/blk-mq-debugfs.c
+++ b/block/blk-mq-debugfs.c
@@ -713,11 +713,6 @@ void blk_mq_debugfs_register(struct request_queue *q)
 	}
 }
 
-void blk_mq_debugfs_unregister(struct request_queue *q)
-{
-	q->sched_debugfs_dir = NULL;
-}
-
 static void blk_mq_debugfs_register_ctx(struct blk_mq_hw_ctx *hctx,
 					struct blk_mq_ctx *ctx)
 {
@@ -751,6 +746,8 @@ void blk_mq_debugfs_register_hctx(struct request_queue *q,
 
 void blk_mq_debugfs_unregister_hctx(struct blk_mq_hw_ctx *hctx)
 {
+	if (!hctx->queue->debugfs_dir)
+		return;
 	debugfs_remove_recursive(hctx->debugfs_dir);
 	hctx->sched_debugfs_dir = NULL;
 	hctx->debugfs_dir = NULL;
@@ -778,6 +775,8 @@ void blk_mq_debugfs_register_sched(struct request_queue *q)
 {
 	struct elevator_type *e = q->elevator->type;
 
+	lockdep_assert_held(&q->debugfs_mutex);
+
 	/*
 	 * If the parent directory has not been created yet, return, we will be
 	 * called again later on and the directory/files will be created then.
@@ -795,6 +794,8 @@ void blk_mq_debugfs_register_sched(struct request_queue *q)
 
 void blk_mq_debugfs_unregister_sched(struct request_queue *q)
 {
+	lockdep_assert_held(&q->debugfs_mutex);
+
 	debugfs_remove_recursive(q->sched_debugfs_dir);
 	q->sched_debugfs_dir = NULL;
 }
@@ -816,6 +817,10 @@ static const char *rq_qos_id_to_name(enum rq_qos_id id)
 
 void blk_mq_debugfs_unregister_rqos(struct rq_qos *rqos)
 {
+	lockdep_assert_held(&rqos->q->debugfs_mutex);
+
+	if (!rqos->q->debugfs_dir)
+		return;
 	debugfs_remove_recursive(rqos->debugfs_dir);
 	rqos->debugfs_dir = NULL;
 }
@@ -825,6 +830,8 @@ void blk_mq_debugfs_register_rqos(struct rq_qos *rqos)
 	struct request_queue *q = rqos->q;
 	const char *dir_name = rq_qos_id_to_name(rqos->id);
 
+	lockdep_assert_held(&q->debugfs_mutex);
+
 	if (rqos->debugfs_dir || !rqos->ops->debugfs_attrs)
 		return;
 
@@ -840,6 +847,8 @@ void blk_mq_debugfs_register_rqos(struct rq_qos *rqos)
 
 void blk_mq_debugfs_unregister_queue_rqos(struct request_queue *q)
 {
+	lockdep_assert_held(&q->debugfs_mutex);
+
 	debugfs_remove_recursive(q->rqos_debugfs_dir);
 	q->rqos_debugfs_dir = NULL;
 }
@@ -849,6 +858,8 @@ void blk_mq_debugfs_register_sched_hctx(struct request_queue *q,
 {
 	struct elevator_type *e = q->elevator->type;
 
+	lockdep_assert_held(&q->debugfs_mutex);
+
 	/*
 	 * If the parent debugfs directory has not been created yet, return;
 	 * We will be called again later on with appropriate parent debugfs
@@ -868,6 +879,10 @@ void blk_mq_debugfs_register_sched_hctx(struct request_queue *q,
 
 void blk_mq_debugfs_unregister_sched_hctx(struct blk_mq_hw_ctx *hctx)
 {
+	lockdep_assert_held(&hctx->queue->debugfs_mutex);
+
+	if (!hctx->queue->debugfs_dir)
+		return;
 	debugfs_remove_recursive(hctx->sched_debugfs_dir);
 	hctx->sched_debugfs_dir = NULL;
 }
diff --git a/block/blk-mq-debugfs.h b/block/blk-mq-debugfs.h
index 69918f4170d6..771d45832878 100644
--- a/block/blk-mq-debugfs.h
+++ b/block/blk-mq-debugfs.h
@@ -21,7 +21,6 @@ int __blk_mq_debugfs_rq_show(struct seq_file *m, struct request *rq);
 int blk_mq_debugfs_rq_show(struct seq_file *m, void *v);
 
 void blk_mq_debugfs_register(struct request_queue *q);
-void blk_mq_debugfs_unregister(struct request_queue *q);
 void blk_mq_debugfs_register_hctx(struct request_queue *q,
 				  struct blk_mq_hw_ctx *hctx);
 void blk_mq_debugfs_unregister_hctx(struct blk_mq_hw_ctx *hctx);
@@ -42,10 +41,6 @@ static inline void blk_mq_debugfs_register(struct request_queue *q)
 {
 }
 
-static inline void blk_mq_debugfs_unregister(struct request_queue *q)
-{
-}
-
 static inline void blk_mq_debugfs_register_hctx(struct request_queue *q,
 						struct blk_mq_hw_ctx *hctx)
 {
diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
index 9e56a69422b6..e84bec39fd3a 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -593,7 +593,9 @@ int blk_mq_init_sched(struct request_queue *q, struct elevator_type *e)
 	if (ret)
 		goto err_free_map_and_rqs;
 
+	mutex_lock(&q->debugfs_mutex);
 	blk_mq_debugfs_register_sched(q);
+	mutex_unlock(&q->debugfs_mutex);
 
 	queue_for_each_hw_ctx(q, hctx, i) {
 		if (e->ops.init_hctx) {
@@ -606,7 +608,9 @@ int blk_mq_init_sched(struct request_queue *q, struct elevator_type *e)
 				return ret;
 			}
 		}
+		mutex_lock(&q->debugfs_mutex);
 		blk_mq_debugfs_register_sched_hctx(q, hctx);
+		mutex_unlock(&q->debugfs_mutex);
 	}
 
 	return 0;
@@ -647,14 +651,21 @@ void blk_mq_exit_sched(struct request_queue *q, struct elevator_queue *e)
 	unsigned int flags = 0;
 
 	queue_for_each_hw_ctx(q, hctx, i) {
+		mutex_lock(&q->debugfs_mutex);
 		blk_mq_debugfs_unregister_sched_hctx(hctx);
+		mutex_unlock(&q->debugfs_mutex);
+
 		if (e->type->ops.exit_hctx && hctx->sched_data) {
 			e->type->ops.exit_hctx(hctx, i);
 			hctx->sched_data = NULL;
 		}
 		flags = hctx->flags;
 	}
+
+	mutex_lock(&q->debugfs_mutex);
 	blk_mq_debugfs_unregister_sched(q);
+	mutex_unlock(&q->debugfs_mutex);
+
 	if (e->type->ops.exit_sched)
 		e->type->ops.exit_sched(e);
 	blk_mq_sched_tags_teardown(q, flags);
diff --git a/block/blk-rq-qos.c b/block/blk-rq-qos.c
index e83af7bc7591..249a6f05dd3b 100644
--- a/block/blk-rq-qos.c
+++ b/block/blk-rq-qos.c
@@ -294,7 +294,9 @@ void rq_qos_wait(struct rq_wait *rqw, void *private_data,
 
 void rq_qos_exit(struct request_queue *q)
 {
+	mutex_lock(&q->debugfs_mutex);
 	blk_mq_debugfs_unregister_queue_rqos(q);
+	mutex_unlock(&q->debugfs_mutex);
 
 	while (q->rq_qos) {
 		struct rq_qos *rqos = q->rq_qos;
diff --git a/block/blk-rq-qos.h b/block/blk-rq-qos.h
index 68267007da1c..0e46052b018a 100644
--- a/block/blk-rq-qos.h
+++ b/block/blk-rq-qos.h
@@ -104,8 +104,11 @@ static inline void rq_qos_add(struct request_queue *q, struct rq_qos *rqos)
 
 	blk_mq_unfreeze_queue(q);
 
-	if (rqos->ops->debugfs_attrs)
+	if (rqos->ops->debugfs_attrs) {
+		mutex_lock(&q->debugfs_mutex);
 		blk_mq_debugfs_register_rqos(rqos);
+		mutex_unlock(&q->debugfs_mutex);
+	}
 }
 
 static inline void rq_qos_del(struct request_queue *q, struct rq_qos *rqos)
@@ -129,7 +132,9 @@ static inline void rq_qos_del(struct request_queue *q, struct rq_qos *rqos)
 
 	blk_mq_unfreeze_queue(q);
 
+	mutex_lock(&q->debugfs_mutex);
 	blk_mq_debugfs_unregister_rqos(rqos);
+	mutex_unlock(&q->debugfs_mutex);
 }
 
 typedef bool (acquire_inflight_cb_t)(struct rq_wait *rqw, void *private_data);
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 88bd41d4cb59..6e4801b217a7 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -779,14 +779,13 @@ static void blk_release_queue(struct kobject *kobj)
 	if (queue_is_mq(q))
 		blk_mq_release(q);
 
-	blk_trace_shutdown(q);
 	mutex_lock(&q->debugfs_mutex);
+	blk_trace_shutdown(q);
 	debugfs_remove_recursive(q->debugfs_dir);
+	q->debugfs_dir = NULL;
+	q->sched_debugfs_dir = NULL;
 	mutex_unlock(&q->debugfs_mutex);
 
-	if (queue_is_mq(q))
-		blk_mq_debugfs_unregister(q);
-
 	bioset_exit(&q->bio_split);
 
 	if (blk_queue_has_srcu(q))
@@ -836,17 +835,16 @@ int blk_register_queue(struct gendisk *disk)
 		goto unlock;
 	}
 
+	if (queue_is_mq(q))
+		__blk_mq_register_dev(dev, q);
+	mutex_lock(&q->sysfs_lock);
+
 	mutex_lock(&q->debugfs_mutex);
 	q->debugfs_dir = debugfs_create_dir(kobject_name(q->kobj.parent),
 					    blk_debugfs_root);
-	mutex_unlock(&q->debugfs_mutex);
-
-	if (queue_is_mq(q)) {
-		__blk_mq_register_dev(dev, q);
+	if (queue_is_mq(q))
 		blk_mq_debugfs_register(q);
-	}
-
-	mutex_lock(&q->sysfs_lock);
+	mutex_unlock(&q->debugfs_mutex);
 
 	ret = disk_register_independent_access_ranges(disk, NULL);
 	if (ret)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 108e3d114bfc..cc6b24a5098f 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -466,7 +466,6 @@ struct request_queue {
 #endif /* CONFIG_BLK_DEV_ZONED */
 
 	int			node;
-	struct mutex		debugfs_mutex;
 #ifdef CONFIG_BLK_DEV_IO_TRACE
 	struct blk_trace __rcu	*blk_trace;
 #endif
@@ -510,11 +509,12 @@ struct request_queue {
 	struct bio_set		bio_split;
 
 	struct dentry		*debugfs_dir;
-
-#ifdef CONFIG_BLK_DEBUG_FS
 	struct dentry		*sched_debugfs_dir;
 	struct dentry		*rqos_debugfs_dir;
-#endif
+	/*
+	 * Serializes all debugfs metadata operations using the above dentries.
+	 */
+	struct mutex		debugfs_mutex;
 
 	bool			mq_sysfs_init_done;
 
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index f22219495541..f0500b5cfefe 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -770,14 +770,11 @@ int blk_trace_ioctl(struct block_device *bdev, unsigned cmd, char __user *arg)
  **/
 void blk_trace_shutdown(struct request_queue *q)
 {
-	mutex_lock(&q->debugfs_mutex);
 	if (rcu_dereference_protected(q->blk_trace,
 				      lockdep_is_held(&q->debugfs_mutex))) {
 		__blk_trace_startstop(q, 0);
 		__blk_trace_remove(q);
 	}
-
-	mutex_unlock(&q->debugfs_mutex);
 }
 
 #ifdef CONFIG_BLK_CGROUP
-- 
2.35.1



