Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB8517BF96
	for <lists+stable@lfdr.de>; Fri,  6 Mar 2020 14:53:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbgCFNxH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Mar 2020 08:53:07 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39859 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726251AbgCFNxH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Mar 2020 08:53:07 -0500
Received: by mail-wr1-f65.google.com with SMTP id y17so2453596wrn.6
        for <stable@vger.kernel.org>; Fri, 06 Mar 2020 05:53:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=HiH2M0/3yuQ9rG6qTjCXMrsrRmxTDtobqQj41AdBpaY=;
        b=w1pq0bevIwABf32a6S1sqk9llhRXEfhWU5wIyAMyzvKuA71aydmiWR/E6MBhh/V9bx
         GTGdz1ZZDn/tdpRnZfvMNGaXer8eFF+Wqix1fzIdssTZ+3QTeHfhE0BSYHCF7QGCoVhm
         iEe1v8YR3y8GmxW9AyUnKbYi3oORaeibV2It+xgiMsbNFZRmASnlwBgRTKjeUW8NwhDf
         xEyhn4M2w2CRW8JBpCodcnYlPgiP9hO8BiZnVf2VuH1WegdzEZ7Us8ngVKf40QoTmt3f
         JRkrb12DGh3B5YZtriDKzOk3c0f54beZAOlI6ooN1ZK0MdGQVaQosZNyPMtKrB8bg8vT
         Xn9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=HiH2M0/3yuQ9rG6qTjCXMrsrRmxTDtobqQj41AdBpaY=;
        b=JCqBN4O5DDmz5FmTBBI65hNeEL82n0L/PA1Q1LnVbOxkmk4dNtG7pVMtNGjp38HcZL
         Rf+pu4ft3WK8RIoALfelPiVhvvolWQn8xoZglDTy8FZ7t6WNmeE4pkrj982MumVjwO2t
         xVRACLgwpzrYN4RzvpreNYuAhcIIMrsmkrvuItvvV492n0/u/c63v6oR/QWyFWoJDd49
         jud4i0ABrNal4jObAHcRWMD7bI10KNiy9AQ5UAyUJpGh9CJVgo2Ju73v4yA9aymUOO+9
         AOMpOyRNqcmiPzJa8gTvepYkvkpa8Qc5gMmqXMNXkmXjGT3pMRoc4QouUKc5cM4hNkHp
         UjSg==
X-Gm-Message-State: ANhLgQ3YxBVoXOKzJNgJRTS0S1BZNC09eDwQK8XkZYTa+7jwFrxM4w5f
        BclAKSx8u/XDUjLZH4DJlzxPDA==
X-Google-Smtp-Source: ADFU+vskPHbfBYO1Gqp7RRQsustG07yhjUpepm4EJH0p0WzHlPSUjnZCU2aMRz391ZXKfrPKyrunWw==
X-Received: by 2002:adf:a555:: with SMTP id j21mr4259019wrb.409.1583502785069;
        Fri, 06 Mar 2020 05:53:05 -0800 (PST)
Received: from localhost.localdomain ([2a01:e0a:f:6020:d5d0:80d7:4f6f:54be])
        by smtp.gmail.com with ESMTPSA id s5sm47546636wru.39.2020.03.06.05.53.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2020 05:53:03 -0800 (PST)
From:   Vincent Guittot <vincent.guittot@linaro.org>
To:     mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com,
        dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com,
        mgorman@suse.de, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com
Cc:     Vincent Guittot <vincent.guittot@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH v2] sched/fair: fix enqueue_task_fair warning
Date:   Fri,  6 Mar 2020 14:52:57 +0100
Message-Id: <20200306135257.25044-1-vincent.guittot@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Tested-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Tested-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: stable@vger.kernel.org #v5.1+
Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---

Change since v1:
- added the iteration at the end of unthrottle_cfs_rq() as Dietmar
  reported use case which triggered assert_list_leaf_cfs_rq()

 kernel/sched/fair.c | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index fcc968669aea..ae50a09cbead 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4117,6 +4117,7 @@ static inline void check_schedstat_required(void)
 #endif
 }
 
+static inline bool cfs_bandwidth_used(void);
 
 /*
  * MIGRATION
@@ -4195,10 +4196,16 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
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
@@ -4779,11 +4786,22 @@ void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
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
-- 
2.17.1

