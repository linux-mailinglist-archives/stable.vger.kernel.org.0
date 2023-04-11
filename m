Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 047AE6DD960
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 13:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbjDKL15 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 07:27:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjDKL14 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 07:27:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E90103AAB
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 04:27:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 83BA061CCC
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 11:27:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98C96C433D2;
        Tue, 11 Apr 2023 11:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681212474;
        bh=NOiVs5A4M94fB7pw+0ecdPF6pxMRser1lOftJCx3sXo=;
        h=Subject:To:Cc:From:Date:From;
        b=T9IqNQaXStfN5MJWVXG8cZqgbUnYkqzZDHiBlBfF3Up2wsMp13GgVrKTrDHSRKnm2
         0Y/lTn0ofal9K9oSseUDyTa6vskznubdm8zRJOOke1eMmAb1C1syNoMABnfl3HWa2b
         uWQKzLw1Kj4HnYAbNYKqu4mpHsIX04b221EKWM5s=
Subject: FAILED: patch "[PATCH] tracing: Have tracing_snapshot_instance_cond() write errors" failed to apply to 4.14-stable tree
To:     rostedt@goodmis.org, akpm@linux-foundation.org,
        mark.rutland@arm.com, mhiramat@kernel.org, zwisler@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 11 Apr 2023 13:27:41 +0200
Message-ID: <2023041141-footsore-nanny-d8c6@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-4.14.y
git checkout FETCH_HEAD
git cherry-pick -x 9d52727f8043cfda241ae96896628d92fa9c50bb
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '2023041141-footsore-nanny-d8c6@gregkh' --subject-prefix 'PATCH 4.14.y' HEAD^..

Possible dependencies:

9d52727f8043 ("tracing: Have tracing_snapshot_instance_cond() write errors to the appropriate instance")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 9d52727f8043cfda241ae96896628d92fa9c50bb Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Date: Tue, 4 Apr 2023 22:21:14 -0400
Subject: [PATCH] tracing: Have tracing_snapshot_instance_cond() write errors
 to the appropriate instance

If a trace instance has a failure with its snapshot code, the error
message is to be written to that instance's buffer. But currently, the
message is written to the top level buffer. Worse yet, it may also disable
the top level buffer and not the instance that had the issue.

Link: https://lkml.kernel.org/r/20230405022341.688730321@goodmis.org

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ross Zwisler <zwisler@google.com>
Fixes: 2824f50332486 ("tracing: Make the snapshot trigger work with instances")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 937e9676dfd4..ed1d1093f5e9 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1149,22 +1149,22 @@ static void tracing_snapshot_instance_cond(struct trace_array *tr,
 	unsigned long flags;
 
 	if (in_nmi()) {
-		internal_trace_puts("*** SNAPSHOT CALLED FROM NMI CONTEXT ***\n");
-		internal_trace_puts("*** snapshot is being ignored        ***\n");
+		trace_array_puts(tr, "*** SNAPSHOT CALLED FROM NMI CONTEXT ***\n");
+		trace_array_puts(tr, "*** snapshot is being ignored        ***\n");
 		return;
 	}
 
 	if (!tr->allocated_snapshot) {
-		internal_trace_puts("*** SNAPSHOT NOT ALLOCATED ***\n");
-		internal_trace_puts("*** stopping trace here!   ***\n");
-		tracing_off();
+		trace_array_puts(tr, "*** SNAPSHOT NOT ALLOCATED ***\n");
+		trace_array_puts(tr, "*** stopping trace here!   ***\n");
+		tracer_tracing_off(tr);
 		return;
 	}
 
 	/* Note, snapshot can not be used when the tracer uses it */
 	if (tracer->use_max_tr) {
-		internal_trace_puts("*** LATENCY TRACER ACTIVE ***\n");
-		internal_trace_puts("*** Can not use snapshot (sorry) ***\n");
+		trace_array_puts(tr, "*** LATENCY TRACER ACTIVE ***\n");
+		trace_array_puts(tr, "*** Can not use snapshot (sorry) ***\n");
 		return;
 	}
 

