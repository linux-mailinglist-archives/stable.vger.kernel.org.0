Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A408A635709
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:38:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237984AbiKWJhg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:37:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238029AbiKWJhJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:37:09 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B623864A3A;
        Wed, 23 Nov 2022 01:34:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6FF2BCE0E1D;
        Wed, 23 Nov 2022 09:34:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45D4EC433D7;
        Wed, 23 Nov 2022 09:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196068;
        bh=Fg3xb1nWkgm/mquTtLFY+ruDKPrdccGNSwqrzWLz6Rg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ifwVUpoTxPl0X1tG3O8VOrQSS/3q1nSadQUHJxy0oP9MxSldnhLMGo5Hf3DN1cKDM
         Q+1Ccpw4rWG2PurCbu2Bv5rAnLZNrTs2LR0AoqjztwQstch7YH7YaS9h2+pxSUElPs
         zOCr0hhnwz2iTyCtjZ0T+9xTmG0zsi3kjcp2SMOg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Linux Trace Kernel <linux-trace-kernel@vger.kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Primiano Tucci <primiano@google.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.15 111/181] tracing/ring-buffer: Have polling block on watermark
Date:   Wed, 23 Nov 2022 09:51:14 +0100
Message-Id: <20221123084607.133909424@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>
References: <20221123084602.707860461@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (Google) <rostedt@goodmis.org>

commit 42fb0a1e84ff525ebe560e2baf9451ab69127e2b upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/ring_buffer.h |    2 -
 kernel/trace/ring_buffer.c  |   55 ++++++++++++++++++++++++++++----------------
 kernel/trace/trace.c        |    2 -
 3 files changed, 38 insertions(+), 21 deletions(-)

--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -100,7 +100,7 @@ __ring_buffer_alloc(unsigned long size,
 
 int ring_buffer_wait(struct trace_buffer *buffer, int cpu, int full);
 __poll_t ring_buffer_poll_wait(struct trace_buffer *buffer, int cpu,
-			  struct file *filp, poll_table *poll_table);
+			  struct file *filp, poll_table *poll_table, int full);
 void ring_buffer_wake_waiters(struct trace_buffer *buffer, int cpu);
 
 #define RING_BUFFER_ALL_CPUS -1
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -871,6 +871,21 @@ size_t ring_buffer_nr_dirty_pages(struct
 	return cnt - read;
 }
 
+static __always_inline bool full_hit(struct trace_buffer *buffer, int cpu, int full)
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
@@ -1010,22 +1025,20 @@ int ring_buffer_wait(struct trace_buffer
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
 
@@ -1051,6 +1064,7 @@ int ring_buffer_wait(struct trace_buffer
  * @cpu: the cpu buffer to wait on
  * @filp: the file descriptor
  * @poll_table: The poll descriptor
+ * @full: wait until the percentage of pages are available, if @cpu != RING_BUFFER_ALL_CPUS
  *
  * If @cpu == RING_BUFFER_ALL_CPUS then the task will wake up as soon
  * as data is added to any of the @buffer's cpu buffers. Otherwise
@@ -1060,14 +1074,15 @@ int ring_buffer_wait(struct trace_buffer
  * zero otherwise.
  */
 __poll_t ring_buffer_poll_wait(struct trace_buffer *buffer, int cpu,
-			  struct file *filp, poll_table *poll_table)
+			  struct file *filp, poll_table *poll_table, int full)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 	struct rb_irq_work *work;
 
-	if (cpu == RING_BUFFER_ALL_CPUS)
+	if (cpu == RING_BUFFER_ALL_CPUS) {
 		work = &buffer->irq_work;
-	else {
+		full = 0;
+	} else {
 		if (!cpumask_test_cpu(cpu, buffer->cpumask))
 			return -EINVAL;
 
@@ -1075,8 +1090,14 @@ __poll_t ring_buffer_poll_wait(struct tr
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
@@ -1092,6 +1113,9 @@ __poll_t ring_buffer_poll_wait(struct tr
 	 */
 	smp_mb();
 
+	if (full)
+		return full_hit(buffer, cpu, full) ? EPOLLIN | EPOLLRDNORM : 0;
+
 	if ((cpu == RING_BUFFER_ALL_CPUS && !ring_buffer_empty(buffer)) ||
 	    (cpu != RING_BUFFER_ALL_CPUS && !ring_buffer_empty_cpu(buffer, cpu)))
 		return EPOLLIN | EPOLLRDNORM;
@@ -3112,10 +3136,6 @@ static void rb_commit(struct ring_buffer
 static __always_inline void
 rb_wakeups(struct trace_buffer *buffer, struct ring_buffer_per_cpu *cpu_buffer)
 {
-	size_t nr_pages;
-	size_t dirty;
-	size_t full;
-
 	if (buffer->irq_work.waiters_pending) {
 		buffer->irq_work.waiters_pending = false;
 		/* irq_work_queue() supplies it's own memory barriers */
@@ -3139,10 +3159,7 @@ rb_wakeups(struct trace_buffer *buffer,
 
 	cpu_buffer->last_pages_touch = local_read(&cpu_buffer->pages_touched);
 
-	full = cpu_buffer->shortest_full;
-	nr_pages = cpu_buffer->nr_pages;
-	dirty = ring_buffer_nr_dirty_pages(buffer, cpu_buffer->cpu);
-	if (full && nr_pages && (dirty * 100) <= full * nr_pages)
+	if (!full_hit(buffer, cpu_buffer->cpu, cpu_buffer->shortest_full))
 		return;
 
 	cpu_buffer->irq_work.wakeup_full = true;
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -6655,7 +6655,7 @@ trace_poll(struct trace_iterator *iter,
 		return EPOLLIN | EPOLLRDNORM;
 	else
 		return ring_buffer_poll_wait(iter->array_buffer->buffer, iter->cpu_file,
-					     filp, poll_table);
+					     filp, poll_table, iter->tr->buffer_percent);
 }
 
 static __poll_t


