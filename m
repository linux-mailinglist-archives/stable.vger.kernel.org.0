Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D47122A8378
	for <lists+stable@lfdr.de>; Thu,  5 Nov 2020 17:26:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731234AbgKEQZt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Nov 2020 11:25:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:45168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725998AbgKEQZs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Nov 2020 11:25:48 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9CBC92080D;
        Thu,  5 Nov 2020 16:25:47 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kai54-007Pdh-7g; Thu, 05 Nov 2020 11:25:46 -0500
Message-ID: <20201105162546.069754582@goodmis.org>
User-Agent: quilt/0.66
Date:   Thu, 05 Nov 2020 11:25:00 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org
Subject: [for-linus][PATCH 2/4] ring-buffer: Fix recursion protection transitions between interrupt
 context
References: <20201105162458.408429167@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

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
---
 kernel/trace/ring_buffer.c | 58 ++++++++++++++++++++++++++++++--------
 1 file changed, 46 insertions(+), 12 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 7f45fd9d5a45..dc83b3fa9fe7 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -438,14 +438,16 @@ enum {
 };
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
@@ -3014,10 +3016,10 @@ rb_wakeups(struct trace_buffer *buffer, struct ring_buffer_per_cpu *cpu_buffer)
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
@@ -3040,6 +3042,30 @@ rb_wakeups(struct trace_buffer *buffer, struct ring_buffer_per_cpu *cpu_buffer)
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
@@ -3055,8 +3081,16 @@ trace_recursive_lock(struct ring_buffer_per_cpu *cpu_buffer)
 		bit = pc & NMI_MASK ? RB_CTX_NMI :
 			pc & HARDIRQ_MASK ? RB_CTX_IRQ : RB_CTX_SOFTIRQ;
 
-	if (unlikely(val & (1 << (bit + cpu_buffer->nest))))
-		return 1;
+	if (unlikely(val & (1 << (bit + cpu_buffer->nest)))) {
+		/*
+		 * It is possible that this was called by transitioning
+		 * between interrupt context, and preempt_count() has not
+		 * been updated yet. In this case, use the TRANSITION bit.
+		 */
+		bit = RB_CTX_TRANSITION;
+		if (val & (1 << (bit + cpu_buffer->nest)))
+			return 1;
+	}
 
 	val |= (1 << (bit + cpu_buffer->nest));
 	cpu_buffer->current_context = val;
@@ -3071,8 +3105,8 @@ trace_recursive_unlock(struct ring_buffer_per_cpu *cpu_buffer)
 		cpu_buffer->current_context - (1 << cpu_buffer->nest);
 }
 
-/* The recursive locking above uses 4 bits */
-#define NESTED_BITS 4
+/* The recursive locking above uses 5 bits */
+#define NESTED_BITS 5
 
 /**
  * ring_buffer_nest_start - Allow to trace while nested
-- 
2.28.0


