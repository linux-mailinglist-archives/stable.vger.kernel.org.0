Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E80FA12C594
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:42:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727973AbfL2Rhd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:37:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:40058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729589AbfL2Rff (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:35:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1C45207FD;
        Sun, 29 Dec 2019 17:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640934;
        bh=QjjdSxocEYK0FCHOgwG7IqMPAu67Iojj1rl7rKtdrps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SpX+ZoBlyYIuwq+lOgl0H1EGG6kn+2PlSMlCCbAcaD2h0t/axVYY4QBnXpSu1rKOW
         84TOAY+vOkN+J5KKTGt5LebF5LnvByOhv95RuMxj/FD+ZMh3kJukHXHz8Q1TNxu4hb
         Bc6QzU43qcxdaAhwQXKctdsWNndv6tx96xvp5x8E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anson Huang <anson.huang@nxp.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Peng Fan <peng.fan@nxp.com>
Subject: [PATCH 4.19 199/219] cpufreq: Avoid leaving stale IRQ work items during CPU offline
Date:   Sun, 29 Dec 2019 18:20:01 +0100
Message-Id: <20191229162539.934924530@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162508.458551679@linuxfoundation.org>
References: <20191229162508.458551679@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 85572c2c4a45a541e880e087b5b17a48198b2416 upstream.

The scheduler code calling cpufreq_update_util() may run during CPU
offline on the target CPU after the IRQ work lists have been flushed
for it, so the target CPU should be prevented from running code that
may queue up an IRQ work item on it at that point.

Unfortunately, that may not be the case if dvfs_possible_from_any_cpu
is set for at least one cpufreq policy in the system, because that
allows the CPU going offline to run the utilization update callback
of the cpufreq governor on behalf of another (online) CPU in some
cases.

If that happens, the cpufreq governor callback may queue up an IRQ
work on the CPU running it, which is going offline, and the IRQ work
may not be flushed after that point.  Moreover, that IRQ work cannot
be flushed until the "offlining" CPU goes back online, so if any
other CPU calls irq_work_sync() to wait for the completion of that
IRQ work, it will have to wait until the "offlining" CPU is back
online and that may not happen forever.  In particular, a system-wide
deadlock may occur during CPU online as a result of that.

The failing scenario is as follows.  CPU0 is the boot CPU, so it
creates a cpufreq policy and becomes the "leader" of it
(policy->cpu).  It cannot go offline, because it is the boot CPU.
Next, other CPUs join the cpufreq policy as they go online and they
leave it when they go offline.  The last CPU to go offline, say CPU3,
may queue up an IRQ work while running the governor callback on
behalf of CPU0 after leaving the cpufreq policy because of the
dvfs_possible_from_any_cpu effect described above.  Then, CPU0 is
the only online CPU in the system and the stale IRQ work is still
queued on CPU3.  When, say, CPU1 goes back online, it will run
irq_work_sync() to wait for that IRQ work to complete and so it
will wait for CPU3 to go back online (which may never happen even
in principle), but (worse yet) CPU0 is waiting for CPU1 at that
point too and a system-wide deadlock occurs.

To address this problem notice that CPUs which cannot run cpufreq
utilization update code for themselves (for example, because they
have left the cpufreq policies that they belonged to), should also
be prevented from running that code on behalf of the other CPUs that
belong to a cpufreq policy with dvfs_possible_from_any_cpu set and so
in that case the cpufreq_update_util_data pointer of the CPU running
the code must not be NULL as well as for the CPU which is the target
of the cpufreq utilization update in progress.

Accordingly, change cpufreq_this_cpu_can_update() into a regular
function in kernel/sched/cpufreq.c (instead of a static inline in a
header file) and make it check the cpufreq_update_util_data pointer
of the local CPU if dvfs_possible_from_any_cpu is set for the target
cpufreq policy.

Also update the schedutil governor to do the
cpufreq_this_cpu_can_update() check in the non-fast-switch
case too to avoid the stale IRQ work issues.

Fixes: 99d14d0e16fa ("cpufreq: Process remote callbacks from any CPU if the platform permits")
Link: https://lore.kernel.org/linux-pm/20191121093557.bycvdo4xyinbc5cb@vireshk-i7/
Reported-by: Anson Huang <anson.huang@nxp.com>
Tested-by: Anson Huang <anson.huang@nxp.com>
Cc: 4.14+ <stable@vger.kernel.org> # 4.14+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Tested-by: Peng Fan <peng.fan@nxp.com> (i.MX8QXP-MEK)
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/cpufreq.h          |   11 -----------
 include/linux/sched/cpufreq.h    |    3 +++
 kernel/sched/cpufreq.c           |   18 ++++++++++++++++++
 kernel/sched/cpufreq_schedutil.c |    8 +++-----
 4 files changed, 24 insertions(+), 16 deletions(-)

--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -563,17 +563,6 @@ struct governor_attr {
 			 size_t count);
 };
 
