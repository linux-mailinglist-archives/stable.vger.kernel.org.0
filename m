Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94406508E5C
	for <lists+stable@lfdr.de>; Wed, 20 Apr 2022 19:24:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356052AbiDTR1T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Apr 2022 13:27:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243846AbiDTR1S (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Apr 2022 13:27:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57F5E45065
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 10:24:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 196D5B81E61
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 17:24:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AFD4C385A0;
        Wed, 20 Apr 2022 17:24:28 +0000 (UTC)
Date:   Wed, 20 Apr 2022 13:24:26 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <gregkh@linuxfoundation.org>
Cc:     bristot@kernel.org, zanussi@kernel.org, <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] tracing: Have traceon and traceoff
 trigger honor the instance" failed to apply to 4.14-stable tree
Message-ID: <20220420132426.46ef21f1@gandalf.local.home>
In-Reply-To: <1646029977161194@kroah.com>
References: <1646029977161194@kroah.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 28 Feb 2022 07:32:57 +0100
<gregkh@linuxfoundation.org> wrote:

> The patch below does not apply to the 4.14-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h
> 

This should work for 4.14 (I tested it for one machine).

-- Steve


>From 302e9edd54985f584cfc180098f3554774126969 Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Date: Wed, 23 Feb 2022 22:38:37 -0500
Subject: [PATCH] tracing: Have traceon and traceoff trigger honor the instance

If a trigger is set on an event to disable or enable tracing within an
instance, then tracing should be disabled or enabled in the instance and
not at the top level, which is confusing to users.

Link: https://lkml.kernel.org/r/20220223223837.14f94ec3@rorschach.local.home

Cc: stable@vger.kernel.org
Fixes: ae63b31e4d0e2 ("tracing: Separate out trace events from global variables")
Tested-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Reviewed-by: Tom Zanussi <zanussi@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>

---
 kernel/trace/trace_events_trigger.c |   52 +++++++++++++++++++++++++++++++-----
 1 file changed, 46 insertions(+), 6 deletions(-)

Index: linux-test.git/kernel/trace/trace_events_trigger.c
===================================================================
--- linux-test.git.orig/kernel/trace/trace_events_trigger.c	2022-04-20 12:03:32.899882747 -0400
+++ linux-test.git/kernel/trace/trace_events_trigger.c	2022-04-20 12:06:00.769445281 -0400
@@ -932,6 +932,16 @@ void set_named_trigger_data(struct event
 static void
 traceon_trigger(struct event_trigger_data *data, void *rec)
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
 
@@ -941,8 +951,15 @@ traceon_trigger(struct event_trigger_dat
 static void
 traceon_count_trigger(struct event_trigger_data *data, void *rec)
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
@@ -950,12 +967,25 @@ traceon_count_trigger(struct event_trigg
 	if (data->count != -1)
 		(data->count)--;
 
-	tracing_on();
+	if (file)
+		tracer_tracing_on(file->tr);
+	else
+		tracing_on();
 }
 
 static void
 traceoff_trigger(struct event_trigger_data *data, void *rec)
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
 
@@ -965,8 +995,15 @@ traceoff_trigger(struct event_trigger_da
 static void
 traceoff_count_trigger(struct event_trigger_data *data, void *rec)
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
@@ -974,7 +1011,10 @@ traceoff_count_trigger(struct event_trig
 	if (data->count != -1)
 		(data->count)--;
 
-	tracing_off();
+	if (file)
+		tracer_tracing_off(file->tr);
+	else
+		tracing_off();
 }
 
 static int
