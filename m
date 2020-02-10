Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5D03157A88
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:23:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728807AbgBJNXM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:23:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:58488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728687AbgBJMhP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:37:15 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5EB52051A;
        Mon, 10 Feb 2020 12:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338234;
        bh=Ye4lnjwhH51N0viwX0rcubsBLFSahMBhcDauu9keFiI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GblD2DS7eit13XUUvSlMik1ZGk5E7yn5Ul8q9tvPDvJnF82iL4oODYaxr3z0oNVsQ
         /4qbyMyszmSExV7K8KcNDG8V4zlOAbBOeeyz+sr60gHcycyCJ7VzLO43FskrLzT5AT
         s6Eo+n/agyCox/P/ebMb9I3DUO4KSsCau3x04xo0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Zanussi <zanussi@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 080/309] tracing: Fix now invalid var_ref_vals assumption in trace action
Date:   Mon, 10 Feb 2020 04:30:36 -0800
Message-Id: <20200210122413.528845335@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Zanussi <zanussi@kernel.org>

[ Upstream commit d380dcde9a07ca5de4805dee11f58a98ec0ad6ff ]

The patch 'tracing: Fix histogram code when expression has same var as
value' added code to return an existing variable reference when
creating a new variable reference, which resulted in var_ref_vals
slots being reused instead of being duplicated.

The implementation of the trace action assumes that the end of the
var_ref_vals array starting at action_data.var_ref_idx corresponds to
the values that will be assigned to the trace params. The patch
mentioned above invalidates that assumption, which means that each
param needs to explicitly specify its index into var_ref_vals.

This fix changes action_data.var_ref_idx to an array of var ref
indexes to account for that.

Link: https://lore.kernel.org/r/1580335695.6220.8.camel@kernel.org

Fixes: 8bcebc77e85f ("tracing: Fix histogram code when expression has same var as value")
Signed-off-by: Tom Zanussi <zanussi@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events_hist.c |   53 +++++++++++++++++++++++++++------------
 1 file changed, 38 insertions(+), 15 deletions(-)

--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -470,11 +470,12 @@ struct action_data {
 	 * When a histogram trigger is hit, the values of any
 	 * references to variables, including variables being passed
 	 * as parameters to synthetic events, are collected into a
-	 * var_ref_vals array.  This var_ref_idx is the index of the
-	 * first param in the array to be passed to the synthetic
-	 * event invocation.
+	 * var_ref_vals array.  This var_ref_idx array is an array of
+	 * indices into the var_ref_vals array, one for each synthetic
+	 * event param, and is passed to the synthetic event
+	 * invocation.
 	 */
-	unsigned int		var_ref_idx;
+	unsigned int		var_ref_idx[TRACING_MAP_VARS_MAX];
 	struct synth_event	*synth_event;
 	bool			use_trace_keyword;
 	char			*synth_event_name;
@@ -875,14 +876,14 @@ static struct trace_event_functions synt
 
 static notrace void trace_event_raw_event_synth(void *__data,
 						u64 *var_ref_vals,
-						unsigned int var_ref_idx)
+						unsigned int *var_ref_idx)
 {
 	struct trace_event_file *trace_file = __data;
 	struct synth_trace_event *entry;
 	struct trace_event_buffer fbuffer;
 	struct ring_buffer *buffer;
 	struct synth_event *event;
-	unsigned int i, n_u64;
+	unsigned int i, n_u64, val_idx;
 	int fields_size = 0;
 
 	event = trace_file->event_call->data;
@@ -905,15 +906,16 @@ static notrace void trace_event_raw_even
 		goto out;
 
 	for (i = 0, n_u64 = 0; i < event->n_fields; i++) {
+		val_idx = var_ref_idx[i];
 		if (event->fields[i]->is_string) {
-			char *str_val = (char *)(long)var_ref_vals[var_ref_idx + i];
+			char *str_val = (char *)(long)var_ref_vals[val_idx];
 			char *str_field = (char *)&entry->fields[n_u64];
 
 			strscpy(str_field, str_val, STR_VAR_LEN_MAX);
 			n_u64 += STR_VAR_LEN_MAX / sizeof(u64);
 		} else {
 			struct synth_field *field = event->fields[i];
-			u64 val = var_ref_vals[var_ref_idx + i];
+			u64 val = var_ref_vals[val_idx];
 
 			switch (field->size) {
 			case 1:
@@ -1113,10 +1115,10 @@ static struct tracepoint *alloc_synth_tr
 }
 
 typedef void (*synth_probe_func_t) (void *__data, u64 *var_ref_vals,
-				    unsigned int var_ref_idx);
+				    unsigned int *var_ref_idx);
 
 static inline void trace_synth(struct synth_event *event, u64 *var_ref_vals,
-			       unsigned int var_ref_idx)
+			       unsigned int *var_ref_idx)
 {
 	struct tracepoint *tp = event->tp;
 
@@ -2655,6 +2657,22 @@ static int init_var_ref(struct hist_fiel
 	goto out;
 }
 
+static int find_var_ref_idx(struct hist_trigger_data *hist_data,
+			    struct hist_field *var_field)
+{
+	struct hist_field *ref_field;
+	int i;
+
+	for (i = 0; i < hist_data->n_var_refs; i++) {
+		ref_field = hist_data->var_refs[i];
+		if (ref_field->var.idx == var_field->var.idx &&
+		    ref_field->var.hist_data == var_field->hist_data)
+			return i;
+	}
+
+	return -ENOENT;
+}
+
 /**
  * create_var_ref - Create a variable reference and attach it to trigger
  * @hist_data: The trigger that will be referencing the variable
@@ -4228,11 +4246,11 @@ static int trace_action_create(struct hi
 	struct trace_array *tr = hist_data->event_file->tr;
 	char *event_name, *param, *system = NULL;
 	struct hist_field *hist_field, *var_ref;
-	unsigned int i, var_ref_idx;
+	unsigned int i;
 	unsigned int field_pos = 0;
 	struct synth_event *event;
 	char *synth_event_name;
-	int ret = 0;
+	int var_ref_idx, ret = 0;
 
 	lockdep_assert_held(&event_mutex);
 
@@ -4249,8 +4267,6 @@ static int trace_action_create(struct hi
 
 	event->ref++;
 
-	var_ref_idx = hist_data->n_var_refs;
-
 	for (i = 0; i < data->n_params; i++) {
 		char *p;
 
@@ -4299,6 +4315,14 @@ static int trace_action_create(struct hi
 				goto err;
 			}
 
+			var_ref_idx = find_var_ref_idx(hist_data, var_ref);
+			if (WARN_ON(var_ref_idx < 0)) {
+				ret = var_ref_idx;
+				goto err;
+			}
+
+			data->var_ref_idx[i] = var_ref_idx;
+
 			field_pos++;
 			kfree(p);
 			continue;
@@ -4317,7 +4341,6 @@ static int trace_action_create(struct hi
 	}
 
 	data->synth_event = event;
-	data->var_ref_idx = var_ref_idx;
  out:
 	return ret;
  err:


