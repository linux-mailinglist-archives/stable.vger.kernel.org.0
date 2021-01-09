Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D0DF2EFD0D
	for <lists+stable@lfdr.de>; Sat,  9 Jan 2021 03:09:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbhAICHG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jan 2021 21:07:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:41604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726784AbhAICHF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Jan 2021 21:07:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C860623AC4;
        Sat,  9 Jan 2021 02:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610157959;
        bh=FruuVTRbSSmFOTUvQqJ2CO8k/I1uHvJl6EZqrve6RFA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aC10n/IUNawtRE92wVvr68B5rdZLVdR1L9PuWxnwZZX0xx6GiyVTgOYMHLuBy/AgL
         dx1mlRuQNDmkbd6skznXFvrMqcVdxv0kfgYVHH/W4GJLj3Zqi0cScFpp9CGIqCHzg+
         eFeuSiDBn8HzP70aCllSyE+vHIkTBHdLqpGRkAhEXiw/ymu6rwKuYAOJ7pzvx0lcn8
         3vou37KCqPlnHItNHWHmf/d4amypl7lWKqrG5B7gKnZtoTC/ulcKka3xfs9CI6FW0m
         0YvL0YkudWdWw7wRbSKzRhI2YzhP1j4ooFLaLEeshcP/LSKh8zmsrj1lJiv5gODKpZ
         PMUB00CHuXEdg==
From:   Frederic Weisbecker <frederic@kernel.org>
To:     Peter Zijlstra <peterz@infradead.org>,
        "Paul E . McKenney" <paulmck@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org
Subject: [RFC PATCH 8/8] timer: Report ignored local enqueue in nohz mode
Date:   Sat,  9 Jan 2021 03:05:36 +0100
Message-Id: <20210109020536.127953-9-frederic@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210109020536.127953-1-frederic@kernel.org>
References: <20210109020536.127953-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Enqueuing a local timer after the tick has been stopped will result in
the timer being ignored until the next random interrupt.

Perform sanity checks to report these situations.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar<mingo@kernel.org>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 kernel/sched/core.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 6056f0374674..6c8b04272a9a 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -715,6 +715,26 @@ int get_nohz_timer_target(void)
 	return cpu;
 }
 
+static void wake_idle_assert_possible(void)
+{
+#ifdef CONFIG_SCHED_DEBUG
+	/* Timers are re-evaluated after idle IRQs */
+	if (in_hardirq())
+		return;
+	/*
+	 * Same as hardirqs, assuming they are executing
+	 * on IRQ tail. Ksoftirqd shouldn't reach here
+	 * as the timer base wouldn't be idle. And inline
+	 * softirq processing after a call to local_bh_enable()
+	 * within idle loop sound too fun to be considered here.
+	 */
+	if (in_serving_softirq())
+		return;
+
+	WARN_ON_ONCE("Late timer enqueue may be ignored\n");
+#endif
+}
+
 /*
  * When add_timer_on() enqueues a timer into the timer wheel of an
  * idle CPU then this timer might expire before the next timer event
@@ -729,8 +749,10 @@ static void wake_up_idle_cpu(int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
 
-	if (cpu == smp_processor_id())
+	if (cpu == smp_processor_id()) {
+		wake_idle_assert_possible();
 		return;
+	}
 
 	if (set_nr_and_not_polling(rq->idle))
 		smp_send_reschedule(cpu);
-- 
2.25.1

