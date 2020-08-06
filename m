Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56EE023DF24
	for <lists+stable@lfdr.de>; Thu,  6 Aug 2020 19:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729495AbgHFRii (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Aug 2020 13:38:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:55144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729811AbgHFRbn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Aug 2020 13:31:43 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 714F82311E;
        Thu,  6 Aug 2020 13:11:33 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.93)
        (envelope-from <rostedt@goodmis.org>)
        id 1k3fgC-006KUf-3J; Thu, 06 Aug 2020 09:11:32 -0400
Message-ID: <20200806131131.981451078@goodmis.org>
User-Agent: quilt/0.66
Date:   Thu, 06 Aug 2020 09:11:10 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>
Subject: [for-linus][PATCH 2/3] tracing: Use trace_sched_process_free() instead of exit() for pid
 tracing
References: <20200806131108.374130743@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

On exit, if a process is preempted after the trace_sched_process_exit()
tracepoint but before the process is done exiting, then when it gets
scheduled in, the function tracers will not filter it properly against the
function tracing pid filters.

That is because the function tracing pid filters hooks to the
sched_process_exit() tracepoint to remove the exiting task's pid from the
filter list. Because the filtering happens at the sched_switch tracepoint,
when the exiting task schedules back in to finish up the exit, it will no
longer be in the function pid filtering tables.

This was noticeable in the notrace self tests on a preemptable kernel, as
the tests would fail as it exits and preempted after being taken off the
notrace filter table and on scheduling back in it would not be in the
notrace list, and then the ending of the exit function would trace. The test
detected this and would fail.

Cc: stable@vger.kernel.org
Cc: Namhyung Kim <namhyung@kernel.org>
Fixes: 1e10486ffee0a ("ftrace: Add 'function-fork' trace option")
Fixes: c37775d57830a ("tracing: Add infrastructure to allow set_event_pid to follow children"
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c       | 4 ++--
 kernel/trace/trace_events.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 4e3a5d79c078..76f2dd6fd414 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -6985,12 +6985,12 @@ void ftrace_pid_follow_fork(struct trace_array *tr, bool enable)
 	if (enable) {
 		register_trace_sched_process_fork(ftrace_pid_follow_sched_process_fork,
 						  tr);
-		register_trace_sched_process_exit(ftrace_pid_follow_sched_process_exit,
+		register_trace_sched_process_free(ftrace_pid_follow_sched_process_exit,
 						  tr);
 	} else {
 		unregister_trace_sched_process_fork(ftrace_pid_follow_sched_process_fork,
 						    tr);
-		unregister_trace_sched_process_exit(ftrace_pid_follow_sched_process_exit,
+		unregister_trace_sched_process_free(ftrace_pid_follow_sched_process_exit,
 						    tr);
 	}
 }
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index f6f55682d3e2..a85effb2373b 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -538,12 +538,12 @@ void trace_event_follow_fork(struct trace_array *tr, bool enable)
 	if (enable) {
 		register_trace_prio_sched_process_fork(event_filter_pid_sched_process_fork,
 						       tr, INT_MIN);
-		register_trace_prio_sched_process_exit(event_filter_pid_sched_process_exit,
+		register_trace_prio_sched_process_free(event_filter_pid_sched_process_exit,
 						       tr, INT_MAX);
 	} else {
 		unregister_trace_sched_process_fork(event_filter_pid_sched_process_fork,
 						    tr);
-		unregister_trace_sched_process_exit(event_filter_pid_sched_process_exit,
+		unregister_trace_sched_process_free(event_filter_pid_sched_process_exit,
 						    tr);
 	}
 }
-- 
2.26.2


