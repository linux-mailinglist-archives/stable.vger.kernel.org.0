Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C1492D5E02
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 15:37:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391007AbgLJOg0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 09:36:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:43700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727337AbgLJOgS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:36:18 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.4 41/54] tracing: Fix userstacktrace option for instances
Date:   Thu, 10 Dec 2020 15:27:18 +0100
Message-Id: <20201210142604.055294717@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210142602.037095225@linuxfoundation.org>
References: <20201210142602.037095225@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

commit bcee5278958802b40ee8b26679155a6d9231783e upstream.

When the instances were able to use their own options, the userstacktrace
option was left hardcoded for the top level. This made the instance
userstacktrace option bascially into a nop, and will confuse users that set
it, but nothing happens (I was confused when it happened to me!)

Cc: stable@vger.kernel.org
Fixes: 16270145ce6b ("tracing: Add trace options for core options to instances")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/trace.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
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


