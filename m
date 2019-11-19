Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 300ED10184B
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:07:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728201AbfKSFdi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:33:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:54186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728839AbfKSFdh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:33:37 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82CD921783;
        Tue, 19 Nov 2019 05:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141616;
        bh=lPL/Fqkv/wk/e+ywuFI15F63eJE2Xvzj5FPReiZlEhc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f4bwVFasmPOjxACBKlGWN9dSNsNQuDJB4m2qggYr8rUlkyLU9GIOqjC4XUn7mctTr
         lh4/PmeQghdg5CP9qnlNtftA7nQ8uhDGwjO5MFspdSLCyHkBZ37au4ARJ7bLnXznpQ
         JlFQXCVRdLRCVpxtgzgMlSE8xPQzbs3oT5DXSl4c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 220/422] block, bfq: inject other-queue I/O into seeky idle queues on NCQ flash
Date:   Tue, 19 Nov 2019 06:16:57 +0100
Message-Id: <20191119051412.882089519@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Valente <paolo.valente@linaro.org>

[ Upstream commit d0edc2473be9d70f999282e1ca7863ad6ae704dc ]

The Achilles' heel of BFQ is its failing to reach a high throughput
with sync random I/O on flash storage with internal queueing, in case
the processes doing I/O have differentiated weights.

The cause of this failure is as follows. If at least two processes do
sync I/O, and have a different weight from each other, then BFQ plugs
I/O dispatching every time one of these processes, while it is being
served, remains temporarily without pending I/O requests. This
plugging is necessary to guarantee that every process enjoys a
bandwidth proportional to its weight; but it empties the internal
queue(s) of the drive. And this kills throughput with random I/O. So,
if some processes have differentiated weights and do both sync and
random I/O, the end result is a throughput collapse.

This commit tries to counter this problem by injecting the service of
other processes, in a controlled way, while the process in service
happens to have no I/O. This injection is performed only if the medium
is non rotational and performs internal queueing, and the process in
service does random I/O (service injection might be beneficial for
sequential I/O too, we'll work on that).

As an example of the benefits of this commit, on a PLEXTOR PX-256M5S
SSD, and with five processes having differentiated weights and doing
sync random 4KB I/O, this commit makes the throughput with bfq grow by
400%, from 25 to 100MB/s. This higher throughput is 10MB/s lower than
that reached with none. As some less random I/O is added to the mix,
the throughput becomes equal to or higher than that with none.

This commit is a very first attempt to recover throughput without
losing control, and certainly has many limitations. One is, e.g., that
the processes whose service is injected are not chosen so as to
distribute the extra bandwidth they receive in accordance to their
weights. Thus there might be loss of weighted fairness in some
cases. Anyway, this loss concerns extra service, which would not have
been received at all without this commit. Other limitations and issues
will probably show up with usage.

Signed-off-by: Paolo Valente <paolo.valente@linaro.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bfq-iosched.c | 68 +++++++++++++++++++++++++++++++++++++++++----
 block/bfq-iosched.h | 26 +++++++++++++++++
 2 files changed, 88 insertions(+), 6 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index d8d2ac294b0c0..35ddaa820737c 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -3195,6 +3195,13 @@ static unsigned long bfq_bfqq_softrt_next_start(struct bfq_data *bfqd,
 		    jiffies + nsecs_to_jiffies(bfqq->bfqd->bfq_slice_idle) + 4);
 }
 
+static bool bfq_bfqq_injectable(struct bfq_queue *bfqq)
+{
+	return BFQQ_SEEKY(bfqq) && bfqq->wr_coeff == 1 &&
+		blk_queue_nonrot(bfqq->bfqd->queue) &&
+		bfqq->bfqd->hw_tag;
+}
+
 /**
  * bfq_bfqq_expire - expire a queue.
  * @bfqd: device owning the queue.
@@ -3304,6 +3311,8 @@ void bfq_bfqq_expire(struct bfq_data *bfqd,
 	if (ref == 1) /* bfqq is gone, no more actions on it */
 		return;
 
+	bfqq->injected_service = 0;
+
 	/* mark bfqq as waiting a request only if a bic still points to it */
 	if (!bfq_bfqq_busy(bfqq) &&
 	    reason != BFQQE_BUDGET_TIMEOUT &&
@@ -3642,6 +3651,30 @@ static bool bfq_bfqq_must_idle(struct bfq_queue *bfqq)
 	return RB_EMPTY_ROOT(&bfqq->sort_list) && bfq_better_to_idle(bfqq);
 }
 
