Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB8D06E62E3
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231250AbjDRMgX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:36:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231723AbjDRMgV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:36:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C81DA12C80
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:36:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 630E063293
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:36:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 712EAC433D2;
        Tue, 18 Apr 2023 12:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821374;
        bh=bFCR90D9R1DGi9EikGU2LzfzpqWvFGUinT+2IYv4ic0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PUN99qVKy4ftBYMcO8rMGb/726z/XG3yV0Kt3DiL17gCFNiq4R9qAxgug3p4ca6sa
         sYkzrBkEixMbeYvEWMvHyzUd9E0InVXSx5v1/3YpYl6orG18+yila6OcY8stcAFqAf
         aCskbDuKKaG6OAPoITZuCCRmEJwsn6BxAC/Scx2A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 103/124] powerpc/pseries: Consolidate different NUMA distance update code paths
Date:   Tue, 18 Apr 2023 14:22:02 +0200
Message-Id: <20230418120313.580302068@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120309.539243408@linuxfoundation.org>
References: <20230418120309.539243408@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>

[ Upstream commit 8ddc6448ec5a5ef50eaa581a7dec0e12a02850ff ]

The associativity details of the newly added resourced are collected from
the hypervisor via "ibm,configure-connector" rtas call. Update the numa
distance details of the newly added numa node after the above call.

Instead of updating NUMA distance every time we lookup a node id
from the associativity property, add helpers that can be used
during boot which does this only once. Also remove the distance
update from node id lookup helpers.

Currently, we duplicate parsing code for ibm,associativity and
ibm,associativity-lookup-arrays in the kernel. The associativity array provided
by these device tree properties are very similar and hence can use
a helper to parse the node id and numa distance details.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210812132223.225214-4-aneesh.kumar@linux.ibm.com
Stable-dep-of: b277fc793daf ("powerpc/papr_scm: Update the NUMA distance table for the target node")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/topology.h           |   2 +
 arch/powerpc/mm/numa.c                        | 212 +++++++++++++-----
 arch/powerpc/platforms/pseries/hotplug-cpu.c  |   2 +
 .../platforms/pseries/hotplug-memory.c        |   2 +
 4 files changed, 161 insertions(+), 57 deletions(-)

diff --git a/arch/powerpc/include/asm/topology.h b/arch/powerpc/include/asm/topology.h
index 3beeb030cd78e..1604920d8d2de 100644
--- a/arch/powerpc/include/asm/topology.h
+++ b/arch/powerpc/include/asm/topology.h
@@ -64,6 +64,7 @@ static inline int early_cpu_to_node(int cpu)
 }
 
 int of_drconf_to_nid_single(struct drmem_lmb *lmb);
+void update_numa_distance(struct device_node *node);
 
 #else
 
@@ -93,6 +94,7 @@ static inline int of_drconf_to_nid_single(struct drmem_lmb *lmb)
 	return first_online_node;
 }
 
+static inline void update_numa_distance(struct device_node *node) {}
 #endif /* CONFIG_NUMA */
 
 #if defined(CONFIG_NUMA) && defined(CONFIG_PPC_SPLPAR)
diff --git a/arch/powerpc/mm/numa.c b/arch/powerpc/mm/numa.c
index 415cd3d258ff8..e61593ae25c9e 100644
--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -208,50 +208,35 @@ int __node_distance(int a, int b)
 }
 EXPORT_SYMBOL(__node_distance);
 
-static void initialize_distance_lookup_table(int nid,
-		const __be32 *associativity)
+static int __associativity_to_nid(const __be32 *associativity,
+				  int max_array_sz)
 {
-	int i;
+	int nid;
+	/*
+	 * primary_domain_index is 1 based array index.
+	 */
+	int index = primary_domain_index  - 1;
 
-	if (affinity_form != FORM1_AFFINITY)
-		return;
+	if (!numa_enabled || index >= max_array_sz)
+		return NUMA_NO_NODE;
 
-	for (i = 0; i < distance_ref_points_depth; i++) {
-		const __be32 *entry;
+	nid = of_read_number(&associativity[index], 1);
 
-		entry = &associativity[be32_to_cpu(distance_ref_points[i]) - 1];
-		distance_lookup_table[nid][i] = of_read_number(entry, 1);
-	}
+	/* POWER4 LPAR uses 0xffff as invalid node */
+	if (nid == 0xffff || nid >= nr_node_ids)
+		nid = NUMA_NO_NODE;
+	return nid;
 }
