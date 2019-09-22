Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1A12BAAA6
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728503AbfIVT3A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 15:29:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:47464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403892AbfIVSuZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:50:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3CDE821D56;
        Sun, 22 Sep 2019 18:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178224;
        bh=+CA5L4S3WYxaDcnM1a3Gx9G8CDCvEp1++Jy1THK8e4k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FU0ehTAF51AR3SBRjMElSAuLj7B2yCO5Tn7j4LQPANJ60Kl0gkAbCTT6PyA6iLqH9
         XKOHfYepoRvF0YAd7PXYCyb7wdQ3aPpufM48ziJRoWb1hcKtiV6GWqE0X+DcFfN0Ci
         Dkq8VcF+p6mXgkamVWuknVMRnFtMlU/hwcqNneH0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Juri Lelli <juri.lelli@redhat.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, bristot@redhat.com,
        claudio@evidence.eu.com, lizefan@huawei.com, longman@redhat.com,
        luca.abeni@santannapisa.it, mathieu.poirier@linaro.org,
        rostedt@goodmis.org, tj@kernel.org,
        tommaso.cucinotta@santannapisa.it, Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 025/185] sched/deadline: Fix bandwidth accounting at all levels after offline migration
Date:   Sun, 22 Sep 2019 14:46:43 -0400
Message-Id: <20190922184924.32534-25-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184924.32534-1-sashal@kernel.org>
References: <20190922184924.32534-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juri Lelli <juri.lelli@redhat.com>

[ Upstream commit 59d06cea1198d665ba11f7e8c5f45b00ff2e4812 ]

If a task happens to be throttled while the CPU it was running on gets
hotplugged off, the bandwidth associated with the task is not correctly
migrated with it when the replenishment timer fires (offline_migration).

Fix things up, for this_bw, running_bw and total_bw, when replenishment
timer fires and task is migrated (dl_task_offline_migration()).

Tested-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Signed-off-by: Juri Lelli <juri.lelli@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: bristot@redhat.com
Cc: claudio@evidence.eu.com
Cc: lizefan@huawei.com
Cc: longman@redhat.com
Cc: luca.abeni@santannapisa.it
Cc: mathieu.poirier@linaro.org
Cc: rostedt@goodmis.org
Cc: tj@kernel.org
Cc: tommaso.cucinotta@santannapisa.it
Link: https://lkml.kernel.org/r/20190719140000.31694-5-juri.lelli@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/deadline.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 1c66480afda81..fcdafdcb129cc 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -529,6 +529,7 @@ static struct rq *find_lock_later_rq(struct task_struct *task, struct rq *rq);
 static struct rq *dl_task_offline_migration(struct rq *rq, struct task_struct *p)
 {
 	struct rq *later_rq = NULL;
+	struct dl_bw *dl_b;
 
 	later_rq = find_lock_later_rq(p, rq);
 	if (!later_rq) {
@@ -557,6 +558,38 @@ static struct rq *dl_task_offline_migration(struct rq *rq, struct task_struct *p
 		double_lock_balance(rq, later_rq);
 	}
 
+	if (p->dl.dl_non_contending || p->dl.dl_throttled) {
+		/*
+		 * Inactive timer is armed (or callback is running, but
+		 * waiting for us to release rq locks). In any case, when it
+		 * will fire (or continue), it will see running_bw of this
+		 * task migrated to later_rq (and correctly handle it).
+		 */
+		sub_running_bw(&p->dl, &rq->dl);
+		sub_rq_bw(&p->dl, &rq->dl);
+
+		add_rq_bw(&p->dl, &later_rq->dl);
+		add_running_bw(&p->dl, &later_rq->dl);
+	} else {
+		sub_rq_bw(&p->dl, &rq->dl);
+		add_rq_bw(&p->dl, &later_rq->dl);
+	}
+
+	/*
+	 * And we finally need to fixup root_domain(s) bandwidth accounting,
+	 * since p is still hanging out in the old (now moved to default) root
+	 * domain.
+	 */
+	dl_b = &rq->rd->dl_bw;
+	raw_spin_lock(&dl_b->lock);
+	__dl_sub(dl_b, p->dl.dl_bw, cpumask_weight(rq->rd->span));
+	raw_spin_unlock(&dl_b->lock);
+
+	dl_b = &later_rq->rd->dl_bw;
+	raw_spin_lock(&dl_b->lock);
+	__dl_add(dl_b, p->dl.dl_bw, cpumask_weight(later_rq->rd->span));
+	raw_spin_unlock(&dl_b->lock);
+
 	set_task_cpu(p, later_rq->cpu);
 	double_unlock_balance(later_rq, rq);
 
-- 
2.20.1

