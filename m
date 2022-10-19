Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C973F603C7C
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 10:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231529AbiJSIrv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 04:47:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbiJSIrb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:47:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC0ED66113;
        Wed, 19 Oct 2022 01:45:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3DCC8617E2;
        Wed, 19 Oct 2022 08:45:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FEC3C433C1;
        Wed, 19 Oct 2022 08:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169106;
        bh=4wnaODor8D624RR9nMhH13dQqwy3N+A65TEwwd7SL/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UwzxLmf1utxBqcClmmIlxFiAq3qtxWwfkgmHZi6qUtJIRFjXN04FObbSaCAjHk5DE
         x7GKXaxcGO5gEjfZwsaZiCQ7Jbc0xSqzC9VAzyo65ftOQdJrdHnVUXSzlgP7RKYzLz
         ZVA+9qkiZV1ZfCJKDtjXJlrLyWKn5IpbuKq7szFE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.0 161/862] tracing: Add ioctl() to force ring buffer waiters to wake up
Date:   Wed, 19 Oct 2022 10:24:08 +0200
Message-Id: <20221019083257.077986950@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (Google) <rostedt@goodmis.org>

commit 01b2a52171735c6eea80ee2f355f32bea6c41418 upstream.

If a process is waiting on the ring buffer for data, there currently isn't
a clean way to force it to wake up. Add an ioctl call that will force any
tasks that are waiting on the trace_pipe_raw file to wake up.

Link: https://lkml.kernel.org/r/20220929095029.117f913f@gandalf.local.home

Cc: stable@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Fixes: e30f53aad2202 ("tracing: Do not busy wait in buffer splice")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -8353,12 +8353,34 @@ out:
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
 


