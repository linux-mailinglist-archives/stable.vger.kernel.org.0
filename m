Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D74BAC9F96
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 15:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729586AbfJCNky (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 09:40:54 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:42335 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729440AbfJCNkx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Oct 2019 09:40:53 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 6885C21B82;
        Thu,  3 Oct 2019 09:40:52 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 03 Oct 2019 09:40:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=P3uThd
        wTZXKHZ6QaUlHDF6KiKK8BWQQ/hPqZjhjCr3M=; b=c3LRhBLvbgJp5UOGLyf6Ok
        4cTDkZgb+HkhqdpPodX1gkWD/XXERHCew/BPbzUstG9SUJ3y6P9xNwQDNEmiPApU
        NDH/H0ADM43QkreeJ2B7Zfd+z+sJNaeUt6w0VV1HMUPyyowTA0wp8/Ppn9LK6r2F
        zNj2AYmtuMv/RT0pooE6rfzdhl64WcvOWBYBEES85/Vpq4eD3faPULeJnCSuTcF7
        o922NoL/K8swkgob4oInzU0aNCz1MaM38gDrOsIUtjjPOAEKl/+s8b7ht3g8MbRL
        sLxFFdRVKaFp/oU8rZPCjBpzrg8AL0xMJEu2Ml99MLNsdLFD0AoAMBVhrzgr/9mQ
        ==
X-ME-Sender: <xms:Y_qVXXFwOBa8nteNHrXivDZtjLnm2afqjgrgJ-UNpCAcpDNtOp4Aiw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrgeekgdeikecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:Y_qVXYlbXnLW6DrgOhcoPi24UKeKcYALLUumUbr7FZaQHaQJaxTMoA>
    <xmx:Y_qVXUL8YGqubuyOohbDtUHb8ddt0ydCE-0-8X67XFNSFQtHyk6MKQ>
    <xmx:Y_qVXZa9xUXV0L4s06CHnkKTk7DPe-3xx1jssZOomxMORZkhOHiEww>
    <xmx:ZPqVXVWUaL2KGnOWyw00TFx2_Di5h9KHR-fAZ3r6-BDuBibZ-K2zng>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 09D1280061;
        Thu,  3 Oct 2019 09:40:50 -0400 (EDT)
Subject: FAILED: patch "[PATCH] block: mq-deadline: Fix queue restart handling" failed to apply to 4.19-stable tree
To:     damien.lemoal@wdc.com, Hans.Holmberg@wdc.com, axboe@kernel.dk,
        hans.holmberg@wdc.com, hch@lst.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 03 Oct 2019 15:40:48 +0200
Message-ID: <1570110048170134@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From cb8acabbe33b110157955a7425ee876fb81e6bbc Mon Sep 17 00:00:00 2001
From: Damien Le Moal <damien.lemoal@wdc.com>
Date: Wed, 28 Aug 2019 13:40:20 +0900
Subject: [PATCH] block: mq-deadline: Fix queue restart handling

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

diff --git a/block/mq-deadline.c b/block/mq-deadline.c
index 2a2a2e82832e..35e84bc0ec8c 100644
--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -377,13 +377,6 @@ static struct request *__dd_dispatch_request(struct deadline_data *dd)
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
@@ -392,9 +385,6 @@ static struct request *dd_dispatch_request(struct blk_mq_hw_ctx *hctx)
 
 	spin_lock(&dd->lock);
 	rq = __dd_dispatch_request(dd);
-	if (!rq && blk_queue_is_zoned(hctx->queue) &&
-	    !list_empty(&dd->fifo_list[WRITE]))
-		blk_mq_sched_mark_restart_hctx(hctx);
 	spin_unlock(&dd->lock);
 
 	return rq;
@@ -561,6 +551,13 @@ static void dd_prepare_request(struct request *rq, struct bio *bio)
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
@@ -572,6 +569,8 @@ static void dd_finish_request(struct request *rq)
 
 		spin_lock_irqsave(&dd->zone_lock, flags);
 		blk_req_zone_write_unlock(rq);
+		if (!list_empty(&dd->fifo_list[WRITE]))
+			blk_mq_sched_mark_restart_hctx(rq->mq_hctx);
 		spin_unlock_irqrestore(&dd->zone_lock, flags);
 	}
 }

