Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94C3D4F32E5
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240070AbiDEKHb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:07:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344288AbiDEJTE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:19:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 200BA23BDA;
        Tue,  5 Apr 2022 02:07:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3B7661571;
        Tue,  5 Apr 2022 09:07:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB940C385A0;
        Tue,  5 Apr 2022 09:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149644;
        bh=bSb3HqwUqzg12TWINhvRaliTGErk6UBUU6LHoXhpwQI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zFYWSKtL6hY8UpP6Erk1x3m7sB8hl2bzTzXuy8SVKI6oDX81UyO6iBi4gZ8ro+05/
         s8bu7Lce6RD82TF8dma1bbJrO7Dnn6cQSehr7s/kkWn1vVOByTiAB+Yjf1jLSQKj9T
         vxZw7C50IJDH23jhByKJOcqD/lpAw/Pp7WH7816E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Abhijeet Dharmapurikar <adharmap@quicinc.com>,
        Valentin Schneider <valentin.schneider@arm.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0788/1017] sched/tracing: Dont re-read p->state when emitting sched_switch event
Date:   Tue,  5 Apr 2022 09:28:21 +0200
Message-Id: <20220405070417.645056019@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Valentin Schneider <valentin.schneider@arm.com>

[ Upstream commit fa2c3254d7cfff5f7a916ab928a562d1165f17bb ]

As of commit

  c6e7bd7afaeb ("sched/core: Optimize ttwu() spinning on p->on_cpu")

the following sequence becomes possible:

		      p->__state = TASK_INTERRUPTIBLE;
		      __schedule()
			deactivate_task(p);
  ttwu()
    READ !p->on_rq
    p->__state=TASK_WAKING
			trace_sched_switch()
			  __trace_sched_switch_state()
			    task_state_index()
			      return 0;

TASK_WAKING isn't in TASK_REPORT, so the task appears as TASK_RUNNING in
the trace event.

Prevent this by pushing the value read from __schedule() down the trace
event.

Reported-by: Abhijeet Dharmapurikar <adharmap@quicinc.com>
Signed-off-by: Valentin Schneider <valentin.schneider@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Link: https://lore.kernel.org/r/20220120162520.570782-2-valentin.schneider@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sched.h             | 11 ++++++++---
 include/trace/events/sched.h      | 11 +++++++----
 kernel/sched/core.c               |  4 ++--
 kernel/trace/fgraph.c             |  4 +++-
 kernel/trace/ftrace.c             |  4 +++-
 kernel/trace/trace_events.c       |  8 ++++++--
 kernel/trace/trace_osnoise.c      |  4 +++-
 kernel/trace/trace_sched_switch.c |  1 +
 kernel/trace/trace_sched_wakeup.c |  1 +
 9 files changed, 34 insertions(+), 14 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index ee5ed8821963..084de9b70a77 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1612,10 +1612,10 @@ static inline pid_t task_pgrp_nr(struct task_struct *tsk)
 #define TASK_REPORT_IDLE	(TASK_REPORT + 1)
 #define TASK_REPORT_MAX		(TASK_REPORT_IDLE << 1)
 
-static inline unsigned int task_state_index(struct task_struct *tsk)
+static inline unsigned int __task_state_index(unsigned int tsk_state,
+					      unsigned int tsk_exit_state)
 {
-	unsigned int tsk_state = READ_ONCE(tsk->__state);
-	unsigned int state = (tsk_state | tsk->exit_state) & TASK_REPORT;
+	unsigned int state = (tsk_state | tsk_exit_state) & TASK_REPORT;
 
 	BUILD_BUG_ON_NOT_POWER_OF_2(TASK_REPORT_MAX);
 
@@ -1625,6 +1625,11 @@ static inline unsigned int task_state_index(struct task_struct *tsk)
 	return fls(state);
 }
 
