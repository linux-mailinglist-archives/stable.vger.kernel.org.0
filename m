Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1513D63202E
	for <lists+stable@lfdr.de>; Mon, 21 Nov 2022 12:17:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbiKULRW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Nov 2022 06:17:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231241AbiKULRC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Nov 2022 06:17:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B6C6B7E9D;
        Mon, 21 Nov 2022 03:12:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 84407B80E07;
        Mon, 21 Nov 2022 11:12:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC97CC433D6;
        Mon, 21 Nov 2022 11:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669029135;
        bh=9SNg0B425XxR046RvAjW3EbGVD0wCS60K/fk/AffRn4=;
        h=Subject:To:Cc:From:Date:From;
        b=MZU6GOpb9SVbv7PxjC5HdPPaAoVl9l0UIvDFtf8KBE9gYhxxHTt4yMNUqOcrsNTsW
         cAC1uqaLKC7o4oC3y8DFkREe6H6AnoylFfq0atDEz1Dz65HOyC7Ia2MQve6EW/eXHD
         a0QE/ZMcWAjKKANknqZKJ29c4KCoZQOZ1f3AsEEk=
Subject: FAILED: patch "[PATCH] tracing/ring-buffer: Have polling block on watermark" failed to apply to 4.19-stable tree
To:     rostedt@goodmis.org, linux-trace-kernel@vger.kernel.org,
        mathieu.desnoyers@efficios.com, mhiramat@kernel.org,
        primiano@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 21 Nov 2022 12:12:09 +0100
Message-ID: <16690291295341@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

42fb0a1e84ff ("tracing/ring-buffer: Have polling block on watermark")
7e9fbbb1b776 ("ring-buffer: Add ring_buffer_wake_waiters()")
13292494379f ("tracing: Make struct ring_buffer less ambiguous")
1c5eb4481e01 ("tracing: Rename trace_buffer to array_buffer")
2d6425af6116 ("tracing: Declare newly exported APIs in include/linux/trace.h")
a47b53e95acc ("tracing: Rename tracing_reset() to tracing_reset_cpu()")
46cc0b44428d ("tracing/snapshot: Resize spare buffer if size changed")
d2d8b146043a ("Merge tag 'trace-v5.2' of git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace")

thanks,

greg k-h

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

diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index 2504df9a0453..3c7d295746f6 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -100,7 +100,7 @@ __ring_buffer_alloc(unsigned long size, unsigned flags, struct lock_class_key *k
 
 int ring_buffer_wait(struct trace_buffer *buffer, int cpu, int full);
 __poll_t ring_buffer_poll_wait(struct trace_buffer *buffer, int cpu,
-			  struct file *filp, poll_table *poll_table);
+			  struct file *filp, poll_table *poll_table, int full);
 void ring_buffer_wake_waiters(struct trace_buffer *buffer, int cpu);
 
 #define RING_BUFFER_ALL_CPUS -1
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 9712083832f4..089b1ec9cb3b 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -907,6 +907,21 @@ size_t ring_buffer_nr_dirty_pages(struct trace_buffer *buffer, int cpu)
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
@@ -1046,22 +1061,20 @@ int ring_buffer_wait(struct trace_buffer *buffer, int cpu, int full)
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
 
@@ -1087,6 +1100,7 @@ int ring_buffer_wait(struct trace_buffer *buffer, int cpu, int full)
  * @cpu: the cpu buffer to wait on
  * @filp: the file descriptor
  * @poll_table: The poll descriptor
+ * @full: wait until the percentage of pages are available, if @cpu != RING_BUFFER_ALL_CPUS
  *
  * If @cpu == RING_BUFFER_ALL_CPUS then the task will wake up as soon
  * as data is added to any of the @buffer's cpu buffers. Otherwise
@@ -1096,14 +1110,15 @@ int ring_buffer_wait(struct trace_buffer *buffer, int cpu, int full)
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
 
@@ -1111,8 +1126,14 @@ __poll_t ring_buffer_poll_wait(struct trace_buffer *buffer, int cpu,
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
@@ -1128,6 +1149,9 @@ __poll_t ring_buffer_poll_wait(struct trace_buffer *buffer, int cpu,
 	 */
 	smp_mb();
 
+	if (full)
+		return full_hit(buffer, cpu, full) ? EPOLLIN | EPOLLRDNORM : 0;
+
 	if ((cpu == RING_BUFFER_ALL_CPUS && !ring_buffer_empty(buffer)) ||
 	    (cpu != RING_BUFFER_ALL_CPUS && !ring_buffer_empty_cpu(buffer, cpu)))
 		return EPOLLIN | EPOLLRDNORM;
@@ -3155,10 +3179,6 @@ static void rb_commit(struct ring_buffer_per_cpu *cpu_buffer,
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
@@ -3182,10 +3202,7 @@ rb_wakeups(struct trace_buffer *buffer, struct ring_buffer_per_cpu *cpu_buffer)
 
 	cpu_buffer->last_pages_touch = local_read(&cpu_buffer->pages_touched);
 
-	full = cpu_buffer->shortest_full;
-	nr_pages = cpu_buffer->nr_pages;
-	dirty = ring_buffer_nr_dirty_pages(buffer, cpu_buffer->cpu);
-	if (full && nr_pages && (dirty * 100) <= full * nr_pages)
+	if (!full_hit(buffer, cpu_buffer->cpu, cpu_buffer->shortest_full))
 		return;
 
 	cpu_buffer->irq_work.wakeup_full = true;
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 47a44b055a1d..c6c7a0af3ed2 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -6681,7 +6681,7 @@ trace_poll(struct trace_iterator *iter, struct file *filp, poll_table *poll_tabl
 		return EPOLLIN | EPOLLRDNORM;
 	else
 		return ring_buffer_poll_wait(iter->array_buffer->buffer, iter->cpu_file,
-					     filp, poll_table);
+					     filp, poll_table, iter->tr->buffer_percent);
 }
 
 static __poll_t

