Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ECB26E62E5
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231724AbjDRMg1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:36:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231721AbjDRMgZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:36:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 428A212C98
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:36:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C4AE463274
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:36:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF60CC433D2;
        Tue, 18 Apr 2023 12:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821380;
        bh=8pdVBxB+Vo7LGSUXbL+iVI2JYEzAHhf+qHjd9BINWW0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0FJOSfr8T6bjXfGhSXtbs7y43pWVdQ+BhNiEcW/qaJRf4wH8kZqkhh4aT4S3bD0in
         P49T7T2GyphSXJ0Bsaa5CSM/uW831mHWoNnCZdx6gH5Z5e4N17ETN4o13K7R66z6Gt
         x7YCDbqDQx/P9FCc72RM9KbM73TSxOODiqPZNz5M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 105/124] powerpc/pseries: Add support for FORM2 associativity
Date:   Tue, 18 Apr 2023 14:22:04 +0200
Message-Id: <20230418120313.637367536@linuxfoundation.org>
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

[ Upstream commit 1c6b5a7e74052768977855f95d6b8812f6e7772c ]

PAPR interface currently supports two different ways of communicating resource
grouping details to the OS. These are referred to as Form 0 and Form 1
associativity grouping. Form 0 is the older format and is now considered
deprecated. This patch adds another resource grouping named FORM2.

Signed-off-by: Daniel Henrique Barboza <danielhb413@gmail.com>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210812132223.225214-6-aneesh.kumar@linux.ibm.com
Stable-dep-of: b277fc793daf ("powerpc/papr_scm: Update the NUMA distance table for the target node")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/powerpc/associativity.rst   | 104 ++++++++++++
 arch/powerpc/include/asm/firmware.h       |   3 +-
 arch/powerpc/include/asm/prom.h           |   1 +
 arch/powerpc/kernel/prom_init.c           |   3 +-
 arch/powerpc/mm/numa.c                    | 187 ++++++++++++++++++----
 arch/powerpc/platforms/pseries/firmware.c |   1 +
 6 files changed, 262 insertions(+), 37 deletions(-)
 create mode 100644 Documentation/powerpc/associativity.rst

