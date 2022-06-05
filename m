Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3209653DBC5
	for <lists+stable@lfdr.de>; Sun,  5 Jun 2022 15:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344292AbiFENxj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Jun 2022 09:53:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344163AbiFENxe (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Jun 2022 09:53:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 855495F4F;
        Sun,  5 Jun 2022 06:53:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36107B80D9F;
        Sun,  5 Jun 2022 13:53:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5FB7C385A5;
        Sun,  5 Jun 2022 13:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654437210;
        bh=D/v/WR76LQAO/mUWFPYxdwBs/BY1pE+vkJYJhtP2yLc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ONOBFU4YnCIiOamyNAE8Na57cS4bfBVT8DHefGXUXc+Ett3dq2eVYwHRvtKZoRe6Z
         0nM3LmG7KLeNjrWpuKMO3zsbKxtY5DYK23+SHwjWH4FSDwtbevNLcVqHsokHDWSi4a
         JoH0BvhwsD4KxRQmVIfkJe3tUg15f7WgrVhTZS6qmbNRMrxv1RlIX3LQEE4DATB+36
         YyWdtyOAAVq/S06qIG6QEk+urdmUSNumRKOg4TRpZa7cWM34jYbbzA1hol430lgLBz
         eEbUhVYSrkPv0FTz78n7DNt7G37eDdm5O+mPk5DggdK7x7hyBH5Y7npD9bfMpwkl/D
         dbsRLXkxOr0+A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        kernel test robot <lkp@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>, mingo@redhat.com,
        juri.lelli@redhat.com, vincent.guittot@linaro.org,
        tony.luck@intel.com, hdegoede@redhat.com
Subject: [PATCH MANUALSEL 5.18 4/7] sched: Fix missing prototype warnings
Date:   Sun,  5 Jun 2022 09:53:12 -0400
Message-Id: <20220605135320.61247-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220605135320.61247-1-sashal@kernel.org>
References: <20220605135320.61247-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit d664e399128bd78b905ff480917e2c2d4949e101 ]

A W=1 build emits more than a dozen missing prototype warnings related to
scheduler and scheduler specific includes.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20220413133024.249118058@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sched.h        | 2 ++
 kernel/sched/build_policy.c  | 2 ++
 kernel/sched/build_utility.c | 1 +
 kernel/sched/core.c          | 3 +++
 kernel/sched/deadline.c      | 2 --
 kernel/sched/fair.c          | 1 +
 kernel/sched/sched.h         | 8 ++------
 kernel/sched/smp.h           | 6 ++++++
 kernel/stop_machine.c        | 2 --
 9 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index a8911b1f35aa..74947048e3ad 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2362,4 +2362,6 @@ static inline void sched_core_free(struct task_struct *tsk) { }
 static inline void sched_core_fork(struct task_struct *p) { }
 #endif
 
+extern void sched_set_stop_task(int cpu, struct task_struct *stop);
+
 #endif
diff --git a/kernel/sched/build_policy.c b/kernel/sched/build_policy.c
index e0104b45029a..d9dc9ab3773f 100644
--- a/kernel/sched/build_policy.c
+++ b/kernel/sched/build_policy.c
@@ -15,6 +15,7 @@
 /* Headers: */
 #include <linux/sched/clock.h>
 #include <linux/sched/cputime.h>
+#include <linux/sched/hotplug.h>
 #include <linux/sched/posix-timers.h>
 #include <linux/sched/rt.h>
 
@@ -31,6 +32,7 @@
 #include <uapi/linux/sched/types.h>
 
 #include "sched.h"
+#include "smp.h"
 
 #include "autogroup.h"
 #include "stats.h"
diff --git a/kernel/sched/build_utility.c b/kernel/sched/build_utility.c
index eec0849b2aae..99bdd96f454f 100644
--- a/kernel/sched/build_utility.c
+++ b/kernel/sched/build_utility.c
@@ -14,6 +14,7 @@
 #include <linux/sched/debug.h>
 #include <linux/sched/isolation.h>
 #include <linux/sched/loadavg.h>
+#include <linux/sched/nohz.h>
 #include <linux/sched/mm.h>
 #include <linux/sched/rseq_api.h>
 #include <linux/sched/task_stack.h>
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index d58c0389eb23..ca71ebe2cd1d 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -26,7 +26,10 @@
 #include <linux/topology.h>
 #include <linux/sched/clock.h>
 #include <linux/sched/cond_resched.h>
+#include <linux/sched/cputime.h>
 #include <linux/sched/debug.h>
+#include <linux/sched/hotplug.h>
+#include <linux/sched/init.h>
 #include <linux/sched/isolation.h>
 #include <linux/sched/loadavg.h>
 #include <linux/sched/mm.h>
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index fb4255ae0b2c..6ae423627a7a 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1220,8 +1220,6 @@ int dl_runtime_exceeded(struct sched_dl_entity *dl_se)
 	return (dl_se->runtime <= 0);
 }
 
-extern bool sched_rt_bandwidth_account(struct rt_rq *rt_rq);
-
 /*
  * This function implements the GRUB accounting rule:
  * according to the GRUB reclaiming algorithm, the runtime is
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index a68482d66535..4edd47307cce 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -36,6 +36,7 @@
 #include <linux/sched/cond_resched.h>
 #include <linux/sched/cputime.h>
 #include <linux/sched/isolation.h>
+#include <linux/sched/nohz.h>
 
 #include <linux/cpuidle.h>
 #include <linux/interrupt.h>
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 8dccb34eb190..137d5c7ea7b2 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1827,12 +1827,7 @@ static inline void dirty_sched_domain_sysctl(int cpu)
 #endif
 
 extern int sched_update_scaling(void);
-
-extern void flush_smp_call_function_from_idle(void);
-
-#else /* !CONFIG_SMP: */
-static inline void flush_smp_call_function_from_idle(void) { }
-#endif
+#endif /* CONFIG_SMP */
 
 #include "stats.h"
 
@@ -2309,6 +2304,7 @@ extern void resched_cpu(int cpu);
 
 extern struct rt_bandwidth def_rt_bandwidth;
 extern void init_rt_bandwidth(struct rt_bandwidth *rt_b, u64 period, u64 runtime);
+extern bool sched_rt_bandwidth_account(struct rt_rq *rt_rq);
 
 extern void init_dl_bandwidth(struct dl_bandwidth *dl_b, u64 period, u64 runtime);
 extern void init_dl_task_timer(struct sched_dl_entity *dl_se);
diff --git a/kernel/sched/smp.h b/kernel/sched/smp.h
index 9620e323162c..5719bf9280e9 100644
--- a/kernel/sched/smp.h
+++ b/kernel/sched/smp.h
@@ -7,3 +7,9 @@
 extern void sched_ttwu_pending(void *arg);
 
 extern void send_call_function_single_ipi(int cpu);
+
+#ifdef CONFIG_SMP
+extern void flush_smp_call_function_from_idle(void);
+#else
+static inline void flush_smp_call_function_from_idle(void) { }
+#endif
diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index cbc30271ea4d..6da7b91af353 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -535,8 +535,6 @@ void stop_machine_park(int cpu)
 	kthread_park(stopper->thread);
 }
 
-extern void sched_set_stop_task(int cpu, struct task_struct *stop);
-
 static void cpu_stop_create(unsigned int cpu)
 {
 	sched_set_stop_task(cpu, per_cpu(cpu_stopper.thread, cpu));
-- 
2.35.1

