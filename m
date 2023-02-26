Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CBF76A2DCF
	for <lists+stable@lfdr.de>; Sun, 26 Feb 2023 04:46:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbjBZDq3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Feb 2023 22:46:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbjBZDqI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Feb 2023 22:46:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06E9718174;
        Sat, 25 Feb 2023 19:45:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED7B760BE9;
        Sun, 26 Feb 2023 03:44:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ED01C4339B;
        Sun, 26 Feb 2023 03:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677383056;
        bh=cjwEOnzBjeN7oLDg7qAnbEAnbRdzHKHGwWDhPiqSgUg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BvU3hEhc1i2KkQAzYR8EsEyFsGA8K11UyOKCSBeINxcWQfLufr4+fOIT7SYQQ28AU
         IBxoIp8iZv8aXPcLRhpl1Gygqaqq2Abb97iPrkol6DKqqCD72O+xTn3zgRkyNwrPtF
         Iqd+181sWYyXPPPzSFdVYJ0OEEMDYcW18jwYKoBzHxzrOyuu3XKkztHOIvTloOvbZq
         Ps9SNvkZPRsZb7Y/gENl2mx9Q6b/VJRPqZ5hcSclfwQd0xkKAY7nyMcn8H0JACPx+j
         S5xuNooORbG4VZ8hH7P1yT+phwPrn0hH6JDlHCpmFCTjZ64vsVEH4S2/J9+AvDyZHc
         74J4azTm7eI7A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhang Qiao <zhangqiao22@huawei.com>,
        Roman Kagan <rkagan@amazon.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>, mingo@redhat.com,
        juri.lelli@redhat.com, vincent.guittot@linaro.org
Subject: [PATCH AUTOSEL 5.10 5/5] sched/fair: sanitize vruntime of entity being placed
Date:   Sat, 25 Feb 2023 22:44:08 -0500
Message-Id: <20230226034408.774670-5-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230226034408.774670-1-sashal@kernel.org>
References: <20230226034408.774670-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qiao <zhangqiao22@huawei.com>

[ Upstream commit 829c1651e9c4a6f78398d3e67651cef9bb6b42cc ]

When a scheduling entity is placed onto cfs_rq, its vruntime is pulled
to the base level (around cfs_rq->min_vruntime), so that the entity
doesn't gain extra boost when placed backwards.

However, if the entity being placed wasn't executed for a long time, its
vruntime may get too far behind (e.g. while cfs_rq was executing a
low-weight hog), which can inverse the vruntime comparison due to s64
overflow.  This results in the entity being placed with its original
vruntime way forwards, so that it will effectively never get to the cpu.

To prevent that, ignore the vruntime of the entity being placed if it
didn't execute for much longer than the characteristic sheduler time
scale.

[rkagan: formatted, adjusted commit log, comments, cutoff value]
Signed-off-by: Zhang Qiao <zhangqiao22@huawei.com>
Co-developed-by: Roman Kagan <rkagan@amazon.de>
Signed-off-by: Roman Kagan <rkagan@amazon.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20230130122216.3555094-1-rkagan@amazon.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c39d2fc3f9945..68166c599a355 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4278,6 +4278,7 @@ static void
 place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
 {
 	u64 vruntime = cfs_rq->min_vruntime;
+	u64 sleep_time;
 
 	/*
 	 * The 'current' period is already promised to the current tasks,
@@ -4302,8 +4303,18 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
 		vruntime -= thresh;
 	}
 
-	/* ensure we never gain time by being placed backwards. */
-	se->vruntime = max_vruntime(se->vruntime, vruntime);
+	/*
+	 * Pull vruntime of the entity being placed to the base level of
+	 * cfs_rq, to prevent boosting it if placed backwards.  If the entity
+	 * slept for a long time, don't even try to compare its vruntime with
+	 * the base as it may be too far off and the comparison may get
+	 * inversed due to s64 overflow.
+	 */
+	sleep_time = rq_clock_task(rq_of(cfs_rq)) - se->exec_start;
+	if ((s64)sleep_time > 60LL * NSEC_PER_SEC)
+		se->vruntime = vruntime;
+	else
+		se->vruntime = max_vruntime(se->vruntime, vruntime);
 }
 
 static void check_enqueue_throttle(struct cfs_rq *cfs_rq);
-- 
2.39.0

