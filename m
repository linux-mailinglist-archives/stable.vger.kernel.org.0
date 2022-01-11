Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F033948B3EB
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 18:31:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344463AbiAKRbY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jan 2022 12:31:24 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:45338 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344291AbiAKRbT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jan 2022 12:31:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EDA33B81C4A;
        Tue, 11 Jan 2022 17:31:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96FD3C36AF2;
        Tue, 11 Jan 2022 17:31:16 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@goodmis.org>)
        id 1n7KzL-0032Bc-Pn;
        Tue, 11 Jan 2022 12:31:15 -0500
Message-ID: <20220111173115.632312496@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 11 Jan 2022 12:30:44 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, Tom Zanussi <zanussi@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
Subject: [for-next][PATCH 13/31] tracing: Have syscall trace events use
 trace_event_buffer_lock_reserve()
References: <20220111173030.999527342@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

Currently, the syscall trace events call trace_buffer_lock_reserve()
directly, which means that it misses out on some of the filtering
optimizations provided by the helper function
trace_event_buffer_lock_reserve(). Have the syscall trace events call that
instead, as it was missed when adding the update to use the temp buffer
when filtering.

Link: https://lkml.kernel.org/r/20220107225839.823118570@goodmis.org

Cc: stable@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Tom Zanussi <zanussi@kernel.org>
Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>
Fixes: 0fc1b09ff1ff4 ("tracing: Use temp buffer when filtering events")
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_syscalls.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 8bfcd3b09422..f755bde42fd0 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -323,8 +323,7 @@ static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
 
 	trace_ctx = tracing_gen_ctx();
 
-	buffer = tr->array_buffer.buffer;
-	event = trace_buffer_lock_reserve(buffer,
+	event = trace_event_buffer_lock_reserve(&buffer, trace_file,
 			sys_data->enter_event->event.type, size, trace_ctx);
 	if (!event)
 		return;
@@ -367,8 +366,7 @@ static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
 
 	trace_ctx = tracing_gen_ctx();
 
-	buffer = tr->array_buffer.buffer;
-	event = trace_buffer_lock_reserve(buffer,
+	event = trace_event_buffer_lock_reserve(&buffer, trace_file,
 			sys_data->exit_event->event.type, sizeof(*entry),
 			trace_ctx);
 	if (!event)
-- 
2.33.0
