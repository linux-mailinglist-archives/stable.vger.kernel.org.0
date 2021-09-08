Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A754403FB2
	for <lists+stable@lfdr.de>; Wed,  8 Sep 2021 21:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349847AbhIHTVZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Sep 2021 15:21:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:33788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232168AbhIHTVZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Sep 2021 15:21:25 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 791AF61102;
        Wed,  8 Sep 2021 19:20:17 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@goodmis.org>)
        id 1mO36v-0014Xv-RK; Wed, 08 Sep 2021 15:19:53 -0400
Message-ID: <20210908191953.686120093@goodmis.org>
User-Agent: quilt/0.66
Date:   Wed, 08 Sep 2021 15:18:54 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        <stable@vger.kernel.org>,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        "Qiang.Zhang" <qiang.zhang@windriver.com>
Subject: [for-next][PATCH 03/12] tracing/osnoise: Fix missed cpus_read_unlock() in
 start_per_cpu_kthreads()
References: <20210908191851.381347939@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Qiang.Zhang" <qiang.zhang@windriver.com>

When start_kthread() return error, the cpus_read_unlock() need
to be called.

Link: https://lkml.kernel.org/r/20210831022919.27630-1-qiang.zhang@windriver.com

Cc: <stable@vger.kernel.org>
Fixes: c8895e271f79 ("trace/osnoise: Support hotplug operations")
Acked-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Signed-off-by: Qiang.Zhang <qiang.zhang@windriver.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/trace/trace_osnoise.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace_osnoise.c b/kernel/trace/trace_osnoise.c
index 65b08b8e5bf8..ce053619f289 100644
--- a/kernel/trace/trace_osnoise.c
+++ b/kernel/trace/trace_osnoise.c
@@ -1548,7 +1548,7 @@ static int start_kthread(unsigned int cpu)
 static int start_per_cpu_kthreads(struct trace_array *tr)
 {
 	struct cpumask *current_mask = &save_cpumask;
-	int retval;
+	int retval = 0;
 	int cpu;
 
 	cpus_read_lock();
@@ -1568,13 +1568,13 @@ static int start_per_cpu_kthreads(struct trace_array *tr)
 		retval = start_kthread(cpu);
 		if (retval) {
 			stop_per_cpu_kthreads();
-			return retval;
+			break;
 		}
 	}
 
 	cpus_read_unlock();
 
-	return 0;
+	return retval;
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
-- 
2.32.0
