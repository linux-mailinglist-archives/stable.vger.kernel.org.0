Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3392C1AEBDC
	for <lists+stable@lfdr.de>; Sat, 18 Apr 2020 12:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725857AbgDRKkE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Apr 2020 06:40:04 -0400
Received: from wforward5-smtp.messagingengine.com ([64.147.123.35]:50995 "EHLO
        wforward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725799AbgDRKkE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Apr 2020 06:40:04 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id A32C34B0;
        Sat, 18 Apr 2020 06:40:03 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Sat, 18 Apr 2020 06:40:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=JGNrP4
        KBlYxxLHJDW0caKRkyfV6+OBxazJPcl6KKjF4=; b=lnoQeKJ4do16L36tYAFpX6
        DK+9NlPnBZLRPpsYA1BnZDsHv67JlObgGvNjZ3OzgHrWOKoazRsG3MFgVWNF/6lN
        wIn5NaU3d2D19NVMA9pKY2rriHV38hxOTTRoRXqsgb3ch3uS8rSeq0yYJZDQXxC9
        LFQlIVNZKxND7eFnOFhFt18IHolwaoiKO1z2oKkNy/GCsuA501F0E1RRk46WKlZD
        knDhJkuNgujX3BqaeIUCy0cuDsNlAjsHCDcbnbI+/lfFibVFYoVZRhYiGMc7NLrT
        Hr2swLh2AMPhZ4fFfUA6vX2p5szffWWFKvZQh0u0eB12yAOjp97Vc8T0dCxi/UHA
        ==
X-ME-Sender: <xms:A9maXmg7yYWYFym9O8ZQlX9xBwldDuDHpXNmYy-ZHqN0RJqUa5r09w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrfeelgdefvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekledrud
    dtjeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehg
    rhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:A9maXmPWuIV9SCJUZKhtAH-ctqpL4lMcutfhwCNg1PGXS2VFxwdcIw>
    <xmx:A9maXgylxToV9XbFGE-ZaYfqW_x0HzEHzwjxpyXvt56T2VvnPmx5Sg>
    <xmx:A9maXopH0e_QG6aq-XqrW4zhT2f6D0DgYr_iqpcxjOCv3x0MEjdFsA>
    <xmx:A9maXk0veEe5JLP8ffzNhu3VHwGnywkR-Ce3rS7-o9BbnFbTpamsJ7d-V3M>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id D0FED3280064;
        Sat, 18 Apr 2020 06:40:02 -0400 (EDT)
Subject: FAILED: patch "[PATCH] tracing: Fix the race between registering 'snapshot' event" failed to apply to 4.9-stable tree
To:     yangx.jy@cn.fujitsu.com, rostedt@goodmis.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 18 Apr 2020 12:39:53 +0200
Message-ID: <1587206393189190@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 0bbe7f719985efd9adb3454679ecef0984cb6800 Mon Sep 17 00:00:00 2001
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

diff --git a/kernel/trace/trace_events_trigger.c b/kernel/trace/trace_events_trigger.c
index dd34a1b46a86..3a74736da363 100644
--- a/kernel/trace/trace_events_trigger.c
+++ b/kernel/trace/trace_events_trigger.c
@@ -1088,14 +1088,10 @@ register_snapshot_trigger(char *glob, struct event_trigger_ops *ops,
 			  struct event_trigger_data *data,
 			  struct trace_event_file *file)
 {
-	int ret = register_trigger(glob, ops, data, file);
-
-	if (ret > 0 && tracing_alloc_snapshot_instance(file->tr) != 0) {
-		unregister_trigger(glob, ops, data, file);
-		ret = 0;
-	}
+	if (tracing_alloc_snapshot_instance(file->tr) != 0)
+		return 0;
 
-	return ret;
+	return register_trigger(glob, ops, data, file);
 }
 
 static int

