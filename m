Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB937167766
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:42:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730188AbgBUH4E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:56:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:55208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730176AbgBUH4C (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:56:02 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8373320578;
        Fri, 21 Feb 2020 07:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271761;
        bh=wuXqiR+4TGaPP7KuJ0NO6c5hFH3qljH6jxDi6aplioI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pUf+IA3dVc7nHUAORhqqu65ZQgDZ6afz/WSa39hMZRzkYg2BFaY8GXphqzqOoWJqE
         IDf8Rsi5A84RfCBu4RmTJK6Dq5Vy4BBEvWXUHAXtsqEQfzSMbd4eRh2XTsE9bhwieg
         HHs02Ynm4IKEyV5OxcBLwJ8Ii0kFnJDYoR8H0P/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zeng Tao <prime.zeng@hisilicon.com>,
        Valentin Schneider <valentin.schneider@arm.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 289/399] sched/topology: Assert non-NUMA topology masks dont (partially) overlap
Date:   Fri, 21 Feb 2020 08:40:14 +0100
Message-Id: <20200221072429.909155689@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



