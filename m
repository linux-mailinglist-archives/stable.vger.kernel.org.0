Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22AEB14B8F2
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:29:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733249AbgA1O3G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:29:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:57384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387593AbgA1O3G (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:29:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D8F424691;
        Tue, 28 Jan 2020 14:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221745;
        bh=eycd+sZi3O1twm6Uaq9slvBCns8jEhQ/fIQWbP71Iwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y5gg3suAv6Ix25ZR3iKKX8J7TbVpcjLdkc5uYDJj3Je5z1TdfbbmPI9bzKpAzB0en
         AVYALrvbUntoTojf6TbrSoDEknz5MyRjdRZgv43CoAyM+lVSxjalDmEpxS2qjw5kul
         d6LaT89vFBAEOY2mViFtlmhmSYE3IRkqU5unCo6o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 4.19 57/92] tracing: Remove open-coding of hist trigger var_ref management
Date:   Tue, 28 Jan 2020 15:08:25 +0100
Message-Id: <20200128135816.530516255@linuxfoundation.org>
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

From: Tom Zanussi <tom.zanussi@linux.intel.com>

commit de40f033d4e84e843d6a12266e3869015ea9097c upstream.

Have create_var_ref() manage the hist trigger's var_ref list, rather
than having similar code doing it in multiple places.  This cleans up
the code and makes sure var_refs are always accounted properly.

Also, document the var_ref-related functions to make what their
purpose clearer.

Link: http://lkml.kernel.org/r/05ddae93ff514e66fc03897d6665231892939913.1545161087.git.tom.zanussi@linux.intel.com

Acked-by: Namhyung Kim <namhyung@kernel.org>
Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/trace_events_hist.c |   93 +++++++++++++++++++++++++++++++--------
 1 file changed, 75 insertions(+), 18 deletions(-)

--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -1274,6 +1274,17 @@ static u64 hist_field_cpu(struct hist_fi
 	return cpu;
 }
 
