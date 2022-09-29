Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9E2F5F0108
	for <lists+stable@lfdr.de>; Fri, 30 Sep 2022 00:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbiI2Wz2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Sep 2022 18:55:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbiI2WzZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Sep 2022 18:55:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B352D2D6A;
        Thu, 29 Sep 2022 15:55:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5CB18621D9;
        Thu, 29 Sep 2022 22:55:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB165C433D6;
        Thu, 29 Sep 2022 22:55:22 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@goodmis.org>)
        id 1oe2SK-000cng-2J;
        Thu, 29 Sep 2022 18:56:36 -0400
Message-ID: <20220929225636.321282157@goodmis.org>
User-Agent: quilt/0.66
Date:   Thu, 29 Sep 2022 18:55:47 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org
Subject: [for-next][PATCH 05/15] ring-buffer: Add ring_buffer_wake_waiters()
References: <20220929225542.784716766@goodmis.org>
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

On closing of a file that represents a ring buffer or flushing the file,
there may be waiters on the ring buffer that needs to be woken up and exit
the ring_buffer_wait() function.

Add ring_buffer_wake_waiters() to wake up the waiters on the ring buffer
and allow them to exit the wait loop.

Link: https://lkml.kernel.org/r/20220928133938.28dc2c27@gandalf.local.home

Cc: stable@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Fixes: 15693458c4bc0 ("tracing/ring-buffer: Move poll wake ups into ring buffer code")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 include/linux/ring_buffer.h |  2 +-
 kernel/trace/ring_buffer.c  | 39 +++++++++++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index dac53fd3afea..2504df9a0453 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -101,7 +101,7 @@ __ring_buffer_alloc(unsigned long size, unsigned flags, struct lock_class_key *k
 int ring_buffer_wait(struct trace_buffer *buffer, int cpu, int full);
 __poll_t ring_buffer_poll_wait(struct trace_buffer *buffer, int cpu,
 			  struct file *filp, poll_table *poll_table);
-
+void ring_buffer_wake_waiters(struct trace_buffer *buffer, int cpu);
 
 #define RING_BUFFER_ALL_CPUS -1
 
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 5a7d818ca3ea..3046deacf7b3 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -413,6 +413,7 @@ struct rb_irq_work {
 	struct irq_work			work;
 	wait_queue_head_t		waiters;
 	wait_queue_head_t		full_waiters;
+	long				wait_index;
 	bool				waiters_pending;
 	bool				full_waiters_pending;
 	bool				wakeup_full;
@@ -924,6 +925,37 @@ static void rb_wake_up_waiters(struct irq_work *work)
 	}
 }
 
+/**
+ * ring_buffer_wake_waiters - wake up any waiters on this ring buffer
+ * @buffer: The ring buffer to wake waiters on
+ *
+ * In the case of a file that represents a ring buffer is closing,
+ * it is prudent to wake up any waiters that are on this.
+ */
+void ring_buffer_wake_waiters(struct trace_buffer *buffer, int cpu)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+	struct rb_irq_work *rbwork;
+
+	if (cpu == RING_BUFFER_ALL_CPUS) {
+
+		/* Wake up individual ones too. One level recursion */
+		for_each_buffer_cpu(buffer, cpu)
+			ring_buffer_wake_waiters(buffer, cpu);
+
+		rbwork = &buffer->irq_work;
+	} else {
+		cpu_buffer = buffer->buffers[cpu];
+		rbwork = &cpu_buffer->irq_work;
+	}
+
+	rbwork->wait_index++;
+	/* make sure the waiters see the new index */
+	smp_wmb();
+
+	rb_wake_up_waiters(&rbwork->work);
+}
+
 /**
  * ring_buffer_wait - wait for input to the ring buffer
  * @buffer: buffer to wait on
@@ -939,6 +971,7 @@ int ring_buffer_wait(struct trace_buffer *buffer, int cpu, int full)
 	struct ring_buffer_per_cpu *cpu_buffer;
 	DEFINE_WAIT(wait);
 	struct rb_irq_work *work;
+	long wait_index;
 	int ret = 0;
 
 	/*
@@ -957,6 +990,7 @@ int ring_buffer_wait(struct trace_buffer *buffer, int cpu, int full)
 		work = &cpu_buffer->irq_work;
 	}
 
+	wait_index = READ_ONCE(work->wait_index);
 
 	while (true) {
 		if (full)
@@ -1021,6 +1055,11 @@ int ring_buffer_wait(struct trace_buffer *buffer, int cpu, int full)
 		}
 
 		schedule();
+
+		/* Make sure to see the new wait index */
+		smp_rmb();
+		if (wait_index != work->wait_index)
+			break;
 	}
 
 	if (full)
-- 
2.35.1
