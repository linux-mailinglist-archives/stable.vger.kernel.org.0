Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55E49111F4F
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:10:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729030AbfLCWrS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:47:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:37448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728419AbfLCWrR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:47:17 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3FB2620803;
        Tue,  3 Dec 2019 22:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413236;
        bh=EfdXdmgPbL7KrEcnb9ASYZq3zIOjABUQfQHZzLN0W94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yxc7iSU0PaIAU5IxQnmDW7oguBUy0qeAtH5eg7zM5WnvY8BRbH2ETgUlbjR6ZmHM6
         52/TbXXPB+iIa0n6/QqrHk0XTGXqt60sxSWvOl5j9i17OtFua2tifUlgIyx2X+Dr+6
         H16v0i/fdD5/U3EVwuMSDnJLGHjh7llUUgPLWJi8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Zanussi <tom.zanussi@linux.intel.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 052/321] tracing: Lock event_mutex before synth_event_mutex
Date:   Tue,  3 Dec 2019 23:31:58 +0100
Message-Id: <20191203223429.870417282@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

[ Upstream commit fc800a10be26017f8f338bc8e500d48e3e6429d9 ]

synthetic event is using synth_event_mutex for protecting
synth_event_list, and event_trigger_write() path acquires
locks as below order.

event_trigger_write(event_mutex)
  ->trigger_process_regex(trigger_cmd_mutex)
    ->event_hist_trigger_func(synth_event_mutex)

On the other hand, synthetic event creation and deletion paths
call trace_add_event_call() and trace_remove_event_call()
which acquires event_mutex. In that case, if we keep the
synth_event_mutex locked while registering/unregistering synthetic
events, its dependency will be inversed.

To avoid this issue, current synthetic event is using a 2 phase
process to create/delete events. For example, it searches existing
events under synth_event_mutex to check for event-name conflicts, and
unlocks synth_event_mutex, then registers a new event under event_mutex
locked. Finally, it locks synth_event_mutex and tries to add the
new event to the list. But it can introduce complexity and a chance
for name conflicts.

To solve this simpler, this introduces trace_add_event_call_nolock()
and trace_remove_event_call_nolock() which don't acquire
event_mutex inside. synthetic event can lock event_mutex before
synth_event_mutex to solve the lock dependency issue simpler.

Link: http://lkml.kernel.org/r/154140844377.17322.13781091165954002713.stgit@devbox

Reviewed-by: Tom Zanussi <tom.zanussi@linux.intel.com>
Tested-by: Tom Zanussi <tom.zanussi@linux.intel.com>
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/trace_events.h     |  2 ++
 kernel/trace/trace_events.c      | 34 ++++++++++++++++++++++++++------
 kernel/trace/trace_events_hist.c | 24 ++++++++++------------
 3 files changed, 40 insertions(+), 20 deletions(-)

diff --git a/include/linux/trace_events.h b/include/linux/trace_events.h
index 78a010e19ed41..0643c083ed862 100644
--- a/include/linux/trace_events.h
+++ b/include/linux/trace_events.h
@@ -529,6 +529,8 @@ extern int trace_event_raw_init(struct trace_event_call *call);
 extern int trace_define_field(struct trace_event_call *call, const char *type,
 			      const char *name, int offset, int size,
 			      int is_signed, int filter_type);
+extern int trace_add_event_call_nolock(struct trace_event_call *call);
+extern int trace_remove_event_call_nolock(struct trace_event_call *call);
 extern int trace_add_event_call(struct trace_event_call *call);
 extern int trace_remove_event_call(struct trace_event_call *call);
 extern int trace_event_get_offsets(struct trace_event_call *call);
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 7345f5f8f3fe6..017f737237e60 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -2302,11 +2302,11 @@ __trace_early_add_new_event(struct trace_event_call *call,
 struct ftrace_module_file_ops;
 static void __add_event_to_tracers(struct trace_event_call *call);
 
-/* Add an additional event_call dynamically */
-int trace_add_event_call(struct trace_event_call *call)
+int trace_add_event_call_nolock(struct trace_event_call *call)
 {
 	int ret;
-	mutex_lock(&event_mutex);
+	lockdep_assert_held(&event_mutex);
+
 	mutex_lock(&trace_types_lock);
 
 	ret = __register_event(call, NULL);
@@ -2314,6 +2314,16 @@ int trace_add_event_call(struct trace_event_call *call)
 		__add_event_to_tracers(call);
 
 	mutex_unlock(&trace_types_lock);
+	return ret;
+}
+
+/* Add an additional event_call dynamically */
+int trace_add_event_call(struct trace_event_call *call)
+{
+	int ret;
+
+	mutex_lock(&event_mutex);
+	ret = trace_add_event_call_nolock(call);
 	mutex_unlock(&event_mutex);
 	return ret;
 }
@@ -2363,17 +2373,29 @@ static int probe_remove_event_call(struct trace_event_call *call)
 	return 0;
 }
 
