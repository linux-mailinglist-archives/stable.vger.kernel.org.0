Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29B222AC1F1
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 18:18:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730189AbgKIRSc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 12:18:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:33978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729432AbgKIRSc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 12:18:32 -0500
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81D8120E65;
        Mon,  9 Nov 2020 17:18:30 +0000 (UTC)
Date:   Mon, 9 Nov 2020 12:18:28 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <gregkh@linuxfoundation.org>
Cc:     <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] ring-buffer: Fix recursion protection
 transitions between" failed to apply to 4.14-stable tree
Message-ID: <20201109121828.4bf8bd2e@oasis.local.home>
In-Reply-To: <1604763982232117@kroah.com>
References: <1604763982232117@kroah.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 07 Nov 2020 16:46:22 +0100
<gregkh@linuxfoundation.org> wrote:

> The patch below does not apply to the 4.14-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 


This should work for 4.14, 4.9 and 4.4:

-- Steve

>From b02414c8f045ab3b9afc816c3735bc98c5c3d262 Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Date: Mon, 2 Nov 2020 15:31:27 -0500
Subject: [PATCH] ring-buffer: Fix recursion protection transitions between
 interrupt context

The recursion protection of the ring buffer depends on preempt_count() to be
correct. But it is possible that the ring buffer gets called after an
interrupt comes in but before it updates the preempt_count(). This will
trigger a false positive in the recursion code.

Use the same trick from the ftrace function callback recursion code which
uses a "transition" bit that gets set, to allow for a single recursion for
to handle transitions between contexts.

Cc: stable@vger.kernel.org
Fixes: 567cd4da54ff4 ("ring-buffer: User context bit recursion checking")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

Index: linux-test.git/kernel/trace/ring_buffer.c
===================================================================
--- linux-test.git.orig/kernel/trace/ring_buffer.c
+++ linux-test.git/kernel/trace/ring_buffer.c
@@ -416,14 +416,16 @@ struct rb_event_info {
 
 /*
  * Used for which event context the event is in.
- *  NMI     = 0
- *  IRQ     = 1
- *  SOFTIRQ = 2
- *  NORMAL  = 3
+ *  TRANSITION = 0
+ *  NMI     = 1
+ *  IRQ     = 2
+ *  SOFTIRQ = 3
+ *  NORMAL  = 4
  *
  * See trace_recursive_lock() comment below for more details.
  */
 enum {
+	RB_CTX_TRANSITION,
 	RB_CTX_NMI,
 	RB_CTX_IRQ,
 	RB_CTX_SOFTIRQ,
@@ -2553,10 +2555,10 @@ rb_wakeups(struct ring_buffer *buffer, s
  * a bit of overhead in something as critical as function tracing,
  * we use a bitmask trick.
  *
- *  bit 0 =  NMI context
- *  bit 1 =  IRQ context
- *  bit 2 =  SoftIRQ context
- *  bit 3 =  normal context.
+ *  bit 1 =  NMI context
+ *  bit 2 =  IRQ context
+ *  bit 3 =  SoftIRQ context
+ *  bit 4 =  normal context.
  *
  * This works because this is the order of contexts that can
  * preempt other contexts. A SoftIRQ never preempts an IRQ
@@ -2579,6 +2581,30 @@ rb_wakeups(struct ring_buffer *buffer, s
  * The least significant bit can be cleared this way, and it
  * just so happens that it is the same bit corresponding to
  * the current context.
+ *
+ * Now the TRANSITION bit breaks the above slightly. The TRANSITION bit
+ * is set when a recursion is detected at the current context, and if
+ * the TRANSITION bit is already set, it will fail the recursion.
+ * This is needed because there's a lag between the changing of
+ * interrupt context and updating the preempt count. In this case,
+ * a false positive will be found. To handle this, one extra recursion
+ * is allowed, and this is done by the TRANSITION bit. If the TRANSITION
+ * bit is already set, then it is considered a recursion and the function
+ * ends. Otherwise, the TRANSITION bit is set, and that bit is returned.
+ *
+ * On the trace_recursive_unlock(), the TRANSITION bit will be the first
+ * to be cleared. Even if it wasn't the context that set it. That is,
+ * if an interrupt comes in while NORMAL bit is set and the ring buffer
+ * is called before preempt_count() is updated, since the check will
+ * be on the NORMAL bit, the TRANSITION bit will then be set. If an
+ * NMI then comes in, it will set the NMI bit, but when the NMI code
+ * does the trace_recursive_unlock() it will clear the TRANSTION bit
+ * and leave the NMI bit set. But this is fine, because the interrupt
+ * code that set the TRANSITION bit will then clear the NMI bit when it
+ * calls trace_recursive_unlock(). If another NMI comes in, it will
+ * set the TRANSITION bit and continue.
+ *
+ * Note: The TRANSITION bit only handles a single transition between context.
  */
 
 static __always_inline int
@@ -2597,8 +2623,16 @@ trace_recursive_lock(struct ring_buffer_
 	} else
 		bit = RB_CTX_NORMAL;
 
-	if (unlikely(val & (1 << bit)))
-		return 1;
+	if (unlikely(val & (1 << bit))) {
+		/*
+		 * It is possible that this was called by transitioning
+		 * between interrupt context, and preempt_count() has not
+		 * been updated yet. In this case, use the TRANSITION bit.
+		 */
+		bit = RB_CTX_TRANSITION;
+		if (val & (1 << bit))
+			return 1;
+	}
 
 	val |= (1 << bit);
 	cpu_buffer->current_context = val;
