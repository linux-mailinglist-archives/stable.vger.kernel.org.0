Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85FF4F7D92
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:58:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730535AbfKKS6M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:58:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:58512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730179AbfKKS6M (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:58:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3EBE520659;
        Mon, 11 Nov 2019 18:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498690;
        bh=nrBgn8UFKW74PBHjlnB2QG55PmpfCVjWh3tNrM096r4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qQcHGX5ajghLkw2L4p2WKaB3Bp4IjysLdrkKbBXf7UgGOn1VxLngNvGyqiUi5jbQh
         SD2OwXSr3NXyPsz15JXP6iCjySjJkze0VMqqFuz4DIBsL3ALNgsGJy/M27Q0AcdPqX
         gVfRJGrwdgHxKsZ9GoTYfagxptvgg725uihNGzUE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Valentin Schneider <valentin.schneider@arm.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Dietmar.Eggemann@arm.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, hannes@cmpxchg.org,
        lizefan@huawei.com, morten.rasmussen@arm.com, qperret@google.com,
        tj@kernel.org, vincent.guittot@linaro.org,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 155/193] sched/topology: Allow sched_asym_cpucapacity to be disabled
Date:   Mon, 11 Nov 2019 19:28:57 +0100
Message-Id: <20191111181512.570764400@linuxfoundation.org>
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

[ Upstream commit e284df705cf1eeedb5ec3a66ed82d17a64659150 ]

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

  $ cgcreate -g cpuset:asym0
  $ cgset -r cpuset.cpus=0,1,3 asym0
  $ cgset -r cpuset.mems=0 asym0
  $ cgset -r cpuset.cpu_exclusive=1 asym0

  $ cgcreate -g cpuset:asym1
  $ cgset -r cpuset.cpus=2,4,5 asym1
  $ cgset -r cpuset.mems=0 asym1
  $ cgset -r cpuset.cpu_exclusive=1 asym1

  $ cgset -r cpuset.sched_load_balance=0 .

(the CPU numbering may look odd because on the Juno LITTLEs are CPUs 0,3-5
and bigs are CPUs 1-2)

If we make one of those SMP (IOW remove asymmetry) by e.g. hotplugging its
big core, we would end up with an SMP cpuset and an asymmetric cpuset - the
static key must remain set, because we still have one asymmetric root domain.

With the above example, this could be done with:

  $ echo 0 > /sys/devices/system/cpu/cpu2/online

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

Signed-off-by: Valentin Schneider <valentin.schneider@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
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
Fixes: df054e8445a4 ("sched/topology: Add static_key for asymmetric CPU capacity optimizations")
Link: https://lkml.kernel.org/r/20191023153745.19515-3-valentin.schneider@arm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/topology.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index 1906edb44d63c..93a8749763ea0 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -2008,7 +2008,7 @@ build_sched_domains(const struct cpumask *cpu_map, struct sched_domain_attr *att
 	rcu_read_unlock();
 
 	if (has_asym)
-		static_branch_enable_cpuslocked(&sched_asym_cpucapacity);
+		static_branch_inc_cpuslocked(&sched_asym_cpucapacity);
 
 	if (rq && sched_debug_enabled) {
 		pr_info("root domain span: %*pbl (max cpu_capacity = %lu)\n",
@@ -2103,8 +2103,12 @@ int sched_init_domains(const struct cpumask *cpu_map)
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
2.20.1



