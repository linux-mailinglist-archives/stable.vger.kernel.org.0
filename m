Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7275748B3EF
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 18:31:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344544AbiAKRbb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jan 2022 12:31:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344428AbiAKRbX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jan 2022 12:31:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 936F6C061201;
        Tue, 11 Jan 2022 09:31:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36C62B81C3B;
        Tue, 11 Jan 2022 17:31:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E789EC36AF3;
        Tue, 11 Jan 2022 17:31:19 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@goodmis.org>)
        id 1n7KzP-0032Ln-47;
        Tue, 11 Jan 2022 12:31:19 -0500
Message-ID: <20220111173118.961361869@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 11 Jan 2022 12:31:02 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        Nikita Yushchenko <nikita.yushchenko@virtuozzo.com>
Subject: [for-next][PATCH 31/31] tracing/osnoise: Properly unhook events if start_per_cpu_kthreads()
 fails
References: <20220111173030.999527342@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikita Yushchenko <nikita.yushchenko@virtuozzo.com>

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
---
 kernel/trace/trace_osnoise.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

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
-- 
2.33.0
