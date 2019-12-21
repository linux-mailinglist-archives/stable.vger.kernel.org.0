Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49F8E128BAA
	for <lists+stable@lfdr.de>; Sat, 21 Dec 2019 22:11:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727497AbfLUVLl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Dec 2019 16:11:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:36814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727339AbfLUVLf (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 21 Dec 2019 16:11:35 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 657C82070C;
        Sat, 21 Dec 2019 21:11:34 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92.3)
        (envelope-from <rostedt@goodmis.org>)
        id 1iim29-000o2N-G4; Sat, 21 Dec 2019 16:11:33 -0500
Message-Id: <20191221211133.369572328@goodmis.org>
User-Agent: quilt/0.65
Date:   Sat, 21 Dec 2019 16:11:09 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, Prateek Sood <prsood@codeaurora.org>
Subject: [for-linus][PATCH 3/5] tracing: Fix lock inversion in trace_event_enable_tgid_record()
References: <20191221211106.338673631@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Prateek Sood <prsood@codeaurora.org>

       Task T2                             Task T3
trace_options_core_write()            subsystem_open()

 mutex_lock(trace_types_lock)           mutex_lock(event_mutex)

 set_tracer_flag()

   trace_event_enable_tgid_record()       mutex_lock(trace_types_lock)

    mutex_lock(event_mutex)

This gives a circular dependency deadlock between trace_types_lock and
event_mutex. To fix this invert the usage of trace_types_lock and
event_mutex in trace_options_core_write(). This keeps the sequence of
lock usage consistent.

Link: http://lkml.kernel.org/r/0101016eef175e38-8ca71caf-a4eb-480d-a1e6-6f0bbc015495-000000@us-west-2.amazonses.com

Cc: stable@vger.kernel.org
Fixes: d914ba37d7145 ("tracing: Add support for recording tgid of tasks")
Signed-off-by: Prateek Sood <prsood@codeaurora.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/trace/trace.c        | 8 ++++++++
 kernel/trace/trace_events.c | 8 ++++----
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 6c75410f9698..ddb7e7f5fe8d 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4685,6 +4685,10 @@ int trace_keep_overwrite(struct tracer *tracer, u32 mask, int set)
 
 int set_tracer_flag(struct trace_array *tr, unsigned int mask, int enabled)
 {
+	if ((mask == TRACE_ITER_RECORD_TGID) ||
+	    (mask == TRACE_ITER_RECORD_CMD))
+		lockdep_assert_held(&event_mutex);
+
 	/* do nothing if flag is already set */
 	if (!!(tr->trace_flags & mask) == !!enabled)
 		return 0;
@@ -4752,6 +4756,7 @@ static int trace_set_options(struct trace_array *tr, char *option)
 
 	cmp += len;
 
+	mutex_lock(&event_mutex);
 	mutex_lock(&trace_types_lock);
 
 	ret = match_string(trace_options, -1, cmp);
@@ -4762,6 +4767,7 @@ static int trace_set_options(struct trace_array *tr, char *option)
 		ret = set_tracer_flag(tr, 1 << ret, !neg);
 
 	mutex_unlock(&trace_types_lock);
+	mutex_unlock(&event_mutex);
 
 	/*
 	 * If the first trailing whitespace is replaced with '\0' by strstrip,
@@ -8076,9 +8082,11 @@ trace_options_core_write(struct file *filp, const char __user *ubuf, size_t cnt,
 	if (val != 0 && val != 1)
 		return -EINVAL;
 
+	mutex_lock(&event_mutex);
 	mutex_lock(&trace_types_lock);
 	ret = set_tracer_flag(tr, 1 << index, val);
 	mutex_unlock(&trace_types_lock);
+	mutex_unlock(&event_mutex);
 
 	if (ret < 0)
 		return ret;
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index c6de3cebc127..a5b614cc3887 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -320,7 +320,8 @@ void trace_event_enable_cmd_record(bool enable)
 	struct trace_event_file *file;
 	struct trace_array *tr;
 
-	mutex_lock(&event_mutex);
+	lockdep_assert_held(&event_mutex);
+
 	do_for_each_event_file(tr, file) {
 
 		if (!(file->flags & EVENT_FILE_FL_ENABLED))
@@ -334,7 +335,6 @@ void trace_event_enable_cmd_record(bool enable)
 			clear_bit(EVENT_FILE_FL_RECORDED_CMD_BIT, &file->flags);
 		}
 	} while_for_each_event_file();
-	mutex_unlock(&event_mutex);
 }
 
 void trace_event_enable_tgid_record(bool enable)
@@ -342,7 +342,8 @@ void trace_event_enable_tgid_record(bool enable)
 	struct trace_event_file *file;
 	struct trace_array *tr;
 
-	mutex_lock(&event_mutex);
+	lockdep_assert_held(&event_mutex);
+
 	do_for_each_event_file(tr, file) {
 		if (!(file->flags & EVENT_FILE_FL_ENABLED))
 			continue;
@@ -356,7 +357,6 @@ void trace_event_enable_tgid_record(bool enable)
 				  &file->flags);
 		}
 	} while_for_each_event_file();
-	mutex_unlock(&event_mutex);
 }
 
 static int __ftrace_event_enable_disable(struct trace_event_file *file,
-- 
2.24.0