diff --git a/Documentation/powerpc/associativity.rst b/Documentation/powerpc/associativity.rst
new file mode 100644
index 0000000000000..07e7dd3d6c87e
--- /dev/null
+++ b/Documentation/powerpc/associativity.rst
@@ -0,0 +1,104 @@
+============================
+NUMA resource associativity
+=============================
+
+Associativity represents the groupings of the various platform resources into
+domains of substantially similar mean performance relative to resources outside
+of that domain. Resources subsets of a given domain that exhibit better
+performance relative to each other than relative to other resources subsets
+are represented as being members of a sub-grouping domain. This performance
+characteristic is presented in terms of NUMA node distance within the Linux kernel.
+From the platform view, these groups are also referred to as domains.
+
+PAPR interface currently supports different ways of communicating these resource
+grouping details to the OS. These are referred to as Form 0, Form 1 and Form2
+associativity grouping. Form 0 is the oldest format and is now considered deprecated.
+
+Hypervisor indicates the type/form of associativity used via "ibm,architecture-vec-5 property".
+Bit 0 of byte 5 in the "ibm,architecture-vec-5" property indicates usage of Form 0 or Form 1.
+A value of 1 indicates the usage of Form 1 associativity. For Form 2 associativity
+bit 2 of byte 5 in the "ibm,architecture-vec-5" property is used.
+
+Form 0
+-----
+Form 0 associativity supports only two NUMA distances (LOCAL and REMOTE).
+
+Form 1
+-----
+With Form 1 a combination of ibm,associativity-reference-points, and ibm,associativity
+device tree properties are used to determine the NUMA distance between resource groups/domains.
+
+The “ibm,associativity” property contains a list of one or more numbers (domainID)
+representing the resource’s platform grouping domains.
+
+The “ibm,associativity-reference-points” property contains a list of one or more numbers
+(domainID index) that represents the 1 based ordinal in the associativity lists.
+The list of domainID indexes represents an increasing hierarchy of resource grouping.
+
+ex:
+{ primary domainID index, secondary domainID index, tertiary domainID index.. }
+
+Linux kernel uses the domainID at the primary domainID index as the NUMA node id.
+Linux kernel computes NUMA distance between two domains by recursively comparing
+if they belong to the same higher-level domains. For mismatch at every higher
+level of the resource group, the kernel doubles the NUMA distance between the
+comparing domains.
+
+Form 2
+-------
+Form 2 associativity format adds separate device tree properties representing NUMA node distance
+thereby making the node distance computation flexible. Form 2 also allows flexible primary
+domain numbering. With numa distance computation now detached from the index value in
+"ibm,associativity-reference-points" property, Form 2 allows a large number of primary domain
+ids at the same domainID index representing resource groups of different performance/latency
+characteristics.
+
+Hypervisor indicates the usage of FORM2 associativity using bit 2 of byte 5 in the
+"ibm,architecture-vec-5" property.
+
+"ibm,numa-lookup-index-table" property contains a list of one or more numbers representing
+the domainIDs present in the system. The offset of the domainID in this property is
+used as an index while computing numa distance information via "ibm,numa-distance-table".
+
+prop-encoded-array: The number N of the domainIDs encoded as with encode-int, followed by
+N domainID encoded as with encode-int
+
+For ex:
+"ibm,numa-lookup-index-table" =  {4, 0, 8, 250, 252}. The offset of domainID 8 (2) is used when
+computing the distance of domain 8 from other domains present in the system. For the rest of
+this document, this offset will be referred to as domain distance offset.
+
+"ibm,numa-distance-table" property contains a list of one or more numbers representing the NUMA
+distance between resource groups/domains present in the system.
+
+prop-encoded-array: The number N of the distance values encoded as with encode-int, followed by
+N distance values encoded as with encode-bytes. The max distance value we could encode is 255.
+The number N must be equal to the square of m where m is the number of domainIDs in the
+numa-lookup-index-table.
+
+For ex:
+ibm,numa-lookup-index-table = <3 0 8 40>;
+ibm,numa-distace-table = <9>, /bits/ 8 < 10  20  80
+					 20  10 160
+					 80 160  10>;
+  | 0    8   40
+--|------------
+  |
+0 | 10   20  80
+  |
+8 | 20   10  160
+  |
+40| 80   160  10
+
+A possible "ibm,associativity" property for resources in node 0, 8 and 40
+
+{ 3, 6, 7, 0 }
+{ 3, 6, 9, 8 }
+{ 3, 6, 7, 40}
+
+With "ibm,associativity-reference-points"  { 0x3 }
+
+"ibm,lookup-index-table" helps in having a compact representation of distance matrix.
+Since domainID can be sparse, the matrix of distances can also be effectively sparse.
+With "ibm,lookup-index-table" we can achieve a compact representation of
+distance information.
diff --git a/arch/powerpc/include/asm/firmware.h b/arch/powerpc/include/asm/firmware.h
index 0cf648d829f15..89a31f1c7b118 100644
--- a/arch/powerpc/include/asm/firmware.h
+++ b/arch/powerpc/include/asm/firmware.h
@@ -53,6 +53,7 @@
 #define FW_FEATURE_ULTRAVISOR	ASM_CONST(0x0000004000000000)
 #define FW_FEATURE_STUFF_TCE	ASM_CONST(0x0000008000000000)
 #define FW_FEATURE_RPT_INVALIDATE ASM_CONST(0x0000010000000000)
+#define FW_FEATURE_FORM2_AFFINITY ASM_CONST(0x0000020000000000)
 
 #ifndef __ASSEMBLY__
 
