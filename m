Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6D2630CE5C
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 23:04:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234387AbhBBWCE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 17:02:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:58600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234197AbhBBWCC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 17:02:02 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2167664F60;
        Tue,  2 Feb 2021 22:01:22 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1l73jc-0096yN-Vn; Tue, 02 Feb 2021 17:01:20 -0500
Message-ID: <20210202220120.864689944@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 02 Feb 2021 16:59:50 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, pierre.gondois@arm.com
Subject: [for-linus][PATCH 1/5] fgraph: Initialize tracing_graph_pause at task creation
References: <20210202215949.848582355@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

On some archs, the idle task can call into cpu_suspend(). The cpu_suspend()
will disable or pause function graph tracing, as there's some paths in
bringing down the CPU that can have issues with its return address being
modified. The task_struct structure has a "tracing_graph_pause" atomic
counter, that when set to something other than zero, the function graph
tracer will not modify the return address.

The problem is that the tracing_graph_pause counter is initialized when the
function graph tracer is enabled. This can corrupt the counter for the idle
task if it is suspended in these architectures.

   CPU 1				CPU 2
   -----				-----
  do_idle()
    cpu_suspend()
      pause_graph_tracing()
          task_struct->tracing_graph_pause++ (0 -> 1)

				start_graph_tracing()
				  for_each_online_cpu(cpu) {
				    ftrace_graph_init_idle_task(cpu)
				      task-struct->tracing_graph_pause = 0 (1 -> 0)

      unpause_graph_tracing()
          task_struct->tracing_graph_pause-- (0 -> -1)

The above should have gone from 1 to zero, and enabled function graph
tracing again. But instead, it is set to -1, which keeps it disabled.

There's no reason that the field tracing_graph_pause on the task_struct can
not be initialized at boot up.

Cc: stable@vger.kernel.org
Fixes: 380c4b1411ccd ("tracing/function-graph-tracer: append the tracing_graph_flag")
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=211339
Reported-by: pierre.gondois@arm.com
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 init/init_task.c      | 3 ++-
 kernel/trace/fgraph.c | 2 --
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/init/init_task.c b/init/init_task.c
index 8a992d73e6fb..3711cdaafed2 100644
--- a/init/init_task.c
+++ b/init/init_task.c
@@ -198,7 +198,8 @@ struct task_struct init_task
 	.lockdep_recursion = 0,
 #endif
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
-	.ret_stack	= NULL,
+	.ret_stack		= NULL,
+	.tracing_graph_pause	= ATOMIC_INIT(0),
 #endif
 #if defined(CONFIG_TRACING) && defined(CONFIG_PREEMPTION)
 	.trace_recursion = 0,
diff --git a/kernel/trace/fgraph.c b/kernel/trace/fgraph.c
index 73edb9e4f354..29a6ebeebc9e 100644
--- a/kernel/trace/fgraph.c
+++ b/kernel/trace/fgraph.c
@@ -394,7 +394,6 @@ static int alloc_retstack_tasklist(struct ftrace_ret_stack **ret_stack_list)
 		}
 
 		if (t->ret_stack == NULL) {
-			atomic_set(&t->tracing_graph_pause, 0);
 			atomic_set(&t->trace_overrun, 0);
 			t->curr_ret_stack = -1;
 			t->curr_ret_depth = -1;
@@ -489,7 +488,6 @@ static DEFINE_PER_CPU(struct ftrace_ret_stack *, idle_ret_stack);
 static void
 graph_init_task(struct task_struct *t, struct ftrace_ret_stack *ret_stack)
 {
-	atomic_set(&t->tracing_graph_pause, 0);
 	atomic_set(&t->trace_overrun, 0);
 	t->ftrace_timestamp = 0;
 	/* make curr_ret_stack visible before we add the ret_stack */
-- 
2.29.2


