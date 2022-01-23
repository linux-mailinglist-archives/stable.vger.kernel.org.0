Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDB08497318
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 17:46:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238853AbiAWQqp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jan 2022 11:46:45 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:35676 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232833AbiAWQqo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jan 2022 11:46:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EC1BFCE0EDC
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 16:46:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABD19C340E5;
        Sun, 23 Jan 2022 16:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642956401;
        bh=JILAxxZOINnT0uthY4XMvg6N8DhAOMoy9k8idVndY7E=;
        h=Subject:To:Cc:From:Date:From;
        b=r+vls/FGxMmmXRFV/+bcr+3Hv4sysxcmBkVz6MGVQ/B/r2Evl7CxXFl5CMhi+ILA/
         Pk5CYZnqgjmYSpKDKji/Lz9CpD33DESIYXrnjG4HBlpLbNR/X6Q/4z/THLDQPpchHY
         nLOsdgQKRP9DfogCGqonWWceUBsn8V2TUBbVY2t8=
Subject: FAILED: patch "[PATCH] tracing/osnoise: Properly unhook events if" failed to apply to 5.15-stable tree
To:     nikita.yushchenko@virtuozzo.com, bristot@kernel.org,
        rostedt@goodmis.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Jan 2022 17:46:38 +0100
Message-ID: <1642956398125157@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 0878355b51f5f26632e652c848a8e174bb02d22d Mon Sep 17 00:00:00 2001
From: Nikita Yushchenko <nikita.yushchenko@virtuozzo.com>
Date: Sun, 9 Jan 2022 18:34:59 +0300
Subject: [PATCH] tracing/osnoise: Properly unhook events if
 start_per_cpu_kthreads() fails

If start_per_cpu_kthreads() called from osnoise_workload_start() returns
error, event hooks are left in broken state: unhook_irq_events() called
but unhook_thread_events() and unhook_softirq_events() not called, and
trace_osnoise_callback_enabled flag not cleared.

On the next tracer enable, hooks get not installed due to
trace_osnoise_callback_enabled flag.

And on the further tracer disable an attempt to remove non-installed
hooks happened, hitting a WARN_ON_ONCE() in tracepoint_remove_func().

Fix the error path by adding the missing part of cleanup.
While at this, introduce osnoise_unhook_events() to avoid code
duplication between this error path and normal tracer disable.

Link: https://lkml.kernel.org/r/20220109153459.3701773-1-nikita.yushchenko@virtuozzo.com

Cc: stable@vger.kernel.org
Fixes: bce29ac9ce0b ("trace: Add osnoise tracer")
Acked-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Signed-off-by: Nikita Yushchenko <nikita.yushchenko@virtuozzo.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/trace/trace_osnoise.c b/kernel/trace/trace_osnoise.c
index 4719a848bf17..36d9d5be08b4 100644
--- a/kernel/trace/trace_osnoise.c
+++ b/kernel/trace/trace_osnoise.c
@@ -2122,6 +2122,13 @@ static int osnoise_hook_events(void)
 	return -EINVAL;
 }
 
+static void osnoise_unhook_events(void)
+{
+	unhook_thread_events();
+	unhook_softirq_events();
+	unhook_irq_events();
+}
+
 /*
  * osnoise_workload_start - start the workload and hook to events
  */
@@ -2154,7 +2161,14 @@ static int osnoise_workload_start(void)
 
 	retval = start_per_cpu_kthreads();
 	if (retval) {
-		unhook_irq_events();
+		trace_osnoise_callback_enabled = false;
+		/*
+		 * Make sure that ftrace_nmi_enter/exit() see
+		 * trace_osnoise_callback_enabled as false before continuing.
+		 */
+		barrier();
+
+		osnoise_unhook_events();
 		return retval;
 	}
 
@@ -2185,9 +2199,7 @@ static void osnoise_workload_stop(void)
 
 	stop_per_cpu_kthreads();
 
-	unhook_irq_events();
-	unhook_softirq_events();
-	unhook_thread_events();
+	osnoise_unhook_events();
 }
 
 static void osnoise_tracer_start(struct trace_array *tr)