+static inline unsigned int task_state_index(struct task_struct *tsk)
+{
+	return __task_state_index(READ_ONCE(tsk->__state), tsk->exit_state);
+}
+
 static inline char task_index_to_char(unsigned int state)
 {
 	static const char state_char[] = "RSDTtXZPI";
diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index 94640482cfe7..65e786756321 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -187,7 +187,9 @@ DEFINE_EVENT(sched_wakeup_template, sched_wakeup_new,
 	     TP_ARGS(p));
 
 #ifdef CREATE_TRACE_POINTS
-static inline long __trace_sched_switch_state(bool preempt, struct task_struct *p)
+static inline long __trace_sched_switch_state(bool preempt,
+					      unsigned int prev_state,
+					      struct task_struct *p)
 {
 	unsigned int state;
 
@@ -208,7 +210,7 @@ static inline long __trace_sched_switch_state(bool preempt, struct task_struct *
 	 * it for left shift operation to get the correct task->state
 	 * mapping.
 	 */
-	state = task_state_index(p);
+	state = __task_state_index(prev_state, p->exit_state);
 
 	return state ? (1 << (state - 1)) : state;
 }
@@ -220,10 +222,11 @@ static inline long __trace_sched_switch_state(bool preempt, struct task_struct *
 TRACE_EVENT(sched_switch,
 
 	TP_PROTO(bool preempt,
+		 unsigned int prev_state,
 		 struct task_struct *prev,
 		 struct task_struct *next),
 
-	TP_ARGS(preempt, prev, next),
+	TP_ARGS(preempt, prev_state, prev, next),
 
 	TP_STRUCT__entry(
 		__array(	char,	prev_comm,	TASK_COMM_LEN	)
@@ -239,7 +242,7 @@ TRACE_EVENT(sched_switch,
 		memcpy(__entry->next_comm, next->comm, TASK_COMM_LEN);
 		__entry->prev_pid	= prev->pid;
 		__entry->prev_prio	= prev->prio;
-		__entry->prev_state	= __trace_sched_switch_state(preempt, prev);
+		__entry->prev_state	= __trace_sched_switch_state(preempt, prev_state, prev);
 		memcpy(__entry->prev_comm, prev->comm, TASK_COMM_LEN);
 		__entry->next_pid	= next->pid;
 		__entry->next_prio	= next->prio;
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 0e4b8214af31..527ee363db3f 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4821,7 +4821,7 @@ static struct rq *finish_task_switch(struct task_struct *prev)
 {
 	struct rq *rq = this_rq();
 	struct mm_struct *mm = rq->prev_mm;
-	long prev_state;
+	unsigned int prev_state;
 
 	/*
 	 * The previous task will have left us with a preempt_count of 2
@@ -6257,7 +6257,7 @@ static void __sched notrace __schedule(unsigned int sched_mode)
 		migrate_disable_switch(rq, prev);
 		psi_sched_switch(prev, next, !task_on_rq_queued(prev));
 
-		trace_sched_switch(sched_mode & SM_MASK_PREEMPT, prev, next);
+		trace_sched_switch(sched_mode & SM_MASK_PREEMPT, prev_state, prev, next);
 
 		/* Also unlocks the rq: */
 		rq = context_switch(rq, prev, next, &rf);
diff --git a/kernel/trace/fgraph.c b/kernel/trace/fgraph.c
index 22061d38fc00..19028e072cdb 100644
--- a/kernel/trace/fgraph.c
+++ b/kernel/trace/fgraph.c
@@ -415,7 +415,9 @@ static int alloc_retstack_tasklist(struct ftrace_ret_stack **ret_stack_list)
 
 static void
 ftrace_graph_probe_sched_switch(void *ignore, bool preempt,
-			struct task_struct *prev, struct task_struct *next)
+				unsigned int prev_state,
+				struct task_struct *prev,
+				struct task_struct *next)
 {
 	unsigned long long timestamp;
 	int index;
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index be5f6b32a012..bbfa4606cba6 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -7317,7 +7317,9 @@ ftrace_func_t ftrace_ops_get_func(struct ftrace_ops *ops)
 
 static void
 ftrace_filter_pid_sched_switch_probe(void *data, bool preempt,
-		    struct task_struct *prev, struct task_struct *next)
+				     unsigned int prev_state,
+				     struct task_struct *prev,
+				     struct task_struct *next)
 {
 	struct trace_array *tr = data;
 	struct trace_pid_list *pid_list;
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 92be9cb1d7d4..c097d89ca946 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -759,7 +759,9 @@ void trace_event_follow_fork(struct trace_array *tr, bool enable)
 
 static void
 event_filter_pid_sched_switch_probe_pre(void *data, bool preempt,
-		    struct task_struct *prev, struct task_struct *next)
+					unsigned int prev_state,
+					struct task_struct *prev,
+					struct task_struct *next)
 {
 	struct trace_array *tr = data;
 	struct trace_pid_list *no_pid_list;
@@ -783,7 +785,9 @@ event_filter_pid_sched_switch_probe_pre(void *data, bool preempt,
 
 static void
 event_filter_pid_sched_switch_probe_post(void *data, bool preempt,
-		    struct task_struct *prev, struct task_struct *next)
+					 unsigned int prev_state,
+					 struct task_struct *prev,
+					 struct task_struct *next)
 {
 	struct trace_array *tr = data;
 	struct trace_pid_list *no_pid_list;
diff --git a/kernel/trace/trace_osnoise.c b/kernel/trace/trace_osnoise.c
index b6da7bd2383d..b3b8060e8bdd 100644
--- a/kernel/trace/trace_osnoise.c
+++ b/kernel/trace/trace_osnoise.c
@@ -1168,7 +1168,9 @@ thread_exit(struct osnoise_variables *osn_var, struct task_struct *t)
  * used to record the beginning and to report the end of a thread noise window.
  */
 static void
-trace_sched_switch_callback(void *data, bool preempt, struct task_struct *p,
+trace_sched_switch_callback(void *data, bool preempt,
+			    unsigned int prev_state,
+			    struct task_struct *p,
 			    struct task_struct *n)
 {
 	struct osnoise_variables *osn_var = this_cpu_osn_var();
diff --git a/kernel/trace/trace_sched_switch.c b/kernel/trace/trace_sched_switch.c
index e304196d7c28..993b0ed10d8c 100644
--- a/kernel/trace/trace_sched_switch.c
+++ b/kernel/trace/trace_sched_switch.c
@@ -22,6 +22,7 @@ static DEFINE_MUTEX(sched_register_mutex);
 
 static void
 probe_sched_switch(void *ignore, bool preempt,
+		   unsigned int prev_state,
 		   struct task_struct *prev, struct task_struct *next)
 {
 	int flags;
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index 2402de520eca..46429f9a96fa 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -426,6 +426,7 @@ tracing_sched_wakeup_trace(struct trace_array *tr,
 
 static void notrace
 probe_wakeup_sched_switch(void *ignore, bool preempt,
+			  unsigned int prev_state,
 			  struct task_struct *prev, struct task_struct *next)
 {
 	struct trace_array_cpu *data;
-- 
2.34.1



