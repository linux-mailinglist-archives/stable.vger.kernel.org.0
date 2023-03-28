Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4639D6CC398
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233523AbjC1Ozd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:55:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233537AbjC1Ozc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:55:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CDBDDBDB
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:55:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15D27B81D68
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:55:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EF92C4339B;
        Tue, 28 Mar 2023 14:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015322;
        bh=GJmuaaJ/ED0Dz0sbfG/ou0yIOCIt+LNeQoiPXsOdICg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C14bIffyNdDnkjMJ27AIBJaq+hAE6Sy001B8kZ0dFR5LkipdiArkoCFACJMCXFTM/
         +cAh+fSnQQYJ6oiM0YmW0NL4w4CcTtGnOL41dRRuJtN0kVwex4FO6+7+gPoDzVTvUF
         ws1NFHQbqoMhhbEGzqZCU4wMFKF5l+yi8+HWTPzA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Vincent Guittot <vincent.guittot@linaro.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Zhang Qiao <zhangqiao22@huawei.com>
Subject: [PATCH 6.2 240/240] sched/fair: Sanitize vruntime of entity being migrated
Date:   Tue, 28 Mar 2023 16:43:23 +0200
Message-Id: <20230328142629.701480541@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Guittot <vincent.guittot@linaro.org>

commit a53ce18cacb477dd0513c607f187d16f0fa96f71 upstream.

Commit 829c1651e9c4 ("sched/fair: sanitize vruntime of entity being placed")
fixes an overflowing bug, but ignore a case that se->exec_start is reset
after a migration.

For fixing this case, we delay the reset of se->exec_start after
placing the entity which se->exec_start to detect long sleeping task.

In order to take into account a possible divergence between the clock_task
of 2 rqs, we increase the threshold to around 104 days.

Fixes: 829c1651e9c4 ("sched/fair: sanitize vruntime of entity being placed")
Originally-by: Zhang Qiao <zhangqiao22@huawei.com>
Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Zhang Qiao <zhangqiao22@huawei.com>
Link: https://lore.kernel.org/r/20230317160810.107988-1-vincent.guittot@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/core.c |    3 ++
 kernel/sched/fair.c |   53 ++++++++++++++++++++++++++++++++++++++++++----------
 2 files changed, 46 insertions(+), 10 deletions(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2082,6 +2082,9 @@ static inline void dequeue_task(struct r
 
 void activate_task(struct rq *rq, struct task_struct *p, int flags)
 {
+	if (task_on_rq_migrating(p))
+		flags |= ENQUEUE_MIGRATED;
+
 	enqueue_task(rq, p, flags);
 
 	p->on_rq = TASK_ON_RQ_QUEUED;
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4652,11 +4652,33 @@ static void check_spread(struct cfs_rq *
 #endif
 }
 
+static inline bool entity_is_long_sleeper(struct sched_entity *se)
+{
+	struct cfs_rq *cfs_rq;
+	u64 sleep_time;
+
+	if (se->exec_start == 0)
+		return false;
+
+	cfs_rq = cfs_rq_of(se);
+
+	sleep_time = rq_clock_task(rq_of(cfs_rq));
+
+	/* Happen while migrating because of clock task divergence */
+	if (sleep_time <= se->exec_start)
+		return false;
+
+	sleep_time -= se->exec_start;
+	if (sleep_time > ((1ULL << 63) / scale_load_down(NICE_0_LOAD)))
+		return true;
+
+	return false;
+}
+
 static void
 place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
 {
 	u64 vruntime = cfs_rq->min_vruntime;
-	u64 sleep_time;
 
 	/*
 	 * The 'current' period is already promised to the current tasks,
@@ -4688,13 +4710,24 @@ place_entity(struct cfs_rq *cfs_rq, stru
 
 	/*
 	 * Pull vruntime of the entity being placed to the base level of
-	 * cfs_rq, to prevent boosting it if placed backwards.  If the entity
-	 * slept for a long time, don't even try to compare its vruntime with
-	 * the base as it may be too far off and the comparison may get
-	 * inversed due to s64 overflow.
+	 * cfs_rq, to prevent boosting it if placed backwards.
+	 * However, min_vruntime can advance much faster than real time, with
+	 * the extreme being when an entity with the minimal weight always runs
+	 * on the cfs_rq. If the waking entity slept for a long time, its
+	 * vruntime difference from min_vruntime may overflow s64 and their
+	 * comparison may get inversed, so ignore the entity's original
+	 * vruntime in that case.
+	 * The maximal vruntime speedup is given by the ratio of normal to
+	 * minimal weight: scale_load_down(NICE_0_LOAD) / MIN_SHARES.
+	 * When placing a migrated waking entity, its exec_start has been set
+	 * from a different rq. In order to take into account a possible
+	 * divergence between new and prev rq's clocks task because of irq and
+	 * stolen time, we take an additional margin.
+	 * So, cutting off on the sleep time of
+	 *     2^63 / scale_load_down(NICE_0_LOAD) ~ 104 days
+	 * should be safe.
 	 */
-	sleep_time = rq_clock_task(rq_of(cfs_rq)) - se->exec_start;
-	if ((s64)sleep_time > 60LL * NSEC_PER_SEC)
+	if (entity_is_long_sleeper(se))
 		se->vruntime = vruntime;
 	else
 		se->vruntime = max_vruntime(se->vruntime, vruntime);
@@ -4774,6 +4807,9 @@ enqueue_entity(struct cfs_rq *cfs_rq, st
 
 	if (flags & ENQUEUE_WAKEUP)
 		place_entity(cfs_rq, se, 0);
+	/* Entity has migrated, no longer consider this task hot */
+	if (flags & ENQUEUE_MIGRATED)
+		se->exec_start = 0;
 
 	check_schedstat_required();
 	update_stats_enqueue_fair(cfs_rq, se, flags);
@@ -7476,9 +7512,6 @@ static void migrate_task_rq_fair(struct
 	/* Tell new CPU we are migrated */
 	se->avg.last_update_time = 0;
 
-	/* We have migrated, no longer consider this task hot */
-	se->exec_start = 0;
-
 	update_scan_period(p, new_cpu);
 }
 


