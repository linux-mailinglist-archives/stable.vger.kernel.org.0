Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 225883216DC
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:39:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230447AbhBVMh6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:37:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:52350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231197AbhBVMhl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:37:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1853E64E24;
        Mon, 22 Feb 2021 12:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613997420;
        bh=wGfNUVQGKijfz3TfNQUC5tVSc5ZoTCa14SvtoPK49Z0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zsOeKOM8k22zB6vz8Vi55TuzIyCzQIBBJlXYjZltelketIB43H8Ck9G0DtN5P3ChW
         mBW6TGtFbJQYyNT83pcTKd+cv1TySDO25J81jIXMnue5wbSRbtXU0gubeiY2hJdJOl
         i2G4SyP/SDh2+Qk6XPVM8zOzXjdygT2DVWaV9E1Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, pierre.gondois@arm.com,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 4.14 01/57] fgraph: Initialize tracing_graph_pause at task creation
Date:   Mon, 22 Feb 2021 13:35:27 +0100
Message-Id: <20210222121027.282518698@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121027.174911182@linuxfoundation.org>
References: <20210222121027.174911182@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
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
@@ -792,7 +792,9 @@ typedef int (*trace_func_graph_ent_t)(st
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
@@ -6666,7 +6666,6 @@ static int alloc_retstack_tasklist(struc
 		}
 
 		if (t->ret_stack == NULL) {
-			atomic_set(&t->tracing_graph_pause, 0);
 			atomic_set(&t->trace_overrun, 0);
 			t->curr_ret_stack = -1;
 			/* Make sure the tasks see the -1 first: */
@@ -6878,7 +6877,6 @@ static DEFINE_PER_CPU(struct ftrace_ret_
 static void
 graph_init_task(struct task_struct *t, struct ftrace_ret_stack *ret_stack)
 {
-	atomic_set(&t->tracing_graph_pause, 0);
 	atomic_set(&t->trace_overrun, 0);
 	t->ftrace_timestamp = 0;
 	/* make curr_ret_stack visible before we add the ret_stack */


