Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 184DB2EFD0B
	for <lists+stable@lfdr.de>; Sat,  9 Jan 2021 03:09:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726771AbhAICHF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jan 2021 21:07:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:41578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725916AbhAICHE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Jan 2021 21:07:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 765BD23AC0;
        Sat,  9 Jan 2021 02:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610157955;
        bh=IV3Fs0Tk44Jn/JKmGxOFZ56+bWFBTn/p6qGPe5NQbU0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uZt+mIZCXCyB4A5z7v/wHBhDSeAecI+Zk0qMUEmwOzSFTeH5LykuoWLhyLcjJY6fc
         3PeKwVK5wGFLGoyBni84W7zlCifL8EHHr3qqUzZr6wmQ3Mm6h064lICfkHwJTD/hCm
         6kmyOjcd5YHHGPSkGuwYdi0rtWBRqisKmy6DONhQu9yhxcNdZSXg9GE3wurIRWQLy5
         67kWIroDOCgbLXUDvJPWlpx0Du6oQuTTKZtNkk5jZXKqIp0zfdd3bhzYvYUvlWrGAs
         2JLgadTjAhxIMI75PIeAfrtZivOyNDbEE9940i7heJxjOkL4/zyDUfv23um+ipCYjr
         Ro8JCbPpZ/Iig==
From:   Frederic Weisbecker <frederic@kernel.org>
To:     Peter Zijlstra <peterz@infradead.org>,
        "Paul E . McKenney" <paulmck@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org
Subject: [RFC PATCH 6/8] sched: Report local wake up on resched blind zone within idle loop
Date:   Sat,  9 Jan 2021 03:05:34 +0100
Message-Id: <20210109020536.127953-7-frederic@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210109020536.127953-1-frederic@kernel.org>
References: <20210109020536.127953-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The idle loop has several need_resched() checks that make sure we don't
miss a rescheduling request. This means that any wake up performed on
the local runqueue after the last generic need_resched() check is going
to have its rescheduling silently ignored. This has happened in the
past with rcu kthreads awaken from rcu_idle_enter() for example.

Perform sanity checks to report these situations.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar<mingo@kernel.org>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 include/linux/sched.h | 11 +++++++++++
 kernel/sched/core.c   | 42 ++++++++++++++++++++++++++++++++++++++++++
 kernel/sched/idle.c   |  3 +++
 kernel/sched/sched.h  |  3 +++
 4 files changed, 59 insertions(+)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 6e3a5eeec509..83fedda54943 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1917,6 +1917,17 @@ static __always_inline bool need_resched(void)
 	return unlikely(tif_need_resched());
 }
 
+#ifdef CONFIG_SCHED_DEBUG
+extern void sched_resched_local_allow(void);
+extern void sched_resched_local_forbid(void);
+extern void sched_resched_local_assert_allowed(void);
+#else
+static inline void sched_resched_local_allow(void) { }
+static inline void sched_resched_local_forbid(void) { }
+static inline void sched_resched_local_assert_allowed(void) { }
+#endif
+
+
 /*
  * Wrappers for p->thread_info->cpu access. No-op on UP.
  */
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 15d2562118d1..6056f0374674 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -591,6 +591,44 @@ void wake_up_q(struct wake_q_head *head)
 	}
 }
 
+#ifdef CONFIG_SCHED_DEBUG
+void noinstr sched_resched_local_allow(void)
+{
+	this_rq()->resched_local_allow = 1;
+}
+
+void noinstr sched_resched_local_forbid(void)
+{
+	this_rq()->resched_local_allow = 0;
+}
+
+void noinstr sched_resched_local_assert_allowed(void)
+{
+	if (this_rq()->resched_local_allow)
+		return;
+
+	/*
+	 * Idle interrupts break the CPU from its pause and
+	 * rescheduling happens on idle loop exit.
+	 */
+	if (in_hardirq())
+		return;
+
+	/*
+	 * What applies to hardirq also applies to softirq as
+	 * we assume they execute on hardirq tail. Ksoftirqd
+	 * shouldn't have resched_local_allow == 0.
+	 * We also assume that no local_bh_enable() call may
+	 * execute softirqs inline on fragile idle/entry
+	 * path...
+	 */
+	if (in_serving_softirq())
+		return;
+
+	WARN_ONCE(1, "Late current task rescheduling may be lost\n");
+}
+#endif
+
 /*
  * resched_curr - mark rq's current task 'to be rescheduled now'.
  *
@@ -613,6 +651,7 @@ void resched_curr(struct rq *rq)
 	if (cpu == smp_processor_id()) {
 		set_tsk_need_resched(curr);
 		set_preempt_need_resched();
+		sched_resched_local_assert_allowed();
 		return;
 	}
 
@@ -7796,6 +7835,9 @@ void __init sched_init(void)
 #endif /* CONFIG_SMP */
 		hrtick_rq_init(rq);
 		atomic_set(&rq->nr_iowait, 0);
+#ifdef CONFIG_SCHED_DEBUG
+		rq->resched_local_allow = 1;
+#endif
 	}
 
 	set_load_weight(&init_task, false);
diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
index b601a3aa2152..cdffd32812bd 100644
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -185,6 +185,8 @@ static void cpuidle_idle_call(void)
 		return;
 	}
 
+	sched_resched_local_forbid();
+
 	/*
 	 * The RCU framework needs to be told that we are entering an idle
 	 * section, so no more rcu read side critical sections and one more
@@ -247,6 +249,7 @@ static void cpuidle_idle_call(void)
 	}
 
 exit_idle:
+	sched_resched_local_allow();
 	__current_set_polling();
 
 	/*
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 12ada79d40f3..a9416c383451 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1060,6 +1060,9 @@ struct rq {
 #endif
 	unsigned int		push_busy;
 	struct cpu_stop_work	push_work;
+#ifdef CONFIG_SCHED_DEBUG
+	unsigned int		resched_local_allow;
+#endif
 };
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
-- 
2.25.1

