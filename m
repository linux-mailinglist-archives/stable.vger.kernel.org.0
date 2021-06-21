Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B209F3AEC5E
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 17:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbhFUPbM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 11:31:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:55208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230059AbhFUPbM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 11:31:12 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB9FD6113E;
        Mon, 21 Jun 2021 15:28:57 +0000 (UTC)
Date:   Mon, 21 Jun 2021 11:28:56 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <gregkh@linuxfoundation.org>
Cc:     <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] tracing: Do not stop recording comms if
 the trace file is" failed to apply to 4.9-stable tree
Message-ID: <20210621112856.05268850@oasis.local.home>
In-Reply-To: <1624272081106153@kroah.com>
References: <1624272081106153@kroah.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 21 Jun 2021 12:41:21 +0200
<gregkh@linuxfoundation.org> wrote:

> The patch below does not apply to the 4.9-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 

The following should apply to both 4.9 and 4.4.

-- Steve


>From 4fdd595e4f9a1ff6d93ec702eaecae451cfc6591 Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Date: Thu, 17 Jun 2021 14:32:34 -0400
Subject: [PATCH] tracing: Do not stop recording comms if the trace file is
 being read

A while ago, when the "trace" file was opened, tracing was stopped, and
code was added to stop recording the comms to saved_cmdlines, for mapping
of the pids to the task name.

Code has been added that only records the comm if a trace event occurred,
and there's no reason to not trace it if the trace file is opened.

Cc: stable@vger.kernel.org
Fixes: 7ffbd48d5cab2 ("tracing: Cache comms only after an event occurred")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

Index: linux-test.git/kernel/trace/trace.c
===================================================================
--- linux-test.git.orig/kernel/trace/trace.c
+++ linux-test.git/kernel/trace/trace.c
@@ -1616,9 +1616,6 @@ struct saved_cmdlines_buffer {
 };
 static struct saved_cmdlines_buffer *savedcmd;
 
-/* temporary disable recording */
-static atomic_t trace_record_cmdline_disabled __read_mostly;
-
 static inline char *get_saved_cmdlines(int idx)
 {
 	return &savedcmd->saved_cmdlines[idx * TASK_COMM_LEN];
@@ -2825,9 +2822,6 @@ static void *s_start(struct seq_file *m,
 		return ERR_PTR(-EBUSY);
 #endif
 
-	if (!iter->snapshot)
-		atomic_inc(&trace_record_cmdline_disabled);
-
 	if (*pos != iter->pos) {
 		iter->ent = NULL;
 		iter->cpu = 0;
@@ -2870,9 +2864,6 @@ static void s_stop(struct seq_file *m, v
 		return;
 #endif
 
-	if (!iter->snapshot)
-		atomic_dec(&trace_record_cmdline_disabled);
-
 	trace_access_unlock(iter->cpu_file);
 	trace_event_read_unlock();
 }
