Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D9DD14E213
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727606AbgA3Sta (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:49:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:59340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728099AbgA3SsZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:48:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2F45215A4;
        Thu, 30 Jan 2020 18:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580410104;
        bh=omQK6YtQPZxeFMc5Tcn4LImuQtqGDm4lYcaymhI5MBs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w8kjtesrX0wPrCJOx/DrXG15IFmIm1cqBaa/5iMNcZS5UJHXnNCcwDtE5nboGePLf
         J7gdO7xaYDJDNox9JUP2Gdgcmf/qhdijDHnHD6v4G3UsoCAVV2kS9ks+FgxYuAlxMb
         IvhHXEJ7tg/UlNFi06wtt59lUW+caEHQJF6CzeWs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sargun Dhillon <sargun@sargun.me>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>,
        Thomas Gleixner <tglx@linutronix.de>, tj@kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Janne Huttunen <janne.huttunen@nokia.com>
Subject: [PATCH 4.19 47/55] sched/fair: Fix insertion in rq->leaf_cfs_rq_list
Date:   Thu, 30 Jan 2020 19:39:28 +0100
Message-Id: <20200130183617.093532313@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183608.563083888@linuxfoundation.org>
References: <20200130183608.563083888@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Guittot <vincent.guittot@linaro.org>

commit f6783319737f28e4436a69611853a5a098cbe974 upstream.

Sargun reported a crash:

  "I picked up c40f7d74c741a907cfaeb73a7697081881c497d0 sched/fair: Fix
   infinite loop in update_blocked_averages() by reverting a9e7f6544b9c
   and put it on top of 4.19.13. In addition to this, I uninlined
   list_add_leaf_cfs_rq for debugging.

   This revealed a new bug that we didn't get to because we kept getting
   crashes from the previous issue. When we are running with cgroups that
   are rapidly changing, with CFS bandwidth control, and in addition
   using the cpusets cgroup, we see this crash. Specifically, it seems to
   occur with cgroups that are throttled and we change the allowed
   cpuset."

The algorithm used to order cfs_rq in rq->leaf_cfs_rq_list assumes that
it will walk down to root the 1st time a cfs_rq is used and we will finish
to add either a cfs_rq without parent or a cfs_rq with a parent that is
already on the list. But this is not always true in presence of throttling.
Because a cfs_rq can be throttled even if it has never been used but other CPUs
of the cgroup have already used all the bandwdith, we are not sure to go down to
the root and add all cfs_rq in the list.

Ensure that all cfs_rq will be added in the list even if they are throttled.

[ mingo: Fix !CGROUPS build. ]

Reported-by: Sargun Dhillon <sargun@sargun.me>
Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: tj@kernel.org
Fixes: 9c2791f936ef ("Fix hierarchical order in rq->leaf_cfs_rq_list")
Link: https://lkml.kernel.org/r/1548825767-10799-1-git-send-email-vincent.guittot@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Janne Huttunen <janne.huttunen@nokia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/sched/fair.c |   33 ++++++++++++++++++++++++++++-----
 1 file changed, 28 insertions(+), 5 deletions(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -282,13 +282,13 @@ static inline struct cfs_rq *group_cfs_r
 	return grp->my_q;
 }
 
-static inline void list_add_leaf_cfs_rq(struct cfs_rq *cfs_rq)
+static inline bool list_add_leaf_cfs_rq(struct cfs_rq *cfs_rq)
 {
 	struct rq *rq = rq_of(cfs_rq);
 	int cpu = cpu_of(rq);
 
 	if (cfs_rq->on_list)
-		return;
+		return rq->tmp_alone_branch == &rq->leaf_cfs_rq_list;
 
 	cfs_rq->on_list = 1;
 
@@ -317,7 +317,7 @@ static inline void list_add_leaf_cfs_rq(
 		 * list.
 		 */
 		rq->tmp_alone_branch = &rq->leaf_cfs_rq_list;
-		return;
+		return true;
 	}
 
 	if (!cfs_rq->tg->parent) {
@@ -332,7 +332,7 @@ static inline void list_add_leaf_cfs_rq(
 		 * tmp_alone_branch to the beginning of the list.
 		 */
 		rq->tmp_alone_branch = &rq->leaf_cfs_rq_list;
-		return;
+		return true;
 	}
 
 	/*
@@ -347,6 +347,7 @@ static inline void list_add_leaf_cfs_rq(
 	 * of the branch
 	 */
 	rq->tmp_alone_branch = &cfs_rq->leaf_cfs_rq_list;
+	return false;
 }
 
 static inline void list_del_leaf_cfs_rq(struct cfs_rq *cfs_rq)
@@ -448,8 +449,9 @@ static inline struct cfs_rq *group_cfs_r
 	return NULL;
 }
 
-static inline void list_add_leaf_cfs_rq(struct cfs_rq *cfs_rq)
+static inline bool list_add_leaf_cfs_rq(struct cfs_rq *cfs_rq)
 {
+	return true;
 }
 
 static inline void list_del_leaf_cfs_rq(struct cfs_rq *cfs_rq)
@@ -5019,6 +5021,12 @@ static void __maybe_unused unthrottle_of
 }
 
 #else /* CONFIG_CFS_BANDWIDTH */
+
+static inline bool cfs_bandwidth_used(void)
+{
+	return false;
+}
+
 static inline u64 cfs_rq_clock_task(struct cfs_rq *cfs_rq)
 {
 	return rq_clock_task(rq_of(cfs_rq));
@@ -5174,6 +5182,21 @@ enqueue_task_fair(struct rq *rq, struct
 	if (!se)
 		add_nr_running(rq, 1);
 
+	if (cfs_bandwidth_used()) {
+		/*
+		 * When bandwidth control is enabled; the cfs_rq_throttled()
+		 * breaks in the above iteration can result in incomplete
+		 * leaf list maintenance, resulting in triggering the assertion
+		 * below.
+		 */
+		for_each_sched_entity(se) {
+			cfs_rq = cfs_rq_of(se);
+
+			if (list_add_leaf_cfs_rq(cfs_rq))
+				break;
+		}
+	}
+
 	assert_list_leaf_cfs_rq(rq);
 
 	hrtick_update(rq);


