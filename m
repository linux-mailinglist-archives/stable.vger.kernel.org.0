Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A95D66BA352
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 00:05:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231225AbjCNXFS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 19:05:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbjCNXFO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 19:05:14 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E31A27D68
        for <stable@vger.kernel.org>; Tue, 14 Mar 2023 16:05:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678835113; x=1710371113;
  h=from:to:cc:subject:date:message-id;
  bh=WrrhCRvdXc22LfrfW5RvmTwqb6i5r2ubwQSHJiMjvQE=;
  b=FbwoMY0c2zfYNWQZGEfEJzNaoO3RsdBcz9ZRkfDu3d3k0jad8m0qLtKf
   AI7uSRKq8+vu0lMYuBcItBHzkFHMkPsFo/QJfkNEFH4RwqXIYAB8eFOI2
   zldBr4u9Kkg28AUQlFIIGbJXz4qmxKmycBIAQgpIpCUbOERlBw7n+76i5
   U0U567cbaIEsPM28W2+kQyw0xpkCDxgN/OW7P6EJUa95OiAoJUDg8ClTM
   NH9S4hlOxBj+o0pmEqcyaKF9GU5hFnml3hlKnxZiLKq6dgeYFjlSYwpnP
   TqkYrkZQLfKLp0SWBlpY7zJA4rqSRl7/nwBvEkdBb0/oQpIjHgRtKTGWA
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="339925960"
X-IronPort-AV: E=Sophos;i="5.98,261,1673942400"; 
   d="scan'208";a="339925960"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 16:05:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="743481024"
X-IronPort-AV: E=Sophos;i="5.98,261,1673942400"; 
   d="scan'208";a="743481024"
Received: from ranerica-svr.sc.intel.com ([172.25.110.23])
  by fmsmga008.fm.intel.com with ESMTP; 14 Mar 2023 16:05:11 -0700
From:   Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
To:     x86@kernel.org
Cc:     Ricardo Neri <ricardo.neri@intel.com>,
        Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Len Brown <len.brown@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Zhang Rui <rui.zhang@intel.com>, Chen Yu <yu.c.chen@intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] x86/cacheinfo: Define per-CPU num_cache_leaves
Date:   Tue, 14 Mar 2023 16:15:19 -0700
Message-Id: <20230314231519.30119-1-ricardo.neri-calderon@linux.intel.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Make num_cache_leaves a per-CPU variable. Otherwise, populate_cache_
leaves() fails on systems with asymmetric number of subleaves in CPUID
leaf 0x4. Intel Meteor Lake is an example of such a system.

Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: Len Brown <len.brown@intel.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Chen Yu <yu.c.chen@intel.com>
Cc: stable@vger.kernel.org
Reviewed-by: Len Brown <len.brown@intel.com>
Signed-off-by: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
---
After this change, all CPUs will traverse CPUID leaf 0x4 when booted for
the first time. On systems with asymmetric cache topologies this is
useless work.

Creating a list of processor models that have asymmetric cache topologies
was considered. The burden of maintaining such list would outweigh the
performance benefit of skipping this extra step.
---
 arch/x86/kernel/cpu/cacheinfo.c | 48 ++++++++++++++++++++-------------
 1 file changed, 29 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kernel/cpu/cacheinfo.c b/arch/x86/kernel/cpu/cacheinfo.c
index 4063e8991211..6ad51657c853 100644
--- a/arch/x86/kernel/cpu/cacheinfo.c
+++ b/arch/x86/kernel/cpu/cacheinfo.c
@@ -176,7 +176,18 @@ struct _cpuid4_info_regs {
 	struct amd_northbridge *nb;
 };
 
