Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D6DD2E6617
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:10:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388855AbgL1QIo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:08:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:53842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388867AbgL1NZM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:25:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6635E207CF;
        Mon, 28 Dec 2020 13:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161871;
        bh=hnbIANBvFnDsoYqHpijpVuK87AxUj5SjnX6pB32gcv8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mjqbA9E+sv7vXjJz2A9J6zMW+k7ygh/HB3tzBfdXuZJffEAFDaQG5twXrvOPu42Rs
         v7isdK6AujXTZ21LOkpYgIIKj6kW/u5k9ZOvX80mvhDXoIo473+ZKRcY8jHA7OO46F
         +8rwfH/3W3hKhbgb8wmbqXFhNDmLjgkfrmapkBHA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Liu <iwtbavbm@gmail.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 110/346] sched/deadline: Fix sched_dl_global_validate()
Date:   Mon, 28 Dec 2020 13:47:09 +0100
Message-Id: <20201228124925.104644630@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peng Liu <iwtbavbm@gmail.com>

[ Upstream commit a57415f5d1e43c3a5c5d412cd85e2792d7ed9b11 ]

When change sched_rt_{runtime, period}_us, we validate that the new
settings should at least accommodate the currently allocated -dl
bandwidth:

  sched_rt_handler()
    -->	sched_dl_bandwidth_validate()
	{
		new_bw = global_rt_runtime()/global_rt_period();

		for_each_possible_cpu(cpu) {
			dl_b = dl_bw_of(cpu);
			if (new_bw < dl_b->total_bw)    <-------
				ret = -EBUSY;
		}
	}

But under CONFIG_SMP, dl_bw is per root domain , but not per CPU,
dl_b->total_bw is the allocated bandwidth of the whole root domain.
Instead, we should compare dl_b->total_bw against "cpus*new_bw",
where 'cpus' is the number of CPUs of the root domain.

Also, below annotation(in kernel/sched/sched.h) implied implementation
only appeared in SCHED_DEADLINE v2[1], then deadline scheduler kept
evolving till got merged(v9), but the annotation remains unchanged,
meaningless and misleading, update it.

* With respect to SMP, the bandwidth is given on a per-CPU basis,
* meaning that:
*  - dl_bw (< 100%) is the bandwidth of the system (group) on each CPU;
*  - dl_total_bw array contains, in the i-eth element, the currently
*    allocated bandwidth on the i-eth CPU.

[1]: https://lore.kernel.org/lkml/1267385230.13676.101.camel@Palantir/

Fixes: 332ac17ef5bf ("sched/deadline: Add bandwidth management for SCHED_DEADLINE tasks")
Signed-off-by: Peng Liu <iwtbavbm@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Daniel Bristot de Oliveira <bristot@redhat.com>
Acked-by: Juri Lelli <juri.lelli@redhat.com>
Link: https://lkml.kernel.org/r/db6bbda316048cda7a1bbc9571defde193a8d67e.1602171061.git.iwtbavbm@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/deadline.c |  5 +++--
 kernel/sched/sched.h    | 42 ++++++++++++++++++-----------------------
 2 files changed, 21 insertions(+), 26 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 8aecfb143859d..aa592dc3cb401 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -2464,7 +2464,7 @@ int sched_dl_global_validate(void)
 	u64 period = global_rt_period();
 	u64 new_bw = to_ratio(period, runtime);
 	struct dl_bw *dl_b;
-	int cpu, ret = 0;
+	int cpu, cpus, ret = 0;
 	unsigned long flags;
 
 	/*
@@ -2479,9 +2479,10 @@ int sched_dl_global_validate(void)
 	for_each_possible_cpu(cpu) {
 		rcu_read_lock_sched();
 		dl_b = dl_bw_of(cpu);
+		cpus = dl_bw_cpus(cpu);
 
 		raw_spin_lock_irqsave(&dl_b->lock, flags);
-		if (new_bw < dl_b->total_bw)
+		if (new_bw * cpus < dl_b->total_bw)
 			ret = -EBUSY;
 		raw_spin_unlock_irqrestore(&dl_b->lock, flags);
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 41b7954be68b7..7b7ba91e319bb 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -247,30 +247,6 @@ struct rt_bandwidth {
 
 void __dl_clear_params(struct task_struct *p);
 
-/*
- * To keep the bandwidth of -deadline tasks and groups under control
- * we need some place where:
- *  - store the maximum -deadline bandwidth of the system (the group);
- *  - cache the fraction of that bandwidth that is currently allocated.
- *
- * This is all done in the data structure below. It is similar to the
- * one used for RT-throttling (rt_bandwidth), with the main difference
- * that, since here we are only interested in admission control, we
- * do not decrease any runtime while the group "executes", neither we
- * need a timer to replenish it.
- *
- * With respect to SMP, the bandwidth is given on a per-CPU basis,
- * meaning that:
- *  - dl_bw (< 100%) is the bandwidth of the system (group) on each CPU;
- *  - dl_total_bw array contains, in the i-eth element, the currently
- *    allocated bandwidth on the i-eth CPU.
- * Moreover, groups consume bandwidth on each CPU, while tasks only
- * consume bandwidth on the CPU they're running on.
- * Finally, dl_total_bw_cpu is used to cache the index of dl_total_bw
- * that will be shown the next time the proc or cgroup controls will
- * be red. It on its turn can be changed by writing on its own
- * control.
- */
 struct dl_bandwidth {
 	raw_spinlock_t		dl_runtime_lock;
 	u64			dl_runtime;
@@ -282,6 +258,24 @@ static inline int dl_bandwidth_enabled(void)
 	return sysctl_sched_rt_runtime >= 0;
 }
 
+/*
+ * To keep the bandwidth of -deadline tasks under control
+ * we need some place where:
+ *  - store the maximum -deadline bandwidth of each cpu;
+ *  - cache the fraction of bandwidth that is currently allocated in
+ *    each root domain;
+ *
+ * This is all done in the data structure below. It is similar to the
+ * one used for RT-throttling (rt_bandwidth), with the main difference
+ * that, since here we are only interested in admission control, we
+ * do not decrease any runtime while the group "executes", neither we
+ * need a timer to replenish it.
+ *
+ * With respect to SMP, bandwidth is given on a per root domain basis,
+ * meaning that:
+ *  - bw (< 100%) is the deadline bandwidth of each CPU;
+ *  - total_bw is the currently allocated bandwidth in each root domain;
+ */
 struct dl_bw {
 	raw_spinlock_t		lock;
 	u64			bw;
-- 
2.27.0



