Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EF9637C716
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:58:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234284AbhELP6I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:58:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:50860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232343AbhELPvH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:51:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0620561982;
        Wed, 12 May 2021 15:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833169;
        bh=IYgTNI9KVnkzuftttWP08pk/008Q/PI8FqEP+Jouq74=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=014xnwlb83EVZQUOLNsr8WG2h8EngjlOPQgqtdfW3i9H0q979/tFHwE4pJAi45Cav
         h27hS38R9RAc0doEbkR1ryRtyPVtN0MoxnNUNg9OX6DZroFS9hxwnaITJ8rK5oXQFJ
         poSVeD4RAPPM5H0hgm1zYBGL/v/FgErOhlEGIAMc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Alison Schofield <alison.schofield@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH 5.11 046/601] x86, sched: Treat Intel SNC topology as default, COD as exception
Date:   Wed, 12 May 2021 16:42:03 +0200
Message-Id: <20210512144829.339860005@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alison Schofield <alison.schofield@intel.com>

commit 2c88d45edbb89029c1190bb3b136d2602f057c98 upstream.

Commit 1340ccfa9a9a ("x86,sched: Allow topologies where NUMA nodes
share an LLC") added a vendor and model specific check to never
call topology_sane() for Intel Skylake Server systems where NUMA
nodes share an LLC.

Intel Ice Lake and Sapphire Rapids CPUs also enumerate an LLC that is
shared by multiple NUMA nodes. The LLC on these CPUs is shared for
off-package data access but private to the NUMA node for on-package
access. Rather than managing a list of allowable SNC topologies, make
this SNC topology the default, and treat Intel's Cluster-On-Die (COD)
topology as the exception.

In SNC mode, Sky Lake, Ice Lake, and Sapphire Rapids servers do not
emit this warning:

sched: CPU #3's llc-sibling CPU #0 is not on the same node! [node: 1 != 0]. Ignoring dependency.

Suggested-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20210310190233.31752-1-alison.schofield@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/smpboot.c |   90 +++++++++++++++++++++++-----------------------
 1 file changed, 46 insertions(+), 44 deletions(-)

--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -458,29 +458,52 @@ static bool match_smt(struct cpuinfo_x86
 	return false;
 }
 
+static bool match_die(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
+{
+	if (c->phys_proc_id == o->phys_proc_id &&
+	    c->cpu_die_id == o->cpu_die_id)
+		return true;
+	return false;
+}
+
 /*
- * Define snc_cpu[] for SNC (Sub-NUMA Cluster) CPUs.
+ * Unlike the other levels, we do not enforce keeping a
+ * multicore group inside a NUMA node.  If this happens, we will
+ * discard the MC level of the topology later.
+ */
+static bool match_pkg(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
+{
+	if (c->phys_proc_id == o->phys_proc_id)
+		return true;
+	return false;
+}
+
+/*
+ * Define intel_cod_cpu[] for Intel COD (Cluster-on-Die) CPUs.
  *
- * These are Intel CPUs that enumerate an LLC that is shared by
- * multiple NUMA nodes. The LLC on these systems is shared for
- * off-package data access but private to the NUMA node (half
- * of the package) for on-package access.
+ * Any Intel CPU that has multiple nodes per package and does not
+ * match intel_cod_cpu[] has the SNC (Sub-NUMA Cluster) topology.
  *
- * CPUID (the source of the information about the LLC) can only
- * enumerate the cache as being shared *or* unshared, but not
- * this particular configuration. The CPU in this case enumerates
- * the cache to be shared across the entire package (spanning both
- * NUMA nodes).
+ * When in SNC mode, these CPUs enumerate an LLC that is shared
+ * by multiple NUMA nodes. The LLC is shared for off-package data
+ * access but private to the NUMA node (half of the package) for
+ * on-package access. CPUID (the source of the information about
+ * the LLC) can only enumerate the cache as shared or unshared,
+ * but not this particular configuration.
  */
 
-static const struct x86_cpu_id snc_cpu[] = {
-	X86_MATCH_INTEL_FAM6_MODEL(SKYLAKE_X, NULL),
+static const struct x86_cpu_id intel_cod_cpu[] = {
+	X86_MATCH_INTEL_FAM6_MODEL(HASWELL_X, 0),	/* COD */
+	X86_MATCH_INTEL_FAM6_MODEL(BROADWELL_X, 0),	/* COD */
+	X86_MATCH_INTEL_FAM6_MODEL(ANY, 1),		/* SNC */
 	{}
 };
 
 static bool match_llc(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
 {
+	const struct x86_cpu_id *id = x86_match_cpu(intel_cod_cpu);
 	int cpu1 = c->cpu_index, cpu2 = o->cpu_index;
+	bool intel_snc = id && id->driver_data;
 
 	/* Do not match if we do not have a valid APICID for cpu: */
 	if (per_cpu(cpu_llc_id, cpu1) == BAD_APICID)
@@ -495,32 +518,12 @@ static bool match_llc(struct cpuinfo_x86
 	 * means 'c' does not share the LLC of 'o'. This will be
 	 * reflected to userspace.
 	 */
-	if (!topology_same_node(c, o) && x86_match_cpu(snc_cpu))
+	if (match_pkg(c, o) && !topology_same_node(c, o) && intel_snc)
 		return false;
 
 	return topology_sane(c, o, "llc");
 }
 
-/*
- * Unlike the other levels, we do not enforce keeping a
- * multicore group inside a NUMA node.  If this happens, we will
- * discard the MC level of the topology later.
- */
-static bool match_pkg(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
-{
-	if (c->phys_proc_id == o->phys_proc_id)
-		return true;
-	return false;
-}
-
-static bool match_die(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
-{
-	if ((c->phys_proc_id == o->phys_proc_id) &&
-		(c->cpu_die_id == o->cpu_die_id))
-		return true;
-	return false;
-}
-
 
 #if defined(CONFIG_SCHED_SMT) || defined(CONFIG_SCHED_MC)
 static inline int x86_sched_itmt_flags(void)
@@ -592,14 +595,23 @@ void set_cpu_sibling_map(int cpu)
 	for_each_cpu(i, cpu_sibling_setup_mask) {
 		o = &cpu_data(i);
 
+		if (match_pkg(c, o) && !topology_same_node(c, o))
+			x86_has_numa_in_package = true;
+
 		if ((i == cpu) || (has_smt && match_smt(c, o)))
 			link_mask(topology_sibling_cpumask, cpu, i);
 
 		if ((i == cpu) || (has_mp && match_llc(c, o)))
 			link_mask(cpu_llc_shared_mask, cpu, i);
 
+		if ((i == cpu) || (has_mp && match_die(c, o)))
+			link_mask(topology_die_cpumask, cpu, i);
 	}
 
+	threads = cpumask_weight(topology_sibling_cpumask(cpu));
+	if (threads > __max_smt_threads)
+		__max_smt_threads = threads;
+
 	/*
 	 * This needs a separate iteration over the cpus because we rely on all
 	 * topology_sibling_cpumask links to be set-up.
@@ -613,8 +625,7 @@ void set_cpu_sibling_map(int cpu)
 			/*
 			 *  Does this new cpu bringup a new core?
 			 */
-			if (cpumask_weight(
-			    topology_sibling_cpumask(cpu)) == 1) {
+			if (threads == 1) {
 				/*
 				 * for each core in package, increment
 				 * the booted_cores for this new cpu
@@ -631,16 +642,7 @@ void set_cpu_sibling_map(int cpu)
 			} else if (i != cpu && !c->booted_cores)
 				c->booted_cores = cpu_data(i).booted_cores;
 		}
-		if (match_pkg(c, o) && !topology_same_node(c, o))
-			x86_has_numa_in_package = true;
-
-		if ((i == cpu) || (has_mp && match_die(c, o)))
-			link_mask(topology_die_cpumask, cpu, i);
 	}
-
-	threads = cpumask_weight(topology_sibling_cpumask(cpu));
-	if (threads > __max_smt_threads)
-		__max_smt_threads = threads;
 }
 
 /* maps the cpu to the sched domain representing multi-core */


