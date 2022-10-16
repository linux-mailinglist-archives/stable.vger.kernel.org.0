Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C20306000B2
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 17:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbiJPPc5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 11:32:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbiJPPcw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 11:32:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03F8C386B6
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 08:32:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B50DB80CB3
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 15:32:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0CA0C433D6;
        Sun, 16 Oct 2022 15:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665934367;
        bh=AKlBGv91mHEmfKrbGqS0MJ2utMFno45t+y7WlFbaSIU=;
        h=Subject:To:Cc:From:Date:From;
        b=Y9gR+WCPLnGKrkIlNae7bzj9vB0+aXm474Ad//LDJZkJf625zszu+xHPGB/yCnBJ8
         d211oD8AVXtIOckB+LXyVTe/9g6MkWjsqyeDpMr6u6srNhSMMbIwTkpAo9xN4+Y9cc
         I931jxs/8YAwo4mhQpAhVk/T+NrrJnrVMdsKHYZw=
Subject: FAILED: patch "[PATCH] tracing: Add ioctl() to force ring buffer waiters to wake up" failed to apply to 4.14-stable tree
To:     rostedt@goodmis.org, akpm@linux-foundation.org, mingo@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 16 Oct 2022 17:33:33 +0200
Message-ID: <1665934413211196@kroah.com>
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


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

01b2a5217173 ("tracing: Add ioctl() to force ring buffer waiters to wake up")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 01b2a52171735c6eea80ee2f355f32bea6c41418 Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Date: Thu, 29 Sep 2022 09:50:29 -0400
Subject: [PATCH] tracing: Add ioctl() to force ring buffer waiters to wake up

If a process is waiting on the ring buffer for data, there currently isn't
a clean way to force it to wake up. Add an ioctl call that will force any
tasks that are waiting on the trace_pipe_raw file to wake up.

Link: https://lkml.kernel.org/r/20220929095029.117f913f@gandalf.local.home

Cc: stable@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Fixes: e30f53aad2202 ("tracing: Do not busy wait in buffer splice")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index e101b0764b39..58afc83afc9d 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -8349,12 +8349,34 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
 	return ret;
 }
 
+/* An ioctl call with cmd 0 to the ring buffer file will wake up all waiters */
+static long tracing_buffers_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	struct ftrace_buffer_info *info = file->private_data;
+	struct trace_iterator *iter = &info->iter;
+
+	if (cmd)
+		return -ENOIOCTLCMD;
+
+	mutex_lock(&trace_types_lock);
+
+	iter->wait_index++;
+	/* Make sure the waiters see the new wait_index */
+	smp_wmb();
+
+	ring_buffer_wake_waiters(iter->array_buffer->buffer, iter->cpu_file);
+
+	mutex_unlock(&trace_types_lock);
+	return 0;
+}
+
 static const struct file_operations tracing_buffers_fops = {
 	.open		= tracing_buffers_open,
 	.read		= tracing_buffers_read,
 	.poll		= tracing_buffers_poll,
 	.release	= tracing_buffers_release,
 	.splice_read	= tracing_buffers_splice_read,
+	.unlocked_ioctl = tracing_buffers_ioctl,
 	.llseek		= no_llseek,
 };
 

