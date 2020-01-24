Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13407147AE3
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:40:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729180AbgAXJjN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:39:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:36346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729924AbgAXJjM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:39:12 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 748F920709;
        Fri, 24 Jan 2020 09:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579858751;
        bh=HdT58Yiqp0jmr/sDUj4BFGZyrgcM7XM5tIMrOuWTN1A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ABQgjvWt9UWEBfssCI/B24Za4PkOUZboMprP/QVtkTA0Zu/mKuEWVVPKMa4bCsbSm
         kbQGVuUHCN+acpwLI1M29eLEAmZim6cYpGcNq/RGdMsUQ0YYzdToYoMNTiCII7N210
         dPj6V9j4Tkw3QyfpHSdlfUiqrFriaV6qaVqeWpcE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, bsegall@google.com,
        dietmar.eggemann@arm.com, juri.lelli@redhat.com,
        ktkhai@virtuozzo.com, mgorman@suse.de, qais.yousef@arm.com,
        qperret@google.com, rostedt@goodmis.org,
        valentin.schneider@arm.com, vincent.guittot@linaro.org,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 5.4 047/102] sched/core: Further clarify sched_class::set_next_task()
Date:   Fri, 24 Jan 2020 10:30:48 +0100
Message-Id: <20200124092813.389202154@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092806.004582306@linuxfoundation.org>
References: <20200124092806.004582306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit a0e813f26ebcb25c0b5e504498fbd796cca1a4ba upstream.

It turns out there really is something special to the first
set_next_task() invocation. In specific the 'change' pattern really
should not cause balance callbacks.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: bsegall@google.com
Cc: dietmar.eggemann@arm.com
Cc: juri.lelli@redhat.com
Cc: ktkhai@virtuozzo.com
Cc: mgorman@suse.de
Cc: qais.yousef@arm.com
Cc: qperret@google.com
Cc: rostedt@goodmis.org
Cc: valentin.schneider@arm.com
Cc: vincent.guittot@linaro.org
Fixes: f95d4eaee6d0 ("sched/{rt,deadline}: Fix set_next_task vs pick_next_task")
Link: https://lkml.kernel.org/r/20191108131909.775434698@infradead.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/sched/deadline.c  |    7 +++++--
 kernel/sched/fair.c      |    2 +-
 kernel/sched/idle.c      |    4 ++--
 kernel/sched/rt.c        |    7 +++++--
 kernel/sched/sched.h     |    4 ++--
 kernel/sched/stop_task.c |    4 ++--
 6 files changed, 17 insertions(+), 11 deletions(-)

--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1743,13 +1743,16 @@ static void start_hrtick_dl(struct rq *r
 }
 #endif
 
-static void set_next_task_dl(struct rq *rq, struct task_struct *p)
+static void set_next_task_dl(struct rq *rq, struct task_struct *p, bool first)
 {
 	p->se.exec_start = rq_clock_task(rq);
 
 	/* You can't push away the running task */
 	dequeue_pushable_dl_task(rq, p);
 
+	if (!first)
+		return;
+
 	if (hrtick_enabled(rq))
 		start_hrtick_dl(rq, p);
 
@@ -1785,7 +1788,7 @@ pick_next_task_dl(struct rq *rq, struct
 	dl_se = pick_next_dl_entity(rq, dl_rq);
 	BUG_ON(!dl_se);
 	p = dl_task_of(dl_se);
-	set_next_task_dl(rq, p);
+	set_next_task_dl(rq, p, true);
 	return p;
 }
 
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -10151,7 +10151,7 @@ static void switched_to_fair(struct rq *
  * This routine is mostly called to set cfs_rq->curr field when a task
  * migrates between groups/classes.
  */
-static void set_next_task_fair(struct rq *rq, struct task_struct *p)
+static void set_next_task_fair(struct rq *rq, struct task_struct *p, bool first)
 {
 	struct sched_entity *se = &p->se;
 
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -385,7 +385,7 @@ static void put_prev_task_idle(struct rq
 {
 }
 
-static void set_next_task_idle(struct rq *rq, struct task_struct *next)
+static void set_next_task_idle(struct rq *rq, struct task_struct *next, bool first)
 {
 	update_idle_core(rq);
 	schedstat_inc(rq->sched_goidle);
@@ -399,7 +399,7 @@ pick_next_task_idle(struct rq *rq, struc
 	if (prev)
 		put_prev_task(rq, prev);
 
-	set_next_task_idle(rq, next);
+	set_next_task_idle(rq, next, true);
 
 	return next;
 }
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1515,13 +1515,16 @@ static void check_preempt_curr_rt(struct
 #endif
 }
 
-static inline void set_next_task_rt(struct rq *rq, struct task_struct *p)
+static inline void set_next_task_rt(struct rq *rq, struct task_struct *p, bool first)
 {
 	p->se.exec_start = rq_clock_task(rq);
 
 	/* The running task is never eligible for pushing */
 	dequeue_pushable_task(rq, p);
 
+	if (!first)
+		return;
+
 	/*
 	 * If prev task was rt, put_prev_task() has already updated the
 	 * utilization. We only care of the case where we start to schedule a
@@ -1575,7 +1578,7 @@ pick_next_task_rt(struct rq *rq, struct
 		return NULL;
 
 	p = _pick_next_task_rt(rq);
-	set_next_task_rt(rq, p);
+	set_next_task_rt(rq, p, true);
 	return p;
 }
 
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1728,7 +1728,7 @@ struct sched_class {
 					       struct task_struct *prev,
 					       struct rq_flags *rf);
 	void (*put_prev_task)(struct rq *rq, struct task_struct *p);
-	void (*set_next_task)(struct rq *rq, struct task_struct *p);
+	void (*set_next_task)(struct rq *rq, struct task_struct *p, bool first);
 
 #ifdef CONFIG_SMP
 	int (*balance)(struct rq *rq, struct task_struct *prev, struct rq_flags *rf);
@@ -1780,7 +1780,7 @@ static inline void put_prev_task(struct
 static inline void set_next_task(struct rq *rq, struct task_struct *next)
 {
 	WARN_ON_ONCE(rq->curr != next);
-	next->sched_class->set_next_task(rq, next);
+	next->sched_class->set_next_task(rq, next, false);
 }
 
 #ifdef CONFIG_SMP
--- a/kernel/sched/stop_task.c
+++ b/kernel/sched/stop_task.c
@@ -29,7 +29,7 @@ check_preempt_curr_stop(struct rq *rq, s
 	/* we're never preempted */
 }
 
-static void set_next_task_stop(struct rq *rq, struct task_struct *stop)
+static void set_next_task_stop(struct rq *rq, struct task_struct *stop, bool first)
 {
 	stop->se.exec_start = rq_clock_task(rq);
 }
@@ -42,7 +42,7 @@ pick_next_task_stop(struct rq *rq, struc
 	if (!sched_stop_runnable(rq))
 		return NULL;
 
-	set_next_task_stop(rq, rq->stop);
+	set_next_task_stop(rq, rq->stop, true);
 	return rq->stop;
 }
 


