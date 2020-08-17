Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2756247299
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391532AbgHQSpA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:45:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:43816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388064AbgHQP4H (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:56:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 191AC20888;
        Mon, 17 Aug 2020 15:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679762;
        bh=N1gT3kAw/UBcFA7s49rB6JKME29zU0dtcQUV78S0TKI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mHqZXr5eEMECi5V4dvYJrWvAvEcFQLQ5ze6YeQvRnV3UQxts5a+fRHcISV9tIV6Jj
         Rvy0GIvzXxdHbt0hoMa+sm1jqomhinYE04NKT0WagWCuJt5mtR2csf6Dy3WjdcnL1+
         fQpgjgj6b9JWrksSpW/A7PSaJWk4ZM/ZxYBzE27Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 295/393] ftrace: Fix ftrace_trace_task return value
Date:   Mon, 17 Aug 2020 17:15:45 +0200
Message-Id: <20200817143833.927717439@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit c58b6b0372de0d4cd0536d6585addd1b36b151ae ]

I was attempting to use pid filtering with function_graph, but it wasn't
allowing anything to make it through.  Turns out ftrace_trace_task
returns false if ftrace_ignore_pid is not-empty, which isn't correct
anymore.  We're now setting it to FTRACE_PID_IGNORE if we need to ignore
that pid, otherwise it's set to the pid (which is weird considering the
name) or to FTRACE_PID_TRACE.  Fix the check to check for !=
FTRACE_PID_IGNORE.  With this we can now use function_graph with pid
filtering.

Link: https://lkml.kernel.org/r/20200725005048.1790-1-josef@toxicpanda.com

Fixes: 717e3f5ebc82 ("ftrace: Make function trace pid filtering a bit more exact")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/ftrace.c | 3 ---
 kernel/trace/trace.h  | 7 ++++++-
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index bd030b1b95148..baa7c050dc7bc 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -139,9 +139,6 @@ static inline void ftrace_ops_init(struct ftrace_ops *ops)
 #endif
 }
 
-#define FTRACE_PID_IGNORE	-1
-#define FTRACE_PID_TRACE	-2
-
 static void ftrace_pid_func(unsigned long ip, unsigned long parent_ip,
 			    struct ftrace_ops *op, struct pt_regs *regs)
 {
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 09298ce5f805b..6b9acbf95cbc9 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -1103,6 +1103,10 @@ print_graph_function_flags(struct trace_iterator *iter, u32 flags)
 extern struct list_head ftrace_pids;
 
 #ifdef CONFIG_FUNCTION_TRACER
+
+#define FTRACE_PID_IGNORE	-1
+#define FTRACE_PID_TRACE	-2
+
 struct ftrace_func_command {
 	struct list_head	list;
 	char			*name;
@@ -1114,7 +1118,8 @@ struct ftrace_func_command {
 extern bool ftrace_filter_param __initdata;
 static inline int ftrace_trace_task(struct trace_array *tr)
 {
-	return !this_cpu_read(tr->array_buffer.data->ftrace_ignore_pid);
+	return this_cpu_read(tr->array_buffer.data->ftrace_ignore_pid) !=
+		FTRACE_PID_IGNORE;
 }
 extern int ftrace_is_dead(void);
 int ftrace_create_function_files(struct trace_array *tr,
-- 
2.25.1