-static inline bool cpufreq_this_cpu_can_update(struct cpufreq_policy *policy)
-{
-	/*
-	 * Allow remote callbacks if:
-	 * - dvfs_possible_from_any_cpu flag is set
-	 * - the local and remote CPUs share cpufreq policy
-	 */
-	return policy->dvfs_possible_from_any_cpu ||
-		cpumask_test_cpu(smp_processor_id(), policy->cpus);
-}
-
 /*********************************************************************
  *                     FREQUENCY TABLE HELPERS                       *
  *********************************************************************/
--- a/include/linux/sched/cpufreq.h
+++ b/include/linux/sched/cpufreq.h
@@ -12,6 +12,8 @@
 #define SCHED_CPUFREQ_MIGRATION	(1U << 1)
 
 #ifdef CONFIG_CPU_FREQ
+struct cpufreq_policy;
+
 struct update_util_data {
        void (*func)(struct update_util_data *data, u64 time, unsigned int flags);
 };
@@ -20,6 +22,7 @@ void cpufreq_add_update_util_hook(int cp
                        void (*func)(struct update_util_data *data, u64 time,
 				    unsigned int flags));
 void cpufreq_remove_update_util_hook(int cpu);
+bool cpufreq_this_cpu_can_update(struct cpufreq_policy *policy);
 #endif /* CONFIG_CPU_FREQ */
 
 #endif /* _LINUX_SCHED_CPUFREQ_H */
--- a/kernel/sched/cpufreq.c
+++ b/kernel/sched/cpufreq.c
@@ -8,6 +8,8 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
+#include <linux/cpufreq.h>
+
 #include "sched.h"
 
 DEFINE_PER_CPU(struct update_util_data *, cpufreq_update_util_data);
@@ -60,3 +62,19 @@ void cpufreq_remove_update_util_hook(int
 	rcu_assign_pointer(per_cpu(cpufreq_update_util_data, cpu), NULL);
 }
 EXPORT_SYMBOL_GPL(cpufreq_remove_update_util_hook);
+
+/**
+ * cpufreq_this_cpu_can_update - Check if cpufreq policy can be updated.
+ * @policy: cpufreq policy to check.
+ *
+ * Return 'true' if:
+ * - the local and remote CPUs share @policy,
+ * - dvfs_possible_from_any_cpu is set in @policy and the local CPU is not going
+ *   offline (in which case it is not expected to run cpufreq updates any more).
+ */
+bool cpufreq_this_cpu_can_update(struct cpufreq_policy *policy)
+{
+	return cpumask_test_cpu(smp_processor_id(), policy->cpus) ||
+		(policy->dvfs_possible_from_any_cpu &&
+		 rcu_dereference_sched(*this_cpu_ptr(&cpufreq_update_util_data)));
+}
--- a/kernel/sched/cpufreq_schedutil.c
+++ b/kernel/sched/cpufreq_schedutil.c
@@ -83,12 +83,10 @@ static bool sugov_should_update_freq(str
 	 * by the hardware, as calculating the frequency is pointless if
 	 * we cannot in fact act on it.
 	 *
-	 * For the slow switching platforms, the kthread is always scheduled on
-	 * the right set of CPUs and any CPU can find the next frequency and
-	 * schedule the kthread.
+	 * This is needed on the slow switching platforms too to prevent CPUs
+	 * going offline from leaving stale IRQ work items behind.
 	 */
-	if (sg_policy->policy->fast_switch_enabled &&
-	    !cpufreq_this_cpu_can_update(sg_policy->policy))
+	if (!cpufreq_this_cpu_can_update(sg_policy->policy))
 		return false;
 
 	if (unlikely(sg_policy->limits_changed)) {


