Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD2E947FED4
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:33:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237848AbhL0Pcv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:32:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237909AbhL0Pcq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:32:46 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35CECC06173E;
        Mon, 27 Dec 2021 07:32:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 751E4CE10CB;
        Mon, 27 Dec 2021 15:32:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F15AC36AEA;
        Mon, 27 Dec 2021 15:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619162;
        bh=gCzMgD61y1tiuU8Y99qaRfET3JIP5Z/yd6u7N0H1yuI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1gioFUGZMIuKbGJZf6s4CdGxpHMtLbgEXMusNF7oLGPEN+0cb6HycXL9fx/bpH6fG
         JhMIygiUVs8qJ9i7VmHvs5HQPzAm3Rn2ZzsY0ibpFCEIXi/1TTba09q7GeKuEWZDvg
         QkECYp/ADfyWUwB0fu353XQkRvV1RMzoh9L60jMU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steven Barrett <steven@liquorix.net>,
        Lucjan Lucjanov <lucjan.lucjanov@gmail.com>,
        Federico Motta <federico@willer.it>,
        Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>, Yu Kuai <yukuai3@huawei.com>
Subject: [PATCH 4.19 04/38] block, bfq: fix decrement of num_active_groups
Date:   Mon, 27 Dec 2021 16:30:41 +0100
Message-Id: <20211227151319.526009941@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151319.379265346@linuxfoundation.org>
References: <20211227151319.379265346@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Valente <paolo.valente@linaro.org>

commit ba7aeae5539c7a7cccc4cf07a2bc61281a93c50e upstream.

Since commit '2d29c9f89fcd ("block, bfq: improve asymmetric scenarios
detection")', if there are process groups with I/O requests waiting for
completion, then BFQ tags the scenario as 'asymmetric'. This detection
is needed for preserving service guarantees (for details, see comments
on the computation * of the variable asymmetric_scenario in the
function bfq_better_to_idle).

Unfortunately, commit '2d29c9f89fcd ("block, bfq: improve asymmetric
scenarios detection")' contains an error exactly in the updating of
the number of groups with I/O requests waiting for completion: if a
group has more than one descendant process, then the above number of
groups, which is renamed from num_active_groups to a more appropriate
num_groups_with_pending_reqs by this commit, may happen to be wrongly
decremented multiple times, namely every time one of the descendant
processes gets all its pending I/O requests completed.

A correct, complete solution should work as follows. Consider a group
that is inactive, i.e., that has no descendant process with pending
I/O inside BFQ queues. Then suppose that num_groups_with_pending_reqs
is still accounting for this group, because the group still has some
descendant process with some I/O request still in
flight. num_groups_with_pending_reqs should be decremented when the
in-flight request of the last descendant process is finally completed
(assuming that nothing else has changed for the group in the meantime,
in terms of composition of the group and active/inactive state of
child groups and processes). To accomplish this, an additional
pending-request counter must be added to entities, and must be
updated correctly.

To avoid this additional field and operations, this commit resorts to
the following tradeoff between simplicity and accuracy: for an
inactive group that is still counted in num_groups_with_pending_reqs,
this commit decrements num_groups_with_pending_reqs when the first
descendant process of the group remains with no request waiting for
completion.

This simplified scheme provides a fix to the unbalanced decrements
introduced by 2d29c9f89fcd. Since this error was also caused by lack
of comments on this non-trivial issue, this commit also adds related
comments.

Fixes: 2d29c9f89fcd ("block, bfq: improve asymmetric scenarios detection")
Reported-by: Steven Barrett <steven@liquorix.net>
Tested-by: Steven Barrett <steven@liquorix.net>
Tested-by: Lucjan Lucjanov <lucjan.lucjanov@gmail.com>
Reviewed-by: Federico Motta <federico@willer.it>
Signed-off-by: Paolo Valente <paolo.valente@linaro.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/bfq-iosched.c |   76 ++++++++++++++++++++++++++++++++++++----------------
 block/bfq-iosched.h |   51 +++++++++++++++++++++++++++++++++-
 block/bfq-wf2q.c    |    5 ++-
 3 files changed, 107 insertions(+), 25 deletions(-)

--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -639,7 +639,7 @@ static bool bfq_varied_queue_weights_or_
 		 bfqd->queue_weights_tree.rb_node->rb_right)
 #ifdef CONFIG_BFQ_GROUP_IOSCHED
 	       ) ||