-/* Remove an event_call */
-int trace_remove_event_call(struct trace_event_call *call)
+/* no event_mutex version */
+int trace_remove_event_call_nolock(struct trace_event_call *call)
 {
 	int ret;
 
-	mutex_lock(&event_mutex);
+	lockdep_assert_held(&event_mutex);
+
 	mutex_lock(&trace_types_lock);
 	down_write(&trace_event_sem);
 	ret = probe_remove_event_call(call);
 	up_write(&trace_event_sem);
 	mutex_unlock(&trace_types_lock);
+
+	return ret;
+}
+
+/* Remove an event_call */
+int trace_remove_event_call(struct trace_event_call *call)
+{
+	int ret;
+
+	mutex_lock(&event_mutex);
+	ret = trace_remove_event_call_nolock(call);
 	mutex_unlock(&event_mutex);
 
 	return ret;
diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index dac518977e7d0..11d952650fa72 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -914,7 +914,7 @@ static int register_synth_event(struct synth_event *event)
 	call->data = event;
 	call->tp = event->tp;
 
-	ret = trace_add_event_call(call);
+	ret = trace_add_event_call_nolock(call);
 	if (ret) {
 		pr_warn("Failed to register synthetic event: %s\n",
 			trace_event_name(call));
@@ -938,7 +938,7 @@ static int unregister_synth_event(struct synth_event *event)
 	struct trace_event_call *call = &event->call;
 	int ret;
 
-	ret = trace_remove_event_call(call);
+	ret = trace_remove_event_call_nolock(call);
 
 	return ret;
 }
@@ -1015,12 +1015,10 @@ static void add_or_delete_synth_event(struct synth_event *event, int delete)
 	if (delete)
 		free_synth_event(event);
 	else {
-		mutex_lock(&synth_event_mutex);
 		if (!find_synth_event(event->name))
 			list_add(&event->list, &synth_event_list);
 		else
 			free_synth_event(event);
-		mutex_unlock(&synth_event_mutex);
 	}
 }
 
@@ -1032,6 +1030,7 @@ static int create_synth_event(int argc, char **argv)
 	int i, consumed = 0, n_fields = 0, ret = 0;
 	char *name;
 
+	mutex_lock(&event_mutex);
 	mutex_lock(&synth_event_mutex);
 
 	/*
@@ -1104,8 +1103,6 @@ static int create_synth_event(int argc, char **argv)
 		goto err;
 	}
  out:
-	mutex_unlock(&synth_event_mutex);
-
 	if (event) {
 		if (delete_event) {
 			ret = unregister_synth_event(event);
@@ -1115,10 +1112,13 @@ static int create_synth_event(int argc, char **argv)
 			add_or_delete_synth_event(event, ret);
 		}
 	}
+	mutex_unlock(&synth_event_mutex);
+	mutex_unlock(&event_mutex);
 
 	return ret;
  err:
 	mutex_unlock(&synth_event_mutex);
+	mutex_unlock(&event_mutex);
 
 	for (i = 0; i < n_fields; i++)
 		free_synth_field(fields[i]);
@@ -1129,12 +1129,10 @@ static int create_synth_event(int argc, char **argv)
 
 static int release_all_synth_events(void)
 {
-	struct list_head release_events;
 	struct synth_event *event, *e;
 	int ret = 0;
 
-	INIT_LIST_HEAD(&release_events);
-
+	mutex_lock(&event_mutex);
 	mutex_lock(&synth_event_mutex);
 
 	list_for_each_entry(event, &synth_event_list, list) {
@@ -1144,16 +1142,14 @@ static int release_all_synth_events(void)
 		}
 	}
 
-	list_splice_init(&event->list, &release_events);
-
-	mutex_unlock(&synth_event_mutex);
-
-	list_for_each_entry_safe(event, e, &release_events, list) {
+	list_for_each_entry_safe(event, e, &synth_event_list, list) {
 		list_del(&event->list);
 
 		ret = unregister_synth_event(event);
 		add_or_delete_synth_event(event, !ret);
 	}
+	mutex_unlock(&synth_event_mutex);
+	mutex_unlock(&event_mutex);
 
 	return ret;
 }
-- 
2.20.1



