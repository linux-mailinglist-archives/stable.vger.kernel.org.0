Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B01C62D0479
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 12:52:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729579AbgLFLp5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 06:45:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:45264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729572AbgLFLps (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Dec 2020 06:45:48 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Vasily Averin <vvs@virtuozzo.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.9 44/46] tracing: Remove WARN_ON in start_thread()
Date:   Sun,  6 Dec 2020 12:17:52 +0100
Message-Id: <20201206111558.584406523@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201206111556.455533723@linuxfoundation.org>
References: <20201206111556.455533723@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>

commit 310e3a4b5a4fc718a72201c1e4cf5c64ac6f5442 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/trace_hwlat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/trace_hwlat.c
+++ b/kernel/trace/trace_hwlat.c
@@ -368,7 +368,7 @@ static int start_kthread(struct trace_ar
 	struct task_struct *kthread;
 	int next_cpu;
 
-	if (WARN_ON(hwlat_kthread))
+	if (hwlat_kthread)
 		return 0;
 
 	/* Just pick the first CPU on first iteration */


