Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71D7F3D60F9
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237399AbhGZPZx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:25:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:40160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238205AbhGZPZK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:25:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 328C260240;
        Mon, 26 Jul 2021 16:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315537;
        bh=0xJFq9/VPxiLProRyjJC3dWEwG6bWuO3KFVp7IFpMdM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V1Nnpc9jI+5X7pFkKd6HPaNchAUlJX9ORJmfuIG1IVc+ZCJYlksTcDBZYd3laYT6+
         hnOM1utdiQ91d48Ch6wN9K7L28hoQqXSJqp823ps7RGSck5ZwPHw3X1BTMk17WKvHR
         dwGzrQdE/ZA5rRxppKquP9zsqpL8tnJ/B5CvJduY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tom Zanussi <zanussi@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.10 135/167] tracing/histogram: Rename "cpu" to "common_cpu"
Date:   Mon, 26 Jul 2021 17:39:28 +0200
Message-Id: <20210726153843.918896978@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153839.371771838@linuxfoundation.org>
References: <20210726153839.371771838@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

commit 1e3bac71c5053c99d438771fc9fa5082ae5d90aa upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/trace/histogram.rst |    2 +-
 kernel/trace/trace.c              |    4 ++++
 kernel/trace/trace_events_hist.c  |   22 ++++++++++++++++------
 3 files changed, 21 insertions(+), 7 deletions(-)

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
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -5241,6 +5241,10 @@ static const char readme_msg[] =
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
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -1095,7 +1095,7 @@ static const char *hist_field_name(struc
 		 field->flags & HIST_FIELD_FL_ALIAS)
 		field_name = hist_field_name(field->operands[0], ++level);
 	else if (field->flags & HIST_FIELD_FL_CPU)
-		field_name = "cpu";
+		field_name = "common_cpu";
 	else if (field->flags & HIST_FIELD_FL_EXPR ||
 		 field->flags & HIST_FIELD_FL_VAR_REF) {
 		if (field->system) {
@@ -1975,14 +1975,24 @@ parse_field(struct hist_trigger_data *hi
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
@@ -5057,7 +5067,7 @@ static void hist_field_print(struct seq_
 		seq_printf(m, "%s=", hist_field->var.name);
 
 	if (hist_field->flags & HIST_FIELD_FL_CPU)
-		seq_puts(m, "cpu");
+		seq_puts(m, "common_cpu");
 	else if (field_name) {
 		if (hist_field->flags & HIST_FIELD_FL_VAR_REF ||
 		    hist_field->flags & HIST_FIELD_FL_ALIAS)


