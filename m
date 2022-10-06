Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D73E5F5EB0
	for <lists+stable@lfdr.de>; Thu,  6 Oct 2022 04:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbiJFCVx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 22:21:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbiJFCVv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 22:21:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8149E4B0C9;
        Wed,  5 Oct 2022 19:21:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA3EB6181D;
        Thu,  6 Oct 2022 02:21:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54A90C43470;
        Thu,  6 Oct 2022 02:21:49 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@goodmis.org>)
        id 1ogGWI-002gPy-1M;
        Wed, 05 Oct 2022 22:21:54 -0400
Message-ID: <20221006022154.258328812@goodmis.org>
User-Agent: quilt/0.66
Date:   Wed, 05 Oct 2022 22:21:28 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, Ross Zwisler <zwisler@kernel.org>
Subject: [for-next][PATCH 2/2] tracing: Do not free snapshot if tracer is on cmdline
References: <20221006022126.894976366@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

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
---
 kernel/trace/trace.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

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
-- 
2.35.1
