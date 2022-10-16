Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFDE9600098
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 17:22:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbiJPPW6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 11:22:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbiJPPW6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 11:22:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 535F936BCD
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 08:22:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05865B80CA6
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 15:22:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5637CC433C1;
        Sun, 16 Oct 2022 15:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665933774;
        bh=aDKPT9rwf3xwzCvpKgHHjLFhcUi57PKkUl4q7UcUMAg=;
        h=Subject:To:Cc:From:Date:From;
        b=yqyxMuhgbgc/C97r3pcdlYJdi03Bwtd0LpdbnefFfineHtkSvoe1xTSNjB0LB/LMh
         Oom3DcnZP8WvWrPMwVMSBo5BBVZ6VC4WZMUIcWO2dJfy6qXaE8jpeYKO82jkzevdiW
         5P7zWFOt5aDR2OxDssZdrZHMHoLWfIBSUdyCTq7o=
Subject: FAILED: patch "[PATCH] tracing: Do not free snapshot if tracer is on cmdline" failed to apply to 5.10-stable tree
To:     rostedt@goodmis.org, akpm@linux-foundation.org,
        mhiramat@kernel.org, zwisler@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 16 Oct 2022 17:23:40 +0200
Message-ID: <1665933820109188@kroah.com>
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


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

a541a9559bb0 ("tracing: Do not free snapshot if tracer is on cmdline")
f4b0d318097e ("tracing: Simplify conditional compilation code in tracing_set_tracer()")

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

