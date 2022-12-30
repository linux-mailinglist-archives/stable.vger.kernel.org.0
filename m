Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C730658296
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:38:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233624AbiL1Qil (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:38:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234980AbiL1Qhq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:37:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80B7A1A223
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:33:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A48061576
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:33:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B412C433D2;
        Wed, 28 Dec 2022 16:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245220;
        bh=XSQ+gHGwxJSr0QgnoAxTWH8NBgRxRNWB5qvPYDchsqI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PHNvCg9AnAO9bwA2f3OXgXmy4nLvPLQWmrLnkQvg+hwA0WkqZqWSjOmrZxl4X0/1t
         2IY77ad11iw9izGg1AxKhQ19YnlY46mwdvhA2HOrYfCgACB59VRYFBVuJCjihmgyG6
         ak5m0NDPjpnSoqIs8JX3DxWgil/AOOLvSLfKQzug=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>,
        Ming Lei <ming.lei@redhat.com>,
        Chao Leng <lengchao@huawei.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Hannes Reinecke <hare@suse.de>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0853/1073] blk-mq: move the srcu_struct used for quiescing to the tagset
Date:   Wed, 28 Dec 2022 15:40:41 +0100
Message-Id: <20221228144351.187844650@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

[ Upstream commit 80bd4a7aab4c9ce59bf5e35fdf52aa23d8a3c9f5 ]

All I/O submissions have fairly similar latencies, and a tagset-wide
quiesce is a fairly common operation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Chao Leng <lengchao@huawei.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Link: https://lore.kernel.org/r/20221101150050.3510-12-hch@lst.de
[axboe: fix whitespace]
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: d36a9ea5e776 ("block: fix use-after-free of q->q_usage_counter")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-core.c       | 27 +++++----------------------
 block/blk-mq.c         | 33 +++++++++++++++++++++++++--------
 block/blk-mq.h         | 14 +++++++-------
 block/blk-sysfs.c      |  9 ++-------
 block/blk.h            |  9 +--------
 block/genhd.c          |  2 +-
 include/linux/blk-mq.h |  4 ++++
 include/linux/blkdev.h |  9 ---------
 8 files changed, 45 insertions(+), 62 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 2fbdf17f2206..adc5fc562348 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -66,7 +66,6 @@ DEFINE_IDA(blk_queue_ida);
  * For queue allocation
  */
 struct kmem_cache *blk_requestq_cachep;
