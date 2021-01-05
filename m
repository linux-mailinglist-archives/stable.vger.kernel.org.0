Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAFFF2EA219
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 02:09:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728108AbhAEBAl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 20:00:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:39224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728080AbhAEBAk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 20:00:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C35622597;
        Tue,  5 Jan 2021 00:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609808367;
        bh=0dOcWsGh9Z/V+w6PU/Ju3OjRV+n9m9dtFHHPjcms3l4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UpvGE2Oom9D6rcDWbzDAqlIlyRHZcwDZRjYF5/eD2kS78z6kZUFRgjBn3D9WlvtV3
         yTXGFLJI/Sd1vq+IYgH6AMR3ehOW9mZ+nwUVj5s4pp10srj7hGpnChtac7yiFBJo4o
         ujZCofGLP+2Db2DAccq+uNaN0hyCpS8TyuKX+sSsj5ddZpq0BiRvNIzjseL0wUGAeK
         17B9UQoFea6geE2q1QsjKljK7a8KXUQyr8KMnbRQsTNWXGBiYLySEFLaK29N5GoLuz
         PBKY643BqmhVMuCY3x3bZx3pTNY0v7e/R0neVsgvR+OfeazKZYK2P7z22cM4zRNDmK
         1PGZ8QEOmE8hA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Ming Lei <ming.lei@redhat.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Can Guo <cang@codeaurora.org>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-block@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 08/17] scsi: block: Introduce BLK_MQ_REQ_PM
Date:   Mon,  4 Jan 2021 19:59:06 -0500
Message-Id: <20210105005915.3954208-8-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210105005915.3954208-1-sashal@kernel.org>
References: <20210105005915.3954208-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 0854bcdcdec26aecdc92c303816f349ee1fba2bc ]

Introduce the BLK_MQ_REQ_PM flag. This flag makes the request allocation
functions set RQF_PM. This is the first step towards removing
BLK_MQ_REQ_PREEMPT.

Link: https://lore.kernel.org/r/20201209052951.16136-3-bvanassche@acm.org
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Can Guo <cang@codeaurora.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Can Guo <cang@codeaurora.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-core.c       | 7 ++++---
 block/blk-mq.c         | 2 ++
 include/linux/blk-mq.h | 2 ++
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 2db8bda43b6e6..10696f9fb6ac6 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -424,11 +424,11 @@ EXPORT_SYMBOL(blk_cleanup_queue);
 /**
  * blk_queue_enter() - try to increase q->q_usage_counter
  * @q: request queue pointer
- * @flags: BLK_MQ_REQ_NOWAIT and/or BLK_MQ_REQ_PREEMPT
+ * @flags: BLK_MQ_REQ_NOWAIT, BLK_MQ_REQ_PM and/or BLK_MQ_REQ_PREEMPT
  */
 int blk_queue_enter(struct request_queue *q, blk_mq_req_flags_t flags)
 {
-	const bool pm = flags & BLK_MQ_REQ_PREEMPT;
+	const bool pm = flags & (BLK_MQ_REQ_PM | BLK_MQ_REQ_PREEMPT);
 
 	while (true) {
 		bool success = false;
@@ -630,7 +630,8 @@ struct request *blk_get_request(struct request_queue *q, unsigned int op,
 	struct request *req;
 
 	WARN_ON_ONCE(op & REQ_NOWAIT);
-	WARN_ON_ONCE(flags & ~(BLK_MQ_REQ_NOWAIT | BLK_MQ_REQ_PREEMPT));
+	WARN_ON_ONCE(flags & ~(BLK_MQ_REQ_NOWAIT | BLK_MQ_REQ_PM |
+			       BLK_MQ_REQ_PREEMPT));
 
 	req = blk_mq_alloc_request(q, op, flags);
 	if (!IS_ERR(req) && q->mq_ops->initialize_rq_fn)
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 55bcee5dc0320..0072ffa50b46e 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -292,6 +292,8 @@ static struct request *blk_mq_rq_ctx_init(struct blk_mq_alloc_data *data,
 	rq->mq_hctx = data->hctx;
 	rq->rq_flags = 0;
 	rq->cmd_flags = data->cmd_flags;
+	if (data->flags & BLK_MQ_REQ_PM)
+		rq->rq_flags |= RQF_PM;
 	if (data->flags & BLK_MQ_REQ_PREEMPT)
 		rq->rq_flags |= RQF_PREEMPT;
 	if (blk_queue_io_stat(data->q))
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 794b2a33a2c36..c9ecfd8b03381 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -446,6 +446,8 @@ enum {
 	BLK_MQ_REQ_NOWAIT	= (__force blk_mq_req_flags_t)(1 << 0),
 	/* allocate from reserved pool */
 	BLK_MQ_REQ_RESERVED	= (__force blk_mq_req_flags_t)(1 << 1),
+	/* set RQF_PM */
+	BLK_MQ_REQ_PM		= (__force blk_mq_req_flags_t)(1 << 2),
 	/* set RQF_PREEMPT */
 	BLK_MQ_REQ_PREEMPT	= (__force blk_mq_req_flags_t)(1 << 3),
 };
-- 
2.27.0

