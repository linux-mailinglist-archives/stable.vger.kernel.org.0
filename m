Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC2F31FFF0B
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 01:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728361AbgFRX53 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jun 2020 19:57:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:36092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728283AbgFRX4m (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jun 2020 19:56:42 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BD222100A;
        Thu, 18 Jun 2020 23:56:41 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.93)
        (envelope-from <rostedt@goodmis.org>)
        id 1jm4Oe-003lQH-J2; Thu, 18 Jun 2020 19:56:40 -0400
Message-ID: <20200618235640.471806886@goodmis.org>
User-Agent: quilt/0.66
Date:   Thu, 18 Jun 2020 19:56:05 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org
Subject: [for-linus][PATCH 09/17] tracing: Make ftrace packed events have align of 1
References: <20200618235556.451120786@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

When using trace-cmd on 5.6-rt for the function graph tracer, the output was
corrupted. It gave output like this:

 funcgraph_entry:       func=0xffffffff depth=38982
 funcgraph_entry:       func=0x1ffffffff depth=16044
 funcgraph_exit:        func=0xffffffff overrun=0x92539aaf00000000 calltime=0x92539c9900000072 rettime=0x100000072 depth=11084
 funcgraph_exit:        func=0xffffffff overrun=0x9253946e00000000 calltime=0x92539e2100000072 rettime=0x72 depth=26033702
 funcgraph_entry:       func=0xffffffff depth=85798
 funcgraph_entry:       func=0x1ffffffff depth=12044

The reason was because the tracefs/events/ftrace/funcgraph_entry/exit format
file was incorrect. The -rt kernel adds more common fields to the trace
events. Namely, common_migrate_disable and common_preempt_lazy_count. Each
is one byte in size. This changes the alignment of the normal payload. Most
events are aligned normally, but the function and function graph events are
defined with a "PACKED" macro, that packs their payload. As the offsets
displayed in the format files are now calculated by an aligned field, the
aligned field for function and function graph events should be 1, not their
normal alignment.

With aligning of the funcgraph_entry event, the format file has:

        field:unsigned short common_type;       offset:0;       size:2; signed:0;
        field:unsigned char common_flags;       offset:2;       size:1; signed:0;
        field:unsigned char common_preempt_count;       offset:3;       size:1; signed:0;
        field:int common_pid;   offset:4;       size:4; signed:1;
        field:unsigned char common_migrate_disable;     offset:8;       size:1; signed:0;
        field:unsigned char common_preempt_lazy_count;  offset:9;       size:1; signed:0;

        field:unsigned long func;       offset:16;      size:8; signed:0;
        field:int depth;        offset:24;      size:4; signed:1;

But the actual alignment is:

	field:unsigned short common_type;	offset:0;	size:2;	signed:0;
	field:unsigned char common_flags;	offset:2;	size:1;	signed:0;
	field:unsigned char common_preempt_count;	offset:3;	size:1;	signed:0;
	field:int common_pid;	offset:4;	size:4;	signed:1;
	field:unsigned char common_migrate_disable;	offset:8;	size:1;	signed:0;
	field:unsigned char common_preempt_lazy_count;	offset:9;	size:1;	signed:0;

	field:unsigned long func;	offset:12;	size:8;	signed:0;
	field:int depth;	offset:20;	size:4;	signed:1;

Link: https://lkml.kernel.org/r/20200609220041.2a3b527f@oasis.local.home

Cc: stable@vger.kernel.org
Fixes: 04ae87a52074e ("ftrace: Rework event_create_dir()")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/trace/trace.h         |  3 +++
 kernel/trace/trace_entries.h | 14 +++++++-------
 kernel/trace/trace_export.c  | 16 ++++++++++++++++
 3 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index def769df5bf1..13db4000af3f 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -61,6 +61,9 @@ enum trace_type {
 #undef __field_desc
 #define __field_desc(type, container, item)
 
+#undef __field_packed
+#define __field_packed(type, container, item)
+
 #undef __array
 #define __array(type, item, size)	type	item[size];
 
diff --git a/kernel/trace/trace_entries.h b/kernel/trace/trace_entries.h
index a523da0dae0a..18c4a58aff79 100644
--- a/kernel/trace/trace_entries.h
+++ b/kernel/trace/trace_entries.h
@@ -78,8 +78,8 @@ FTRACE_ENTRY_PACKED(funcgraph_entry, ftrace_graph_ent_entry,
 
 	F_STRUCT(
 		__field_struct(	struct ftrace_graph_ent,	graph_ent	)
-		__field_desc(	unsigned long,	graph_ent,	func		)
-		__field_desc(	int,		graph_ent,	depth		)
+		__field_packed(	unsigned long,	graph_ent,	func		)
+		__field_packed(	int,		graph_ent,	depth		)
 	),
 
 	F_printk("--> %ps (%d)", (void *)__entry->func, __entry->depth)
@@ -92,11 +92,11 @@ FTRACE_ENTRY_PACKED(funcgraph_exit, ftrace_graph_ret_entry,
 
 	F_STRUCT(
 		__field_struct(	struct ftrace_graph_ret,	ret	)
-		__field_desc(	unsigned long,	ret,		func	)
-		__field_desc(	unsigned long,	ret,		overrun	)
-		__field_desc(	unsigned long long, ret,	calltime)
-		__field_desc(	unsigned long long, ret,	rettime	)
-		__field_desc(	int,		ret,		depth	)
+		__field_packed(	unsigned long,	ret,		func	)
+		__field_packed(	unsigned long,	ret,		overrun	)
+		__field_packed(	unsigned long long, ret,	calltime)
+		__field_packed(	unsigned long long, ret,	rettime	)
+		__field_packed(	int,		ret,		depth	)
 	),
 
 	F_printk("<-- %ps (%d) (start: %llx  end: %llx) over: %d",
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index 77ce5a3b6773..70d3d0a09053 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -45,6 +45,9 @@ static int ftrace_event_register(struct trace_event_call *call,
 #undef __field_desc
 #define __field_desc(type, container, item)		type item;
 
+#undef __field_packed
+#define __field_packed(type, container, item)		type item;
+
 #undef __array
 #define __array(type, item, size)			type item[size];
 
@@ -85,6 +88,13 @@ static void __always_unused ____ftrace_check_##name(void)		\
 	.size = sizeof(_type), .align = __alignof__(_type),		\
 	is_signed_type(_type), .filter_type = _filter_type },
 
+
+#undef __field_ext_packed
+#define __field_ext_packed(_type, _item, _filter_type) {	\
+	.type = #_type, .name = #_item,				\
+	.size = sizeof(_type), .align = 1,			\
+	is_signed_type(_type), .filter_type = _filter_type },
+
 #undef __field
 #define __field(_type, _item) __field_ext(_type, _item, FILTER_OTHER)
 
@@ -94,6 +104,9 @@ static void __always_unused ____ftrace_check_##name(void)		\
 #undef __field_desc
 #define __field_desc(_type, _container, _item) __field_ext(_type, _item, FILTER_OTHER)
 
+#undef __field_packed
+#define __field_packed(_type, _container, _item) __field_ext_packed(_type, _item, FILTER_OTHER)
+
 #undef __array
 #define __array(_type, _item, _len) {					\
 	.type = #_type"["__stringify(_len)"]", .name = #_item,		\
@@ -129,6 +142,9 @@ static struct trace_event_fields ftrace_event_fields_##name[] = {	\
 #undef __field_desc
 #define __field_desc(type, container, item)
 
+#undef __field_packed
+#define __field_packed(type, container, item)
+
 #undef __array
 #define __array(type, item, len)
 
-- 
2.26.2


