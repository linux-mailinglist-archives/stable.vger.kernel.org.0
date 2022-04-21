Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D950509439
	for <lists+stable@lfdr.de>; Thu, 21 Apr 2022 02:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357479AbiDUAjD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Apr 2022 20:39:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234346AbiDUAjD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Apr 2022 20:39:03 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFE9B1FCDA
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 17:36:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2EF3FCE2019
        for <stable@vger.kernel.org>; Thu, 21 Apr 2022 00:36:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8130C385A0;
        Thu, 21 Apr 2022 00:36:10 +0000 (UTC)
Date:   Wed, 20 Apr 2022 20:36:09 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <gregkh@linuxfoundation.org>
Cc:     bristot@kernel.org, zanussi@kernel.org, <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] tracing: Dump stacktrace trigger to the
 corresponding" failed to apply to 4.14-stable tree
Message-ID: <20220420203609.3bd98d39@gandalf.local.home>
In-Reply-To: <1646033429886@kroah.com>
References: <1646033429886@kroah.com>
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

On Mon, 28 Feb 2022 08:30:29 +0100
<gregkh@linuxfoundation.org> wrote:

> The patch below does not apply to the 4.14-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
>

The following should work for 4.14. Again, 4.9 and earlier requires a lot
more work than I have time for.

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
--- linux-test.git.orig/kernel/trace/trace_events_trigger.c	2022-04-20 19:03:45.329706898 -0400
+++ linux-test.git/kernel/trace/trace_events_trigger.c	2022-04-20 19:05:35.323694306 -0400
@@ -1156,7 +1156,14 @@ static __init int register_trigger_snaps
 static void
 stacktrace_trigger(struct event_trigger_data *data, void *rec)
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
