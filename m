Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 996BB4397FB
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 15:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233103AbhJYOBJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 10:01:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:52282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233125AbhJYOBJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 10:01:09 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE62560F46;
        Mon, 25 Oct 2021 13:58:43 +0000 (UTC)
Date:   Mon, 25 Oct 2021 09:58:42 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <gregkh@linuxfoundation.org>
Cc:     James.Bottomley@hansenpartnership.com, aou@eecs.berkeley.edu,
        benh@kernel.crashing.org, bp@alien8.de, colin.king@canonical.com,
        deller@gmx.de, guoren@kernel.org, hpa@zytor.com, jikos@kernel.org,
        joe.lawrence@redhat.com, jpoimboe@redhat.com, jszhang@kernel.org,
        mbenes@suse.cz, mhiramat@kernel.org, mingo@redhat.com,
        mpe@ellerman.id.au, npiggin@gmail.com, palmer@dabbelt.com,
        paul.walmsley@sifive.com, paulus@samba.org, peterz@infradead.org,
        pmladek@suse.com, tglx@linutronix.de,
        torvalds@linux-foundation.org, yun.wang@linux.alibaba.com,
        <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] tracing: Have all levels of checks
 prevent recursion" failed to apply to 5.10-stable tree
Message-ID: <20211025095842.610f4244@gandalf.local.home>
In-Reply-To: <1635075011165189@kroah.com>
References: <1635075011165189@kroah.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 24 Oct 2021 13:30:11 +0200
<gregkh@linuxfoundation.org> wrote:

> The patch below does not apply to the 5.10-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h
> 

The below should be the fix for 5.10.

-- Steve


>From ed65df63a39a3f6ed04f7258de8b6789e5021c18 Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Date: Mon, 18 Oct 2021 15:44:12 -0400
Subject: [PATCH] tracing: Have all levels of checks prevent recursion

While writing an email explaining the "bit = 0" logic for a discussion on
making ftrace_test_recursion_trylock() disable preemption, I discovered a
path that makes the "not do the logic if bit is zero" unsafe.

The recursion logic is done in hot paths like the function tracer. Thus,
any code executed causes noticeable overhead. Thus, tricks are done to try
to limit the amount of code executed. This included the recursion testing
logic.

Having recursion testing is important, as there are many paths that can
end up in an infinite recursion cycle when tracing every function in the
kernel. Thus protection is needed to prevent that from happening.

Because it is OK to recurse due to different running context levels (e.g.
an interrupt preempts a trace, and then a trace occurs in the interrupt
handler), a set of bits are used to know which context one is in (normal,
softirq, irq and NMI). If a recursion occurs in the same level, it is
prevented*.

Then there are infrastructure levels of recursion as well. When more than
one callback is attached to the same function to trace, it calls a loop
function to iterate over all the callbacks. Both the callbacks and the
loop function have recursion protection. The callbacks use the
"ftrace_test_recursion_trylock()" which has a "function" set of context
bits to test, and the loop function calls the internal
trace_test_and_set_recursion() directly, with an "internal" set of bits.

If an architecture does not implement all the features supported by ftrace
then the callbacks are never called directly, and the loop function is
called instead, which will implement the features of ftrace.

Since both the loop function and the callbacks do recursion protection, it
was seemed unnecessary to do it in both locations. Thus, a trick was made
to have the internal set of recursion bits at a more significant bit
location than the function bits. Then, if any of the higher bits were set,
the logic of the function bits could be skipped, as any new recursion
would first have to go through the loop function.

This is true for architectures that do not support all the ftrace
features, because all functions being traced must first go through the
loop function before going to the callbacks. But this is not true for
architectures that support all the ftrace features. That's because the
loop function could be called due to two callbacks attached to the same
function, but then a recursion function inside the callback could be
called that does not share any other callback, and it will be called
directly.

i.e.

 traced_function_1: [ more than one callback tracing it ]
   call loop_func

 loop_func:
   trace_recursion set internal bit
   call callback

 callback:
   trace_recursion [ skipped because internal bit is set, return 0 ]
   call traced_function_2

 traced_function_2: [ only traced by above callback ]
   call callback

 callback:
   trace_recursion [ skipped because internal bit is set, return 0 ]
   call traced_function_2

 [ wash, rinse, repeat, BOOM! out of shampoo! ]

