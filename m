Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B32F2143FBB
	for <lists+stable@lfdr.de>; Tue, 21 Jan 2020 15:40:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729340AbgAUOkD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jan 2020 09:40:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:56142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728916AbgAUOj7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Jan 2020 09:39:59 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CF9624125;
        Tue, 21 Jan 2020 14:39:58 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.93)
        (envelope-from <rostedt@goodmis.org>)
        id 1ituhB-000dyY-1A; Tue, 21 Jan 2020 09:39:57 -0500
Message-Id: <20200121143956.921051524@goodmis.org>
User-Agent: quilt/0.65
Date:   Tue, 21 Jan 2020 09:38:51 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, Tom Zanuss <zanussi@kernel.org>
Subject: [for-linus][PATCH 4/5] tracing: Fix histogram code when expression has same var as value
References: <20200121143847.609307852@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

While working on a tool to convert SQL syntex into the histogram language of
the kernel, I discovered the following bug:

 # echo 'first u64 start_time u64 end_time pid_t pid u64 delta' >> synthetic_events
 # echo 'hist:keys=pid:start=common_timestamp' > events/sched/sched_waking/trigger
 # echo 'hist:keys=next_pid:delta=common_timestamp-$start,start2=$start:onmatch(sched.sched_waking).trace(first,$start2,common_timestamp,next_pid,$delta)' > events/sched/sched_switch/trigger

Would not display any histograms in the sched_switch histogram side.

But if I were to swap the location of

  "delta=common_timestamp-$start" with "start2=$start"

Such that the last line had:

 # echo 'hist:keys=next_pid:start2=$start,delta=common_timestamp-$start:onmatch(sched.sched_waking).trace(first,$start2,common_timestamp,next_pid,$delta)' > events/sched/sched_switch/trigger

The histogram works as expected.

What I found out is that the expressions clear out the value once it is
resolved. As the variables are resolved in the order listed, when
processing:

  delta=common_timestamp-$start

The $start is cleared. When it gets to "start2=$start", it errors out with
"unresolved symbol" (which is silent as this happens at the location of the
trace), and the histogram is dropped.

When processing the histogram for variable references, instead of adding a
new reference for a variable used twice, use the same reference. That way,
not only is it more efficient, but the order will no longer matter in
processing of the variables.

From Tom Zanussi:

 "Just to clarify some more about what the problem was is that without
  your patch, we would have two separate references to the same variable,
  and during resolve_var_refs(), they'd both want to be resolved
  separately, so in this case, since the first reference to start wasn't
  part of an expression, it wouldn't get the read-once flag set, so would
  be read normally, and then the second reference would do the read-once
  read and also be read but using read-once.  So everything worked and
  you didn't see a problem:

   from: start2=$start,delta=common_timestamp-$start

  In the second case, when you switched them around, the first reference
  would be resolved by doing the read-once, and following that the second
  reference would try to resolve and see that the variable had already
  been read, so failed as unset, which caused it to short-circuit out and
  not do the trigger action to generate the synthetic event:

   to: delta=common_timestamp-$start,start2=$start

  With your patch, we only have the single resolution which happens
  correctly the one time it's resolved, so this can't happen."

Link: https://lore.kernel.org/r/20200116154216.58ca08eb@gandalf.local.home

Cc: stable@vger.kernel.org
Fixes: 067fe038e70f6 ("tracing: Add variable reference handling to hist triggers")
Reviewed-by: Tom Zanuss <zanussi@kernel.org>
Tested-by: Tom Zanussi <zanussi@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/trace/trace_events_hist.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index d33b046f985a..6ac35b9e195d 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -116,6 +116,7 @@ struct hist_field {
 	struct ftrace_event_field	*field;
 	unsigned long			flags;
 	hist_field_fn_t			fn;
+	unsigned int			ref;
 	unsigned int			size;
 	unsigned int			offset;
 	unsigned int                    is_signed;
@@ -2427,8 +2428,16 @@ static int contains_operator(char *str)
 	return field_op;
 }
 
+static void get_hist_field(struct hist_field *hist_field)
+{
+	hist_field->ref++;
+}
+
 static void __destroy_hist_field(struct hist_field *hist_field)
 {
+	if (--hist_field->ref > 1)
+		return;
+
 	kfree(hist_field->var.name);
 	kfree(hist_field->name);
 	kfree(hist_field->type);
@@ -2470,6 +2479,8 @@ static struct hist_field *create_hist_field(struct hist_trigger_data *hist_data,
 	if (!hist_field)
 		return NULL;
 
+	hist_field->ref = 1;
+
 	hist_field->hist_data = hist_data;
 
 	if (flags & HIST_FIELD_FL_EXPR || flags & HIST_FIELD_FL_ALIAS)
@@ -2665,6 +2676,17 @@ static struct hist_field *create_var_ref(struct hist_trigger_data *hist_data,
 {
 	unsigned long flags = HIST_FIELD_FL_VAR_REF;
 	struct hist_field *ref_field;
+	int i;
+
+	/* Check if the variable already exists */
+	for (i = 0; i < hist_data->n_var_refs; i++) {
+		ref_field = hist_data->var_refs[i];
+		if (ref_field->var.idx == var_field->var.idx &&
+		    ref_field->var.hist_data == var_field->hist_data) {
+			get_hist_field(ref_field);
+			return ref_field;
+		}
+	}
 
 	ref_field = create_hist_field(var_field->hist_data, NULL, flags, NULL);
 	if (ref_field) {
-- 
2.24.1


