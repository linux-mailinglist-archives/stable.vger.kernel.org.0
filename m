Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79A2826AD2
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 21:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730048AbfEVTVo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 15:21:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:42304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730039AbfEVTVn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 15:21:43 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 988E5217D4;
        Wed, 22 May 2019 19:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558552901;
        bh=/x4OjuKTJbdwFJUuUeo6m7mPKGoWuj9Z7ADizqsKEPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u4TtBG08ujhYHR2Vo6K00pfm5FYn7FRyWE+myLGS5U3gcVn8cx61GJMhI93of2zBV
         x99MyGv1L3Nb5ZRuyUfMpotIoVWCQ1WKCBkad95jCCBnncZM7T0DDbR/RcPtuFJ5WV
         9+3RYoZGPYVI3DL1wat4ZnWh2IsbxC50di1E+S+c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>,
        Dongli Zhang <dongli.zhang@oracle.com>,
        James Smart <james.smart@broadcom.com>,
        Bart Van Assche <bart.vanassche@wdc.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Hannes Reinecke <hare@suse.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 019/375] blk-mq: split blk_mq_alloc_and_init_hctx into two parts
Date:   Wed, 22 May 2019 15:15:19 -0400
Message-Id: <20190522192115.22666-19-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192115.22666-1-sashal@kernel.org>
References: <20190522192115.22666-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 7c6c5b7c9186e3fb5b10afb8e5f710ae661144c6 ]

Split blk_mq_alloc_and_init_hctx into two parts, and one is
blk_mq_alloc_hctx() for allocating all hctx resources, another
is blk_mq_init_hctx() for initializing hctx, which serves as
counter-part of blk_mq_exit_hctx().

Cc: Dongli Zhang <dongli.zhang@oracle.com>
Cc: James Smart <james.smart@broadcom.com>
Cc: Bart Van Assche <bart.vanassche@wdc.com>
Cc: linux-scsi@vger.kernel.org
Cc: Martin K . Petersen <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: James E . J . Bottomley <jejb@linux.vnet.ibm.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Tested-by: James Smart <james.smart@broadcom.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 139 ++++++++++++++++++++++++++-----------------------
 1 file changed, 75 insertions(+), 64 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index fc60ed7e940ea..24e3ae3bd710e 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2289,15 +2289,65 @@ static void blk_mq_exit_hw_queues(struct request_queue *q,
 	}
 }
 
+static int blk_mq_hw_ctx_size(struct blk_mq_tag_set *tag_set)
+{
+	int hw_ctx_size = sizeof(struct blk_mq_hw_ctx);
+
+	BUILD_BUG_ON(ALIGN(offsetof(struct blk_mq_hw_ctx, srcu),
+			   __alignof__(struct blk_mq_hw_ctx)) !=
+		     sizeof(struct blk_mq_hw_ctx));
+
+	if (tag_set->flags & BLK_MQ_F_BLOCKING)
+		hw_ctx_size += sizeof(struct srcu_struct);
+
+	return hw_ctx_size;
+}
+
 static int blk_mq_init_hctx(struct request_queue *q,
 		struct blk_mq_tag_set *set,
 		struct blk_mq_hw_ctx *hctx, unsigned hctx_idx)
 {
-	int node;
+	hctx->queue_num = hctx_idx;
+
+	cpuhp_state_add_instance_nocalls(CPUHP_BLK_MQ_DEAD, &hctx->cpuhp_dead);
+
+	hctx->tags = set->tags[hctx_idx];
+
+	if (set->ops->init_hctx &&
+	    set->ops->init_hctx(hctx, set->driver_data, hctx_idx))
+		goto unregister_cpu_notifier;
 
-	node = hctx->numa_node;
+	if (blk_mq_init_request(set, hctx->fq->flush_rq, hctx_idx,
+				hctx->numa_node))
+		goto exit_hctx;
+	return 0;
+
+ exit_hctx:
+	if (set->ops->exit_hctx)
+		set->ops->exit_hctx(hctx, hctx_idx);
+ unregister_cpu_notifier:
+	blk_mq_remove_cpuhp(hctx);
+	return -1;
+}
+
+static struct blk_mq_hw_ctx *
+blk_mq_alloc_hctx(struct request_queue *q, struct blk_mq_tag_set *set,
+		int node)
+{
+	struct blk_mq_hw_ctx *hctx;
+	gfp_t gfp = GFP_NOIO | __GFP_NOWARN | __GFP_NORETRY;
+
+	hctx = kzalloc_node(blk_mq_hw_ctx_size(set), gfp, node);
+	if (!hctx)
+		goto fail_alloc_hctx;
+
+	if (!zalloc_cpumask_var_node(&hctx->cpumask, gfp, node))
+		goto free_hctx;
+
+	atomic_set(&hctx->nr_active, 0);
 	if (node == NUMA_NO_NODE)
-		node = hctx->numa_node = set->numa_node;
+		node = set->numa_node;
+	hctx->numa_node = node;
 
 	INIT_DELAYED_WORK(&hctx->run_work, blk_mq_run_work_fn);
 	spin_lock_init(&hctx->lock);
@@ -2305,58 +2355,45 @@ static int blk_mq_init_hctx(struct request_queue *q,
 	hctx->queue = q;
 	hctx->flags = set->flags & ~BLK_MQ_F_TAG_SHARED;
 
-	cpuhp_state_add_instance_nocalls(CPUHP_BLK_MQ_DEAD, &hctx->cpuhp_dead);
-
-	hctx->tags = set->tags[hctx_idx];
-
 	/*
 	 * Allocate space for all possible cpus to avoid allocation at
 	 * runtime
 	 */
 	hctx->ctxs = kmalloc_array_node(nr_cpu_ids, sizeof(void *),
-			GFP_NOIO | __GFP_NOWARN | __GFP_NORETRY, node);
+			gfp, node);
 	if (!hctx->ctxs)
-		goto unregister_cpu_notifier;
+		goto free_cpumask;
 
 	if (sbitmap_init_node(&hctx->ctx_map, nr_cpu_ids, ilog2(8),
-				GFP_NOIO | __GFP_NOWARN | __GFP_NORETRY, node))
+				gfp, node))
 		goto free_ctxs;