Thus, the "bit == 0 skip" trick is not safe, unless the loop function is
call for all functions.

Since we want to encourage architectures to implement all ftrace features,
having them slow down due to this extra logic may encourage the
maintainers to update to the latest ftrace features. And because this
logic is only safe for them, remove it completely.

 [*] There is on layer of recursion that is allowed, and that is to allow
     for the transition between interrupt context (normal -> softirq ->
     irq -> NMI), because a trace may occur before the context update is
     visible to the trace recursion logic.

Link: https://lore.kernel.org/all/609b565a-ed6e-a1da-f025-166691b5d994@linux.alibaba.com/
Link: https://lkml.kernel.org/r/20211018154412.09fcad3c@gandalf.local.home

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Jiri Kosina <jikos@kernel.org>
Cc: Miroslav Benes <mbenes@suse.cz>
Cc: Joe Lawrence <joe.lawrence@redhat.com>
Cc: Colin Ian King <colin.king@canonical.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Jisheng Zhang <jszhang@kernel.org>
Cc: =?utf-8?b?546L6LSH?= <yun.wang@linux.alibaba.com>
Cc: Guo Ren <guoren@kernel.org>
Cc: stable@vger.kernel.org
Fixes: edc15cafcbfa3 ("tracing: Avoid unnecessary multiple recursion checks")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

