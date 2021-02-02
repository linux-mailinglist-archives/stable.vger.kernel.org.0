Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9FAF30CE5D
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 23:04:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234438AbhBBWCw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 17:02:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:58594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234194AbhBBWCC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 17:02:02 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20B0F64E49;
        Tue,  2 Feb 2021 22:01:22 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1l73jd-0096ys-43; Tue, 02 Feb 2021 17:01:21 -0500
Message-ID: <20210202220121.006816711@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 02 Feb 2021 16:59:51 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, Viktor Rosendahl <Viktor.Rosendahl@bmw.de>
Subject: [for-linus][PATCH 2/5] tracing: Use pause-on-trace with the latency tracers
References: <20210202215949.848582355@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Viktor Rosendahl <Viktor.Rosendahl@bmw.de>

Eaerlier, tracing was disabled when reading the trace file. This behavior
was changed with:

commit 06e0a548bad0 ("tracing: Do not disable tracing when reading the
trace file").

This doesn't seem to work with the latency tracers.

The above mentioned commit dit not only change the behavior but also added
an option to emulate the old behavior. The idea with this patch is to
enable this pause-on-trace option when the latency tracers are used.

Link: https://lkml.kernel.org/r/20210119164344.37500-2-Viktor.Rosendahl@bmw.de

Cc: stable@vger.kernel.org
Fixes: 06e0a548bad0 ("tracing: Do not disable tracing when reading the trace file")
Signed-off-by: Viktor Rosendahl <Viktor.Rosendahl@bmw.de>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/trace/trace_irqsoff.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index d06aab4dcbb8..6756379b661f 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -562,6 +562,8 @@ static int __irqsoff_tracer_init(struct trace_array *tr)
 	/* non overwrite screws up the latency tracers */
 	set_tracer_flag(tr, TRACE_ITER_OVERWRITE, 1);
 	set_tracer_flag(tr, TRACE_ITER_LATENCY_FMT, 1);
+	/* without pause, we will produce garbage if another latency occurs */
+	set_tracer_flag(tr, TRACE_ITER_PAUSE_ON_TRACE, 1);
 
 	tr->max_latency = 0;
 	irqsoff_trace = tr;
@@ -583,11 +585,13 @@ static void __irqsoff_tracer_reset(struct trace_array *tr)
 {
 	int lat_flag = save_flags & TRACE_ITER_LATENCY_FMT;
 	int overwrite_flag = save_flags & TRACE_ITER_OVERWRITE;
+	int pause_flag = save_flags & TRACE_ITER_PAUSE_ON_TRACE;
 
 	stop_irqsoff_tracer(tr, is_graph(tr));
 
 	set_tracer_flag(tr, TRACE_ITER_LATENCY_FMT, lat_flag);
 	set_tracer_flag(tr, TRACE_ITER_OVERWRITE, overwrite_flag);
+	set_tracer_flag(tr, TRACE_ITER_PAUSE_ON_TRACE, pause_flag);
 	ftrace_reset_array_ops(tr);
 
 	irqsoff_busy = false;
-- 
2.29.2


