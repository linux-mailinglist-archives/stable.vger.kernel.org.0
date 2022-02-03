Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 316674A8E18
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:35:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354844AbiBCUe1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:34:27 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:35956 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354831AbiBCUdQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:33:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 250EBB835AC;
        Thu,  3 Feb 2022 20:33:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04956C340E8;
        Thu,  3 Feb 2022 20:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920394;
        bh=/xlu2VM/Pmf6/hEtweejH6o/3L605ACUbkorLULWzOM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d7FBjsJpSU2PLoLK46OZDgGpT5Z+IHFkwlAeTZDKLCTMCHbZNR3sM6gBhuTZeZaKC
         TuAcWaxnCVOGRY8FM04GkJap/ZhXUxdms1qNwD3xdvFtDnsVE+jEFzNPFzHG1xGkEP
         Wv2iOullaQIqdJorq7s7f43M5B4UzVavCeQB0AOrvbT/xReNKzOb6EEcdUN0cuLqW9
         Fc6wOiIcd27+m6akqv93Ol9EVMmwrxTJa1nZsF+1izh5pVu9llbQYfI7xunjqHTS2/
         Yo0Fl2hkbGn2/UmOdykIRCEjUPFSK4NVxUBH3NKrvjTqBI1w0bBuSzHkN9yC8VyDZ6
         CWt7rMv+YadKQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vincent Guittot <vincent.guittot@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Sachin Sant <sachinp@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, mingo@redhat.com,
        juri.lelli@redhat.com
Subject: [PATCH AUTOSEL 5.15 17/41] sched/pelt: Relax the sync of runnable_sum with runnable_avg
Date:   Thu,  3 Feb 2022 15:32:21 -0500
Message-Id: <20220203203245.3007-17-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203203245.3007-1-sashal@kernel.org>
References: <20220203203245.3007-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Guittot <vincent.guittot@linaro.org>

[ Upstream commit 95246d1ec80b8d19d882cd8eb7ad094e63b41bb8 ]

Similarly to util_avg and util_sum, don't sync runnable_sum with the low
bound of runnable_avg but only ensure that runnable_sum stays in the
correct range.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Tested-by: Sachin Sant <sachinp@linux.ibm.com>
Link: https://lkml.kernel.org/r/20220111134659.24961-4-vincent.guittot@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index d41f966f5866a..2c06e50a4fac2 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3519,11 +3519,11 @@ update_tg_cfs_util(struct cfs_rq *cfs_rq, struct sched_entity *se, struct cfs_rq
 static inline void
 update_tg_cfs_runnable(struct cfs_rq *cfs_rq, struct sched_entity *se, struct cfs_rq *gcfs_rq)
 {
-	long delta = gcfs_rq->avg.runnable_avg - se->avg.runnable_avg;
-	u32 divider;
+	long delta_sum, delta_avg = gcfs_rq->avg.runnable_avg - se->avg.runnable_avg;
+	u32 new_sum, divider;
 
 	/* Nothing to update */
-	if (!delta)
+	if (!delta_avg)
 		return;
 
 	/*
@@ -3534,11 +3534,16 @@ update_tg_cfs_runnable(struct cfs_rq *cfs_rq, struct sched_entity *se, struct cf
 
 	/* Set new sched_entity's runnable */
 	se->avg.runnable_avg = gcfs_rq->avg.runnable_avg;
-	se->avg.runnable_sum = se->avg.runnable_avg * divider;
+	new_sum = se->avg.runnable_avg * divider;
+	delta_sum = (long)new_sum - (long)se->avg.runnable_sum;
+	se->avg.runnable_sum = new_sum;
 
 	/* Update parent cfs_rq runnable */
-	add_positive(&cfs_rq->avg.runnable_avg, delta);
-	cfs_rq->avg.runnable_sum = cfs_rq->avg.runnable_avg * divider;
+	add_positive(&cfs_rq->avg.runnable_avg, delta_avg);
+	add_positive(&cfs_rq->avg.runnable_sum, delta_sum);
+	/* See update_cfs_rq_load_avg() */
+	cfs_rq->avg.runnable_sum = max_t(u32, cfs_rq->avg.runnable_sum,
+					      cfs_rq->avg.runnable_avg * PELT_MIN_DIVIDER);
 }
 
 static inline void
@@ -3726,7 +3731,10 @@ update_cfs_rq_load_avg(u64 now, struct cfs_rq *cfs_rq)
 
 		r = removed_runnable;
 		sub_positive(&sa->runnable_avg, r);
-		sa->runnable_sum = sa->runnable_avg * divider;
+		sub_positive(&sa->runnable_sum, r * divider);
+		/* See sa->util_sum above */
+		sa->runnable_sum = max_t(u32, sa->runnable_sum,
+					      sa->runnable_avg * PELT_MIN_DIVIDER);
 
 		/*
 		 * removed_runnable is the unweighted version of removed_load so we
@@ -3813,17 +3821,14 @@ static void attach_entity_load_avg(struct cfs_rq *cfs_rq, struct sched_entity *s
  */
 static void detach_entity_load_avg(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
-	/*
-	 * cfs_rq->avg.period_contrib can be used for both cfs_rq and se.
-	 * See ___update_load_avg() for details.
-	 */
-	u32 divider = get_pelt_divider(&cfs_rq->avg);
-
 	dequeue_load_avg(cfs_rq, se);
 	sub_positive(&cfs_rq->avg.util_avg, se->avg.util_avg);
 	cfs_rq->avg.util_sum = cfs_rq->avg.util_avg * divider;
 	sub_positive(&cfs_rq->avg.runnable_avg, se->avg.runnable_avg);
-	cfs_rq->avg.runnable_sum = cfs_rq->avg.runnable_avg * divider;
+	sub_positive(&cfs_rq->avg.runnable_sum, se->avg.runnable_sum);
+	/* See update_cfs_rq_load_avg() */
+	cfs_rq->avg.runnable_sum = max_t(u32, cfs_rq->avg.runnable_sum,
+					      cfs_rq->avg.runnable_avg * PELT_MIN_DIVIDER);
 
 	add_tg_cfs_propagate(cfs_rq, -se->avg.load_sum);
 
-- 
2.34.1

