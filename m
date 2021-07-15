Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC0B63CA7CB
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241483AbhGOS4U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:56:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:60452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241804AbhGOSzu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:55:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 529D1613E0;
        Thu, 15 Jul 2021 18:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375176;
        bh=VFcnzHhQTJ8lkpOys6XIBnUC/9rRaMOKXqzALTEit38=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QmpFQzWcdvPi3BpK9mhIpSOox7hasTapI5TrW39d6gqOuop1By7K5adrpzgqUs+ku
         jbylox9vwCFOAJp1eQrzrrCyqVebpBhMsl7LiXq0jjr2veZqPl4UUpALDuFqS8Xk2L
         G6XvP7rwImcdfICRrRLn6Ng8/zM+i71Xapy4kxoU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Joel Fernandes <joelaf@google.com>,
        Paul Burton <paulburton@google.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.10 190/215] tracing: Simplify & fix saved_tgids logic
Date:   Thu, 15 Jul 2021 20:39:22 +0200
Message-Id: <20210715182632.752757116@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182558.381078833@linuxfoundation.org>
References: <20210715182558.381078833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Burton <paulburton@google.com>

commit b81b3e959adb107cd5b36c7dc5ba1364bbd31eb2 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c |   38 +++++++++++++-------------------------
 1 file changed, 13 insertions(+), 25 deletions(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -5284,37 +5284,20 @@ static const struct file_operations trac
 
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
@@ -5323,9 +5306,14 @@ static void saved_tgids_stop(struct seq_
 
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
 


