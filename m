Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 499BB4077D0
	for <lists+stable@lfdr.de>; Sat, 11 Sep 2021 15:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236697AbhIKNUr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Sep 2021 09:20:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:47874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236396AbhIKNSn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Sep 2021 09:18:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B6DE61209;
        Sat, 11 Sep 2021 13:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631366034;
        bh=U+PazZfylI4yj1f3g7sPZtyTH+1XAxfIgi00Rw/DJM0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=USu2fmzn6XjRqGo73/vqL95C5N5K3ifqTeDOaBguQ13fsoMHCwofNEIkK32fFWk0A
         TY/vYfIcRlyLEWjQdbpBsMc8Ls+ngR7ws1RjqIBM4N7YnSyszsQ5Z0KnCRWQ5xfBKo
         R8LT2xW6QWLW67/AXauDtIApsWyitmBoN1Hxwg2epqCHJXuTQG7068ieUB3WZoSHLt
         sJXdM7yddUSuDYkm6Cn+dTWUvH7ysUyHwD+oULlrNRyiTHUelkrnNXE1B2fiMgnjbe
         i2RGLySFK6A+vR6FUPdXh+gM/HeltIceSfMhcSMCGjBvHD1bxEp4rclxFp6Gv03bZb
         G+n6YxFlUpcdA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 06/14] tracing/probes: Reject events which have the same name of existing one
Date:   Sat, 11 Sep 2021 09:13:37 -0400
Message-Id: <20210911131345.285564-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210911131345.285564-1-sashal@kernel.org>
References: <20210911131345.285564-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

[ Upstream commit 8e242060c6a4947e8ae7d29794af6a581db08841 ]

Since kprobe_events and uprobe_events only check whether the
other same-type probe event has the same name or not, if the
user gives the same name of the existing tracepoint event (or
the other type of probe events), it silently fails to create
the tracefs entry (but registered.) as below.

/sys/kernel/tracing # ls events/task/task_rename
enable   filter   format   hist     id       trigger
/sys/kernel/tracing # echo p:task/task_rename vfs_read >> kprobe_events
[  113.048508] Could not create tracefs 'task_rename' directory
/sys/kernel/tracing # cat kprobe_events
p:task/task_rename vfs_read

To fix this issue, check whether the existing events have the
same name or not in trace_probe_register_event_call(). If exists,
it rejects to register the new event.

Link: https://lkml.kernel.org/r/162936876189.187130.17558311387542061930.stgit@devnote2

Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_kprobe.c |  6 +++++-
 kernel/trace/trace_probe.c  | 25 +++++++++++++++++++++++++
 kernel/trace/trace_probe.h  |  1 +
 kernel/trace/trace_uprobe.c |  6 +++++-
 4 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 233322c77b76..5de084dab4fa 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -646,7 +646,11 @@ static int register_trace_kprobe(struct trace_kprobe *tk)
 	/* Register new event */
 	ret = register_kprobe_event(tk);
 	if (ret) {
-		pr_warn("Failed to register probe event(%d)\n", ret);
+		if (ret == -EEXIST) {
+			trace_probe_log_set_index(0);
+			trace_probe_log_err(0, EVENT_EXIST);
+		} else
+			pr_warn("Failed to register probe event(%d)\n", ret);
 		goto end;
 	}
 
diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index f98d6d94cbbf..23e85cb15134 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -1029,11 +1029,36 @@ int trace_probe_init(struct trace_probe *tp, const char *event,
 	return ret;
 }
 
+static struct trace_event_call *
+find_trace_event_call(const char *system, const char *event_name)
+{
+	struct trace_event_call *tp_event;
+	const char *name;
+
+	list_for_each_entry(tp_event, &ftrace_events, list) {
+		if (!tp_event->class->system ||
+		    strcmp(system, tp_event->class->system))
+			continue;
+		name = trace_event_name(tp_event);
+		if (!name || strcmp(event_name, name))
+			continue;
+		return tp_event;
+	}
+
+	return NULL;
+}
+
 int trace_probe_register_event_call(struct trace_probe *tp)
 {
 	struct trace_event_call *call = trace_probe_event_call(tp);
 	int ret;
 
+	lockdep_assert_held(&event_mutex);
+
+	if (find_trace_event_call(trace_probe_group_name(tp),
+				  trace_probe_name(tp)))
+		return -EEXIST;
+
 	ret = register_trace_event(&call->event);
 	if (!ret)
 		return -ENODEV;
diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
index a0ff9e200ef6..bab9e0dba9af 100644
--- a/kernel/trace/trace_probe.h
+++ b/kernel/trace/trace_probe.h
@@ -410,6 +410,7 @@ extern int traceprobe_define_arg_fields(struct trace_event_call *event_call,
 	C(NO_EVENT_NAME,	"Event name is not specified"),		\
 	C(EVENT_TOO_LONG,	"Event name is too long"),		\
 	C(BAD_EVENT_NAME,	"Event name must follow the same rules as C identifiers"), \
+	C(EVENT_EXIST,		"Given group/event name is already used by another event"), \
 	C(RETVAL_ON_PROBE,	"$retval is not available on probe"),	\
 	C(BAD_STACK_NUM,	"Invalid stack number"),		\
 	C(BAD_ARG_NUM,		"Invalid argument number"),		\
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 5294843de6ef..b515db036bec 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -514,7 +514,11 @@ static int register_trace_uprobe(struct trace_uprobe *tu)
 
 	ret = register_uprobe_event(tu);
 	if (ret) {
-		pr_warn("Failed to register probe event(%d)\n", ret);
+		if (ret == -EEXIST) {
+			trace_probe_log_set_index(0);
+			trace_probe_log_err(0, EVENT_EXIST);
+		} else
+			pr_warn("Failed to register probe event(%d)\n", ret);
 		goto end;
 	}
 
-- 
2.30.2

