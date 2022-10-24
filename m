Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07A8C60BB0E
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 22:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234779AbiJXUpd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 16:45:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234773AbiJXUnn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 16:43:43 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D1B22AD9E0;
        Mon, 24 Oct 2022 11:51:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8FEF3CE1582;
        Mon, 24 Oct 2022 12:37:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75D40C433C1;
        Mon, 24 Oct 2022 12:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615072;
        bh=xLnmq/e1GktPM53bVVsTWUVSNLFocaglt+qGnImyh60=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CUkfmyDuj++NiKpM3ylhbVAUPaA/iAVk1/wxBn5Dufac4ZFVm5t3BosCgUaFiTtb2
         OA1dC9NuMK3YvPHgJ0bj2gCsu5x4lxWo4ynFkJH1uk5PMR79LyjcYJJvWP7IWFXV6o
         P2mA7u1N7GwNVdXT2ovGSgZ3TYJC8hLz8Db21m7c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.15 112/530] tracing: Wake up ring buffer waiters on closing of the file
Date:   Mon, 24 Oct 2022 13:27:36 +0200
Message-Id: <20221024113050.105982512@linuxfoundation.org>
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

commit f3ddb74ad0790030c9592229fb14d8c451f4e9a8 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/trace_events.h |    1 +
 kernel/trace/trace.c         |   15 +++++++++++++++
 2 files changed, 16 insertions(+)

--- a/include/linux/trace_events.h
+++ b/include/linux/trace_events.h
@@ -91,6 +91,7 @@ struct trace_iterator {
 	unsigned int		temp_size;
 	char			*fmt;	/* modified format holder */
 	unsigned int		fmt_size;
+	long			wait_index;
 
 	/* trace_seq for __print_flags() and __print_symbolic() etc. */
 	struct trace_seq	tmp_seq;
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -8117,6 +8117,12 @@ static int tracing_buffers_release(struc
 
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
@@ -8270,6 +8276,8 @@ tracing_buffers_splice_read(struct file
 
 	/* did we read anything? */
 	if (!spd.nr_pages) {
+		long wait_index;
+
 		if (ret)
 			goto out;
 
@@ -8277,10 +8285,17 @@ tracing_buffers_splice_read(struct file
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
 


