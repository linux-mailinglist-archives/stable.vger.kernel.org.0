Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0284C4C63CE
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 08:30:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233630AbiB1HbM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 02:31:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233073AbiB1HbL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 02:31:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3B24220F7
        for <stable@vger.kernel.org>; Sun, 27 Feb 2022 23:30:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C6E461037
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 07:30:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32353C340E7;
        Mon, 28 Feb 2022 07:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646033432;
        bh=LgoI407bP25aiHc3pD6WrAMrdoH/AAY0lyGB6Q2zkeY=;
        h=Subject:To:Cc:From:Date:From;
        b=j4bV0X4aDK6TSWRvntG3eNfl4zuhoHtqExYZPm2qLPulBFkcJfvyYrokm4KVATP2V
         wIZzzsz5g4UQYo7SSnFZo2UrH1kMjxbCLonRGv4d4G4OYR2M3cSLNvIzoWgwaNP5rD
         rPg9NHd6QFhtfyj8zCvF5c7WZ6cIuMlf/qkL52bI=
Subject: FAILED: patch "[PATCH] tracing: Dump stacktrace trigger to the corresponding" failed to apply to 4.14-stable tree
To:     bristot@kernel.org, rostedt@goodmis.org, zanussi@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Feb 2022 08:30:29 +0100
Message-ID: <1646033429886@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ce33c845b030c9cf768370c951bc699470b09fa7 Mon Sep 17 00:00:00 2001
From: Daniel Bristot de Oliveira <bristot@kernel.org>
Date: Sun, 20 Feb 2022 23:49:57 +0100
Subject: [PATCH] tracing: Dump stacktrace trigger to the corresponding
 instance

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

