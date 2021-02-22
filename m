Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9936532173C
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:46:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231664AbhBVMop (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:44:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:52847 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231386AbhBVMmO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:42:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9CE0964E2F;
        Mon, 22 Feb 2021 12:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613997579;
        bh=mOZrxsMuS8Iyo28/X7/ikWnVHoRzhoKOzgfbwmCkz3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iWQUcligh5Syn9mir1nX3gJvck+IW8Fc6+2axE2vRBanio/KVK6gKVUrE4wFt2lLR
         OjnEiUJ9OBJRE/ZgYjqw8gMA0HJifnTWGUZE9KuCSMa7c6uPVPNo+yxkemtADGMuKk
         ijmdrftZQw/S84pcmS8k+Lfz3Q6/5SnBcTgvzY40=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, pierre.gondois@arm.com,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 4.4 02/35] fgraph: Initialize tracing_graph_pause at task creation
Date:   Mon, 22 Feb 2021 13:35:58 +0100
Message-Id: <20210222121017.542227125@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121013.581198717@linuxfoundation.org>
References: <20210222121013.581198717@linuxfoundation.org>
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
 include/linux/ftrace.h |    4 +++-
 kernel/trace/ftrace.c  |    2 --
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -747,7 +747,9 @@ typedef int (*trace_func_graph_ent_t)(st
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 
 /* for init task */
-#define INIT_FTRACE_GRAPH		.ret_stack = NULL,
+#define INIT_FTRACE_GRAPH				\
+	.ret_stack		= NULL,			\
+	.tracing_graph_pause	= ATOMIC_INIT(0),
 
 /*
  * Stack of return addresses for functions
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -5708,7 +5708,6 @@ static int alloc_retstack_tasklist(struc
 		}
 
 		if (t->ret_stack == NULL) {
-			atomic_set(&t->tracing_graph_pause, 0);
 			atomic_set(&t->trace_overrun, 0);
 			t->curr_ret_stack = -1;
 			/* Make sure the tasks see the -1 first: */
@@ -5920,7 +5919,6 @@ static DEFINE_PER_CPU(struct ftrace_ret_
 static void
 graph_init_task(struct task_struct *t, struct ftrace_ret_stack *ret_stack)
 {
-	atomic_set(&t->tracing_graph_pause, 0);
 	atomic_set(&t->trace_overrun, 0);
 	t->ftrace_timestamp = 0;
 	/* make curr_ret_stack visible before we add the ret_stack */


