Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCA4414B968
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:33:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387395AbgA1Obc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:31:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:55604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387411AbgA1O1s (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:27:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71B2924688;
        Tue, 28 Jan 2020 14:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221667;
        bh=fusV38pNnVTYdf03ragpw6I0F770zWDy/XdXdVRpTR8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vEgt7CBF9JhHb7smjiElznJTY/lWAfotaYGBCq6logd6fpKwE3lY78PZydNUcSf4V
         EubV3Qx/vgU6IHM8Ot+8sDwLHxG+lVDCJl0IimxgcfnUCqtWJqG/IZmq9xB3pJAVEf
         sHgOYGz/ub2O4v7CcMpywU0eS38Sj3xewK1+jaYY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Zanussi <zanussi@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 4.19 26/92] tracing: trigger: Replace unneeded RCU-list traversals
Date:   Tue, 28 Jan 2020 15:07:54 +0100
Message-Id: <20200128135812.413518101@linuxfoundation.org>
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

From: Masami Hiramatsu <mhiramat@kernel.org>

commit aeed8aa3874dc15b9d82a6fe796fd7cfbb684448 upstream.

With CONFIG_PROVE_RCU_LIST, I had many suspicious RCU warnings
when I ran ftracetest trigger testcases.

-----
  # dmesg -c > /dev/null
  # ./ftracetest test.d/trigger
  ...
  # dmesg | grep "RCU-list traversed" | cut -f 2 -d ] | cut -f 2 -d " "
  kernel/trace/trace_events_hist.c:6070
  kernel/trace/trace_events_hist.c:1760
  kernel/trace/trace_events_hist.c:5911
  kernel/trace/trace_events_trigger.c:504
  kernel/trace/trace_events_hist.c:1810
  kernel/trace/trace_events_hist.c:3158
  kernel/trace/trace_events_hist.c:3105
  kernel/trace/trace_events_hist.c:5518
  kernel/trace/trace_events_hist.c:5998
  kernel/trace/trace_events_hist.c:6019
  kernel/trace/trace_events_hist.c:6044
  kernel/trace/trace_events_trigger.c:1500
  kernel/trace/trace_events_trigger.c:1540
  kernel/trace/trace_events_trigger.c:539
  kernel/trace/trace_events_trigger.c:584
-----

I investigated those warnings and found that the RCU-list
traversals in event trigger and hist didn't need to use
RCU version because those were called only under event_mutex.

I also checked other RCU-list traversals related to event
trigger list, and found that most of them were called from
event_hist_trigger_func() or hist_unregister_trigger() or
register/unregister functions except for a few cases.

Replace these unneeded RCU-list traversals with normal list
traversal macro and lockdep_assert_held() to check the
event_mutex is held.

Link: http://lkml.kernel.org/r/157680910305.11685.15110237954275915782.stgit@devnote2

Cc: stable@vger.kernel.org
Fixes: 30350d65ac567 ("tracing: Add variable support to hist triggers")
Reviewed-by: Tom Zanussi <zanussi@kernel.org>
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 kernel/trace/trace_events_hist.c    |   38 ++++++++++++++++++++++++++----------
 kernel/trace/trace_events_trigger.c |   20 ++++++++++++++----
 2 files changed, 43 insertions(+), 15 deletions(-)

