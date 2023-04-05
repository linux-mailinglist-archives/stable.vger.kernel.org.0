Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AC616D7F61
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 16:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238483AbjDEO1M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 10:27:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238496AbjDEO1J (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 10:27:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16A84E7B;
        Wed,  5 Apr 2023 07:26:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 95592625AC;
        Wed,  5 Apr 2023 14:26:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D56DC433A0;
        Wed,  5 Apr 2023 14:26:56 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
        (envelope-from <rostedt@goodmis.org>)
        id 1pk46A-000qk7-3D;
        Wed, 05 Apr 2023 10:26:55 -0400
Message-ID: <20230405142654.813714541@goodmis.org>
User-Agent: quilt/0.66
Date:   Wed, 05 Apr 2023 09:58:15 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, Ross Zwisler <zwisler@google.com>
Subject: [for-linus][PATCH 2/3] tracing: Fix ftrace_boot_snapshot command line logic
References: <20230405135813.735507007@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Spam-Status: No, score=-2.0 required=5.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
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

Link: https://lkml.kernel.org/r/20230405022341.895334039@goodmis.org

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ross Zwisler <zwisler@google.com>
Fixes: 9c1c251d670bc ("tracing: Allow boot instances to have snapshot buffers")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 kernel/trace/trace.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index ed1d1093f5e9..4686473b8497 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -10393,19 +10393,20 @@ __init static int tracer_alloc_buffers(void)
 
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
