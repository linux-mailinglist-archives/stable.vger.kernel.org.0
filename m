Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 871E6582F20
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241899AbiG0RVP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:21:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242001AbiG0RTb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:19:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0D522AE17;
        Wed, 27 Jul 2022 09:44:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 14C6E61479;
        Wed, 27 Jul 2022 16:44:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20142C433C1;
        Wed, 27 Jul 2022 16:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940288;
        bh=roAxcCl7YYnNnFsxMV/IrRFJsK0GSPZxSVawqBUG7PY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dM099xVRo5kq9W9EJSHHFm0kyqrgfF8hU/SbwWqhHG4GajZ8PYOcjSSJsAbVnx1K3
         Zc9YDk/YLi4JO6AHnLSaX4TcZu0HGag4qeNfFaJfUDnpsl2xd+JS3MtpQgorSkTuWo
         DRzaQo66vO0tYFJ57oVJhies8EL9LK40Nv1z5Zhc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 170/201] tracing: Place trace_pid_list logic into abstract functions
Date:   Wed, 27 Jul 2022 18:11:14 +0200
Message-Id: <20220727161034.871219706@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
References: <20220727161026.977588183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

[ Upstream commit 6954e415264eeb5ee6be0d22d789ad12c995ee64 ]

Instead of having the logic that does trace_pid_list open coded, wrap it in
abstract functions. This will allow a rewrite of the logic that implements
the trace_pid_list without affecting the users.

Note, this causes a change in behavior. Every time a pid is written into
the set_*_pid file, it creates a new list and uses RCU to update it. If
pid_max is lowered, but there was a pid currently in the list that was
higher than pid_max, those pids will now be removed on updating the list.
The old behavior kept that from happening.

The rewrite of the pid_list logic will no longer depend on pid_max,
and will return the old behavior.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/Makefile       |   1 +
 kernel/trace/ftrace.c       |   6 +-
 kernel/trace/pid_list.c     | 160 ++++++++++++++++++++++++++++++++++++
 kernel/trace/pid_list.h     |  13 +++
 kernel/trace/trace.c        |  78 ++++++------------
 kernel/trace/trace.h        |  14 +++-
 kernel/trace/trace_events.c |   6 +-
 7 files changed, 217 insertions(+), 61 deletions(-)
 create mode 100644 kernel/trace/pid_list.c
 create mode 100644 kernel/trace/pid_list.h

diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index 6de5d4d63165..bedc5caceec7 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -47,6 +47,7 @@ obj-$(CONFIG_TRACING) += trace_output.o
 obj-$(CONFIG_TRACING) += trace_seq.o
 obj-$(CONFIG_TRACING) += trace_stat.o
 obj-$(CONFIG_TRACING) += trace_printk.o
+obj-$(CONFIG_TRACING) += 	pid_list.o
 obj-$(CONFIG_TRACING_MAP) += tracing_map.o
 obj-$(CONFIG_PREEMPTIRQ_DELAY_TEST) += preemptirq_delay_test.o
 obj-$(CONFIG_SYNTH_EVENT_GEN_TEST) += synth_event_gen_test.o
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 53a1af21d25c..e215a9c96971 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -7184,10 +7184,10 @@ static void clear_ftrace_pids(struct trace_array *tr, int type)
 	synchronize_rcu();
 
 	if ((type & TRACE_PIDS) && pid_list)
-		trace_free_pid_list(pid_list);
+		trace_pid_list_free(pid_list);
 
 	if ((type & TRACE_NO_PIDS) && no_pid_list)
-		trace_free_pid_list(no_pid_list);
+		trace_pid_list_free(no_pid_list);
 }
 
 void ftrace_clear_pids(struct trace_array *tr)