+static struct bfq_queue *bfq_choose_bfqq_for_injection(struct bfq_data *bfqd)
+{
+	struct bfq_queue *bfqq;
+
+	/*
+	 * A linear search; but, with a high probability, very few
+	 * steps are needed to find a candidate queue, i.e., a queue
+	 * with enough budget left for its next request. In fact:
+	 * - BFQ dynamically updates the budget of every queue so as
+	 *   to accommodate the expected backlog of the queue;
+	 * - if a queue gets all its requests dispatched as injected
+	 *   service, then the queue is removed from the active list
+	 *   (and re-added only if it gets new requests, but with
+	 *   enough budget for its new backlog).
+	 */
+	list_for_each_entry(bfqq, &bfqd->active_list, bfqq_list)
+		if (!RB_EMPTY_ROOT(&bfqq->sort_list) &&
+		    bfq_serv_to_charge(bfqq->next_rq, bfqq) <=
+		    bfq_bfqq_budget_left(bfqq))
+			return bfqq;
+
+	return NULL;
+}
+
 /*
  * Select a queue for service.  If we have a current queue in service,
  * check whether to continue servicing it, or retrieve and set a new one.
@@ -3723,10 +3756,19 @@ check_queue:
 	 * No requests pending. However, if the in-service queue is idling
 	 * for a new request, or has requests waiting for a completion and
 	 * may idle after their completion, then keep it anyway.
+	 *
+	 * Yet, to boost throughput, inject service from other queues if
+	 * possible.
 	 */
 	if (bfq_bfqq_wait_request(bfqq) ||
 	    (bfqq->dispatched != 0 && bfq_better_to_idle(bfqq))) {
-		bfqq = NULL;
+		if (bfq_bfqq_injectable(bfqq) &&
+		    bfqq->injected_service * bfqq->inject_coeff <
+		    bfqq->entity.service * 10)
+			bfqq = bfq_choose_bfqq_for_injection(bfqd);
+		else
+			bfqq = NULL;
+
 		goto keep_queue;
 	}
 
@@ -3816,6 +3858,14 @@ static struct request *bfq_dispatch_rq_from_bfqq(struct bfq_data *bfqd,
 
 	bfq_dispatch_remove(bfqd->queue, rq);
 
+	if (bfqq != bfqd->in_service_queue) {
+		if (likely(bfqd->in_service_queue))
+			bfqd->in_service_queue->injected_service +=
+				bfq_serv_to_charge(rq, bfqq);
+
+		goto return_rq;
+	}
+
 	/*
 	 * If weight raising has to terminate for bfqq, then next
 	 * function causes an immediate update of bfqq's weight,
@@ -3834,13 +3884,12 @@ static struct request *bfq_dispatch_rq_from_bfqq(struct bfq_data *bfqd,
 	 * belongs to CLASS_IDLE and other queues are waiting for
 	 * service.
 	 */
-	if (bfqd->busy_queues > 1 && bfq_class_idle(bfqq))
-		goto expire;
-
-	return rq;
+	if (!(bfqd->busy_queues > 1 && bfq_class_idle(bfqq)))
+		goto return_rq;
 
-expire:
 	bfq_bfqq_expire(bfqd, bfqq, false, BFQQE_BUDGET_EXHAUSTED);
+
+return_rq:
 	return rq;
 }
 
@@ -4246,6 +4295,13 @@ static void bfq_init_bfqq(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 			bfq_mark_bfqq_has_short_ttime(bfqq);
 		bfq_mark_bfqq_sync(bfqq);
 		bfq_mark_bfqq_just_created(bfqq);
+		/*
+		 * Aggressively inject a lot of service: up to 90%.
+		 * This coefficient remains constant during bfqq life,
+		 * but this behavior might be changed, after enough
+		 * testing and tuning.
+		 */
+		bfqq->inject_coeff = 1;
 	} else
 		bfq_clear_bfqq_sync(bfqq);
 
diff --git a/block/bfq-iosched.h b/block/bfq-iosched.h
index d5e9e60cb1a5f..a41e9884f2dd2 100644
--- a/block/bfq-iosched.h
+++ b/block/bfq-iosched.h
@@ -351,6 +351,32 @@ struct bfq_queue {
 	unsigned long split_time; /* time of last split */
 
 	unsigned long first_IO_time; /* time of first I/O for this queue */
+
+	/* max service rate measured so far */
+	u32 max_service_rate;
+	/*
+	 * Ratio between the service received by bfqq while it is in
+	 * service, and the cumulative service (of requests of other
+	 * queues) that may be injected while bfqq is empty but still
+	 * in service. To increase precision, the coefficient is
+	 * measured in tenths of unit. Here are some example of (1)
+	 * ratios, (2) resulting percentages of service injected
+	 * w.r.t. to the total service dispatched while bfqq is in
+	 * service, and (3) corresponding values of the coefficient:
+	 * 1 (50%) -> 10
+	 * 2 (33%) -> 20
+	 * 10 (9%) -> 100
+	 * 9.9 (9%) -> 99
+	 * 1.5 (40%) -> 15
+	 * 0.5 (66%) -> 5
+	 * 0.1 (90%) -> 1
+	 *
+	 * So, if the coefficient is lower than 10, then
+	 * injected service is more than bfqq service.
+	 */
+	unsigned int inject_coeff;
+	/* amount of service injected in current service slot */
+	unsigned int injected_service;
 };
 
 /**
-- 
2.20.1



