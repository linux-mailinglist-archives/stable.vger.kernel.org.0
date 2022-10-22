Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A73E660860C
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbiJVHnc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:43:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231208AbiJVHm4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:42:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22DC762A5A;
        Sat, 22 Oct 2022 00:41:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A79C7B82E05;
        Sat, 22 Oct 2022 07:40:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03D10C433D6;
        Sat, 22 Oct 2022 07:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424437;
        bh=mnc13TlevMeVJzlX+brpL19d8f7IuIS8B6nuN0+yHxE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cB1a8U7M7XX6enPk8/IleCek8VX1HXiIVwe9OSj0O7iPi49PGpE/Cd3H68k1JyaEy
         05kIV5PlsJth0tvSUaWZsFyxv51RSO9z5eXBEZUfYijHDTp4zKtjbCeXuASlITBuIS
         +U3F5dPBPLmYgCSc2Io8BRAXUfFt8Q4IseteRSE4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.19 146/717] tracing: Wake up ring buffer waiters on closing of the file
Date:   Sat, 22 Oct 2022 09:20:25 +0200
Message-Id: <20221022072441.334683004@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
@@ -92,6 +92,7 @@ struct trace_iterator {
 	unsigned int		temp_size;
 	char			*fmt;	/* modified format holder */
 	unsigned int		fmt_size;
+	long			wait_index;
 
 	/* trace_seq for __print_flags() and __print_symbolic() etc. */
 	struct trace_seq	tmp_seq;
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -8160,6 +8160,12 @@ static int tracing_buffers_release(struc
 
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
@@ -8313,6 +8319,8 @@ tracing_buffers_splice_read(struct file
 
 	/* did we read anything? */
 	if (!spd.nr_pages) {
+		long wait_index;
+
 		if (ret)
 			goto out;
 
@@ -8320,10 +8328,17 @@ tracing_buffers_splice_read(struct file
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
 


