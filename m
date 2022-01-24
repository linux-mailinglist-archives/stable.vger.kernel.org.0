Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2DC849954A
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:09:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392532AbiAXUv0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:51:26 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:45552 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390766AbiAXUqP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:46:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 50570B81253;
        Mon, 24 Jan 2022 20:46:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E3A6C340E5;
        Mon, 24 Jan 2022 20:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057173;
        bh=KIekPdyAAYx3DbDY5ShyO0Q26/ob9MmYZs4wsnImTk4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rfst4mgoUSB9MsSamVS4isg8KF3JyaoXL6xwaPf3O782uhS79J8EuMcYOoqp7M1bq
         4hzXHDfsbdFWlRWvSo13pcmZrSxl6clGCseIB4TmMQy7IcBcBBwZIEIMSj93WMt9E2
         ZUPjdjSoKAArmBQ2jbBSa+PuWvyfKNUQ/Cr4WxrQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        Nikita Yushchenko <nikita.yushchenko@virtuozzo.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 5.15 726/846] tracing/osnoise: Properly unhook events if start_per_cpu_kthreads() fails
Date:   Mon, 24 Jan 2022 19:44:03 +0100
Message-Id: <20220124184126.052371237@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikita Yushchenko <nikita.yushchenko@virtuozzo.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_osnoise.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

--- a/kernel/trace/trace_osnoise.c
+++ b/kernel/trace/trace_osnoise.c
@@ -1932,6 +1932,13 @@ out_unhook_irq:
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
@@ -1949,7 +1956,14 @@ static int __osnoise_tracer_start(struct
 
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
 
@@ -1981,9 +1995,7 @@ static void osnoise_tracer_stop(struct t
 
 	stop_per_cpu_kthreads();
 
-	unhook_irq_events();
-	unhook_softirq_events();
-	unhook_thread_events();
+	osnoise_unhook_events();
 
 	osnoise_busy = false;
 }