-
 	hctx->nr_ctx = 0;
 
 	spin_lock_init(&hctx->dispatch_wait_lock);
 	init_waitqueue_func_entry(&hctx->dispatch_wait, blk_mq_dispatch_wake);
 	INIT_LIST_HEAD(&hctx->dispatch_wait.entry);
 
-	if (set->ops->init_hctx &&
-	    set->ops->init_hctx(hctx, set->driver_data, hctx_idx))
-		goto free_bitmap;
-
 	hctx->fq = blk_alloc_flush_queue(q, hctx->numa_node, set->cmd_size,
-			GFP_NOIO | __GFP_NOWARN | __GFP_NORETRY);
+			gfp);
 	if (!hctx->fq)
-		goto exit_hctx;
-
-	if (blk_mq_init_request(set, hctx->fq->flush_rq, hctx_idx, node))
-		goto free_fq;
+		goto free_bitmap;
 
 	if (hctx->flags & BLK_MQ_F_BLOCKING)
 		init_srcu_struct(hctx->srcu);
+	blk_mq_hctx_kobj_init(hctx);
 
-	return 0;
+	return hctx;
 
- free_fq:
-	blk_free_flush_queue(hctx->fq);
- exit_hctx:
-	if (set->ops->exit_hctx)
-		set->ops->exit_hctx(hctx, hctx_idx);
  free_bitmap:
 	sbitmap_free(&hctx->ctx_map);
  free_ctxs:
 	kfree(hctx->ctxs);
- unregister_cpu_notifier:
-	blk_mq_remove_cpuhp(hctx);
-	return -1;
+ free_cpumask:
+	free_cpumask_var(hctx->cpumask);
+ free_hctx:
+	kfree(hctx);
+ fail_alloc_hctx:
+	return NULL;
 }
 
 static void blk_mq_init_cpu_queues(struct request_queue *q,
@@ -2700,51 +2737,25 @@ struct request_queue *blk_mq_init_sq_queue(struct blk_mq_tag_set *set,
 }
 EXPORT_SYMBOL(blk_mq_init_sq_queue);
 
-static int blk_mq_hw_ctx_size(struct blk_mq_tag_set *tag_set)
-{
-	int hw_ctx_size = sizeof(struct blk_mq_hw_ctx);
-
-	BUILD_BUG_ON(ALIGN(offsetof(struct blk_mq_hw_ctx, srcu),
-			   __alignof__(struct blk_mq_hw_ctx)) !=
-		     sizeof(struct blk_mq_hw_ctx));
-
-	if (tag_set->flags & BLK_MQ_F_BLOCKING)
-		hw_ctx_size += sizeof(struct srcu_struct);
-
-	return hw_ctx_size;
-}
-
 static struct blk_mq_hw_ctx *blk_mq_alloc_and_init_hctx(
 		struct blk_mq_tag_set *set, struct request_queue *q,
 		int hctx_idx, int node)
 {
 	struct blk_mq_hw_ctx *hctx;
 
-	hctx = kzalloc_node(blk_mq_hw_ctx_size(set),
-			GFP_NOIO | __GFP_NOWARN | __GFP_NORETRY,
-			node);
+	hctx = blk_mq_alloc_hctx(q, set, node);
 	if (!hctx)
-		return NULL;
-
-	if (!zalloc_cpumask_var_node(&hctx->cpumask,
-				GFP_NOIO | __GFP_NOWARN | __GFP_NORETRY,
-				node)) {
-		kfree(hctx);
-		return NULL;
-	}
-
-	atomic_set(&hctx->nr_active, 0);
-	hctx->numa_node = node;
-	hctx->queue_num = hctx_idx;
+		goto fail;
 
-	if (blk_mq_init_hctx(q, set, hctx, hctx_idx)) {
-		free_cpumask_var(hctx->cpumask);
-		kfree(hctx);
-		return NULL;
-	}
-	blk_mq_hctx_kobj_init(hctx);
+	if (blk_mq_init_hctx(q, set, hctx, hctx_idx))
+		goto free_hctx;
 
 	return hctx;
+
+ free_hctx:
+	kobject_put(&hctx->kobj);
+ fail:
+	return NULL;
 }
 
 static void blk_mq_realloc_hw_ctxs(struct blk_mq_tag_set *set,
-- 
2.20.1

