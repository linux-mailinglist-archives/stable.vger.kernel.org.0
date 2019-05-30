Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 049282F40E
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388246AbfE3Eeb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:34:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:58358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729422AbfE3DNX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:13:23 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48C9F24526;
        Thu, 30 May 2019 03:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186002;
        bh=KKtLbADqIJY+gRZAtssZ9l6tqtMGcedHxKBhhJGaN/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t5Iu525SkKQD1QZCe1XjOhD9VmoxHIrJC0kTmUQo12bB2pQdvNKov2sUvDDixovh5
         Viy+NuTF1TEJOs5JgFDNx8zB7pN/mM6lPR5zxp/JxIwYrG1DmfsJGks7jRqjUtHCIP
         jmBA1q/lQMrx1gxxIWjRWVK7Dhi+eY+zUPj902Rw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dongli Zhang <dongli.zhang@oracle.com>,
        James Smart <james.smart@broadcom.com>,
        Bart Van Assche <bart.vanassche@wdc.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Hannes Reinecke <hare@suse.com>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 054/346] blk-mq: split blk_mq_alloc_and_init_hctx into two parts
Date:   Wed, 29 May 2019 20:02:07 -0700
Message-Id: <20190530030543.682671827@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 9957e0fc17fc4..27526095319c3 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2287,15 +2287,65 @@ static void blk_mq_exit_hw_queues(struct request_queue *q,
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
@@ -2303,58 +2353,45 @@ static int blk_mq_init_hctx(struct request_queue *q,
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
@@ -2691,51 +2728,25 @@ struct request_queue *blk_mq_init_sq_queue(struct blk_mq_tag_set *set,
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



