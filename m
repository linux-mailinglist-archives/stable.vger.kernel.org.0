Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A535E299BBD
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 00:53:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409080AbgJZXxG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 19:53:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:56864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409953AbgJZXxF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 19:53:05 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC1C120B1F;
        Mon, 26 Oct 2020 23:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756384;
        bh=kyEewnVBVkaDGzRqY6v8My85Gla89CAOx9ljs28QbXs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r4SxyUM79x7Fl3RG4Ierrt5uhK++uFDrA5AzMyFdTfc8w0FgWxp2j9+0qGMrcbiGy
         hYCIg3BE/TdJe09Kq4KhX6yJI4yyJD/Ike6LhTrb6t4uEYACZxAVtd8OA6dU267SFH
         nEn4d2Rrh+5oE3YMvdqOoSm2c8yXx3CPFx5AXEko=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Valentin Schneider <valentin.schneider@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.8 048/132] arm64: topology: Stop using MPIDR for topology information
Date:   Mon, 26 Oct 2020 19:50:40 -0400
Message-Id: <20201026235205.1023962-48-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026235205.1023962-1-sashal@kernel.org>
References: <20201026235205.1023962-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Valentin Schneider <valentin.schneider@arm.com>

[ Upstream commit 3102bc0e6ac752cc5df896acb557d779af4d82a1 ]

In the absence of ACPI or DT topology data, we fallback to haphazardly
decoding *something* out of MPIDR. Sadly, the contents of that register are
mostly unusable due to the implementation leniancy and things like Aff0
having to be capped to 15 (despite being encoded on 8 bits).

Consider a simple system with a single package of 32 cores, all under the
same LLC. We ought to be shoving them in the same core_sibling mask, but
MPIDR is going to look like:

  | CPU  | 0 | ... | 15 | 16 | ... | 31 |
  |------+---+-----+----+----+-----+----+
  | Aff0 | 0 | ... | 15 |  0 | ... | 15 |
  | Aff1 | 0 | ... |  0 |  1 | ... |  1 |
  | Aff2 | 0 | ... |  0 |  0 | ... |  0 |

Which will eventually yield

  core_sibling(0-15)  == 0-15
  core_sibling(16-31) == 16-31

NUMA woes
=========

If we try to play games with this and set up NUMA boundaries within those
groups of 16 cores via e.g. QEMU:

  # Node0: 0-9; Node1: 10-19
  $ qemu-system-aarch64 <blah> \
    -smp 20 -numa node,cpus=0-9,nodeid=0 -numa node,cpus=10-19,nodeid=1

The scheduler's MC domain (all CPUs with same LLC) is going to be built via

  arch_topology.c::cpu_coregroup_mask()

In there we try to figure out a sensible mask out of the topology
information we have. In short, here we'll pick the smallest of NUMA or
core sibling mask.

  node_mask(CPU9)    == 0-9
  core_sibling(CPU9) == 0-15

MC mask for CPU9 will thus be 0-9, not a problem.

  node_mask(CPU10)    == 10-19
  core_sibling(CPU10) == 0-15

MC mask for CPU10 will thus be 10-19, not a problem.

  node_mask(CPU16)    == 10-19
  core_sibling(CPU16) == 16-19

MC mask for CPU16 will thus be 16-19... Uh oh. CPUs 16-19 are in two
different unique MC spans, and the scheduler has no idea what to make of
that. That triggers the WARN_ON() added by commit

  ccf74128d66c ("sched/topology: Assert non-NUMA topology masks don't (partially) overlap")

Fixing MPIDR-derived topology
=============================

We could try to come up with some cleverer scheme to figure out which of
the available masks to pick, but really if one of those masks resulted from
MPIDR then it should be discarded because it's bound to be bogus.

I was hoping to give MPIDR a chance for SMT, to figure out which threads are
in the same core using Aff1-3 as core ID, but Sudeep and Robin pointed out
to me that there are systems out there where *all* cores have non-zero
values in their higher affinity fields (e.g. RK3288 has "5" in all of its
cores' MPIDR.Aff1), which would expose a bogus core ID to userspace.

Stop using MPIDR for topology information. When no other source of topology
information is available, mark each CPU as its own core and its NUMA node
as its LLC domain.

Signed-off-by: Valentin Schneider <valentin.schneider@arm.com>
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Link: https://lore.kernel.org/r/20200829130016.26106-1-valentin.schneider@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/topology.c | 32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/kernel/topology.c b/arch/arm64/kernel/topology.c
index 0801a0f3c156a..ff1dd1dbfe641 100644
--- a/arch/arm64/kernel/topology.c
+++ b/arch/arm64/kernel/topology.c
@@ -36,21 +36,23 @@ void store_cpu_topology(unsigned int cpuid)
 	if (mpidr & MPIDR_UP_BITMASK)
 		return;
 
-	/* Create cpu topology mapping based on MPIDR. */
-	if (mpidr & MPIDR_MT_BITMASK) {
-		/* Multiprocessor system : Multi-threads per core */
-		cpuid_topo->thread_id  = MPIDR_AFFINITY_LEVEL(mpidr, 0);
-		cpuid_topo->core_id    = MPIDR_AFFINITY_LEVEL(mpidr, 1);
-		cpuid_topo->package_id = MPIDR_AFFINITY_LEVEL(mpidr, 2) |
-					 MPIDR_AFFINITY_LEVEL(mpidr, 3) << 8;
-	} else {
-		/* Multiprocessor system : Single-thread per core */
-		cpuid_topo->thread_id  = -1;
-		cpuid_topo->core_id    = MPIDR_AFFINITY_LEVEL(mpidr, 0);
-		cpuid_topo->package_id = MPIDR_AFFINITY_LEVEL(mpidr, 1) |
-					 MPIDR_AFFINITY_LEVEL(mpidr, 2) << 8 |
-					 MPIDR_AFFINITY_LEVEL(mpidr, 3) << 16;
-	}
+	/*
+	 * This would be the place to create cpu topology based on MPIDR.
+	 *
+	 * However, it cannot be trusted to depict the actual topology; some
+	 * pieces of the architecture enforce an artificial cap on Aff0 values
+	 * (e.g. GICv3's ICC_SGI1R_EL1 limits it to 15), leading to an
+	 * artificial cycling of Aff1, Aff2 and Aff3 values. IOW, these end up
+	 * having absolutely no relationship to the actual underlying system
+	 * topology, and cannot be reasonably used as core / package ID.
+	 *
+	 * If the MT bit is set, Aff0 *could* be used to define a thread ID, but
+	 * we still wouldn't be able to obtain a sane core ID. This means we
+	 * need to entirely ignore MPIDR for any topology deduction.
+	 */
+	cpuid_topo->thread_id  = -1;
+	cpuid_topo->core_id    = cpuid;
+	cpuid_topo->package_id = cpu_to_node(cpuid);
 
 	pr_debug("CPU%u: cluster %d core %d thread %d mpidr %#016llx\n",
 		 cpuid, cpuid_topo->package_id, cpuid_topo->core_id,
-- 
2.25.1

