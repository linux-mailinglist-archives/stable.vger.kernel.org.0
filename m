Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 368B71CADA5
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:06:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729256AbgEHNDA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:03:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:58582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729553AbgEHMud (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:50:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 524C624959;
        Fri,  8 May 2020 12:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942232;
        bh=qMWxE2EfYOhqlgoLvRG1U4MWq/4ftK5fTVTdxu9bbNw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CR5QQBIgH9po7yMWs3pcfTflE+YXXo8dtWSxSyxsdAy28+spS5oQthNvV9etCZFsj
         LJUAsRcdx0DVvtsziorKzxQGidAXTkSy6vLCOdj0SQ8EWbSi37NhLD/PfdG58FB1KS
         9/fLWCj5He9bMXsP5GCH+cGHvm6s5qHrOc3C4wEU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Zanussi <tom.zanussi@linux.intel.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        =?UTF-8?q?Andress=20Kuo=20 ?= <Andress.Kuo@mediatek.com>
Subject: [PATCH 4.14 19/22] tracing: Reverse the order of trace_types_lock and event_mutex
Date:   Fri,  8 May 2020 14:35:31 +0200
Message-Id: <20200508123036.277013811@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123033.915895060@linuxfoundation.org>
References: <20200508123033.915895060@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

commit 12ecef0cb12102d8c034770173d2d1363cb97d52 upstream.

In order to make future changes where we need to call
tracing_set_clock() from within an event command, the order of
trace_types_lock and event_mutex must be reversed, as the event command
will hold event_mutex and the trace_types_lock is taken from within
tracing_set_clock().

Link: http://lkml.kernel.org/r/20170921162249.0dde3dca@gandalf.local.home

Requested-by: Tom Zanussi <tom.zanussi@linux.intel.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Andress Kuo (郭孟修) <Andress.Kuo@mediatek.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/trace.c        |    5 +++++
 kernel/trace/trace_events.c |   31 +++++++++++++++----------------
 2 files changed, 20 insertions(+), 16 deletions(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -7720,6 +7720,7 @@ static int instance_mkdir(const char *na
 	struct trace_array *tr;
 	int ret;
 
+	mutex_lock(&event_mutex);
 	mutex_lock(&trace_types_lock);
 
 	ret = -EEXIST;
@@ -7775,6 +7776,7 @@ static int instance_mkdir(const char *na
 	list_add(&tr->list, &ftrace_trace_arrays);
 
 	mutex_unlock(&trace_types_lock);
+	mutex_unlock(&event_mutex);
 
 	return 0;
 
@@ -7786,6 +7788,7 @@ static int instance_mkdir(const char *na
 
  out_unlock:
 	mutex_unlock(&trace_types_lock);
+	mutex_unlock(&event_mutex);
 
 	return ret;
 
@@ -7798,6 +7801,7 @@ static int instance_rmdir(const char *na
 	int ret;
 	int i;
 
+	mutex_lock(&event_mutex);
 	mutex_lock(&trace_types_lock);
 
 	ret = -ENODEV;
@@ -7843,6 +7847,7 @@ static int instance_rmdir(const char *na
 
  out_unlock:
 	mutex_unlock(&trace_types_lock);
+	mutex_unlock(&event_mutex);
 
 	return ret;
 }
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1403,8 +1403,8 @@ static int subsystem_open(struct inode *
 		return -ENODEV;
 
 	/* Make sure the system still exists */
-	mutex_lock(&trace_types_lock);
 	mutex_lock(&event_mutex);
+	mutex_lock(&trace_types_lock);
 	list_for_each_entry(tr, &ftrace_trace_arrays, list) {
 		list_for_each_entry(dir, &tr->systems, list) {
 			if (dir == inode->i_private) {
@@ -1418,8 +1418,8 @@ static int subsystem_open(struct inode *
 		}
 	}
  exit_loop:
-	mutex_unlock(&event_mutex);
 	mutex_unlock(&trace_types_lock);
+	mutex_unlock(&event_mutex);
 
 	if (!system)
 		return -ENODEV;
@@ -2305,15 +2305,15 @@ static void __add_event_to_tracers(struc
 int trace_add_event_call(struct trace_event_call *call)
 {
 	int ret;
-	mutex_lock(&trace_types_lock);
 	mutex_lock(&event_mutex);
+	mutex_lock(&trace_types_lock);
 
 	ret = __register_event(call, NULL);
 	if (ret >= 0)
 		__add_event_to_tracers(call);
 
-	mutex_unlock(&event_mutex);
 	mutex_unlock(&trace_types_lock);
+	mutex_unlock(&event_mutex);
 	return ret;
 }
 
@@ -2367,13 +2367,13 @@ int trace_remove_event_call(struct trace
 {
 	int ret;
 
-	mutex_lock(&trace_types_lock);
 	mutex_lock(&event_mutex);
+	mutex_lock(&trace_types_lock);
 	down_write(&trace_event_sem);
 	ret = probe_remove_event_call(call);
 	up_write(&trace_event_sem);
-	mutex_unlock(&event_mutex);
 	mutex_unlock(&trace_types_lock);
+	mutex_unlock(&event_mutex);
 
 	return ret;
 }
@@ -2435,8 +2435,8 @@ static int trace_module_notify(struct no
 {
 	struct module *mod = data;
 
-	mutex_lock(&trace_types_lock);
 	mutex_lock(&event_mutex);
+	mutex_lock(&trace_types_lock);
 	switch (val) {
 	case MODULE_STATE_COMING:
 		trace_module_add_events(mod);
@@ -2445,8 +2445,8 @@ static int trace_module_notify(struct no
 		trace_module_remove_events(mod);
 		break;
 	}
-	mutex_unlock(&event_mutex);
 	mutex_unlock(&trace_types_lock);
+	mutex_unlock(&event_mutex);
 
 	return 0;
 }
@@ -2961,24 +2961,24 @@ create_event_toplevel_files(struct dentr
  * creates the event hierachry in the @parent/events directory.
  *
  * Returns 0 on success.
+ *
+ * Must be called with event_mutex held.
  */
 int event_trace_add_tracer(struct dentry *parent, struct trace_array *tr)
 {
 	int ret;
 
-	mutex_lock(&event_mutex);
+	lockdep_assert_held(&event_mutex);
 
 	ret = create_event_toplevel_files(parent, tr);
 	if (ret)
-		goto out_unlock;
+		goto out;
 
 	down_write(&trace_event_sem);
 	__trace_add_event_dirs(tr);
 	up_write(&trace_event_sem);
 
- out_unlock:
-	mutex_unlock(&event_mutex);
-
+ out:
 	return ret;
 }
 
@@ -3007,9 +3007,10 @@ early_event_add_tracer(struct dentry *pa
 	return ret;
 }
 
+/* Must be called with event_mutex held */
 int event_trace_del_tracer(struct trace_array *tr)
 {
-	mutex_lock(&event_mutex);
+	lockdep_assert_held(&event_mutex);
 
 	/* Disable any event triggers and associated soft-disabled events */
 	clear_event_triggers(tr);
@@ -3030,8 +3031,6 @@ int event_trace_del_tracer(struct trace_
 
 	tr->event_dir = NULL;
 
-	mutex_unlock(&event_mutex);
-
 	return 0;
 }
 


