Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5343F3E3249
	for <lists+stable@lfdr.de>; Sat,  7 Aug 2021 02:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbhHGAWT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 20:22:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:56330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229581AbhHGAWT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 20:22:19 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10653603E7;
        Sat,  7 Aug 2021 00:22:01 +0000 (UTC)
Date:   Fri, 6 Aug 2021 20:21:55 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <gregkh@linuxfoundation.org>
Cc:     akpm@linux-foundation.org, mhiramat@kernel.org, mingo@kernel.org,
        namhyung@kernel.org, zanussi@kernel.org, <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] tracing/histogram: Rename "cpu" to
 "common_cpu"" failed to apply to 4.19-stable tree
Message-ID: <20210806202155.20445a11@oasis.local.home>
In-Reply-To: <1627289097126136@kroah.com>
References: <1627289097126136@kroah.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 26 Jul 2021 10:44:57 +0200
<gregkh@linuxfoundation.org> wrote:

> The patch below does not apply to the 4.19-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

The below should work for 4.19. I fixed the conflicts and tested it.

-- Steve


>From 1e3bac71c5053c99d438771fc9fa5082ae5d90aa Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Date: Wed, 21 Jul 2021 11:00:53 -0400
Subject: [PATCH] tracing/histogram: Rename "cpu" to "common_cpu"

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

Index: linux-test.git/Documentation/trace/histogram.rst
===================================================================
--- linux-test.git.orig/Documentation/trace/histogram.rst
+++ linux-test.git/Documentation/trace/histogram.rst
@@ -191,7 +191,7 @@ Documentation written by Tom Zanussi
                                 with the event, in nanoseconds.  May be
 			        modified by .usecs to have timestamps
 			        interpreted as microseconds.
-    cpu                    int  the cpu on which the event occurred.
+    common_cpu             int  the cpu on which the event occurred.
     ====================== ==== =======================================
 
 Extended error information
Index: linux-test.git/kernel/trace/trace.c
===================================================================
--- linux-test.git.orig/kernel/trace/trace.c
+++ linux-test.git/kernel/trace/trace.c
@@ -4727,6 +4727,10 @@ static const char readme_msg[] =
 	"\t            [:pause][:continue][:clear]\n"
 	"\t            [:name=histname1]\n"
 	"\t            [if <filter>]\n\n"
+	"\t    Note, special fields can be used as well:\n"
+	"\t            common_timestamp - to record current timestamp\n"
+	"\t            common_cpu - to record the CPU the event happened on\n"
+	"\n"
 	"\t    When a matching event is hit, an entry is added to a hash\n"
 	"\t    table using the key(s) and value(s) named, and the value of a\n"
 	"\t    sum called 'hitcount' is incremented.  Keys and values\n"
Index: linux-test.git/kernel/trace/trace_events_hist.c
===================================================================
--- linux-test.git.orig/kernel/trace/trace_events_hist.c
+++ linux-test.git/kernel/trace/trace_events_hist.c
@@ -1773,7 +1773,7 @@ static const char *hist_field_name(struc
 		 field->flags & HIST_FIELD_FL_ALIAS)
 		field_name = hist_field_name(field->operands[0], ++level);
 	else if (field->flags & HIST_FIELD_FL_CPU)
-		field_name = "cpu";
+		field_name = "common_cpu";
 	else if (field->flags & HIST_FIELD_FL_EXPR ||
 		 field->flags & HIST_FIELD_FL_VAR_REF) {
 		if (field->system) {
@@ -2627,14 +2627,23 @@ parse_field(struct hist_trigger_data *hi
 		hist_data->enable_timestamps = true;
 		if (*flags & HIST_FIELD_FL_TIMESTAMP_USECS)
 			hist_data->attrs->ts_in_usecs = true;
-	} else if (strcmp(field_name, "cpu") == 0)
+	} else if (strcmp(field_name, "common_cpu") == 0)
 		*flags |= HIST_FIELD_FL_CPU;
 	else {
 		field = trace_find_event_field(file->event_call, field_name);
 		if (!field || !field->size) {
-			hist_err("Couldn't find field: ", field_name);
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
+				hist_err("Couldn't find field: ", field_name);
+				field = ERR_PTR(-EINVAL);
+				goto out;
+			}
 		}
 	}
  out:
@@ -5048,7 +5057,7 @@ static void hist_field_print(struct seq_
 		seq_printf(m, "%s=", hist_field->var.name);
 
 	if (hist_field->flags & HIST_FIELD_FL_CPU)
-		seq_puts(m, "cpu");
+		seq_puts(m, "common_cpu");
 	else if (field_name) {
 		if (hist_field->flags & HIST_FIELD_FL_VAR_REF ||
 		    hist_field->flags & HIST_FIELD_FL_ALIAS)
