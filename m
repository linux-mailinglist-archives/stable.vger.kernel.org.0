Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7B9115F0A5
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:56:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388250AbgBNP5a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 10:57:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:40474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388237AbgBNP53 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:57:29 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42D072086A;
        Fri, 14 Feb 2020 15:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695849;
        bh=wuXqiR+4TGaPP7KuJ0NO6c5hFH3qljH6jxDi6aplioI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o2UzYZAcnziClzq57K/2DzgYJg/vlH6ziQi4tMUkpe12RFQfjy+ZS7uMZtaoyyoQA
         gBooKu5oYVURifC6Sjw/jI4f/wdwF4FOzQ+v+Hww6YkBEZBqt/98SHBCDbWF0PLq0F
         W6HMB1pARBfOS8r1eQ3q/Ub3fhEgSYz81woetv+Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Valentin Schneider <valentin.schneider@arm.com>,
        Zeng Tao <prime.zeng@hisilicon.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.5 398/542] sched/topology: Assert non-NUMA topology masks don't (partially) overlap
Date:   Fri, 14 Feb 2020 10:46:30 -0500
Message-Id: <20200214154854.6746-398-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Valentin Schneider <valentin.schneider@arm.com>

[ Upstream commit ccf74128d66ce937876184ad55db2e0276af08d3 ]

topology.c::get_group() relies on the assumption that non-NUMA domains do
not partially overlap. Zeng Tao pointed out in [1] that such topology
descriptions, while completely bogus, can end up being exposed to the
scheduler.

In his example (8 CPUs, 2-node system), we end up with:
  MC span for CPU3 == 3-7
  MC span for CPU4 == 4-7

The first pass through get_group(3, sdd@MC) will result in the following
sched_group list:

  3 -> 4 -> 5 -> 6 -> 7
  ^                  /
   `----------------'

And a later pass through get_group(4, sdd@MC) will "corrupt" that to:

  3 -> 4 -> 5 -> 6 -> 7
       ^             /
	`-----------'

which will completely break things like 'while (sg != sd->groups)' when
using CPU3's base sched_domain.

There already are some architecture-specific checks in place such as
x86/kernel/smpboot.c::topology.sane(), but this is something we can detect
in the core scheduler, so it seems worthwhile to do so.

Warn and abort the construction of the sched domains if such a broken
topology description is detected. Note that this is somewhat
expensive (O(t.c²), 't' non-NUMA topology levels and 'c' CPUs) and could be
gated under SCHED_DEBUG if deemed necessary.

Testing
=======

Dietmar managed to reproduce this using the following qemu incantation:

  $ qemu-system-aarch64 -kernel ./Image -hda ./qemu-image-aarch64.img \
  -append 'root=/dev/vda console=ttyAMA0 loglevel=8 sched_debug' -smp \
  cores=8 --nographic -m 512 -cpu cortex-a53 -machine virt -numa \
  node,cpus=0-2,nodeid=0 -numa node,cpus=3-7,nodeid=1

alongside the following drivers/base/arch_topology.c hack (AIUI wouldn't be
needed if '-smp cores=X, sockets=Y' would work with qemu):

8<---
@@ -465,6 +465,9 @@ void update_siblings_masks(unsigned int cpuid)
 		if (cpuid_topo->package_id != cpu_topo->package_id)
 			continue;

+		if ((cpu < 4 && cpuid > 3) || (cpu > 3 && cpuid < 4))
+			continue;
+
 		cpumask_set_cpu(cpuid, &cpu_topo->core_sibling);
 		cpumask_set_cpu(cpu, &cpuid_topo->core_sibling);

8<---

[1]: https://lkml.kernel.org/r/1577088979-8545-1-git-send-email-prime.zeng@hisilicon.com

Reported-by: Zeng Tao <prime.zeng@hisilicon.com>
Signed-off-by: Valentin Schneider <valentin.schneider@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20200115160915.22575-1-valentin.schneider@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/topology.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index 6ec1e595b1d42..dfb64c08a407a 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -1879,6 +1879,42 @@ static struct sched_domain *build_sched_domain(struct sched_domain_topology_leve
 	return sd;
 }
 
+/*
+ * Ensure topology masks are sane, i.e. there are no conflicts (overlaps) for
+ * any two given CPUs at this (non-NUMA) topology level.
+ */
+static bool topology_span_sane(struct sched_domain_topology_level *tl,
+			      const struct cpumask *cpu_map, int cpu)
+{
+	int i;
+
+	/* NUMA levels are allowed to overlap */
+	if (tl->flags & SDTL_OVERLAP)
+		return true;
+
+	/*
+	 * Non-NUMA levels cannot partially overlap - they must be either
+	 * completely equal or completely disjoint. Otherwise we can end up
+	 * breaking the sched_group lists - i.e. a later get_group() pass
+	 * breaks the linking done for an earlier span.
+	 */
+	for_each_cpu(i, cpu_map) {
+		if (i == cpu)
+			continue;
+		/*
+		 * We should 'and' all those masks with 'cpu_map' to exactly
+		 * match the topology we're about to build, but that can only
+		 * remove CPUs, which only lessens our ability to detect
+		 * overlaps
+		 */
+		if (!cpumask_equal(tl->mask(cpu), tl->mask(i)) &&
+		    cpumask_intersects(tl->mask(cpu), tl->mask(i)))
+			return false;
+	}
+
+	return true;
+}
+
 /*
  * Find the sched_domain_topology_level where all CPU capacities are visible
  * for all CPUs.
@@ -1975,6 +2011,9 @@ build_sched_domains(const struct cpumask *cpu_map, struct sched_domain_attr *att
 				has_asym = true;
 			}
 
+			if (WARN_ON(!topology_span_sane(tl, cpu_map, i)))
+				goto error;
+
 			sd = build_sched_domain(tl, cpu_map, attr, sd, dflags, i);
 
 			if (tl == sched_domain_topology)
-- 
2.20.1

