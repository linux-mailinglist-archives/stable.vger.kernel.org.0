Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0087515AF8
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 07:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728835AbfEGFuX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 01:50:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:59668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727645AbfEGFkL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:40:11 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B42D420578;
        Tue,  7 May 2019 05:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207610;
        bh=gJeXJ2QRq1NFjpcek+JAmbg2dpyjUJM27PIPaL5vOzQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ekgz6yhmqm6BiRa0vcQNnrpFLjBOkyb7PExMITEriX2fhrRV+BCkvTxqwNrWcFtXl
         3rbleqiFW5JFIfWhCJNKLGvLXpbfz59DZCMN9fh27MfgqZK+cHwtXt+TZmpQ5hTM9v
         30o4k1QmR6Y3qdKMHWQi15t5wXjOWwtjLJni6W24=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>, stable@kernel.org,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Sasha Levin <alexander.levin@microsoft.com>
Subject: [PATCH AUTOSEL 4.14 54/95] tracing/fgraph: Fix set_graph_function from showing interrupts
Date:   Tue,  7 May 2019 01:37:43 -0400
Message-Id: <20190507053826.31622-54-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053826.31622-1-sashal@kernel.org>
References: <20190507053826.31622-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

[ Upstream commit 5cf99a0f3161bc3ae2391269d134d6bf7e26f00e ]

The tracefs file set_graph_function is used to only function graph functions
that are listed in that file (or all functions if the file is empty). The
way this is implemented is that the function graph tracer looks at every
function, and if the current depth is zero and the function matches
something in the file then it will trace that function. When other functions
are called, the depth will be greater than zero (because the original
function will be at depth zero), and all functions will be traced where the
depth is greater than zero.

The issue is that when a function is first entered, and the handler that
checks this logic is called, the depth is set to zero. If an interrupt comes
in and a function in the interrupt handler is traced, its depth will be
greater than zero and it will automatically be traced, even if the original
function was not. But because the logic only looks at depth it may trace
interrupts when it should not be.

The recent design change of the function graph tracer to fix other bugs
caused the depth to be zero while the function graph callback handler is
being called for a longer time, widening the race of this happening. This
bug was actually there for a longer time, but because the race window was so
small it seldom happened. The Fixes tag below is for the commit that widen
the race window, because that commit belongs to a series that will also help
fix the original bug.

Cc: stable@kernel.org
Fixes: 39eb456dacb5 ("function_graph: Use new curr_ret_depth to manage depth instead of curr_ret_stack")
Reported-by: Joe Lawrence <joe.lawrence@redhat.com>
Tested-by: Joe Lawrence <joe.lawrence@redhat.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 kernel/trace/trace.h                 | 57 ++++++++++++++++++++++++++--
 kernel/trace/trace_functions_graph.c |  4 ++
 kernel/trace/trace_irqsoff.c         |  2 +
 kernel/trace/trace_sched_wakeup.c    |  2 +
 4 files changed, 62 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 851cd1605085..a51e32de7c5f 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -504,12 +504,44 @@ enum {
  * can only be modified by current, we can reuse trace_recursion.
  */
 	TRACE_IRQ_BIT,
+
+	/* Set if the function is in the set_graph_function file */
+	TRACE_GRAPH_BIT,
+
+	/*
+	 * In the very unlikely case that an interrupt came in
+	 * at a start of graph tracing, and we want to trace
+	 * the function in that interrupt, the depth can be greater
+	 * than zero, because of the preempted start of a previous
+	 * trace. In an even more unlikely case, depth could be 2
+	 * if a softirq interrupted the start of graph tracing,
+	 * followed by an interrupt preempting a start of graph
+	 * tracing in the softirq, and depth can even be 3
+	 * if an NMI came in at the start of an interrupt function
+	 * that preempted a softirq start of a function that
+	 * preempted normal context!!!! Luckily, it can't be
+	 * greater than 3, so the next two bits are a mask
+	 * of what the depth is when we set TRACE_GRAPH_BIT
+	 */
+
+	TRACE_GRAPH_DEPTH_START_BIT,
+	TRACE_GRAPH_DEPTH_END_BIT,
 };
 
 #define trace_recursion_set(bit)	do { (current)->trace_recursion |= (1<<(bit)); } while (0)
 #define trace_recursion_clear(bit)	do { (current)->trace_recursion &= ~(1<<(bit)); } while (0)
 #define trace_recursion_test(bit)	((current)->trace_recursion & (1<<(bit)))
 
