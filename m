Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0508246709E
	for <lists+stable@lfdr.de>; Fri,  3 Dec 2021 04:17:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236569AbhLCDVI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Dec 2021 22:21:08 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:27337 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231585AbhLCDVI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Dec 2021 22:21:08 -0500
Received: from dggeml756-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4J4ygK4jvtzbjK4;
        Fri,  3 Dec 2021 11:17:33 +0800 (CST)
Received: from huawei.com (10.67.174.191) by dggeml756-chm.china.huawei.com
 (10.1.199.158) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.20; Fri, 3
 Dec 2021 11:17:42 +0800
From:   Li Hua <hucool.lihua@huawei.com>
To:     Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>
CC:     Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        <linux-kernel@vger.kernel.org>, <hucool.lihua@huawei.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v2, RESEND] sched/rt: Try to restart rt period timer when rt runtime exceeded
Date:   Fri, 3 Dec 2021 03:36:18 +0000
Message-ID: <20211203033618.11895-1-hucool.lihua@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.174.191]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggeml756-chm.china.huawei.com (10.1.199.158)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When rt_runtime is modified from -1 to a valid control value, it may
cause the task to be throttled all the time. Operations like the following
will trigger the bug. E.g:
1. echo -1 > /proc/sys/kernel/sched_rt_runtime_us
2. Run a FIFO task named A that executes while(1)
3. echo 950000 > /proc/sys/kernel/sched_rt_runtime_us

When rt_runtime is -1, The rt period timer will not be activated when task
A enqueued. And then the task will be throttled after setting rt_runtime to
950,000. The task will always be throttled because the rt period timer is
not activated.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Li Hua <hucool.lihua@huawei.com>
---
v1->v2:
  - call do_start_rt_bandwidth to reduce repetitive code.
  - use raw_spin_lock_irqsave to avoid deadlock on a timer context.
---
 kernel/sched/rt.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index b48baaba2fc2..7b4f4fbbb404 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -52,11 +52,8 @@ void init_rt_bandwidth(struct rt_bandwidth *rt_b, u64 period, u64 runtime)
 	rt_b->rt_period_timer.function = sched_rt_period_timer;
 }
 
-static void start_rt_bandwidth(struct rt_bandwidth *rt_b)
+static inline void do_start_rt_bandwidth(struct rt_bandwidth *rt_b)
 {
-	if (!rt_bandwidth_enabled() || rt_b->rt_runtime == RUNTIME_INF)
-		return;
-
 	raw_spin_lock(&rt_b->rt_runtime_lock);
 	if (!rt_b->rt_period_active) {
 		rt_b->rt_period_active = 1;
@@ -75,6 +72,14 @@ static void start_rt_bandwidth(struct rt_bandwidth *rt_b)
 	raw_spin_unlock(&rt_b->rt_runtime_lock);
 }
 
+static void start_rt_bandwidth(struct rt_bandwidth *rt_b)
+{
+	if (!rt_bandwidth_enabled() || rt_b->rt_runtime == RUNTIME_INF)
+		return;
+
+	do_start_rt_bandwidth(rt_b);
+}
+
 void init_rt_rq(struct rt_rq *rt_rq)
 {
 	struct rt_prio_array *array;
@@ -1031,13 +1036,17 @@ static void update_curr_rt(struct rq *rq)
 
 	for_each_sched_rt_entity(rt_se) {
 		struct rt_rq *rt_rq = rt_rq_of_se(rt_se);
+		int exceeded;
 
 		if (sched_rt_runtime(rt_rq) != RUNTIME_INF) {
 			raw_spin_lock(&rt_rq->rt_runtime_lock);
 			rt_rq->rt_time += delta_exec;
-			if (sched_rt_runtime_exceeded(rt_rq))
+			exceeded = sched_rt_runtime_exceeded(rt_rq);
+			if (exceeded)
 				resched_curr(rq);
 			raw_spin_unlock(&rt_rq->rt_runtime_lock);
+			if (exceeded)
+				do_start_rt_bandwidth(sched_rt_bandwidth(rt_rq));
 		}
 	}
 }
@@ -2911,8 +2920,12 @@ static int sched_rt_global_validate(void)
 
 static void sched_rt_do_global(void)
 {
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&def_rt_bandwidth.rt_runtime_lock, flags);
 	def_rt_bandwidth.rt_runtime = global_rt_runtime();
 	def_rt_bandwidth.rt_period = ns_to_ktime(global_rt_period());
+	raw_spin_unlock_irqrestore(&def_rt_bandwidth.rt_runtime_lock, flags);
 }
 
 int sched_rt_handler(struct ctl_table *table, int write, void *buffer,
-- 
2.17.1