-		(bfqd->num_active_groups > 0
+		(bfqd->num_groups_with_pending_reqs > 0
 #endif
 	       );
 }
@@ -803,7 +803,21 @@ void bfq_weights_tree_remove(struct bfq_
 			 */
 			break;
 		}
-		bfqd->num_active_groups--;
+
+		/*
+		 * The decrement of num_groups_with_pending_reqs is
+		 * not performed immediately upon the deactivation of
+		 * entity, but it is delayed to when it also happens
+		 * that the first leaf descendant bfqq of entity gets
+		 * all its pending requests completed. The following
+		 * instructions perform this delayed decrement, if
+		 * needed. See the comments on
+		 * num_groups_with_pending_reqs for details.
+		 */
+		if (entity->in_groups_with_pending_reqs) {
+			entity->in_groups_with_pending_reqs = false;
+			bfqd->num_groups_with_pending_reqs--;
+		}
 	}
 }
 
@@ -3544,27 +3558,44 @@ static bool bfq_better_to_idle(struct bf
 	 * fact, if there are active groups, then, for condition (i)
 	 * to become false, it is enough that an active group contains
 	 * more active processes or sub-groups than some other active
-	 * group. We address this issue with the following bi-modal
-	 * behavior, implemented in the function
+	 * group. More precisely, for condition (i) to hold because of
+	 * such a group, it is not even necessary that the group is
+	 * (still) active: it is sufficient that, even if the group
+	 * has become inactive, some of its descendant processes still
+	 * have some request already dispatched but still waiting for
+	 * completion. In fact, requests have still to be guaranteed
+	 * their share of the throughput even after being
+	 * dispatched. In this respect, it is easy to show that, if a
+	 * group frequently becomes inactive while still having
+	 * in-flight requests, and if, when this happens, the group is
+	 * not considered in the calculation of whether the scenario
+	 * is asymmetric, then the group may fail to be guaranteed its
+	 * fair share of the throughput (basically because idling may
+	 * not be performed for the descendant processes of the group,
+	 * but it had to be).  We address this issue with the
+	 * following bi-modal behavior, implemented in the function
 	 * bfq_symmetric_scenario().
 	 *
-	 * If there are active groups, then the scenario is tagged as
+	 * If there are groups with requests waiting for completion
+	 * (as commented above, some of these groups may even be
+	 * already inactive), then the scenario is tagged as
 	 * asymmetric, conservatively, without checking any of the
 	 * conditions (i) and (ii). So the device is idled for bfqq.
 	 * This behavior matches also the fact that groups are created
-	 * exactly if controlling I/O (to preserve bandwidth and
-	 * latency guarantees) is a primary concern.
+	 * exactly if controlling I/O is a primary concern (to
+	 * preserve bandwidth and latency guarantees).
 	 *
-	 * On the opposite end, if there are no active groups, then
-	 * only condition (i) is actually controlled, i.e., provided
-	 * that condition (i) holds, idling is not performed,
-	 * regardless of whether condition (ii) holds. In other words,
-	 * only if condition (i) does not hold, then idling is
-	 * allowed, and the device tends to be prevented from queueing
-	 * many requests, possibly of several processes. Since there
-	 * are no active groups, then, to control condition (i) it is
-	 * enough to check whether all active queues have the same
-	 * weight.
+	 * On the opposite end, if there are no groups with requests
+	 * waiting for completion, then only condition (i) is actually
+	 * controlled, i.e., provided that condition (i) holds, idling
+	 * is not performed, regardless of whether condition (ii)
+	 * holds. In other words, only if condition (i) does not hold,
+	 * then idling is allowed, and the device tends to be
+	 * prevented from queueing many requests, possibly of several
+	 * processes. Since there are no groups with requests waiting
+	 * for completion, then, to control condition (i) it is enough
+	 * to check just whether all the queues with requests waiting
+	 * for completion also have the same weight.
 	 *
 	 * Not checking condition (ii) evidently exposes bfqq to the
 	 * risk of getting less throughput than its fair share.
@@ -3622,10 +3653,11 @@ static bool bfq_better_to_idle(struct bf
 	 * bfqq is weight-raised is checked explicitly here. More
 	 * precisely, the compound condition below takes into account
 	 * also the fact that, even if bfqq is being weight-raised,
-	 * the scenario is still symmetric if all active queues happen
-	 * to be weight-raised. Actually, we should be even more
-	 * precise here, and differentiate between interactive weight
-	 * raising and soft real-time weight raising.
+	 * the scenario is still symmetric if all queues with requests
+	 * waiting for completion happen to be
+	 * weight-raised. Actually, we should be even more precise
+	 * here, and differentiate between interactive weight raising
+	 * and soft real-time weight raising.
 	 *
 	 * As a side note, it is worth considering that the above
 	 * device-idling countermeasures may however fail in the
@@ -5447,7 +5479,7 @@ static int bfq_init_queue(struct request
 	bfqd->idle_slice_timer.function = bfq_idle_slice_timer;
 
 	bfqd->queue_weights_tree = RB_ROOT;
-	bfqd->num_active_groups = 0;
+	bfqd->num_groups_with_pending_reqs = 0;
 
 	INIT_LIST_HEAD(&bfqd->active_list);
 	INIT_LIST_HEAD(&bfqd->idle_list);
--- a/block/bfq-iosched.h
+++ b/block/bfq-iosched.h
@@ -196,6 +196,9 @@ struct bfq_entity {
 
 	/* flag, set to request a weight, ioprio or ioprio_class change  */
 	int prio_changed;
+
+	/* flag, set if the entity is counted in groups_with_pending_reqs */
+	bool in_groups_with_pending_reqs;
 };
 
 struct bfq_group;
@@ -448,10 +451,54 @@ struct bfq_data {
 	 * bfq_weights_tree_[add|remove] for further details).
 	 */
 	struct rb_root queue_weights_tree;
+
 	/*
-	 * number of groups with requests still waiting for completion
+	 * Number of groups with at least one descendant process that
+	 * has at least one request waiting for completion. Note that
+	 * this accounts for also requests already dispatched, but not
+	 * yet completed. Therefore this number of groups may differ
+	 * (be larger) than the number of active groups, as a group is
+	 * considered active only if its corresponding entity has
+	 * descendant queues with at least one request queued. This
+	 * number is used to decide whether a scenario is symmetric.
+	 * For a detailed explanation see comments on the computation
+	 * of the variable asymmetric_scenario in the function
+	 * bfq_better_to_idle().
+	 *
+	 * However, it is hard to compute this number exactly, for
+	 * groups with multiple descendant processes. Consider a group
+	 * that is inactive, i.e., that has no descendant process with
+	 * pending I/O inside BFQ queues. Then suppose that
+	 * num_groups_with_pending_reqs is still accounting for this
+	 * group, because the group has descendant processes with some
+	 * I/O request still in flight. num_groups_with_pending_reqs
+	 * should be decremented when the in-flight request of the
+	 * last descendant process is finally completed (assuming that
+	 * nothing else has changed for the group in the meantime, in
+	 * terms of composition of the group and active/inactive state of child
+	 * groups and processes). To accomplish this, an additional
+	 * pending-request counter must be added to entities, and must
+	 * be updated correctly. To avoid this additional field and operations,
+	 * we resort to the following tradeoff between simplicity and
+	 * accuracy: for an inactive group that is still counted in
+	 * num_groups_with_pending_reqs, we decrement
+	 * num_groups_with_pending_reqs when the first descendant
+	 * process of the group remains with no request waiting for
+	 * completion.
+	 *
+	 * Even this simpler decrement strategy requires a little
+	 * carefulness: to avoid multiple decrements, we flag a group,
+	 * more precisely an entity representing a group, as still
+	 * counted in num_groups_with_pending_reqs when it becomes
+	 * inactive. Then, when the first descendant queue of the
+	 * entity remains with no request waiting for completion,
+	 * num_groups_with_pending_reqs is decremented, and this flag
+	 * is reset. After this flag is reset for the entity,
+	 * num_groups_with_pending_reqs won't be decremented any
+	 * longer in case a new descendant queue of the entity remains
+	 * with no request waiting for completion.
 	 */
-	unsigned int num_active_groups;
+	unsigned int num_groups_with_pending_reqs;
 
 	/*
 	 * Number of bfq_queues containing requests (including the
--- a/block/bfq-wf2q.c
+++ b/block/bfq-wf2q.c
@@ -1012,7 +1012,10 @@ static void __bfq_activate_entity(struct
 			container_of(entity, struct bfq_group, entity);
 		struct bfq_data *bfqd = bfqg->bfqd;
 
-		bfqd->num_active_groups++;
+		if (!entity->in_groups_with_pending_reqs) {
+			entity->in_groups_with_pending_reqs = true;
+			bfqd->num_groups_with_pending_reqs++;
+		}
 	}
 #endif
 


