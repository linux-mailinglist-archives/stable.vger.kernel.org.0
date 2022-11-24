Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E83863719F
	for <lists+stable@lfdr.de>; Thu, 24 Nov 2022 05:56:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229463AbiKXE4A convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 23 Nov 2022 23:56:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiKXE4A (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 23:56:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 120C254B03;
        Wed, 23 Nov 2022 20:55:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ADA7A61F38;
        Thu, 24 Nov 2022 04:55:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DCF8C433C1;
        Thu, 24 Nov 2022 04:55:57 +0000 (UTC)
Date:   Wed, 23 Nov 2022 23:55:55 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <gregkh@linuxfoundation.org>
Cc:     linux-trace-kernel@vger.kernel.org, mathieu.desnoyers@efficios.com,
        mhiramat@kernel.org, primiano@google.com, <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] tracing/ring-buffer: Have polling block
 on watermark" failed to apply to 5.4-stable tree
Message-ID: <20221123235555.6791e1b4@rorschach.local.home>
In-Reply-To: <16690291284651@kroah.com>
References: <16690291284651@kroah.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


After working on this, I believe the real Fixes tag should have been

2c2b0a78b3739 ("ring-buffer: Add percentage of ring buffer full to wake up reader")

Which was added in 5.0, so this is the only release I'm backporting this to.

-- Steve


------------------ original commit in Linus's tree ------------------

From 42fb0a1e84ff525ebe560e2baf9451ab69127e2b Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Date: Thu, 20 Oct 2022 23:14:27 -0400
Subject: [PATCH] tracing/ring-buffer: Have polling block on watermark

Currently the way polling works on the ring buffer is broken. It will
return immediately if there's any data in the ring buffer whereas a read
will block until the watermark (defined by the tracefs buffer_percent file)
is hit.

That is, a select() or poll() will return as if there's data available,
but then the following read will block. This is broken for the way
select()s and poll()s are supposed to work.

Have the polling on the ring buffer also block the same way reads and
splice does on the ring buffer.

Link: https://lkml.kernel.org/r/20221020231427.41be3f26@gandalf.local.home

Cc: Linux Trace Kernel <linux-trace-kernel@vger.kernel.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Primiano Tucci <primiano@google.com>
Cc: stable@vger.kernel.org
Fixes: 1e0d6714aceb7 ("ring-buffer: Do not wake up a splice waiter when page is not full")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>

---
 include/linux/ring_buffer.h |    2 -
 kernel/trace/ring_buffer.c  |   54 ++++++++++++++++++++++++++++----------------
 kernel/trace/trace.c        |    2 -
 3 files changed, 37 insertions(+), 21 deletions(-)

Index: linux-test.git/include/linux/ring_buffer.h
===================================================================
--- linux-test.git.orig/include/linux/ring_buffer.h	2022-11-23 21:52:16.912916427 -0500
+++ linux-test.git/include/linux/ring_buffer.h	2022-11-23 21:52:39.400515404 -0500
@@ -99,7 +99,7 @@ __ring_buffer_alloc(unsigned long size,
 
 int ring_buffer_wait(struct ring_buffer *buffer, int cpu, int full);
 __poll_t ring_buffer_poll_wait(struct ring_buffer *buffer, int cpu,
-			  struct file *filp, poll_table *poll_table);
+			  struct file *filp, poll_table *poll_table, int full);
 
 
 #define RING_BUFFER_ALL_CPUS -1
Index: linux-test.git/kernel/trace/ring_buffer.c
===================================================================
--- linux-test.git.orig/kernel/trace/ring_buffer.c	2022-11-23 21:52:16.912916427 -0500
+++ linux-test.git/kernel/trace/ring_buffer.c	2022-11-23 22:40:37.013711581 -0500
@@ -557,6 +557,21 @@ size_t ring_buffer_nr_dirty_pages(struct
 	return cnt - read;
 }
 