-
 /*
  * Returns nid in the range [0..nr_node_ids], or -1 if no useful NUMA
  * info is found.
  */
 static int associativity_to_nid(const __be32 *associativity)
 {
-	int nid = NUMA_NO_NODE;
-
-	if (!numa_enabled)
-		goto out;
-
-	if (of_read_number(associativity, 1) >= primary_domain_index)
-		nid = of_read_number(&associativity[primary_domain_index], 1);
-
-	/* POWER4 LPAR uses 0xffff as invalid node */
-	if (nid == 0xffff || nid >= nr_node_ids)
-		nid = NUMA_NO_NODE;
-
-	if (nid > 0 &&
-		of_read_number(associativity, 1) >= distance_ref_points_depth) {
-		/*
-		 * Skip the length field and send start of associativity array
-		 */
-		initialize_distance_lookup_table(nid, associativity + 1);
-	}
+	int array_sz = of_read_number(associativity, 1);
 
-out:
-	return nid;
+	/* Skip the first element in the associativity array */
+	return __associativity_to_nid((associativity + 1), array_sz);
 }
 
 /* Returns the nid associated with the given device tree node,
@@ -287,6 +272,60 @@ int of_node_to_nid(struct device_node *device)
 }
 EXPORT_SYMBOL(of_node_to_nid);
 
+static void __initialize_form1_numa_distance(const __be32 *associativity,
+					     int max_array_sz)
+{
+	int i, nid;
+
+	if (affinity_form != FORM1_AFFINITY)
+		return;
+
+	nid = __associativity_to_nid(associativity, max_array_sz);
+	if (nid != NUMA_NO_NODE) {
+		for (i = 0; i < distance_ref_points_depth; i++) {
+			const __be32 *entry;
+			int index = be32_to_cpu(distance_ref_points[i]) - 1;
+
+			/*
+			 * broken hierarchy, return with broken distance table
+			 */
+			if (WARN(index >= max_array_sz, "Broken ibm,associativity property"))
+				return;
+
+			entry = &associativity[index];
+			distance_lookup_table[nid][i] = of_read_number(entry, 1);
+		}
+	}
+}
+
+static void initialize_form1_numa_distance(const __be32 *associativity)
+{
+	int array_sz;
+
+	array_sz = of_read_number(associativity, 1);
+	/* Skip the first element in the associativity array */
+	__initialize_form1_numa_distance(associativity + 1, array_sz);
+}
+
+/*
+ * Used to update distance information w.r.t newly added node.
+ */
+void update_numa_distance(struct device_node *node)
+{
+	if (affinity_form == FORM0_AFFINITY)
+		return;
+	else if (affinity_form == FORM1_AFFINITY) {
+		const __be32 *associativity;
+
+		associativity = of_get_associativity(node);
+		if (!associativity)
+			return;
+
+		initialize_form1_numa_distance(associativity);
+		return;
+	}
+}
+
 static int __init find_primary_domain_index(void)
 {
 	int index;
@@ -433,6 +472,38 @@ static int of_get_assoc_arrays(struct assoc_arrays *aa)
 	return 0;
 }
 
