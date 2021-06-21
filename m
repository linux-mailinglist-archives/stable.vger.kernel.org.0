Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 417B73AEC34
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 17:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbhFUPZF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 11:25:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:53164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230071AbhFUPZF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 11:25:05 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8947D61002;
        Mon, 21 Jun 2021 15:22:50 +0000 (UTC)
Date:   Mon, 21 Jun 2021 11:22:49 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <gregkh@linuxfoundation.org>
Cc:     <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] tracing: Do not stop recording cmdlines
 when tracing is off" failed to apply to 4.9-stable tree
Message-ID: <20210621112249.0e15c939@oasis.local.home>
In-Reply-To: <1624272059104109@kroah.com>
References: <1624272059104109@kroah.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 21 Jun 2021 12:40:59 +0200
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

The following should work for both 4.4 and 4.9

-- Steve


>From 85550c83da421fb12dc1816c45012e1e638d2b38 Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Date: Thu, 17 Jun 2021 13:47:25 -0400
Subject: [PATCH] tracing: Do not stop recording cmdlines when tracing is off

The saved_cmdlines is used to map pids to the task name, such that the
output of the tracing does not just show pids, but also gives a human
readable name for the task.

If the name is not mapped, the output looks like this:

    <...>-1316          [005] ...2   132.044039: ...

Instead of this:

    gnome-shell-1316    [005] ...2   132.044039: ...

The names are updated when tracing is running, but are skipped if tracing
is stopped. Unfortunately, this stops the recording of the names if the
top level tracer is stopped, and not if there's other tracers active.

The recording of a name only happens when a new event is written into a
ring buffer, so there is no need to test if tracing is on or not. If
tracing is off, then no event is written and no need to test if tracing is
off or not.

Remove the check, as it hides the names of tasks for events in the
instance buffers.

Cc: stable@vger.kernel.org
Fixes: 7ffbd48d5cab2 ("tracing: Cache comms only after an event occurred")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

Index: linux-test.git/kernel/trace/trace.c
===================================================================
--- linux-test.git.orig/kernel/trace/trace.c
+++ linux-test.git/kernel/trace/trace.c
@@ -1882,9 +1882,6 @@ void trace_find_cmdline(int pid, char co
 
 void tracing_record_cmdline(struct task_struct *tsk)
 {
-	if (atomic_read(&trace_record_cmdline_disabled) || !tracing_is_on())
-		return;
-
 	if (!__this_cpu_read(trace_cmdline_save))
 		return;
 
