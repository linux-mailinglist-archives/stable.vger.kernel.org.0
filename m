Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 615D8498BA8
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:15:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230297AbiAXTPl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:15:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344886AbiAXTNQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:13:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8DE5C0604EE;
        Mon, 24 Jan 2022 11:04:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A4AE3B8122F;
        Mon, 24 Jan 2022 19:04:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7AA8C340E5;
        Mon, 24 Jan 2022 19:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051094;
        bh=Itpp8NO44b1xZ6LMPWzH1bUZjsSx4L43K2IPFVftaNI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HImC4TNR9rX1ohiXf+RZAtbk/S6aQsCFThiAgfQN8qFcmQk6vnACak4phK069is9o
         Z6gHuIicRvMnonlUI0679jsgpvWts7OSZ4siV8pUOFCsJzBjyEoiomk5gf5f7crdbr
         Y56pF7UZJfsQeMnj/2kQJbXwDzmnDd3aZIiwQgjI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Li Hua <hucool.lihua@huawei.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 053/186] sched/rt: Try to restart rt period timer when rt runtime exceeded
Date:   Mon, 24 Jan 2022 19:42:08 +0100
Message-Id: <20220124183938.834983282@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183937.101330125@linuxfoundation.org>
References: <20220124183937.101330125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Hua <hucool.lihua@huawei.com>

[ Upstream commit 9b58e976b3b391c0cf02e038d53dd0478ed3013c ]

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

Fixes: d0b27fa77854 ("sched: rt-group: synchonised bandwidth period")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Li Hua <hucool.lihua@huawei.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20211203033618.11895-1-hucool.lihua@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/rt.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index cc7dd1aaf08e3..c093bb0f52eb1 100644
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
@@ -74,6 +71,14 @@ static void start_rt_bandwidth(struct rt_bandwidth *rt_b)
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
@@ -982,13 +987,17 @@ static void update_curr_rt(struct rq *rq)
 
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
@@ -2629,8 +2638,12 @@ static int sched_rt_global_validate(void)
 
 static void sched_rt_do_global(void)
 {
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&def_rt_bandwidth.rt_runtime_lock, flags);
 	def_rt_bandwidth.rt_runtime = global_rt_runtime();
 	def_rt_bandwidth.rt_period = ns_to_ktime(global_rt_period());
+	raw_spin_unlock_irqrestore(&def_rt_bandwidth.rt_runtime_lock, flags);
 }
 
 int sched_rt_handler(struct ctl_table *table, int write,
-- 
2.34.1



