Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2CF31D910
	for <lists+stable@lfdr.de>; Wed, 17 Feb 2021 13:05:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232563AbhBQMDk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Feb 2021 07:03:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232608AbhBQMDG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Feb 2021 07:03:06 -0500
X-Greylist: delayed 126 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 17 Feb 2021 04:02:25 PST
Received: from forwardcorp1p.mail.yandex.net (forwardcorp1p.mail.yandex.net [IPv6:2a02:6b8:0:1472:2741:0:8b6:217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC74EC0613D6;
        Wed, 17 Feb 2021 04:02:25 -0800 (PST)
Received: from iva8-d077482f1536.qloud-c.yandex.net (iva8-d077482f1536.qloud-c.yandex.net [IPv6:2a02:6b8:c0c:2f26:0:640:d077:482f])
        by forwardcorp1p.mail.yandex.net (Yandex) with ESMTP id F37942E1467;
        Wed, 17 Feb 2021 14:58:57 +0300 (MSK)
Received: from iva4-f06c35e68a0a.qloud-c.yandex.net (iva4-f06c35e68a0a.qloud-c.yandex.net [2a02:6b8:c0c:152e:0:640:f06c:35e6])
        by iva8-d077482f1536.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id tgDQ5AHuBi-wuxGMGd3;
        Wed, 17 Feb 2021 14:58:57 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.com; s=default;
        t=1613563137; bh=6C15C64hP1XMKAgjinsCItu/GC9ExXSOFBzauCsTbfU=;
        h=In-Reply-To:Message-Id:References:Date:Subject:To:From:Cc;
        b=2aiP//157Nbc1Tr9M4D8ZOrLUkjHEY7B/qpKBnWnMgokd1IcBIP2syEqrViQTa3vh
         2Ol7yq48YVkhWhF4gXQk6MK2Qn8qkZ24DKRL27KCxic1ryb7jqf3TXqy8ZC5BQr2Hd
         4kpthI2dBNJJAthCm978OppJWikRr4ALrCO9sDww=
Authentication-Results: iva8-d077482f1536.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.com
Received: from dynamic-vpn.dhcp.yndx.net (dynamic-vpn.dhcp.yndx.net [2a02:6b8:b080:7222::1:5])
        by iva4-f06c35e68a0a.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id GINHK1nK2P-wunWfUjX;
        Wed, 17 Feb 2021 14:58:56 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
From:   Andrey Ryabinin <arbn@yandex-team.com>
To:     Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>
Cc:     Boris Burkov <boris@bur.io>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrey Ryabinin <arbn@yandex-team.com>, stable@vger.kernel.org
Subject: [PATCH 3/4] sched/cpuacct: fix user/system in shown cpuacct.usage*
Date:   Wed, 17 Feb 2021 15:00:03 +0300
Message-Id: <20210217120004.7984-3-arbn@yandex-team.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210217120004.7984-1-arbn@yandex-team.com>
References: <20210217120004.7984-1-arbn@yandex-team.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

cpuacct has 2 different ways of accounting and showing user
and system times.

The first one uses cpuacct_account_field() to account times
and cpuacct.stat file to expose them. And this one seems to work ok.

The second one is uses cpuacct_charge() function for accounting and
set of cpuacct.usage* files to show times. Despite some attempts to
fix it in the past it still doesn't work. E.g. while running KVM
guest the cpuacct_charge() accounts most of the guest time as
system time. This doesn't match with user&system times shown in
cpuacct.stat or proc/<pid>/stat.

Use cpustats accounted in cpuacct_account_field() as the source
of user/sys times for cpuacct.usage* files. Make cpuacct_charge()
to account only summary execution time.

Fixes: d740037fac70 ("sched/cpuacct: Split usage accounting into user_usage and sys_usage")
Signed-off-by: Andrey Ryabinin <arbn@yandex-team.com>
Cc: <stable@vger.kernel.org>
---
 kernel/sched/cpuacct.c | 77 +++++++++++++++++++-----------------------
 1 file changed, 34 insertions(+), 43 deletions(-)

diff --git a/kernel/sched/cpuacct.c b/kernel/sched/cpuacct.c
index 941c28cf9738..7eff79faab0d 100644
--- a/kernel/sched/cpuacct.c
+++ b/kernel/sched/cpuacct.c
@@ -29,7 +29,7 @@ struct cpuacct_usage {
 struct cpuacct {
 	struct cgroup_subsys_state	css;
 	/* cpuusage holds pointer to a u64-type object on every CPU */
-	struct cpuacct_usage __percpu	*cpuusage;
+	u64 __percpu	*cpuusage;
 	struct kernel_cpustat __percpu	*cpustat;
 };
 
@@ -49,7 +49,7 @@ static inline struct cpuacct *parent_ca(struct cpuacct *ca)
 	return css_ca(ca->css.parent);
 }
 
-static DEFINE_PER_CPU(struct cpuacct_usage, root_cpuacct_cpuusage);
+static DEFINE_PER_CPU(u64, root_cpuacct_cpuusage);
 static struct cpuacct root_cpuacct = {
 	.cpustat	= &kernel_cpustat,
 	.cpuusage	= &root_cpuacct_cpuusage,
@@ -68,7 +68,7 @@ cpuacct_css_alloc(struct cgroup_subsys_state *parent_css)
 	if (!ca)
 		goto out;
 
-	ca->cpuusage = alloc_percpu(struct cpuacct_usage);
+	ca->cpuusage = alloc_percpu(u64);
 	if (!ca->cpuusage)
 		goto out_free_ca;
 
@@ -99,7 +99,8 @@ static void cpuacct_css_free(struct cgroup_subsys_state *css)
 static u64 cpuacct_cpuusage_read(struct cpuacct *ca, int cpu,
 				 enum cpuacct_stat_index index)
 {
-	struct cpuacct_usage *cpuusage = per_cpu_ptr(ca->cpuusage, cpu);
+	u64 *cpuusage = per_cpu_ptr(ca->cpuusage, cpu);
+	u64 *cpustat = per_cpu_ptr(ca->cpustat, cpu)->cpustat;
 	u64 data;
 
 	/*
@@ -115,14 +116,17 @@ static u64 cpuacct_cpuusage_read(struct cpuacct *ca, int cpu,
 	raw_spin_lock_irq(&cpu_rq(cpu)->lock);
 #endif
 
-	if (index == CPUACCT_STAT_NSTATS) {
-		int i = 0;
-
-		data = 0;
-		for (i = 0; i < CPUACCT_STAT_NSTATS; i++)
-			data += cpuusage->usages[i];
-	} else {
-		data = cpuusage->usages[index];
+	switch (index) {
+	case CPUACCT_STAT_USER:
+		data = cpustat[CPUTIME_USER] + cpustat[CPUTIME_NICE];
+		break;
+	case CPUACCT_STAT_SYSTEM:
+		data = cpustat[CPUTIME_SYSTEM] + cpustat[CPUTIME_IRQ] +
+			cpustat[CPUTIME_SOFTIRQ];
+		break;
+	case CPUACCT_STAT_NSTATS:
+		data = *cpuusage;
+		break;
 	}
 
 #ifndef CONFIG_64BIT
@@ -132,10 +136,14 @@ static u64 cpuacct_cpuusage_read(struct cpuacct *ca, int cpu,
 	return data;
 }
 
-static void cpuacct_cpuusage_write(struct cpuacct *ca, int cpu, u64 val)
+static void cpuacct_cpuusage_write(struct cpuacct *ca, int cpu)
 {
-	struct cpuacct_usage *cpuusage = per_cpu_ptr(ca->cpuusage, cpu);
-	int i;
+	u64 *cpuusage = per_cpu_ptr(ca->cpuusage, cpu);
+	u64 *cpustat = per_cpu_ptr(ca->cpustat, cpu)->cpustat;
+
+	/* Don't allow to reset global kernel_cpustat */
+	if (ca == &root_cpuacct)
+		return;
 
 #ifndef CONFIG_64BIT
 	/*
@@ -143,9 +151,10 @@ static void cpuacct_cpuusage_write(struct cpuacct *ca, int cpu, u64 val)
 	 */
 	raw_spin_lock_irq(&cpu_rq(cpu)->lock);
 #endif
-
-	for (i = 0; i < CPUACCT_STAT_NSTATS; i++)
-		cpuusage->usages[i] = val;
+	*cpuusage = 0;
+	cpustat[CPUTIME_USER] = cpustat[CPUTIME_NICE] = 0;
+	cpustat[CPUTIME_SYSTEM] = cpustat[CPUTIME_IRQ] = 0;
+	cpustat[CPUTIME_SOFTIRQ] = 0;
 
 #ifndef CONFIG_64BIT
 	raw_spin_unlock_irq(&cpu_rq(cpu)->lock);
@@ -196,7 +205,7 @@ static int cpuusage_write(struct cgroup_subsys_state *css, struct cftype *cft,
 		return -EINVAL;
 
 	for_each_possible_cpu(cpu)
-		cpuacct_cpuusage_write(ca, cpu, 0);
+		cpuacct_cpuusage_write(ca, cpu);
 
 	return 0;
 }
@@ -243,25 +252,12 @@ static int cpuacct_all_seq_show(struct seq_file *m, void *V)
 	seq_puts(m, "\n");
 
 	for_each_possible_cpu(cpu) {
-		struct cpuacct_usage *cpuusage = per_cpu_ptr(ca->cpuusage, cpu);
-
 		seq_printf(m, "%d", cpu);
 
-		for (index = 0; index < CPUACCT_STAT_NSTATS; index++) {
-#ifndef CONFIG_64BIT
-			/*
-			 * Take rq->lock to make 64-bit read safe on 32-bit
-			 * platforms.
-			 */
-			raw_spin_lock_irq(&cpu_rq(cpu)->lock);
-#endif
-
-			seq_printf(m, " %llu", cpuusage->usages[index]);
+		for (index = 0; index < CPUACCT_STAT_NSTATS; index++)
+			seq_printf(m, " %llu",
+				cpuacct_cpuusage_read(ca, cpu, index));
 
-#ifndef CONFIG_64BIT
-			raw_spin_unlock_irq(&cpu_rq(cpu)->lock);
-#endif
-		}
 		seq_puts(m, "\n");
 	}
 	return 0;
@@ -278,8 +274,8 @@ static int cpuacct_stats_show(struct seq_file *sf, void *v)
 	for_each_possible_cpu(cpu) {
 		u64 *cpustat = per_cpu_ptr(ca->cpustat, cpu)->cpustat;
 
-		val[CPUACCT_STAT_USER]   += cpustat[CPUTIME_USER];
-		val[CPUACCT_STAT_USER]   += cpustat[CPUTIME_NICE];
+		val[CPUACCT_STAT_USER] += cpustat[CPUTIME_USER];
+		val[CPUACCT_STAT_USER] += cpustat[CPUTIME_NICE];
 		val[CPUACCT_STAT_SYSTEM] += cpustat[CPUTIME_SYSTEM];
 		val[CPUACCT_STAT_SYSTEM] += cpustat[CPUTIME_IRQ];
 		val[CPUACCT_STAT_SYSTEM] += cpustat[CPUTIME_SOFTIRQ];
@@ -339,16 +335,11 @@ static struct cftype files[] = {
 void cpuacct_charge(struct task_struct *tsk, u64 cputime)
 {
 	struct cpuacct *ca;
-	int index = CPUACCT_STAT_SYSTEM;
-	struct pt_regs *regs = get_irq_regs() ? : task_pt_regs(tsk);
-
-	if (regs && user_mode(regs))
-		index = CPUACCT_STAT_USER;
 
 	rcu_read_lock();
 
 	for (ca = task_ca(tsk); ca; ca = parent_ca(ca))
-		__this_cpu_add(ca->cpuusage->usages[index], cputime);
+		__this_cpu_add(*ca->cpuusage, cputime);
 
 	rcu_read_unlock();
 }
-- 
2.26.2

