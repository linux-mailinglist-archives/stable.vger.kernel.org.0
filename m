Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAE1F27B9F8
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 03:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727414AbgI2Bep (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Sep 2020 21:34:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:40922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727641AbgI2Bba (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Sep 2020 21:31:30 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA18C2311C;
        Tue, 29 Sep 2020 01:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601343083;
        bh=QrXEH/R629pVHr5xJ3XAcquGccangn+Q3/2jgX3mB6E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IuHEqZ1rEHNFV2RJZ5DU+Ql9RfdUGRW4bqYy88A/GoTh3ml/16+0L10qzK0KyxDu/
         4kMygCGl1h5Lrgx0x6ACifigDaPMeN3xIiQaYLEp7Z8irEE9meU7tvst6EUELDKDs6
         Lv424ASPK6UIzjnjXX1VW7SWjRxOjcqpsdIzkqc8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 14/18] tracing: Make the space reserved for the pid wider
Date:   Mon, 28 Sep 2020 21:31:00 -0400
Message-Id: <20200929013105.2406634-14-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200929013105.2406634-1-sashal@kernel.org>
References: <20200929013105.2406634-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit 795d6379a47bcbb88bd95a69920e4acc52849f88 ]

For 64bit CONFIG_BASE_SMALL=0 systems PID_MAX_LIMIT is set by default to
4194304. During boot the kernel sets a new value based on number of CPUs
but no lower than 32768. It is 1024 per CPU so with 128 CPUs the default
becomes 131072 which needs six digits.
This value can be increased during run time but must not exceed the
initial upper limit.

Systemd sometime after v241 sets it to the upper limit during boot. The
result is that when the pid exceeds five digits, the trace output is a
little hard to read because it is no longer properly padded (same like
on big iron with 98+ CPUs).

Increase the pid padding to seven digits.

Link: https://lkml.kernel.org/r/20200904082331.dcdkrr3bkn3e4qlg@linutronix.de

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace.c        | 38 ++++++++++++++++++-------------------
 kernel/trace/trace_output.c | 12 ++++++------
 2 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index f9c2bdbbd8936..a0339e5e3e3e2 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3581,14 +3581,14 @@ unsigned long trace_total_entries(struct trace_array *tr)
 
 static void print_lat_help_header(struct seq_file *m)
 {
-	seq_puts(m, "#                  _------=> CPU#            \n"
-		    "#                 / _-----=> irqs-off        \n"
-		    "#                | / _----=> need-resched    \n"
-		    "#                || / _---=> hardirq/softirq \n"
-		    "#                ||| / _--=> preempt-depth   \n"
-		    "#                |||| /     delay            \n"
-		    "#  cmd     pid   ||||| time  |   caller      \n"
-		    "#     \\   /      |||||  \\    |   /         \n");
+	seq_puts(m, "#                    _------=> CPU#            \n"
+		    "#                   / _-----=> irqs-off        \n"
+		    "#                  | / _----=> need-resched    \n"
+		    "#                  || / _---=> hardirq/softirq \n"
+		    "#                  ||| / _--=> preempt-depth   \n"
+		    "#                  |||| /     delay            \n"
+		    "#  cmd     pid     ||||| time  |   caller      \n"
+		    "#     \\   /        |||||  \\    |   /         \n");
 }
 
 static void print_event_info(struct trace_buffer *buf, struct seq_file *m)
