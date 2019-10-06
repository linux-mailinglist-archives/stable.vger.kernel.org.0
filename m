Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68774CD78C
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 20:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729424AbfJFRb2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:31:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:57648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729412AbfJFRbZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:31:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30A5E2080F;
        Sun,  6 Oct 2019 17:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383083;
        bh=6U0DUglx+sJiUGe4E43ESyfD7KbgwoFb8onbvz+2Zoc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0kbSlWCwfua3AAwvHFO9OL1C2mob/2Pw3clOWS28w4Yrjq1Wz0NKjZfVpGW4Du7+u
         Ln31YxhZQnGUejceKu1S7wT5VKDh8rKyQhTjFv2b7V7e/93R99EfX+OhL2Rxlyv2t5
         uIp4VxyIUvx7Imbmks9zoQN7qMkf7fdpMC/qTNUI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Holmberg <Hans.Holmberg@wdc.com>,
        Hans Holmberg <hans.holmberg@wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 078/106] block: mq-deadline: Fix queue restart handling
Date:   Sun,  6 Oct 2019 19:21:24 +0200
Message-Id: <20191006171156.638428126@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171124.641144086@linuxfoundation.org>
References: <20191006171124.641144086@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Damien Le Moal <damien.lemoal@wdc.com>

[ Upstream commit cb8acabbe33b110157955a7425ee876fb81e6bbc ]

Commit 7211aef86f79 ("block: mq-deadline: Fix write completion
handling") added a call to blk_mq_sched_mark_restart_hctx() in
dd_dispatch_request() to make sure that write request dispatching does
not stall when all target zones are locked. This fix left a subtle race
when a write completion happens during a dispatch execution on another
CPU:

CPU 0: Dispatch			CPU1: write completion

dd_dispatch_request()
    lock(&dd->lock);
    ...
    lock(&dd->zone_lock);	dd_finish_request()
    rq = find request		lock(&dd->zone_lock);
    unlock(&dd->zone_lock);
    				zone write unlock
				unlock(&dd->zone_lock);
				...
				__blk_mq_free_request
                                      check restart flag (not set)
				      -> queue not run
    ...
    if (!rq && have writes)
        blk_mq_sched_mark_restart_hctx()
    unlock(&dd->lock)

Since the dispatch context finishes after the write request completion
handling, marking the queue as needing a restart is not seen from
__blk_mq_free_request() and blk_mq_sched_restart() not executed leading
to the dispatch stall under 100% write workloads.

Fix this by moving the call to blk_mq_sched_mark_restart_hctx() from
dd_dispatch_request() into dd_finish_request() under the zone lock to
ensure full mutual exclusion between write request dispatch selection
and zone unlock on write request completion.

Fixes: 7211aef86f79 ("block: mq-deadline: Fix write completion handling")
Cc: stable@vger.kernel.org
Reported-by: Hans Holmberg <Hans.Holmberg@wdc.com>
Reviewed-by: Hans Holmberg <hans.holmberg@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/mq-deadline.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/block/mq-deadline.c b/block/mq-deadline.c
index d5e21ce44d2cc..69094d6410623 100644
--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -376,13 +376,6 @@ static struct request *__dd_dispatch_request(struct deadline_data *dd)
  * hardware queue, but we may return a request that is for a
  * different hardware queue. This is because mq-deadline has shared
  * state for all hardware queues, in terms of sorting, FIFOs, etc.
- *
- * For a zoned block device, __dd_dispatch_request() may return NULL
- * if all the queued write requests are directed at zones that are already
- * locked due to on-going write requests. In this case, make sure to mark
- * the queue as needing a restart to ensure that the queue is run again
- * and the pending writes dispatched once the target zones for the ongoing
- * write requests are unlocked in dd_finish_request().
  */
 static struct request *dd_dispatch_request(struct blk_mq_hw_ctx *hctx)
 {
@@ -391,9 +384,6 @@ static struct request *dd_dispatch_request(struct blk_mq_hw_ctx *hctx)
 
 	spin_lock(&dd->lock);
 	rq = __dd_dispatch_request(dd);
-	if (!rq && blk_queue_is_zoned(hctx->queue) &&
-	    !list_empty(&dd->fifo_list[WRITE]))
-		blk_mq_sched_mark_restart_hctx(hctx);
 	spin_unlock(&dd->lock);
 
 	return rq;
@@ -559,6 +549,13 @@ static void dd_prepare_request(struct request *rq, struct bio *bio)
  * spinlock so that the zone is never unlocked while deadline_fifo_request()
  * or deadline_next_request() are executing. This function is called for
  * all requests, whether or not these requests complete successfully.
+ *
+ * For a zoned block device, __dd_dispatch_request() may have stopped
+ * dispatching requests if all the queued requests are write requests directed
+ * at zones that are already locked due to on-going write requests. To ensure
+ * write request dispatch progress in this case, mark the queue as needing a
+ * restart to ensure that the queue is run again after completion of the
+ * request and zones being unlocked.
  */
 static void dd_finish_request(struct request *rq)
 {
@@ -570,6 +567,12 @@ static void dd_finish_request(struct request *rq)
 
 		spin_lock_irqsave(&dd->zone_lock, flags);
 		blk_req_zone_write_unlock(rq);
+		if (!list_empty(&dd->fifo_list[WRITE])) {
+			struct blk_mq_hw_ctx *hctx;
+
+			hctx = blk_mq_map_queue(q, rq->mq_ctx->cpu);
+			blk_mq_sched_mark_restart_hctx(hctx);
+		}
 		spin_unlock_irqrestore(&dd->zone_lock, flags);
 	}
 }
-- 
2.20.1



