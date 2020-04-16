Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF9721AC952
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405207AbgDPPVp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:21:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:60602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2898599AbgDPNqc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:46:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55AEC21974;
        Thu, 16 Apr 2020 13:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044791;
        bh=onF0Q3ck23MEhrOfebvcgKutD7Bobnp4aqHWm2/ayD4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C13ngBRdOcowph6JBYB4z0vz2JeqqxDLdLSuflSEmkTCsSz7n1uyFmN5PP2+79n6z
         cMUiA0mYNmaYptkjvMNtb7A+Ptn+EgO+tZlFjDzwK1xyqnAlnrxWePpdhy5ozitWTO
         DGaljyihOf+3cqEEBSz/sgbhNjM7EBtT/KG1Cim8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>
Subject: [PATCH 5.4 104/232] sched/fair: Fix enqueue_task_fair warning
Date:   Thu, 16 Apr 2020 15:23:18 +0200
Message-Id: <20200416131328.097402688@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131316.640996080@linuxfoundation.org>
References: <20200416131316.640996080@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Guittot <vincent.guittot@linaro.org>

commit fe61468b2cbc2b7ce5f8d3bf32ae5001d4c434e9 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/sched/fair.c |   26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3927,6 +3927,7 @@ static inline void check_schedstat_requi
 #endif
 }
 
+static inline bool cfs_bandwidth_used(void);
 
 /*
  * MIGRATION
@@ -4005,10 +4006,16 @@ enqueue_entity(struct cfs_rq *cfs_rq, st
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
@@ -4589,11 +4596,22 @@ void unthrottle_cfs_rq(struct cfs_rq *cf
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


