Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E934A14B953
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:33:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387619AbgA1OaZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:30:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:57448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387614AbgA1O3J (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:29:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 38B9721739;
        Tue, 28 Jan 2020 14:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221747;
        bh=SGN8Qz2eSMkSW3JyldVokWfkqjyn9HgNuVf/9HIHyfo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GTr5YPyFB+GHvgTH7BPF1AE03Eau5vzUbiDj9iie/RTT009Ocxvfpbw+NRUOYfzV7
         IoI5f0NEKMG0QRJNDd2QampI6K5B6xcF4Y7WpWfH6HcofZssJ8KjuhhW4w4TWU/sZT
         XvJSlHx0k4jMHOM3FWVPRqDxkl7jPzp6um9inq3E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Zanuss <zanussi@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 4.19 58/92] tracing: Fix histogram code when expression has same var as value
Date:   Tue, 28 Jan 2020 15:08:26 +0100
Message-Id: <20200128135816.670214575@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135809.344954797@linuxfoundation.org>
References: <20200128135809.344954797@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

commit 8bcebc77e85f3d7536f96845a0fe94b1dddb6af0 upstream.

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

>From Tom Zanussi:

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/trace_events_hist.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -49,6 +49,7 @@ struct hist_field {
 	struct ftrace_event_field	*field;
 	unsigned long			flags;
 	hist_field_fn_t			fn;
+	unsigned int			ref;
 	unsigned int			size;
 	unsigned int			offset;
 	unsigned int                    is_signed;
@@ -2225,8 +2226,16 @@ static int contains_operator(char *str)
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
@@ -2268,6 +2277,8 @@ static struct hist_field *create_hist_fi
 	if (!hist_field)
 		return NULL;
 
+	hist_field->ref = 1;
+
 	hist_field->hist_data = hist_data;
 
 	if (flags & HIST_FIELD_FL_EXPR || flags & HIST_FIELD_FL_ALIAS)
@@ -2463,6 +2474,17 @@ static struct hist_field *create_var_ref
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