+#define trace_recursion_depth() \
+	(((current)->trace_recursion >> TRACE_GRAPH_DEPTH_START_BIT) & 3)
+#define trace_recursion_set_depth(depth) \
+	do {								\
+		current->trace_recursion &=				\
+			~(3 << TRACE_GRAPH_DEPTH_START_BIT);		\
+		current->trace_recursion |=				\
+			((depth) & 3) << TRACE_GRAPH_DEPTH_START_BIT;	\
+	} while (0)
+
 #define TRACE_CONTEXT_BITS	4
 
 #define TRACE_FTRACE_START	TRACE_FTRACE_BIT
@@ -839,8 +871,9 @@ extern void __trace_graph_return(struct trace_array *tr,
 extern struct ftrace_hash *ftrace_graph_hash;
 extern struct ftrace_hash *ftrace_graph_notrace_hash;
 
-static inline int ftrace_graph_addr(unsigned long addr)
+static inline int ftrace_graph_addr(struct ftrace_graph_ent *trace)
 {
+	unsigned long addr = trace->func;
 	int ret = 0;
 
 	preempt_disable_notrace();
@@ -851,6 +884,14 @@ static inline int ftrace_graph_addr(unsigned long addr)
 	}
 
 	if (ftrace_lookup_ip(ftrace_graph_hash, addr)) {
+
+		/*
+		 * This needs to be cleared on the return functions
+		 * when the depth is zero.
+		 */
+		trace_recursion_set(TRACE_GRAPH_BIT);
+		trace_recursion_set_depth(trace->depth);
+
 		/*
 		 * If no irqs are to be traced, but a set_graph_function
 		 * is set, and called by an interrupt handler, we still
@@ -868,6 +909,13 @@ static inline int ftrace_graph_addr(unsigned long addr)
 	return ret;
 }
 
+static inline void ftrace_graph_addr_finish(struct ftrace_graph_ret *trace)
+{
+	if (trace_recursion_test(TRACE_GRAPH_BIT) &&
+	    trace->depth == trace_recursion_depth())
+		trace_recursion_clear(TRACE_GRAPH_BIT);
+}
+
 static inline int ftrace_graph_notrace_addr(unsigned long addr)
 {
 	int ret = 0;
@@ -881,7 +929,7 @@ static inline int ftrace_graph_notrace_addr(unsigned long addr)
 	return ret;
 }
 #else
-static inline int ftrace_graph_addr(unsigned long addr)
+static inline int ftrace_graph_addr(struct ftrace_graph_ent *trace)
 {
 	return 1;
 }
@@ -890,6 +938,8 @@ static inline int ftrace_graph_notrace_addr(unsigned long addr)
 {
 	return 0;
 }
+static inline void ftrace_graph_addr_finish(struct ftrace_graph_ret *trace)
+{ }
 #endif /* CONFIG_DYNAMIC_FTRACE */
 
 extern unsigned int fgraph_max_depth;
@@ -897,7 +947,8 @@ extern unsigned int fgraph_max_depth;
 static inline bool ftrace_graph_ignore_func(struct ftrace_graph_ent *trace)
 {
 	/* trace it when it is-nested-in or is a function enabled. */
-	return !(trace->depth || ftrace_graph_addr(trace->func)) ||
+	return !(trace_recursion_test(TRACE_GRAPH_BIT) ||
+		 ftrace_graph_addr(trace)) ||
 		(trace->depth < 0) ||
 		(fgraph_max_depth && trace->depth >= fgraph_max_depth);
 }
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 169b3c44ee97..72d0d477f5c1 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -482,6 +482,8 @@ void trace_graph_return(struct ftrace_graph_ret *trace)
 	int cpu;
 	int pc;
 
+	ftrace_graph_addr_finish(trace);
+
 	local_irq_save(flags);
 	cpu = raw_smp_processor_id();
 	data = per_cpu_ptr(tr->trace_buffer.data, cpu);
@@ -505,6 +507,8 @@ void set_graph_array(struct trace_array *tr)
 
 static void trace_graph_thresh_return(struct ftrace_graph_ret *trace)
 {
+	ftrace_graph_addr_finish(trace);
+
 	if (tracing_thresh &&
 	    (trace->rettime - trace->calltime < tracing_thresh))
 		return;
diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index 7758bc0617cb..2d9e12380dc3 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -204,6 +204,8 @@ static void irqsoff_graph_return(struct ftrace_graph_ret *trace)
 	unsigned long flags;
 	int pc;
 
+	ftrace_graph_addr_finish(trace);
+
 	if (!func_prolog_dec(tr, &data, &flags))
 		return;
 
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index 7d461dcd4831..0fa9dadf3f4f 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -270,6 +270,8 @@ static void wakeup_graph_return(struct ftrace_graph_ret *trace)
 	unsigned long flags;
 	int pc;
 
+	ftrace_graph_addr_finish(trace);
+
 	if (!func_prolog_preempt_disable(tr, &data, &pc))
 		return;
 
-- 
2.20.1

