Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E556CE1F83
	for <lists+stable@lfdr.de>; Wed, 23 Oct 2019 17:38:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406808AbfJWPix (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Oct 2019 11:38:53 -0400
Received: from [217.140.110.172] ([217.140.110.172]:55204 "EHLO foss.arm.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S2403912AbfJWPiw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Oct 2019 11:38:52 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 14273442;
        Wed, 23 Oct 2019 08:38:30 -0700 (PDT)
Received: from e113632-lin.cambridge.arm.com (e113632-lin.cambridge.arm.com [10.1.194.37])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 63E403F718;
        Wed, 23 Oct 2019 08:38:28 -0700 (PDT)
From:   Valentin Schneider <valentin.schneider@arm.com>
To:     linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Cc:     lizefan@huawei.com, tj@kernel.org, hannes@cmpxchg.org,
        mingo@kernel.org, peterz@infradead.org, vincent.guittot@linaro.org,
        Dietmar.Eggemann@arm.com, morten.rasmussen@arm.com,
        qperret@google.com, stable@vger.kernel.org
Subject: [PATCH v4 1/2] sched/topology: Don't try to build empty sched domains
Date:   Wed, 23 Oct 2019 16:37:44 +0100
Message-Id: <20191023153745.19515-2-valentin.schneider@arm.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191023153745.19515-1-valentin.schneider@arm.com>
References: <20191023153745.19515-1-valentin.schneider@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Turns out hotplugging CPUs that are in exclusive cpusets can lead to the
cpuset code feeding empty cpumasks to the sched domain rebuild machinery.
This leads to the following splat:

[   30.618174] Internal error: Oops: 96000004 [#1] PREEMPT SMP
[   30.623697] Modules linked in:
[   30.626731] CPU: 0 PID: 235 Comm: kworker/5:2 Not tainted 5.4.0-rc1-00005-g8d495477d62e #23
[   30.635003] Hardware name: ARM Juno development board (r0) (DT)
[   30.640877] Workqueue: events cpuset_hotplug_workfn
[   30.645713] pstate: 60000005 (nZCv daif -PAN -UAO)
[   30.650464] pc : build_sched_domains (./include/linux/arch_topology.h:23 kernel/sched/topology.c:1898 kernel/sched/topology.c:1969)
[   30.655126] lr : build_sched_domains (kernel/sched/topology.c:1966)
[...]
[   30.742047] Call trace:
[   30.744474] build_sched_domains (./include/linux/arch_topology.h:23 kernel/sched/topology.c:1898 kernel/sched/topology.c:1969)
[   30.748793] partition_sched_domains_locked (kernel/sched/topology.c:2250)
[   30.753971] rebuild_sched_domains_locked (./include/linux/bitmap.h:370 ./include/linux/cpumask.h:538 kernel/cgroup/cpuset.c:955 kernel/cgroup/cpuset.c:978 kernel/cgroup/cpuset.c:1019)
[   30.758977] rebuild_sched_domains (kernel/cgroup/cpuset.c:1032)
[   30.763209] cpuset_hotplug_workfn (kernel/cgroup/cpuset.c:3205 (discriminator 2))
[   30.767613] process_one_work (./arch/arm64/include/asm/jump_label.h:21 ./include/linux/jump_label.h:200 ./include/trace/events/workqueue.h:114 kernel/workqueue.c:2274)
[   30.771586] worker_thread (./include/linux/compiler.h:199 ./include/linux/list.h:268 kernel/workqueue.c:2416)
[   30.775217] kthread (kernel/kthread.c:255)
[   30.778418] ret_from_fork (arch/arm64/kernel/entry.S:1167)
[ 30.781965] Code: f860dae2 912802d6 aa1603e1 12800000 (f8616853)

The faulty line in question is

  cap = arch_scale_cpu_capacity(cpumask_first(cpu_map));

and we're not checking the return value against nr_cpu_ids (we shouldn't
have to!), which leads to the above.

Prevent generate_sched_domains() from returning empty cpumasks, and add
some assertion in build_sched_domains() to scream bloody murder if it
happens again.

The above splat was obtained on my Juno r0 with:

  cgcreate -g cpuset:asym
  cgset -r cpuset.cpus=0-3 asym
  cgset -r cpuset.mems=0 asym
  cgset -r cpuset.cpu_exclusive=1 asym

  cgcreate -g cpuset:smp
  cgset -r cpuset.cpus=4-5 smp
  cgset -r cpuset.mems=0 smp
  cgset -r cpuset.cpu_exclusive=1 smp

  cgset -r cpuset.sched_load_balance=0 .

  echo 0 > /sys/devices/system/cpu/cpu4/online
  echo 0 > /sys/devices/system/cpu/cpu5/online

Cc: <stable@vger.kernel.org>
Fixes: 05484e098448 ("sched/topology: Add SD_ASYM_CPUCAPACITY flag detection")
Signed-off-by: Valentin Schneider <valentin.schneider@arm.com>
---
 kernel/cgroup/cpuset.c  | 3 ++-
 kernel/sched/topology.c | 5 ++++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index c52bc91f882b..c87ee6412b36 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -798,7 +798,8 @@ static int generate_sched_domains(cpumask_var_t **domains,
 		    cpumask_subset(cp->cpus_allowed, top_cpuset.effective_cpus))
 			continue;
 
-		if (is_sched_load_balance(cp))
+		if (is_sched_load_balance(cp) &&
+		    !cpumask_empty(cp->effective_cpus))
 			csa[csn++] = cp;
 
 		/* skip @cp's subtree if not a partition root */
diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index 3623ffe85d18..2e7af755e17a 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -1945,7 +1945,7 @@ static struct sched_domain_topology_level
 static int
 build_sched_domains(const struct cpumask *cpu_map, struct sched_domain_attr *attr)
 {
-	enum s_alloc alloc_state;
+	enum s_alloc alloc_state = sa_none;
 	struct sched_domain *sd;
 	struct s_data d;
 	struct rq *rq = NULL;
@@ -1953,6 +1953,9 @@ build_sched_domains(const struct cpumask *cpu_map, struct sched_domain_attr *att
 	struct sched_domain_topology_level *tl_asym;
 	bool has_asym = false;
 
+	if (WARN_ON(cpumask_empty(cpu_map)))
+		goto error;
+
 	alloc_state = __visit_domain_allocation_hell(&d, cpu_map);
 	if (alloc_state != sa_rootdomain)
 		goto error;
-- 
2.22.0

