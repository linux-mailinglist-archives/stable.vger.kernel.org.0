Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B43718B60F
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:24:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730383AbgCSNXs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:23:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:49930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730386AbgCSNXr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:23:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22F8521707;
        Thu, 19 Mar 2020 13:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584624226;
        bh=/sOLfcB78ooPON9tkDzlMoGzEbOGHBf9o0sHqQL4E74=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a6wjLZQwVxPhnScF2dfBJHWvjYioySBo9jeWsYJYnQrylxjiqmVUQfMqUXpXwcMnJ
         KgoH3uS2bpt0WwY0pXDwE6dxxDEgPChiiE6qQzPNGQgWc5bLSEWE7cy2ju/j0huH/j
         PN+vAs7yA0DlCzdQB00pibYlLYvaUmCaHGzXFbCI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Tom Zanussi <zanussi@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 22/60] tracing: Fix number printing bug in print_synth_event()
Date:   Thu, 19 Mar 2020 14:04:00 +0100
Message-Id: <20200319123926.307490100@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123919.441695203@linuxfoundation.org>
References: <20200319123919.441695203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Zanussi <zanussi@kernel.org>

[ Upstream commit 784bd0847eda032ed2f3522f87250655a18c0190 ]

Fix a varargs-related bug in print_synth_event() which resulted in
strange output and oopses on 32-bit x86 systems. The problem is that
trace_seq_printf() expects the varargs to match the format string, but
print_synth_event() was always passing u64 values regardless.  This
results in unspecified behavior when unpacking with va_arg() in
trace_seq_printf().

Add a function that takes the size into account when calling
trace_seq_printf().

Before:

  modprobe-1731  [003] ....   919.039758: gen_synth_test: next_pid_field=777(null)next_comm_field=hula hoops ts_ns=1000000 ts_ms=1000 cpu=3(null)my_string_field=thneed my_int_field=598(null)

After:

 insmod-1136  [001] ....    36.634590: gen_synth_test: next_pid_field=777 next_comm_field=hula hoops ts_ns=1000000 ts_ms=1000 cpu=1 my_string_field=thneed my_int_field=598

Link: http://lkml.kernel.org/r/a9b59eb515dbbd7d4abe53b347dccf7a8e285657.1581720155.git.zanussi@kernel.org

Reported-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Tom Zanussi <zanussi@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events_hist.c | 32 +++++++++++++++++++++++++++++---
 1 file changed, 29 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index a31be3fce3e8e..6495800fb92a1 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -811,6 +811,29 @@ static const char *synth_field_fmt(char *type)
 	return fmt;
 }
 
+static void print_synth_event_num_val(struct trace_seq *s,
+				      char *print_fmt, char *name,
+				      int size, u64 val, char *space)
+{
+	switch (size) {
+	case 1:
+		trace_seq_printf(s, print_fmt, name, (u8)val, space);
+		break;
+
+	case 2:
+		trace_seq_printf(s, print_fmt, name, (u16)val, space);
+		break;
+
+	case 4:
+		trace_seq_printf(s, print_fmt, name, (u32)val, space);
+		break;
+
+	default:
+		trace_seq_printf(s, print_fmt, name, val, space);
+		break;
+	}
+}
+
 static enum print_line_t print_synth_event(struct trace_iterator *iter,
 					   int flags,
 					   struct trace_event *event)
@@ -849,10 +872,13 @@ static enum print_line_t print_synth_event(struct trace_iterator *iter,
 		} else {
 			struct trace_print_flags __flags[] = {
 			    __def_gfpflag_names, {-1, NULL} };
+			char *space = (i == se->n_fields - 1 ? "" : " ");
 
-			trace_seq_printf(s, print_fmt, se->fields[i]->name,
-					 entry->fields[n_u64],
-					 i == se->n_fields - 1 ? "" : " ");
+			print_synth_event_num_val(s, print_fmt,
+						  se->fields[i]->name,
+						  se->fields[i]->size,
+						  entry->fields[n_u64],
+						  space);
 
 			if (strcmp(se->fields[i]->type, "gfp_t") == 0) {
 				trace_seq_puts(s, " (");
-- 
2.20.1



