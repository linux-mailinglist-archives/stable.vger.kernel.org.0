Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11CBD3ACC09
	for <lists+stable@lfdr.de>; Fri, 18 Jun 2021 15:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233577AbhFRNXg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Jun 2021 09:23:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:60026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232825AbhFRNXg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Jun 2021 09:23:36 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B671613F6;
        Fri, 18 Jun 2021 13:21:27 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@goodmis.org>)
        id 1luER4-003VFe-5W; Fri, 18 Jun 2021 09:21:26 -0400
Message-ID: <20210618132125.986218910@goodmis.org>
User-Agent: quilt/0.66
Date:   Fri, 18 Jun 2021 09:20:49 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org
Subject: [for-linus][PATCH 3/4] tracing: Do not stop recording comms if the trace file is being read
References: <20210618132046.600413369@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

A while ago, when the "trace" file was opened, tracing was stopped, and
code was added to stop recording the comms to saved_cmdlines, for mapping
of the pids to the task name.

Code has been added that only records the comm if a trace event occurred,
and there's no reason to not trace it if the trace file is opened.

Cc: stable@vger.kernel.org
Fixes: 7ffbd48d5cab2 ("tracing: Cache comms only after an event occurred")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/trace/trace.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index e220b37e29c6..d23a09d3eb37 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2198,9 +2198,6 @@ struct saved_cmdlines_buffer {
 };
 static struct saved_cmdlines_buffer *savedcmd;
 
-/* temporary disable recording */
-static atomic_t trace_record_taskinfo_disabled __read_mostly;
-
 static inline char *get_saved_cmdlines(int idx)
 {
 	return &savedcmd->saved_cmdlines[idx * TASK_COMM_LEN];
@@ -3996,9 +3993,6 @@ static void *s_start(struct seq_file *m, loff_t *pos)
 		return ERR_PTR(-EBUSY);
 #endif
 
-	if (!iter->snapshot)
-		atomic_inc(&trace_record_taskinfo_disabled);
-
 	if (*pos != iter->pos) {
 		iter->ent = NULL;
 		iter->cpu = 0;
@@ -4041,9 +4035,6 @@ static void s_stop(struct seq_file *m, void *p)
 		return;
 #endif
 
-	if (!iter->snapshot)
-		atomic_dec(&trace_record_taskinfo_disabled);
-
 	trace_access_unlock(iter->cpu_file);
 	trace_event_read_unlock();
 }
-- 
2.30.2
