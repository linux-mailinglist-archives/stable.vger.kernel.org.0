Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0566E1F89
	for <lists+stable@lfdr.de>; Wed, 23 Oct 2019 17:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403917AbfJWPjO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Oct 2019 11:39:14 -0400
Received: from [217.140.110.172] ([217.140.110.172]:55240 "EHLO foss.arm.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S2403757AbfJWPjO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Oct 2019 11:39:14 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B93B0494;
        Wed, 23 Oct 2019 08:38:46 -0700 (PDT)
Received: from e113632-lin.cambridge.arm.com (e113632-lin.cambridge.arm.com [10.1.194.37])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id EDBF43F718;
        Wed, 23 Oct 2019 08:38:44 -0700 (PDT)
From:   Valentin Schneider <valentin.schneider@arm.com>
To:     linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Cc:     lizefan@huawei.com, tj@kernel.org, hannes@cmpxchg.org,
        mingo@kernel.org, peterz@infradead.org, vincent.guittot@linaro.org,
        Dietmar.Eggemann@arm.com, morten.rasmussen@arm.com,
        qperret@google.com, stable@vger.kernel.org,
        Dietmar Eggemann <dietmar.eggemann@arm.com>
Subject: [PATCH v4 2/2] sched/topology: Allow sched_asym_cpucapacity to be disabled
Date:   Wed, 23 Oct 2019 16:37:45 +0100
Message-Id: <20191023153745.19515-3-valentin.schneider@arm.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191023153745.19515-1-valentin.schneider@arm.com>
References: <20191023153745.19515-1-valentin.schneider@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

While the static key is correctly initialized as being disabled, it will
remain forever enabled once turned on. This means that if we start with an
asymmetric system and hotplug out enough CPUs to end up with an SMP system,
the static key will remain set - which is obviously wrong. We should detect
this and turn off things like misfit migration and capacity aware wakeups.

As Quentin pointed out, having separate root domains makes this slightly
trickier. We could have exclusive cpusets that create an SMP island - IOW,
the domains within this root domain will not see any asymmetry. This means
we can't just disable the key on domain destruction, we need to count how
many asymmetric root domains we have.


Consider the following example using Juno r0 which is 2+4 big.LITTLE, where
two identical cpusets are created: they both span both big and LITTLE CPUs:

    asym0    asym1
  [       ][       ]
   L  L  B  L  L  B

  cgcreate -g cpuset:asym0
  cgset -r cpuset.cpus=0,1,3 asym0
  cgset -r cpuset.mems=0 asym0
  cgset -r cpuset.cpu_exclusive=1 asym0

  cgcreate -g cpuset:asym1
  cgset -r cpuset.cpus=2,4,5 asym1
  cgset -r cpuset.mems=0 asym1
  cgset -r cpuset.cpu_exclusive=1 asym1

  cgset -r cpuset.sched_load_balance=0 .

(the CPU numbering may look odd because on the Juno LITTLEs are CPUs 0,3-5
and bigs are CPUs 1-2)

If we make one of those SMP (IOW remove asymmetry) by e.g. hotplugging its
big core, we would end up with an SMP cpuset and an asymmetric cpuset - the
static key must remain set, because we still have one asymmetric root domain.

With the above example, this could be done with:

  echo 0 > /sys/devices/system/cpu/cpu2/online

Which would result in:

    asym0   asym1
  [       ][    ]
   L  L  B  L  L

When both SMP and asymmetric cpusets are present, all CPUs will observe
sched_asym_cpucapacity being set (it is system-wide), but not all CPUs
observe asymmetry in their sched domain hierarchy:

per_cpu(sd_asym_cpucapacity, <any CPU in asym0>) == <some SD at DIE level>
per_cpu(sd_asym_cpucapacity, <any CPU in asym1>) == NULL


Change the simple key enablement to an increment, and decrement the key
counter when destroying domains that cover asymmetric CPUs.

Cc: <stable@vger.kernel.org>
Fixes: df054e8445a4 ("sched/topology: Add static_key for asymmetric CPU capacity optimizations")
Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Signed-off-by: Valentin Schneider <valentin.schneider@arm.com>
---
 kernel/sched/topology.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index 2e7af755e17a..6ec1e595b1d4 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -2026,7 +2026,7 @@ build_sched_domains(const struct cpumask *cpu_map, struct sched_domain_attr *att
 	rcu_read_unlock();
 
 	if (has_asym)
-		static_branch_enable_cpuslocked(&sched_asym_cpucapacity);
+		static_branch_inc_cpuslocked(&sched_asym_cpucapacity);
 
 	if (rq && sched_debug_enabled) {
 		pr_info("root domain span: %*pbl (max cpu_capacity = %lu)\n",
@@ -2121,9 +2121,12 @@ int sched_init_domains(const struct cpumask *cpu_map)
  */
 static void detach_destroy_domains(const struct cpumask *cpu_map)
 {
+	unsigned int cpu = cpumask_any(cpu_map);
 	int i;
 
+	if (rcu_access_pointer(per_cpu(sd_asym_cpucapacity, cpu)))
+		static_branch_dec_cpuslocked(&sched_asym_cpucapacity);
+
 	rcu_read_lock();
 	for_each_cpu(i, cpu_map)
 		cpu_attach_domain(NULL, &def_root_domain, i);
--
2.22.0

