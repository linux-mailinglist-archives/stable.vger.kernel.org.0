Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF9B337C1F0
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:05:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232365AbhELPF4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:05:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:58780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233125AbhELPEg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:04:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 840B26142D;
        Wed, 12 May 2021 14:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831557;
        bh=n6xTy54zpTSL7hjKZsE59IEkKmz858ajsGfAnskWD38=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l0O6uU/W9chyWHdEdbHZo2UuIi2oC0nLCQO1AD9X2ouywzwW+N6FuG69h8UdsHqDW
         wyux8z1dnZw0hBf0uWcdp6h0NnAvCqOVivBGnYVkyyNEim7/GHkbYSdXIfuBzsESJF
         ObhKOMzInE45GPlPl17LFl8p45dJyA0UVlPj29dE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Waiman Long <longman@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 168/244] sched/debug: Fix cgroup_path[] serialization
Date:   Wed, 12 May 2021 16:48:59 +0200
Message-Id: <20210512144748.383970275@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
References: <20210512144743.039977287@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Waiman Long <longman@redhat.com>

[ Upstream commit ad789f84c9a145f8a18744c0387cec22ec51651e ]

The handling of sysrq key can be activated by echoing the key to
/proc/sysrq-trigger or via the magic key sequence typed into a terminal
that is connected to the system in some way (serial, USB or other mean).
In the former case, the handling is done in a user context. In the
latter case, it is likely to be in an interrupt context.

Currently in print_cpu() of kernel/sched/debug.c, sched_debug_lock is
taken with interrupt disabled for the whole duration of the calls to
print_*_stats() and print_rq() which could last for the quite some time
if the information dump happens on the serial console.

If the system has many cpus and the sched_debug_lock is somehow busy
(e.g. parallel sysrq-t), the system may hit a hard lockup panic
depending on the actually serial console implementation of the
system.

The purpose of sched_debug_lock is to serialize the use of the global
cgroup_path[] buffer in print_cpu(). The rests of the printk calls don't
need serialization from sched_debug_lock.

Calling printk() with interrupt disabled can still be problematic if
multiple instances are running. Allocating a stack buffer of PATH_MAX
bytes is not feasible because of the limited size of the kernel stack.

The solution implemented in this patch is to allow only one caller at a
time to use the full size group_path[], while other simultaneous callers
will have to use shorter stack buffers with the possibility of path
name truncation. A "..." suffix will be printed if truncation may have
happened.  The cgroup path name is provided for informational purpose
only, so occasional path name truncation should not be a big problem.

Fixes: efe25c2c7b3a ("sched: Reinstate group names in /proc/sched_debug")
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20210415195426.6677-1-longman@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/debug.c | 42 +++++++++++++++++++++++++++++-------------
 1 file changed, 29 insertions(+), 13 deletions(-)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index c4b702fe1d73..faada713cfae 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -8,8 +8,6 @@
  */
 #include "sched.h"
 
-static DEFINE_SPINLOCK(sched_debug_lock);
-
 /*
  * This allows printing both to /proc/sched_debug and
  * to the console
@@ -417,16 +415,37 @@ static void print_cfs_group_stats(struct seq_file *m, int cpu, struct task_group
 #endif
 
 #ifdef CONFIG_CGROUP_SCHED
+static DEFINE_SPINLOCK(sched_debug_lock);
 static char group_path[PATH_MAX];
 
-static char *task_group_path(struct task_group *tg)
+static void task_group_path(struct task_group *tg, char *path, int plen)
 {
-	if (autogroup_path(tg, group_path, PATH_MAX))
-		return group_path;
+	if (autogroup_path(tg, path, plen))
+		return;
 
-	cgroup_path(tg->css.cgroup, group_path, PATH_MAX);
+	cgroup_path(tg->css.cgroup, path, plen);
+}
 
-	return group_path;
+/*
+ * Only 1 SEQ_printf_task_group_path() caller can use the full length
+ * group_path[] for cgroup path. Other simultaneous callers will have
+ * to use a shorter stack buffer. A "..." suffix is appended at the end
+ * of the stack buffer so that it will show up in case the output length
+ * matches the given buffer size to indicate possible path name truncation.
+ */
+#define SEQ_printf_task_group_path(m, tg, fmt...)			\
+{									\
+	if (spin_trylock(&sched_debug_lock)) {				\
+		task_group_path(tg, group_path, sizeof(group_path));	\
+		SEQ_printf(m, fmt, group_path);				\
+		spin_unlock(&sched_debug_lock);				\
+	} else {							\
+		char buf[128];						\
+		char *bufend = buf + sizeof(buf) - 3;			\
+		task_group_path(tg, buf, bufend - buf);			\
+		strcpy(bufend - 1, "...");				\
+		SEQ_printf(m, fmt, buf);				\
+	}								\
 }
 #endif
 
@@ -453,7 +472,7 @@ print_task(struct seq_file *m, struct rq *rq, struct task_struct *p)
 	SEQ_printf(m, " %d %d", task_node(p), task_numa_group_id(p));
 #endif
 #ifdef CONFIG_CGROUP_SCHED
-	SEQ_printf(m, " %s", task_group_path(task_group(p)));
+	SEQ_printf_task_group_path(m, task_group(p), " %s")
 #endif
 
 	SEQ_printf(m, "\n");
@@ -490,7 +509,7 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	SEQ_printf(m, "\n");
-	SEQ_printf(m, "cfs_rq[%d]:%s\n", cpu, task_group_path(cfs_rq->tg));
+	SEQ_printf_task_group_path(m, cfs_rq->tg, "cfs_rq[%d]:%s\n", cpu);
 #else
 	SEQ_printf(m, "\n");
 	SEQ_printf(m, "cfs_rq[%d]:\n", cpu);
@@ -562,7 +581,7 @@ void print_rt_rq(struct seq_file *m, int cpu, struct rt_rq *rt_rq)
 {
 #ifdef CONFIG_RT_GROUP_SCHED
 	SEQ_printf(m, "\n");
-	SEQ_printf(m, "rt_rq[%d]:%s\n", cpu, task_group_path(rt_rq->tg));
+	SEQ_printf_task_group_path(m, rt_rq->tg, "rt_rq[%d]:%s\n", cpu);
 #else
 	SEQ_printf(m, "\n");
 	SEQ_printf(m, "rt_rq[%d]:\n", cpu);
@@ -614,7 +633,6 @@ void print_dl_rq(struct seq_file *m, int cpu, struct dl_rq *dl_rq)
 static void print_cpu(struct seq_file *m, int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
-	unsigned long flags;
 
 #ifdef CONFIG_X86
 	{
@@ -666,13 +684,11 @@ do {									\
 	}
 #undef P
 
-	spin_lock_irqsave(&sched_debug_lock, flags);
 	print_cfs_stats(m, cpu);
 	print_rt_stats(m, cpu);
 	print_dl_stats(m, cpu);
 
 	print_rq(m, rq, cpu);
-	spin_unlock_irqrestore(&sched_debug_lock, flags);
 	SEQ_printf(m, "\n");
 }
 
-- 
2.30.2



