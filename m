Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD9942A178C
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 14:09:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727409AbgJaNJe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 09:09:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:57908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727322AbgJaNJd (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 09:09:33 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCD6320825;
        Sat, 31 Oct 2020 13:09:32 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kYqdP-006Cmv-HT; Sat, 31 Oct 2020 09:09:31 -0400
Message-ID: <20201031130931.419089346@goodmis.org>
User-Agent: quilt/0.66
Date:   Sat, 31 Oct 2020 09:06:45 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>, Petr Mladek <pmladek@suse.com>,
        stable@vger.kernel.org
Subject: [for-linus][PATCH 3/3] ftrace: Handle tracing when switching between context
References: <20201031130642.971173960@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

When an interrupt or NMI comes in and switches the context, there's a delay
from when the preempt_count() shows the update. As the preempt_count() is
used to detect recursion having each context have its own bit get set when
tracing starts, and if that bit is already set, it is considered a recursion
and the function exits. But if this happens in that section where context
has changed but preempt_count() has not been updated, this will be
incorrectly flagged as a recursion.

To handle this case, create another bit call TRANSITION and test it if the
current context bit is already set. Flag the call as a recursion if the
TRANSITION bit is already set, and if not, set it and continue. The
TRANSITION bit will be cleared normally on the return of the function that
set it, or if the current context bit is clear, set it and clear the
TRANSITION bit to allow for another transition between the current context
and an even higher one.

Cc: stable@vger.kernel.org
Fixes: edc15cafcbfa3 ("tracing: Avoid unnecessary multiple recursion checks")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/trace/trace.h          | 23 +++++++++++++++++++++--
 kernel/trace/trace_selftest.c |  9 +++++++--
 2 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index fee535a89560..1dadef445cd1 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -637,6 +637,12 @@ enum {
 	 * function is called to clear it.
 	 */
 	TRACE_GRAPH_NOTRACE_BIT,
+
+	/*
+	 * When transitioning between context, the preempt_count() may
+	 * not be correct. Allow for a single recursion to cover this case.
+	 */
+	TRACE_TRANSITION_BIT,
 };
 
 #define trace_recursion_set(bit)	do { (current)->trace_recursion |= (1<<(bit)); } while (0)
@@ -691,8 +697,21 @@ static __always_inline int trace_test_and_set_recursion(int start, int max)
 		return 0;
 
 	bit = trace_get_context_bit() + start;
-	if (unlikely(val & (1 << bit)))
-		return -1;
+	if (unlikely(val & (1 << bit))) {
+		/*
+		 * It could be that preempt_count has not been updated during
+		 * a switch between contexts. Allow for a single recursion.
+		 */
+		bit = TRACE_TRANSITION_BIT;
+		if (trace_recursion_test(bit))
+			return -1;
+		trace_recursion_set(bit);
+		barrier();
+		return bit + 1;
+	}
+
+	/* Normal check passed, clear the transition to allow it again */
+	trace_recursion_clear(TRACE_TRANSITION_BIT);
 
 	val |= 1 << bit;
 	current->trace_recursion = val;
diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index b5e3496cf803..4738ad48a667 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -492,8 +492,13 @@ trace_selftest_function_recursion(void)
 	unregister_ftrace_function(&test_rec_probe);
 
 	ret = -1;
-	if (trace_selftest_recursion_cnt != 1) {
-		pr_cont("*callback not called once (%d)* ",
+	/*
+	 * Recursion allows for transitions between context,
+	 * and may call the callback twice.
+	 */
+	if (trace_selftest_recursion_cnt != 1 &&
+	    trace_selftest_recursion_cnt != 2) {
+		pr_cont("*callback not called once (or twice) (%d)* ",
 			trace_selftest_recursion_cnt);
 		goto out;
 	}
-- 
2.28.0


