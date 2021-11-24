Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 710EE45C243
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:23:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348715AbhKXN0r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:26:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:48372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348109AbhKXNYn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:24:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE22261057;
        Wed, 24 Nov 2021 12:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758138;
        bh=fw81+EASjhldrQmGseGFtvQNMPXgJN9D375yhTonjsM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xnt63cqdVF+3V81Nu2KsVPm5hse77y56r1DTvmvdVu5JyqguQn6h1+PntoKe83MGY
         HCLBwGYjQKzyJGOCy+Sh5XXUJ4Pf8u0nFf244EGKuaTAZIIQLvfzZbJMefuf7uOR/a
         UrwK1fepXr2B7saFqnBTg2T8yFH9oyaCr5KS81As=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Zanussi <zanussi@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 041/100] tracing: Save normal string variables
Date:   Wed, 24 Nov 2021 12:57:57 +0100
Message-Id: <20211124115656.213988852@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115654.849735859@linuxfoundation.org>
References: <20211124115654.849735859@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Zanussi <zanussi@kernel.org>

[ Upstream commit 63a1e5de3006f4ad713e4d72bcb404d0301e853d ]

String variables created as field variables and save variables are
already handled properly by having their values copied when set.  The
same isn't done for normal variables, but needs to be - simply saving
a pointer to a string contained in an old event isn't sufficient,
since that event's data may quickly become overwritten and therefore a
string pointer to it could yield garbage.

This change uses the same mechanism as field variables and simply
appends the new strings to the existing per-element field_var_str[]
array allocated for that purpose.

Link: https://lkml.kernel.org/r/1c1a03798b02e67307412a0c719d1bfb69b13007.1601848695.git.zanussi@kernel.org

Fixes: 02205a6752f2 (tracing: Add support for 'field variables')
Signed-off-by: Tom Zanussi <zanussi@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events_hist.c | 34 ++++++++++++++++++++++++++++++--
 1 file changed, 32 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index f63766366e238..9a73c187d241e 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -149,6 +149,8 @@ struct hist_field {
 	 */
 	unsigned int			var_ref_idx;
 	bool                            read_once;
+
+	unsigned int			var_str_idx;
 };
 
 static u64 hist_field_none(struct hist_field *field,
@@ -351,6 +353,7 @@ struct hist_trigger_data {
 	unsigned int			n_keys;
 	unsigned int			n_fields;
 	unsigned int			n_vars;
+	unsigned int			n_var_str;
 	unsigned int			key_size;
 	struct tracing_map_sort_key	sort_keys[TRACING_MAP_SORT_KEYS_MAX];
 	unsigned int			n_sort_keys;
@@ -2305,7 +2308,12 @@ static int hist_trigger_elt_data_alloc(struct tracing_map_elt *elt)
 		}
 	}
 
-	n_str = hist_data->n_field_var_str + hist_data->n_save_var_str;
+	n_str = hist_data->n_field_var_str + hist_data->n_save_var_str +
+		hist_data->n_var_str;
+	if (n_str > SYNTH_FIELDS_MAX) {
+		hist_elt_data_free(elt_data);
+		return -EINVAL;
+	}
 
 	size = STR_VAR_LEN_MAX;
 
@@ -4599,6 +4607,7 @@ static int create_var_field(struct hist_trigger_data *hist_data,
 {
 	struct trace_array *tr = hist_data->event_file->tr;
 	unsigned long flags = 0;
+	int ret;
 
 	if (WARN_ON(val_idx >= TRACING_MAP_VALS_MAX + TRACING_MAP_VARS_MAX))
 		return -EINVAL;
@@ -4613,7 +4622,12 @@ static int create_var_field(struct hist_trigger_data *hist_data,
 	if (WARN_ON(hist_data->n_vars > TRACING_MAP_VARS_MAX))
 		return -EINVAL;
 
-	return __create_val_field(hist_data, val_idx, file, var_name, expr_str, flags);
+	ret = __create_val_field(hist_data, val_idx, file, var_name, expr_str, flags);
+
+	if (hist_data->fields[val_idx]->flags & HIST_FIELD_FL_STRING)
+		hist_data->fields[val_idx]->var_str_idx = hist_data->n_var_str++;
+
+	return ret;
 }
 
 static int create_val_fields(struct hist_trigger_data *hist_data,
@@ -5333,6 +5347,22 @@ static void hist_trigger_elt_update(struct hist_trigger_data *hist_data,
 		hist_val = hist_field->fn(hist_field, elt, rbe, rec);
 		if (hist_field->flags & HIST_FIELD_FL_VAR) {
 			var_idx = hist_field->var.idx;
+
+			if (hist_field->flags & HIST_FIELD_FL_STRING) {
+				unsigned int str_start, var_str_idx, idx;
+				char *str, *val_str;
+
+				str_start = hist_data->n_field_var_str +
+					hist_data->n_save_var_str;
+				var_str_idx = hist_field->var_str_idx;
+				idx = str_start + var_str_idx;
+
+				str = elt_data->field_var_str[idx];
+				val_str = (char *)(uintptr_t)hist_val;
+				strscpy(str, val_str, STR_VAR_LEN_MAX);
+
+				hist_val = (u64)(uintptr_t)str;
+			}
 			tracing_map_set_var(elt, var_idx, hist_val);
 			continue;
 		}
-- 
2.33.0



