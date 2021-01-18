Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E6782FA2D0
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 15:22:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730106AbhAROUh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 09:20:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:39540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390641AbhARLot (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:44:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C76A322E00;
        Mon, 18 Jan 2021 11:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970248;
        bh=BNa5SEtTM0EjOCso8uzFS9MPKothiHVejn6idl1PSbU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u2Rj5Xrcle9fiT7mWkB3SmrpDpuRvYcQy6YLfeWrKhyphSFYnNwH7YCUMmBnvv7G5
         OICQ6txNyuWUDMZiFu7vdBwUXjsncAZUPbNIwSEefU6Cc5sSSP4EUSQYgO3nZKNBpv
         WlzD/tXN4FMgHIqsj8+0Xyfo9GFA9dJ/82DM6DnI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Axtens <dja@axtens.net>,
        "Uladzislau Rezki (Sony)" <urezki@gmail.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 098/152] rcu-tasks: Move RCU-tasks initialization to before early_initcall()
Date:   Mon, 18 Jan 2021 12:34:33 +0100
Message-Id: <20210118113357.442923897@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uladzislau Rezki (Sony) <urezki@gmail.com>

[ Upstream commit 1b04fa9900263b4e217ca2509fd778b32c2b4eb2 ]

PowerPC testing encountered boot failures due to RCU Tasks not being
fully initialized until core_initcall() time.  This commit therefore
initializes RCU Tasks (along with Rude RCU and RCU Tasks Trace) just
before early_initcall() time, thus allowing waiting on RCU Tasks grace
periods from early_initcall() handlers.

Link: https://lore.kernel.org/rcu/87eekfh80a.fsf@dja-thinkpad.axtens.net/
Fixes: 36dadef23fcc ("kprobes: Init kprobes in early_initcall")
Tested-by: Daniel Axtens <dja@axtens.net>
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/rcupdate.h |  6 ++++++
 init/main.c              |  1 +
 kernel/rcu/tasks.h       | 25 +++++++++++++++++++++----
 3 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 6cdd0152c253a..5c119d6cecf14 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -86,6 +86,12 @@ void rcu_sched_clock_irq(int user);
 void rcu_report_dead(unsigned int cpu);
 void rcutree_migrate_callbacks(int cpu);
 
+#ifdef CONFIG_TASKS_RCU_GENERIC
+void rcu_init_tasks_generic(void);
+#else
+static inline void rcu_init_tasks_generic(void) { }
+#endif
+
 #ifdef CONFIG_RCU_STALL_COMMON
 void rcu_sysrq_start(void);
 void rcu_sysrq_end(void);
diff --git a/init/main.c b/init/main.c
index 32b2a8affafd1..9d964511fe0c2 100644
--- a/init/main.c
+++ b/init/main.c
@@ -1512,6 +1512,7 @@ static noinline void __init kernel_init_freeable(void)
 
 	init_mm_internals();
 
+	rcu_init_tasks_generic();
 	do_pre_smp_initcalls();
 	lockup_detector_init();
 
diff --git a/kernel/rcu/tasks.h b/kernel/rcu/tasks.h
index d5d9f2d03e8a0..73bbe792fe1e8 100644
--- a/kernel/rcu/tasks.h
+++ b/kernel/rcu/tasks.h
@@ -241,7 +241,7 @@ static int __noreturn rcu_tasks_kthread(void *arg)
 	}
 }
 
-/* Spawn RCU-tasks grace-period kthread, e.g., at core_initcall() time. */
+/* Spawn RCU-tasks grace-period kthread. */
 static void __init rcu_spawn_tasks_kthread_generic(struct rcu_tasks *rtp)
 {
 	struct task_struct *t;
@@ -569,7 +569,6 @@ static int __init rcu_spawn_tasks_kthread(void)
 	rcu_spawn_tasks_kthread_generic(&rcu_tasks);
 	return 0;
 }
-core_initcall(rcu_spawn_tasks_kthread);
 
 #ifndef CONFIG_TINY_RCU
 static void show_rcu_tasks_classic_gp_kthread(void)
@@ -697,7 +696,6 @@ static int __init rcu_spawn_tasks_rude_kthread(void)
 	rcu_spawn_tasks_kthread_generic(&rcu_tasks_rude);
 	return 0;
 }
-core_initcall(rcu_spawn_tasks_rude_kthread);
 
 #ifndef CONFIG_TINY_RCU
 static void show_rcu_tasks_rude_gp_kthread(void)
@@ -975,6 +973,11 @@ static void rcu_tasks_trace_pregp_step(void)
 static void rcu_tasks_trace_pertask(struct task_struct *t,
 				    struct list_head *hop)
 {
+	// During early boot when there is only the one boot CPU, there
+	// is no idle task for the other CPUs. Just return.
+	if (unlikely(t == NULL))
+		return;
+
 	WRITE_ONCE(t->trc_reader_special.b.need_qs, false);
 	WRITE_ONCE(t->trc_reader_checked, false);
 	t->trc_ipi_to_cpu = -1;
@@ -1200,7 +1203,6 @@ static int __init rcu_spawn_tasks_trace_kthread(void)
 	rcu_spawn_tasks_kthread_generic(&rcu_tasks_trace);
 	return 0;
 }
-core_initcall(rcu_spawn_tasks_trace_kthread);
 
 #ifndef CONFIG_TINY_RCU
 static void show_rcu_tasks_trace_gp_kthread(void)
@@ -1229,6 +1231,21 @@ void show_rcu_tasks_gp_kthreads(void)
 }
 #endif /* #ifndef CONFIG_TINY_RCU */
 
+void __init rcu_init_tasks_generic(void)
+{
+#ifdef CONFIG_TASKS_RCU
+	rcu_spawn_tasks_kthread();
+#endif
+
+#ifdef CONFIG_TASKS_RUDE_RCU
+	rcu_spawn_tasks_rude_kthread();
+#endif
+
+#ifdef CONFIG_TASKS_TRACE_RCU
+	rcu_spawn_tasks_trace_kthread();
+#endif
+}
+
 #else /* #ifdef CONFIG_TASKS_RCU_GENERIC */
 static inline void rcu_tasks_bootup_oddness(void) {}
 void show_rcu_tasks_gp_kthreads(void) {}
-- 
2.27.0



