Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 542BB548E29
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378830AbiFMNqa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:46:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378502AbiFMNm6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:42:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E1B02B19B;
        Mon, 13 Jun 2022 04:31:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A03C16125A;
        Mon, 13 Jun 2022 11:31:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4865C36B06;
        Mon, 13 Jun 2022 11:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119895;
        bh=yRje9zJj6k4Qpu7HfECVlAhlL7PYsk56cdaU6S3uQd0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2t1VcmSiZn3oE1GV1rO2fTLWT6mf3Eg8zGdPq2OaARKKsqPrSSHQmsIjxWYMx+O5J
         EQuBejBRYb3tjMyIMhgvxtu2Y/gZnh08NT0Bbj6V/AvPhi627/k2q8SzbdeHsUOFth
         QExM8tazfxgak7y6dug3a/XY6gtk1RVXx/IosaFg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff Xie <xiehuan09@gmail.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 157/339] tracing: Make tp_printk work on syscall tracepoints
Date:   Mon, 13 Jun 2022 12:09:42 +0200
Message-Id: <20220613094931.447448061@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Xie <xiehuan09@gmail.com>

[ Upstream commit cb1c45fb68b8a4285ccf750842b1136f26cfe267 ]

Currently the tp_printk option has no effect on syscall tracepoint.
When adding the kernel option parameter tp_printk, then:

echo 1 > /sys/kernel/debug/tracing/events/syscalls/enable

When running any application, no trace information is printed on the
terminal.

Now added printk for syscall tracepoints.

Link: https://lkml.kernel.org/r/20220410145025.681144-1-xiehuan09@gmail.com

Signed-off-by: Jeff Xie <xiehuan09@gmail.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_syscalls.c | 35 +++++++++++------------------------
 1 file changed, 11 insertions(+), 24 deletions(-)

diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index f755bde42fd0..b69e207012c9 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -154,7 +154,7 @@ print_syscall_enter(struct trace_iterator *iter, int flags,
 			goto end;
 
 		/* parameter types */
-		if (tr->trace_flags & TRACE_ITER_VERBOSE)
+		if (tr && tr->trace_flags & TRACE_ITER_VERBOSE)
 			trace_seq_printf(s, "%s ", entry->types[i]);
 
 		/* parameter values */
@@ -296,9 +296,7 @@ static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
 	struct trace_event_file *trace_file;
 	struct syscall_trace_enter *entry;
 	struct syscall_metadata *sys_data;
-	struct ring_buffer_event *event;
-	struct trace_buffer *buffer;
-	unsigned int trace_ctx;
+	struct trace_event_buffer fbuffer;
 	unsigned long args[6];
 	int syscall_nr;
 	int size;
@@ -321,20 +319,16 @@ static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
 
 	size = sizeof(*entry) + sizeof(unsigned long) * sys_data->nb_args;
 
-	trace_ctx = tracing_gen_ctx();
-
-	event = trace_event_buffer_lock_reserve(&buffer, trace_file,
-			sys_data->enter_event->event.type, size, trace_ctx);
-	if (!event)
+	entry = trace_event_buffer_reserve(&fbuffer, trace_file, size);
+	if (!entry)
 		return;
 
-	entry = ring_buffer_event_data(event);
+	entry = ring_buffer_event_data(fbuffer.event);
 	entry->nr = syscall_nr;
 	syscall_get_arguments(current, regs, args);
 	memcpy(entry->args, args, sizeof(unsigned long) * sys_data->nb_args);
 
-	event_trigger_unlock_commit(trace_file, buffer, event, entry,
-				    trace_ctx);
+	trace_event_buffer_commit(&fbuffer);
 }
 
 static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
@@ -343,9 +337,7 @@ static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
 	struct trace_event_file *trace_file;
 	struct syscall_trace_exit *entry;
 	struct syscall_metadata *sys_data;
-	struct ring_buffer_event *event;
-	struct trace_buffer *buffer;
-	unsigned int trace_ctx;
+	struct trace_event_buffer fbuffer;
 	int syscall_nr;
 
 	syscall_nr = trace_get_syscall_nr(current, regs);
@@ -364,20 +356,15 @@ static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
 	if (!sys_data)
 		return;
 
-	trace_ctx = tracing_gen_ctx();
-
-	event = trace_event_buffer_lock_reserve(&buffer, trace_file,
-			sys_data->exit_event->event.type, sizeof(*entry),
-			trace_ctx);
-	if (!event)
+	entry = trace_event_buffer_reserve(&fbuffer, trace_file, sizeof(*entry));
+	if (!entry)
 		return;
 
-	entry = ring_buffer_event_data(event);
+	entry = ring_buffer_event_data(fbuffer.event);
 	entry->nr = syscall_nr;
 	entry->ret = syscall_get_return_value(current, regs);
 
-	event_trigger_unlock_commit(trace_file, buffer, event, entry,
-				    trace_ctx);
+	trace_event_buffer_commit(&fbuffer);
 }
 
 static int reg_event_syscall_enter(struct trace_event_file *file,
-- 
2.35.1



