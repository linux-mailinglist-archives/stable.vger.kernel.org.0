Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF0103B9B3F
	for <lists+stable@lfdr.de>; Fri,  2 Jul 2021 06:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbhGBEM2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Jul 2021 00:12:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:58504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229870AbhGBEM2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Jul 2021 00:12:28 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD02861413;
        Fri,  2 Jul 2021 04:09:56 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@goodmis.org>)
        id 1lzAV1-000eQN-Ng; Fri, 02 Jul 2021 00:09:55 -0400
Message-ID: <20210702040955.567600244@goodmis.org>
User-Agent: quilt/0.66
Date:   Fri, 02 Jul 2021 00:09:37 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Joel Fernandes <joelaf@google.com>, <stable@vger.kernel.org>,
        Paul Burton <paulburton@google.com>
Subject: [for-next][PATCH 1/2] tracing: Simplify & fix saved_tgids logic
References: <20210702040936.551628380@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Burton <paulburton@google.com>

The tgid_map array records a mapping from pid to tgid, where the index
of an entry within the array is the pid & the value stored at that index
is the tgid.

The saved_tgids_next() function iterates over pointers into the tgid_map
array & dereferences the pointers which results in the tgid, but then it
passes that dereferenced value to trace_find_tgid() which treats it as a
pid & does a further lookup within the tgid_map array. It seems likely
that the intent here was to skip over entries in tgid_map for which the
recorded tgid is zero, but instead we end up skipping over entries for
which the thread group leader hasn't yet had its own tgid recorded in
tgid_map.

A minimal fix would be to remove the call to trace_find_tgid, turning:

  if (trace_find_tgid(*ptr))

into:

  if (*ptr)

..but it seems like this logic can be much simpler if we simply let
seq_read() iterate over the whole tgid_map array & filter out empty
entries by returning SEQ_SKIP from saved_tgids_show(). Here we take that
approach, removing the incorrect logic here entirely.

Link: https://lkml.kernel.org/r/20210630003406.4013668-1-paulburton@google.com

Fixes: d914ba37d714 ("tracing: Add support for recording tgid of tasks")
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Joel Fernandes <joelaf@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Paul Burton <paulburton@google.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/trace/trace.c | 38 +++++++++++++-------------------------
 1 file changed, 13 insertions(+), 25 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 60492464281e..4843076d67d3 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -5662,37 +5662,20 @@ static const struct file_operations tracing_readme_fops = {
 
 static void *saved_tgids_next(struct seq_file *m, void *v, loff_t *pos)
 {
-	int *ptr = v;
+	int pid = ++(*pos);
 
-	if (*pos || m->count)
-		ptr++;
-
-	(*pos)++;
-
-	for (; ptr <= &tgid_map[PID_MAX_DEFAULT]; ptr++) {
-		if (trace_find_tgid(*ptr))
-			return ptr;
-	}
+	if (pid > PID_MAX_DEFAULT)
+		return NULL;
 
-	return NULL;
+	return &tgid_map[pid];
 }
 
 static void *saved_tgids_start(struct seq_file *m, loff_t *pos)
 {
-	void *v;
-	loff_t l = 0;
-
-	if (!tgid_map)
+	if (!tgid_map || *pos > PID_MAX_DEFAULT)
 		return NULL;
 
-	v = &tgid_map[0];
-	while (l <= *pos) {
-		v = saved_tgids_next(m, v, &l);
-		if (!v)
-			return NULL;
-	}
-
-	return v;
+	return &tgid_map[*pos];
 }
 
 static void saved_tgids_stop(struct seq_file *m, void *v)
@@ -5701,9 +5684,14 @@ static void saved_tgids_stop(struct seq_file *m, void *v)
 
 static int saved_tgids_show(struct seq_file *m, void *v)
 {
-	int pid = (int *)v - tgid_map;
+	int *entry = (int *)v;
+	int pid = entry - tgid_map;
+	int tgid = *entry;
+
+	if (tgid == 0)
+		return SEQ_SKIP;
 
-	seq_printf(m, "%d %d\n", pid, trace_find_tgid(pid));
+	seq_printf(m, "%d %d\n", pid, tgid);
 	return 0;
 }
 
-- 
2.30.2
