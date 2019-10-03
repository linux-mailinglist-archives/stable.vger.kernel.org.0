Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75260CA5C4
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404411AbfJCQg2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:36:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:45670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404384AbfJCQg1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:36:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DE9420830;
        Thu,  3 Oct 2019 16:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120586;
        bh=uz0yh/ZK6cChfUY3IqA6SxiaK6OQKPgqLLWkm4NAiSA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AQMfZNJ5Cus48FVw6//qKktYY4kvK663U0wmgS6A06ZSa8eEjE2cJOO0DQvnEjOAN
         HLRrDFu5FEJXXkkuja/lpdiWPDKeC6onkNN2YfukZdORLvkZMUi1irH/ii9rhfdHlV
         0q3Yl0e6WIAvPB8qEZqm2L3juFVMMyf2duN844L8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Holmberg <Hans.Holmberg@wdc.com>,
        Hans Holmberg <hans.holmberg@wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.2 276/313] block: mq-deadline: Fix queue restart handling
Date:   Thu,  3 Oct 2019 17:54:14 +0200
Message-Id: <20191003154600.232127235@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Damien Le Moal <damien.lemoal@wdc.com>

commit cb8acabbe33b110157955a7425ee876fb81e6bbc upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 block/mq-deadline.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -377,13 +377,6 @@ done:
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
@@ -392,9 +385,6 @@ static struct request *dd_dispatch_reque
 
 	spin_lock(&dd->lock);
 	rq = __dd_dispatch_request(dd);
-	if (!rq && blk_queue_is_zoned(hctx->queue) &&
-	    !list_empty(&dd->fifo_list[WRITE]))
-		blk_mq_sched_mark_restart_hctx(hctx);
 	spin_unlock(&dd->lock);
 
 	return rq;
@@ -560,6 +550,13 @@ static void dd_prepare_request(struct re
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
@@ -571,6 +568,8 @@ static void dd_finish_request(struct req
 
 		spin_lock_irqsave(&dd->zone_lock, flags);
 		blk_req_zone_write_unlock(rq);
+		if (!list_empty(&dd->fifo_list[WRITE]))
+			blk_mq_sched_mark_restart_hctx(rq->mq_hctx);
 		spin_unlock_irqrestore(&dd->zone_lock, flags);
 	}
 }


