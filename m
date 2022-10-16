Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5121C60008E
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 17:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbiJPPV2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 11:21:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiJPPV1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 11:21:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E081336BCD
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 08:21:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A1402B80CBF
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 15:21:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6DDDC433C1;
        Sun, 16 Oct 2022 15:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665933684;
        bh=7R5Qg/gMnn9yzoRy1WawNKWlElOr5JHWExchwh2rhlI=;
        h=Subject:To:Cc:From:Date:From;
        b=djVECNg/72bjDaGW0UjxOnx9jW44iP8YacXF6CWNqjeiXGduuk/Q90fbhaKoQZRB7
         /SBIGRYPt9S7zGAw6YyBvnPhtWpvI5j8o681FgMJjZDcq2YZvSlKcgNF36h5u1SG/L
         mnMQ1DKa7Udip42iu5sAPKdn1a0SQEvqad3DzHbQ=
Subject: FAILED: patch "[PATCH] tracing: Wake up ring buffer waiters on closing of the file" failed to apply to 4.19-stable tree
To:     rostedt@goodmis.org, akpm@linux-foundation.org, mingo@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 16 Oct 2022 17:22:08 +0200
Message-ID: <1665933728203113@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

f3ddb74ad079 ("tracing: Wake up ring buffer waiters on closing of the file")
efbbdaa22bb7 ("tracing: Show real address for trace event arguments")
8e99cf91b99b ("tracing: Do not allocate buffer in trace_find_next_entry() in atomic")
ff895103a84a ("tracing: Save off entry when peeking at next entry")
03329f993978 ("tracing: Add tracefs file buffer_percentage")
2c2b0a78b373 ("ring-buffer: Add percentage of ring buffer full to wake up reader")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f3ddb74ad0790030c9592229fb14d8c451f4e9a8 Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Date: Tue, 27 Sep 2022 19:15:27 -0400
Subject: [PATCH] tracing: Wake up ring buffer waiters on closing of the file

When the file that represents the ring buffer is closed, there may be
waiters waiting on more input from the ring buffer. Call
ring_buffer_wake_waiters() to wake up any waiters when the file is
closed.

Link: https://lkml.kernel.org/r/20220927231825.182416969@goodmis.org

Cc: stable@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Fixes: e30f53aad2202 ("tracing: Do not busy wait in buffer splice")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>

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
 

