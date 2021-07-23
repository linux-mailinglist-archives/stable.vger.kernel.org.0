Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E66AE3D3AB2
	for <lists+stable@lfdr.de>; Fri, 23 Jul 2021 14:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235158AbhGWMQC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Jul 2021 08:16:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:40098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235027AbhGWMQB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 23 Jul 2021 08:16:01 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F05D360F22;
        Fri, 23 Jul 2021 12:56:34 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@goodmis.org>)
        id 1m6ujC-001hhT-01; Fri, 23 Jul 2021 08:56:34 -0400
Message-ID: <20210723125633.840379520@goodmis.org>
User-Agent: quilt/0.66
Date:   Fri, 23 Jul 2021 08:54:57 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Namhyung Kim <namhyung@kernel.org>, stable@vger.kernel.org,
        Tom Zanussi <zanussi@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
Subject: [for-linus][PATCH 3/7] tracing/histogram: Rename "cpu" to "common_cpu"
References: <20210723125454.570472450@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Currently the histogram logic allows the user to write "cpu" in as an
event field, and it will record the CPU that the event happened on.

The problem with this is that there's a lot of events that have "cpu"
as a real field, and using "cpu" as the CPU it ran on, makes it
impossible to run histograms on the "cpu" field of events.

For example, if I want to have a histogram on the count of the
workqueue_queue_work event on its cpu field, running:

 ># echo 'hist:keys=cpu' > events/workqueue/workqueue_queue_work/trigger

Gives a misleading and wrong result.

Change the command to "common_cpu" as no event should have "common_*"
fields as that's a reserved name for fields used by all events. And
this makes sense here as common_cpu would be a field used by all events.

Now we can even do:

 ># echo 'hist:keys=common_cpu,cpu if cpu < 100' > events/workqueue/workqueue_queue_work/trigger
 ># cat events/workqueue/workqueue_queue_work/hist
 # event histogram
 #
 # trigger info: hist:keys=common_cpu,cpu:vals=hitcount:sort=hitcount:size=2048 if cpu < 100 [active]
 #

 { common_cpu:          0, cpu:          2 } hitcount:          1
 { common_cpu:          0, cpu:          4 } hitcount:          1
 { common_cpu:          7, cpu:          7 } hitcount:          1
 { common_cpu:          0, cpu:          7 } hitcount:          1
 { common_cpu:          0, cpu:          1 } hitcount:          1
 { common_cpu:          0, cpu:          6 } hitcount:          2
 { common_cpu:          0, cpu:          5 } hitcount:          2
 { common_cpu:          1, cpu:          1 } hitcount:          4
 { common_cpu:          6, cpu:          6 } hitcount:          4
 { common_cpu:          5, cpu:          5 } hitcount:         14
 { common_cpu:          4, cpu:          4 } hitcount:         26
 { common_cpu:          0, cpu:          0 } hitcount:         39
 { common_cpu:          2, cpu:          2 } hitcount:        184

Now for backward compatibility, I added a trick. If "cpu" is used, and
the field is not found, it will fall back to "common_cpu" and work as
it did before. This way, it will still work for old programs that use
"cpu" to get the actual CPU, but if the event has a "cpu" as a field, it
will get that event's "cpu" field, which is probably what it wants
anyway.

I updated the tracefs/README to include documentation about both the
common_timestamp and the common_cpu. This way, if that text is present in
the README, then an application can know that common_cpu is supported over
just plain "cpu".

Link: https://lkml.kernel.org/r/20210721110053.26b4f641@oasis.local.home

Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: stable@vger.kernel.org
Fixes: 8b7622bf94a44 ("tracing: Add cpu field for hist triggers")
Reviewed-by: Tom Zanussi <zanussi@kernel.org>
Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Documentation/trace/histogram.rst |  2 +-
 kernel/trace/trace.c              |  4 ++++
 kernel/trace/trace_events_hist.c  | 22 ++++++++++++++++------
 3 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/Documentation/trace/histogram.rst b/Documentation/trace/histogram.rst
index b71e09f745c3..f99be8062bc8 100644
--- a/Documentation/trace/histogram.rst
+++ b/Documentation/trace/histogram.rst
@@ -191,7 +191,7 @@ Documentation written by Tom Zanussi
                                 with the event, in nanoseconds.  May be
 			        modified by .usecs to have timestamps
 			        interpreted as microseconds.
-    cpu                    int  the cpu on which the event occurred.
+    common_cpu             int  the cpu on which the event occurred.
     ====================== ==== =======================================
 
 Extended error information
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index f8b80b5bab71..c59dd35a6da5 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -5609,6 +5609,10 @@ static const char readme_msg[] =
 	"\t            [:name=histname1]\n"
 	"\t            [:<handler>.<action>]\n"
 	"\t            [if <filter>]\n\n"
+	"\t    Note, special fields can be used as well:\n"
+	"\t            common_timestamp - to record current timestamp\n"
+	"\t            common_cpu - to record the CPU the event happened on\n"
+	"\n"
 	"\t    When a matching event is hit, an entry is added to a hash\n"
 	"\t    table using the key(s) and value(s) named, and the value of a\n"
 	"\t    sum called 'hitcount' is incremented.  Keys and values\n"
diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index 16a9dfc9fffc..34325f41ebc0 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -1111,7 +1111,7 @@ static const char *hist_field_name(struct hist_field *field,
 		 field->flags & HIST_FIELD_FL_ALIAS)
 		field_name = hist_field_name(field->operands[0], ++level);
 	else if (field->flags & HIST_FIELD_FL_CPU)
-		field_name = "cpu";
+		field_name = "common_cpu";
 	else if (field->flags & HIST_FIELD_FL_EXPR ||
 		 field->flags & HIST_FIELD_FL_VAR_REF) {
 		if (field->system) {
@@ -1991,14 +1991,24 @@ parse_field(struct hist_trigger_data *hist_data, struct trace_event_file *file,
 		hist_data->enable_timestamps = true;
 		if (*flags & HIST_FIELD_FL_TIMESTAMP_USECS)
 			hist_data->attrs->ts_in_usecs = true;
-	} else if (strcmp(field_name, "cpu") == 0)
+	} else if (strcmp(field_name, "common_cpu") == 0)
 		*flags |= HIST_FIELD_FL_CPU;
 	else {
 		field = trace_find_event_field(file->event_call, field_name);
 		if (!field || !field->size) {
-			hist_err(tr, HIST_ERR_FIELD_NOT_FOUND, errpos(field_name));
-			field = ERR_PTR(-EINVAL);
-			goto out;
+			/*
+			 * For backward compatibility, if field_name
+			 * was "cpu", then we treat this the same as
+			 * common_cpu.
+			 */
+			if (strcmp(field_name, "cpu") == 0) {
+				*flags |= HIST_FIELD_FL_CPU;
+			} else {
+				hist_err(tr, HIST_ERR_FIELD_NOT_FOUND,
+					 errpos(field_name));
+				field = ERR_PTR(-EINVAL);
+				goto out;
+			}
 		}
 	}
  out:
@@ -5085,7 +5095,7 @@ static void hist_field_print(struct seq_file *m, struct hist_field *hist_field)
 		seq_printf(m, "%s=", hist_field->var.name);
 
 	if (hist_field->flags & HIST_FIELD_FL_CPU)
-		seq_puts(m, "cpu");
+		seq_puts(m, "common_cpu");
 	else if (field_name) {
 		if (hist_field->flags & HIST_FIELD_FL_VAR_REF ||
 		    hist_field->flags & HIST_FIELD_FL_ALIAS)
-- 
2.30.2
