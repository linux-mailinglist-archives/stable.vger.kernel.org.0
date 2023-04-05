Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1C226D725C
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 04:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbjDECXr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 22:23:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236548AbjDECXp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 22:23:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39B282106;
        Tue,  4 Apr 2023 19:23:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C022B60DD5;
        Wed,  5 Apr 2023 02:23:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A30CC4339E;
        Wed,  5 Apr 2023 02:23:43 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
        (envelope-from <rostedt@goodmis.org>)
        id 1pjsoI-000hVn-0E;
        Tue, 04 Apr 2023 22:23:42 -0400
Message-ID: <20230405022341.895334039@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 04 Apr 2023 22:21:15 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ross Zwisler <zwisler@google.com>, stable@vger.kernel.org
Subject: [PATCH 2/2 v2] tracing: Fix ftrace_boot_snapshot command line logic
References: <20230405022113.860447811@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Spam-Status: No, score=-2.1 required=5.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The kernel command line ftrace_boot_snapshot by itself is supposed to
trigger a snapshot at the end of boot up of the main top level trace
buffer. A ftrace_boot_snapshot=foo will do the same for an instance called
foo that was created by trace_instance=foo,...

The logic was broken where if ftrace_boot_snapshot was by itself, it would
trigger a snapshot for all instances that had tracing enabled, regardless
if it asked for a snapshot or not.

When a snapshot is requested for a buffer, the buffer's
tr->allocated_snapshot is set to true. Use that to know if a trace buffer
wants a snapshot at boot up or not.

Since the top level buffer is part of the ftrace_trace_arrays list,
there's no reason to treat it differently than the other buffers. Just
iterate the list if ftrace_boot_snapshot was specified.

Cc: stable@vger.kernel.org
Fixes: 9c1c251d670bc ("tracing: Allow boot instances to have snapshot buffers")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
Changes since v1: https://lkml.kernel.org/r/20230404230308.501833715@goodmis.org

 - Protect use of tr->allocated_snapshot around #ifdef TRACER_MAX_TRACE

 kernel/trace/trace.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 93740a9370c6..36a6037823cd 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -10394,19 +10394,20 @@ __init static int tracer_alloc_buffers(void)
 
 void __init ftrace_boot_snapshot(void)
 {
+#ifdef CONFIG_TRACER_MAX_TRACE
 	struct trace_array *tr;
 
-	if (snapshot_at_boot) {
-		tracing_snapshot();
-		internal_trace_puts("** Boot snapshot taken **\n");
-	}
+	if (!snapshot_at_boot)
+		return;
 
 	list_for_each_entry(tr, &ftrace_trace_arrays, list) {
-		if (tr == &global_trace)
+		if (!tr->allocated_snapshot)
 			continue;
-		trace_array_puts(tr, "** Boot snapshot taken **\n");
+
 		tracing_snapshot_instance(tr);
+		trace_array_puts(tr, "** Boot snapshot taken **\n");
 	}
+#endif
 }
 
 void __init early_trace_init(void)
-- 
2.39.2
