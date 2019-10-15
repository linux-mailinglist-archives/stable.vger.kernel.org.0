Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F20F7D7340
	for <lists+stable@lfdr.de>; Tue, 15 Oct 2019 12:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbfJOKaL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Oct 2019 06:30:11 -0400
Received: from foss.arm.com ([217.140.110.172]:34678 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726540AbfJOKaK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Oct 2019 06:30:10 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0D3A928;
        Tue, 15 Oct 2019 03:30:10 -0700 (PDT)
Received: from e113632-lin.cambridge.arm.com (e113632-lin.cambridge.arm.com [10.1.194.37])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id C92373F68E;
        Tue, 15 Oct 2019 03:30:08 -0700 (PDT)
From:   Valentin Schneider <valentin.schneider@arm.com>
To:     linux-kernel@vger.kernel.org
Cc:     mingo@kernel.org, peterz@infradead.org, vincent.guittot@linaro.org,
        Dietmar.Eggemann@arm.com, morten.rasmussen@arm.com,
        qperret@google.com, stable@vger.kernel.org
Subject: [PATCH v2] sched/topology: Allow sched_asym_cpucapacity to be disabled
Date:   Tue, 15 Oct 2019 11:29:56 +0100
Message-Id: <20191015102956.20133-1-valentin.schneider@arm.com>
X-Mailer: git-send-email 2.22.0
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
we need to count how many asymmetric root domains we have.

Change the simple key enablement to an increment, and decrement the key
counter when destroying domains that cover asymmetric CPUs.

Cc: <stable@vger.kernel.org>
Fixes: df054e8445a4 ("sched/topology: Add static_key for asymmetric CPU capacity optimizations")
Signed-off-by: Valentin Schneider <valentin.schneider@arm.com>
---
Changes since v1:

Use static_branch_{inc,dec} rather than enable/disable
---
 kernel/sched/topology.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index b5667a273bf6..79944e969bcf 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -2026,7 +2026,7 @@ build_sched_domains(const struct cpumask *cpu_map, struct sched_domain_attr *att
 	rcu_read_unlock();
 
 	if (has_asym)
-		static_branch_enable_cpuslocked(&sched_asym_cpucapacity);
+		static_branch_inc_cpuslocked(&sched_asym_cpucapacity);
 
 	if (rq && sched_debug_enabled) {
 		pr_info("root domain span: %*pbl (max cpu_capacity = %lu)\n",
@@ -2124,8 +2124,17 @@ static void detach_destroy_domains(const struct cpumask *cpu_map)
 	int i;
 
 	rcu_read_lock();
+
+	if (static_key_enabled(&sched_asym_cpucapacity)) {
+		unsigned int cpu = cpumask_any(cpu_map);
+
+		if (rcu_dereference(per_cpu(sd_asym_cpucapacity, cpu)))
+			static_branch_dec_cpuslocked(&sched_asym_cpucapacity);
+	}
+
 	for_each_cpu(i, cpu_map)
 		cpu_attach_domain(NULL, &def_root_domain, i);
+
 	rcu_read_unlock();
 }
 
-- 
2.22.0

