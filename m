Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA942D475D
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 18:01:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729639AbgLIRAc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 12:00:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:54766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728587AbgLIRAc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Dec 2020 12:00:32 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1756A23C43;
        Wed,  9 Dec 2020 16:59:51 +0000 (UTC)
Date:   Wed, 9 Dec 2020 11:59:49 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <gregkh@linuxfoundation.org>
Cc:     <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] tracing: Fix userstacktrace option for
 instances" failed to apply to 4.14-stable tree
Message-ID: <20201209115949.56766ea0@gandalf.local.home>
In-Reply-To: <160750307316291@kroah.com>
References: <160750307316291@kroah.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This should be the fix for 4.14.

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
@@ -2404,7 +2404,7 @@ void trace_buffer_unlock_commit_regs(str
 	 * two. They are that meaningful.
 	 */
 	ftrace_trace_stack(tr, buffer, flags, regs ? 0 : 4, pc, regs);
-	ftrace_trace_userstack(buffer, flags, pc);
+	ftrace_trace_userstack(tr, buffer, flags, pc);
 }
 
 /*
@@ -2734,14 +2734,15 @@ void trace_dump_stack(int skip)
 static DEFINE_PER_CPU(int, user_stack_count);
 
 void
-ftrace_trace_userstack(struct ring_buffer *buffer, unsigned long flags, int pc)
+ftrace_trace_userstack(struct trace_array *tr,
+		       struct ring_buffer *buffer, unsigned long flags, int pc)
 {
 	struct trace_event_call *call = &event_user_stack;
 	struct ring_buffer_event *event;
 	struct userstack_entry *entry;
 	struct stack_trace trace;
 
-	if (!(global_trace.trace_flags & TRACE_ITER_USERSTACKTRACE))
+	if (!(tr->trace_flags & TRACE_ITER_USERSTACKTRACE))
 		return;
 
 	/*
Index: linux-test.git/kernel/trace/trace.h
===================================================================
--- linux-test.git.orig/kernel/trace/trace.h
+++ linux-test.git/kernel/trace/trace.h
@@ -739,13 +739,15 @@ void update_max_tr_single(struct trace_a
 #endif /* CONFIG_TRACER_MAX_TRACE */
 
 #ifdef CONFIG_STACKTRACE
-void ftrace_trace_userstack(struct ring_buffer *buffer, unsigned long flags,
+void ftrace_trace_userstack(struct trace_array *tr,
+			    struct ring_buffer *buffer, unsigned long flags,
 			    int pc);
 
 void __trace_stack(struct trace_array *tr, unsigned long flags, int skip,
 		   int pc);
 #else
-static inline void ftrace_trace_userstack(struct ring_buffer *buffer,
+static inline void ftrace_trace_userstack(struct trace_array *tr,
+					  struct ring_buffer *buffer,
 					  unsigned long flags, int pc)
 {
 }
