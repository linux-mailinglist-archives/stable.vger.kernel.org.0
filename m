Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B36360AAFB
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236147AbiJXNmp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:42:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236687AbiJXNlE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:41:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B0EE895D5;
        Mon, 24 Oct 2022 05:38:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D43D612F4;
        Mon, 24 Oct 2022 12:37:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF334C433D6;
        Mon, 24 Oct 2022 12:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615065;
        bh=DW7fMcNbVUcJAVYBNxb1tue/4JtMbn4dGrsZ3o/tHhU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cmzeauQdSO7PzWT/IKcSDgb0Ix9afAL4YyR6x9k1GJPqYBhlEXv0m/4s1Qai5//TK
         /InHeXzpfgFPAQuC39RKVLXyxH3i6o73o93Bdr4sj9tjSyR35QV6Qo0rW64uFLFslh
         ycWab2tBuK+jY4aYBkNSJoLZiDTG4+fOqnExnleo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.15 109/530] ring-buffer: Add ring_buffer_wake_waiters()
Date:   Mon, 24 Oct 2022 13:27:33 +0200
Message-Id: <20221024113049.953720243@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (Google) <rostedt@goodmis.org>

commit 7e9fbbb1b776d8d7969551565bc246f74ec53b27 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/ring_buffer.h |    2 +-
 kernel/trace/ring_buffer.c  |   39 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+), 1 deletion(-)

--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -101,7 +101,7 @@ __ring_buffer_alloc(unsigned long size,
 int ring_buffer_wait(struct trace_buffer *buffer, int cpu, int full);
 __poll_t ring_buffer_poll_wait(struct trace_buffer *buffer, int cpu,
 			  struct file *filp, poll_table *poll_table);
-
+void ring_buffer_wake_waiters(struct trace_buffer *buffer, int cpu);
 
 #define RING_BUFFER_ALL_CPUS -1
 
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -405,6 +405,7 @@ struct rb_irq_work {
 	struct irq_work			work;
 	wait_queue_head_t		waiters;
 	wait_queue_head_t		full_waiters;
+	long				wait_index;
 	bool				waiters_pending;
 	bool				full_waiters_pending;
 	bool				wakeup_full;
@@ -889,6 +890,37 @@ static void rb_wake_up_waiters(struct ir
 }
 
 /**
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
+/**
  * ring_buffer_wait - wait for input to the ring buffer
  * @buffer: buffer to wait on
  * @cpu: the cpu buffer to wait on
@@ -903,6 +935,7 @@ int ring_buffer_wait(struct trace_buffer
 	struct ring_buffer_per_cpu *cpu_buffer;
 	DEFINE_WAIT(wait);
 	struct rb_irq_work *work;
+	long wait_index;
 	int ret = 0;
 
 	/*
@@ -921,6 +954,7 @@ int ring_buffer_wait(struct trace_buffer
 		work = &cpu_buffer->irq_work;
 	}
 
+	wait_index = READ_ONCE(work->wait_index);
 
 	while (true) {
 		if (full)
@@ -985,6 +1019,11 @@ int ring_buffer_wait(struct trace_buffer
 		}
 
 		schedule();
+
+		/* Make sure to see the new wait index */
+		smp_rmb();
+		if (wait_index != work->wait_index)
+			break;
 	}
 
 	if (full)


