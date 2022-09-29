Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54A945F010D
	for <lists+stable@lfdr.de>; Fri, 30 Sep 2022 00:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbiI2Wzc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Sep 2022 18:55:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbiI2Wz2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Sep 2022 18:55:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B840E7E1D;
        Thu, 29 Sep 2022 15:55:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5EF87621D7;
        Thu, 29 Sep 2022 22:55:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB18AC433D6;
        Thu, 29 Sep 2022 22:55:23 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@goodmis.org>)
        id 1oe2SL-000coo-2F;
        Thu, 29 Sep 2022 18:56:37 -0400
Message-ID: <20220929225637.311818825@goodmis.org>
User-Agent: quilt/0.66
Date:   Thu, 29 Sep 2022 18:55:49 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org
Subject: [for-next][PATCH 07/15] tracing: Add ioctl() to force ring buffer waiters to wake up
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

If a process is waiting on the ring buffer for data, there currently isn't
a clean way to force it to wake up. Add an ioctl call that will force any
tasks that are waiting on the trace_pipe_raw file to wake up.

Link: https://lkml.kernel.org/r/20220929095029.117f913f@gandalf.local.home

Cc: stable@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Fixes: e30f53aad2202 ("tracing: Do not busy wait in buffer splice")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 kernel/trace/trace.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

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
 
-- 
2.35.1
