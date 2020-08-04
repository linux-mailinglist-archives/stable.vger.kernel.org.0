Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C67223C10F
	for <lists+stable@lfdr.de>; Tue,  4 Aug 2020 22:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728133AbgHDU6Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Aug 2020 16:58:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:41884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728057AbgHDU6N (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Aug 2020 16:58:13 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9538522CB1;
        Tue,  4 Aug 2020 20:58:13 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.93)
        (envelope-from <rostedt@goodmis.org>)
        id 1k340i-006HAs-Jt; Tue, 04 Aug 2020 16:58:12 -0400
Message-ID: <20200804205812.490385897@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 04 Aug 2020 16:57:47 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, stable@vger.kernel.org,
        Kevin Hao <haokexin@gmail.com>
Subject: [for-linus][PATCH 04/17] tracing/hwlat: Honor the tracing_cpumask
References: <20200804205743.419135730@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kevin Hao <haokexin@gmail.com>

In calculation of the cpu mask for the hwlat kernel thread, the wrong
cpu mask is used instead of the tracing_cpumask, this causes the
tracing/tracing_cpumask useless for hwlat tracer. Fixes it.

Link: https://lkml.kernel.org/r/20200730082318.42584-2-haokexin@gmail.com

Cc: Ingo Molnar <mingo@redhat.com>
Cc: stable@vger.kernel.org
Fixes: 0330f7aa8ee6 ("tracing: Have hwlat trace migrate across tracing_cpumask CPUs")
Signed-off-by: Kevin Hao <haokexin@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/trace/trace_hwlat.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_hwlat.c b/kernel/trace/trace_hwlat.c
index ddb528a6cd51..17873e5d0353 100644
--- a/kernel/trace/trace_hwlat.c
+++ b/kernel/trace/trace_hwlat.c
@@ -283,6 +283,7 @@ static bool disable_migrate;
 static void move_to_next_cpu(void)
 {
 	struct cpumask *current_mask = &save_cpumask;
+	struct trace_array *tr = hwlat_trace;
 	int next_cpu;
 
 	if (disable_migrate)
@@ -296,7 +297,7 @@ static void move_to_next_cpu(void)
 		goto disable;
 
 	get_online_cpus();
-	cpumask_and(current_mask, cpu_online_mask, tracing_buffer_mask);
+	cpumask_and(current_mask, cpu_online_mask, tr->tracing_cpumask);
 	next_cpu = cpumask_next(smp_processor_id(), current_mask);
 	put_online_cpus();
 
@@ -372,7 +373,7 @@ static int start_kthread(struct trace_array *tr)
 
 	/* Just pick the first CPU on first iteration */
 	get_online_cpus();
-	cpumask_and(current_mask, cpu_online_mask, tracing_buffer_mask);
+	cpumask_and(current_mask, cpu_online_mask, tr->tracing_cpumask);
 	put_online_cpus();
 	next_cpu = cpumask_first(current_mask);
 
-- 
2.26.2