+static __always_inline bool full_hit(struct ring_buffer *buffer, int cpu, int full)
+{
+	struct ring_buffer_per_cpu *cpu_buffer = buffer->buffers[cpu];
+	size_t nr_pages;
+	size_t dirty;
+
+	nr_pages = cpu_buffer->nr_pages;
+	if (!nr_pages || !full)
+		return true;
+
+	dirty = ring_buffer_nr_dirty_pages(buffer, cpu);
+
+	return (dirty * 100) > (full * nr_pages);
+}
+
 /*
  * rb_wake_up_waiters - wake up tasks waiting for ring buffer input
  *
@@ -652,22 +667,20 @@ int ring_buffer_wait(struct ring_buffer
 		    !ring_buffer_empty_cpu(buffer, cpu)) {
 			unsigned long flags;
 			bool pagebusy;
-			size_t nr_pages;
-			size_t dirty;
+			bool done;
 
 			if (!full)
 				break;
 
 			raw_spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
 			pagebusy = cpu_buffer->reader_page == cpu_buffer->commit_page;
-			nr_pages = cpu_buffer->nr_pages;
-			dirty = ring_buffer_nr_dirty_pages(buffer, cpu);
+			done = !pagebusy && full_hit(buffer, cpu, full);
+
 			if (!cpu_buffer->shortest_full ||
 			    cpu_buffer->shortest_full > full)
 				cpu_buffer->shortest_full = full;
 			raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
-			if (!pagebusy &&
-			    (!nr_pages || (dirty * 100) > full * nr_pages))
+			if (done)
 				break;
 		}
 
@@ -688,6 +701,7 @@ int ring_buffer_wait(struct ring_buffer
  * @cpu: the cpu buffer to wait on
  * @filp: the file descriptor
  * @poll_table: The poll descriptor
+ * @full: wait until the percentage of pages are available, if @cpu != RING_BUFFER_ALL_CPUS
  *
  * If @cpu == RING_BUFFER_ALL_CPUS then the task will wake up as soon
  * as data is added to any of the @buffer's cpu buffers. Otherwise
@@ -697,14 +711,14 @@ int ring_buffer_wait(struct ring_buffer
  * zero otherwise.
  */
 __poll_t ring_buffer_poll_wait(struct ring_buffer *buffer, int cpu,
-			  struct file *filp, poll_table *poll_table)
+			  struct file *filp, poll_table *poll_table, int full)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 	struct rb_irq_work *work;
 
-	if (cpu == RING_BUFFER_ALL_CPUS)
+	if (cpu == RING_BUFFER_ALL_CPUS) {
 		work = &buffer->irq_work;
-	else {
+	} else {
 		if (!cpumask_test_cpu(cpu, buffer->cpumask))
 			return -EINVAL;
 
@@ -712,8 +726,14 @@ __poll_t ring_buffer_poll_wait(struct ri
 		work = &cpu_buffer->irq_work;
 	}
 
-	poll_wait(filp, &work->waiters, poll_table);
-	work->waiters_pending = true;
+	if (full) {
+		poll_wait(filp, &work->full_waiters, poll_table);
+		work->full_waiters_pending = true;
+	} else {
+		poll_wait(filp, &work->waiters, poll_table);
+		work->waiters_pending = true;
+	}
+
 	/*
 	 * There's a tight race between setting the waiters_pending and
 	 * checking if the ring buffer is empty.  Once the waiters_pending bit
@@ -729,6 +749,9 @@ __poll_t ring_buffer_poll_wait(struct ri
 	 */
 	smp_mb();
 
+	if (full)
+		return full_hit(buffer, cpu, full) ? EPOLLIN | EPOLLRDNORM : 0;
+
 	if ((cpu == RING_BUFFER_ALL_CPUS && !ring_buffer_empty(buffer)) ||
 	    (cpu != RING_BUFFER_ALL_CPUS && !ring_buffer_empty_cpu(buffer, cpu)))
 		return EPOLLIN | EPOLLRDNORM;
@@ -2629,10 +2652,6 @@ static void rb_commit(struct ring_buffer
 static __always_inline void
 rb_wakeups(struct ring_buffer *buffer, struct ring_buffer_per_cpu *cpu_buffer)
 {
-	size_t nr_pages;
-	size_t dirty;
-	size_t full;
-
 	if (buffer->irq_work.waiters_pending) {
 		buffer->irq_work.waiters_pending = false;
 		/* irq_work_queue() supplies it's own memory barriers */
@@ -2656,10 +2675,7 @@ rb_wakeups(struct ring_buffer *buffer, s
 
 	cpu_buffer->last_pages_touch = local_read(&cpu_buffer->pages_touched);
 
-	full = cpu_buffer->shortest_full;
-	nr_pages = cpu_buffer->nr_pages;
-	dirty = ring_buffer_nr_dirty_pages(buffer, cpu_buffer->cpu);
-	if (full && nr_pages && (dirty * 100) <= full * nr_pages)
+	if (!full_hit(buffer, cpu_buffer->cpu, cpu_buffer->shortest_full))
 		return;
 
 	cpu_buffer->irq_work.wakeup_full = true;
Index: linux-test.git/kernel/trace/trace.c
===================================================================
--- linux-test.git.orig/kernel/trace/trace.c	2022-11-23 21:52:16.912916427 -0500
+++ linux-test.git/kernel/trace/trace.c	2022-11-23 22:53:05.448304881 -0500
@@ -5993,7 +5993,7 @@ trace_poll(struct trace_iterator *iter,
 		return EPOLLIN | EPOLLRDNORM;
 	else
 		return ring_buffer_poll_wait(iter->trace_buffer->buffer, iter->cpu_file,
-					     filp, poll_table);
+					     filp, poll_table, iter->tr->buffer_percent);
 }
 
 static __poll_t
