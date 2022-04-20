Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3145A509353
	for <lists+stable@lfdr.de>; Thu, 21 Apr 2022 01:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383064AbiDTXHl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Apr 2022 19:07:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383099AbiDTXHg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Apr 2022 19:07:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E14AD2FF
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 16:04:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8477D61ACA
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 23:04:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52069C385A1;
        Wed, 20 Apr 2022 23:04:47 +0000 (UTC)
Date:   Wed, 20 Apr 2022 19:04:45 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <gregkh@linuxfoundation.org>
Cc:     bristot@kernel.org, zanussi@kernel.org, <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] tracing: Dump stacktrace trigger to the
 corresponding" failed to apply to 5.10-stable tree
Message-ID: <20220420190445.51a8c9a0@gandalf.local.home>
In-Reply-To: <164603350939149@kroah.com>
References: <164603350939149@kroah.com>
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

On Mon, 28 Feb 2022 08:31:49 +0100
<gregkh@linuxfoundation.org> wrote:

> The patch below does not apply to the 5.10-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 

The below should work for 5.10 back through 4.19.

-- Steve


>From ce33c845b030c9cf768370c951bc699470b09fa7 Mon Sep 17 00:00:00 2001
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

---
 kernel/trace/trace_events_trigger.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

Index: linux-test.git/kernel/trace/trace_events_trigger.c
===================================================================
--- linux-test.git.orig/kernel/trace/trace_events_trigger.c	2022-04-20 14:37:15.087171720 -0400
+++ linux-test.git/kernel/trace/trace_events_trigger.c	2022-04-20 16:14:56.316913633 -0400
@@ -1219,7 +1219,14 @@ static void
 stacktrace_trigger(struct event_trigger_data *data, void *rec,
 		   struct ring_buffer_event *event)
 {
-	trace_dump_stack(STACK_SKIP);
+	struct trace_event_file *file = data->private_data;
+	unsigned long flags;
+
+	if (file) {
+		local_save_flags(flags);
+		__trace_stack(file->tr, flags, STACK_SKIP, preempt_count());
+	} else
+		trace_dump_stack(STACK_SKIP);
 }
 
 static void
