Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1327F1B17BD
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 22:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728214AbgDTU6a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 16:58:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:34438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728164AbgDTU63 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 16:58:29 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1047C20857;
        Mon, 20 Apr 2020 20:58:28 +0000 (UTC)
Date:   Mon, 20 Apr 2020 16:58:27 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <gregkh@linuxfoundation.org>
Cc:     yangx.jy@cn.fujitsu.com, <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] tracing: Fix the race between
 registering 'snapshot' event" failed to apply to 4.9-stable tree
Message-ID: <20200420165827.59308521@gandalf.local.home>
In-Reply-To: <1587206393189190@kroah.com>
References: <1587206393189190@kroah.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 18 Apr 2020 12:39:53 +0200
<gregkh@linuxfoundation.org> wrote:

> The patch below does not apply to the 4.9-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 

The below should apply and work for 4.9 and 4.4.

-- Steve

>From 0bbe7f719985efd9adb3454679ecef0984cb6800 Mon Sep 17 00:00:00 2001
From: Xiao Yang <yangx.jy@cn.fujitsu.com>
Date: Tue, 14 Apr 2020 09:51:45 +0800
Subject: [PATCH] tracing: Fix the race between registering 'snapshot' event
 trigger and triggering 'snapshot' operation

Traced event can trigger 'snapshot' operation(i.e. calls snapshot_trigger()
or snapshot_count_trigger()) when register_snapshot_trigger() has completed
registration but doesn't allocate buffer for 'snapshot' event trigger.  In
the rare case, 'snapshot' operation always detects the lack of allocated
buffer so make register_snapshot_trigger() allocate buffer first.

trigger-snapshot.tc in kselftest reproduces the issue on slow vm:
-----------------------------------------------------------
cat trace
...
ftracetest-3028  [002] ....   236.784290: sched_process_fork: comm=ftracetest pid=3028 child_comm=ftracetest child_pid=3036
     <...>-2875  [003] ....   240.460335: tracing_snapshot_instance_cond: *** SNAPSHOT NOT ALLOCATED ***
     <...>-2875  [003] ....   240.460338: tracing_snapshot_instance_cond: *** stopping trace here!   ***
-----------------------------------------------------------

Link: http://lkml.kernel.org/r/20200414015145.66236-1-yangx.jy@cn.fujitsu.com

Cc: stable@vger.kernel.org
Fixes: 93e31ffbf417a ("tracing: Add 'snapshot' event trigger command")
Signed-off-by: Xiao Yang <yangx.jy@cn.fujitsu.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

Index: linux-test.git/kernel/trace/trace_events_trigger.c
===================================================================
--- linux-test.git.orig/kernel/trace/trace_events_trigger.c
+++ linux-test.git/kernel/trace/trace_events_trigger.c
@@ -1068,14 +1068,10 @@ register_snapshot_trigger(char *glob, st
 			  struct event_trigger_data *data,
 			  struct trace_event_file *file)
 {
-	int ret = register_trigger(glob, ops, data, file);
+	if (tracing_alloc_snapshot() != 0)
+		return 0;
 
-	if (ret > 0 && tracing_alloc_snapshot() != 0) {
-		unregister_trigger(glob, ops, data, file);
-		ret = 0;
-	}
-
-	return ret;
+	return register_trigger(glob, ops, data, file);
 }
 
 static int