+static int get_nid_and_numa_distance(struct drmem_lmb *lmb)
+{
+	struct assoc_arrays aa = { .arrays = NULL };
+	int default_nid = NUMA_NO_NODE;
+	int nid = default_nid;
+	int rc, index;
+
+	if ((primary_domain_index < 0) || !numa_enabled)
+		return default_nid;
+
+	rc = of_get_assoc_arrays(&aa);
+	if (rc)
+		return default_nid;
+
+	if (primary_domain_index <= aa.array_sz &&
+	    !(lmb->flags & DRCONF_MEM_AI_INVALID) && lmb->aa_index < aa.n_arrays) {
+		const __be32 *associativity;
+
+		index = lmb->aa_index * aa.array_sz;
+		associativity = &aa.arrays[index];
+		nid = __associativity_to_nid(associativity, aa.array_sz);
+		if (nid > 0 && affinity_form == FORM1_AFFINITY) {
+			/*
+			 * lookup array associativity entries have
+			 * no length of the array as the first element.
+			 */
+			__initialize_form1_numa_distance(associativity, aa.array_sz);
+		}
+	}
+	return nid;
+}
+
 /*
  * This is like of_node_to_nid_single() for memory represented in the
  * ibm,dynamic-reconfiguration-memory node.
@@ -453,26 +524,19 @@ int of_drconf_to_nid_single(struct drmem_lmb *lmb)
 
 	if (primary_domain_index <= aa.array_sz &&
 	    !(lmb->flags & DRCONF_MEM_AI_INVALID) && lmb->aa_index < aa.n_arrays) {
-		index = lmb->aa_index * aa.array_sz + primary_domain_index - 1;
-		nid = of_read_number(&aa.arrays[index], 1);
-
-		if (nid == 0xffff || nid >= nr_node_ids)
-			nid = default_nid;
+		const __be32 *associativity;
 
-		if (nid > 0) {
-			index = lmb->aa_index * aa.array_sz;
-			initialize_distance_lookup_table(nid,
-							&aa.arrays[index]);
-		}
+		index = lmb->aa_index * aa.array_sz;
+		associativity = &aa.arrays[index];
+		nid = __associativity_to_nid(associativity, aa.array_sz);
 	}
-
 	return nid;
 }
 
 #ifdef CONFIG_PPC_SPLPAR
-static int vphn_get_nid(long lcpu)
+
+static int __vphn_get_associativity(long lcpu, __be32 *associativity)
 {
-	__be32 associativity[VPHN_ASSOC_BUFSIZE] = {0};
 	long rc, hwid;
 
 	/*
@@ -492,12 +556,30 @@ static int vphn_get_nid(long lcpu)
 
 		rc = hcall_vphn(hwid, VPHN_FLAG_VCPU, associativity);
 		if (rc == H_SUCCESS)
-			return associativity_to_nid(associativity);
+			return 0;
 	}
 
+	return -1;
+}
+
+static int vphn_get_nid(long lcpu)
+{
+	__be32 associativity[VPHN_ASSOC_BUFSIZE] = {0};
+
+
+	if (!__vphn_get_associativity(lcpu, associativity))
+		return associativity_to_nid(associativity);
+
 	return NUMA_NO_NODE;
+
 }
 #else
+
+static int __vphn_get_associativity(long lcpu, __be32 *associativity)
+{
+	return -1;
+}
+
 static int vphn_get_nid(long unused)
 {
 	return NUMA_NO_NODE;
@@ -692,7 +774,7 @@ static int __init numa_setup_drmem_lmb(struct drmem_lmb *lmb,
 			size = read_n_cells(n_mem_size_cells, usm);
 		}
 
-		nid = of_drconf_to_nid_single(lmb);
+		nid = get_nid_and_numa_distance(lmb);
 		fake_numa_create_new_node(((base + size) >> PAGE_SHIFT),
 					  &nid);
 		node_set_online(nid);
@@ -709,6 +791,7 @@ static int __init parse_numa_properties(void)
 	struct device_node *memory;
 	int default_nid = 0;
 	unsigned long i;
+	const __be32 *associativity;
 
 	if (numa_enabled == 0) {
 		printk(KERN_WARNING "NUMA disabled by user\n");
@@ -734,18 +817,30 @@ static int __init parse_numa_properties(void)
 	 * each node to be onlined must have NODE_DATA etc backing it.
 	 */
 	for_each_present_cpu(i) {
+		__be32 vphn_assoc[VPHN_ASSOC_BUFSIZE];
 		struct device_node *cpu;
-		int nid = vphn_get_nid(i);
+		int nid = NUMA_NO_NODE;
 
-		/*
-		 * Don't fall back to default_nid yet -- we will plug
-		 * cpus into nodes once the memory scan has discovered
-		 * the topology.
-		 */
-		if (nid == NUMA_NO_NODE) {
+		memset(vphn_assoc, 0, VPHN_ASSOC_BUFSIZE * sizeof(__be32));
+
+		if (__vphn_get_associativity(i, vphn_assoc) == 0) {
+			nid = associativity_to_nid(vphn_assoc);
+			initialize_form1_numa_distance(vphn_assoc);
+		} else {
+
+			/*
+			 * Don't fall back to default_nid yet -- we will plug
+			 * cpus into nodes once the memory scan has discovered
+			 * the topology.
+			 */
 			cpu = of_get_cpu_node(i, NULL);
 			BUG_ON(!cpu);
-			nid = of_node_to_nid_single(cpu);
+
+			associativity = of_get_associativity(cpu);
+			if (associativity) {
+				nid = associativity_to_nid(associativity);
+				initialize_form1_numa_distance(associativity);
+			}
 			of_node_put(cpu);
 		}
 
@@ -783,8 +878,11 @@ static int __init parse_numa_properties(void)
 		 * have associativity properties.  If none, then
 		 * everything goes to default_nid.
 		 */
-		nid = of_node_to_nid_single(memory);
-		if (nid < 0)
+		associativity = of_get_associativity(memory);
+		if (associativity) {
+			nid = associativity_to_nid(associativity);
+			initialize_form1_numa_distance(associativity);
+		} else
 			nid = default_nid;
 
 		fake_numa_create_new_node(((start + size) >> PAGE_SHIFT), &nid);
diff --git a/arch/powerpc/platforms/pseries/hotplug-cpu.c b/arch/powerpc/platforms/pseries/hotplug-cpu.c
index 325f3b220f360..1f8f97210d143 100644
--- a/arch/powerpc/platforms/pseries/hotplug-cpu.c
+++ b/arch/powerpc/platforms/pseries/hotplug-cpu.c
@@ -484,6 +484,8 @@ static ssize_t dlpar_cpu_add(u32 drc_index)
 		return saved_rc;
 	}
 
+	update_numa_distance(dn);
+
 	rc = dlpar_online_cpu(dn);
 	if (rc) {
 		saved_rc = rc;
diff --git a/arch/powerpc/platforms/pseries/hotplug-memory.c b/arch/powerpc/platforms/pseries/hotplug-memory.c
index 7efe6ec5d14a4..a5f968b5fa3a8 100644
--- a/arch/powerpc/platforms/pseries/hotplug-memory.c
+++ b/arch/powerpc/platforms/pseries/hotplug-memory.c
@@ -180,6 +180,8 @@ static int update_lmb_associativity_index(struct drmem_lmb *lmb)
 		return -ENODEV;
 	}
 
+	update_numa_distance(lmb_node);
+
 	dr_node = of_find_node_by_path("/ibm,dynamic-reconfiguration-memory");
 	if (!dr_node) {
 		dlpar_free_cc_nodes(lmb_node);
-- 
2.39.2



