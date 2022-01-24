Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 294C1497897
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 06:35:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241094AbiAXFfZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 00:35:25 -0500
Received: from relay.sw.ru ([185.231.240.75]:40866 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229623AbiAXFfY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jan 2022 00:35:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=MIME-Version:Message-Id:Date:Subject:From:
        Content-Type; bh=mCdoqK58TSX7WoJa1ICg1sKUn9VUYBc0HMM9qwx04Fs=; b=DW1QxRRqv3Gf
        DBBIF7PdePwQIZ/AgF4w+YXJhC9SMRsjePFVG3Heq0dMRRnlXLTEpEMlK3v4F13To9YQ88bGOK23j
        jOi9cIZWRQaRGOhLXyYWRpsD84cRhPasiA4q3VxZDJL468U8IQdWVlkMZupfNbwMwI+02oa7+jw+k
        3Da8w=;
Received: from [192.168.15.98] (helo=cobook.home)
        by relay.sw.ru with esmtp (Exim 4.94.2)
        (envelope-from <nikita.yushchenko@virtuozzo.com>)
        id 1nBs0R-007XYa-0g; Mon, 24 Jan 2022 08:35:07 +0300
From:   Nikita Yushchenko <nikita.yushchenko@virtuozzo.com>
To:     gregkh@linuxfoundation.org, bristot@kernel.org, rostedt@goodmis.org
Cc:     stable@vger.kernel.org
Subject: [PATCH 5.15.y] tracing/osnoise: Properly unhook events if start_per_cpu_kthreads() fails
Date:   Mon, 24 Jan 2022 08:33:57 +0300
Message-Id: <20220124053356.495768-1-nikita.yushchenko@virtuozzo.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <1642956398125157@kroah.com>
References: <1642956398125157@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 0878355b51f5f26632e652c848a8e174bb02d22d upstream.

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
index c4f14fb98aaa..65a518649997 100644
--- a/kernel/trace/trace_osnoise.c
+++ b/kernel/trace/trace_osnoise.c
@@ -1932,6 +1932,13 @@ static int osnoise_hook_events(void)
 	return -EINVAL;
 }
 
+static void osnoise_unhook_events(void)
+{
+	unhook_thread_events();
+	unhook_softirq_events();
+	unhook_irq_events();
+}
+
 static int __osnoise_tracer_start(struct trace_array *tr)
 {
 	int retval;
@@ -1949,7 +1956,14 @@ static int __osnoise_tracer_start(struct trace_array *tr)
 
 	retval = start_per_cpu_kthreads(tr);
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
 
@@ -1981,9 +1995,7 @@ static void osnoise_tracer_stop(struct trace_array *tr)
 
 	stop_per_cpu_kthreads();
 
-	unhook_irq_events();
-	unhook_softirq_events();
-	unhook_thread_events();
+	osnoise_unhook_events();
 
 	osnoise_busy = false;
 }
-- 
2.30.2

