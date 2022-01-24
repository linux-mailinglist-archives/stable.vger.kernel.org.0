Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DC1B49A267
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 02:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2365723AbiAXXve (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:51:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382903AbiAXWlx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:41:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80346C06B5A5;
        Mon, 24 Jan 2022 13:05:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F14F61361;
        Mon, 24 Jan 2022 21:05:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE3F6C340E5;
        Mon, 24 Jan 2022 21:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058321;
        bh=0XhSti58rGg1bd0mP0ZghW2OZEV0aA4SSU2tDfHBNT0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0F+c4s/vGI8G2t5kEwm4cnjjC8Y5EVV+h7JblogqYCYiwt8xSHgFJgwHCZ7UgSMk1
         L4iBVcKxkFJNufWPEotN5mkTiQ84JV4zHhwOAXQu9n3bQDQAdGZPT8Iis+l8xCrwln
         DqpWnQs2ozNgLpf+c8NWx0DGZ6+sfsGHuVDnV4gw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Li Hua <hucool.lihua@huawei.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0251/1039] sched/rt: Try to restart rt period timer when rt runtime exceeded
Date:   Mon, 24 Jan 2022 19:34:00 +0100
Message-Id: <20220124184133.766926257@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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
index b48baaba2fc2e..7b4f4fbbb4048 100644
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
2.34.1



