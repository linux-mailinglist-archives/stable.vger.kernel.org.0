Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7732B283A8D
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728260AbgJEPeR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 5 Oct 2020 11:34:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:34498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728238AbgJEPeD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:34:03 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE5F321707;
        Mon,  5 Oct 2020 15:34:02 +0000 (UTC)
Date:   Mon, 5 Oct 2020 11:34:01 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <gregkh@linuxfoundation.org>
Cc:     paulmck@kernel.org, peterz@infradead.org, <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] ftrace: Move RCU is watching check after
 recursion check" failed to apply to 4.14-stable tree
Message-ID: <20201005113401.67628dbf@gandalf.local.home>
In-Reply-To: <1601808916133245@kroah.com>
References: <1601808916133245@kroah.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 04 Oct 2020 12:55:16 +0200
<gregkh@linuxfoundation.org> wrote:

> The patch below does not apply to the 4.14-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h
> 

The below should work for 4.14 and 4.9.

-- Steve


From b40341fad6cc2daa195f8090fd3348f18fff640a Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Date: Tue, 29 Sep 2020 12:40:31 -0400
Subject: [PATCH] ftrace: Move RCU is watching check after recursion check

The first thing that the ftrace function callback helper functions should do
is to check for recursion. Peter Zijlstra found that when
"rcu_is_watching()" had its notrace removed, it caused perf function tracing
to crash. This is because the call of rcu_is_watching() is tested before
function recursion is checked and and if it is traced, it will cause an
infinite recursion loop.

rcu_is_watching() should still stay notrace, but to prevent this should
never had crashed in the first place. The recursion prevention must be the
first thing done in callback functions.

Link: https://lore.kernel.org/r/20200929112541.GM2628@hirez.programming.kicks-ass.net

Cc: stable@vger.kernel.org
Cc: Paul McKenney <paulmck@kernel.org>
Fixes: c68c0fa293417 ("ftrace: Have ftrace_ops_get_func() handle RCU and PER_CPU flags too")
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reported-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

Index: linux-test.git/kernel/trace/ftrace.c
===================================================================
--- linux-test.git.orig/kernel/trace/ftrace.c
+++ linux-test.git/kernel/trace/ftrace.c
@@ -6159,17 +6159,15 @@ static void ftrace_ops_assist_func(unsig
 {
 	int bit;
 
-	if ((op->flags & FTRACE_OPS_FL_RCU) && !rcu_is_watching())
-		return;
-
 	bit = trace_test_and_set_recursion(TRACE_LIST_START, TRACE_LIST_MAX);
 	if (bit < 0)
 		return;
 
 	preempt_disable_notrace();
 
-	if (!(op->flags & FTRACE_OPS_FL_PER_CPU) ||
-	    !ftrace_function_local_disabled(op)) {
+	if ((!(op->flags & FTRACE_OPS_FL_RCU) || rcu_is_watching()) &&
+	    (!(op->flags & FTRACE_OPS_FL_PER_CPU) ||
+	     !ftrace_function_local_disabled(op))) {
 		op->func(ip, parent_ip, op, regs);
 	}
 
