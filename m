Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 222FC50F400
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244347AbiDZIb0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:31:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344870AbiDZI3Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:29:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 328D26D3B3;
        Tue, 26 Apr 2022 01:24:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0709361778;
        Tue, 26 Apr 2022 08:24:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A076C385AE;
        Tue, 26 Apr 2022 08:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650961486;
        bh=KhnqbTI40bcgc+gv8MN7+miV4cr/0b8bQdQ739nQbUw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y3QKlu19lenvs9DjfBcCCNB9UKXNvCT/+bpiaJUEHtiwQ/KitZeeib8DR5yNzLSHr
         eqchgDvHIzsngaAO5hh0kBAmQk2twhwHa7jKTI6KTB60VAbexrV9ysUMkHZtZFtyIk
         sHgdJYTSYGxRrcbA6qAJ6bSCIeeXJbbB5XMKilTw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        Tom Zanussi <zanussi@kernel.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 4.14 03/43] tracing: Have traceon and traceoff trigger honor the instance
Date:   Tue, 26 Apr 2022 10:20:45 +0200
Message-Id: <20220426081734.615461663@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081734.509314186@linuxfoundation.org>
References: <20220426081734.509314186@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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


