Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E84C206342
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:29:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389924AbgFWUUW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:20:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:37570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389887AbgFWUUT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:20:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2809206C3;
        Tue, 23 Jun 2020 20:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943618;
        bh=0RljbIrSJYmtRiqpkkHxXz0PZOqnpIji2puciASAjT8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2YWzRABMZM2nK8oFEXIA6COeWGPChf5Pceh4VTAbyDvrCV7zB0Pye0497fwdlEAJt
         Rrb94Wx/JewTRT6SRDH/xWoR9TVffkzCQPh2btuCuLObCyT9V03iE/jGOuwkvp5jyF
         tI9BKcSIPPHL8Lj6jpsGuAaVnwxJqZ3x4Yxw03gM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.7 462/477] tracing: Make ftrace packed events have align of 1
Date:   Tue, 23 Jun 2020 21:57:39 +0200
Message-Id: <20200623195429.388398627@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

commit 4649079b9de1ad86be9f4c989373adb8235a8485 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/trace.h         |    3 +++
 kernel/trace/trace_entries.h |   14 +++++++-------
 kernel/trace/trace_export.c  |   16 ++++++++++++++++
 3 files changed, 26 insertions(+), 7 deletions(-)

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
 
--- a/kernel/trace/trace_entries.h
+++ b/kernel/trace/trace_entries.h
@@ -78,8 +78,8 @@ FTRACE_ENTRY_PACKED(funcgraph_entry, ftr
 
 	F_STRUCT(
 		__field_struct(	struct ftrace_graph_ent,	graph_ent	)
-		__field_desc(	unsigned long,	graph_ent,	func		)
-		__field_desc(	int,		graph_ent,	depth		)
+		__field_packed(	unsigned long,	graph_ent,	func		)
+		__field_packed(	int,		graph_ent,	depth		)
 	),
 
 	F_printk("--> %ps (%d)", (void *)__entry->func, __entry->depth)
@@ -92,11 +92,11 @@ FTRACE_ENTRY_PACKED(funcgraph_exit, ftra
 
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
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -45,6 +45,9 @@ static int ftrace_event_register(struct
 #undef __field_desc
 #define __field_desc(type, container, item)		type item;
 
+#undef __field_packed
+#define __field_packed(type, container, item)		type item;
+
 #undef __array
 #define __array(type, item, size)			type item[size];
 
@@ -85,6 +88,13 @@ static void __always_unused ____ftrace_c
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
 
@@ -94,6 +104,9 @@ static void __always_unused ____ftrace_c
 #undef __field_desc
 #define __field_desc(_type, _container, _item) __field_ext(_type, _item, FILTER_OTHER)
 
+#undef __field_packed
+#define __field_packed(_type, _container, _item) __field_ext_packed(_type, _item, FILTER_OTHER)
+
 #undef __array
 #define __array(_type, _item, _len) {					\
 	.type = #_type"["__stringify(_len)"]", .name = #_item,		\
@@ -129,6 +142,9 @@ static struct trace_event_fields ftrace_
 #undef __field_desc
 #define __field_desc(type, container, item)
 
+#undef __field_packed
+#define __field_packed(type, container, item)
+
 #undef __array
 #define __array(type, item, len)
 


