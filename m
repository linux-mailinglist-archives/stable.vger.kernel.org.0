Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3B6E450A00
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 17:47:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230513AbhKOQuW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 11:50:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232052AbhKOQuI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 11:50:08 -0500
X-Greylist: delayed 137 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 15 Nov 2021 08:47:03 PST
Received: from forwardcorp1p.mail.yandex.net (forwardcorp1p.mail.yandex.net [IPv6:2a02:6b8:0:1472:2741:0:8b6:217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D2F8C061746;
        Mon, 15 Nov 2021 08:47:01 -0800 (PST)
Received: from sas1-4cbebe29391b.qloud-c.yandex.net (sas1-4cbebe29391b.qloud-c.yandex.net [IPv6:2a02:6b8:c08:789:0:640:4cbe:be29])
        by forwardcorp1p.mail.yandex.net (Yandex) with ESMTP id 4B8022E0AF8;
        Mon, 15 Nov 2021 19:44:44 +0300 (MSK)
Received: from myt6-10e59078d438.qloud-c.yandex.net (myt6-10e59078d438.qloud-c.yandex.net [2a02:6b8:c12:5209:0:640:10e5:9078])
        by sas1-4cbebe29391b.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id 50Bczk8b2D-igsOabIR;
        Mon, 15 Nov 2021 19:44:44 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.com; s=default;
        t=1636994684; bh=ewG6yrgLHvFhUCb82RJmeXRNaG9U40j3wHYfggqDy6k=;
        h=In-Reply-To:Message-Id:References:Date:Subject:To:From:Cc;
        b=spxtxn/9BScHVRKv1ftQoJym/hm4LZp+byyQvkEyvRiGzfESYd7MmVFcfPNhgXy+E
         8DDUvPw4EEyidXK6eGWxgy4phMypy2suxZkDg3wKYB++y4qjkxcmDt62lY0O/B5ImN
         vAB5P4zXLNe5EO5C8b6Ihp8FSVbQaXy82IwEIG2A=
Authentication-Results: sas1-4cbebe29391b.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.com
Received: from dellarbn.yandex.net (dynamic-red3.dhcp.yndx.net [2a02:6b8:0:107:3e85:844d:5b1d:60a])
        by myt6-10e59078d438.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPS id 7goUWCU60O-igwSvJTc;
        Mon, 15 Nov 2021 19:44:42 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
X-Yandex-Fwd: 2
From:   Andrey Ryabinin <arbn@yandex-team.com>
To:     Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Andrey Ryabinin <arbn@yandex-team.com>, stable@vger.kernel.org,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Tejun Heo <tj@kernel.org>, Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dan Schatzberg <schatzberg.dan@gmail.com>
Subject: [PATCH v3 3/4] sched/cpuacct: fix user/system in shown cpuacct.usage*
Date:   Mon, 15 Nov 2021 19:46:06 +0300
Message-Id: <20211115164607.23784-3-arbn@yandex-team.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211115164607.23784-1-arbn@yandex-team.com>
References: <20211115164607.23784-1-arbn@yandex-team.com>
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
fix it in the past it still doesn't work. Sometimes while running KVM
guest the cpuacct_charge() accounts most of the guest time as
system time. This doesn't match with user&system times shown in
cpuacct.stat or proc/<pid>/stat.

Demonstration:
 # git clone https://github.com/aryabinin/kvmsample
 # make
 # mkdir /sys/fs/cgroup/cpuacct/test
 # echo $$ > /sys/fs/cgroup/cpuacct/test/tasks
 # ./kvmsample &
 # for i in {1..5}; do cat /sys/fs/cgroup/cpuacct/test/cpuacct.usage_sys; sleep 1; done
 1976535645
 2979839428
 3979832704
 4983603153
 5983604157

Use cpustats accounted in cpuacct_account_field() as the source
of user/sys times for cpuacct.usage* files. Make cpuacct_charge()
to account only summary execution time.

Fixes: d740037fac70 ("sched/cpuacct: Split usage accounting into user_usage and sys_usage")
Signed-off-by: Andrey Ryabinin <arbn@yandex-team.com>
Cc: <stable@vger.kernel.org>
Reviewed-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Acked-by: Tejun Heo <tj@kernel.org>
---
 kernel/sched/cpuacct.c | 79 +++++++++++++++++-------------------------
 1 file changed, 32 insertions(+), 47 deletions(-)

diff --git a/kernel/sched/cpuacct.c b/kernel/sched/cpuacct.c
index f347cf9e4634..9de7dd51beb0 100644
--- a/kernel/sched/cpuacct.c
+++ b/kernel/sched/cpuacct.c
@@ -21,15 +21,11 @@ static const char * const cpuacct_stat_desc[] = {
 	[CPUACCT_STAT_SYSTEM] = "system",
 };
 
-struct cpuacct_usage {
-	u64	usages[CPUACCT_STAT_NSTATS];
-};
-
 /* track CPU usage of a group of tasks and its child groups */
 struct cpuacct {
 	struct cgroup_subsys_state	css;
 	/* cpuusage holds pointer to a u64-type object on every CPU */
-	struct cpuacct_usage __percpu	*cpuusage;
+	u64 __percpu	*cpuusage;
 	struct kernel_cpustat __percpu	*cpustat;
 };
 
@@ -49,7 +45,7 @@ static inline struct cpuacct *parent_ca(struct cpuacct *ca)
 	return css_ca(ca->css.parent);
 }
 
-static DEFINE_PER_CPU(struct cpuacct_usage, root_cpuacct_cpuusage);
+static DEFINE_PER_CPU(u64, root_cpuacct_cpuusage);
 static struct cpuacct root_cpuacct = {
 	.cpustat	= &kernel_cpustat,
 	.cpuusage	= &root_cpuacct_cpuusage,
@@ -68,7 +64,7 @@ cpuacct_css_alloc(struct cgroup_subsys_state *parent_css)
 	if (!ca)
 		goto out;
 
-	ca->cpuusage = alloc_percpu(struct cpuacct_usage);
+	ca->cpuusage = alloc_percpu(u64);
 	if (!ca->cpuusage)
 		goto out_free_ca;
 
@@ -99,7 +95,8 @@ static void cpuacct_css_free(struct cgroup_subsys_state *css)
 static u64 cpuacct_cpuusage_read(struct cpuacct *ca, int cpu,
 				 enum cpuacct_stat_index index)
 {
-	struct cpuacct_usage *cpuusage = per_cpu_ptr(ca->cpuusage, cpu);
+	u64 *cpuusage = per_cpu_ptr(ca->cpuusage, cpu);
+	u64 *cpustat = per_cpu_ptr(ca->cpustat, cpu)->cpustat;
 	u64 data;
 
 	/*
@@ -116,14 +113,17 @@ static u64 cpuacct_cpuusage_read(struct cpuacct *ca, int cpu,
 	raw_spin_rq_lock_irq(cpu_rq(cpu));
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
@@ -133,10 +133,14 @@ static u64 cpuacct_cpuusage_read(struct cpuacct *ca, int cpu,
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
@@ -144,9 +148,10 @@ static void cpuacct_cpuusage_write(struct cpuacct *ca, int cpu, u64 val)
 	 */
 	raw_spin_rq_lock_irq(cpu_rq(cpu));
 #endif
-
-	for (i = 0; i < CPUACCT_STAT_NSTATS; i++)
-		cpuusage->usages[i] = val;
+	*cpuusage = 0;
+	cpustat[CPUTIME_USER] = cpustat[CPUTIME_NICE] = 0;
+	cpustat[CPUTIME_SYSTEM] = cpustat[CPUTIME_IRQ] = 0;
+	cpustat[CPUTIME_SOFTIRQ] = 0;
 
 #ifndef CONFIG_64BIT
 	raw_spin_rq_unlock_irq(cpu_rq(cpu));
@@ -197,7 +202,7 @@ static int cpuusage_write(struct cgroup_subsys_state *css, struct cftype *cft,
 		return -EINVAL;
 
 	for_each_possible_cpu(cpu)
-		cpuacct_cpuusage_write(ca, cpu, 0);
+		cpuacct_cpuusage_write(ca, cpu);
 
 	return 0;
 }
@@ -244,25 +249,10 @@ static int cpuacct_all_seq_show(struct seq_file *m, void *V)
 	seq_puts(m, "\n");
 
 	for_each_possible_cpu(cpu) {
-		struct cpuacct_usage *cpuusage = per_cpu_ptr(ca->cpuusage, cpu);
-
 		seq_printf(m, "%d", cpu);
-
-		for (index = 0; index < CPUACCT_STAT_NSTATS; index++) {
-#ifndef CONFIG_64BIT
-			/*
-			 * Take rq->lock to make 64-bit read safe on 32-bit
-			 * platforms.
-			 */
-			raw_spin_rq_lock_irq(cpu_rq(cpu));
-#endif
-
-			seq_printf(m, " %llu", cpuusage->usages[index]);
-
-#ifndef CONFIG_64BIT
-			raw_spin_rq_unlock_irq(cpu_rq(cpu));
-#endif
-		}
+		for (index = 0; index < CPUACCT_STAT_NSTATS; index++)
+			seq_printf(m, " %llu",
+				   cpuacct_cpuusage_read(ca, cpu, index));
 		seq_puts(m, "\n");
 	}
 	return 0;
@@ -340,16 +330,11 @@ static struct cftype files[] = {
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
2.32.0