+/**
+ * check_field_for_var_ref - Check if a VAR_REF field references a variable
+ * @hist_field: The VAR_REF field to check
+ * @var_data: The hist trigger that owns the variable
+ * @var_idx: The trigger variable identifier
+ *
+ * Check the given VAR_REF field to see whether or not it references
+ * the given variable associated with the given trigger.
+ *
+ * Return: The VAR_REF field if it does reference the variable, NULL if not
+ */
 static struct hist_field *
 check_field_for_var_ref(struct hist_field *hist_field,
 			struct hist_trigger_data *var_data,
@@ -1324,6 +1335,18 @@ check_field_for_var_refs(struct hist_tri
 	return found;
 }
 
+/**
+ * find_var_ref - Check if a trigger has a reference to a trigger variable
+ * @hist_data: The hist trigger that might have a reference to the variable
+ * @var_data: The hist trigger that owns the variable
+ * @var_idx: The trigger variable identifier
+ *
+ * Check the list of var_refs[] on the first hist trigger to see
+ * whether any of them are references to the variable on the second
+ * trigger.
+ *
+ * Return: The VAR_REF field referencing the variable if so, NULL if not
+ */
 static struct hist_field *find_var_ref(struct hist_trigger_data *hist_data,
 				       struct hist_trigger_data *var_data,
 				       unsigned int var_idx)
@@ -1350,6 +1373,20 @@ static struct hist_field *find_var_ref(s
 	return found;
 }
 
+/**
+ * find_any_var_ref - Check if there is a reference to a given trigger variable
+ * @hist_data: The hist trigger
+ * @var_idx: The trigger variable identifier
+ *
+ * Check to see whether the given variable is currently referenced by
+ * any other trigger.
+ *
+ * The trigger the variable is defined on is explicitly excluded - the
+ * assumption being that a self-reference doesn't prevent a trigger
+ * from being removed.
+ *
+ * Return: The VAR_REF field referencing the variable if so, NULL if not
+ */
 static struct hist_field *find_any_var_ref(struct hist_trigger_data *hist_data,
 					   unsigned int var_idx)
 {
@@ -1368,6 +1405,19 @@ static struct hist_field *find_any_var_r
 	return found;
 }
 
+/**
+ * check_var_refs - Check if there is a reference to any of trigger's variables
+ * @hist_data: The hist trigger
+ *
+ * A trigger can define one or more variables.  If any one of them is
+ * currently referenced by any other trigger, this function will
+ * determine that.
+
+ * Typically used to determine whether or not a trigger can be removed
+ * - if there are any references to a trigger's variables, it cannot.
+ *
+ * Return: True if there is a reference to any of trigger's variables
+ */
 static bool check_var_refs(struct hist_trigger_data *hist_data)
 {
 	struct hist_field *field;
@@ -2392,7 +2442,23 @@ static int init_var_ref(struct hist_fiel
 	goto out;
 }
 
-static struct hist_field *create_var_ref(struct hist_field *var_field,
+/**
+ * create_var_ref - Create a variable reference and attach it to trigger
+ * @hist_data: The trigger that will be referencing the variable
+ * @var_field: The VAR field to create a reference to
+ * @system: The optional system string
+ * @event_name: The optional event_name string
+ *
+ * Given a variable hist_field, create a VAR_REF hist_field that
+ * represents a reference to it.
+ *
+ * This function also adds the reference to the trigger that
+ * now references the variable.
+ *
+ * Return: The VAR_REF field if successful, NULL if not
+ */
+static struct hist_field *create_var_ref(struct hist_trigger_data *hist_data,
+					 struct hist_field *var_field,
 					 char *system, char *event_name)
 {
 	unsigned long flags = HIST_FIELD_FL_VAR_REF;
@@ -2404,6 +2470,9 @@ static struct hist_field *create_var_ref
 			destroy_hist_field(ref_field, 0);
 			return NULL;
 		}
+
+		hist_data->var_refs[hist_data->n_var_refs] = ref_field;
+		ref_field->var_ref_idx = hist_data->n_var_refs++;
 	}
 
 	return ref_field;
@@ -2477,7 +2546,8 @@ static struct hist_field *parse_var_ref(
 
 	var_field = find_event_var(hist_data, system, event_name, var_name);
 	if (var_field)
-		ref_field = create_var_ref(var_field, system, event_name);
+		ref_field = create_var_ref(hist_data, var_field,
+					   system, event_name);
 
 	if (!ref_field)
 		hist_err_event("Couldn't find variable: $",
@@ -2597,8 +2667,6 @@ static struct hist_field *parse_atom(str
 	if (!s) {
 		hist_field = parse_var_ref(hist_data, ref_system, ref_event, ref_var);
 		if (hist_field) {
-			hist_data->var_refs[hist_data->n_var_refs] = hist_field;
-			hist_field->var_ref_idx = hist_data->n_var_refs++;
 			if (var_name) {
 				hist_field = create_alias(hist_data, hist_field, var_name);
 				if (!hist_field) {
@@ -3376,7 +3444,6 @@ static int onmax_create(struct hist_trig
 	unsigned int var_ref_idx = hist_data->n_var_refs;
 	struct field_var *field_var;
 	char *onmax_var_str, *param;
-	unsigned long flags;
 	unsigned int i;
 	int ret = 0;
 
@@ -3393,18 +3460,10 @@ static int onmax_create(struct hist_trig
 		return -EINVAL;
 	}
 
-	flags = HIST_FIELD_FL_VAR_REF;
-	ref_field = create_hist_field(hist_data, NULL, flags, NULL);
+	ref_field = create_var_ref(hist_data, var_field, NULL, NULL);
 	if (!ref_field)
 		return -ENOMEM;
 
-	if (init_var_ref(ref_field, var_field, NULL, NULL)) {
-		destroy_hist_field(ref_field, 0);
-		ret = -ENOMEM;
-		goto out;
-	}
-	hist_data->var_refs[hist_data->n_var_refs] = ref_field;
-	ref_field->var_ref_idx = hist_data->n_var_refs++;
 	data->onmax.var = ref_field;
 
 	data->fn = onmax_save;
@@ -3595,9 +3654,6 @@ static void save_synth_var_ref(struct hi
 			 struct hist_field *var_ref)
 {
 	hist_data->synth_var_refs[hist_data->n_synth_var_refs++] = var_ref;
-
-	hist_data->var_refs[hist_data->n_var_refs] = var_ref;
-	var_ref->var_ref_idx = hist_data->n_var_refs++;
 }
 
 static int check_synth_field(struct synth_event *event,
@@ -3752,7 +3808,8 @@ static int onmatch_create(struct hist_tr
 		}
 
 		if (check_synth_field(event, hist_field, field_pos) == 0) {
-			var_ref = create_var_ref(hist_field, system, event_name);
+			var_ref = create_var_ref(hist_data, hist_field,
+						 system, event_name);
 			if (!var_ref) {
 				kfree(p);
 				ret = -ENOMEM;


