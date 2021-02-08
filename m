Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B626431371F
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:21:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233699AbhBHPUU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:20:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:55764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231743AbhBHPNa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:13:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D44B64F00;
        Mon,  8 Feb 2021 15:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797030;
        bh=W4shUEBm82+PdHKxOiO3QIVumzaP82iQQXRNNA665Xg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OAR8gpy0+9Oy8wW/pVJ5ZSKaGWnKiDihrU1c2k7tLJBYv/yzODrAFIg6BnTN6c6o1
         5ZLl64Uz5B2+SY+kk9USNDb4VOaJncJoxa4wSG88rLjXgXpEY9pAHc4tAT+UwbDAwU
         ZwvDR/N4FeiijDQu9oaVTbUMRAi6YH2iMa7WwsCo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, pierre.gondois@arm.com,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.4 34/65] fgraph: Initialize tracing_graph_pause at task creation
Date:   Mon,  8 Feb 2021 16:01:06 +0100
Message-Id: <20210208145811.547133434@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145810.230485165@linuxfoundation.org>
References: <20210208145810.230485165@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

commit 7e0a9220467dbcfdc5bc62825724f3e52e50ab31 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 init/init_task.c      |    3 ++-
 kernel/trace/fgraph.c |    2 --
 2 files changed, 2 insertions(+), 3 deletions(-)

--- a/init/init_task.c
+++ b/init/init_task.c
@@ -171,7 +171,8 @@ struct task_struct init_task
 	.lockdep_recursion = 0,
 #endif
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
-	.ret_stack	= NULL,
+	.ret_stack		= NULL,
+	.tracing_graph_pause	= ATOMIC_INIT(0),
 #endif
 #if defined(CONFIG_TRACING) && defined(CONFIG_PREEMPTION)
 	.trace_recursion = 0,
--- a/kernel/trace/fgraph.c
+++ b/kernel/trace/fgraph.c
@@ -367,7 +367,6 @@ static int alloc_retstack_tasklist(struc
 		}
 
 		if (t->ret_stack == NULL) {
-			atomic_set(&t->tracing_graph_pause, 0);
 			atomic_set(&t->trace_overrun, 0);
 			t->curr_ret_stack = -1;
 			t->curr_ret_depth = -1;
@@ -462,7 +461,6 @@ static DEFINE_PER_CPU(struct ftrace_ret_
 static void
 graph_init_task(struct task_struct *t, struct ftrace_ret_stack *ret_stack)
 {
-	atomic_set(&t->tracing_graph_pause, 0);
 	atomic_set(&t->trace_overrun, 0);
 	t->ftrace_timestamp = 0;
 	/* make curr_ret_stack visible before we add the ret_stack */


