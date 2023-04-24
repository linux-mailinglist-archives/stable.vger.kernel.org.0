Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0382E6EC341
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 02:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbjDXARO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Apr 2023 20:17:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbjDXARN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Apr 2023 20:17:13 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EF5794;
        Sun, 23 Apr 2023 17:17:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682295431; x=1713831431;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=/FwfvdilZ1y10bo98zmMqAo6SyCOKge7Mha+KtjYw10=;
  b=efj7+MvYs8mNmk8TnDqGoX16aGEb2r9ec48ZpXzPZrMA1NH+9ULC6vKf
   j/ziF6/ebpd2t9iIAPyVBmQDJmOAoiGXQEH3dj1IfJbca4ZMS2jzu4mmq
   u8KUkpyK8E0WMHxirRPX5mR+tg6ZVSbJCqlEvUyOgoyQ8xJ+h6oA2QyFo
   TZnYGzWQWqjfetGOrec6GdqSaPFR6eq45W1doij7U+djHQEGwpghfOjNJ
   kS0F7cXzr+4Je+TOkE4pVDIi/UBgxnSVSn8wVMOIB9jfzM/On5cSeIGeh
   tNLJx3eDJ4rnuEbb40Na0Cs0V6RMPzClzCS5LSg5fcGU/NSA11DY4S4cE
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10689"; a="411605278"
X-IronPort-AV: E=Sophos;i="5.99,221,1677571200"; 
   d="scan'208";a="411605278"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2023 17:17:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10689"; a="1022502122"
X-IronPort-AV: E=Sophos;i="5.99,221,1677571200"; 
   d="scan'208";a="1022502122"
Received: from ranerica-svr.sc.intel.com ([172.25.110.23])
  by fmsmga005.fm.intel.com with ESMTP; 23 Apr 2023 17:17:09 -0700
From:   Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
To:     x86@kernel.org
Cc:     Andreas Herrmann <aherrmann@suse.com>,
        Chen Yu <yu.c.chen@intel.com>, Len Brown <len.brown@intel.com>,
        Pu Wen <puwen@hygon.cn>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Ricardo Neri <ricardo.neri@intel.com>,
        linux-kernel@vger.kernel.org,
        Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH v2 1/2] x86/cacheinfo: Delete global num_cache_leaves
Date:   Sun, 23 Apr 2023 17:19:55 -0700
Message-Id: <20230424001956.21434-2-ricardo.neri-calderon@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230424001956.21434-1-ricardo.neri-calderon@linux.intel.com>
References: <20230424001956.21434-1-ricardo.neri-calderon@linux.intel.com>
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Linux remembers cpu_cachinfo::num_leaves per CPU, but x86 initializes all
CPUs from the same global "num_cache_leaves".

This is erroneous on systems like Meteor Lake, which has different
num_leaves per CPU. Delete the global "num_cache_leaves" and initialize
num_leaves accurately on each CPU.

Cc: Andreas Herrmann <aherrmann@suse.com>
Cc: Chen Yu <yu.c.chen@intel.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Pu Wen <puwen@hygon.cn>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: Zhang Rui <rui.zhang@intel.com>
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
Changes since v1:
 * Do not make num_cache_leaves a per-CPU variable. Instead, reuse the
   existing per-CPU ci_cpu_cacheinfo variable. (Dave Hansen)
---
 arch/x86/kernel/cpu/cacheinfo.c | 45 ++++++++++++++++++---------------
 1 file changed, 25 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kernel/cpu/cacheinfo.c b/arch/x86/kernel/cpu/cacheinfo.c
index 4063e8991211..45c4e9daf3f1 100644
--- a/arch/x86/kernel/cpu/cacheinfo.c
+++ b/arch/x86/kernel/cpu/cacheinfo.c
@@ -176,7 +176,16 @@ struct _cpuid4_info_regs {
 	struct amd_northbridge *nb;
 };
 
-static unsigned short num_cache_leaves;
+static inline unsigned int get_num_cache_leaves(unsigned int cpu)
+{
+	return get_cpu_cacheinfo(cpu)->num_leaves;
+}
+
+static inline void
+set_num_cache_leaves(unsigned int nr_leaves, unsigned int cpu)
+{
+	get_cpu_cacheinfo(cpu)->num_leaves = nr_leaves;
+}
 
 /* AMD doesn't have CPUID4. Emulate it here to report the same
    information to the user.  This makes some assumptions about the machine:
@@ -716,19 +725,21 @@ void cacheinfo_hygon_init_llc_id(struct cpuinfo_x86 *c, int cpu)
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
@@ -738,24 +749,21 @@ void init_intel_cacheinfo(struct cpuinfo_x86 *c)
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
 
@@ -791,14 +799,14 @@ void init_intel_cacheinfo(struct cpuinfo_x86 *c)
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
@@ -1000,12 +1008,9 @@ int init_cache_level(unsigned int cpu)
 {
 	struct cpu_cacheinfo *this_cpu_ci = get_cpu_cacheinfo(cpu);
 
-	if (!num_cache_leaves)
-		return -ENOENT;
 	if (!this_cpu_ci)
 		return -EINVAL;
 	this_cpu_ci->num_levels = 3;
-	this_cpu_ci->num_leaves = num_cache_leaves;
 	return 0;
 }
 
-- 
2.25.1

