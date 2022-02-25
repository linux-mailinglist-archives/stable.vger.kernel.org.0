Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01B394C4B5B
	for <lists+stable@lfdr.de>; Fri, 25 Feb 2022 17:52:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231774AbiBYQxR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Feb 2022 11:53:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242788AbiBYQwx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Feb 2022 11:52:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E1271AF0E;
        Fri, 25 Feb 2022 08:52:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2226161CF2;
        Fri, 25 Feb 2022 16:52:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80642C340F5;
        Fri, 25 Feb 2022 16:52:19 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@goodmis.org>)
        id 1nNdpK-00B8J8-J9;
        Fri, 25 Feb 2022 11:52:18 -0500
Message-ID: <20220225165218.424446548@goodmis.org>
User-Agent: quilt/0.66
Date:   Fri, 25 Feb 2022 11:51:53 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, Tom Zanussi <zanussi@kernel.org>,
        Daniel Bristot de Oliveira <bristot@kernel.org>
Subject: [for-linus][PATCH 02/13] tracing: Dump stacktrace trigger to the corresponding instance
References: <20220225165151.824659113@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Bristot de Oliveira <bristot@kernel.org>

The stacktrace event trigger is not dumping the stacktrace to the instance
where it was enabled, but to the global "instance."

Use the private_data, pointing to the trigger file, to figure out the
corresponding trace instance, and use it in the trigger action, like
snapshot_trigger does.

Link: https://lkml.kernel.org/r/afbb0b4f18ba92c276865bc97204d438473f4ebc.1645396236.git.bristot@kernel.org

Cc: stable@vger.kernel.org
Fixes: ae63b31e4d0e2 ("tracing: Separate out trace events from global variables")
Reviewed-by: Tom Zanussi <zanussi@kernel.org>
Tested-by: Tom Zanussi <zanussi@kernel.org>
Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 kernel/trace/trace_events_trigger.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace_events_trigger.c b/kernel/trace/trace_events_trigger.c
index d00fee705f9c..e0d50c9577f3 100644
--- a/kernel/trace/trace_events_trigger.c
+++ b/kernel/trace/trace_events_trigger.c
@@ -1540,7 +1540,12 @@ stacktrace_trigger(struct event_trigger_data *data,
 		   struct trace_buffer *buffer,  void *rec,
 		   struct ring_buffer_event *event)
 {
-	trace_dump_stack(STACK_SKIP);
+	struct trace_event_file *file = data->private_data;
+
+	if (file)
+		__trace_stack(file->tr, tracing_gen_ctx(), STACK_SKIP);
+	else
+		trace_dump_stack(STACK_SKIP);
 }
 
 static void
-- 
2.34.1