@@ -3609,26 +3609,26 @@ static void print_func_help_header(struct trace_buffer *buf, struct seq_file *m,
 
 	print_event_info(buf, m);
 
-	seq_printf(m, "#           TASK-PID   %s  CPU#   TIMESTAMP  FUNCTION\n", tgid ? "TGID     " : "");
-	seq_printf(m, "#              | |     %s    |       |         |\n",	 tgid ? "  |      " : "");
+	seq_printf(m, "#           TASK-PID    %s CPU#     TIMESTAMP  FUNCTION\n", tgid ? "   TGID   " : "");
+	seq_printf(m, "#              | |      %s   |         |         |\n",      tgid ? "     |    " : "");
 }
 
 static void print_func_help_header_irq(struct trace_buffer *buf, struct seq_file *m,
 				       unsigned int flags)
 {
 	bool tgid = flags & TRACE_ITER_RECORD_TGID;
-	const char *space = "          ";
-	int prec = tgid ? 10 : 2;
+	const char *space = "            ";
+	int prec = tgid ? 12 : 2;
 
 	print_event_info(buf, m);
 
-	seq_printf(m, "#                          %.*s  _-----=> irqs-off\n", prec, space);
-	seq_printf(m, "#                          %.*s / _----=> need-resched\n", prec, space);
-	seq_printf(m, "#                          %.*s| / _---=> hardirq/softirq\n", prec, space);
-	seq_printf(m, "#                          %.*s|| / _--=> preempt-depth\n", prec, space);
-	seq_printf(m, "#                          %.*s||| /     delay\n", prec, space);
-	seq_printf(m, "#           TASK-PID %.*sCPU#  ||||    TIMESTAMP  FUNCTION\n", prec, "   TGID   ");
-	seq_printf(m, "#              | |   %.*s  |   ||||       |         |\n", prec, "     |    ");
+	seq_printf(m, "#                            %.*s  _-----=> irqs-off\n", prec, space);
+	seq_printf(m, "#                            %.*s / _----=> need-resched\n", prec, space);
+	seq_printf(m, "#                            %.*s| / _---=> hardirq/softirq\n", prec, space);
+	seq_printf(m, "#                            %.*s|| / _--=> preempt-depth\n", prec, space);
+	seq_printf(m, "#                            %.*s||| /     delay\n", prec, space);
+	seq_printf(m, "#           TASK-PID  %.*s CPU#  ||||   TIMESTAMP  FUNCTION\n", prec, "     TGID   ");
+	seq_printf(m, "#              | |    %.*s   |   ||||      |         |\n", prec, "       |    ");
 }
 
 void
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index d54ce252b05a8..a0a45901dc027 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -482,7 +482,7 @@ lat_print_generic(struct trace_seq *s, struct trace_entry *entry, int cpu)
 
 	trace_find_cmdline(entry->pid, comm);
 
-	trace_seq_printf(s, "%8.8s-%-5d %3d",
+	trace_seq_printf(s, "%8.8s-%-7d %3d",
 			 comm, entry->pid, cpu);
 
 	return trace_print_lat_fmt(s, entry);
@@ -573,15 +573,15 @@ int trace_print_context(struct trace_iterator *iter)
 
 	trace_find_cmdline(entry->pid, comm);
 
-	trace_seq_printf(s, "%16s-%-5d ", comm, entry->pid);
+	trace_seq_printf(s, "%16s-%-7d ", comm, entry->pid);
 
 	if (tr->trace_flags & TRACE_ITER_RECORD_TGID) {
 		unsigned int tgid = trace_find_tgid(entry->pid);
 
 		if (!tgid)
-			trace_seq_printf(s, "(-----) ");
+			trace_seq_printf(s, "(-------) ");
 		else
-			trace_seq_printf(s, "(%5d) ", tgid);
+			trace_seq_printf(s, "(%7d) ", tgid);
 	}
 
 	trace_seq_printf(s, "[%03d] ", iter->cpu);
@@ -624,7 +624,7 @@ int trace_print_lat_context(struct trace_iterator *iter)
 		trace_find_cmdline(entry->pid, comm);
 
 		trace_seq_printf(
-			s, "%16s %5d %3d %d %08x %08lx ",
+			s, "%16s %7d %3d %d %08x %08lx ",
 			comm, entry->pid, iter->cpu, entry->flags,
 			entry->preempt_count, iter->idx);
 	} else {
@@ -905,7 +905,7 @@ static enum print_line_t trace_ctxwake_print(struct trace_iterator *iter,
 	S = task_index_to_char(field->prev_state);
 	trace_find_cmdline(field->next_pid, comm);
 	trace_seq_printf(&iter->seq,
-			 " %5d:%3d:%c %s [%03d] %5d:%3d:%c %s\n",
+			 " %7d:%3d:%c %s [%03d] %7d:%3d:%c %s\n",
 			 field->prev_pid,
 			 field->prev_prio,
 			 S, delim,
-- 
2.25.1

