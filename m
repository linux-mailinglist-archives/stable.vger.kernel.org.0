Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33739B202A
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390009AbfIMNRK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:17:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:44268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390003AbfIMNRJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:17:09 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40FC7206A5;
        Fri, 13 Sep 2019 13:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380628;
        bh=N3tYjEOjmtvilGkRnIq3L5IQvZOmdaHEWoeBzIlVhu8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ERtYfT22zZNF3P8kULEVtwIIXPdGnzYriIjMeDveGZQ0ixHbZ+jKicFnLpfY2OMbJ
         nCXehN7n+xFGwSHtz7jq28bYN52zC9gvycvIc2ligAGrR8wz7ZMXN6v2t46fCDkO50
         b5OswF6Mpyoi8K74aczWN6/En1NEuAvFlKgb5Z8Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dongli Zhang <dongli.zhang@oracle.com>,
        James Smart <james.smart@broadcom.com>,
        Bart Van Assche <bart.vanassche@wdc.com>,
        Hannes Reinecke <hare@suse.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Subject: [PATCH 4.19 127/190] blk-mq: free hw queues resource in hctxs release handler
Date:   Fri, 13 Sep 2019 14:06:22 +0100
Message-Id: <20190913130610.041910427@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit c7e2d94b3d1634988a95ac4d77a72dc7487ece06 ]

Once blk_cleanup_queue() returns, tags shouldn't be used any more,
because blk_mq_free_tag_set() may be called. Commit 45a9c9d909b2
("blk-mq: Fix a use-after-free") fixes this issue exactly.

However, that commit introduces another issue. Before 45a9c9d909b2,
we are allowed to run queue during cleaning up queue if the queue's
kobj refcount is held. After that commit, queue can't be run during
queue cleaning up, otherwise oops can be triggered easily because
some fields of hctx are freed by blk_mq_free_queue() in blk_cleanup_queue().

We have invented ways for addressing this kind of issue before, such as:

	8dc765d438f1 ("SCSI: fix queue cleanup race before queue initialization is done")
	c2856ae2f315 ("blk-mq: quiesce queue before freeing queue")

But still can't cover all cases, recently James reports another such
kind of issue:

	https://marc.info/?l=linux-scsi&m=155389088124782&w=2

This issue can be quite hard to address by previous way, given
scsi_run_queue() may run requeues for other LUNs.

Fixes the above issue by freeing hctx's resources in its release handler, and this
way is safe becasue tags isn't needed for freeing such hctx resource.

This approach follows typical design pattern wrt. kobject's release handler.

Cc: Dongli Zhang <dongli.zhang@oracle.com>
Cc: James Smart <james.smart@broadcom.com>
Cc: Bart Van Assche <bart.vanassche@wdc.com>
Cc: linux-scsi@vger.kernel.org,
Cc: Martin K . Petersen <martin.petersen@oracle.com>,
Cc: Christoph Hellwig <hch@lst.de>,
Cc: James E . J . Bottomley <jejb@linux.vnet.ibm.com>,
Reported-by: James Smart <james.smart@broadcom.com>
Fixes: 45a9c9d909b2 ("blk-mq: Fix a use-after-free")
Cc: stable@vger.kernel.org
Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Tested-by: James Smart <james.smart@broadcom.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-core.c     | 3 ++-
 block/blk-mq-sysfs.c | 6 ++++++
 block/blk-mq.c       | 8 ++------
 block/blk-mq.h       | 2 +-
 4 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 4a3e1f4178804..af635f878f966 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -816,7 +816,8 @@ void blk_cleanup_queue(struct request_queue *q)
 	blk_exit_queue(q);
 
 	if (q->mq_ops)
-		blk_mq_free_queue(q);
+		blk_mq_exit_queue(q);
+
 	percpu_ref_exit(&q->q_usage_counter);
 
 	spin_lock_irq(lock);
diff --git a/block/blk-mq-sysfs.c b/block/blk-mq-sysfs.c
index aafb44224c896..0b7297a43ccd2 100644
--- a/block/blk-mq-sysfs.c
+++ b/block/blk-mq-sysfs.c
@@ -10,6 +10,7 @@
 #include <linux/smp.h>
 
 #include <linux/blk-mq.h>
+#include "blk.h"
 #include "blk-mq.h"
 #include "blk-mq-tag.h"
 
@@ -21,6 +22,11 @@ static void blk_mq_hw_sysfs_release(struct kobject *kobj)
 {
 	struct blk_mq_hw_ctx *hctx = container_of(kobj, struct blk_mq_hw_ctx,
 						  kobj);
+
+	if (hctx->flags & BLK_MQ_F_BLOCKING)
+		cleanup_srcu_struct(hctx->srcu);
+	blk_free_flush_queue(hctx->fq);
+	sbitmap_free(&hctx->ctx_map);
 	free_cpumask_var(hctx->cpumask);
 	kfree(hctx->ctxs);
 	kfree(hctx);
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 70d839b9c3b09..455fda99255a4 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2157,12 +2157,7 @@ static void blk_mq_exit_hctx(struct request_queue *q,
 	if (set->ops->exit_hctx)
 		set->ops->exit_hctx(hctx, hctx_idx);
 
-	if (hctx->flags & BLK_MQ_F_BLOCKING)
-		cleanup_srcu_struct(hctx->srcu);
-
 	blk_mq_remove_cpuhp(hctx);
-	blk_free_flush_queue(hctx->fq);
-	sbitmap_free(&hctx->ctx_map);
 }
 
 static void blk_mq_exit_hw_queues(struct request_queue *q,
@@ -2662,7 +2657,8 @@ err_exit:
 }
 EXPORT_SYMBOL(blk_mq_init_allocated_queue);
 
-void blk_mq_free_queue(struct request_queue *q)
+/* tags can _not_ be used after returning from blk_mq_exit_queue */
+void blk_mq_exit_queue(struct request_queue *q)
 {
 	struct blk_mq_tag_set	*set = q->tag_set;
 
diff --git a/block/blk-mq.h b/block/blk-mq.h
index 9497b47e2526c..5ad9251627f80 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -31,7 +31,7 @@ struct blk_mq_ctx {
 } ____cacheline_aligned_in_smp;
 
 void blk_mq_freeze_queue(struct request_queue *q);
-void blk_mq_free_queue(struct request_queue *q);
+void blk_mq_exit_queue(struct request_queue *q);
 int blk_mq_update_nr_requests(struct request_queue *q, unsigned int nr);
 void blk_mq_wake_waiters(struct request_queue *q);
 bool blk_mq_dispatch_rq_list(struct request_queue *, struct list_head *, bool);
-- 
2.20.1