--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -1511,11 +1511,13 @@ static struct hist_field *find_var(struc
 	struct event_trigger_data *test;
 	struct hist_field *hist_field;
 
+	lockdep_assert_held(&event_mutex);
+
 	hist_field = find_var_field(hist_data, var_name);
 	if (hist_field)
 		return hist_field;
 
-	list_for_each_entry_rcu(test, &file->triggers, list) {
+	list_for_each_entry(test, &file->triggers, list) {
 		if (test->cmd_ops->trigger_type == ETT_EVENT_HIST) {
 			test_data = test->private_data;
 			hist_field = find_var_field(test_data, var_name);
@@ -1565,7 +1567,9 @@ static struct hist_field *find_file_var(
 	struct event_trigger_data *test;
 	struct hist_field *hist_field;
 
-	list_for_each_entry_rcu(test, &file->triggers, list) {
+	lockdep_assert_held(&event_mutex);
+
+	list_for_each_entry(test, &file->triggers, list) {
 		if (test->cmd_ops->trigger_type == ETT_EVENT_HIST) {
 			test_data = test->private_data;
 			hist_field = find_var_field(test_data, var_name);
@@ -2828,7 +2832,9 @@ static char *find_trigger_filter(struct
 {
 	struct event_trigger_data *test;
 
-	list_for_each_entry_rcu(test, &file->triggers, list) {
+	lockdep_assert_held(&event_mutex);
+
+	list_for_each_entry(test, &file->triggers, list) {
 		if (test->cmd_ops->trigger_type == ETT_EVENT_HIST) {
 			if (test->private_data == hist_data)
 				return test->filter_str;
@@ -2879,9 +2885,11 @@ find_compatible_hist(struct hist_trigger
 	struct event_trigger_data *test;
 	unsigned int n_keys;
 
+	lockdep_assert_held(&event_mutex);
+
 	n_keys = target_hist_data->n_fields - target_hist_data->n_vals;
 
-	list_for_each_entry_rcu(test, &file->triggers, list) {
+	list_for_each_entry(test, &file->triggers, list) {
 		if (test->cmd_ops->trigger_type == ETT_EVENT_HIST) {
 			hist_data = test->private_data;
 
@@ -4905,7 +4913,7 @@ static int hist_show(struct seq_file *m,
 		goto out_unlock;
 	}
 
-	list_for_each_entry_rcu(data, &event_file->triggers, list) {
+	list_for_each_entry(data, &event_file->triggers, list) {
 		if (data->cmd_ops->trigger_type == ETT_EVENT_HIST)
 			hist_trigger_show(m, data, n++);
 	}
@@ -5296,7 +5304,9 @@ static int hist_register_trigger(char *g
 	if (hist_data->attrs->name && !named_data)
 		goto new;
 
-	list_for_each_entry_rcu(test, &file->triggers, list) {
+	lockdep_assert_held(&event_mutex);
+
+	list_for_each_entry(test, &file->triggers, list) {
 		if (test->cmd_ops->trigger_type == ETT_EVENT_HIST) {
 			if (!hist_trigger_match(data, test, named_data, false))
 				continue;
@@ -5380,10 +5390,12 @@ static bool have_hist_trigger_match(stru
 	struct event_trigger_data *test, *named_data = NULL;
 	bool match = false;
 
+	lockdep_assert_held(&event_mutex);
+
 	if (hist_data->attrs->name)
 		named_data = find_named_trigger(hist_data->attrs->name);
 
-	list_for_each_entry_rcu(test, &file->triggers, list) {
+	list_for_each_entry(test, &file->triggers, list) {
 		if (test->cmd_ops->trigger_type == ETT_EVENT_HIST) {
 			if (hist_trigger_match(data, test, named_data, false)) {
 				match = true;
@@ -5401,10 +5413,12 @@ static bool hist_trigger_check_refs(stru
 	struct hist_trigger_data *hist_data = data->private_data;
 	struct event_trigger_data *test, *named_data = NULL;
 
+	lockdep_assert_held(&event_mutex);
+
 	if (hist_data->attrs->name)
 		named_data = find_named_trigger(hist_data->attrs->name);
 
-	list_for_each_entry_rcu(test, &file->triggers, list) {
+	list_for_each_entry(test, &file->triggers, list) {
 		if (test->cmd_ops->trigger_type == ETT_EVENT_HIST) {
 			if (!hist_trigger_match(data, test, named_data, false))
 				continue;
@@ -5426,10 +5440,12 @@ static void hist_unregister_trigger(char
 	struct event_trigger_data *test, *named_data = NULL;
 	bool unregistered = false;
 
+	lockdep_assert_held(&event_mutex);
+
 	if (hist_data->attrs->name)
 		named_data = find_named_trigger(hist_data->attrs->name);
 
-	list_for_each_entry_rcu(test, &file->triggers, list) {
+	list_for_each_entry(test, &file->triggers, list) {
 		if (test->cmd_ops->trigger_type == ETT_EVENT_HIST) {
 			if (!hist_trigger_match(data, test, named_data, false))
 				continue;
@@ -5455,7 +5471,9 @@ static bool hist_file_check_refs(struct
 	struct hist_trigger_data *hist_data;
 	struct event_trigger_data *test;
 
-	list_for_each_entry_rcu(test, &file->triggers, list) {
+	lockdep_assert_held(&event_mutex);
+
+	list_for_each_entry(test, &file->triggers, list) {
 		if (test->cmd_ops->trigger_type == ETT_EVENT_HIST) {
 			hist_data = test->private_data;
 			if (check_var_refs(hist_data))
--- a/kernel/trace/trace_events_trigger.c
+++ b/kernel/trace/trace_events_trigger.c
@@ -495,7 +495,9 @@ void update_cond_flag(struct trace_event
 	struct event_trigger_data *data;
 	bool set_cond = false;
 
-	list_for_each_entry_rcu(data, &file->triggers, list) {
+	lockdep_assert_held(&event_mutex);
+
+	list_for_each_entry(data, &file->triggers, list) {
 		if (data->filter || event_command_post_trigger(data->cmd_ops) ||
 		    event_command_needs_rec(data->cmd_ops)) {
 			set_cond = true;
@@ -530,7 +532,9 @@ static int register_trigger(char *glob,
 	struct event_trigger_data *test;
 	int ret = 0;
 
-	list_for_each_entry_rcu(test, &file->triggers, list) {
+	lockdep_assert_held(&event_mutex);
+
+	list_for_each_entry(test, &file->triggers, list) {
 		if (test->cmd_ops->trigger_type == data->cmd_ops->trigger_type) {
 			ret = -EEXIST;
 			goto out;
@@ -575,7 +579,9 @@ static void unregister_trigger(char *glo
 	struct event_trigger_data *data;
 	bool unregistered = false;
 
-	list_for_each_entry_rcu(data, &file->triggers, list) {
+	lockdep_assert_held(&event_mutex);
+
+	list_for_each_entry(data, &file->triggers, list) {
 		if (data->cmd_ops->trigger_type == test->cmd_ops->trigger_type) {
 			unregistered = true;
 			list_del_rcu(&data->list);
@@ -1490,7 +1496,9 @@ int event_enable_register_trigger(char *
 	struct event_trigger_data *test;
 	int ret = 0;
 
-	list_for_each_entry_rcu(test, &file->triggers, list) {
+	lockdep_assert_held(&event_mutex);
+
+	list_for_each_entry(test, &file->triggers, list) {
 		test_enable_data = test->private_data;
 		if (test_enable_data &&
 		    (test->cmd_ops->trigger_type ==
@@ -1530,7 +1538,9 @@ void event_enable_unregister_trigger(cha
 	struct event_trigger_data *data;
 	bool unregistered = false;
 
-	list_for_each_entry_rcu(data, &file->triggers, list) {
+	lockdep_assert_held(&event_mutex);
+
+	list_for_each_entry(data, &file->triggers, list) {
 		enable_data = data->private_data;
 		if (enable_data &&
 		    (data->cmd_ops->trigger_type ==