-struct kmem_cache *blk_requestq_srcu_cachep;
 
 /*
  * Controlling structure to kblockd
@@ -374,26 +373,20 @@ static void blk_timeout_work(struct work_struct *work)
 {
 }
 
-struct request_queue *blk_alloc_queue(int node_id, bool alloc_srcu)
+struct request_queue *blk_alloc_queue(int node_id)
 {
 	struct request_queue *q;
 
-	q = kmem_cache_alloc_node(blk_get_queue_kmem_cache(alloc_srcu),
-			GFP_KERNEL | __GFP_ZERO, node_id);
+	q = kmem_cache_alloc_node(blk_requestq_cachep, GFP_KERNEL | __GFP_ZERO,
+				  node_id);
 	if (!q)
 		return NULL;
 
-	if (alloc_srcu) {
-		blk_queue_flag_set(QUEUE_FLAG_HAS_SRCU, q);
-		if (init_srcu_struct(q->srcu) != 0)
-			goto fail_q;
-	}
-
 	q->last_merge = NULL;
 
 	q->id = ida_alloc(&blk_queue_ida, GFP_KERNEL);
 	if (q->id < 0)
-		goto fail_srcu;
+		goto fail_q;
 
 	q->stats = blk_alloc_queue_stats();
 	if (!q->stats)
@@ -435,11 +428,8 @@ struct request_queue *blk_alloc_queue(int node_id, bool alloc_srcu)
 	blk_free_queue_stats(q->stats);
 fail_id:
 	ida_free(&blk_queue_ida, q->id);
-fail_srcu:
-	if (alloc_srcu)
-		cleanup_srcu_struct(q->srcu);
 fail_q:
-	kmem_cache_free(blk_get_queue_kmem_cache(alloc_srcu), q);
+	kmem_cache_free(blk_requestq_cachep, q);
 	return NULL;
 }
 
@@ -1198,9 +1188,6 @@ int __init blk_dev_init(void)
 			sizeof_field(struct request, cmd_flags));
 	BUILD_BUG_ON(REQ_OP_BITS + REQ_FLAG_BITS > 8 *
 			sizeof_field(struct bio, bi_opf));
-	BUILD_BUG_ON(ALIGN(offsetof(struct request_queue, srcu),
-			   __alignof__(struct request_queue)) !=
-		     sizeof(struct request_queue));
 
 	/* used for unplugging and affects IO latency/throughput - HIGHPRI */
 	kblockd_workqueue = alloc_workqueue("kblockd",
@@ -1211,10 +1198,6 @@ int __init blk_dev_init(void)
 	blk_requestq_cachep = kmem_cache_create("request_queue",
 			sizeof(struct request_queue), 0, SLAB_PANIC, NULL);
 
-	blk_requestq_srcu_cachep = kmem_cache_create("request_queue_srcu",
-			sizeof(struct request_queue) +
-			sizeof(struct srcu_struct), 0, SLAB_PANIC, NULL);
-
 	blk_debugfs_root = debugfs_create_dir("block", NULL);
 
 	return 0;
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 3f1f5e3e0951..88975170cc32 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -261,8 +261,8 @@ EXPORT_SYMBOL_GPL(blk_mq_quiesce_queue_nowait);
  */
 void blk_mq_wait_quiesce_done(struct request_queue *q)
 {
-	if (blk_queue_has_srcu(q))
-		synchronize_srcu(q->srcu);
+	if (q->tag_set->flags & BLK_MQ_F_BLOCKING)
+		synchronize_srcu(q->tag_set->srcu);
 	else
 		synchronize_rcu();
 }
@@ -3886,7 +3886,7 @@ static struct request_queue *blk_mq_init_queue_data(struct blk_mq_tag_set *set,
 	struct request_queue *q;
 	int ret;
 
-	q = blk_alloc_queue(set->numa_node, set->flags & BLK_MQ_F_BLOCKING);
+	q = blk_alloc_queue(set->numa_node);
 	if (!q)
 		return ERR_PTR(-ENOMEM);
 	q->queuedata = queuedata;
@@ -4058,9 +4058,6 @@ static void blk_mq_update_poll_flag(struct request_queue *q)
 int blk_mq_init_allocated_queue(struct blk_mq_tag_set *set,
 		struct request_queue *q)
 {
-	WARN_ON_ONCE(blk_queue_has_srcu(q) !=
-			!!(set->flags & BLK_MQ_F_BLOCKING));
-
 	/* mark the queue as mq asap */
 	q->mq_ops = set->ops;
 
@@ -4317,8 +4314,18 @@ int blk_mq_alloc_tag_set(struct blk_mq_tag_set *set)
 	if (set->nr_maps == 1 && set->nr_hw_queues > nr_cpu_ids)
 		set->nr_hw_queues = nr_cpu_ids;
 
-	if (blk_mq_alloc_tag_set_tags(set, set->nr_hw_queues) < 0)
-		return -ENOMEM;
+	if (set->flags & BLK_MQ_F_BLOCKING) {
+		set->srcu = kmalloc(sizeof(*set->srcu), GFP_KERNEL);
+		if (!set->srcu)
+			return -ENOMEM;
+		ret = init_srcu_struct(set->srcu);
+		if (ret)
+			goto out_free_srcu;
+	}
+
+	ret = blk_mq_alloc_tag_set_tags(set, set->nr_hw_queues);
+	if (ret)
+		goto out_cleanup_srcu;
 
 	ret = -ENOMEM;
 	for (i = 0; i < set->nr_maps; i++) {
@@ -4350,6 +4357,12 @@ int blk_mq_alloc_tag_set(struct blk_mq_tag_set *set)
 	}
 	kfree(set->tags);
 	set->tags = NULL;
+out_cleanup_srcu:
+	if (set->flags & BLK_MQ_F_BLOCKING)
+		cleanup_srcu_struct(set->srcu);
+out_free_srcu:
+	if (set->flags & BLK_MQ_F_BLOCKING)
+		kfree(set->srcu);
 	return ret;
 }
 EXPORT_SYMBOL(blk_mq_alloc_tag_set);
@@ -4389,6 +4402,10 @@ void blk_mq_free_tag_set(struct blk_mq_tag_set *set)
 
 	kfree(set->tags);
 	set->tags = NULL;
+	if (set->flags & BLK_MQ_F_BLOCKING) {
+		cleanup_srcu_struct(set->srcu);
+		kfree(set->srcu);
+	}
 }
 EXPORT_SYMBOL(blk_mq_free_tag_set);
 
diff --git a/block/blk-mq.h b/block/blk-mq.h
index 8ca453ac243d..1a88ad9428b7 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -376,17 +376,17 @@ static inline bool hctx_may_queue(struct blk_mq_hw_ctx *hctx,
 /* run the code block in @dispatch_ops with rcu/srcu read lock held */
 #define __blk_mq_run_dispatch_ops(q, check_sleep, dispatch_ops)	\
 do {								\
-	if (!blk_queue_has_srcu(q)) {				\
-		rcu_read_lock();				\
-		(dispatch_ops);					\
-		rcu_read_unlock();				\
-	} else {						\
+	if ((q)->tag_set->flags & BLK_MQ_F_BLOCKING) {		\
 		int srcu_idx;					\
 								\
 		might_sleep_if(check_sleep);			\
-		srcu_idx = srcu_read_lock((q)->srcu);		\
+		srcu_idx = srcu_read_lock((q)->tag_set->srcu);	\
 		(dispatch_ops);					\
-		srcu_read_unlock((q)->srcu, srcu_idx);		\
+		srcu_read_unlock((q)->tag_set->srcu, srcu_idx);	\
+	} else {						\
+		rcu_read_lock();				\
+		(dispatch_ops);					\
+		rcu_read_unlock();				\
 	}							\
 } while (0)
 
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index e1f009aba6fd..8822b4b6bed2 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -739,10 +739,8 @@ queue_attr_store(struct kobject *kobj, struct attribute *attr,
 
 static void blk_free_queue_rcu(struct rcu_head *rcu_head)
 {
-	struct request_queue *q = container_of(rcu_head, struct request_queue,
-					       rcu_head);
-
-	kmem_cache_free(blk_get_queue_kmem_cache(blk_queue_has_srcu(q)), q);
+	kmem_cache_free(blk_requestq_cachep,
+			container_of(rcu_head, struct request_queue, rcu_head));
 }
 
 /**
@@ -779,9 +777,6 @@ static void blk_release_queue(struct kobject *kobj)
 	if (queue_is_mq(q))
 		blk_mq_release(q);
 
-	if (blk_queue_has_srcu(q))
-		cleanup_srcu_struct(q->srcu);
-
 	ida_free(&blk_queue_ida, q->id);
 	call_rcu(&q->rcu_head, blk_free_queue_rcu);
 }
diff --git a/block/blk.h b/block/blk.h
index ff0bec16f0fa..5040c5b4ee70 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -27,7 +27,6 @@ struct blk_flush_queue {
 };
 
 extern struct kmem_cache *blk_requestq_cachep;
-extern struct kmem_cache *blk_requestq_srcu_cachep;
 extern struct kobj_type blk_queue_ktype;
 extern struct ida blk_queue_ida;
 
@@ -421,13 +420,7 @@ int bio_add_hw_page(struct request_queue *q, struct bio *bio,
 		struct page *page, unsigned int len, unsigned int offset,
 		unsigned int max_sectors, bool *same_page);
 
-static inline struct kmem_cache *blk_get_queue_kmem_cache(bool srcu)
-{
-	if (srcu)
-		return blk_requestq_srcu_cachep;
-	return blk_requestq_cachep;
-}
-struct request_queue *blk_alloc_queue(int node_id, bool alloc_srcu);
+struct request_queue *blk_alloc_queue(int node_id);
 
 int disk_scan_partitions(struct gendisk *disk, fmode_t mode);
 
diff --git a/block/genhd.c b/block/genhd.c
index 28654723bc2b..d4715ea7dc39 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1402,7 +1402,7 @@ struct gendisk *__blk_alloc_disk(int node, struct lock_class_key *lkclass)
 	struct request_queue *q;
 	struct gendisk *disk;
 
-	q = blk_alloc_queue(node, false);
+	q = blk_alloc_queue(node);
 	if (!q)
 		return NULL;
 
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 1532cd07a597..21f7b889f54e 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -7,6 +7,7 @@
 #include <linux/lockdep.h>
 #include <linux/scatterlist.h>
 #include <linux/prefetch.h>
+#include <linux/srcu.h>
 
 struct blk_mq_tags;
 struct blk_flush_queue;
@@ -496,6 +497,8 @@ enum hctx_type {
  * @tag_list_lock: Serializes tag_list accesses.
  * @tag_list:	   List of the request queues that use this tag set. See also
  *		   request_queue.tag_set_list.
+ * @srcu:	   Use as lock when type of the request queue is blocking
+ *		   (BLK_MQ_F_BLOCKING).
  */
 struct blk_mq_tag_set {
 	struct blk_mq_queue_map	map[HCTX_MAX_TYPES];
@@ -516,6 +519,7 @@ struct blk_mq_tag_set {
 
 	struct mutex		tag_list_lock;
 	struct list_head	tag_list;
+	struct srcu_struct	*srcu;
 };
 
 /**
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index e6bf06dc0770..0526f1c49fc6 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -22,7 +22,6 @@
 #include <linux/blkzoned.h>
 #include <linux/sched.h>
 #include <linux/sbitmap.h>
-#include <linux/srcu.h>
 #include <linux/uuid.h>
 #include <linux/xarray.h>
 
@@ -544,18 +543,11 @@ struct request_queue {
 	struct mutex		debugfs_mutex;
 
 	bool			mq_sysfs_init_done;
-
-	/**
-	 * @srcu: Sleepable RCU. Use as lock when type of the request queue
-	 * is blocking (BLK_MQ_F_BLOCKING). Must be the last member
-	 */
-	struct srcu_struct	srcu[];
 };
 
 /* Keep blk_queue_flag_name[] in sync with the definitions below */
 #define QUEUE_FLAG_STOPPED	0	/* queue is stopped */
 #define QUEUE_FLAG_DYING	1	/* queue being torn down */
-#define QUEUE_FLAG_HAS_SRCU	2	/* SRCU is allocated */
 #define QUEUE_FLAG_NOMERGES     3	/* disable merge attempts */
 #define QUEUE_FLAG_SAME_COMP	4	/* complete on same CPU-group */
 #define QUEUE_FLAG_FAIL_IO	5	/* fake timeout */
@@ -591,7 +583,6 @@ bool blk_queue_flag_test_and_set(unsigned int flag, struct request_queue *q);
 
 #define blk_queue_stopped(q)	test_bit(QUEUE_FLAG_STOPPED, &(q)->queue_flags)
 #define blk_queue_dying(q)	test_bit(QUEUE_FLAG_DYING, &(q)->queue_flags)
-#define blk_queue_has_srcu(q)	test_bit(QUEUE_FLAG_HAS_SRCU, &(q)->queue_flags)
 #define blk_queue_init_done(q)	test_bit(QUEUE_FLAG_INIT_DONE, &(q)->queue_flags)
 #define blk_queue_nomerges(q)	test_bit(QUEUE_FLAG_NOMERGES, &(q)->queue_flags)
 #define blk_queue_noxmerges(q)	\
-- 
2.35.1



