Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5576E755D
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 10:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232770AbjDSIeh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 04:34:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232664AbjDSIeS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 04:34:18 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C030D6A63;
        Wed, 19 Apr 2023 01:33:58 -0700 (PDT)
Date:   Wed, 19 Apr 2023 08:33:55 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1681893236;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vdsbrh7FdIhP1wb9imiviwOB+uVZ3EupVTF1jcm/rRE=;
        b=qNlghMZZeq+L1mMqnenjXEmNevoIaV349ntILSxNup80hbFtx6FImzqqJ8pnj5rCom3J6i
        aoG/CHm995DzYaAVMPq1LVwDrq/1wPcWYNjC3fqMAPNBUjwQeVBIE4pacOOiEQxa66DVQN
        UlUFqFmSVKWare7pgNP675AStHIAi1DVyZKynUHbFaieyzzDuWSsrmOlmW8bSCqsRNb8MM
        wl2Hrf3e3Gx7Y87yUv813O8tfYQt+sdJyr/Howl/zFiHPoSxizfl5fSsov4t6dtdD+C1J6
        EAzWp2EqYQknD/k9SJnwLh3oou76KvhE4y8V4fWM1VylfKSZJHAJkIyozrh4OQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1681893236;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vdsbrh7FdIhP1wb9imiviwOB+uVZ3EupVTF1jcm/rRE=;
        b=6KwxoS/XYkitWjfU935ghaCejiJDrkwMPnNmpPMdrZdjO4cBYCZGB12W8ltTxqO+ijsXpI
        MkEQjITHnG34E2Bw==
From:   "tip-bot2 for Thomas Gleixner" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: timers/core] posix-cpu-timers: Implement the missing
 timer_wait_running callback
Cc:     Marco Elver <elver@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Frederic Weisbecker <frederic@kernel.org>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <87zg764ojw.ffs@tglx>
References: <87zg764ojw.ffs@tglx>
MIME-Version: 1.0
Message-ID: <168189323577.404.1408682841393463765.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the timers/core branch of tip:

Commit-ID:     1bb5b68fd3aabb6b9d6b9e9bb092bb8f3c2ade62
Gitweb:        https://git.kernel.org/tip/1bb5b68fd3aabb6b9d6b9e9bb092bb8f3c2ade62
Author:        Thomas Gleixner <tglx@linutronix.de>
AuthorDate:    Mon, 17 Apr 2023 15:37:55 +02:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Wed, 19 Apr 2023 10:29:00 +02:00

posix-cpu-timers: Implement the missing timer_wait_running callback

For some unknown reason the introduction of the timer_wait_running callback
missed to fixup posix CPU timers, which went unnoticed for almost four years.
Marco reported recently that the WARN_ON() in timer_wait_running()
triggers with a posix CPU timer test case.

Posix CPU timers have two execution models for expiring timers depending on
CONFIG_POSIX_CPU_TIMERS_TASK_WORK:

1) If not enabled, the expiry happens in hard interrupt context so
   spin waiting on the remote CPU is reasonably time bound.

   Implement an empty stub function for that case.

2) If enabled, the expiry happens in task work before returning to user
   space or guest mode. The expired timers are marked as firing and moved
   from the timer queue to a local list head with sighand lock held. Once
   the timers are moved, sighand lock is dropped and the expiry happens in
   fully preemptible context. That means the expiring task can be scheduled
   out, migrated, interrupted etc. So spin waiting on it is more than
   suboptimal.

   The timer wheel has a timer_wait_running() mechanism for RT, which uses
   a per CPU timer-base expiry lock which is held by the expiry code and the
   task waiting for the timer function to complete blocks on that lock.

   This does not work in the same way for posix CPU timers as there is no
   timer base and expiry for process wide timers can run on any task
   belonging to that process, but the concept of waiting on an expiry lock
   can be used too in a slightly different way:

    - Add a mutex to struct posix_cputimers_work. This struct is per task
      and used to schedule the expiry task work from the timer interrupt.

    - Add a task_struct pointer to struct cpu_timer which is used to store
      a the task which runs the expiry. That's filled in when the task
      moves the expired timers to the local expiry list. That's not
      affecting the size of the k_itimer union as there are bigger union
      members already

    - Let the task take the expiry mutex around the expiry function

    - Let the waiter acquire a task reference with rcu_read_lock() held and
      block on the expiry mutex

   This avoids spin-waiting on a task which might not even be on a CPU and
   works nicely for RT too.

