Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 503FC497320
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 17:47:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238862AbiAWQrb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jan 2022 11:47:31 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:52782 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238867AbiAWQrb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jan 2022 11:47:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4CBC360C26
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 16:47:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A10EC340E4;
        Sun, 23 Jan 2022 16:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642956450;
        bh=vXrmyUYmsQEAPCGllSf4l5weyXt8BgRKH2AKVl41WHs=;
        h=Subject:To:Cc:From:Date:From;
        b=2O6EvWQ9QSm4//wp5ph02kNJO4HLpY1eRdktPwTAojZG1BqL0D8QD/6DQoLLxLLw3
         obf0lSHUGkc4N98qFU1tqU8u5dHEIz2eVthd3lik3V3c+F+P/gDrG6kgdFCHa962sO
         X269y8ySoWLbRB9u0adBt7HUTan8OHXo2o8EUEQk=
Subject: FAILED: patch "[PATCH] tracing: Have syscall trace events use" failed to apply to 5.10-stable tree
To:     rostedt@goodmis.org, akpm@linux-foundation.org,
        mhiramat@kernel.org, mingo@kernel.org, zanussi@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Jan 2022 17:47:27 +0100
Message-ID: <164295644719085@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3e2a56e6f639492311e0a8533f0a7aed60816308 Mon Sep 17 00:00:00 2001
From: Steven Rostedt <rostedt@goodmis.org>
Date: Fri, 7 Jan 2022 17:56:56 -0500
Subject: [PATCH] tracing: Have syscall trace events use
 trace_event_buffer_lock_reserve()

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

