Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4317C4C756E
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:54:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239109AbiB1Ry6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:54:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239485AbiB1RxG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:53:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3723BA9978;
        Mon, 28 Feb 2022 09:40:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B818061543;
        Mon, 28 Feb 2022 17:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C831FC340E7;
        Mon, 28 Feb 2022 17:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070014;
        bh=KCalSnuWuzSfa+L8A6ehOYwa/W3kEiG0HRBRIYFecX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0tKl54OVVQQ+I+hm4rlOJ1MMebA1p+iMwtN5H9UbhS+P4pNKWFDo8mBycLb/U9Bly
         kY2XahJoKBc+DjIXp6Opb8z7f9kQO7YISG6vE5ywWUYSLxDbAYjB3Dlp8fDtUuaz+l
         FRt138ozvY15dIBpVT8+wOS9cD8ZKCJZLufh0Q4Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        Tom Zanussi <zanussi@kernel.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.15 095/139] tracing: Have traceon and traceoff trigger honor the instance
Date:   Mon, 28 Feb 2022 18:24:29 +0100
Message-Id: <20220228172357.590999187@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172347.614588246@linuxfoundation.org>
References: <20220228172347.614588246@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (Google) <rostedt@goodmis.org>

commit 302e9edd54985f584cfc180098f3554774126969 upstream.

If a trigger is set on an event to disable or enable tracing within an
instance, then tracing should be disabled or enabled in the instance and
not at the top level, which is confusing to users.

Link: https://lkml.kernel.org/r/20220223223837.14f94ec3@rorschach.local.home

Cc: stable@vger.kernel.org
Fixes: ae63b31e4d0e2 ("tracing: Separate out trace events from global variables")
Tested-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Reviewed-by: Tom Zanussi <zanussi@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_trigger.c |   52 +++++++++++++++++++++++++++++++-----
 1 file changed, 46 insertions(+), 6 deletions(-)

--- a/kernel/trace/trace_events_trigger.c
+++ b/kernel/trace/trace_events_trigger.c
@@ -955,6 +955,16 @@ traceon_trigger(struct event_trigger_dat
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
 
@@ -966,8 +976,15 @@ traceon_count_trigger(struct event_trigg
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
@@ -975,7 +992,10 @@ traceon_count_trigger(struct event_trigg
 	if (data->count != -1)
 		(data->count)--;
 
-	tracing_on();
+	if (file)
+		tracer_tracing_on(file->tr);
+	else
+		tracing_on();
 }
 
 static void
@@ -983,6 +1003,16 @@ traceoff_trigger(struct event_trigger_da
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
 
@@ -994,8 +1024,15 @@ traceoff_count_trigger(struct event_trig
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
@@ -1003,7 +1040,10 @@ traceoff_count_trigger(struct event_trig
 	if (data->count != -1)
 		(data->count)--;
 
-	tracing_off();
+	if (file)
+		tracer_tracing_off(file->tr);
+	else
+		tracing_off();
 }
 
 static int