@@ -7428,7 +7428,7 @@ pid_write(struct file *filp, const char __user *ubuf,
 
 	if (filtered_pids) {
 		synchronize_rcu();
-		trace_free_pid_list(filtered_pids);
+		trace_pid_list_free(filtered_pids);
 	} else if (pid_list && !other_pids) {
 		/* Register a probe to set whether to ignore the tracing of a task */
 		register_trace_sched_switch(ftrace_filter_pid_sched_switch_probe, tr);
diff --git a/kernel/trace/pid_list.c b/kernel/trace/pid_list.c
new file mode 100644
index 000000000000..4483ef70b562
--- /dev/null
+++ b/kernel/trace/pid_list.c
@@ -0,0 +1,160 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2021 VMware Inc, Steven Rostedt <rostedt@goodmis.org>
+ */
+#include <linux/vmalloc.h>
+#include <linux/slab.h>
+#include "trace.h"
+
+/**
+ * trace_pid_list_is_set - test if the pid is set in the list
+ * @pid_list: The pid list to test
+ * @pid: The pid to to see if set in the list.
+ *
+ * Tests if @pid is is set in the @pid_list. This is usually called
+ * from the scheduler when a task is scheduled. Its pid is checked
+ * if it should be traced or not.
+ *
+ * Return true if the pid is in the list, false otherwise.
+ */
+bool trace_pid_list_is_set(struct trace_pid_list *pid_list, unsigned int pid)
+{
+	/*
+	 * If pid_max changed after filtered_pids was created, we
+	 * by default ignore all pids greater than the previous pid_max.
+	 */
+	if (pid >= pid_list->pid_max)
+		return false;
+
+	return test_bit(pid, pid_list->pids);
+}
+
+/**
+ * trace_pid_list_set - add a pid to the list
+ * @pid_list: The pid list to add the @pid to.
+ * @pid: The pid to add.
+ *
+ * Adds @pid to @pid_list. This is usually done explicitly by a user
+ * adding a task to be traced, or indirectly by the fork function
+ * when children should be traced and a task's pid is in the list.
+ *
+ * Return 0 on success, negative otherwise.
+ */
+int trace_pid_list_set(struct trace_pid_list *pid_list, unsigned int pid)
+{
+	/* Sorry, but we don't support pid_max changing after setting */
+	if (pid >= pid_list->pid_max)
+		return -EINVAL;
+
+	set_bit(pid, pid_list->pids);
+
+	return 0;
+}
+
+/**
+ * trace_pid_list_clear - remove a pid from the list
+ * @pid_list: The pid list to remove the @pid from.
+ * @pid: The pid to remove.
+ *
+ * Removes @pid from @pid_list. This is usually done explicitly by a user
+ * removing tasks from tracing, or indirectly by the exit function
+ * when a task that is set to be traced exits.
+ *
+ * Return 0 on success, negative otherwise.
+ */
+int trace_pid_list_clear(struct trace_pid_list *pid_list, unsigned int pid)
+{
+	/* Sorry, but we don't support pid_max changing after setting */
+	if (pid >= pid_list->pid_max)
+		return -EINVAL;
+
+	clear_bit(pid, pid_list->pids);
+
+	return 0;
+}
+
+/**
+ * trace_pid_list_next - return the next pid in the list
+ * @pid_list: The pid list to examine.
+ * @pid: The pid to start from
+ * @next: The pointer to place the pid that is set starting from @pid.
+ *
+ * Looks for the next consecutive pid that is in @pid_list starting
+ * at the pid specified by @pid. If one is set (including @pid), then
+ * that pid is placed into @next.
+ *
+ * Return 0 when a pid is found, -1 if there are no more pids included.
+ */
+int trace_pid_list_next(struct trace_pid_list *pid_list, unsigned int pid,
+			unsigned int *next)
+{
+	pid = find_next_bit(pid_list->pids, pid_list->pid_max, pid);
+
+	if (pid < pid_list->pid_max) {
+		*next = pid;
+		return 0;
+	}
+	return -1;
+}
+
+/**
+ * trace_pid_list_first - return the first pid in the list
+ * @pid_list: The pid list to examine.
+ * @pid: The pointer to place the pid first found pid that is set.
+ *
+ * Looks for the first pid that is set in @pid_list, and places it
+ * into @pid if found.
+ *
+ * Return 0 when a pid is found, -1 if there are no pids set.
+ */
+int trace_pid_list_first(struct trace_pid_list *pid_list, unsigned int *pid)
+{
+	unsigned int first;
+
+	first = find_first_bit(pid_list->pids, pid_list->pid_max);
+
+	if (first < pid_list->pid_max) {
+		*pid = first;
+		return 0;
+	}
+	return -1;
+}
+
+/**
+ * trace_pid_list_alloc - create a new pid_list
+ *
+ * Allocates a new pid_list to store pids into.
+ *
+ * Returns the pid_list on success, NULL otherwise.
+ */
+struct trace_pid_list *trace_pid_list_alloc(void)
+{
+	struct trace_pid_list *pid_list;
+
+	pid_list = kmalloc(sizeof(*pid_list), GFP_KERNEL);
+	if (!pid_list)
+		return NULL;
+
+	pid_list->pid_max = READ_ONCE(pid_max);
+
+	pid_list->pids = vzalloc((pid_list->pid_max + 7) >> 3);
+	if (!pid_list->pids) {
+		kfree(pid_list);
+		return NULL;
+	}
+	return pid_list;
+}
+
+/**
+ * trace_pid_list_free - Frees an allocated pid_list.
+ *
+ * Frees the memory for a pid_list that was allocated.
+ */
+void trace_pid_list_free(struct trace_pid_list *pid_list)
+{
+	if (!pid_list)
+		return;
+
+	vfree(pid_list->pids);
+	kfree(pid_list);
+}
diff --git a/kernel/trace/pid_list.h b/kernel/trace/pid_list.h
new file mode 100644
index 000000000000..80d0ecfe1536
--- /dev/null
+++ b/kernel/trace/pid_list.h
@@ -0,0 +1,13 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/* Do not include this file directly. */
+
+#ifndef _TRACE_INTERNAL_PID_LIST_H
+#define _TRACE_INTERNAL_PID_LIST_H
+
+struct trace_pid_list {
+	int			pid_max;
+	unsigned long		*pids;
+};
+
+#endif /* _TRACE_INTERNAL_PID_LIST_H */
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index f752f2574630..abbe8489faae 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -516,12 +516,6 @@ int call_filter_check_discard(struct trace_event_call *call, void *rec,
 	return 0;
 }
 
-void trace_free_pid_list(struct trace_pid_list *pid_list)
-{
-	vfree(pid_list->pids);
-	kfree(pid_list);
-}
-
 /**
  * trace_find_filtered_pid - check if a pid exists in a filtered_pid list
  * @filtered_pids: The list of pids to check
@@ -532,14 +526,7 @@ void trace_free_pid_list(struct trace_pid_list *pid_list)
 bool
 trace_find_filtered_pid(struct trace_pid_list *filtered_pids, pid_t search_pid)
 {
-	/*
-	 * If pid_max changed after filtered_pids was created, we
-	 * by default ignore all pids greater than the previous pid_max.
-	 */
-	if (search_pid >= filtered_pids->pid_max)
-		return false;
-
-	return test_bit(search_pid, filtered_pids->pids);
+	return trace_pid_list_is_set(filtered_pids, search_pid);
 }
 
 /**
@@ -596,15 +583,11 @@ void trace_filter_add_remove_task(struct trace_pid_list *pid_list,
 			return;
 	}
 
-	/* Sorry, but we don't support pid_max changing after setting */
-	if (task->pid >= pid_list->pid_max)
-		return;
-
 	/* "self" is set for forks, and NULL for exits */
 	if (self)
-		set_bit(task->pid, pid_list->pids);
+		trace_pid_list_set(pid_list, task->pid);
 	else
-		clear_bit(task->pid, pid_list->pids);
+		trace_pid_list_clear(pid_list, task->pid);
 }
 
 /**
@@ -621,18 +604,19 @@ void trace_filter_add_remove_task(struct trace_pid_list *pid_list,
  */
 void *trace_pid_next(struct trace_pid_list *pid_list, void *v, loff_t *pos)
 {
-	unsigned long pid = (unsigned long)v;
+	long pid = (unsigned long)v;
+	unsigned int next;
 
 	(*pos)++;
 
 	/* pid already is +1 of the actual previous bit */
-	pid = find_next_bit(pid_list->pids, pid_list->pid_max, pid);
+	if (trace_pid_list_next(pid_list, pid, &next) < 0)
+		return NULL;
 
-	/* Return pid + 1 to allow zero to be represented */
-	if (pid < pid_list->pid_max)
-		return (void *)(pid + 1);
+	pid = next;
 
-	return NULL;
+	/* Return pid + 1 to allow zero to be represented */
+	return (void *)(pid + 1);
 }
 
 /**
@@ -649,12 +633,14 @@ void *trace_pid_next(struct trace_pid_list *pid_list, void *v, loff_t *pos)
 void *trace_pid_start(struct trace_pid_list *pid_list, loff_t *pos)
 {
 	unsigned long pid;
+	unsigned int first;
 	loff_t l = 0;
 
-	pid = find_first_bit(pid_list->pids, pid_list->pid_max);
-	if (pid >= pid_list->pid_max)
+	if (trace_pid_list_first(pid_list, &first) < 0)
 		return NULL;
 
+	pid = first;
+
 	/* Return pid + 1 so that zero can be the exit value */
 	for (pid++; pid && l < *pos;
 	     pid = (unsigned long)trace_pid_next(pid_list, (void *)pid, &l))
