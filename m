Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7DC5ED0EA
	for <lists+stable@lfdr.de>; Wed, 28 Sep 2022 01:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232333AbiI0XRV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Sep 2022 19:17:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232196AbiI0XRR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Sep 2022 19:17:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1C35112FD2;
        Tue, 27 Sep 2022 16:17:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2185661C35;
        Tue, 27 Sep 2022 23:17:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 906ECC433D6;
        Tue, 27 Sep 2022 23:17:14 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@goodmis.org>)
        id 1odJqL-00HDfQ-1q;
        Tue, 27 Sep 2022 19:18:25 -0400
Message-ID: <20220927231825.182416969@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 27 Sep 2022 19:15:27 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org
Subject: [PATCH 4/5] tracing: Wake up ring buffer waiters on closing of the file
References: <20220927231523.298295015@goodmis.org>
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

When the file that represents the ring buffer is closed, there may be
waiters waiting on more input from the ring buffer. Call
ring_buffer_wake_waiters() to wake up any waiters when the file is
closed.

Cc: stable@vger.kernel.org
Fixes: e30f53aad2202 ("tracing: Do not busy wait in buffer splice")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 include/linux/trace_events.h |  1 +
 kernel/trace/trace.c         | 15 +++++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/include/linux/trace_events.h b/include/linux/trace_events.h
index 8401dec93c15..20749bd9db71 100644
--- a/include/linux/trace_events.h
+++ b/include/linux/trace_events.h
@@ -92,6 +92,7 @@ struct trace_iterator {
 	unsigned int		temp_size;
 	char			*fmt;	/* modified format holder */
 	unsigned int		fmt_size;
+	long			wait_index;
 
 	/* trace_seq for __print_flags() and __print_symbolic() etc. */
 	struct trace_seq	tmp_seq;
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index aed7ea6e6045..e101b0764b39 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -8160,6 +8160,12 @@ static int tracing_buffers_release(struct inode *inode, struct file *file)
 
 	__trace_array_put(iter->tr);
 
+	iter->wait_index++;
+	/* Make sure the waiters see the new wait_index */
+	smp_wmb();
+
+	ring_buffer_wake_waiters(iter->array_buffer->buffer, iter->cpu_file);
+
 	if (info->spare)
 		ring_buffer_free_read_page(iter->array_buffer->buffer,
 					   info->spare_cpu, info->spare);
@@ -8313,6 +8319,8 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
 
 	/* did we read anything? */
 	if (!spd.nr_pages) {
+		long wait_index;
+
 		if (ret)
 			goto out;
 
@@ -8320,10 +8328,17 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
 		if ((file->f_flags & O_NONBLOCK) || (flags & SPLICE_F_NONBLOCK))
 			goto out;
 
+		wait_index = READ_ONCE(iter->wait_index);
+
 		ret = wait_on_pipe(iter, iter->tr->buffer_percent);
 		if (ret)
 			goto out;
 
+		/* Make sure we see the new wait_index */
+		smp_rmb();
+		if (wait_index != iter->wait_index)
+			goto out;
+
 		goto again;
 	}
 
-- 
2.35.1
