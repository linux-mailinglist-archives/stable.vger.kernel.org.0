Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A376499543
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:09:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392506AbiAXUvX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:51:23 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:46340 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390476AbiAXUpb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:45:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F846B810A8;
        Mon, 24 Jan 2022 20:45:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50553C340E5;
        Mon, 24 Jan 2022 20:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057126;
        bh=lwmo3Kp9Lf9a9yqto9dD7w/To7cLK85iygXK9u4mjjU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MEBJmI35V/B90ZoamGCRYdSxVX0ZJf0c/mKiO5s0mXWyit5utyqd8mcgKCGFOa/B+
         RHHhMk4PlaydQhb2sW2lXwoUfPKDBmDyQ48T7vWFqmy2rhZaCdQ7xQHUUui51DiLZm
         2wflFWY3VsTz8yvDIhxMO1XSA2MP2OQevfikx8kk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrey Ryabinin <arbn@yandex-team.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 5.15 683/846] sched/cpuacct: Fix user/system in shown cpuacct.usage*
Date:   Mon, 24 Jan 2022 19:43:20 +0100
Message-Id: <20220124184124.631379399@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Ryabinin <arbn@yandex-team.com>

commit dd02d4234c9a2214a81c57a16484304a1a51872a upstream.

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
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20211115164607.23784-3-arbn@yandex-team.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/cpuacct.c |   79 +++++++++++++++++++------------------------------
 1 file changed, 32 insertions(+), 47 deletions(-)

--- a/kernel/sched/cpuacct.c
+++ b/kernel/sched/cpuacct.c
@@ -21,15 +21,11 @@ static const char * const cpuacct_stat_d
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
 
@@ -49,7 +45,7 @@ static inline struct cpuacct *parent_ca(
 	return css_ca(ca->css.parent);
 }
 
-static DEFINE_PER_CPU(struct cpuacct_usage, root_cpuacct_cpuusage);
+static DEFINE_PER_CPU(u64, root_cpuacct_cpuusage);
 static struct cpuacct root_cpuacct = {
 	.cpustat	= &kernel_cpustat,
 	.cpuusage	= &root_cpuacct_cpuusage,
@@ -68,7 +64,7 @@ cpuacct_css_alloc(struct cgroup_subsys_s
 	if (!ca)
 		goto out;
 
-	ca->cpuusage = alloc_percpu(struct cpuacct_usage);
+	ca->cpuusage = alloc_percpu(u64);
 	if (!ca->cpuusage)
 		goto out_free_ca;
 
@@ -99,7 +95,8 @@ static void cpuacct_css_free(struct cgro
 static u64 cpuacct_cpuusage_read(struct cpuacct *ca, int cpu,
 				 enum cpuacct_stat_index index)
 {
-	struct cpuacct_usage *cpuusage = per_cpu_ptr(ca->cpuusage, cpu);
+	u64 *cpuusage = per_cpu_ptr(ca->cpuusage, cpu);
+	u64 *cpustat = per_cpu_ptr(ca->cpustat, cpu)->cpustat;
 	u64 data;
 
 	/*
@@ -115,14 +112,17 @@ static u64 cpuacct_cpuusage_read(struct
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
@@ -132,10 +132,14 @@ static u64 cpuacct_cpuusage_read(struct
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
@@ -143,9 +147,10 @@ static void cpuacct_cpuusage_write(struc
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
@@ -196,7 +201,7 @@ static int cpuusage_write(struct cgroup_
 		return -EINVAL;
 
 	for_each_possible_cpu(cpu)
-		cpuacct_cpuusage_write(ca, cpu, 0);
+		cpuacct_cpuusage_write(ca, cpu);
 
 	return 0;
 }
@@ -243,25 +248,10 @@ static int cpuacct_all_seq_show(struct s
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
@@ -339,16 +329,11 @@ static struct cftype files[] = {
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


