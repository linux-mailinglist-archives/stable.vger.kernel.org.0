Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C92034C4B5D
	for <lists+stable@lfdr.de>; Fri, 25 Feb 2022 17:52:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243226AbiBYQxR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Feb 2022 11:53:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243183AbiBYQwy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Feb 2022 11:52:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4002223102;
        Fri, 25 Feb 2022 08:52:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6013B61CF5;
        Fri, 25 Feb 2022 16:52:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C35CEC340F6;
        Fri, 25 Feb 2022 16:52:19 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@goodmis.org>)
        id 1nNdpK-00B8Jg-Oz;
        Fri, 25 Feb 2022 11:52:18 -0500
Message-ID: <20220225165218.614031878@goodmis.org>
User-Agent: quilt/0.66
Date:   Fri, 25 Feb 2022 11:51:54 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tom Zanussi <zanussi@kernel.org>, stable@vger.kernel.org,
        Daniel Bristot de Oliveira <bristot@kernel.org>
Subject: [for-linus][PATCH 03/13] tracing: Have traceon and traceoff trigger honor the instance
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

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

If a trigger is set on an event to disable or enable tracing within an
instance, then tracing should be disabled or enabled in the instance and
not at the top level, which is confusing to users.

Link: https://lkml.kernel.org/r/20220223223837.14f94ec3@rorschach.local.home

Cc: Tom Zanussi <zanussi@kernel.org>
Cc: stable@vger.kernel.org
Fixes: ae63b31e4d0e2 ("tracing: Separate out trace events from global variables")
Tested-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 kernel/trace/trace_events_trigger.c | 52 +++++++++++++++++++++++++----
 1 file changed, 46 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace_events_trigger.c b/kernel/trace/trace_events_trigger.c
index e0d50c9577f3..efe563140f27 100644
--- a/kernel/trace/trace_events_trigger.c
+++ b/kernel/trace/trace_events_trigger.c
@@ -1295,6 +1295,16 @@ traceon_trigger(struct event_trigger_data *data,
 		struct trace_buffer *buffer, void *rec,
 		struct ring_buffer_event *event)
 {
+	struct trace_event_file *file = data->private_data;
+
+	if (file) {
+		if (tracer_tracing_is_on(file->tr))
+			return;
+
+		tracer_tracing_on(file->tr);
+		return;
+	}
+
 	if (tracing_is_on())
 		return;
 
@@ -1306,8 +1316,15 @@ traceon_count_trigger(struct event_trigger_data *data,
 		      struct trace_buffer *buffer, void *rec,
 		      struct ring_buffer_event *event)
 {
-	if (tracing_is_on())
-		return;
+	struct trace_event_file *file = data->private_data;
+
+	if (file) {
+		if (tracer_tracing_is_on(file->tr))
+			return;
+	} else {
+		if (tracing_is_on())
+			return;
+	}
 
 	if (!data->count)
 		return;
@@ -1315,7 +1332,10 @@ traceon_count_trigger(struct event_trigger_data *data,
 	if (data->count != -1)
 		(data->count)--;
 
-	tracing_on();
+	if (file)
+		tracer_tracing_on(file->tr);
+	else
+		tracing_on();
 }
 
 static void
@@ -1323,6 +1343,16 @@ traceoff_trigger(struct event_trigger_data *data,
 		 struct trace_buffer *buffer, void *rec,
 		 struct ring_buffer_event *event)
 {
+	struct trace_event_file *file = data->private_data;
+
+	if (file) {
+		if (!tracer_tracing_is_on(file->tr))
+			return;
+
+		tracer_tracing_off(file->tr);
+		return;
+	}
+
 	if (!tracing_is_on())
 		return;
 
@@ -1334,8 +1364,15 @@ traceoff_count_trigger(struct event_trigger_data *data,
 		       struct trace_buffer *buffer, void *rec,
 		       struct ring_buffer_event *event)
 {
-	if (!tracing_is_on())
-		return;
+	struct trace_event_file *file = data->private_data;
+
+	if (file) {
+		if (!tracer_tracing_is_on(file->tr))
+			return;
+	} else {
+		if (!tracing_is_on())
+			return;
+	}
 
 	if (!data->count)
 		return;
@@ -1343,7 +1380,10 @@ traceoff_count_trigger(struct event_trigger_data *data,
 	if (data->count != -1)
 		(data->count)--;
 
-	tracing_off();
+	if (file)
+		tracer_tracing_off(file->tr);
+	else
+		tracing_off();
 }
 
 static int
-- 
2.34.1
