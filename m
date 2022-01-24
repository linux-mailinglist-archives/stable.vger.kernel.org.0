Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29AF8499D99
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1585705AbiAXWYt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:24:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1583165AbiAXWRW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:17:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC192C04A2E0;
        Mon, 24 Jan 2022 12:45:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 451D960C2A;
        Mon, 24 Jan 2022 20:45:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C9D8C340E5;
        Mon, 24 Jan 2022 20:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057151;
        bh=RYKL0195HNgCJWuQDIBJ5AxoBVK81NvUTBgz1ofwYFw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RRyGF9Mo2pgGJ9PPvoBJcKSV9bd6ub7OlUSD+XLfWmNkz9i7ZCGXBAfw6YAxqDLw+
         wO/A2eoDGaUaDjtiFgIzS5t82abfPA5haqebN/8x2bN9a6RiMSyxcRh8DaM7UAT8Ni
         cV+2i4c9l/461TOwcKyQJ5DPqhop9DeQnTzhy5Fw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tom Zanussi <zanussi@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 5.15 685/846] tracing: Have syscall trace events use trace_event_buffer_lock_reserve()
Date:   Mon, 24 Jan 2022 19:43:22 +0100
Message-Id: <20220124184124.693915947@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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