Fixes: ec8f954a40da ("posix-timers: Use a callback for cancel synchronization on PREEMPT_RT")
Reported-by: Marco Elver <elver@google.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Marco Elver <elver@google.com>
Tested-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/87zg764ojw.ffs@tglx
---
 include/linux/posix-timers.h   | 17 ++++---
 kernel/time/posix-cpu-timers.c | 81 +++++++++++++++++++++++++++------
 kernel/time/posix-timers.c     |  4 ++-
 3 files changed, 82 insertions(+), 20 deletions(-)

diff --git a/include/linux/posix-timers.h b/include/linux/posix-timers.h
index 2c6e99c..d607f51 100644
--- a/include/linux/posix-timers.h
+++ b/include/linux/posix-timers.h
@@ -4,6 +4,7 @@
 
 #include <linux/spinlock.h>
 #include <linux/list.h>
+#include <linux/mutex.h>
 #include <linux/alarmtimer.h>
 #include <linux/timerqueue.h>
 
@@ -62,16 +63,18 @@ static inline int clockid_to_fd(const clockid_t clk)
  * cpu_timer - Posix CPU timer representation for k_itimer
  * @node:	timerqueue node to queue in the task/sig
  * @head:	timerqueue head on which this timer is queued
- * @task:	Pointer to target task
+ * @pid:	Pointer to target task PID
  * @elist:	List head for the expiry list
  * @firing:	Timer is currently firing
+ * @handling:	Pointer to the task which handles expiry
  */
 struct cpu_timer {
-	struct timerqueue_node	node;
-	struct timerqueue_head	*head;
-	struct pid		*pid;
-	struct list_head	elist;
-	int			firing;
+	struct timerqueue_node		node;
+	struct timerqueue_head		*head;
+	struct pid			*pid;
+	struct list_head		elist;
+	int				firing;
+	struct task_struct __rcu	*handling;
 };
 
 static inline bool cpu_timer_enqueue(struct timerqueue_head *head,
@@ -135,10 +138,12 @@ struct posix_cputimers {
 /**
  * posix_cputimers_work - Container for task work based posix CPU timer expiry
  * @work:	The task work to be scheduled
+ * @mutex:	Mutex held around expiry in context of this task work
  * @scheduled:  @work has been scheduled already, no further processing
  */
 struct posix_cputimers_work {
 	struct callback_head	work;
+	struct mutex		mutex;
 	unsigned int		scheduled;
 };
 
diff --git a/kernel/time/posix-cpu-timers.c b/kernel/time/posix-cpu-timers.c
index 2f5e9b3..fb56e02 100644
--- a/kernel/time/posix-cpu-timers.c
+++ b/kernel/time/posix-cpu-timers.c
@@ -846,6 +846,8 @@ static u64 collect_timerqueue(struct timerqueue_head *head,
 			return expires;
 
 		ctmr->firing = 1;
+		/* See posix_cpu_timer_wait_running() */
+		rcu_assign_pointer(ctmr->handling, current);
 		cpu_timer_dequeue(ctmr);
 		list_add_tail(&ctmr->elist, firing);
 	}
@@ -1161,7 +1163,49 @@ static void handle_posix_cpu_timers(struct task_struct *tsk);
 #ifdef CONFIG_POSIX_CPU_TIMERS_TASK_WORK
 static void posix_cpu_timers_work(struct callback_head *work)
 {
+	struct posix_cputimers_work *cw = container_of(work, typeof(*cw), work);
+
+	mutex_lock(&cw->mutex);
 	handle_posix_cpu_timers(current);
+	mutex_unlock(&cw->mutex);
+}
+
+/*
+ * Invoked from the posix-timer core when a cancel operation failed because
+ * the timer is marked firing. The caller holds rcu_read_lock(), which
+ * protects the timer and the task which is expiring it from being freed.
+ */
+static void posix_cpu_timer_wait_running(struct k_itimer *timr)
+{
+	struct task_struct *tsk = rcu_dereference(timr->it.cpu.handling);
+
+	/* Has the handling task completed expiry already? */
+	if (!tsk)
+		return;
+
+	/* Ensure that the task cannot go away */
+	get_task_struct(tsk);
+	/* Now drop the RCU protection so the mutex can be locked */
+	rcu_read_unlock();
+	/* Wait on the expiry mutex */
+	mutex_lock(&tsk->posix_cputimers_work.mutex);
+	/* Release it immediately again. */
+	mutex_unlock(&tsk->posix_cputimers_work.mutex);
+	/* Drop the task reference. */
+	put_task_struct(tsk);
+	/* Relock RCU so the callsite is balanced */
+	rcu_read_lock();
+}
+
+static void posix_cpu_timer_wait_running_nsleep(struct k_itimer *timr)
+{
+	/* Ensure that timr->it.cpu.handling task cannot go away */
+	rcu_read_lock();
+	spin_unlock_irq(&timr->it_lock);
+	posix_cpu_timer_wait_running(timr);
+	rcu_read_unlock();
+	/* @timr is on stack and is valid */
+	spin_lock_irq(&timr->it_lock);
 }
 
 /*
@@ -1177,6 +1221,7 @@ void clear_posix_cputimers_work(struct task_struct *p)
 	       sizeof(p->posix_cputimers_work.work));
 	init_task_work(&p->posix_cputimers_work.work,
 		       posix_cpu_timers_work);
+	mutex_init(&p->posix_cputimers_work.mutex);
 	p->posix_cputimers_work.scheduled = false;
 }
 
@@ -1255,6 +1300,18 @@ static inline void __run_posix_cpu_timers(struct task_struct *tsk)
 	lockdep_posixtimer_exit();
 }
 
+static void posix_cpu_timer_wait_running(struct k_itimer *timr)
+{
+	cpu_relax();
+}
+
+static void posix_cpu_timer_wait_running_nsleep(struct k_itimer *timr)
+{
+	spin_unlock_irq(&timer.it_lock);
+	cpu_relax();
+	spin_lock_irq(&timer.it_lock);
+}
+
 static inline bool posix_cpu_timers_work_scheduled(struct task_struct *tsk)
 {
 	return false;
@@ -1363,6 +1420,8 @@ static void handle_posix_cpu_timers(struct task_struct *tsk)
 		 */
 		if (likely(cpu_firing >= 0))
 			cpu_timer_fire(timer);
+		/* See posix_cpu_timer_wait_running() */
+		rcu_assign_pointer(timer->it.cpu.handling, NULL);
 		spin_unlock(&timer->it_lock);
 	}
 }
