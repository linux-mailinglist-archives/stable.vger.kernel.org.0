Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3A1143FC0
	for <lists+stable@lfdr.de>; Tue, 21 Jan 2020 15:40:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727817AbgAUOkD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jan 2020 09:40:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:56088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727508AbgAUOj7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Jan 2020 09:39:59 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7DCE24655;
        Tue, 21 Jan 2020 14:39:57 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.93)
        (envelope-from <rostedt@goodmis.org>)
        id 1ituhA-000dxW-NS; Tue, 21 Jan 2020 09:39:56 -0500
Message-Id: <20200121143956.600928887@goodmis.org>
User-Agent: quilt/0.65
Date:   Tue, 21 Jan 2020 09:38:49 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Namhyung Kim <namhyung@kernel.org>,
        =?utf-8?q?Toke_H=C3=B8iland-J?= =?utf-8?b?w7hyZ2Vuc2Vu?= 
        <thoiland@redhat.com>, Jean-Tsung Hsiao <jhsiao@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        stable@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>
Subject: [for-linus][PATCH 2/5] tracing/uprobe: Fix double perf_event linking on multiprobe uprobe
References: <20200121143847.609307852@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

Fix double perf_event linking to trace_uprobe_filter on
multiple uprobe event by moving trace_uprobe_filter under
trace_probe_event.

In uprobe perf event, trace_uprobe_filter data structure is
managing target mm filters (in perf_event) related to each
uprobe event.

