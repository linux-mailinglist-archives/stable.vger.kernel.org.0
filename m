Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA882AB97C
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:09:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731266AbgKINJp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:09:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:34774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731286AbgKINJn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:09:43 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88CFE2083B;
        Mon,  9 Nov 2020 13:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927382;
        bh=M93C0WxoUZjVjd1QMB2wolPFvM6MJqaX+RFl+yae1ug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uWFH/d/IjwzUmBvk7I7+zr9CyP8ozsgj+f9qWv3ASJ9O5YR7cO89NU0BUQjIMY7IA
         a5nE+1jKsef8gSCQKp6j1fgfUkf8nSj1mlPahAPhnixXv20HMJEVn2D6cKVdk77pBX
         57l5a3JI05YcZaWsEH1YeqWE6vrBOvH7ylNOvRTg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 4.19 41/71] ring-buffer: Fix recursion protection transitions between interrupt context
Date:   Mon,  9 Nov 2020 13:55:35 +0100
Message-Id: <20201109125021.834412935@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125019.906191744@linuxfoundation.org>
References: <20201109125019.906191744@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

commit b02414c8f045ab3b9afc816c3735bc98c5c3d262 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/ring_buffer.c |   58 +++++++++++++++++++++++++++++++++++----------
 1 file changed, 46 insertions(+), 12 deletions(-)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -444,14 +444,16 @@ struct rb_event_info {
 
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
@@ -2620,10 +2622,10 @@ rb_wakeups(struct ring_buffer *buffer, s
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
@@ -2646,6 +2648,30 @@ rb_wakeups(struct ring_buffer *buffer, s
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
@@ -2661,8 +2687,16 @@ trace_recursive_lock(struct ring_buffer_
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
@@ -2677,8 +2711,8 @@ trace_recursive_unlock(struct ring_buffe
 		cpu_buffer->current_context - (1 << cpu_buffer->nest);
 }
 
-/* The recursive locking above uses 4 bits */
-#define NESTED_BITS 4
+/* The recursive locking above uses 5 bits */
+#define NESTED_BITS 5
 
 /**
  * ring_buffer_nest_start - Allow to trace while nested