@@ -1497,23 +1556,16 @@ static int do_cpu_nanosleep(const clockid_t which_clock, int flags,
 		expires = cpu_timer_getexpires(&timer.it.cpu);
 		error = posix_cpu_timer_set(&timer, 0, &zero_it, &it);
 		if (!error) {
-			/*
-			 * Timer is now unarmed, deletion can not fail.
-			 */
+			/* Timer is now unarmed, deletion can not fail. */
 			posix_cpu_timer_del(&timer);
+		} else {
+			while (error == TIMER_RETRY) {
+				posix_cpu_timer_wait_running_nsleep(&timer);
+				error = posix_cpu_timer_del(&timer);
+			}
 		}
-		spin_unlock_irq(&timer.it_lock);
 
-		while (error == TIMER_RETRY) {
-			/*
-			 * We need to handle case when timer was or is in the
-			 * middle of firing. In other cases we already freed
-			 * resources.
-			 */
-			spin_lock_irq(&timer.it_lock);
-			error = posix_cpu_timer_del(&timer);
-			spin_unlock_irq(&timer.it_lock);
-		}
+		spin_unlock_irq(&timer.it_lock);
 
 		if ((it.it_value.tv_sec | it.it_value.tv_nsec) == 0) {
 			/*
@@ -1623,6 +1675,7 @@ const struct k_clock clock_posix_cpu = {
 	.timer_del		= posix_cpu_timer_del,
 	.timer_get		= posix_cpu_timer_get,
 	.timer_rearm		= posix_cpu_timer_rearm,
+	.timer_wait_running	= posix_cpu_timer_wait_running,
 };
 
 const struct k_clock clock_process = {
diff --git a/kernel/time/posix-timers.c b/kernel/time/posix-timers.c
index 0c8a87a..808a247 100644
--- a/kernel/time/posix-timers.c
+++ b/kernel/time/posix-timers.c
@@ -846,6 +846,10 @@ static struct k_itimer *timer_wait_running(struct k_itimer *timer,
 	rcu_read_lock();
 	unlock_timer(timer, *flags);
 
+	/*
+	 * kc->timer_wait_running() might drop RCU lock. So @timer
+	 * cannot be touched anymore after the function returns!
+	 */
 	if (!WARN_ON_ONCE(!kc->timer_wait_running))
 		kc->timer_wait_running(timer);
 
