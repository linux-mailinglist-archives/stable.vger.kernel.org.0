Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB98518CE3F
	for <lists+stable@lfdr.de>; Fri, 20 Mar 2020 13:58:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbgCTM65 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Mar 2020 08:58:57 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:35647 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727222AbgCTM6P (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Mar 2020 08:58:15 -0400
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1jFHE0-0003lF-VP; Fri, 20 Mar 2020 13:58:09 +0100
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id C87881C22C3;
        Fri, 20 Mar 2020 13:58:06 +0100 (CET)
Date:   Fri, 20 Mar 2020 12:58:06 -0000
From:   "tip-bot2 for Vincent Guittot" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: sched/core] sched/fair: Fix enqueue_task_fair warning
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        stable@vger.kernel.org, stable@vger.kernel.org,
        #v5.1+@tip-bot2.tec.linutronix.de, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20200306135257.25044-1-vincent.guittot@linaro.org>
References: <20200306135257.25044-1-vincent.guittot@linaro.org>
MIME-Version: 1.0
Message-ID: <158470908651.28353.12189194857904620285.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the sched/core branch of tip:

Commit-ID:     fe61468b2cbc2b7ce5f8d3bf32ae5001d4c434e9
Gitweb:        https://git.kernel.org/tip/fe61468b2cbc2b7ce5f8d3bf32ae5001d4c434e9
Author:        Vincent Guittot <vincent.guittot@linaro.org>
AuthorDate:    Fri, 06 Mar 2020 14:52:57 +01:00
Committer:     Peter Zijlstra <peterz@infradead.org>
CommitterDate: Fri, 20 Mar 2020 13:06:18 +01:00

sched/fair: Fix enqueue_task_fair warning

When a cfs rq is throttled, the latter and its child are removed from the
leaf list but their nr_running is not changed which includes staying higher
than 1. When a task is enqueued in this throttled branch, the cfs rqs must
be added back in order to ensure correct ordering in the list but this can
only happens if nr_running == 1.
When cfs bandwidth is used, we call unconditionnaly list_add_leaf_cfs_rq()
when enqueuing an entity to make sure that the complete branch will be
added.

Similarly unthrottle_cfs_rq() can stop adding cfs in the list when a parent
is throttled. Iterate the remaining entity to ensure that the complete
branch will be added in the list.

Reported-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Tested-by: Christian Borntraeger <borntraeger@de.ibm.com>
Tested-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: stable@vger.kernel.org
Cc: stable@vger.kernel.org #v5.1+
Link: https://lkml.kernel.org/r/20200306135257.25044-1-vincent.guittot@linaro.org
---
 kernel/sched/fair.c | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 1dea855..c7aaae2 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4136,6 +4136,7 @@ static inline void check_schedstat_required(void)
 #endif
 }
 
+static inline bool cfs_bandwidth_used(void);
 
 /*
  * MIGRATION
@@ -4214,10 +4215,16 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 		__enqueue_entity(cfs_rq, se);
 	se->on_rq = 1;
 
-	if (cfs_rq->nr_running == 1) {
+	/*
+	 * When bandwidth control is enabled, cfs might have been removed
+	 * because of a parent been throttled but cfs->nr_running > 1. Try to
+	 * add it unconditionnally.
+	 */
+	if (cfs_rq->nr_running == 1 || cfs_bandwidth_used())
 		list_add_leaf_cfs_rq(cfs_rq);
+
+	if (cfs_rq->nr_running == 1)
 		check_enqueue_throttle(cfs_rq);
-	}
 }
 
 static void __clear_buddies_last(struct sched_entity *se)
@@ -4808,11 +4815,22 @@ void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
 			break;
 	}
 
-	assert_list_leaf_cfs_rq(rq);
-
 	if (!se)
 		add_nr_running(rq, task_delta);
 
+	/*
+	 * The cfs_rq_throttled() breaks in the above iteration can result in
+	 * incomplete leaf list maintenance, resulting in triggering the
+	 * assertion below.
+	 */
+	for_each_sched_entity(se) {
+		cfs_rq = cfs_rq_of(se);
+
+		list_add_leaf_cfs_rq(cfs_rq);
+	}
+
+	assert_list_leaf_cfs_rq(rq);
+
 	/* Determine whether we need to wake up potentially idle CPU: */
 	if (rq->curr == rq->idle && rq->cfs.nr_running)
 		resched_curr(rq);
