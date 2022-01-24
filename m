Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D40E1499FC4
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:23:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1842128AbiAXXA7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:00:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1836493AbiAXWjh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:39:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6000C054874;
        Mon, 24 Jan 2022 13:01:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4366B6131F;
        Mon, 24 Jan 2022 21:01:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 183EDC340E5;
        Mon, 24 Jan 2022 21:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058106;
        bh=cf3LxnhY71jlrMoqRMBqvHmx+grq7ctd4LTG2H4U8cw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V+OUp9QdQ87TnIrHlJBTPwqtIyHFVjw6Rx+qRKBmbv0VwLewBsvhxm89REL+LP5gS
         f1630gGYwOjWaxRBsPPMoNNU+YxMHt5DKH3AHVqj2ls6wvzgGl6Jhu27XI5n2MXMRL
         EahyIY0jOhex93gDUUD75KDG+xH93MvOi4i8+sR8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Valente <paolo.valente@linaro.org>,
        Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0183/1039] bfq: Do not let waker requests skip proper accounting
Date:   Mon, 24 Jan 2022 19:32:52 +0100
Message-Id: <20220124184131.428737070@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

[ Upstream commit c65e6fd460b4df796ecd6ea22e132076ed1f2820 ]

Commit 7cc4ffc55564 ("block, bfq: put reqs of waker and woken in
dispatch list") added a condition to bfq_insert_request() which added
waker's requests directly to dispatch list. The rationale was that
completing waker's IO is needed to get more IO for the current queue.
Although this rationale is valid, there is a hole in it. The waker does
not necessarily serve the IO only for the current queue and maybe it's
current IO is not needed for current queue to make progress. Furthermore
injecting IO like this completely bypasses any service accounting within
bfq and thus we do not properly track how much service is waker's queue
getting or that the waker is actually doing any IO. Depending on the
conditions this can result in the waker getting too much or too few
service.

Consider for example the following job file:

[global]
directory=/mnt/repro/
rw=write
size=8g
time_based
runtime=30
ramp_time=10
blocksize=1m
direct=0
ioengine=sync

[slowwriter]
numjobs=1
prioclass=2
prio=7
fsync=200

[fastwriter]
numjobs=1
prioclass=2
prio=0
fsync=200

Despite processes have very different IO priorities, they get the same
about of service. The reason is that bfq identifies these processes as
having waker-wakee relationship and once that happens, IO from
fastwriter gets injected during slowwriter's time slice. As a result bfq
is not aware that fastwriter has any IO to do and constantly schedules
only slowwriter's queue. Thus fastwriter is forced to compete with
slowwriter's IO all the time instead of getting its share of time based
on IO priority.

Drop the special injection condition from bfq_insert_request(). As a
result, requests will be tracked and queued in a normal way and on next
dispatch bfq_select_queue() can decide whether the waker's inserted
requests should be injected during the current queue's timeslice or not.

Fixes: 7cc4ffc55564 ("block, bfq: put reqs of waker and woken in dispatch list")
Acked-by: Paolo Valente <paolo.valente@linaro.org>
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20211125133645.27483-8-jack@suse.cz
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bfq-iosched.c | 44 +-------------------------------------------
 1 file changed, 1 insertion(+), 43 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index fec18118dc309..30918b0e81c02 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -5991,48 +5991,7 @@ static void bfq_insert_request(struct blk_mq_hw_ctx *hctx, struct request *rq,
 
 	spin_lock_irq(&bfqd->lock);
 	bfqq = bfq_init_rq(rq);
-
-	/*
-	 * Reqs with at_head or passthrough flags set are to be put
-	 * directly into dispatch list. Additional case for putting rq
-	 * directly into the dispatch queue: the only active
-	 * bfq_queues are bfqq and either its waker bfq_queue or one
-	 * of its woken bfq_queues. The rationale behind this
-	 * additional condition is as follows:
-	 * - consider a bfq_queue, say Q1, detected as a waker of
-	 *   another bfq_queue, say Q2
-	 * - by definition of a waker, Q1 blocks the I/O of Q2, i.e.,
-	 *   some I/O of Q1 needs to be completed for new I/O of Q2
-	 *   to arrive.  A notable example of waker is journald
-	 * - so, Q1 and Q2 are in any respect the queues of two
-	 *   cooperating processes (or of two cooperating sets of
-	 *   processes): the goal of Q1's I/O is doing what needs to
-	 *   be done so that new Q2's I/O can finally be
-	 *   issued. Therefore, if the service of Q1's I/O is delayed,
-	 *   then Q2's I/O is delayed too.  Conversely, if Q2's I/O is
-	 *   delayed, the goal of Q1's I/O is hindered.
-	 * - as a consequence, if some I/O of Q1/Q2 arrives while
-	 *   Q2/Q1 is the only queue in service, there is absolutely
-	 *   no point in delaying the service of such an I/O. The
-	 *   only possible result is a throughput loss
-	 * - so, when the above condition holds, the best option is to
-	 *   have the new I/O dispatched as soon as possible
-	 * - the most effective and efficient way to attain the above
-	 *   goal is to put the new I/O directly in the dispatch
-	 *   list
-	 * - as an additional restriction, Q1 and Q2 must be the only
-	 *   busy queues for this commit to put the I/O of Q2/Q1 in
-	 *   the dispatch list.  This is necessary, because, if also
-	 *   other queues are waiting for service, then putting new
-	 *   I/O directly in the dispatch list may evidently cause a
-	 *   violation of service guarantees for the other queues
-	 */
-	if (!bfqq ||
-	    (bfqq != bfqd->in_service_queue &&
-	     bfqd->in_service_queue != NULL &&
-	     bfq_tot_busy_queues(bfqd) == 1 + bfq_bfqq_busy(bfqq) &&
-	     (bfqq->waker_bfqq == bfqd->in_service_queue ||
-	      bfqd->in_service_queue->waker_bfqq == bfqq)) || at_head) {
+	if (!bfqq || at_head) {
 		if (at_head)
 			list_add(&rq->queuelist, &bfqd->dispatch);
 		else
@@ -6059,7 +6018,6 @@ static void bfq_insert_request(struct blk_mq_hw_ctx *hctx, struct request *rq,
 	 * merge).
 	 */
 	cmd_flags = rq->cmd_flags;
-
 	spin_unlock_irq(&bfqd->lock);
 
 	bfq_update_insert_stats(q, bfqq, idle_timer_disabled,
-- 
2.34.1



