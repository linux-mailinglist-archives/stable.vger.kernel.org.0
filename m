Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77A78F7DAA
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:59:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730410AbfKKS5g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:57:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:57130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729045AbfKKS5e (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:57:34 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A412222C2;
        Mon, 11 Nov 2019 18:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498652;
        bh=nRbuoaP0ls5mMuvPlcnbXxC++POTCv9TaXemck2nBYA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=haFJOXT0WewyYFCKMh18x39cNXism/hLLNnQ4KkMwW+yoyaZTF9Zf/PeqBSL6Crq0
         deGX4qMiJqqWczqh2cn008DJByFoB9GKrDulcw8zoXoOxDlztZ9jWC3rfEJF6fEEtX
         kwRuy1QjOd3kePvfeyfzB5unwkwR9Vf7ROqXioxI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Valentin Schneider <valentin.schneider@arm.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Dietmar.Eggemann@arm.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, hannes@cmpxchg.org,
        lizefan@huawei.com, morten.rasmussen@arm.com, qperret@google.com,
        tj@kernel.org, vincent.guittot@linaro.org,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 154/193] sched/topology: Dont try to build empty sched domains
Date:   Mon, 11 Nov 2019 19:28:56 +0100
Message-Id: <20191111181512.492886334@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Valentin Schneider <valentin.schneider@arm.com>

[ Upstream commit cd1cb3350561d2bf544ddfef76fbf0b1c9c7178f ]

Turns out hotplugging CPUs that are in exclusive cpusets can lead to the
cpuset code feeding empty cpumasks to the sched domain rebuild machinery.

This leads to the following splat:

    Internal error: Oops: 96000004 [#1] PREEMPT SMP
    Modules linked in:
    CPU: 0 PID: 235 Comm: kworker/5:2 Not tainted 5.4.0-rc1-00005-g8d495477d62e #23
    Hardware name: ARM Juno development board (r0) (DT)
    Workqueue: events cpuset_hotplug_workfn
    pstate: 60000005 (nZCv daif -PAN -UAO)
    pc : build_sched_domains (./include/linux/arch_topology.h:23 kernel/sched/topology.c:1898 kernel/sched/topology.c:1969)
    lr : build_sched_domains (kernel/sched/topology.c:1966)
    Call trace:
    build_sched_domains (./include/linux/arch_topology.h:23 kernel/sched/topology.c:1898 kernel/sched/topology.c:1969)
    partition_sched_domains_locked (kernel/sched/topology.c:2250)
    rebuild_sched_domains_locked (./include/linux/bitmap.h:370 ./include/linux/cpumask.h:538 kernel/cgroup/cpuset.c:955 kernel/cgroup/cpuset.c:978 kernel/cgroup/cpuset.c:1019)
    rebuild_sched_domains (kernel/cgroup/cpuset.c:1032)
    cpuset_hotplug_workfn (kernel/cgroup/cpuset.c:3205 (discriminator 2))
    process_one_work (./arch/arm64/include/asm/jump_label.h:21 ./include/linux/jump_label.h:200 ./include/trace/events/workqueue.h:114 kernel/workqueue.c:2274)
    worker_thread (./include/linux/compiler.h:199 ./include/linux/list.h:268 kernel/workqueue.c:2416)
    kthread (kernel/kthread.c:255)
    ret_from_fork (arch/arm64/kernel/entry.S:1167)
    Code: f860dae2 912802d6 aa1603e1 12800000 (f8616853)

The faulty line in question is:

  cap = arch_scale_cpu_capacity(cpumask_first(cpu_map));

and we're not checking the return value against nr_cpu_ids (we shouldn't
have to!), which leads to the above.

Prevent generate_sched_domains() from returning empty cpumasks, and add
some assertion in build_sched_domains() to scream bloody murder if it
happens again.

The above splat was obtained on my Juno r0 with the following reproducer:

  $ cgcreate -g cpuset:asym
  $ cgset -r cpuset.cpus=0-3 asym
  $ cgset -r cpuset.mems=0 asym
  $ cgset -r cpuset.cpu_exclusive=1 asym

  $ cgcreate -g cpuset:smp
  $ cgset -r cpuset.cpus=4-5 smp
  $ cgset -r cpuset.mems=0 smp
  $ cgset -r cpuset.cpu_exclusive=1 smp

  $ cgset -r cpuset.sched_load_balance=0 .

  $ echo 0 > /sys/devices/system/cpu/cpu4/online
  $ echo 0 > /sys/devices/system/cpu/cpu5/online

Signed-off-by: Valentin Schneider <valentin.schneider@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Dietmar.Eggemann@arm.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: hannes@cmpxchg.org
Cc: lizefan@huawei.com
Cc: morten.rasmussen@arm.com
Cc: qperret@google.com
Cc: tj@kernel.org
Cc: vincent.guittot@linaro.org
Fixes: 05484e098448 ("sched/topology: Add SD_ASYM_CPUCAPACITY flag detection")
Link: https://lkml.kernel.org/r/20191023153745.19515-2-valentin.schneider@arm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset.c  | 3 ++-
 kernel/sched/topology.c | 5 ++++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 5aa37531ce76f..a8122c405603b 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -786,7 +786,8 @@ static int generate_sched_domains(cpumask_var_t **domains,
 		    cpumask_subset(cp->cpus_allowed, top_cpuset.effective_cpus))
 			continue;
 
-		if (is_sched_load_balance(cp))
+		if (is_sched_load_balance(cp) &&
+		    !cpumask_empty(cp->effective_cpus))
 			csa[csn++] = cp;
 
 		/* skip @cp's subtree if not a partition root */
diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index f751ce0b783e5..1906edb44d63c 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -1927,7 +1927,7 @@ next_level:
 static int
 build_sched_domains(const struct cpumask *cpu_map, struct sched_domain_attr *attr)
 {
-	enum s_alloc alloc_state;
+	enum s_alloc alloc_state = sa_none;
 	struct sched_domain *sd;
 	struct s_data d;
 	struct rq *rq = NULL;
@@ -1935,6 +1935,9 @@ build_sched_domains(const struct cpumask *cpu_map, struct sched_domain_attr *att
 	struct sched_domain_topology_level *tl_asym;
 	bool has_asym = false;
 
+	if (WARN_ON(cpumask_empty(cpu_map)))
+		goto error;
+
 	alloc_state = __visit_domain_allocation_hell(&d, cpu_map);
 	if (alloc_state != sa_rootdomain)
 		goto error;
-- 
2.20.1