Index: linux-test.git/kernel/trace/trace.h
===================================================================
--- linux-test.git.orig/kernel/trace/trace.h
+++ linux-test.git/kernel/trace/trace.h
@@ -573,18 +573,6 @@ struct tracer {
  *    then this function calls...
  *   The function callback, which can use the FTRACE bits to
  *    check for recursion.
- *
- * Now if the arch does not support a feature, and it calls
- * the global list function which calls the ftrace callback
- * all three of these steps will do a recursion protection.
- * There's no reason to do one if the previous caller already
- * did. The recursion that we are protecting against will
- * go through the same steps again.
- *
- * To prevent the multiple recursion checks, if a recursion
- * bit is set that is higher than the MAX bit of the current
- * check, then we know that the check was made by the previous
- * caller, and we can skip the current check.
  */
 enum {
 	/* Function recursion bits */
@@ -592,12 +580,14 @@ enum {
 	TRACE_FTRACE_NMI_BIT,
 	TRACE_FTRACE_IRQ_BIT,
 	TRACE_FTRACE_SIRQ_BIT,
+	TRACE_FTRACE_TRANSITION_BIT,
 
-	/* INTERNAL_BITs must be greater than FTRACE_BITs */
+	/* Internal use recursion bits */
 	TRACE_INTERNAL_BIT,
 	TRACE_INTERNAL_NMI_BIT,
 	TRACE_INTERNAL_IRQ_BIT,
 	TRACE_INTERNAL_SIRQ_BIT,
+	TRACE_INTERNAL_TRANSITION_BIT,
 
 	TRACE_BRANCH_BIT,
 /*
@@ -637,12 +627,6 @@ enum {
 	 * function is called to clear it.
 	 */
 	TRACE_GRAPH_NOTRACE_BIT,
-
-	/*
-	 * When transitioning between context, the preempt_count() may
-	 * not be correct. Allow for a single recursion to cover this case.
-	 */
-	TRACE_TRANSITION_BIT,
 };
 
 #define trace_recursion_set(bit)	do { (current)->trace_recursion |= (1<<(bit)); } while (0)
@@ -662,12 +646,18 @@ enum {
 #define TRACE_CONTEXT_BITS	4
 
 #define TRACE_FTRACE_START	TRACE_FTRACE_BIT
-#define TRACE_FTRACE_MAX	((1 << (TRACE_FTRACE_START + TRACE_CONTEXT_BITS)) - 1)
 
 #define TRACE_LIST_START	TRACE_INTERNAL_BIT
-#define TRACE_LIST_MAX		((1 << (TRACE_LIST_START + TRACE_CONTEXT_BITS)) - 1)
 
-#define TRACE_CONTEXT_MASK	TRACE_LIST_MAX
+#define TRACE_CONTEXT_MASK	((1 << (TRACE_LIST_START + TRACE_CONTEXT_BITS)) - 1)
+
+enum {
+	TRACE_CTX_NMI,
+	TRACE_CTX_IRQ,
+	TRACE_CTX_SOFTIRQ,
+	TRACE_CTX_NORMAL,
+	TRACE_CTX_TRANSITION,
+};
 
 static __always_inline int trace_get_context_bit(void)
 {
@@ -675,59 +665,48 @@ static __always_inline int trace_get_con
 
 	if (in_interrupt()) {
 		if (in_nmi())
-			bit = 0;
+			bit = TRACE_CTX_NMI;
 
 		else if (in_irq())
-			bit = 1;
+			bit = TRACE_CTX_IRQ;
 		else
-			bit = 2;
+			bit = TRACE_CTX_SOFTIRQ;
 	} else
-		bit = 3;
+		bit = TRACE_CTX_NORMAL;
 
 	return bit;
 }
 
-static __always_inline int trace_test_and_set_recursion(int start, int max)
+static __always_inline int trace_test_and_set_recursion(int start)
 {
 	unsigned int val = current->trace_recursion;
 	int bit;
 
-	/* A previous recursion check was made */
-	if ((val & TRACE_CONTEXT_MASK) > max)
-		return 0;
-
 	bit = trace_get_context_bit() + start;
 	if (unlikely(val & (1 << bit))) {
 		/*
 		 * It could be that preempt_count has not been updated during
 		 * a switch between contexts. Allow for a single recursion.
 		 */
-		bit = TRACE_TRANSITION_BIT;
+		bit = start + TRACE_CTX_TRANSITION;
 		if (trace_recursion_test(bit))
 			return -1;
 		trace_recursion_set(bit);
 		barrier();
-		return bit + 1;
+		return bit;
 	}
 
-	/* Normal check passed, clear the transition to allow it again */
-	trace_recursion_clear(TRACE_TRANSITION_BIT);
-
 	val |= 1 << bit;
 	current->trace_recursion = val;
 	barrier();
 
-	return bit + 1;
+	return bit;
 }
 
 static __always_inline void trace_clear_recursion(int bit)
 {
 	unsigned int val = current->trace_recursion;
 
-	if (!bit)
-		return;
-
-	bit--;
 	bit = 1 << bit;
 	val &= ~bit;
 
Index: linux-test.git/kernel/trace/ftrace.c
===================================================================
--- linux-test.git.orig/kernel/trace/ftrace.c
+++ linux-test.git/kernel/trace/ftrace.c
@@ -6985,7 +6985,7 @@ __ftrace_ops_list_func(unsigned long ip,
 	struct ftrace_ops *op;
 	int bit;
 
-	bit = trace_test_and_set_recursion(TRACE_LIST_START, TRACE_LIST_MAX);
+	bit = trace_test_and_set_recursion(TRACE_LIST_START);
 	if (bit < 0)
 		return;
 
@@ -7060,7 +7060,7 @@ static void ftrace_ops_assist_func(unsig
 {
 	int bit;
 
-	bit = trace_test_and_set_recursion(TRACE_LIST_START, TRACE_LIST_MAX);
+	bit = trace_test_and_set_recursion(TRACE_LIST_START);
 	if (bit < 0)
 		return;
 
Index: linux-test.git/kernel/trace/trace_functions.c
===================================================================
--- linux-test.git.orig/kernel/trace/trace_functions.c
+++ linux-test.git/kernel/trace/trace_functions.c
@@ -144,7 +144,7 @@ function_trace_call(unsigned long ip, un
 	pc = preempt_count();
 	preempt_disable_notrace();
 
-	bit = trace_test_and_set_recursion(TRACE_FTRACE_START, TRACE_FTRACE_MAX);
+	bit = trace_test_and_set_recursion(TRACE_FTRACE_START);
 	if (bit < 0)
 		goto out;
 
