Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F40031C9804
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 19:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728068AbgEGRjk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 13:39:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:35774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726491AbgEGRja (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 May 2020 13:39:30 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58A02218AC;
        Thu,  7 May 2020 17:39:30 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.93)
        (envelope-from <rostedt@goodmis.org>)
        id 1jWkUb-000DoE-7b; Thu, 07 May 2020 13:39:29 -0400
Message-ID: <20200507173929.118079761@goodmis.org>
User-Agent: quilt/0.66
Date:   Thu, 07 May 2020 13:39:10 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>,
        Joerg Roedel <jroedel@suse.de>
Subject: [for-linus][PATCH 6/9] tracing: Add a vmalloc_sync_mappings() for safe measure
References: <20200507173904.729935165@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

x86_64 lazily maps in the vmalloc pages, and the way this works with per_cpu
areas can be complex, to say the least. Mappings may happen at boot up, and
if nothing synchronizes the page tables, those page mappings may not be
synced till they are used. This causes issues for anything that might touch
one of those mappings in the path of the page fault handler. When one of
those unmapped mappings is touched in the page fault handler, it will cause
another page fault, which in turn will cause a page fault, and leave us in
a loop of page faults.

Commit 763802b53a42 ("x86/mm: split vmalloc_sync_all()") split
vmalloc_sync_all() into vmalloc_sync_unmappings() and
vmalloc_sync_mappings(), as on system exit, it did not need to do a full
sync on x86_64 (although it still needed to be done on x86_32). By chance,
the vmalloc_sync_all() would synchronize the page mappings done at boot up
and prevent the per cpu area from being a problem for tracing in the page
fault handler. But when that synchronization in the exit of a task became a
nop, it caused the problem to appear.

Link: https://lore.kernel.org/r/20200429054857.66e8e333@oasis.local.home

Cc: stable@vger.kernel.org
Fixes: 737223fbca3b1 ("tracing: Consolidate buffer allocation code")
Reported-by: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Suggested-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/trace/trace.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 8d2b98812625..9ed6d92768af 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -8525,6 +8525,19 @@ static int allocate_trace_buffers(struct trace_array *tr, int size)
 	 */
 	allocate_snapshot = false;
 #endif
+
+	/*
+	 * Because of some magic with the way alloc_percpu() works on
+	 * x86_64, we need to synchronize the pgd of all the tables,
+	 * otherwise the trace events that happen in x86_64 page fault
+	 * handlers can't cope with accessing the chance that a
+	 * alloc_percpu()'d memory might be touched in the page fault trace
+	 * event. Oh, and we need to audit all other alloc_percpu() and vmalloc()
+	 * calls in tracing, because something might get triggered within a
+	 * page fault trace event!
+	 */
+	vmalloc_sync_mappings();
+
 	return 0;
 }
 
-- 
2.26.2


