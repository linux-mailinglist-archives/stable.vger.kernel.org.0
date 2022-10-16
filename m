Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F06160009B
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 17:23:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbiJPPXV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 11:23:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbiJPPXT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 11:23:19 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8533E36BCD
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 08:23:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DD297CE0B7F
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 15:23:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C25AC433D6;
        Sun, 16 Oct 2022 15:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665933795;
        bh=/MY6GEsnb+4Ucyid/GOsSgyImApUi52z2sBpc0+eGjc=;
        h=Subject:To:Cc:From:Date:From;
        b=tGNhmsf7Lt9JvjuyM0gemR39yHb7W3PmO/PLzVZn6IUH2r1kZMQ8qxdvHajSV/dPG
         zfo05/DUGTznIeAGL2/l1sTuELYF6Rkuv027tTuSEPW8Zeg8GC9ANbvRCO9nAXevce
         bKaXFFvoTslb1GCjQ+DTL9I61SSjYMNknOHet2WM=
Subject: FAILED: patch "[PATCH] tracing: Do not free snapshot if tracer is on cmdline" failed to apply to 4.14-stable tree
To:     rostedt@goodmis.org, akpm@linux-foundation.org,
        mhiramat@kernel.org, zwisler@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 16 Oct 2022 17:23:56 +0200
Message-ID: <1665933836232147@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

a541a9559bb0 ("tracing: Do not free snapshot if tracer is on cmdline")
f4b0d318097e ("tracing: Simplify conditional compilation code in tracing_set_tracer()")
7440172974e8 ("tracing: Replace synchronize_sched() and call_rcu_sched()")
f8a79d5c7ef4 ("tracepoints: Free early tracepoints after RCU is initialized")
e0a568dcd18b ("tracing: Fix synchronizing to event changes with tracepoint_synchronize_unregister()")
e6753f23d961 ("tracepoint: Make rcuidle tracepoint callers use SRCU")
2824f5033248 ("tracing: Make the snapshot trigger work with instances")
80765597bc58 ("tracing: Rewrite filter logic to be simpler and faster")
478325f18865 ("tracing: Clean up and document pred_funcs_##type creation and use")
e9baef0d8616 ("tracing: Combine enum and arrays into single macro in filter code")
567f6989fd2a ("tracing: Embed replace_filter_string() helper function")
404a3add43c9 ("tracing: Only add filter list when needed")
c7399708b3cd ("tracing: Remove filter allocator helper")
559d421267d1 ("tracing: Use trace_seq instead of open code string appending")
a0ff08fd4e3f ("tracing: Remove BUG_ON() from append_filter_string()")
844ccdd7dce2 ("rcu: Eliminate rcu_irq_enter_disabled()")
51a1fd30f130 ("rcu: Make ->dynticks_nesting be a simple counter")
58721f5da4bc ("rcu: Define rcu_irq_{enter,exit}() in terms of rcu_nmi_{enter,exit}()")
6136d6e48a01 ("rcu: Clamp ->dynticks_nmi_nesting at eqs entry/exit")
a0eb22bf64a7 ("rcu: Reduce dyntick-idle state space")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a541a9559bb0a8ecc434de01d3e4826c32e8bb53 Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Date: Wed, 5 Oct 2022 11:37:57 -0400
Subject: [PATCH] tracing: Do not free snapshot if tracer is on cmdline

The ftrace_boot_snapshot and alloc_snapshot cmdline options allocate the
snapshot buffer at boot up for use later. The ftrace_boot_snapshot in
particular requires the snapshot to be allocated because it will take a
snapshot at the end of boot up allowing to see the traces that happened
during boot so that it's not lost when user space takes over.

When a tracer is registered (started) there's a path that checks if it
requires the snapshot buffer or not, and if it does not and it was
allocated it will do a synchronization and free the snapshot buffer.

This is only required if the previous tracer was using it for "max
latency" snapshots, as it needs to make sure all max snapshots are
complete before freeing. But this is only needed if the previous tracer
was using the snapshot buffer for latency (like irqoff tracer and
friends). But it does not make sense to free it, if the previous tracer
was not using it, and the snapshot was allocated by the cmdline
parameters. This basically takes away the point of allocating it in the
first place!

Note, the allocated snapshot worked fine for just trace events, but fails
when a tracer is enabled on the cmdline.

Further investigation, this goes back even further and it does not require
a tracer on the cmdline to fail. Simply enable snapshots and then enable a
tracer, and it will remove the snapshot.

Link: https://lkml.kernel.org/r/20221005113757.041df7fe@gandalf.local.home

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: stable@vger.kernel.org
Fixes: 45ad21ca5530 ("tracing: Have trace_array keep track if snapshot buffer is allocated")
Reported-by: Ross Zwisler <zwisler@kernel.org>
Tested-by: Ross Zwisler <zwisler@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index def721de68a0..47a44b055a1d 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -6428,12 +6428,12 @@ int tracing_set_tracer(struct trace_array *tr, const char *buf)
 	if (tr->current_trace->reset)
 		tr->current_trace->reset(tr);
 
+#ifdef CONFIG_TRACER_MAX_TRACE
+	had_max_tr = tr->current_trace->use_max_tr;
+
 	/* Current trace needs to be nop_trace before synchronize_rcu */
 	tr->current_trace = &nop_trace;
 
-#ifdef CONFIG_TRACER_MAX_TRACE
-	had_max_tr = tr->allocated_snapshot;
-
 	if (had_max_tr && !t->use_max_tr) {
 		/*
 		 * We need to make sure that the update_max_tr sees that
@@ -6446,11 +6446,13 @@ int tracing_set_tracer(struct trace_array *tr, const char *buf)
 		free_snapshot(tr);
 	}
 
-	if (t->use_max_tr && !had_max_tr) {
+	if (t->use_max_tr && !tr->allocated_snapshot) {
 		ret = tracing_alloc_snapshot_instance(tr);
 		if (ret < 0)
 			goto out;
 	}
+#else
+	tr->current_trace = &nop_trace;
 #endif
 
 	if (t->init) {