-static unsigned short num_cache_leaves;
+static DEFINE_PER_CPU(unsigned short, num_cache_leaves);
+
+static inline unsigned short get_num_cache_leaves(unsigned int cpu)
+{
+	return per_cpu(num_cache_leaves, cpu);
+}
+
+static inline void
+set_num_cache_leaves(unsigned short nr_leaves, unsigned int cpu)
+{
+	per_cpu(num_cache_leaves, cpu) = nr_leaves;
+}
 
 /* AMD doesn't have CPUID4. Emulate it here to report the same
    information to the user.  This makes some assumptions about the machine:
@@ -716,19 +727,21 @@ void cacheinfo_hygon_init_llc_id(struct cpuinfo_x86 *c, int cpu)
 void init_amd_cacheinfo(struct cpuinfo_x86 *c)
 {
 
+	unsigned int cpu = c->cpu_index;
+
 	if (boot_cpu_has(X86_FEATURE_TOPOEXT)) {
-		num_cache_leaves = find_num_cache_leaves(c);
+		set_num_cache_leaves(find_num_cache_leaves(c), cpu);
 	} else if (c->extended_cpuid_level >= 0x80000006) {
 		if (cpuid_edx(0x80000006) & 0xf000)
-			num_cache_leaves = 4;
+			set_num_cache_leaves(4, cpu);
 		else
-			num_cache_leaves = 3;
+			set_num_cache_leaves(3, cpu);
 	}
 }
 
 void init_hygon_cacheinfo(struct cpuinfo_x86 *c)
 {
-	num_cache_leaves = find_num_cache_leaves(c);
+	set_num_cache_leaves(find_num_cache_leaves(c), c->cpu_index);
 }
 
 void init_intel_cacheinfo(struct cpuinfo_x86 *c)
@@ -738,24 +751,21 @@ void init_intel_cacheinfo(struct cpuinfo_x86 *c)
 	unsigned int new_l1d = 0, new_l1i = 0; /* Cache sizes from cpuid(4) */
 	unsigned int new_l2 = 0, new_l3 = 0, i; /* Cache sizes from cpuid(4) */
 	unsigned int l2_id = 0, l3_id = 0, num_threads_sharing, index_msb;
-#ifdef CONFIG_SMP
 	unsigned int cpu = c->cpu_index;
-#endif
 
 	if (c->cpuid_level > 3) {
-		static int is_initialized;
-
-		if (is_initialized == 0) {
-			/* Init num_cache_leaves from boot CPU */
-			num_cache_leaves = find_num_cache_leaves(c);
-			is_initialized++;
-		}
+		/*
+		 * There should be at least one leaf. A non-zero value means
+		 * that the number of leaves has been initialized.
+		 */
+		if (!get_num_cache_leaves(cpu))
+			set_num_cache_leaves(find_num_cache_leaves(c), cpu);
 
 		/*
 		 * Whenever possible use cpuid(4), deterministic cache
 		 * parameters cpuid leaf to find the cache details
 		 */
-		for (i = 0; i < num_cache_leaves; i++) {
+		for (i = 0; i < get_num_cache_leaves(cpu); i++) {
 			struct _cpuid4_info_regs this_leaf = {};
 			int retval;
 
@@ -791,14 +801,14 @@ void init_intel_cacheinfo(struct cpuinfo_x86 *c)
 	 * Don't use cpuid2 if cpuid4 is supported. For P4, we use cpuid2 for
 	 * trace cache
 	 */
-	if ((num_cache_leaves == 0 || c->x86 == 15) && c->cpuid_level > 1) {
+	if ((!get_num_cache_leaves(cpu) || c->x86 == 15) && c->cpuid_level > 1) {
 		/* supports eax=2  call */
 		int j, n;
 		unsigned int regs[4];
 		unsigned char *dp = (unsigned char *)regs;
 		int only_trace = 0;
 
-		if (num_cache_leaves != 0 && c->x86 == 15)
+		if (get_num_cache_leaves(cpu) && c->x86 == 15)
 			only_trace = 1;
 
 		/* Number of times to iterate */
@@ -1000,12 +1010,12 @@ int init_cache_level(unsigned int cpu)
 {
 	struct cpu_cacheinfo *this_cpu_ci = get_cpu_cacheinfo(cpu);
 
-	if (!num_cache_leaves)
+	if (!get_num_cache_leaves(cpu))
 		return -ENOENT;
 	if (!this_cpu_ci)
 		return -EINVAL;
 	this_cpu_ci->num_levels = 3;
-	this_cpu_ci->num_leaves = num_cache_leaves;
+	this_cpu_ci->num_leaves = get_num_cache_leaves(cpu);
 	return 0;
 }
 
-- 
2.25.1

