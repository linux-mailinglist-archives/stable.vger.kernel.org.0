Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B17AF2B607F
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:10:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728953AbgKQNJy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:09:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:39002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728909AbgKQNJw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:09:52 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 389F22468F;
        Tue, 17 Nov 2020 13:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605618590;
        bh=kFN26FCoJ5RTYz+C+KKLivP3ft7QRNyOIj+tOTU76/Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zihotvrBPu/UztprRNj/NMo7mttLsLJ2RvMaCfjao9LWn8o9nEOUtNZJtuI/NrWxI
         laTFi8XtOMJYPZr2pa5xOsYYZuOfgV2vUi2C/aErUjlNo/oajIV4dtU3EjEiWsUH+h
         wvDmc7rW/Yr1pQ/WPXG7DCSkHCGpN6akny2RT6Fo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 02/78] ring-buffer: Fix recursion protection transitions between interrupt context
Date:   Tue, 17 Nov 2020 14:04:28 +0100
Message-Id: <20201117122109.242183249@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122109.116890262@linuxfoundation.org>
References: <20201117122109.116890262@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

[ Upstream commit b02414c8f045ab3b9afc816c3735bc98c5c3d262 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/ring_buffer.c | 54 +++++++++++++++++++++++++++++++-------
 1 file changed, 44 insertions(+), 10 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index fb2aa2430edcc..55f60d2edc3fb 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
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
@@ -2579,10 +2581,10 @@ rb_wakeups(struct ring_buffer *buffer, struct ring_buffer_per_cpu *cpu_buffer)
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
@@ -2605,6 +2607,30 @@ rb_wakeups(struct ring_buffer *buffer, struct ring_buffer_per_cpu *cpu_buffer)
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
@@ -2623,8 +2649,16 @@ trace_recursive_lock(struct ring_buffer_per_cpu *cpu_buffer)
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
-- 
2.27.0



