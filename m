Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 144056434BC
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:49:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235066AbiLETtJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:49:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235037AbiLETs1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:48:27 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33DAF24BEF;
        Mon,  5 Dec 2022 11:45:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9CF2DCE13A4;
        Mon,  5 Dec 2022 19:45:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B36FC433C1;
        Mon,  5 Dec 2022 19:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670269532;
        bh=nlls+mMrGod18/annYo2/2Pvmx0nt3SzhU3hi2vvX+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K+EcMIXBR+X1DIDnUZYShPRFVQmu/F5dpPS7mzdVzNP0F6gg3+h1E2BdUvuFQzQjL
         31OiMaDPP42yHjR5KhPbC3kzBpvu+g7Hu+uqnkhTuw7JjYz8z/Qeb7+qkvoCjPWmfF
         xU+f9XiV/M0qtBYxMV7+db8FIOd+j5d5Eekm+VaA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Linux Trace Kernel <linux-trace-kernel@vger.kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Primiano Tucci <primiano@google.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.4 141/153] tracing/ring-buffer: Have polling block on watermark
Date:   Mon,  5 Dec 2022 20:11:05 +0100
Message-Id: <20221205190812.669520495@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.733996403@linuxfoundation.org>
References: <20221205190808.733996403@linuxfoundation.org>
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
 kernel/trace/ring_buffer.c  |   54 ++++++++++++++++++++++++++++----------------
 kernel/trace/trace.c        |    2 -
 3 files changed, 37 insertions(+), 21 deletions(-)

--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -99,7 +99,7 @@ __ring_buffer_alloc(unsigned long size,
 
 int ring_buffer_wait(struct ring_buffer *buffer, int cpu, int full);
 __poll_t ring_buffer_poll_wait(struct ring_buffer *buffer, int cpu,
-			  struct file *filp, poll_table *poll_table);
+			  struct file *filp, poll_table *poll_table, int full);
 
 
 #define RING_BUFFER_ALL_CPUS -1
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -566,6 +566,21 @@ size_t ring_buffer_nr_dirty_pages(struct
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
@@ -661,22 +676,20 @@ int ring_buffer_wait(struct ring_buffer
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
 
@@ -697,6 +710,7 @@ int ring_buffer_wait(struct ring_buffer
  * @cpu: the cpu buffer to wait on
  * @filp: the file descriptor
  * @poll_table: The poll descriptor
+ * @full: wait until the percentage of pages are available, if @cpu != RING_BUFFER_ALL_CPUS
  *
  * If @cpu == RING_BUFFER_ALL_CPUS then the task will wake up as soon
  * as data is added to any of the @buffer's cpu buffers. Otherwise
@@ -706,14 +720,14 @@ int ring_buffer_wait(struct ring_buffer
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
 
@@ -721,8 +735,14 @@ __poll_t ring_buffer_poll_wait(struct ri
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
@@ -738,6 +758,9 @@ __poll_t ring_buffer_poll_wait(struct ri
 	 */
 	smp_mb();
 
+	if (full)
+		return full_hit(buffer, cpu, full) ? EPOLLIN | EPOLLRDNORM : 0;
+
 	if ((cpu == RING_BUFFER_ALL_CPUS && !ring_buffer_empty(buffer)) ||
 	    (cpu != RING_BUFFER_ALL_CPUS && !ring_buffer_empty_cpu(buffer, cpu)))
 		return EPOLLIN | EPOLLRDNORM;
@@ -2640,10 +2663,6 @@ static void rb_commit(struct ring_buffer
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
@@ -2667,10 +2686,7 @@ rb_wakeups(struct ring_buffer *buffer, s
 
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
@@ -5993,7 +5993,7 @@ trace_poll(struct trace_iterator *iter,
 		return EPOLLIN | EPOLLRDNORM;
 	else
 		return ring_buffer_poll_wait(iter->trace_buffer->buffer, iter->cpu_file,
-					     filp, poll_table);
+					     filp, poll_table, iter->tr->buffer_percent);
 }
 
 static __poll_t