@@ -690,7 +676,7 @@ int trace_pid_write(struct trace_pid_list *filtered_pids,
 	unsigned long val;
 	int nr_pids = 0;
 	ssize_t read = 0;
-	ssize_t ret = 0;
+	ssize_t ret;
 	loff_t pos;
 	pid_t pid;
 
@@ -703,34 +689,23 @@ int trace_pid_write(struct trace_pid_list *filtered_pids,
 	 * the user. If the operation fails, then the current list is
 	 * not modified.
 	 */
-	pid_list = kmalloc(sizeof(*pid_list), GFP_KERNEL);
+	pid_list = trace_pid_list_alloc();
 	if (!pid_list) {
 		trace_parser_put(&parser);
 		return -ENOMEM;
 	}
 
-	pid_list->pid_max = READ_ONCE(pid_max);
-
-	/* Only truncating will shrink pid_max */
-	if (filtered_pids && filtered_pids->pid_max > pid_list->pid_max)
-		pid_list->pid_max = filtered_pids->pid_max;
-
-	pid_list->pids = vzalloc((pid_list->pid_max + 7) >> 3);
-	if (!pid_list->pids) {
-		trace_parser_put(&parser);
-		kfree(pid_list);
-		return -ENOMEM;
-	}
-
 	if (filtered_pids) {
 		/* copy the current bits to the new max */
-		for_each_set_bit(pid, filtered_pids->pids,
-				 filtered_pids->pid_max) {
-			set_bit(pid, pid_list->pids);
+		ret = trace_pid_list_first(filtered_pids, &pid);
+		while (!ret) {
+			trace_pid_list_set(pid_list, pid);
+			ret = trace_pid_list_next(filtered_pids, pid + 1, &pid);
 			nr_pids++;
 		}
 	}
 
+	ret = 0;
 	while (cnt > 0) {
 
 		pos = 0;
@@ -746,12 +721,13 @@ int trace_pid_write(struct trace_pid_list *filtered_pids,
 		ret = -EINVAL;
 		if (kstrtoul(parser.buffer, 0, &val))
 			break;
-		if (val >= pid_list->pid_max)
-			break;
 
 		pid = (pid_t)val;
 
-		set_bit(pid, pid_list->pids);
+		if (trace_pid_list_set(pid_list, pid) < 0) {
+			ret = -1;
+			break;
+		}
 		nr_pids++;
 
 		trace_parser_clear(&parser);
@@ -760,13 +736,13 @@ int trace_pid_write(struct trace_pid_list *filtered_pids,
 	trace_parser_put(&parser);
 
 	if (ret < 0) {
-		trace_free_pid_list(pid_list);
+		trace_pid_list_free(pid_list);
 		return ret;
 	}
 
 	if (!nr_pids) {
 		/* Cleared the list of pids */
-		trace_free_pid_list(pid_list);
+		trace_pid_list_free(pid_list);
 		read = ret;
 		pid_list = NULL;
 	}
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 421374c304fc..d6763366a320 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -22,6 +22,8 @@
 #include <linux/ctype.h>
 #include <linux/once_lite.h>
 
+#include "pid_list.h"
+
 #ifdef CONFIG_FTRACE_SYSCALLS
 #include <asm/unistd.h>		/* For NR_SYSCALLS	     */
 #include <asm/syscall.h>	/* some archs define it here */
@@ -191,10 +193,14 @@ struct trace_options {
 	struct trace_option_dentry	*topts;
 };
 
-struct trace_pid_list {
-	int				pid_max;
-	unsigned long			*pids;
-};
+struct trace_pid_list *trace_pid_list_alloc(void);
+void trace_pid_list_free(struct trace_pid_list *pid_list);
+bool trace_pid_list_is_set(struct trace_pid_list *pid_list, unsigned int pid);
+int trace_pid_list_set(struct trace_pid_list *pid_list, unsigned int pid);
+int trace_pid_list_clear(struct trace_pid_list *pid_list, unsigned int pid);
+int trace_pid_list_first(struct trace_pid_list *pid_list, unsigned int *pid);
+int trace_pid_list_next(struct trace_pid_list *pid_list, unsigned int pid,
+			unsigned int *next);
 
 enum {
 	TRACE_PIDS		= BIT(0),
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index ea3fbfa87fdd..c4f654efb77a 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -900,10 +900,10 @@ static void __ftrace_clear_event_pids(struct trace_array *tr, int type)
 	tracepoint_synchronize_unregister();
 
 	if ((type & TRACE_PIDS) && pid_list)
-		trace_free_pid_list(pid_list);
+		trace_pid_list_free(pid_list);
 
 	if ((type & TRACE_NO_PIDS) && no_pid_list)
-		trace_free_pid_list(no_pid_list);
+		trace_pid_list_free(no_pid_list);
 }
 
 static void ftrace_clear_event_pids(struct trace_array *tr, int type)
@@ -1982,7 +1982,7 @@ event_pid_write(struct file *filp, const char __user *ubuf,
 
 	if (filtered_pids) {
 		tracepoint_synchronize_unregister();
-		trace_free_pid_list(filtered_pids);
+		trace_pid_list_free(filtered_pids);
 	} else if (pid_list && !other_pids) {
 		register_pid_events(tr);
 	}
-- 
2.35.1



