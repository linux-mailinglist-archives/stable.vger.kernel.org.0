Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE025F57CE
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 17:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbiJEPvR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 11:51:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbiJEPvP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 11:51:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D1EB422C2;
        Wed,  5 Oct 2022 08:51:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 17DF161751;
        Wed,  5 Oct 2022 15:51:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7400BC433D6;
        Wed,  5 Oct 2022 15:51:11 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@goodmis.org>)
        id 1og6fz-0028Gd-35;
        Wed, 05 Oct 2022 11:51:15 -0400
Message-ID: <20221005155115.783254244@goodmis.org>
User-Agent: quilt/0.66
Date:   Wed, 05 Oct 2022 11:50:31 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, stable@vger.kernel.org,
        "Jiazi.Li" <jiazi.li@transsion.com>
Subject: [for-next][PATCH 1/5] ring-buffer: Fix race between reset page and reading page
References: <20221005155030.594135087@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The ring buffer is broken up into sub buffers (currently of page size).
Each sub buffer has a pointer to its "tail" (the last event written to the
sub buffer). When a new event is requested, the tail is locally
incremented to cover the size of the new event. This is done in a way that
there is no need for locking.

If the tail goes past the end of the sub buffer, the process of moving to
the next sub buffer takes place. After setting the current sub buffer to
the next one, the previous one that had the tail go passed the end of the
sub buffer needs to be reset back to the original tail location (before
the new event was requested) and the rest of the sub buffer needs to be
"padded".

The race happens when a reader takes control of the sub buffer. As readers
do a "swap" of sub buffers from the ring buffer to get exclusive access to
the sub buffer, it replaces the "head" sub buffer with an empty sub buffer
that goes back into the writable portion of the ring buffer. This swap can
happen as soon as the writer moves to the next sub buffer and before it
updates the last sub buffer with padding.

Because the sub buffer can be released to the reader while the writer is
still updating the padding, it is possible for the reader to see the event
that goes past the end of the sub buffer. This can cause obvious issues.

To fix this, add a few memory barriers so that the reader definitely sees
the updates to the sub buffer, and also waits until the writer has put
back the "tail" of the sub buffer back to the last event that was written
on it.

To be paranoid, it will only spin for 1 second, otherwise it will
warn and shutdown the ring buffer code. 1 second should be enough as
the writer does have preemption disabled. If the writer doesn't move
within 1 second (with preemption disabled) something is horribly
wrong. No interrupt should last 1 second!

Link: https://lore.kernel.org/all/20220830120854.7545-1-jiazi.li@transsion.com/
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216369
Link: https://lkml.kernel.org/r/20220929104909.0650a36c@gandalf.local.home

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: stable@vger.kernel.org
Fixes: c7b0930857e22 ("ring-buffer: prevent adding write in discarded area")
Reported-by: Jiazi.Li <jiazi.li@transsion.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 3046deacf7b3..c3f354cfc5ba 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2648,6 +2648,9 @@ rb_reset_tail(struct ring_buffer_per_cpu *cpu_buffer,
 		/* Mark the rest of the page with padding */
 		rb_event_set_padding(event);
 
+		/* Make sure the padding is visible before the write update */
+		smp_wmb();
+
 		/* Set the write back to the previous setting */
 		local_sub(length, &tail_page->write);
 		return;
@@ -2659,6 +2662,9 @@ rb_reset_tail(struct ring_buffer_per_cpu *cpu_buffer,
 	/* time delta must be non zero */
 	event->time_delta = 1;
 
+	/* Make sure the padding is visible before the tail_page->write update */
+	smp_wmb();
+
 	/* Set write to end of buffer */
 	length = (tail + length) - BUF_PAGE_SIZE;
 	local_sub(length, &tail_page->write);
@@ -4627,6 +4633,33 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
 	arch_spin_unlock(&cpu_buffer->lock);
 	local_irq_restore(flags);
 
+	/*
+	 * The writer has preempt disable, wait for it. But not forever
+	 * Although, 1 second is pretty much "forever"
+	 */
+#define USECS_WAIT	1000000
+        for (nr_loops = 0; nr_loops < USECS_WAIT; nr_loops++) {
+		/* If the write is past the end of page, a writer is still updating it */
+		if (likely(!reader || rb_page_write(reader) <= BUF_PAGE_SIZE))
+			break;
+
+		udelay(1);
+
+		/* Get the latest version of the reader write value */
+		smp_rmb();
+	}
+
+	/* The writer is not moving forward? Something is wrong */
+	if (RB_WARN_ON(cpu_buffer, nr_loops == USECS_WAIT))
+		reader = NULL;
+
+	/*
+	 * Make sure we see any padding after the write update
+	 * (see rb_reset_tail())
+	 */
+	smp_rmb();
+
+
 	return reader;
 }
 
-- 
2.35.1
