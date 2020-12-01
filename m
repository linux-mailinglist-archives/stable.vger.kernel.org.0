Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5F722CA7A5
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 17:05:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391998AbgLAQB2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 11:01:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:42706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391609AbgLAQB2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 11:01:28 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 688692222E;
        Tue,  1 Dec 2020 16:00:07 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kk84U-002R7w-AR; Tue, 01 Dec 2020 11:00:06 -0500
Message-ID: <20201201160006.206022360@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 01 Dec 2020 10:58:43 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, stable@vger.kernel.org,
        Vasily Averin <vvs@virtuozzo.com>
Subject: [for-linus][PATCH 08/12] tracing: Remove WARN_ON in start_thread()
References: <20201201155835.647858317@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>

This patch reverts commit 978defee11a5 ("tracing: Do a WARN_ON()
 if start_thread() in hwlat is called when thread exists")

.start hook can be legally called several times if according
tracer is stopped

screen window 1
[root@localhost ~]# echo 1 > /sys/kernel/tracing/events/kmem/kfree/enable
[root@localhost ~]# echo 1 > /sys/kernel/tracing/options/pause-on-trace
[root@localhost ~]# less -F /sys/kernel/tracing/trace

screen window 2
[root@localhost ~]# cat /sys/kernel/debug/tracing/tracing_on
0
[root@localhost ~]# echo hwlat >  /sys/kernel/debug/tracing/current_tracer
[root@localhost ~]# echo 1 > /sys/kernel/debug/tracing/tracing_on
[root@localhost ~]# cat /sys/kernel/debug/tracing/tracing_on
0
[root@localhost ~]# echo 2 > /sys/kernel/debug/tracing/tracing_on

triggers warning in dmesg:
WARNING: CPU: 3 PID: 1403 at kernel/trace/trace_hwlat.c:371 hwlat_tracer_start+0xc9/0xd0

Link: https://lkml.kernel.org/r/bd4d3e70-400d-9c82-7b73-a2d695e86b58@virtuozzo.com

Cc: Ingo Molnar <mingo@redhat.com>
Cc: stable@vger.kernel.org
Fixes: 978defee11a5 ("tracing: Do a WARN_ON() if start_thread() in hwlat is called when thread exists")
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/trace/trace_hwlat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace_hwlat.c b/kernel/trace/trace_hwlat.c
index c9ad5c6fbaad..d071fc271eef 100644
--- a/kernel/trace/trace_hwlat.c
+++ b/kernel/trace/trace_hwlat.c
@@ -368,7 +368,7 @@ static int start_kthread(struct trace_array *tr)
 	struct task_struct *kthread;
 	int next_cpu;
 
-	if (WARN_ON(hwlat_kthread))
+	if (hwlat_kthread)
 		return 0;
 
 	/* Just pick the first CPU on first iteration */
-- 
2.28.0