@@ -73,7 +74,7 @@ enum {
 		FW_FEATURE_HPT_RESIZE | FW_FEATURE_DRMEM_V2 |
 		FW_FEATURE_DRC_INFO | FW_FEATURE_BLOCK_REMOVE |
 		FW_FEATURE_PAPR_SCM | FW_FEATURE_ULTRAVISOR |
-		FW_FEATURE_RPT_INVALIDATE,
+		FW_FEATURE_RPT_INVALIDATE | FW_FEATURE_FORM2_AFFINITY,
 	FW_FEATURE_PSERIES_ALWAYS = 0,
 	FW_FEATURE_POWERNV_POSSIBLE = FW_FEATURE_OPAL | FW_FEATURE_ULTRAVISOR,
 	FW_FEATURE_POWERNV_ALWAYS = 0,
diff --git a/arch/powerpc/include/asm/prom.h b/arch/powerpc/include/asm/prom.h
index df9fec9d232cb..5c80152e8f188 100644
--- a/arch/powerpc/include/asm/prom.h
+++ b/arch/powerpc/include/asm/prom.h
@@ -149,6 +149,7 @@ extern int of_read_drc_info_cell(struct property **prop,
 #define OV5_XCMO		0x0440	/* Page Coalescing */
 #define OV5_FORM1_AFFINITY	0x0580	/* FORM1 NUMA affinity */
 #define OV5_PRRN		0x0540	/* Platform Resource Reassignment */
+#define OV5_FORM2_AFFINITY	0x0520	/* Form2 NUMA affinity */
 #define OV5_HP_EVT		0x0604	/* Hot Plug Event support */
 #define OV5_RESIZE_HPT		0x0601	/* Hash Page Table resizing */
 #define OV5_PFO_HW_RNG		0x1180	/* PFO Random Number Generator */
diff --git a/arch/powerpc/kernel/prom_init.c b/arch/powerpc/kernel/prom_init.c
index a3bf3587a4162..6f7ad80763159 100644
--- a/arch/powerpc/kernel/prom_init.c
+++ b/arch/powerpc/kernel/prom_init.c
@@ -1069,7 +1069,8 @@ static const struct ibm_arch_vec ibm_architecture_vec_template __initconst = {
 #else
 		0,
 #endif
-		.associativity = OV5_FEAT(OV5_FORM1_AFFINITY) | OV5_FEAT(OV5_PRRN),
+		.associativity = OV5_FEAT(OV5_FORM1_AFFINITY) | OV5_FEAT(OV5_PRRN) |
+		OV5_FEAT(OV5_FORM2_AFFINITY),
 		.bin_opts = OV5_FEAT(OV5_RESIZE_HPT) | OV5_FEAT(OV5_HP_EVT),
 		.micro_checkpoint = 0,
 		.reserved0 = 0,
diff --git a/arch/powerpc/mm/numa.c b/arch/powerpc/mm/numa.c
index 010476abec344..cfc170935a58b 100644
--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -56,12 +56,17 @@ static int n_mem_addr_cells, n_mem_size_cells;
 
 #define FORM0_AFFINITY 0
 #define FORM1_AFFINITY 1
+#define FORM2_AFFINITY 2
 static int affinity_form;
 
 #define MAX_DISTANCE_REF_POINTS 4
 static int distance_ref_points_depth;
 static const __be32 *distance_ref_points;
 static int distance_lookup_table[MAX_NUMNODES][MAX_DISTANCE_REF_POINTS];
+static int numa_distance_table[MAX_NUMNODES][MAX_NUMNODES] = {
+	[0 ... MAX_NUMNODES - 1] = { [0 ... MAX_NUMNODES - 1] = -1 }
+};
+static int numa_id_index_table[MAX_NUMNODES] = { [0 ... MAX_NUMNODES - 1] = NUMA_NO_NODE };
 
 /*
  * Allocate node_to_cpumask_map based on number of available nodes
@@ -166,6 +171,54 @@ static void unmap_cpu_from_node(unsigned long cpu)
 }
 #endif /* CONFIG_HOTPLUG_CPU || CONFIG_PPC_SPLPAR */
 
+static int __associativity_to_nid(const __be32 *associativity,
+				  int max_array_sz)
+{
+	int nid;
+	/*
+	 * primary_domain_index is 1 based array index.
+	 */
+	int index = primary_domain_index  - 1;
+
+	if (!numa_enabled || index >= max_array_sz)
+		return NUMA_NO_NODE;
+
+	nid = of_read_number(&associativity[index], 1);
+
+	/* POWER4 LPAR uses 0xffff as invalid node */
+	if (nid == 0xffff || nid >= nr_node_ids)
+		nid = NUMA_NO_NODE;
+	return nid;
+}
+/*
+ * Returns nid in the range [0..nr_node_ids], or -1 if no useful NUMA
+ * info is found.
+ */
+static int associativity_to_nid(const __be32 *associativity)
+{
+	int array_sz = of_read_number(associativity, 1);
+
+	/* Skip the first element in the associativity array */
+	return __associativity_to_nid((associativity + 1), array_sz);
+}
+
+static int __cpu_form2_relative_distance(__be32 *cpu1_assoc, __be32 *cpu2_assoc)
+{
+	int dist;
+	int node1, node2;
+
+	node1 = associativity_to_nid(cpu1_assoc);
+	node2 = associativity_to_nid(cpu2_assoc);
+
+	dist = numa_distance_table[node1][node2];
+	if (dist <= LOCAL_DISTANCE)
+		return 0;
+	else if (dist <= REMOTE_DISTANCE)
+		return 1;
+	else
+		return 2;
+}
+
 static int __cpu_form1_relative_distance(__be32 *cpu1_assoc, __be32 *cpu2_assoc)
 {
 	int dist = 0;
@@ -186,8 +239,9 @@ int cpu_relative_distance(__be32 *cpu1_assoc, __be32 *cpu2_assoc)
 {
 	/* We should not get called with FORM0 */
 	VM_WARN_ON(affinity_form == FORM0_AFFINITY);
-
-	return __cpu_form1_relative_distance(cpu1_assoc, cpu2_assoc);
+	if (affinity_form == FORM1_AFFINITY)
+		return __cpu_form1_relative_distance(cpu1_assoc, cpu2_assoc);
+	return __cpu_form2_relative_distance(cpu1_assoc, cpu2_assoc);
 }
 
 /* must hold reference to node during call */
@@ -201,7 +255,9 @@ int __node_distance(int a, int b)
 	int i;
 	int distance = LOCAL_DISTANCE;
 
-	if (affinity_form == FORM0_AFFINITY)
+	if (affinity_form == FORM2_AFFINITY)
+		return numa_distance_table[a][b];
+	else if (affinity_form == FORM0_AFFINITY)
 		return ((a == b) ? LOCAL_DISTANCE : REMOTE_DISTANCE);
 
 	for (i = 0; i < distance_ref_points_depth; i++) {
@@ -216,37 +272,6 @@ int __node_distance(int a, int b)
 }
 EXPORT_SYMBOL(__node_distance);
 
-static int __associativity_to_nid(const __be32 *associativity,
-				  int max_array_sz)
-{
-	int nid;
-	/*
-	 * primary_domain_index is 1 based array index.
-	 */
-	int index = primary_domain_index  - 1;
-
-	if (!numa_enabled || index >= max_array_sz)
-		return NUMA_NO_NODE;
-
-	nid = of_read_number(&associativity[index], 1);
-
-	/* POWER4 LPAR uses 0xffff as invalid node */
-	if (nid == 0xffff || nid >= nr_node_ids)
-		nid = NUMA_NO_NODE;
-	return nid;
-}
-/*
- * Returns nid in the range [0..nr_node_ids], or -1 if no useful NUMA
- * info is found.
- */
-static int associativity_to_nid(const __be32 *associativity)
-{
-	int array_sz = of_read_number(associativity, 1);
-
-	/* Skip the first element in the associativity array */
-	return __associativity_to_nid((associativity + 1), array_sz);
-}
-
 /* Returns the nid associated with the given device tree node,
  * or -1 if not found.
  */
@@ -320,6 +345,8 @@ static void initialize_form1_numa_distance(const __be32 *associativity)
  */
 void update_numa_distance(struct device_node *node)
 {
+	int nid;
+
 	if (affinity_form == FORM0_AFFINITY)
 		return;
 	else if (affinity_form == FORM1_AFFINITY) {
@@ -332,6 +359,84 @@ void update_numa_distance(struct device_node *node)
 		initialize_form1_numa_distance(associativity);
 		return;
 	}
+
+	/* FORM2 affinity  */
+	nid = of_node_to_nid_single(node);
+	if (nid == NUMA_NO_NODE)
+		return;
+
+	/*
+	 * With FORM2 we expect NUMA distance of all possible NUMA
+	 * nodes to be provided during boot.
+	 */
+	WARN(numa_distance_table[nid][nid] == -1,
+	     "NUMA distance details for node %d not provided\n", nid);
+}
+
+/*
+ * ibm,numa-lookup-index-table= {N, domainid1, domainid2, ..... domainidN}
+ * ibm,numa-distance-table = { N, 1, 2, 4, 5, 1, 6, .... N elements}
+ */
+static void initialize_form2_numa_distance_lookup_table(void)
+{
+	int i, j;
+	struct device_node *root;
+	const __u8 *numa_dist_table;
+	const __be32 *numa_lookup_index;
+	int numa_dist_table_length;
+	int max_numa_index, distance_index;
+
+	if (firmware_has_feature(FW_FEATURE_OPAL))
+		root = of_find_node_by_path("/ibm,opal");
+	else
+		root = of_find_node_by_path("/rtas");
+	if (!root)
+		root = of_find_node_by_path("/");
+
+	numa_lookup_index = of_get_property(root, "ibm,numa-lookup-index-table", NULL);
+	max_numa_index = of_read_number(&numa_lookup_index[0], 1);
+
+	/* first element of the array is the size and is encode-int */
+	numa_dist_table = of_get_property(root, "ibm,numa-distance-table", NULL);
+	numa_dist_table_length = of_read_number((const __be32 *)&numa_dist_table[0], 1);
+	/* Skip the size which is encoded int */
+	numa_dist_table += sizeof(__be32);
+
+	pr_debug("numa_dist_table_len = %d, numa_dist_indexes_len = %d\n",
+		 numa_dist_table_length, max_numa_index);
+
+	for (i = 0; i < max_numa_index; i++)
+		/* +1 skip the max_numa_index in the property */
+		numa_id_index_table[i] = of_read_number(&numa_lookup_index[i + 1], 1);
+
+
+	if (numa_dist_table_length != max_numa_index * max_numa_index) {
+		WARN(1, "Wrong NUMA distance information\n");
+		/* consider everybody else just remote. */
+		for (i = 0;  i < max_numa_index; i++) {
+			for (j = 0; j < max_numa_index; j++) {
+				int nodeA = numa_id_index_table[i];
+				int nodeB = numa_id_index_table[j];
+
+				if (nodeA == nodeB)
+					numa_distance_table[nodeA][nodeB] = LOCAL_DISTANCE;
+				else
+					numa_distance_table[nodeA][nodeB] = REMOTE_DISTANCE;
+			}
+		}
+	}
+
+	distance_index = 0;
+	for (i = 0;  i < max_numa_index; i++) {
+		for (j = 0; j < max_numa_index; j++) {
+			int nodeA = numa_id_index_table[i];
+			int nodeB = numa_id_index_table[j];
+
+			numa_distance_table[nodeA][nodeB] = numa_dist_table[distance_index++];
+			pr_debug("dist[%d][%d]=%d ", nodeA, nodeB, numa_distance_table[nodeA][nodeB]);
+		}
+	}
+	of_node_put(root);
 }
 
 static int __init find_primary_domain_index(void)
@@ -344,6 +449,9 @@ static int __init find_primary_domain_index(void)
 	 */
 	if (firmware_has_feature(FW_FEATURE_OPAL)) {
 		affinity_form = FORM1_AFFINITY;
+	} else if (firmware_has_feature(FW_FEATURE_FORM2_AFFINITY)) {
+		dbg("Using form 2 affinity\n");
+		affinity_form = FORM2_AFFINITY;
 	} else if (firmware_has_feature(FW_FEATURE_FORM1_AFFINITY)) {
 		dbg("Using form 1 affinity\n");
 		affinity_form = FORM1_AFFINITY;
@@ -388,9 +496,12 @@ static int __init find_primary_domain_index(void)
 
 		index = of_read_number(&distance_ref_points[1], 1);
 	} else {
+		/*
+		 * Both FORM1 and FORM2 affinity find the primary domain details
+		 * at the same offset.
+		 */
 		index = of_read_number(distance_ref_points, 1);
 	}
-
 	/*
 	 * Warn and cap if the hardware supports more than
 	 * MAX_DISTANCE_REF_POINTS domains.
@@ -819,6 +930,12 @@ static int __init parse_numa_properties(void)
 
 	dbg("NUMA associativity depth for CPU/Memory: %d\n", primary_domain_index);
 
+	/*
+	 * If it is FORM2 initialize the distance table here.
+	 */
+	if (affinity_form == FORM2_AFFINITY)
+		initialize_form2_numa_distance_lookup_table();
+
 	/*
 	 * Even though we connect cpus to numa domains later in SMP
 	 * init, we need to know the node ids now. This is because
diff --git a/arch/powerpc/platforms/pseries/firmware.c b/arch/powerpc/platforms/pseries/firmware.c
index 5d4c2bc20bbab..f162156b7b68d 100644
--- a/arch/powerpc/platforms/pseries/firmware.c
+++ b/arch/powerpc/platforms/pseries/firmware.c
@@ -123,6 +123,7 @@ vec5_fw_features_table[] = {
 	{FW_FEATURE_PRRN,		OV5_PRRN},
 	{FW_FEATURE_DRMEM_V2,		OV5_DRMEM_V2},
 	{FW_FEATURE_DRC_INFO,		OV5_DRC_INFO},
+	{FW_FEATURE_FORM2_AFFINITY,	OV5_FORM2_AFFINITY},
 };
 
 static void __init fw_vec5_feature_init(const char *vec5, unsigned long len)
-- 
2.39.2



