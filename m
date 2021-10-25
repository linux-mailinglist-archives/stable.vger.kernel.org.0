Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5F63439F73
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232427AbhJYTUl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:20:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:37868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234410AbhJYTTs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:19:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E36F610CB;
        Mon, 25 Oct 2021 19:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635189446;
        bh=ebURVFVyb3ejP3rzmOU9QcaG2D/ubbXF4hpcGSVorao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WwDUWdNnieSRQb9ZtuzA6JtvetVOUEr0CSIExUnd2S3vUxG1+jZck1vHapZJZT1iX
         Yt1CKmOIw7aPTKya+aocr40klJHSJMUB2F7+fAq5aCj+9Movn7YKVON5UOh9yv0vVz
         BuIkkjYuTtTna9n2AQV2eCClDaqrG0KQQjAz7ru4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Petr Mladek <pmladek@suse.com>, Ingo Molnar <mingo@redhat.com>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        Helge Deller <deller@gmx.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Colin Ian King <colin.king@canonical.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Jisheng Zhang <jszhang@kernel.org>,
        =?utf-8?b?546L6LSH?= <yun.wang@linux.alibaba.com>,
        Guo Ren <guoren@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 4.4 43/44] tracing: Have all levels of checks prevent recursion
Date:   Mon, 25 Oct 2021 21:14:24 +0200
Message-Id: <20211025190937.271718793@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190928.054676643@linuxfoundation.org>
References: <20211025190928.054676643@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

commit ed65df63a39a3f6ed04f7258de8b6789e5021c18 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/ftrace.c          |    4 +-
 kernel/trace/trace.h           |   64 ++++++++++++-----------------------------
 kernel/trace/trace_functions.c |    2 -
 3 files changed, 23 insertions(+), 47 deletions(-)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -5185,7 +5185,7 @@ __ftrace_ops_list_func(unsigned long ip,
 	struct ftrace_ops *op;
 	int bit;
 
-	bit = trace_test_and_set_recursion(TRACE_LIST_START, TRACE_LIST_MAX);
+	bit = trace_test_and_set_recursion(TRACE_LIST_START);
 	if (bit < 0)
 		return;
 
@@ -5246,7 +5246,7 @@ static void ftrace_ops_recurs_func(unsig
 {
 	int bit;
 
-	bit = trace_test_and_set_recursion(TRACE_LIST_START, TRACE_LIST_MAX);
+	bit = trace_test_and_set_recursion(TRACE_LIST_START);
 	if (bit < 0)
 		return;
 
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -431,23 +431,8 @@ struct tracer {
  *  When function tracing occurs, the following steps are made:
  *   If arch does not support a ftrace feature:
  *    call internal function (uses INTERNAL bits) which calls...
- *   If callback is registered to the "global" list, the list
- *    function is called and recursion checks the GLOBAL bits.
- *    then this function calls...
  *   The function callback, which can use the FTRACE bits to
  *    check for recursion.
- *
- * Now if the arch does not suppport a feature, and it calls
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
 	TRACE_BUFFER_BIT,
@@ -460,12 +445,14 @@ enum {
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
 
 	TRACE_CONTROL_BIT,
 
@@ -478,12 +465,6 @@ enum {
  * can only be modified by current, we can reuse trace_recursion.
  */
 	TRACE_IRQ_BIT,
-
-	/*
-	 * When transitioning between context, the preempt_count() may
-	 * not be correct. Allow for a single recursion to cover this case.
-	 */
-	TRACE_TRANSITION_BIT,
 };
 
 #define trace_recursion_set(bit)	do { (current)->trace_recursion |= (1<<(bit)); } while (0)
@@ -493,12 +474,18 @@ enum {
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
@@ -506,59 +493,48 @@ static __always_inline int trace_get_con
 
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
 
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -137,7 +137,7 @@ function_trace_call(unsigned long ip, un
 	pc = preempt_count();
 	preempt_disable_notrace();
 
-	bit = trace_test_and_set_recursion(TRACE_FTRACE_START, TRACE_FTRACE_MAX);
+	bit = trace_test_and_set_recursion(TRACE_FTRACE_START);
 	if (bit < 0)
 		goto out;
 


