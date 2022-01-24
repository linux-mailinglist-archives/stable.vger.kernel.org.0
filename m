Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6154249A34B
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:02:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2365116AbiAXXuQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:50:16 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47836 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1455642AbiAXVfs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:35:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B9D1FB80CCF;
        Mon, 24 Jan 2022 21:35:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1CD5C340E4;
        Mon, 24 Jan 2022 21:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060146;
        bh=RYKL0195HNgCJWuQDIBJ5AxoBVK81NvUTBgz1ofwYFw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jqgolr7MBIkK6VwJNFfXZmKUk0AskFhjuZlWGJjyyg8N1oTWGlDoivsSWvIQ8Ve5/
         IHNhgThfk50YiNJK6dol4MvVmlnZLZpKxOG+ZNvIknKwaqQjZtTgDtndUGY4vVDv8k
         QNj+bBjziJncuk/P1cWIJ5uJC+ouSv+0zYTbLSzU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tom Zanussi <zanussi@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 5.16 0854/1039] tracing: Have syscall trace events use trace_event_buffer_lock_reserve()
Date:   Mon, 24 Jan 2022 19:44:03 +0100
Message-Id: <20220124184153.986599946@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

commit 3e2a56e6f639492311e0a8533f0a7aed60816308 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_syscalls.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -323,8 +323,7 @@ static void ftrace_syscall_enter(void *d
 
 	trace_ctx = tracing_gen_ctx();
 
-	buffer = tr->array_buffer.buffer;
-	event = trace_buffer_lock_reserve(buffer,
+	event = trace_event_buffer_lock_reserve(&buffer, trace_file,
 			sys_data->enter_event->event.type, size, trace_ctx);
 	if (!event)
 		return;
@@ -367,8 +366,7 @@ static void ftrace_syscall_exit(void *da
 
 	trace_ctx = tracing_gen_ctx();
 
-	buffer = tr->array_buffer.buffer;
-	event = trace_buffer_lock_reserve(buffer,
+	event = trace_event_buffer_lock_reserve(&buffer, trace_file,
 			sys_data->exit_event->event.type, sizeof(*entry),
 			trace_ctx);
 	if (!event)


