Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDDEB2F407
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729440AbfE3DNY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:13:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:58448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729426AbfE3DNY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:13:24 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 306E623D14;
        Thu, 30 May 2019 03:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186003;
        bh=/27MC/24vy0pzlQ1bxrg2WEVvYdYFBSyYBq0wfcmfUc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dy2mbto3EfvGjw8SNcvX6OkaAf3S63Q4DKdbzKEJVIBq88Ykz1uGJpuFmNLhNXQIE
         VL/OBed8ujaSBxiFIOMF7oERee+GAT9ckERP0T6AeD3k+NQBwzkMsLPnXBGLMY5p7n
         YUtEFD5w8xSflD47fpAlvtK4lDSrEIPOOkz0VjFg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dongli Zhang <dongli.zhang@oracle.com>,
        James Smart <james.smart@broadcom.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Subject: [PATCH 5.0 055/346] blk-mq: grab .q_usage_counter when queuing request from plug code path
Date:   Wed, 29 May 2019 20:02:08 -0700
Message-Id: <20190530030543.736817542@linuxfoundation.org>
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

[ Upstream commit e87eb301bee183d82bb3d04bd71b6660889a2588 ]

Just like aio/io_uring, we need to grab 2 refcount for queuing one
request, one is for submission, another is for completion.

If the request isn't queued from plug code path, the refcount grabbed
in generic_make_request() serves for submission. In theroy, this
refcount should have been released after the sumission(async run queue)
is done. blk_freeze_queue() works with blk_sync_queue() together
for avoiding race between cleanup queue and IO submission, given async
run queue activities are canceled because hctx->run_work is scheduled with
the refcount held, so it is fine to not hold the refcount when
running the run queue work function for dispatch IO.

However, if request is staggered into plug list, and finally queued
from plug code path, the refcount in submission side is actually missed.
And we may start to run queue after queue is removed because the queue's
kobject refcount isn't guaranteed to be grabbed in flushing plug list
context, then kernel oops is triggered, see the following race:

blk_mq_flush_plug_list():
        blk_mq_sched_insert_requests()
                insert requests to sw queue or scheduler queue
                blk_mq_run_hw_queue

Because of concurrent run queue, all requests inserted above may be
completed before calling the above blk_mq_run_hw_queue. Then queue can
be freed during the above blk_mq_run_hw_queue().

Fixes the issue by grab .q_usage_counter before calling
blk_mq_sched_insert_requests() in blk_mq_flush_plug_list(). This way is
safe because the queue is absolutely alive before inserting request.

Cc: Dongli Zhang <dongli.zhang@oracle.com>
Cc: James Smart <james.smart@broadcom.com>
Cc: linux-scsi@vger.kernel.org,
Cc: Martin K . Petersen <martin.petersen@oracle.com>,
Cc: Christoph Hellwig <hch@lst.de>,
Cc: James E . J . Bottomley <jejb@linux.vnet.ibm.com>,
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Tested-by: James Smart <james.smart@broadcom.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq-sched.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
index 0c98b6c1ca49c..1213556a20dad 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -413,6 +413,14 @@ void blk_mq_sched_insert_requests(struct blk_mq_hw_ctx *hctx,
 				  struct list_head *list, bool run_queue_async)
 {
 	struct elevator_queue *e;
+	struct request_queue *q = hctx->queue;
+
+	/*
+	 * blk_mq_sched_insert_requests() is called from flush plug
+	 * context only, and hold one usage counter to prevent queue
+	 * from being released.
+	 */
+	percpu_ref_get(&q->q_usage_counter);
 
 	e = hctx->queue->elevator;
 	if (e && e->type->ops.insert_requests)
@@ -426,12 +434,14 @@ void blk_mq_sched_insert_requests(struct blk_mq_hw_ctx *hctx,
 		if (!hctx->dispatch_busy && !e && !run_queue_async) {
 			blk_mq_try_issue_list_directly(hctx, list);
 			if (list_empty(list))
-				return;
+				goto out;
 		}
 		blk_mq_insert_requests(hctx, ctx, list);
 	}
 
 	blk_mq_run_hw_queue(hctx, run_queue_async);
+ out:
+	percpu_ref_put(&q->q_usage_counter);
 }
 
 static void blk_mq_sched_free_tags(struct blk_mq_tag_set *set,
-- 
2.20.1



