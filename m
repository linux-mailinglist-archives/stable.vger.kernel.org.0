Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 453B52F14C3
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:30:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732282AbhAKNPy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:15:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:33882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732278AbhAKNPx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:15:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 01C9B2246B;
        Mon, 11 Jan 2021 13:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370937;
        bh=cypiEaOxJZITf3HXcWLWePfPYyK/+WFE/VFWM5SxPu8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qA927dQeUOwY2uxiiLuGx8S4sKD78IoKZKzD3mYz0AF0Ahtx1MSp7ZdH3uGPaPzbA
         jDg2bLHAi74EkhZ4Iu7/PEH6SCLSqM7py8B/3yogsoI7/dl/RGsuKVloxfVYow6znE
         k9Z8UOLQ2mH3002diPBNYfWWSjh+/fmnciKK/L3c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Ming Lei <ming.lei@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Martin Kepplinger <martin.kepplinger@puri.sm>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Jens Axboe <axboe@kernel.dk>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 070/145] scsi: block: Remove RQF_PREEMPT and BLK_MQ_REQ_PREEMPT
Date:   Mon, 11 Jan 2021 14:01:34 +0100
Message-Id: <20210111130051.904265571@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit a4d34da715e3cb7e0741fe603dcd511bed067e00 ]

Remove flag RQF_PREEMPT and BLK_MQ_REQ_PREEMPT since these are no longer
used by any kernel code.

Link: https://lore.kernel.org/r/20201209052951.16136-8-bvanassche@acm.org
Cc: Can Guo <cang@codeaurora.org>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Martin Kepplinger <martin.kepplinger@puri.sm>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Can Guo <cang@codeaurora.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-core.c       | 7 +++----
 block/blk-mq-debugfs.c | 1 -
 block/blk-mq.c         | 2 --
 include/linux/blk-mq.h | 2 --
 include/linux/blkdev.h | 6 +-----
 5 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 10696f9fb6ac6..a00bce9f46d88 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -424,11 +424,11 @@ EXPORT_SYMBOL(blk_cleanup_queue);
 /**
  * blk_queue_enter() - try to increase q->q_usage_counter
  * @q: request queue pointer
- * @flags: BLK_MQ_REQ_NOWAIT, BLK_MQ_REQ_PM and/or BLK_MQ_REQ_PREEMPT
+ * @flags: BLK_MQ_REQ_NOWAIT and/or BLK_MQ_REQ_PM
  */
 int blk_queue_enter(struct request_queue *q, blk_mq_req_flags_t flags)
 {
-	const bool pm = flags & (BLK_MQ_REQ_PM | BLK_MQ_REQ_PREEMPT);
+	const bool pm = flags & BLK_MQ_REQ_PM;
 
 	while (true) {
 		bool success = false;
@@ -630,8 +630,7 @@ struct request *blk_get_request(struct request_queue *q, unsigned int op,
 	struct request *req;
 
 	WARN_ON_ONCE(op & REQ_NOWAIT);
-	WARN_ON_ONCE(flags & ~(BLK_MQ_REQ_NOWAIT | BLK_MQ_REQ_PM |
-			       BLK_MQ_REQ_PREEMPT));
+	WARN_ON_ONCE(flags & ~(BLK_MQ_REQ_NOWAIT | BLK_MQ_REQ_PM));
 
 	req = blk_mq_alloc_request(q, op, flags);
 	if (!IS_ERR(req) && q->mq_ops->initialize_rq_fn)
diff --git a/block/blk-mq-debugfs.c b/block/blk-mq-debugfs.c
index e21eed20a1551..4d6e83e5b4429 100644
--- a/block/blk-mq-debugfs.c
+++ b/block/blk-mq-debugfs.c
@@ -298,7 +298,6 @@ static const char *const rqf_name[] = {
 	RQF_NAME(MIXED_MERGE),
 	RQF_NAME(MQ_INFLIGHT),
 	RQF_NAME(DONTPREP),
-	RQF_NAME(PREEMPT),
 	RQF_NAME(FAILED),
 	RQF_NAME(QUIET),
 	RQF_NAME(ELVPRIV),
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 0072ffa50b46e..2a1eff60c7975 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -294,8 +294,6 @@ static struct request *blk_mq_rq_ctx_init(struct blk_mq_alloc_data *data,
 	rq->cmd_flags = data->cmd_flags;
 	if (data->flags & BLK_MQ_REQ_PM)
 		rq->rq_flags |= RQF_PM;
-	if (data->flags & BLK_MQ_REQ_PREEMPT)
-		rq->rq_flags |= RQF_PREEMPT;
 	if (blk_queue_io_stat(data->q))
 		rq->rq_flags |= RQF_IO_STAT;
 	INIT_LIST_HEAD(&rq->queuelist);
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index c9ecfd8b03381..f8ea27423d1d8 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -448,8 +448,6 @@ enum {
 	BLK_MQ_REQ_RESERVED	= (__force blk_mq_req_flags_t)(1 << 1),
 	/* set RQF_PM */
 	BLK_MQ_REQ_PM		= (__force blk_mq_req_flags_t)(1 << 2),
-	/* set RQF_PREEMPT */
-	BLK_MQ_REQ_PREEMPT	= (__force blk_mq_req_flags_t)(1 << 3),
 };
 
 struct request *blk_mq_alloc_request(struct request_queue *q, unsigned int op,
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 033eb5f73b654..4a6e33d382429 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -79,9 +79,6 @@ typedef __u32 __bitwise req_flags_t;
 #define RQF_MQ_INFLIGHT		((__force req_flags_t)(1 << 6))
 /* don't call prep for this one */
 #define RQF_DONTPREP		((__force req_flags_t)(1 << 7))
-/* set for "ide_preempt" requests and also for requests for which the SCSI
-   "quiesce" state must be ignored. */
-#define RQF_PREEMPT		((__force req_flags_t)(1 << 8))
 /* vaguely specified driver internal error.  Ignored by the block layer */
 #define RQF_FAILED		((__force req_flags_t)(1 << 10))
 /* don't warn about errors */
@@ -430,8 +427,7 @@ struct request_queue {
 	unsigned long		queue_flags;
 	/*
 	 * Number of contexts that have called blk_set_pm_only(). If this
-	 * counter is above zero then only RQF_PM and RQF_PREEMPT requests are
-	 * processed.
+	 * counter is above zero then only RQF_PM requests are processed.
 	 */
 	atomic_t		pm_only;
 
-- 
2.27.0