Since commit 60d53e2c3b75 ("tracing/probe: Split trace_event
related data from trace_probe") left the trace_uprobe_filter
data structure in trace_uprobe, if a trace_probe_event has
multiple trace_uprobe (multi-probe event), a perf_event is
added to different trace_uprobe_filter on each trace_uprobe.
This leads a linked list corruption.

To fix this issue, move trace_uprobe_filter to trace_probe_event
and link it once on each event instead of each probe.

Link: http://lkml.kernel.org/r/157862073931.1800.3800576241181489174.stgit@devnote2

Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: "David S . Miller" <davem@davemloft.net>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: =?utf-8?q?Toke_H=C3=B8iland-J?= =?utf-8?b?w7hyZ2Vuc2Vu?= <thoiland@redhat.com>
Cc: Jean-Tsung Hsiao <jhsiao@redhat.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: stable@vger.kernel.org
Fixes: 60d53e2c3b75 ("tracing/probe: Split trace_event related data from trace_probe")
Link: https://lkml.kernel.org/r/20200108171611.GA8472@kernel.org
Reported-by: Arnaldo Carvalho de Melo <acme@kernel.org>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/trace/trace_kprobe.c |   2 +-
 kernel/trace/trace_probe.c  |   5 +-
 kernel/trace/trace_probe.h  |   3 +-
 kernel/trace/trace_uprobe.c | 124 +++++++++++++++++++++++-------------
 4 files changed, 86 insertions(+), 48 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 7f890262c8a3..3e5f9c7d939c 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -290,7 +290,7 @@ static struct trace_kprobe *alloc_trace_kprobe(const char *group,
 	INIT_HLIST_NODE(&tk->rp.kp.hlist);
 	INIT_LIST_HEAD(&tk->rp.kp.list);
 
-	ret = trace_probe_init(&tk->tp, event, group);
+	ret = trace_probe_init(&tk->tp, event, group, 0);
 	if (ret < 0)
 		goto error;
 
diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index 905b10af5d5c..bba18cf44a30 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -984,7 +984,7 @@ void trace_probe_cleanup(struct trace_probe *tp)
 }
 
 int trace_probe_init(struct trace_probe *tp, const char *event,
-		     const char *group)
+		     const char *group, size_t event_data_size)
 {
 	struct trace_event_call *call;
 	int ret = 0;
@@ -992,7 +992,8 @@ int trace_probe_init(struct trace_probe *tp, const char *event,
 	if (!event || !group)
 		return -EINVAL;
 
-	tp->event = kzalloc(sizeof(struct trace_probe_event), GFP_KERNEL);
+	tp->event = kzalloc(sizeof(struct trace_probe_event) + event_data_size,
+			    GFP_KERNEL);
 	if (!tp->event)
 		return -ENOMEM;
 
diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
index 4ee703728aec..03e4e180058d 100644
--- a/kernel/trace/trace_probe.h
+++ b/kernel/trace/trace_probe.h
@@ -230,6 +230,7 @@ struct trace_probe_event {
 	struct trace_event_call		call;
 	struct list_head 		files;
 	struct list_head		probes;
+	char				data[0];
 };
 
 struct trace_probe {
@@ -322,7 +323,7 @@ static inline bool trace_probe_has_single_file(struct trace_probe *tp)
 }
 
 int trace_probe_init(struct trace_probe *tp, const char *event,
-		     const char *group);
+		     const char *group, size_t event_data_size);
 void trace_probe_cleanup(struct trace_probe *tp);
 int trace_probe_append(struct trace_probe *tp, struct trace_probe *to);
 void trace_probe_unlink(struct trace_probe *tp);
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 352073d36585..f66e202fec13 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -60,7 +60,6 @@ static struct dyn_event_operations trace_uprobe_ops = {
  */
 struct trace_uprobe {
 	struct dyn_event		devent;
-	struct trace_uprobe_filter	filter;
 	struct uprobe_consumer		consumer;
 	struct path			path;
 	struct inode			*inode;
@@ -264,6 +263,14 @@ process_fetch_insn(struct fetch_insn *code, struct pt_regs *regs, void *dest,
 }
 NOKPROBE_SYMBOL(process_fetch_insn)
 
+static struct trace_uprobe_filter *
+trace_uprobe_get_filter(struct trace_uprobe *tu)
+{
+	struct trace_probe_event *event = tu->tp.event;
+
+	return (struct trace_uprobe_filter *)&event->data[0];
+}
+
 static inline void init_trace_uprobe_filter(struct trace_uprobe_filter *filter)
 {
 	rwlock_init(&filter->rwlock);
@@ -351,7 +358,8 @@ alloc_trace_uprobe(const char *group, const char *event, int nargs, bool is_ret)
 	if (!tu)
 		return ERR_PTR(-ENOMEM);
 
-	ret = trace_probe_init(&tu->tp, event, group);
+	ret = trace_probe_init(&tu->tp, event, group,
+				sizeof(struct trace_uprobe_filter));
 	if (ret < 0)
 		goto error;
 
@@ -359,7 +367,7 @@ alloc_trace_uprobe(const char *group, const char *event, int nargs, bool is_ret)
 	tu->consumer.handler = uprobe_dispatcher;
 	if (is_ret)
 		tu->consumer.ret_handler = uretprobe_dispatcher;
-	init_trace_uprobe_filter(&tu->filter);
+	init_trace_uprobe_filter(trace_uprobe_get_filter(tu));
 	return tu;
 
 error:
@@ -1067,13 +1075,14 @@ static void __probe_event_disable(struct trace_probe *tp)
 	struct trace_probe *pos;
 	struct trace_uprobe *tu;
 
+	tu = container_of(tp, struct trace_uprobe, tp);
+	WARN_ON(!uprobe_filter_is_empty(trace_uprobe_get_filter(tu)));
+
 	list_for_each_entry(pos, trace_probe_probe_list(tp), list) {
 		tu = container_of(pos, struct trace_uprobe, tp);
 		if (!tu->inode)
 			continue;
 
-		WARN_ON(!uprobe_filter_is_empty(&tu->filter));
-
 		uprobe_unregister(tu->inode, tu->offset, &tu->consumer);
 		tu->inode = NULL;
 	}
@@ -1108,7 +1117,7 @@ static int probe_event_enable(struct trace_event_call *call,
 	}
 
 	tu = container_of(tp, struct trace_uprobe, tp);
-	WARN_ON(!uprobe_filter_is_empty(&tu->filter));
+	WARN_ON(!uprobe_filter_is_empty(trace_uprobe_get_filter(tu)));
 
 	if (enabled)
 		return 0;
@@ -1205,39 +1214,39 @@ __uprobe_perf_filter(struct trace_uprobe_filter *filter, struct mm_struct *mm)
 }
 
 static inline bool
-uprobe_filter_event(struct trace_uprobe *tu, struct perf_event *event)
+trace_uprobe_filter_event(struct trace_uprobe_filter *filter,
+			  struct perf_event *event)
 {
-	return __uprobe_perf_filter(&tu->filter, event->hw.target->mm);
+	return __uprobe_perf_filter(filter, event->hw.target->mm);
 }
 
-static int uprobe_perf_close(struct trace_uprobe *tu, struct perf_event *event)
+static bool trace_uprobe_filter_remove(struct trace_uprobe_filter *filter,
+				       struct perf_event *event)
 {
 	bool done;
 
-	write_lock(&tu->filter.rwlock);
+	write_lock(&filter->rwlock);
 	if (event->hw.target) {
 		list_del(&event->hw.tp_list);
-		done = tu->filter.nr_systemwide ||
+		done = filter->nr_systemwide ||
 			(event->hw.target->flags & PF_EXITING) ||
-			uprobe_filter_event(tu, event);
+			trace_uprobe_filter_event(filter, event);
 	} else {
-		tu->filter.nr_systemwide--;
-		done = tu->filter.nr_systemwide;
+		filter->nr_systemwide--;
+		done = filter->nr_systemwide;
 	}
-	write_unlock(&tu->filter.rwlock);
-
-	if (!done)
-		return uprobe_apply(tu->inode, tu->offset, &tu->consumer, false);
+	write_unlock(&filter->rwlock);
 
-	return 0;
+	return done;
 }
 
-static int uprobe_perf_open(struct trace_uprobe *tu, struct perf_event *event)
+/* This returns true if the filter always covers target mm */
+static bool trace_uprobe_filter_add(struct trace_uprobe_filter *filter,
+				    struct perf_event *event)
 {
 	bool done;
-	int err;
 
-	write_lock(&tu->filter.rwlock);
+	write_lock(&filter->rwlock);
 	if (event->hw.target) {
 		/*
 		 * event->parent != NULL means copy_process(), we can avoid
@@ -1247,28 +1256,21 @@ static int uprobe_perf_open(struct trace_uprobe *tu, struct perf_event *event)
 		 * attr.enable_on_exec means that exec/mmap will install the
 		 * breakpoints we need.
 		 */
-		done = tu->filter.nr_systemwide ||
+		done = filter->nr_systemwide ||
 			event->parent || event->attr.enable_on_exec ||
-			uprobe_filter_event(tu, event);
-		list_add(&event->hw.tp_list, &tu->filter.perf_events);
+			trace_uprobe_filter_event(filter, event);
+		list_add(&event->hw.tp_list, &filter->perf_events);
 	} else {
-		done = tu->filter.nr_systemwide;
-		tu->filter.nr_systemwide++;
+		done = filter->nr_systemwide;
+		filter->nr_systemwide++;
 	}
-	write_unlock(&tu->filter.rwlock);
+	write_unlock(&filter->rwlock);
 
-	err = 0;
-	if (!done) {
-		err = uprobe_apply(tu->inode, tu->offset, &tu->consumer, true);
-		if (err)
-			uprobe_perf_close(tu, event);
-	}
-	return err;
+	return done;
 }
 
-static int uprobe_perf_multi_call(struct trace_event_call *call,
-				  struct perf_event *event,
-		int (*op)(struct trace_uprobe *tu, struct perf_event *event))
+static int uprobe_perf_close(struct trace_event_call *call,
+			     struct perf_event *event)
 {
 	struct trace_probe *pos, *tp;
 	struct trace_uprobe *tu;
@@ -1278,25 +1280,59 @@ static int uprobe_perf_multi_call(struct trace_event_call *call,
 	if (WARN_ON_ONCE(!tp))
 		return -ENODEV;
 
+	tu = container_of(tp, struct trace_uprobe, tp);
+	if (trace_uprobe_filter_remove(trace_uprobe_get_filter(tu), event))
+		return 0;
+
 	list_for_each_entry(pos, trace_probe_probe_list(tp), list) {
 		tu = container_of(pos, struct trace_uprobe, tp);
-		ret = op(tu, event);
+		ret = uprobe_apply(tu->inode, tu->offset, &tu->consumer, false);
 		if (ret)
 			break;
 	}
 
 	return ret;
 }
+
+static int uprobe_perf_open(struct trace_event_call *call,
+			    struct perf_event *event)
+{
+	struct trace_probe *pos, *tp;
+	struct trace_uprobe *tu;
+	int err = 0;
+
+	tp = trace_probe_primary_from_call(call);
+	if (WARN_ON_ONCE(!tp))
+		return -ENODEV;
+
+	tu = container_of(tp, struct trace_uprobe, tp);
+	if (trace_uprobe_filter_add(trace_uprobe_get_filter(tu), event))
+		return 0;
+
+	list_for_each_entry(pos, trace_probe_probe_list(tp), list) {
+		err = uprobe_apply(tu->inode, tu->offset, &tu->consumer, true);
+		if (err) {
+			uprobe_perf_close(call, event);
+			break;
+		}
+	}
+
+	return err;
+}
+
 static bool uprobe_perf_filter(struct uprobe_consumer *uc,
 				enum uprobe_filter_ctx ctx, struct mm_struct *mm)
 {
+	struct trace_uprobe_filter *filter;
 	struct trace_uprobe *tu;
 	int ret;
 
 	tu = container_of(uc, struct trace_uprobe, consumer);
-	read_lock(&tu->filter.rwlock);
-	ret = __uprobe_perf_filter(&tu->filter, mm);
-	read_unlock(&tu->filter.rwlock);
+	filter = trace_uprobe_get_filter(tu);
+
+	read_lock(&filter->rwlock);
+	ret = __uprobe_perf_filter(filter, mm);
+	read_unlock(&filter->rwlock);
 
 	return ret;
 }
@@ -1419,10 +1455,10 @@ trace_uprobe_register(struct trace_event_call *event, enum trace_reg type,
 		return 0;
 
 	case TRACE_REG_PERF_OPEN:
-		return uprobe_perf_multi_call(event, data, uprobe_perf_open);
+		return uprobe_perf_open(event, data);
 
 	case TRACE_REG_PERF_CLOSE:
-		return uprobe_perf_multi_call(event, data, uprobe_perf_close);
+		return uprobe_perf_close(event, data);
 
 #endif
 	default:
-- 
2.24.1


