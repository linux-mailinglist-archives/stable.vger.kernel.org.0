Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F41FA26F281
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 05:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727670AbgIRCF5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:05:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:54396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726915AbgIRCF4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:05:56 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A873123770;
        Fri, 18 Sep 2020 02:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394753;
        bh=AiRrw4gYZftgvCZFwosYg7/WVjgkagPGraiwlo0q5IA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qybyt9Hr6p2UzoBBBHC3CansEbRL100jUVKJ/jZOy41Pb4Ra++AaEDvOhcLMKrFx+
         qBeQVAhdyk4kyK/tpDsxvQ5ofCHcETZv9UEvQSwSWa3oFQ5+k6RhaTooLnGAb/+8rC
         xtooNvp45iLIpERwHHT2asMkY9xRPD8UyFVly7pU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        kernel test robot <lkp@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Tejun Heo <tj@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 231/330] workqueue: Remove the warning in wq_worker_sleeping()
Date:   Thu, 17 Sep 2020 21:59:31 -0400
Message-Id: <20200918020110.2063155-231-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit 62849a9612924a655c67cf6962920544aa5c20db ]

The kernel test robot triggered a warning with the following race:
   task-ctx A                            interrupt-ctx B
 worker
  -> process_one_work()
    -> work_item()
      -> schedule();
         -> sched_submit_work()
           -> wq_worker_sleeping()
             -> ->sleeping = 1
               atomic_dec_and_test(nr_running)
         __schedule();                *interrupt*
                                       async_page_fault()
                                       -> local_irq_enable();
                                       -> schedule();
                                          -> sched_submit_work()
                                            -> wq_worker_sleeping()
                                               -> if (WARN_ON(->sleeping)) return
                                          -> __schedule()
                                            ->  sched_update_worker()
                                              -> wq_worker_running()
                                                 -> atomic_inc(nr_running);
                                                 -> ->sleeping = 0;

      ->  sched_update_worker()
        -> wq_worker_running()
          if (!->sleeping) return

In this context the warning is pointless everything is fine.
An interrupt before wq_worker_sleeping() will perform the ->sleeping
assignment (0 -> 1 > 0) twice.
An interrupt after wq_worker_sleeping() will trigger the warning and
nr_running will be decremented (by A) and incremented once (only by B, A
will skip it). This is the case until the ->sleeping is zeroed again in
wq_worker_running().

Remove the WARN statement because this condition may happen. Document
that preemption around wq_worker_sleeping() needs to be disabled to
protect ->sleeping and not just as an optimisation.

Fixes: 6d25be5782e48 ("sched/core, workqueues: Distangle worker accounting from rq lock")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Link: https://lkml.kernel.org/r/20200327074308.GY11705@shao2-debian
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c | 3 ++-
 kernel/workqueue.c  | 6 ++++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 352239c411a44..79ce22de44095 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4199,7 +4199,8 @@ static inline void sched_submit_work(struct task_struct *tsk)
 	 * it wants to wake up a task to maintain concurrency.
 	 * As this function is called inside the schedule() context,
 	 * we disable preemption to avoid it calling schedule() again
-	 * in the possible wakeup of a kworker.
+	 * in the possible wakeup of a kworker and because wq_worker_sleeping()
+	 * requires it.
 	 */
 	if (tsk->flags & PF_WQ_WORKER) {
 		preempt_disable();
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 1a0c224af6fb3..4aa268582a225 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -864,7 +864,8 @@ void wq_worker_running(struct task_struct *task)
  * @task: task going to sleep
  *
  * This function is called from schedule() when a busy worker is
- * going to sleep.
+ * going to sleep. Preemption needs to be disabled to protect ->sleeping
+ * assignment.
  */
 void wq_worker_sleeping(struct task_struct *task)
 {
@@ -881,7 +882,8 @@ void wq_worker_sleeping(struct task_struct *task)
 
 	pool = worker->pool;
 
-	if (WARN_ON_ONCE(worker->sleeping))
+	/* Return if preempted before wq_worker_running() was reached */
+	if (worker->sleeping)
 		return;
 
 	worker->sleeping = 1;
-- 
2.25.1

