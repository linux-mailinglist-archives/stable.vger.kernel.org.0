Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BC352D475A
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 18:01:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730902AbgLIRAG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 12:00:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:54450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732098AbgLIQ7j (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Dec 2020 11:59:39 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 16DD523C43;
        Wed,  9 Dec 2020 16:58:59 +0000 (UTC)
Date:   Wed, 9 Dec 2020 11:58:57 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <gregkh@linuxfoundation.org>
Cc:     <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] tracing: Fix userstacktrace option for
 instances" failed to apply to 5.4-stable tree
Message-ID: <20201209115857.19aca347@gandalf.local.home>
In-Reply-To: <160750307485180@kroah.com>
References: <160750307485180@kroah.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This should be the fix for 5.4.

-- Steve


>From bcee5278958802b40ee8b26679155a6d9231783e Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Date: Fri, 4 Dec 2020 16:36:16 -0500
Subject: [PATCH] tracing: Fix userstacktrace option for instances

When the instances were able to use their own options, the userstacktrace
option was left hardcoded for the top level. This made the instance
userstacktrace option bascially into a nop, and will confuse users that set
it, but nothing happens (I was confused when it happened to me!)

Cc: stable@vger.kernel.org
Fixes: 16270145ce6b ("tracing: Add trace options for core options to instances")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

Index: linux-test.git/kernel/trace/trace.c
===================================================================
--- linux-test.git.orig/kernel/trace/trace.c
+++ linux-test.git/kernel/trace/trace.c
@@ -160,7 +160,8 @@ static union trace_eval_map_item *trace_
 #endif /* CONFIG_TRACE_EVAL_MAP_FILE */
 
 static int tracing_set_tracer(struct trace_array *tr, const char *buf);
-static void ftrace_trace_userstack(struct ring_buffer *buffer,
+static void ftrace_trace_userstack(struct trace_array *tr,
+				   struct ring_buffer *buffer,
 				   unsigned long flags, int pc);
 
 #define MAX_TRACER_SIZE		100
@@ -2621,7 +2622,7 @@ void trace_buffer_unlock_commit_regs(str
 	 * two. They are not that meaningful.
 	 */
 	ftrace_trace_stack(tr, buffer, flags, regs ? 0 : STACK_SKIP, pc, regs);
-	ftrace_trace_userstack(buffer, flags, pc);
+	ftrace_trace_userstack(tr, buffer, flags, pc);
 }
 
 /*
@@ -2936,13 +2937,14 @@ EXPORT_SYMBOL_GPL(trace_dump_stack);
 static DEFINE_PER_CPU(int, user_stack_count);
 
 static void
-ftrace_trace_userstack(struct ring_buffer *buffer, unsigned long flags, int pc)
+ftrace_trace_userstack(struct trace_array *tr,
+		       struct ring_buffer *buffer, unsigned long flags, int pc)
 {
 	struct trace_event_call *call = &event_user_stack;
 	struct ring_buffer_event *event;
 	struct userstack_entry *entry;
 
-	if (!(global_trace.trace_flags & TRACE_ITER_USERSTACKTRACE))
+	if (!(tr->trace_flags & TRACE_ITER_USERSTACKTRACE))
 		return;
 
 	/*
@@ -2981,7 +2983,8 @@ ftrace_trace_userstack(struct ring_buffe
 	preempt_enable();
 }
 #else /* CONFIG_USER_STACKTRACE_SUPPORT */
-static void ftrace_trace_userstack(struct ring_buffer *buffer,
+static void ftrace_trace_userstack(struct trace_array *tr,
+				   struct ring_buffer *buffer,
 				   unsigned long flags, int pc)
 {
 }
