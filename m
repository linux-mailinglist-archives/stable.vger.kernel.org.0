Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 614E16E9050
	for <lists+stable@lfdr.de>; Thu, 20 Apr 2023 12:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234893AbjDTKeZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Apr 2023 06:34:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231936AbjDTKeB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Apr 2023 06:34:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3357137;
        Thu, 20 Apr 2023 03:31:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3595B61158;
        Thu, 20 Apr 2023 10:31:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E3C7C433EF;
        Thu, 20 Apr 2023 10:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681986706;
        bh=9nTyhdmLiWflGBmxQBz57p2XPHYStxdXZ6DFC2P8okM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XpEmGUEL9aksyGXsgJOIT00wcQ1JTFEOOwBAyyz0hvCmRJhpP0BV5JIbFrMHVMWUF
         9lkub8YGFH94M+5jZLH8oYSG31efPvzuBzJN5iup4Srm24HUWIBprO4ehE8zwCO32i
         7+z79aidKBEj/NcFI6r2h0oiC0HPR8xOovWNOWrs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.10.178
Date:   Thu, 20 Apr 2023 12:31:35 +0200
Message-Id: <2023042034-varied-bubbly-11e3@gregkh>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <2023042034-unicycle-copious-d453@gregkh>
References: <2023042034-unicycle-copious-d453@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Documentation/devicetree/bindings/serial/renesas,scif.yaml b/Documentation/devicetree/bindings/serial/renesas,scif.yaml
index eda3d2c6bdd3..dbaa04380209 100644
--- a/Documentation/devicetree/bindings/serial/renesas,scif.yaml
+++ b/Documentation/devicetree/bindings/serial/renesas,scif.yaml
@@ -74,7 +74,7 @@ properties:
           - description: Error interrupt
           - description: Receive buffer full interrupt
           - description: Transmit buffer empty interrupt
-          - description: Transmit End interrupt
+          - description: Break interrupt
       - items:
           - description: Error interrupt
           - description: Receive buffer full interrupt
@@ -89,7 +89,7 @@ properties:
           - const: eri
           - const: rxi
           - const: txi
-          - const: tei
+          - const: bri
       - items:
           - const: eri
           - const: rxi
diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 0158dff63887..df26cf4110ef 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -272,6 +272,8 @@ tcp_app_win - INTEGER
 	Reserve max(window/2^tcp_app_win, mss) of window for application
 	buffer. Value 0 is special, it means that nothing is reserved.
 
+	Possible values are [0, 31], inclusive.
+
 	Default: 31
 
 tcp_autocorking - BOOLEAN
diff --git a/Documentation/powerpc/associativity.rst b/Documentation/powerpc/associativity.rst
new file mode 100644
index 000000000000..07e7dd3d6c87
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
diff --git a/Documentation/sound/hd-audio/models.rst b/Documentation/sound/hd-audio/models.rst
index 9b52f50a6854..120430450014 100644
--- a/Documentation/sound/hd-audio/models.rst
+++ b/Documentation/sound/hd-audio/models.rst
@@ -704,7 +704,7 @@ ref
 no-jd
     BIOS setup but without jack-detection
 intel
-    Intel DG45* mobos
+    Intel D*45* mobos
 dell-m6-amic
     Dell desktops/laptops with analog mics
 dell-m6-dmic
diff --git a/Makefile b/Makefile
index ae202cc53158..3bde04cc7f04 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 10
-SUBLEVEL = 177
+SUBLEVEL = 178
 EXTRAVERSION =
 NAME = Dare mighty things
 
@@ -580,8 +580,10 @@ endif
 ifneq ($(GCC_TOOLCHAIN),)
 CLANG_FLAGS	+= --gcc-toolchain=$(GCC_TOOLCHAIN)
 endif
-ifneq ($(LLVM_IAS),1)
-CLANG_FLAGS	+= -no-integrated-as
+ifeq ($(LLVM_IAS),1)
+CLANG_FLAGS	+= -fintegrated-as
+else
+CLANG_FLAGS	+= -fno-integrated-as
 endif
 CLANG_FLAGS	+= -Werror=unknown-warning-option
 KBUILD_CFLAGS	+= $(CLANG_FLAGS)
@@ -849,7 +851,7 @@ else
 DEBUG_CFLAGS	+= -g
 endif
 
-ifeq ($(LLVM_IAS),1)
+ifdef CONFIG_AS_IS_LLVM
 KBUILD_AFLAGS	+= -g
 else
 KBUILD_AFLAGS	+= -Wa,-gdwarf-2
diff --git a/arch/powerpc/include/asm/firmware.h b/arch/powerpc/include/asm/firmware.h
index aa6a5ef5d483..89a31f1c7b11 100644
--- a/arch/powerpc/include/asm/firmware.h
+++ b/arch/powerpc/include/asm/firmware.h
@@ -44,7 +44,7 @@
 #define FW_FEATURE_OPAL		ASM_CONST(0x0000000010000000)
 #define FW_FEATURE_SET_MODE	ASM_CONST(0x0000000040000000)
 #define FW_FEATURE_BEST_ENERGY	ASM_CONST(0x0000000080000000)
-#define FW_FEATURE_TYPE1_AFFINITY ASM_CONST(0x0000000100000000)
+#define FW_FEATURE_FORM1_AFFINITY ASM_CONST(0x0000000100000000)
 #define FW_FEATURE_PRRN		ASM_CONST(0x0000000200000000)
 #define FW_FEATURE_DRMEM_V2	ASM_CONST(0x0000000400000000)
 #define FW_FEATURE_DRC_INFO	ASM_CONST(0x0000000800000000)
@@ -53,6 +53,7 @@
 #define FW_FEATURE_ULTRAVISOR	ASM_CONST(0x0000004000000000)
 #define FW_FEATURE_STUFF_TCE	ASM_CONST(0x0000008000000000)
 #define FW_FEATURE_RPT_INVALIDATE ASM_CONST(0x0000010000000000)
+#define FW_FEATURE_FORM2_AFFINITY ASM_CONST(0x0000020000000000)
 
 #ifndef __ASSEMBLY__
 
@@ -69,11 +70,11 @@ enum {
 		FW_FEATURE_SPLPAR | FW_FEATURE_LPAR |
 		FW_FEATURE_CMO | FW_FEATURE_VPHN | FW_FEATURE_XCMO |
 		FW_FEATURE_SET_MODE | FW_FEATURE_BEST_ENERGY |
-		FW_FEATURE_TYPE1_AFFINITY | FW_FEATURE_PRRN |
+		FW_FEATURE_FORM1_AFFINITY | FW_FEATURE_PRRN |
 		FW_FEATURE_HPT_RESIZE | FW_FEATURE_DRMEM_V2 |
 		FW_FEATURE_DRC_INFO | FW_FEATURE_BLOCK_REMOVE |
 		FW_FEATURE_PAPR_SCM | FW_FEATURE_ULTRAVISOR |
-		FW_FEATURE_RPT_INVALIDATE,
+		FW_FEATURE_RPT_INVALIDATE | FW_FEATURE_FORM2_AFFINITY,
 	FW_FEATURE_PSERIES_ALWAYS = 0,
 	FW_FEATURE_POWERNV_POSSIBLE = FW_FEATURE_OPAL | FW_FEATURE_ULTRAVISOR,
 	FW_FEATURE_POWERNV_ALWAYS = 0,
diff --git a/arch/powerpc/include/asm/prom.h b/arch/powerpc/include/asm/prom.h
index 324a13351749..5c80152e8f18 100644
--- a/arch/powerpc/include/asm/prom.h
+++ b/arch/powerpc/include/asm/prom.h
@@ -147,8 +147,9 @@ extern int of_read_drc_info_cell(struct property **prop,
 #define OV5_MSI			0x0201	/* PCIe/MSI support */
 #define OV5_CMO			0x0480	/* Cooperative Memory Overcommitment */
 #define OV5_XCMO		0x0440	/* Page Coalescing */
-#define OV5_TYPE1_AFFINITY	0x0580	/* Type 1 NUMA affinity */
+#define OV5_FORM1_AFFINITY	0x0580	/* FORM1 NUMA affinity */
 #define OV5_PRRN		0x0540	/* Platform Resource Reassignment */
+#define OV5_FORM2_AFFINITY	0x0520	/* Form2 NUMA affinity */
 #define OV5_HP_EVT		0x0604	/* Hot Plug Event support */
 #define OV5_RESIZE_HPT		0x0601	/* Hash Page Table resizing */
 #define OV5_PFO_HW_RNG		0x1180	/* PFO Random Number Generator */
diff --git a/arch/powerpc/include/asm/topology.h b/arch/powerpc/include/asm/topology.h
index 3beeb030cd78..b239ef589ae0 100644
--- a/arch/powerpc/include/asm/topology.h
+++ b/arch/powerpc/include/asm/topology.h
@@ -36,7 +36,7 @@ static inline int pcibus_to_node(struct pci_bus *bus)
 				 cpu_all_mask :				\
 				 cpumask_of_node(pcibus_to_node(bus)))
 
-extern int cpu_distance(__be32 *cpu1_assoc, __be32 *cpu2_assoc);
+int cpu_relative_distance(__be32 *cpu1_assoc, __be32 *cpu2_assoc);
 extern int __node_distance(int, int);
 #define node_distance(a, b) __node_distance(a, b)
 
@@ -64,6 +64,7 @@ static inline int early_cpu_to_node(int cpu)
 }
 
 int of_drconf_to_nid_single(struct drmem_lmb *lmb);
+void update_numa_distance(struct device_node *node);
 
 #else
 
@@ -83,7 +84,7 @@ static inline void sysfs_remove_device_from_node(struct device *dev,
 
 static inline void update_numa_cpu_lookup_table(unsigned int cpu, int node) {}
 
-static inline int cpu_distance(__be32 *cpu1_assoc, __be32 *cpu2_assoc)
+static inline int cpu_relative_distance(__be32 *cpu1_assoc, __be32 *cpu2_assoc)
 {
 	return 0;
 }
@@ -93,6 +94,7 @@ static inline int of_drconf_to_nid_single(struct drmem_lmb *lmb)
 	return first_online_node;
 }
 
+static inline void update_numa_distance(struct device_node *node) {}
 #endif /* CONFIG_NUMA */
 
 #if defined(CONFIG_NUMA) && defined(CONFIG_PPC_SPLPAR)
diff --git a/arch/powerpc/kernel/prom_init.c b/arch/powerpc/kernel/prom_init.c
index 9e71c0739f08..6f7ad8076315 100644
--- a/arch/powerpc/kernel/prom_init.c
+++ b/arch/powerpc/kernel/prom_init.c
@@ -1069,7 +1069,8 @@ static const struct ibm_arch_vec ibm_architecture_vec_template __initconst = {
 #else
 		0,
 #endif
-		.associativity = OV5_FEAT(OV5_TYPE1_AFFINITY) | OV5_FEAT(OV5_PRRN),
+		.associativity = OV5_FEAT(OV5_FORM1_AFFINITY) | OV5_FEAT(OV5_PRRN) |
+		OV5_FEAT(OV5_FORM2_AFFINITY),
 		.bin_opts = OV5_FEAT(OV5_RESIZE_HPT) | OV5_FEAT(OV5_HP_EVT),
 		.micro_checkpoint = 0,
 		.reserved0 = 0,
diff --git a/arch/powerpc/mm/numa.c b/arch/powerpc/mm/numa.c
index 275c60f92a7c..ce8569e16f0c 100644
--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -51,14 +51,22 @@ EXPORT_SYMBOL(numa_cpu_lookup_table);
 EXPORT_SYMBOL(node_to_cpumask_map);
 EXPORT_SYMBOL(node_data);
 
-static int min_common_depth;
+static int primary_domain_index;
 static int n_mem_addr_cells, n_mem_size_cells;
-static int form1_affinity;
+
+#define FORM0_AFFINITY 0
+#define FORM1_AFFINITY 1
+#define FORM2_AFFINITY 2
+static int affinity_form;
 
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
@@ -163,7 +171,55 @@ static void unmap_cpu_from_node(unsigned long cpu)
 }
 #endif /* CONFIG_HOTPLUG_CPU || CONFIG_PPC_SPLPAR */
 
-int cpu_distance(__be32 *cpu1_assoc, __be32 *cpu2_assoc)
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
+static int __cpu_form1_relative_distance(__be32 *cpu1_assoc, __be32 *cpu2_assoc)
 {
 	int dist = 0;
 
@@ -179,6 +235,15 @@ int cpu_distance(__be32 *cpu1_assoc, __be32 *cpu2_assoc)
 	return dist;
 }
 
+int cpu_relative_distance(__be32 *cpu1_assoc, __be32 *cpu2_assoc)
+{
+	/* We should not get called with FORM0 */
+	VM_WARN_ON(affinity_form == FORM0_AFFINITY);
+	if (affinity_form == FORM1_AFFINITY)
+		return __cpu_form1_relative_distance(cpu1_assoc, cpu2_assoc);
+	return __cpu_form2_relative_distance(cpu1_assoc, cpu2_assoc);
+}
+
 /* must hold reference to node during call */
 static const __be32 *of_get_associativity(struct device_node *dev)
 {
@@ -190,7 +255,9 @@ int __node_distance(int a, int b)
 	int i;
 	int distance = LOCAL_DISTANCE;
 
-	if (!form1_affinity)
+	if (affinity_form == FORM2_AFFINITY)
+		return numa_distance_table[a][b];
+	else if (affinity_form == FORM0_AFFINITY)
 		return ((a == b) ? LOCAL_DISTANCE : REMOTE_DISTANCE);
 
 	for (i = 0; i < distance_ref_points_depth; i++) {
@@ -205,52 +272,6 @@ int __node_distance(int a, int b)
 }
 EXPORT_SYMBOL(__node_distance);
 
-static void initialize_distance_lookup_table(int nid,
-		const __be32 *associativity)
-{
-	int i;
-
-	if (!form1_affinity)
-		return;
-
-	for (i = 0; i < distance_ref_points_depth; i++) {
-		const __be32 *entry;
-
-		entry = &associativity[be32_to_cpu(distance_ref_points[i]) - 1];
-		distance_lookup_table[nid][i] = of_read_number(entry, 1);
-	}
-}
-
-/*
- * Returns nid in the range [0..nr_node_ids], or -1 if no useful NUMA
- * info is found.
- */
-static int associativity_to_nid(const __be32 *associativity)
-{
-	int nid = NUMA_NO_NODE;
-
-	if (!numa_enabled)
-		goto out;
-
-	if (of_read_number(associativity, 1) >= min_common_depth)
-		nid = of_read_number(&associativity[min_common_depth], 1);
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
-
-out:
-	return nid;
-}
-
 /* Returns the nid associated with the given device tree node,
  * or -1 if not found.
  */
@@ -284,11 +305,160 @@ int of_node_to_nid(struct device_node *device)
 }
 EXPORT_SYMBOL(of_node_to_nid);
 
-static int __init find_min_common_depth(void)
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
+	int nid;
+
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
+EXPORT_SYMBOL_GPL(update_numa_distance);
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
+}
+
+static int __init find_primary_domain_index(void)
 {
-	int depth;
+	int index;
 	struct device_node *root;
 
+	/*
+	 * Check for which form of affinity.
+	 */
+	if (firmware_has_feature(FW_FEATURE_OPAL)) {
+		affinity_form = FORM1_AFFINITY;
+	} else if (firmware_has_feature(FW_FEATURE_FORM2_AFFINITY)) {
+		dbg("Using form 2 affinity\n");
+		affinity_form = FORM2_AFFINITY;
+	} else if (firmware_has_feature(FW_FEATURE_FORM1_AFFINITY)) {
+		dbg("Using form 1 affinity\n");
+		affinity_form = FORM1_AFFINITY;
+	} else
+		affinity_form = FORM0_AFFINITY;
+
 	if (firmware_has_feature(FW_FEATURE_OPAL))
 		root = of_find_node_by_path("/ibm,opal");
 	else
@@ -318,25 +488,21 @@ static int __init find_min_common_depth(void)
 	}
 
 	distance_ref_points_depth /= sizeof(int);
-
-	if (firmware_has_feature(FW_FEATURE_OPAL) ||
-	    firmware_has_feature(FW_FEATURE_TYPE1_AFFINITY)) {
-		dbg("Using form 1 affinity\n");
-		form1_affinity = 1;
-	}
-
-	if (form1_affinity) {
-		depth = of_read_number(distance_ref_points, 1);
-	} else {
+	if (affinity_form == FORM0_AFFINITY) {
 		if (distance_ref_points_depth < 2) {
 			printk(KERN_WARNING "NUMA: "
-				"short ibm,associativity-reference-points\n");
+			       "short ibm,associativity-reference-points\n");
 			goto err;
 		}
 
-		depth = of_read_number(&distance_ref_points[1], 1);
+		index = of_read_number(&distance_ref_points[1], 1);
+	} else {
+		/*
+		 * Both FORM1 and FORM2 affinity find the primary domain details
+		 * at the same offset.
+		 */
+		index = of_read_number(distance_ref_points, 1);
 	}
-
 	/*
 	 * Warn and cap if the hardware supports more than
 	 * MAX_DISTANCE_REF_POINTS domains.
@@ -348,7 +514,7 @@ static int __init find_min_common_depth(void)
 	}
 
 	of_node_put(root);
-	return depth;
+	return index;
 
 err:
 	of_node_put(root);
@@ -426,6 +592,38 @@ static int of_get_assoc_arrays(struct assoc_arrays *aa)
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
@@ -437,35 +635,28 @@ int of_drconf_to_nid_single(struct drmem_lmb *lmb)
 	int nid = default_nid;
 	int rc, index;
 
-	if ((min_common_depth < 0) || !numa_enabled)
+	if ((primary_domain_index < 0) || !numa_enabled)
 		return default_nid;
 
 	rc = of_get_assoc_arrays(&aa);
 	if (rc)
 		return default_nid;
 
-	if (min_common_depth <= aa.array_sz &&
+	if (primary_domain_index <= aa.array_sz &&
 	    !(lmb->flags & DRCONF_MEM_AI_INVALID) && lmb->aa_index < aa.n_arrays) {
-		index = lmb->aa_index * aa.array_sz + min_common_depth - 1;
-		nid = of_read_number(&aa.arrays[index], 1);
+		const __be32 *associativity;
 
-		if (nid == 0xffff || nid >= nr_node_ids)
-			nid = default_nid;
-
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
@@ -485,12 +676,30 @@ static int vphn_get_nid(long lcpu)
 
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
@@ -685,7 +894,7 @@ static int __init numa_setup_drmem_lmb(struct drmem_lmb *lmb,
 			size = read_n_cells(n_mem_size_cells, usm);
 		}
 
-		nid = of_drconf_to_nid_single(lmb);
+		nid = get_nid_and_numa_distance(lmb);
 		fake_numa_create_new_node(((base + size) >> PAGE_SHIFT),
 					  &nid);
 		node_set_online(nid);
@@ -702,24 +911,31 @@ static int __init parse_numa_properties(void)
 	struct device_node *memory;
 	int default_nid = 0;
 	unsigned long i;
+	const __be32 *associativity;
 
 	if (numa_enabled == 0) {
 		printk(KERN_WARNING "NUMA disabled by user\n");
 		return -1;
 	}
 
-	min_common_depth = find_min_common_depth();
+	primary_domain_index = find_primary_domain_index();
 
-	if (min_common_depth < 0) {
+	if (primary_domain_index < 0) {
 		/*
-		 * if we fail to parse min_common_depth from device tree
+		 * if we fail to parse primary_domain_index from device tree
 		 * mark the numa disabled, boot with numa disabled.
 		 */
 		numa_enabled = false;
-		return min_common_depth;
+		return primary_domain_index;
 	}
 
-	dbg("NUMA associativity depth for CPU/Memory: %d\n", min_common_depth);
+	dbg("NUMA associativity depth for CPU/Memory: %d\n", primary_domain_index);
+
+	/*
+	 * If it is FORM2 initialize the distance table here.
+	 */
+	if (affinity_form == FORM2_AFFINITY)
+		initialize_form2_numa_distance_lookup_table();
 
 	/*
 	 * Even though we connect cpus to numa domains later in SMP
@@ -727,18 +943,30 @@ static int __init parse_numa_properties(void)
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
 
@@ -776,8 +1004,11 @@ static int __init parse_numa_properties(void)
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
@@ -926,7 +1157,7 @@ static void __init find_possible_nodes(void)
 			goto out;
 	}
 
-	max_nodes = of_read_number(&domains[min_common_depth], 1);
+	max_nodes = of_read_number(&domains[primary_domain_index], 1);
 	pr_info("Partition configured for %d NUMA nodes.\n", max_nodes);
 
 	for (i = 0; i < max_nodes; i++) {
@@ -935,7 +1166,7 @@ static void __init find_possible_nodes(void)
 	}
 
 	prop_length /= sizeof(int);
-	if (prop_length > min_common_depth + 2)
+	if (prop_length > primary_domain_index + 2)
 		coregroup_enabled = 1;
 
 out:
@@ -1268,7 +1499,7 @@ int cpu_to_coregroup_id(int cpu)
 		goto out;
 
 	index = of_read_number(associativity, 1);
-	if (index > min_common_depth + 1)
+	if (index > primary_domain_index + 1)
 		return of_read_number(&associativity[index - 1], 1);
 
 out:
diff --git a/arch/powerpc/platforms/pseries/firmware.c b/arch/powerpc/platforms/pseries/firmware.c
index 4c7b7f5a2ebc..f162156b7b68 100644
--- a/arch/powerpc/platforms/pseries/firmware.c
+++ b/arch/powerpc/platforms/pseries/firmware.c
@@ -119,10 +119,11 @@ struct vec5_fw_feature {
 
 static __initdata struct vec5_fw_feature
 vec5_fw_features_table[] = {
-	{FW_FEATURE_TYPE1_AFFINITY,	OV5_TYPE1_AFFINITY},
+	{FW_FEATURE_FORM1_AFFINITY,	OV5_FORM1_AFFINITY},
 	{FW_FEATURE_PRRN,		OV5_PRRN},
 	{FW_FEATURE_DRMEM_V2,		OV5_DRMEM_V2},
 	{FW_FEATURE_DRC_INFO,		OV5_DRC_INFO},
+	{FW_FEATURE_FORM2_AFFINITY,	OV5_FORM2_AFFINITY},
 };
 
 static void __init fw_vec5_feature_init(const char *vec5, unsigned long len)
diff --git a/arch/powerpc/platforms/pseries/hotplug-cpu.c b/arch/powerpc/platforms/pseries/hotplug-cpu.c
index 325f3b220f36..1f8f97210d14 100644
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
index 7efe6ec5d14a..a5f968b5fa3a 100644
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
diff --git a/arch/powerpc/platforms/pseries/lpar.c b/arch/powerpc/platforms/pseries/lpar.c
index 115d196560b8..28396a7e77d6 100644
--- a/arch/powerpc/platforms/pseries/lpar.c
+++ b/arch/powerpc/platforms/pseries/lpar.c
@@ -261,7 +261,7 @@ static int cpu_relative_dispatch_distance(int last_disp_cpu, int cur_disp_cpu)
 	if (!last_disp_cpu_assoc || !cur_disp_cpu_assoc)
 		return -EIO;
 
-	return cpu_distance(last_disp_cpu_assoc, cur_disp_cpu_assoc);
+	return cpu_relative_distance(last_disp_cpu_assoc, cur_disp_cpu_assoc);
 }
 
 static int cpu_home_node_dispatch_distance(int disp_cpu)
@@ -281,7 +281,7 @@ static int cpu_home_node_dispatch_distance(int disp_cpu)
 	if (!disp_cpu_assoc || !vcpu_assoc)
 		return -EIO;
 
-	return cpu_distance(disp_cpu_assoc, vcpu_assoc);
+	return cpu_relative_distance(disp_cpu_assoc, vcpu_assoc);
 }
 
 static void update_vcpu_disp_stat(int disp_cpu)
diff --git a/arch/powerpc/platforms/pseries/papr_scm.c b/arch/powerpc/platforms/pseries/papr_scm.c
index 057acbb9116d..e3b7698b4762 100644
--- a/arch/powerpc/platforms/pseries/papr_scm.c
+++ b/arch/powerpc/platforms/pseries/papr_scm.c
@@ -1079,6 +1079,13 @@ static int papr_scm_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
+	/*
+	 * open firmware platform device create won't update the NUMA 
+	 * distance table. For PAPR SCM devices we use numa_map_to_online_node()
+	 * to find the nearest online NUMA node and that requires correct
+	 * distance table information.
+	 */
+	update_numa_distance(dn);
 
 	p = kzalloc(sizeof(*p), GFP_KERNEL);
 	if (!p)
diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 557c4a8c4087..c192bd7305dc 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -331,6 +331,28 @@ config RISCV_BASE_PMU
 
 endmenu
 
+config TOOLCHAIN_NEEDS_EXPLICIT_ZICSR_ZIFENCEI
+	def_bool y
+	# https://sourceware.org/git/?p=binutils-gdb.git;a=commit;h=aed44286efa8ae8717a77d94b51ac3614e2ca6dc
+	depends on AS_IS_GNU && AS_VERSION >= 23800
+	help
+	  Newer binutils versions default to ISA spec version 20191213 which
+	  moves some instructions from the I extension to the Zicsr and Zifencei
+	  extensions.
+
+config TOOLCHAIN_NEEDS_OLD_ISA_SPEC
+	def_bool y
+	depends on TOOLCHAIN_NEEDS_EXPLICIT_ZICSR_ZIFENCEI
+	# https://github.com/llvm/llvm-project/commit/22e199e6afb1263c943c0c0d4498694e15bf8a16
+	depends on CC_IS_CLANG && CLANG_VERSION < 170000
+	help
+	  Certain versions of clang do not support zicsr and zifencei via -march
+	  but newer versions of binutils require it for the reasons noted in the
+	  help text of CONFIG_TOOLCHAIN_NEEDS_EXPLICIT_ZICSR_ZIFENCEI. This
+	  option causes an older ISA spec compatible with these older versions
+	  of clang to be passed to GAS, which has the same result as passing zicsr
+	  and zifencei to -march.
+
 config FPU
 	bool "FPU support"
 	default y
diff --git a/arch/riscv/Makefile b/arch/riscv/Makefile
index 9446282b52ba..daa679440000 100644
--- a/arch/riscv/Makefile
+++ b/arch/riscv/Makefile
@@ -40,7 +40,7 @@ ifeq ($(CONFIG_LD_IS_LLD),y)
 ifeq ($(shell test $(CONFIG_LLD_VERSION) -lt 150000; echo $$?),0)
 	KBUILD_CFLAGS += -mno-relax
 	KBUILD_AFLAGS += -mno-relax
-ifneq ($(LLVM_IAS),1)
+ifndef CONFIG_AS_IS_LLVM
 	KBUILD_CFLAGS += -Wa,-mno-relax
 	KBUILD_AFLAGS += -Wa,-mno-relax
 endif
@@ -53,10 +53,12 @@ riscv-march-$(CONFIG_ARCH_RV64I)	:= rv64ima
 riscv-march-$(CONFIG_FPU)		:= $(riscv-march-y)fd
 riscv-march-$(CONFIG_RISCV_ISA_C)	:= $(riscv-march-y)c
 
-# Newer binutils versions default to ISA spec version 20191213 which moves some
-# instructions from the I extension to the Zicsr and Zifencei extensions.
-toolchain-need-zicsr-zifencei := $(call cc-option-yn, -march=$(riscv-march-y)_zicsr_zifencei)
-riscv-march-$(toolchain-need-zicsr-zifencei) := $(riscv-march-y)_zicsr_zifencei
+ifdef CONFIG_TOOLCHAIN_NEEDS_OLD_ISA_SPEC
+KBUILD_CFLAGS += -Wa,-misa-spec=2.2
+KBUILD_AFLAGS += -Wa,-misa-spec=2.2
+else
+riscv-march-$(CONFIG_TOOLCHAIN_NEEDS_EXPLICIT_ZICSR_ZIFENCEI) := $(riscv-march-y)_zicsr_zifencei
+endif
 
 KBUILD_CFLAGS += -march=$(subst fd,,$(riscv-march-y))
 KBUILD_AFLAGS += -march=$(riscv-march-y)
diff --git a/arch/riscv/kernel/signal.c b/arch/riscv/kernel/signal.c
index 50a8225c58bc..dd63407e8294 100644
--- a/arch/riscv/kernel/signal.c
+++ b/arch/riscv/kernel/signal.c
@@ -16,6 +16,7 @@
 #include <asm/vdso.h>
 #include <asm/switch_to.h>
 #include <asm/csr.h>
+#include <asm/cacheflush.h>
 
 extern u32 __user_rt_sigreturn[2];
 
@@ -178,6 +179,7 @@ static int setup_rt_frame(struct ksignal *ksig, sigset_t *set,
 {
 	struct rt_sigframe __user *frame;
 	long err = 0;
+	unsigned long __maybe_unused addr;
 
 	frame = get_sigframe(ksig, regs, sizeof(*frame));
 	if (!access_ok(frame, sizeof(*frame)))
@@ -206,7 +208,12 @@ static int setup_rt_frame(struct ksignal *ksig, sigset_t *set,
 	if (copy_to_user(&frame->sigreturn_code, __user_rt_sigreturn,
 			 sizeof(frame->sigreturn_code)))
 		return -EFAULT;
-	regs->ra = (unsigned long)&frame->sigreturn_code;
+
+	addr = (unsigned long)&frame->sigreturn_code;
+	/* Make sure the two instructions are pushed to icache. */
+	flush_icache_range(addr, addr + sizeof(frame->sigreturn_code));
+
+	regs->ra = addr;
 #endif /* CONFIG_MMU */
 
 	/*
diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
index 77909d362b78..5be68190901f 100644
--- a/arch/s390/kvm/intercept.c
+++ b/arch/s390/kvm/intercept.c
@@ -270,10 +270,18 @@ static int handle_prog(struct kvm_vcpu *vcpu)
 /**
  * handle_external_interrupt - used for external interruption interceptions
  *
- * This interception only occurs if the CPUSTAT_EXT_INT bit was set, or if
- * the new PSW does not have external interrupts disabled. In the first case,
- * we've got to deliver the interrupt manually, and in the second case, we
- * drop to userspace to handle the situation there.
+ * This interception occurs if:
+ * - the CPUSTAT_EXT_INT bit was already set when the external interrupt
+ *   occurred. In this case, the interrupt needs to be injected manually to
+ *   preserve interrupt priority.
+ * - the external new PSW has external interrupts enabled, which will cause an
+ *   interruption loop. We drop to userspace in this case.
+ *
+ * The latter case can be detected by inspecting the external mask bit in the
+ * external new psw.
+ *
+ * Under PV, only the latter case can occur, since interrupt priorities are
+ * handled in the ultravisor.
  */
 static int handle_external_interrupt(struct kvm_vcpu *vcpu)
 {
@@ -284,10 +292,18 @@ static int handle_external_interrupt(struct kvm_vcpu *vcpu)
 
 	vcpu->stat.exit_external_interrupt++;
 
-	rc = read_guest_lc(vcpu, __LC_EXT_NEW_PSW, &newpsw, sizeof(psw_t));
-	if (rc)
-		return rc;
-	/* We can not handle clock comparator or timer interrupt with bad PSW */
+	if (kvm_s390_pv_cpu_is_protected(vcpu)) {
+		newpsw = vcpu->arch.sie_block->gpsw;
+	} else {
+		rc = read_guest_lc(vcpu, __LC_EXT_NEW_PSW, &newpsw, sizeof(psw_t));
+		if (rc)
+			return rc;
+	}
+
+	/*
+	 * Clock comparator or timer interrupt with external interrupt enabled
+	 * will cause interrupt loop. Drop to userspace.
+	 */
 	if ((eic == EXT_IRQ_CLK_COMP || eic == EXT_IRQ_CPU_TIMER) &&
 	    (newpsw.mask & PSW_MASK_EXT))
 		return -EOPNOTSUPP;
diff --git a/arch/x86/kernel/sysfb_efi.c b/arch/x86/kernel/sysfb_efi.c
index 9ea65611fba0..fff04d285976 100644
--- a/arch/x86/kernel/sysfb_efi.c
+++ b/arch/x86/kernel/sysfb_efi.c
@@ -272,6 +272,14 @@ static const struct dmi_system_id efifb_dmi_swap_width_height[] __initconst = {
 					"IdeaPad Duet 3 10IGL5"),
 		},
 	},
+	{
+		/* Lenovo Yoga Book X91F / X91L */
+		.matches = {
+			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			/* Non exact match to match F + L versions */
+			DMI_MATCH(DMI_PRODUCT_NAME, "Lenovo YB1-X91"),
+		},
+	},
 	{},
 };
 
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index a3038d8deb6a..b758eeea6090 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -32,8 +32,8 @@ static int __init iommu_init_noop(void) { return 0; }
 static void iommu_shutdown_noop(void) { }
 bool __init bool_x86_init_noop(void) { return false; }
 void x86_op_int_noop(int cpu) { }
-static __init int set_rtc_noop(const struct timespec64 *now) { return -EINVAL; }
-static __init void get_rtc_noop(struct timespec64 *now) { }
+static int set_rtc_noop(const struct timespec64 *now) { return -EINVAL; }
+static void get_rtc_noop(struct timespec64 *now) { }
 
 static __initconst const struct of_device_id of_cmos_match[] = {
 	{ .compatible = "motorola,mc146818" },
diff --git a/arch/x86/pci/fixup.c b/arch/x86/pci/fixup.c
index 9b0e771302ce..3f3411b882f5 100644
--- a/arch/x86/pci/fixup.c
+++ b/arch/x86/pci/fixup.c
@@ -7,6 +7,7 @@
 #include <linux/dmi.h>
 #include <linux/pci.h>
 #include <linux/vgaarb.h>
+#include <asm/amd_nb.h>
 #include <asm/hpet.h>
 #include <asm/pci_x86.h>
 
@@ -824,3 +825,23 @@ static void rs690_fix_64bit_dma(struct pci_dev *pdev)
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x7910, rs690_fix_64bit_dma);
 
 #endif
+
+#ifdef CONFIG_AMD_NB
+
+#define AMD_15B8_RCC_DEV2_EPF0_STRAP2                                  0x10136008
+#define AMD_15B8_RCC_DEV2_EPF0_STRAP2_NO_SOFT_RESET_DEV2_F0_MASK       0x00000080L
+
+static void quirk_clear_strap_no_soft_reset_dev2_f0(struct pci_dev *dev)
+{
+	u32 data;
+
+	if (!amd_smn_read(0, AMD_15B8_RCC_DEV2_EPF0_STRAP2, &data)) {
+		data &= ~AMD_15B8_RCC_DEV2_EPF0_STRAP2_NO_SOFT_RESET_DEV2_F0_MASK;
+		if (amd_smn_write(0, AMD_15B8_RCC_DEV2_EPF0_STRAP2, data))
+			pci_err(dev, "Failed to write data 0x%x\n", data);
+	} else {
+		pci_err(dev, "Failed to read data\n");
+	}
+}
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, 0x15b8, quirk_clear_strap_no_soft_reset_dev2_f0);
+#endif
diff --git a/crypto/asymmetric_keys/pkcs7_verify.c b/crypto/asymmetric_keys/pkcs7_verify.c
index ce49820caa97..01e54450c846 100644
--- a/crypto/asymmetric_keys/pkcs7_verify.c
+++ b/crypto/asymmetric_keys/pkcs7_verify.c
@@ -79,16 +79,16 @@ static int pkcs7_digest(struct pkcs7_message *pkcs7,
 		}
 
 		if (sinfo->msgdigest_len != sig->digest_size) {
-			pr_debug("Sig %u: Invalid digest size (%u)\n",
-				 sinfo->index, sinfo->msgdigest_len);
+			pr_warn("Sig %u: Invalid digest size (%u)\n",
+				sinfo->index, sinfo->msgdigest_len);
 			ret = -EBADMSG;
 			goto error;
 		}
 
 		if (memcmp(sig->digest, sinfo->msgdigest,
 			   sinfo->msgdigest_len) != 0) {
-			pr_debug("Sig %u: Message digest doesn't match\n",
-				 sinfo->index);
+			pr_warn("Sig %u: Message digest doesn't match\n",
+				sinfo->index);
 			ret = -EKEYREJECTED;
 			goto error;
 		}
@@ -488,7 +488,7 @@ int pkcs7_supply_detached_data(struct pkcs7_message *pkcs7,
 			       const void *data, size_t datalen)
 {
 	if (pkcs7->data) {
-		pr_debug("Data already supplied\n");
+		pr_warn("Data already supplied\n");
 		return -EINVAL;
 	}
 	pkcs7->data = data;
diff --git a/crypto/asymmetric_keys/verify_pefile.c b/crypto/asymmetric_keys/verify_pefile.c
index 7553ab18db89..22beaf2213a2 100644
--- a/crypto/asymmetric_keys/verify_pefile.c
+++ b/crypto/asymmetric_keys/verify_pefile.c
@@ -74,7 +74,7 @@ static int pefile_parse_binary(const void *pebuf, unsigned int pelen,
 		break;
 
 	default:
-		pr_debug("Unknown PEOPT magic = %04hx\n", pe32->magic);
+		pr_warn("Unknown PEOPT magic = %04hx\n", pe32->magic);
 		return -ELIBBAD;
 	}
 
@@ -95,7 +95,7 @@ static int pefile_parse_binary(const void *pebuf, unsigned int pelen,
 	ctx->certs_size = ddir->certs.size;
 
 	if (!ddir->certs.virtual_address || !ddir->certs.size) {
-		pr_debug("Unsigned PE binary\n");
+		pr_warn("Unsigned PE binary\n");
 		return -ENODATA;
 	}
 
@@ -127,7 +127,7 @@ static int pefile_strip_sig_wrapper(const void *pebuf,
 	unsigned len;
 
 	if (ctx->sig_len < sizeof(wrapper)) {
-		pr_debug("Signature wrapper too short\n");
+		pr_warn("Signature wrapper too short\n");
 		return -ELIBBAD;
 	}
 
@@ -135,19 +135,23 @@ static int pefile_strip_sig_wrapper(const void *pebuf,
 	pr_debug("sig wrapper = { %x, %x, %x }\n",
 		 wrapper.length, wrapper.revision, wrapper.cert_type);
 
-	/* Both pesign and sbsign round up the length of certificate table
-	 * (in optional header data directories) to 8 byte alignment.
+	/* sbsign rounds up the length of certificate table (in optional
+	 * header data directories) to 8 byte alignment.  However, the PE
+	 * specification states that while entries are 8-byte aligned, this is
+	 * not included in their length, and as a result, pesign has not
+	 * rounded up since 0.110.
 	 */
-	if (round_up(wrapper.length, 8) != ctx->sig_len) {
-		pr_debug("Signature wrapper len wrong\n");
+	if (wrapper.length > ctx->sig_len) {
+		pr_warn("Signature wrapper bigger than sig len (%x > %x)\n",
+			ctx->sig_len, wrapper.length);
 		return -ELIBBAD;
 	}
 	if (wrapper.revision != WIN_CERT_REVISION_2_0) {
-		pr_debug("Signature is not revision 2.0\n");
+		pr_warn("Signature is not revision 2.0\n");
 		return -ENOTSUPP;
 	}
 	if (wrapper.cert_type != WIN_CERT_TYPE_PKCS_SIGNED_DATA) {
-		pr_debug("Signature certificate type is not PKCS\n");
+		pr_warn("Signature certificate type is not PKCS\n");
 		return -ENOTSUPP;
 	}
 
@@ -160,7 +164,7 @@ static int pefile_strip_sig_wrapper(const void *pebuf,
 	ctx->sig_offset += sizeof(wrapper);
 	ctx->sig_len -= sizeof(wrapper);
 	if (ctx->sig_len < 4) {
-		pr_debug("Signature data missing\n");
+		pr_warn("Signature data missing\n");
 		return -EKEYREJECTED;
 	}
 
@@ -194,7 +198,7 @@ static int pefile_strip_sig_wrapper(const void *pebuf,
 		return 0;
 	}
 not_pkcs7:
-	pr_debug("Signature data not PKCS#7\n");
+	pr_warn("Signature data not PKCS#7\n");
 	return -ELIBBAD;
 }
 
@@ -337,8 +341,8 @@ static int pefile_digest_pe(const void *pebuf, unsigned int pelen,
 	digest_size = crypto_shash_digestsize(tfm);
 
 	if (digest_size != ctx->digest_len) {
-		pr_debug("Digest size mismatch (%zx != %x)\n",
-			 digest_size, ctx->digest_len);
+		pr_warn("Digest size mismatch (%zx != %x)\n",
+			digest_size, ctx->digest_len);
 		ret = -EBADMSG;
 		goto error_no_desc;
 	}
@@ -369,7 +373,7 @@ static int pefile_digest_pe(const void *pebuf, unsigned int pelen,
 	 * PKCS#7 certificate.
 	 */
 	if (memcmp(digest, ctx->digest, ctx->digest_len) != 0) {
-		pr_debug("Digest mismatch\n");
+		pr_warn("Digest mismatch\n");
 		ret = -EKEYREJECTED;
 	} else {
 		pr_debug("The digests match!\n");
diff --git a/drivers/clk/sprd/common.c b/drivers/clk/sprd/common.c
index ce81e4087a8f..2bfbab8db94b 100644
--- a/drivers/clk/sprd/common.c
+++ b/drivers/clk/sprd/common.c
@@ -17,7 +17,6 @@ static const struct regmap_config sprdclk_regmap_config = {
 	.reg_bits	= 32,
 	.reg_stride	= 4,
 	.val_bits	= 32,
-	.max_register	= 0xffff,
 	.fast_io	= true,
 };
 
@@ -43,6 +42,8 @@ int sprd_clk_regmap_init(struct platform_device *pdev,
 	struct device *dev = &pdev->dev;
 	struct device_node *node = dev->of_node, *np;
 	struct regmap *regmap;
+	struct resource *res;
+	struct regmap_config reg_config = sprdclk_regmap_config;
 
 	if (of_find_property(node, "sprd,syscon", NULL)) {
 		regmap = syscon_regmap_lookup_by_phandle(node, "sprd,syscon");
@@ -59,12 +60,14 @@ int sprd_clk_regmap_init(struct platform_device *pdev,
 			return PTR_ERR(regmap);
 		}
 	} else {
-		base = devm_platform_ioremap_resource(pdev, 0);
+		base = devm_platform_get_and_ioremap_resource(pdev, 0, &res);
 		if (IS_ERR(base))
 			return PTR_ERR(base);
 
+		reg_config.max_register = resource_size(res) - reg_config.reg_stride;
+
 		regmap = devm_regmap_init_mmio(&pdev->dev, base,
-					       &sprdclk_regmap_config);
+					       &reg_config);
 		if (IS_ERR(regmap)) {
 			pr_err("failed to init regmap\n");
 			return PTR_ERR(regmap);
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index d1300fc003ed..39f3e1366409 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -99,7 +99,7 @@ config GPIO_GENERIC
 	tristate
 
 config GPIO_REGMAP
-	depends on REGMAP
+	select REGMAP
 	tristate
 
 # put drivers in the right section, in alphabetical order
diff --git a/drivers/gpio/gpio-davinci.c b/drivers/gpio/gpio-davinci.c
index 6f2138503726..80597e90de9c 100644
--- a/drivers/gpio/gpio-davinci.c
+++ b/drivers/gpio/gpio-davinci.c
@@ -326,7 +326,7 @@ static struct irq_chip gpio_irqchip = {
 	.irq_enable	= gpio_irq_enable,
 	.irq_disable	= gpio_irq_disable,
 	.irq_set_type	= gpio_irq_type,
-	.flags		= IRQCHIP_SET_TYPE_MASKED,
+	.flags		= IRQCHIP_SET_TYPE_MASKED | IRQCHIP_SKIP_SET_WAKE,
 };
 
 static void gpio_irq_handler(struct irq_desc *desc)
diff --git a/drivers/gpu/drm/armada/armada_drv.c b/drivers/gpu/drm/armada/armada_drv.c
index 980d3f1f8f16..2d1e1e48f0ee 100644
--- a/drivers/gpu/drm/armada/armada_drv.c
+++ b/drivers/gpu/drm/armada/armada_drv.c
@@ -102,7 +102,6 @@ static int armada_drm_bind(struct device *dev)
 	if (ret) {
 		dev_err(dev, "[" DRM_NAME ":%s] can't kick out simple-fb: %d\n",
 			__func__, ret);
-		kfree(priv);
 		return ret;
 	}
 
diff --git a/drivers/gpu/drm/bridge/lontium-lt9611.c b/drivers/gpu/drm/bridge/lontium-lt9611.c
index 0c6dea9ccb72..660e05fa4a70 100644
--- a/drivers/gpu/drm/bridge/lontium-lt9611.c
+++ b/drivers/gpu/drm/bridge/lontium-lt9611.c
@@ -256,6 +256,7 @@ static int lt9611_pll_setup(struct lt9611 *lt9611, const struct drm_display_mode
 		{ 0x8126, 0x55 },
 		{ 0x8127, 0x66 },
 		{ 0x8128, 0x88 },
+		{ 0x812a, 0x20 },
 	};
 
 	regmap_multi_reg_write(lt9611->regmap, reg_cfg, ARRAY_SIZE(reg_cfg));
diff --git a/drivers/gpu/drm/drm_panel_orientation_quirks.c b/drivers/gpu/drm/drm_panel_orientation_quirks.c
index 8768073794fb..6106fa7c4302 100644
--- a/drivers/gpu/drm/drm_panel_orientation_quirks.c
+++ b/drivers/gpu/drm/drm_panel_orientation_quirks.c
@@ -284,10 +284,17 @@ static const struct dmi_system_id orientation_data[] = {
 		  DMI_EXACT_MATCH(DMI_PRODUCT_VERSION, "IdeaPad Duet 3 10IGL5"),
 		},
 		.driver_data = (void *)&lcd1200x1920_rightside_up,
-	}, {	/* Lenovo Yoga Book X90F / X91F / X91L */
+	}, {	/* Lenovo Yoga Book X90F / X90L */
 		.matches = {
-		  /* Non exact match to match all versions */
-		  DMI_MATCH(DMI_PRODUCT_NAME, "Lenovo YB1-X9"),
+		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Intel Corporation"),
+		  DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "CHERRYVIEW D1 PLATFORM"),
+		  DMI_EXACT_MATCH(DMI_PRODUCT_VERSION, "YETI-11"),
+		},
+		.driver_data = (void *)&lcd1200x1920_rightside_up,
+	}, {	/* Lenovo Yoga Book X91F / X91L */
+		.matches = {
+		  /* Non exact match to match F + L versions */
+		  DMI_MATCH(DMI_PRODUCT_NAME, "Lenovo YB1-X91"),
 		},
 		.driver_data = (void *)&lcd1200x1920_rightside_up,
 	}, {	/* OneGX1 Pro */
diff --git a/drivers/gpu/drm/nouveau/dispnv50/disp.c b/drivers/gpu/drm/nouveau/dispnv50/disp.c
index 804ea035fa46..0ac120225b4d 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/disp.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/disp.c
@@ -396,6 +396,35 @@ nv50_outp_atomic_check_view(struct drm_encoder *encoder,
 	return 0;
 }
 
+static void
+nv50_outp_atomic_fix_depth(struct drm_encoder *encoder, struct drm_crtc_state *crtc_state)
+{
+	struct nv50_head_atom *asyh = nv50_head_atom(crtc_state);
+	struct nouveau_encoder *nv_encoder = nouveau_encoder(encoder);
+	struct drm_display_mode *mode = &asyh->state.adjusted_mode;
+	unsigned int max_rate, mode_rate;
+
+	switch (nv_encoder->dcb->type) {
+	case DCB_OUTPUT_DP:
+		max_rate = nv_encoder->dp.link_nr * nv_encoder->dp.link_bw;
+
+		/* we don't support more than 10 anyway */
+		asyh->or.bpc = min_t(u8, asyh->or.bpc, 10);
+
+		/* reduce the bpc until it works out */
+		while (asyh->or.bpc > 6) {
+			mode_rate = DIV_ROUND_UP(mode->clock * asyh->or.bpc * 3, 8);
+			if (mode_rate <= max_rate)
+				break;
+
+			asyh->or.bpc -= 2;
+		}
+		break;
+	default:
+		break;
+	}
+}
+
 static int
 nv50_outp_atomic_check(struct drm_encoder *encoder,
 		       struct drm_crtc_state *crtc_state,
@@ -414,6 +443,9 @@ nv50_outp_atomic_check(struct drm_encoder *encoder,
 	if (crtc_state->mode_changed || crtc_state->connectors_changed)
 		asyh->or.bpc = connector->display_info.bpc;
 
+	/* We might have to reduce the bpc */
+	nv50_outp_atomic_fix_depth(encoder, crtc_state);
+
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/nouveau/nouveau_dp.c b/drivers/gpu/drm/nouveau/nouveau_dp.c
index 040ed88d362d..447b7594b35a 100644
--- a/drivers/gpu/drm/nouveau/nouveau_dp.c
+++ b/drivers/gpu/drm/nouveau/nouveau_dp.c
@@ -220,8 +220,6 @@ void nouveau_dp_irq(struct nouveau_drm *drm,
 }
 
 /* TODO:
- * - Use the minimum possible BPC here, once we add support for the max bpc
- *   property.
  * - Validate against the DP caps advertised by the GPU (we don't check these
  *   yet)
  */
@@ -233,7 +231,11 @@ nv50_dp_mode_valid(struct drm_connector *connector,
 {
 	const unsigned int min_clock = 25000;
 	unsigned int max_rate, mode_rate, ds_max_dotclock, clock = mode->clock;
-	const u8 bpp = connector->display_info.bpc * 3;
+	/* Check with the minmum bpc always, so we can advertise better modes.
+	 * In particlar not doing this causes modes to be dropped on HDR
+	 * displays as we might check with a bpc of 16 even.
+	 */
+	const u8 bpp = 6 * 3;
 
 	if (mode->flags & DRM_MODE_FLAG_INTERLACE && !outp->caps.dp_interlace)
 		return MODE_NO_INTERLACE;
diff --git a/drivers/gpu/drm/panfrost/panfrost_mmu.c b/drivers/gpu/drm/panfrost/panfrost_mmu.c
index 5ff856ef7d88..c81f3ac22cdd 100644
--- a/drivers/gpu/drm/panfrost/panfrost_mmu.c
+++ b/drivers/gpu/drm/panfrost/panfrost_mmu.c
@@ -458,6 +458,7 @@ static int panfrost_mmu_map_fault_addr(struct panfrost_device *pfdev, int as,
 		if (IS_ERR(pages[i])) {
 			mutex_unlock(&bo->base.pages_lock);
 			ret = PTR_ERR(pages[i]);
+			pages[i] = NULL;
 			goto err_pages;
 		}
 	}
diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index bfd7f00a59ec..683fdfa3e723 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -305,6 +305,10 @@ void vmbus_disconnect(void)
  */
 struct vmbus_channel *relid2channel(u32 relid)
 {
+	if (vmbus_connection.channels == NULL) {
+		pr_warn_once("relid2channel: relid=%d: No channels mapped!\n", relid);
+		return NULL;
+	}
 	if (WARN_ON(relid >= MAX_CHANNEL_RELIDS))
 		return NULL;
 	return READ_ONCE(vmbus_connection.channels[relid]);
diff --git a/drivers/hwtracing/coresight/coresight-etm4x-core.c b/drivers/hwtracing/coresight/coresight-etm4x-core.c
index 99df453575f5..059c09a925cc 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -179,7 +179,7 @@ static int etm4_enable_hw(struct etmv4_drvdata *drvdata)
 		writel_relaxed(config->ss_pe_cmp[i],
 			       drvdata->base + TRCSSPCICRn(i));
 	}
-	for (i = 0; i < drvdata->nr_addr_cmp; i++) {
+	for (i = 0; i < drvdata->nr_addr_cmp * 2; i++) {
 		writeq_relaxed(config->addr_val[i],
 			       drvdata->base + TRCACVRn(i));
 		writeq_relaxed(config->addr_acc[i],
diff --git a/drivers/i2c/busses/i2c-imx-lpi2c.c b/drivers/i2c/busses/i2c-imx-lpi2c.c
index 2018dbcf241e..d45ec26d51cb 100644
--- a/drivers/i2c/busses/i2c-imx-lpi2c.c
+++ b/drivers/i2c/busses/i2c-imx-lpi2c.c
@@ -462,6 +462,8 @@ static int lpi2c_imx_xfer(struct i2c_adapter *adapter,
 		if (num == 1 && msgs[0].len == 0)
 			goto stop;
 
+		lpi2c_imx->rx_buf = NULL;
+		lpi2c_imx->tx_buf = NULL;
 		lpi2c_imx->delivered = 0;
 		lpi2c_imx->msglen = msgs[i].len;
 		init_completion(&lpi2c_imx->complete);
diff --git a/drivers/i2c/busses/i2c-ocores.c b/drivers/i2c/busses/i2c-ocores.c
index f5fc75b65a19..71e26aa6bd8f 100644
--- a/drivers/i2c/busses/i2c-ocores.c
+++ b/drivers/i2c/busses/i2c-ocores.c
@@ -343,18 +343,18 @@ static int ocores_poll_wait(struct ocores_i2c *i2c)
  * ocores_isr(), we just add our polling code around it.
  *
  * It can run in atomic context
+ *
+ * Return: 0 on success, -ETIMEDOUT on timeout
  */
-static void ocores_process_polling(struct ocores_i2c *i2c)
+static int ocores_process_polling(struct ocores_i2c *i2c)
 {
-	while (1) {
-		irqreturn_t ret;
-		int err;
+	irqreturn_t ret;
+	int err = 0;
 
+	while (1) {
 		err = ocores_poll_wait(i2c);
-		if (err) {
-			i2c->state = STATE_ERROR;
+		if (err)
 			break; /* timeout */
-		}
 
 		ret = ocores_isr(-1, i2c);
 		if (ret == IRQ_NONE)
@@ -365,13 +365,15 @@ static void ocores_process_polling(struct ocores_i2c *i2c)
 					break;
 		}
 	}
+
+	return err;
 }
 
 static int ocores_xfer_core(struct ocores_i2c *i2c,
 			    struct i2c_msg *msgs, int num,
 			    bool polling)
 {
-	int ret;
+	int ret = 0;
 	u8 ctrl;
 
 	ctrl = oc_getreg(i2c, OCI2C_CONTROL);
@@ -389,15 +391,16 @@ static int ocores_xfer_core(struct ocores_i2c *i2c,
 	oc_setreg(i2c, OCI2C_CMD, OCI2C_CMD_START);
 
 	if (polling) {
-		ocores_process_polling(i2c);
+		ret = ocores_process_polling(i2c);
 	} else {
-		ret = wait_event_timeout(i2c->wait,
-					 (i2c->state == STATE_ERROR) ||
-					 (i2c->state == STATE_DONE), HZ);
-		if (ret == 0) {
-			ocores_process_timeout(i2c);
-			return -ETIMEDOUT;
-		}
+		if (wait_event_timeout(i2c->wait,
+				       (i2c->state == STATE_ERROR) ||
+				       (i2c->state == STATE_DONE), HZ) == 0)
+			ret = -ETIMEDOUT;
+	}
+	if (ret) {
+		ocores_process_timeout(i2c);
+		return ret;
 	}
 
 	return (i2c->state == STATE_DONE) ? num : -EIO;
diff --git a/drivers/iio/adc/ad7791.c b/drivers/iio/adc/ad7791.c
index d57ad966e17c..f3502f12653b 100644
--- a/drivers/iio/adc/ad7791.c
+++ b/drivers/iio/adc/ad7791.c
@@ -253,7 +253,7 @@ static const struct ad_sigma_delta_info ad7791_sigma_delta_info = {
 	.has_registers = true,
 	.addr_shift = 4,
 	.read_mask = BIT(3),
-	.irq_flags = IRQF_TRIGGER_LOW,
+	.irq_flags = IRQF_TRIGGER_FALLING,
 };
 
 static int ad7791_read_raw(struct iio_dev *indio_dev,
diff --git a/drivers/iio/adc/ti-ads7950.c b/drivers/iio/adc/ti-ads7950.c
index a2b83f0bd526..d4583b76f1fe 100644
--- a/drivers/iio/adc/ti-ads7950.c
+++ b/drivers/iio/adc/ti-ads7950.c
@@ -634,6 +634,7 @@ static int ti_ads7950_probe(struct spi_device *spi)
 	st->chip.label = dev_name(&st->spi->dev);
 	st->chip.parent = &st->spi->dev;
 	st->chip.owner = THIS_MODULE;
+	st->chip.can_sleep = true;
 	st->chip.base = -1;
 	st->chip.ngpio = TI_ADS7950_NUM_GPIOS;
 	st->chip.get_direction = ti_ads7950_get_direction;
diff --git a/drivers/iio/dac/cio-dac.c b/drivers/iio/dac/cio-dac.c
index 95813569f394..77a6916b3d6c 100644
--- a/drivers/iio/dac/cio-dac.c
+++ b/drivers/iio/dac/cio-dac.c
@@ -66,8 +66,8 @@ static int cio_dac_write_raw(struct iio_dev *indio_dev,
 	if (mask != IIO_CHAN_INFO_RAW)
 		return -EINVAL;
 
-	/* DAC can only accept up to a 16-bit value */
-	if ((unsigned int)val > 65535)
+	/* DAC can only accept up to a 12-bit value */
+	if ((unsigned int)val > 4095)
 		return -EINVAL;
 
 	priv->chan_out_states[chan->channel] = val;
diff --git a/drivers/iio/light/cm32181.c b/drivers/iio/light/cm32181.c
index 97649944f1df..c14a630dd683 100644
--- a/drivers/iio/light/cm32181.c
+++ b/drivers/iio/light/cm32181.c
@@ -429,6 +429,14 @@ static const struct iio_info cm32181_info = {
 	.attrs			= &cm32181_attribute_group,
 };
 
+static void cm32181_unregister_dummy_client(void *data)
+{
+	struct i2c_client *client = data;
+
+	/* Unregister the dummy client */
+	i2c_unregister_device(client);
+}
+
 static int cm32181_probe(struct i2c_client *client)
 {
 	struct device *dev = &client->dev;
@@ -458,6 +466,10 @@ static int cm32181_probe(struct i2c_client *client)
 		client = i2c_acpi_new_device(dev, 1, &board_info);
 		if (IS_ERR(client))
 			return PTR_ERR(client);
+
+		ret = devm_add_action_or_reset(dev, cm32181_unregister_dummy_client, client);
+		if (ret)
+			return ret;
 	}
 
 	cm32181 = iio_priv(indio_dev);
diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 9ed5de38e372..fdcad8d6a5a0 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -505,22 +505,11 @@ static inline unsigned short cma_family(struct rdma_id_private *id_priv)
 	return id_priv->id.route.addr.src_addr.ss_family;
 }
 
-static int cma_set_qkey(struct rdma_id_private *id_priv, u32 qkey)
+static int cma_set_default_qkey(struct rdma_id_private *id_priv)
 {
 	struct ib_sa_mcmember_rec rec;
 	int ret = 0;
 
-	if (id_priv->qkey) {
-		if (qkey && id_priv->qkey != qkey)
-			return -EINVAL;
-		return 0;
-	}
-
-	if (qkey) {
-		id_priv->qkey = qkey;
-		return 0;
-	}
-
 	switch (id_priv->id.ps) {
 	case RDMA_PS_UDP:
 	case RDMA_PS_IB:
@@ -540,6 +529,16 @@ static int cma_set_qkey(struct rdma_id_private *id_priv, u32 qkey)
 	return ret;
 }
 
+static int cma_set_qkey(struct rdma_id_private *id_priv, u32 qkey)
+{
+	if (!qkey ||
+	    (id_priv->qkey && (id_priv->qkey != qkey)))
+		return -EINVAL;
+
+	id_priv->qkey = qkey;
+	return 0;
+}
+
 static void cma_translate_ib(struct sockaddr_ib *sib, struct rdma_dev_addr *dev_addr)
 {
 	dev_addr->dev_type = ARPHRD_INFINIBAND;
@@ -1107,7 +1106,7 @@ static int cma_ib_init_qp_attr(struct rdma_id_private *id_priv,
 	*qp_attr_mask = IB_QP_STATE | IB_QP_PKEY_INDEX | IB_QP_PORT;
 
 	if (id_priv->id.qp_type == IB_QPT_UD) {
-		ret = cma_set_qkey(id_priv, 0);
+		ret = cma_set_default_qkey(id_priv);
 		if (ret)
 			return ret;
 
@@ -4312,7 +4311,10 @@ static int cma_send_sidr_rep(struct rdma_id_private *id_priv,
 	memset(&rep, 0, sizeof rep);
 	rep.status = status;
 	if (status == IB_SIDR_SUCCESS) {
-		ret = cma_set_qkey(id_priv, qkey);
+		if (qkey)
+			ret = cma_set_qkey(id_priv, qkey);
+		else
+			ret = cma_set_default_qkey(id_priv);
 		if (ret)
 			return ret;
 		rep.qp_num = id_priv->qp_num;
@@ -4516,9 +4518,7 @@ static void cma_make_mc_event(int status, struct rdma_id_private *id_priv,
 	enum ib_gid_type gid_type;
 	struct net_device *ndev;
 
-	if (!status)
-		status = cma_set_qkey(id_priv, be32_to_cpu(multicast->rec.qkey));
-	else
+	if (status)
 		pr_debug_ratelimited("RDMA CM: MULTICAST_ERROR: failed to join multicast. status %d\n",
 				     status);
 
@@ -4546,7 +4546,7 @@ static void cma_make_mc_event(int status, struct rdma_id_private *id_priv,
 	}
 
 	event->param.ud.qp_num = 0xFFFFFF;
-	event->param.ud.qkey = be32_to_cpu(multicast->rec.qkey);
+	event->param.ud.qkey = id_priv->qkey;
 
 out:
 	if (ndev)
@@ -4565,8 +4565,11 @@ static int cma_ib_mc_handler(int status, struct ib_sa_multicast *multicast)
 	    READ_ONCE(id_priv->state) == RDMA_CM_DESTROYING)
 		goto out;
 
-	cma_make_mc_event(status, id_priv, multicast, &event, mc);
-	ret = cma_cm_event_handler(id_priv, &event);
+	ret = cma_set_qkey(id_priv, be32_to_cpu(multicast->rec.qkey));
+	if (!ret) {
+		cma_make_mc_event(status, id_priv, multicast, &event, mc);
+		ret = cma_cm_event_handler(id_priv, &event);
+	}
 	rdma_destroy_ah_attr(&event.param.ud.ah_attr);
 	WARN_ON(ret);
 
@@ -4619,9 +4622,11 @@ static int cma_join_ib_multicast(struct rdma_id_private *id_priv,
 	if (ret)
 		return ret;
 
-	ret = cma_set_qkey(id_priv, 0);
-	if (ret)
-		return ret;
+	if (!id_priv->qkey) {
+		ret = cma_set_default_qkey(id_priv);
+		if (ret)
+			return ret;
+	}
 
 	cma_set_mgid(id_priv, (struct sockaddr *) &mc->addr, &rec.mgid);
 	rec.qkey = cpu_to_be32(id_priv->qkey);
@@ -4709,9 +4714,6 @@ static int cma_iboe_join_multicast(struct rdma_id_private *id_priv,
 	cma_iboe_set_mgid(addr, &ib.rec.mgid, gid_type);
 
 	ib.rec.pkey = cpu_to_be16(0xffff);
-	if (id_priv->id.ps == RDMA_PS_UDP)
-		ib.rec.qkey = cpu_to_be32(RDMA_UDP_QKEY);
-
 	if (dev_addr->bound_dev_if)
 		ndev = dev_get_by_index(dev_addr->net, dev_addr->bound_dev_if);
 	if (!ndev)
@@ -4737,6 +4739,9 @@ static int cma_iboe_join_multicast(struct rdma_id_private *id_priv,
 	if (err || !ib.rec.mtu)
 		return err ?: -EINVAL;
 
+	if (!id_priv->qkey)
+		cma_set_default_qkey(id_priv);
+
 	rdma_ip2gid((struct sockaddr *)&id_priv->id.route.addr.src_addr,
 		    &ib.rec.port_gid);
 	INIT_WORK(&mc->iboe_join.work, cma_iboe_join_work_handler);
@@ -4762,6 +4767,9 @@ int rdma_join_multicast(struct rdma_cm_id *id, struct sockaddr *addr,
 			    READ_ONCE(id_priv->state) != RDMA_CM_ADDR_RESOLVED))
 		return -EINVAL;
 
+	if (id_priv->id.qp_type != IB_QPT_UD)
+		return -EINVAL;
+
 	mc = kzalloc(sizeof(*mc), GFP_KERNEL);
 	if (!mc)
 		return -ENOMEM;
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 5123be0ab02f..4fcabe5a84be 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -535,6 +535,8 @@ static struct ib_ah *_rdma_create_ah(struct ib_pd *pd,
 
 	ret = device->ops.create_ah(ah, &init_attr, udata);
 	if (ret) {
+		if (ah->sgid_attr)
+			rdma_put_gid_attr(ah->sgid_attr);
 		kfree(ah);
 		return ERR_PTR(ret);
 	}
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index eb69bec77e5d..5ef37902e96b 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -425,10 +425,26 @@ static int translate_eth_ext_proto_oper(u32 eth_proto_oper, u16 *active_speed,
 		*active_width = IB_WIDTH_2X;
 		*active_speed = IB_SPEED_HDR;
 		break;
+	case MLX5E_PROT_MASK(MLX5E_100GAUI_1_100GBASE_CR_KR):
+		*active_width = IB_WIDTH_1X;
+		*active_speed = IB_SPEED_NDR;
+		break;
 	case MLX5E_PROT_MASK(MLX5E_200GAUI_4_200GBASE_CR4_KR4):
 		*active_width = IB_WIDTH_4X;
 		*active_speed = IB_SPEED_HDR;
 		break;
+	case MLX5E_PROT_MASK(MLX5E_200GAUI_2_200GBASE_CR2_KR2):
+		*active_width = IB_WIDTH_2X;
+		*active_speed = IB_SPEED_NDR;
+		break;
+	case MLX5E_PROT_MASK(MLX5E_400GAUI_8):
+		*active_width = IB_WIDTH_8X;
+		*active_speed = IB_SPEED_HDR;
+		break;
+	case MLX5E_PROT_MASK(MLX5E_400GAUI_4_400GBASE_CR4_KR4):
+		*active_width = IB_WIDTH_4X;
+		*active_speed = IB_SPEED_NDR;
+		break;
 	default:
 		return -EINVAL;
 	}
diff --git a/drivers/media/platform/ti-vpe/cal.c b/drivers/media/platform/ti-vpe/cal.c
index 93121c90d76a..2eef245c31a1 100644
--- a/drivers/media/platform/ti-vpe/cal.c
+++ b/drivers/media/platform/ti-vpe/cal.c
@@ -624,10 +624,8 @@ static struct cal_ctx *cal_ctx_create(struct cal_dev *cal, int inst)
 	ctx->cport = inst;
 
 	ret = cal_ctx_v4l2_init(ctx);
-	if (ret) {
-		kfree(ctx);
+	if (ret)
 		return NULL;
-	}
 
 	return ctx;
 }
diff --git a/drivers/mtd/mtdblock.c b/drivers/mtd/mtdblock.c
index 32e52d83b961..9e5bbb545702 100644
--- a/drivers/mtd/mtdblock.c
+++ b/drivers/mtd/mtdblock.c
@@ -153,7 +153,7 @@ static int do_cached_write (struct mtdblk_dev *mtdblk, unsigned long pos,
 				mtdblk->cache_state = STATE_EMPTY;
 				ret = mtd_read(mtd, sect_start, sect_size,
 					       &retlen, mtdblk->cache_data);
-				if (ret)
+				if (ret && !mtd_is_bitflip(ret))
 					return ret;
 				if (retlen != sect_size)
 					return -EIO;
@@ -188,8 +188,12 @@ static int do_cached_read (struct mtdblk_dev *mtdblk, unsigned long pos,
 	pr_debug("mtdblock: read on \"%s\" at 0x%lx, size 0x%x\n",
 			mtd->name, pos, len);
 
-	if (!sect_size)
-		return mtd_read(mtd, pos, len, &retlen, buf);
+	if (!sect_size) {
+		ret = mtd_read(mtd, pos, len, &retlen, buf);
+		if (ret && !mtd_is_bitflip(ret))
+			return ret;
+		return 0;
+	}
 
 	while (len > 0) {
 		unsigned long sect_start = (pos/sect_size)*sect_size;
@@ -209,7 +213,7 @@ static int do_cached_read (struct mtdblk_dev *mtdblk, unsigned long pos,
 			memcpy (buf, mtdblk->cache_data + offset, size);
 		} else {
 			ret = mtd_read(mtd, pos, size, &retlen, buf);
-			if (ret)
+			if (ret && !mtd_is_bitflip(ret))
 				return ret;
 			if (retlen != size)
 				return -EIO;
diff --git a/drivers/mtd/nand/raw/meson_nand.c b/drivers/mtd/nand/raw/meson_nand.c
index dc631c514318..228612d82f31 100644
--- a/drivers/mtd/nand/raw/meson_nand.c
+++ b/drivers/mtd/nand/raw/meson_nand.c
@@ -276,7 +276,7 @@ static void meson_nfc_cmd_access(struct nand_chip *nand, int raw, bool dir,
 
 	if (raw) {
 		len = mtd->writesize + mtd->oobsize;
-		cmd = (len & GENMASK(5, 0)) | scrambler | DMA_DIR(dir);
+		cmd = (len & GENMASK(13, 0)) | scrambler | DMA_DIR(dir);
 		writel(cmd, nfc->reg_base + NFC_REG_CMD);
 		return;
 	}
@@ -540,7 +540,7 @@ static int meson_nfc_read_buf(struct nand_chip *nand, u8 *buf, int len)
 	if (ret)
 		goto out;
 
-	cmd = NFC_CMD_N2M | (len & GENMASK(5, 0));
+	cmd = NFC_CMD_N2M | (len & GENMASK(13, 0));
 	writel(cmd, nfc->reg_base + NFC_REG_CMD);
 
 	meson_nfc_drain_cmd(nfc);
@@ -564,7 +564,7 @@ static int meson_nfc_write_buf(struct nand_chip *nand, u8 *buf, int len)
 	if (ret)
 		return ret;
 
-	cmd = NFC_CMD_M2N | (len & GENMASK(5, 0));
+	cmd = NFC_CMD_M2N | (len & GENMASK(13, 0));
 	writel(cmd, nfc->reg_base + NFC_REG_CMD);
 
 	meson_nfc_drain_cmd(nfc);
diff --git a/drivers/mtd/nand/raw/stm32_fmc2_nand.c b/drivers/mtd/nand/raw/stm32_fmc2_nand.c
index 550bda4d1415..c0c47f31c100 100644
--- a/drivers/mtd/nand/raw/stm32_fmc2_nand.c
+++ b/drivers/mtd/nand/raw/stm32_fmc2_nand.c
@@ -1525,6 +1525,9 @@ static int stm32_fmc2_nfc_setup_interface(struct nand_chip *chip, int chipnr,
 	if (IS_ERR(sdrt))
 		return PTR_ERR(sdrt);
 
+	if (conf->timings.mode > 3)
+		return -EOPNOTSUPP;
+
 	if (chipnr == NAND_DATA_IFACE_CHECK_ONLY)
 		return 0;
 
diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index e45fdc1bf66a..929ce489b062 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -665,12 +665,6 @@ static int io_init(struct ubi_device *ubi, int max_beb_per1024)
 	ubi->ec_hdr_alsize = ALIGN(UBI_EC_HDR_SIZE, ubi->hdrs_min_io_size);
 	ubi->vid_hdr_alsize = ALIGN(UBI_VID_HDR_SIZE, ubi->hdrs_min_io_size);
 
-	if (ubi->vid_hdr_offset && ((ubi->vid_hdr_offset + UBI_VID_HDR_SIZE) >
-	    ubi->vid_hdr_alsize)) {
-		ubi_err(ubi, "VID header offset %d too large.", ubi->vid_hdr_offset);
-		return -EINVAL;
-	}
-
 	dbg_gen("min_io_size      %d", ubi->min_io_size);
 	dbg_gen("max_write_size   %d", ubi->max_write_size);
 	dbg_gen("hdrs_min_io_size %d", ubi->hdrs_min_io_size);
@@ -688,6 +682,21 @@ static int io_init(struct ubi_device *ubi, int max_beb_per1024)
 						ubi->vid_hdr_aloffset;
 	}
 
+	/*
+	 * Memory allocation for VID header is ubi->vid_hdr_alsize
+	 * which is described in comments in io.c.
+	 * Make sure VID header shift + UBI_VID_HDR_SIZE not exceeds
+	 * ubi->vid_hdr_alsize, so that all vid header operations
+	 * won't access memory out of bounds.
+	 */
+	if ((ubi->vid_hdr_shift + UBI_VID_HDR_SIZE) > ubi->vid_hdr_alsize) {
+		ubi_err(ubi, "Invalid VID header offset %d, VID header shift(%d)"
+			" + VID header size(%zu) > VID header aligned size(%d).",
+			ubi->vid_hdr_offset, ubi->vid_hdr_shift,
+			UBI_VID_HDR_SIZE, ubi->vid_hdr_alsize);
+		return -EINVAL;
+	}
+
 	/* Similar for the data offset */
 	ubi->leb_start = ubi->vid_hdr_offset + UBI_VID_HDR_SIZE;
 	ubi->leb_start = ALIGN(ubi->leb_start, ubi->min_io_size);
diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index 6da09263e0b9..4427018ad4d9 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -575,6 +575,7 @@ static int erase_worker(struct ubi_device *ubi, struct ubi_work *wl_wrk,
  * @vol_id: the volume ID that last used this PEB
  * @lnum: the last used logical eraseblock number for the PEB
  * @torture: if the physical eraseblock has to be tortured
+ * @nested: denotes whether the work_sem is already held
  *
  * This function returns zero in case of success and a %-ENOMEM in case of
  * failure.
@@ -1066,8 +1067,6 @@ static int ensure_wear_leveling(struct ubi_device *ubi, int nested)
  * __erase_worker - physical eraseblock erase worker function.
  * @ubi: UBI device description object
  * @wl_wrk: the work object
- * @shutdown: non-zero if the worker has to free memory and exit
- * because the WL sub-system is shutting down
  *
  * This function erases a physical eraseblock and perform torture testing if
  * needed. It also takes care about marking the physical eraseblock bad if
@@ -1122,7 +1121,7 @@ static int __erase_worker(struct ubi_device *ubi, struct ubi_work *wl_wrk)
 		int err1;
 
 		/* Re-schedule the LEB for erasure */
-		err1 = schedule_erase(ubi, e, vol_id, lnum, 0, false);
+		err1 = schedule_erase(ubi, e, vol_id, lnum, 0, true);
 		if (err1) {
 			spin_lock(&ubi->wl_lock);
 			wl_entry_destroy(ubi, e);
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index e0d62e251387..70d57ef95fb1 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -884,6 +884,10 @@ static dma_addr_t macb_get_addr(struct macb *bp, struct macb_dma_desc *desc)
 	}
 #endif
 	addr |= MACB_BF(RX_WADDR, MACB_BFEXT(RX_WADDR, desc->addr));
+#ifdef CONFIG_MACB_USE_HWSTAMP
+	if (bp->hw_dma_cap & HW_DMA_CAP_PTP)
+		addr &= ~GEM_BIT(DMA_RXVALID);
+#endif
 	return addr;
 }
 
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c
index 87f76bac2e46..eb827b86ecae 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c
@@ -628,7 +628,13 @@ int qlcnic_fw_create_ctx(struct qlcnic_adapter *dev)
 	int i, err, ring;
 
 	if (dev->flags & QLCNIC_NEED_FLR) {
-		pci_reset_function(dev->pdev);
+		err = pci_reset_function(dev->pdev);
+		if (err) {
+			dev_err(&dev->pdev->dev,
+				"Adapter reset failed (%d). Please reboot\n",
+				err);
+			return err;
+		}
 		dev->flags &= ~QLCNIC_NEED_FLR;
 	}
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 04c59102a286..de66406c5057 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4940,7 +4940,7 @@ static void stmmac_napi_del(struct net_device *dev)
 int stmmac_reinit_queues(struct net_device *dev, u32 rx_cnt, u32 tx_cnt)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
-	int ret = 0;
+	int ret = 0, i;
 
 	if (netif_running(dev))
 		stmmac_release(dev);
@@ -4949,6 +4949,10 @@ int stmmac_reinit_queues(struct net_device *dev, u32 rx_cnt, u32 tx_cnt)
 
 	priv->plat->rx_queues_to_use = rx_cnt;
 	priv->plat->tx_queues_to_use = tx_cnt;
+	if (!netif_is_rxfh_configured(dev))
+		for (i = 0; i < ARRAY_SIZE(priv->rss.table); i++)
+			priv->rss.table[i] = ethtool_rxfh_indir_default(i,
+									rx_cnt);
 
 	stmmac_napi_add(dev);
 
diff --git a/drivers/net/ethernet/sun/niu.c b/drivers/net/ethernet/sun/niu.c
index 860644d182ab..1a269fa8c1a0 100644
--- a/drivers/net/ethernet/sun/niu.c
+++ b/drivers/net/ethernet/sun/niu.c
@@ -4503,7 +4503,7 @@ static int niu_alloc_channels(struct niu *np)
 
 		err = niu_rbr_fill(np, rp, GFP_KERNEL);
 		if (err)
-			return err;
+			goto out_err;
 	}
 
 	tx_rings = kcalloc(num_tx_rings, sizeof(struct tx_ring_info),
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 4074310abcff..e4af1f506b83 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2153,7 +2153,8 @@ static int am65_cpsw_nuss_probe(struct platform_device *pdev)
 	return 0;
 
 err_of_clear:
-	of_platform_device_destroy(common->mdio_dev, NULL);
+	if (common->mdio_dev)
+		of_platform_device_destroy(common->mdio_dev, NULL);
 err_pm_clear:
 	pm_runtime_put_sync(dev);
 	pm_runtime_disable(dev);
@@ -2179,7 +2180,8 @@ static int am65_cpsw_nuss_remove(struct platform_device *pdev)
 	 */
 	am65_cpsw_nuss_cleanup_ndev(common);
 
-	of_platform_device_destroy(common->mdio_dev, NULL);
+	if (common->mdio_dev)
+		of_platform_device_destroy(common->mdio_dev, NULL);
 
 	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index dcbe278086dc..6a5f40f11db3 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -207,6 +207,12 @@ static const enum gpiod_flags gpio_flags[] = {
  */
 #define SFP_PHY_ADDR	22
 
+/* SFP_EEPROM_BLOCK_SIZE is the size of data chunk to read the EEPROM
+ * at a time. Some SFP modules and also some Linux I2C drivers do not like
+ * reads longer than 16 bytes.
+ */
+#define SFP_EEPROM_BLOCK_SIZE	16
+
 struct sff_data {
 	unsigned int gpios;
 	bool (*module_supported)(const struct sfp_eeprom_id *id);
@@ -1754,11 +1760,7 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
 	u8 check;
 	int ret;
 
-	/* Some SFP modules and also some Linux I2C drivers do not like reads
-	 * longer than 16 bytes, so read the EEPROM in chunks of 16 bytes at
-	 * a time.
-	 */
-	sfp->i2c_block_size = 16;
+	sfp->i2c_block_size = SFP_EEPROM_BLOCK_SIZE;
 
 	ret = sfp_read(sfp, false, 0, &id.base, sizeof(id.base));
 	if (ret < 0) {
@@ -2385,6 +2387,7 @@ static struct sfp *sfp_alloc(struct device *dev)
 		return ERR_PTR(-ENOMEM);
 
 	sfp->dev = dev;
+	sfp->i2c_block_size = SFP_EEPROM_BLOCK_SIZE;
 
 	mutex_init(&sfp->sm_mutex);
 	mutex_init(&sfp->st_mutex);
diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index b0024893a1cb..50c34630ca30 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -183,7 +183,7 @@ static const struct mwifiex_pcie_device mwifiex_pcie8997 = {
 	.can_ext_scan = true,
 };
 
-static const struct of_device_id mwifiex_pcie_of_match_table[] = {
+static const struct of_device_id mwifiex_pcie_of_match_table[] __maybe_unused = {
 	{ .compatible = "pci11ab,2b42" },
 	{ .compatible = "pci1b4b,2b42" },
 	{ }
diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index 7fb6eef40928..b09e60fedeb1 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -484,7 +484,7 @@ static struct memory_type_mapping mem_type_mapping_tbl[] = {
 	{"EXTLAST", NULL, 0, 0xFE},
 };
 
-static const struct of_device_id mwifiex_sdio_of_match_table[] = {
+static const struct of_device_id mwifiex_sdio_of_match_table[] __maybe_unused = {
 	{ .compatible = "marvell,sd8787" },
 	{ .compatible = "marvell,sd8897" },
 	{ .compatible = "marvell,sd8997" },
diff --git a/drivers/pinctrl/pinctrl-amd.c b/drivers/pinctrl/pinctrl-amd.c
index 7bfdf5ad77c4..82b658a3c220 100644
--- a/drivers/pinctrl/pinctrl-amd.c
+++ b/drivers/pinctrl/pinctrl-amd.c
@@ -764,34 +764,32 @@ static const struct pinconf_ops amd_pinconf_ops = {
 	.pin_config_group_set = amd_pinconf_group_set,
 };
 
-static void amd_gpio_irq_init_pin(struct amd_gpio *gpio_dev, int pin)
+static void amd_gpio_irq_init(struct amd_gpio *gpio_dev)
 {
-	const struct pin_desc *pd;
+	struct pinctrl_desc *desc = gpio_dev->pctrl->desc;
 	unsigned long flags;
 	u32 pin_reg, mask;
+	int i;
 
 	mask = BIT(WAKE_CNTRL_OFF_S0I3) | BIT(WAKE_CNTRL_OFF_S3) |
 		BIT(INTERRUPT_MASK_OFF) | BIT(INTERRUPT_ENABLE_OFF) |
 		BIT(WAKE_CNTRL_OFF_S4);
 
-	pd = pin_desc_get(gpio_dev->pctrl, pin);
-	if (!pd)
-		return;
+	for (i = 0; i < desc->npins; i++) {
+		int pin = desc->pins[i].number;
+		const struct pin_desc *pd = pin_desc_get(gpio_dev->pctrl, pin);
 
-	raw_spin_lock_irqsave(&gpio_dev->lock, flags);
-	pin_reg = readl(gpio_dev->base + pin * 4);
-	pin_reg &= ~mask;
-	writel(pin_reg, gpio_dev->base + pin * 4);
-	raw_spin_unlock_irqrestore(&gpio_dev->lock, flags);
-}
+		if (!pd)
+			continue;
 
-static void amd_gpio_irq_init(struct amd_gpio *gpio_dev)
-{
-	struct pinctrl_desc *desc = gpio_dev->pctrl->desc;
-	int i;
+		raw_spin_lock_irqsave(&gpio_dev->lock, flags);
 
-	for (i = 0; i < desc->npins; i++)
-		amd_gpio_irq_init_pin(gpio_dev, i);
+		pin_reg = readl(gpio_dev->base + i * 4);
+		pin_reg &= ~mask;
+		writel(pin_reg, gpio_dev->base + i * 4);
+
+		raw_spin_unlock_irqrestore(&gpio_dev->lock, flags);
+	}
 }
 
 #ifdef CONFIG_PM_SLEEP
@@ -844,10 +842,8 @@ static int amd_gpio_resume(struct device *dev)
 	for (i = 0; i < desc->npins; i++) {
 		int pin = desc->pins[i].number;
 
-		if (!amd_gpio_should_save(gpio_dev, pin)) {
-			amd_gpio_irq_init_pin(gpio_dev, pin);
+		if (!amd_gpio_should_save(gpio_dev, pin))
 			continue;
-		}
 
 		raw_spin_lock_irqsave(&gpio_dev->lock, flags);
 		gpio_dev->saved_regs[i] |= readl(gpio_dev->base + pin * 4) & PIN_IRQ_PENDING;
diff --git a/drivers/power/supply/cros_usbpd-charger.c b/drivers/power/supply/cros_usbpd-charger.c
index d89e08efd2ad..0a4f02e4ae7b 100644
--- a/drivers/power/supply/cros_usbpd-charger.c
+++ b/drivers/power/supply/cros_usbpd-charger.c
@@ -276,7 +276,7 @@ static int cros_usbpd_charger_get_power_info(struct port_data *port)
 		port->psy_current_max = 0;
 		break;
 	default:
-		dev_err(dev, "Port %d: default case!\n", port->port_number);
+		dev_dbg(dev, "Port %d: default case!\n", port->port_number);
 		port->psy_usb_type = POWER_SUPPLY_USB_TYPE_SDP;
 	}
 
diff --git a/drivers/pwm/pwm-cros-ec.c b/drivers/pwm/pwm-cros-ec.c
index c1c337969e4e..d4f4a133656c 100644
--- a/drivers/pwm/pwm-cros-ec.c
+++ b/drivers/pwm/pwm-cros-ec.c
@@ -154,6 +154,7 @@ static void cros_ec_pwm_get_state(struct pwm_chip *chip, struct pwm_device *pwm,
 
 	state->enabled = (ret > 0);
 	state->period = EC_PWM_MAX_DUTY;
+	state->polarity = PWM_POLARITY_NORMAL;
 
 	/*
 	 * Note that "disabled" and "duty cycle == 0" are treated the same. If
diff --git a/drivers/pwm/pwm-sprd.c b/drivers/pwm/pwm-sprd.c
index 9eeb59cb81b6..b23456d38bd2 100644
--- a/drivers/pwm/pwm-sprd.c
+++ b/drivers/pwm/pwm-sprd.c
@@ -109,6 +109,7 @@ static void sprd_pwm_get_state(struct pwm_chip *chip, struct pwm_device *pwm,
 	duty = val & SPRD_PWM_DUTY_MSK;
 	tmp = (prescale + 1) * NSEC_PER_SEC * duty;
 	state->duty_cycle = DIV_ROUND_CLOSEST_ULL(tmp, chn->clk_rate);
+	state->polarity = PWM_POLARITY_NORMAL;
 
 	/* Disable PWM clocks if the PWM channel is not in enable state. */
 	if (!state->enabled)
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 252d7881f99c..def9fac7aa4f 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -721,13 +721,12 @@ static int iscsi_sw_tcp_conn_set_param(struct iscsi_cls_conn *cls_conn,
 		iscsi_set_param(cls_conn, param, buf, buflen);
 		break;
 	case ISCSI_PARAM_DATADGST_EN:
-		iscsi_set_param(cls_conn, param, buf, buflen);
-
 		mutex_lock(&tcp_sw_conn->sock_lock);
 		if (!tcp_sw_conn->sock) {
 			mutex_unlock(&tcp_sw_conn->sock_lock);
 			return -ENOTCONN;
 		}
+		iscsi_set_param(cls_conn, param, buf, buflen);
 		tcp_sw_conn->sendpage = conn->datadgst_en ?
 			sock_no_sendpage : tcp_sw_conn->sock->ops->sendpage;
 		mutex_unlock(&tcp_sw_conn->sock_lock);
diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index 1707d6d144d2..6a1428d453f3 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -503,9 +503,6 @@ static int ses_enclosure_find_by_addr(struct enclosure_device *edev,
 	int i;
 	struct ses_component *scomp;
 
-	if (!edev->component[0].scratch)
-		return 0;
-
 	for (i = 0; i < edev->components; i++) {
 		scomp = edev->component[i].scratch;
 		if (scomp->addr != efd->addr)
@@ -596,8 +593,10 @@ static void ses_enclosure_data_process(struct enclosure_device *edev,
 						components++,
 						type_ptr[0],
 						name);
-				else
+				else if (components < edev->components)
 					ecomp = &edev->component[components++];
+				else
+					ecomp = ERR_PTR(-EINVAL);
 
 				if (!IS_ERR(ecomp)) {
 					if (addl_desc_ptr) {
@@ -728,11 +727,6 @@ static int ses_intf_add(struct device *cdev,
 			components += type_ptr[1];
 	}
 
-	if (components == 0) {
-		sdev_printk(KERN_WARNING, sdev, "enclosure has no enumerated components\n");
-		goto err_free;
-	}
-
 	ses_dev->page1 = buf;
 	ses_dev->page1_len = len;
 	buf = NULL;
@@ -774,9 +768,11 @@ static int ses_intf_add(struct device *cdev,
 		buf = NULL;
 	}
 page2_not_supported:
-	scomp = kcalloc(components, sizeof(struct ses_component), GFP_KERNEL);
-	if (!scomp)
-		goto err_free;
+	if (components > 0) {
+		scomp = kcalloc(components, sizeof(struct ses_component), GFP_KERNEL);
+		if (!scomp)
+			goto err_free;
+	}
 
 	edev = enclosure_register(cdev->parent, dev_name(&sdev->sdev_gendev),
 				  components, &ses_enclosure_callbacks);
diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index 99f29bd930bd..f481c260b704 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -809,11 +809,17 @@ static unsigned int lpuart32_tx_empty(struct uart_port *port)
 			struct lpuart_port, port);
 	unsigned long stat = lpuart32_read(port, UARTSTAT);
 	unsigned long sfifo = lpuart32_read(port, UARTFIFO);
+	unsigned long ctrl = lpuart32_read(port, UARTCTRL);
 
 	if (sport->dma_tx_in_progress)
 		return 0;
 
-	if (stat & UARTSTAT_TC && sfifo & UARTFIFO_TXEMPT)
+	/*
+	 * LPUART Transmission Complete Flag may never be set while queuing a break
+	 * character, so avoid checking for transmission complete when UARTCTRL_SBK
+	 * is asserted.
+	 */
+	if ((stat & UARTSTAT_TC && sfifo & UARTFIFO_TXEMPT) || ctrl & UARTCTRL_SBK)
 		return TIOCSER_TEMT;
 
 	return 0;
diff --git a/drivers/tty/serial/sh-sci.c b/drivers/tty/serial/sh-sci.c
index 8d924727d6f0..a7c28543c6f7 100644
--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -31,6 +31,7 @@
 #include <linux/ioport.h>
 #include <linux/ktime.h>
 #include <linux/major.h>
+#include <linux/minmax.h>
 #include <linux/module.h>
 #include <linux/mm.h>
 #include <linux/of.h>
@@ -2923,6 +2924,13 @@ static int sci_init_single(struct platform_device *dev,
 			sci_port->irqs[i] = platform_get_irq(dev, i);
 	}
 
+	/*
+	 * The fourth interrupt on SCI port is transmit end interrupt, so
+	 * shuffle the interrupts.
+	 */
+	if (p->type == PORT_SCI)
+		swap(sci_port->irqs[SCIx_BRI_IRQ], sci_port->irqs[SCIx_TEI_IRQ]);
+
 	/* The SCI generates several interrupts. They can be muxed together or
 	 * connected to different interrupt lines. In the muxed case only one
 	 * interrupt resource is specified as there is only one interrupt ID.
@@ -2988,7 +2996,7 @@ static int sci_init_single(struct platform_device *dev,
 	port->flags		= UPF_FIXED_PORT | UPF_BOOT_AUTOCONF | p->flags;
 	port->fifosize		= sci_port->params->fifosize;
 
-	if (port->type == PORT_SCI) {
+	if (port->type == PORT_SCI && !dev->dev.of_node) {
 		if (sci_port->reg_size >= 0x20)
 			port->regshift = 2;
 		else
diff --git a/drivers/usb/host/xhci-tegra.c b/drivers/usb/host/xhci-tegra.c
index 246a3d274142..9fa4f8f39830 100644
--- a/drivers/usb/host/xhci-tegra.c
+++ b/drivers/usb/host/xhci-tegra.c
@@ -1175,6 +1175,9 @@ static void tegra_xhci_id_work(struct work_struct *work)
 
 	mutex_unlock(&tegra->lock);
 
+	tegra->otg_usb3_port = tegra_xusb_padctl_get_usb3_companion(tegra->padctl,
+								    tegra->otg_usb2_port);
+
 	if (tegra->host_mode) {
 		/* switch to host mode */
 		if (tegra->otg_usb3_port >= 0) {
@@ -1243,9 +1246,6 @@ static int tegra_xhci_id_notify(struct notifier_block *nb,
 	}
 
 	tegra->otg_usb2_port = tegra_xusb_get_usb2_port(tegra, usbphy);
-	tegra->otg_usb3_port = tegra_xusb_padctl_get_usb3_companion(
-							tegra->padctl,
-							tegra->otg_usb2_port);
 
 	tegra->host_mode = (usbphy->last_event == USB_EVENT_ID) ? true : false;
 
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 473b0b64dd57..b069fe3f8ab0 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -9,6 +9,7 @@
  */
 
 #include <linux/pci.h>
+#include <linux/iommu.h>
 #include <linux/iopoll.h>
 #include <linux/irq.h>
 #include <linux/log2.h>
@@ -226,6 +227,7 @@ int xhci_reset(struct xhci_hcd *xhci, u64 timeout_us)
 static void xhci_zero_64b_regs(struct xhci_hcd *xhci)
 {
 	struct device *dev = xhci_to_hcd(xhci)->self.sysdev;
+	struct iommu_domain *domain;
 	int err, i;
 	u64 val;
 	u32 intrs;
@@ -244,7 +246,9 @@ static void xhci_zero_64b_regs(struct xhci_hcd *xhci)
 	 * an iommu. Doing anything when there is no iommu is definitely
 	 * unsafe...
 	 */
-	if (!(xhci->quirks & XHCI_ZERO_64B_REGS) || !device_iommu_mapped(dev))
+	domain = iommu_get_domain_for_dev(dev);
+	if (!(xhci->quirks & XHCI_ZERO_64B_REGS) || !domain ||
+	    domain->type == IOMMU_DOMAIN_IDENTITY)
 		return;
 
 	xhci_info(xhci, "Zeroing 64bit base registers, expecting fault\n");
diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index 9ee0fa775612..045e24174e1a 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -124,6 +124,7 @@ static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x10C4, 0x826B) }, /* Cygnal Integrated Products, Inc., Fasttrax GPS demonstration module */
 	{ USB_DEVICE(0x10C4, 0x8281) }, /* Nanotec Plug & Drive */
 	{ USB_DEVICE(0x10C4, 0x8293) }, /* Telegesis ETRX2USB */
+	{ USB_DEVICE(0x10C4, 0x82AA) }, /* Silicon Labs IFS-USB-DATACABLE used with Quint UPS */
 	{ USB_DEVICE(0x10C4, 0x82EF) }, /* CESINEL FALCO 6105 AC Power Supply */
 	{ USB_DEVICE(0x10C4, 0x82F1) }, /* CESINEL MEDCAL EFD Earth Fault Detector */
 	{ USB_DEVICE(0x10C4, 0x82F2) }, /* CESINEL MEDCAL ST Network Analyzer */
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 14a7af7f3bcd..da8b7bd39703 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1198,6 +1198,8 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_RM520N, 0xff, 0xff, 0x30) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_RM520N, 0xff, 0, 0x40) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_RM520N, 0xff, 0, 0) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, 0x0900, 0xff, 0, 0), /* RM500U-CN */
+	  .driver_info = ZLP },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EC200U, 0xff, 0, 0) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EC200S_CN, 0xff, 0, 0) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EC200T, 0xff, 0, 0) },
@@ -1300,6 +1302,14 @@ static const struct usb_device_id option_ids[] = {
 	  .driver_info = NCTRL(0) | RSVD(1) },
 	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1075, 0xff),	/* Telit FN990 (PCIe) */
 	  .driver_info = RSVD(0) },
+	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1080, 0xff),	/* Telit FE990 (rmnet) */
+	  .driver_info = NCTRL(0) | RSVD(1) | RSVD(2) },
+	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1081, 0xff),	/* Telit FE990 (MBIM) */
+	  .driver_info = NCTRL(0) | RSVD(1) },
+	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1082, 0xff),	/* Telit FE990 (RNDIS) */
+	  .driver_info = NCTRL(2) | RSVD(3) },
+	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1083, 0xff),	/* Telit FE990 (ECM) */
+	  .driver_info = NCTRL(0) | RSVD(1) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_ME910),
 	  .driver_info = NCTRL(0) | RSVD(1) | RSVD(3) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_ME910_DUAL_MODEM),
diff --git a/drivers/usb/typec/altmodes/displayport.c b/drivers/usb/typec/altmodes/displayport.c
index e8eaca5a84db..07b656172068 100644
--- a/drivers/usb/typec/altmodes/displayport.c
+++ b/drivers/usb/typec/altmodes/displayport.c
@@ -101,8 +101,12 @@ static int dp_altmode_configure(struct dp_altmode *dp, u8 con)
 		if (dp->data.status & DP_STATUS_PREFER_MULTI_FUNC &&
 		    pin_assign & DP_PIN_ASSIGN_MULTI_FUNC_MASK)
 			pin_assign &= DP_PIN_ASSIGN_MULTI_FUNC_MASK;
-		else if (pin_assign & DP_PIN_ASSIGN_DP_ONLY_MASK)
+		else if (pin_assign & DP_PIN_ASSIGN_DP_ONLY_MASK) {
 			pin_assign &= DP_PIN_ASSIGN_DP_ONLY_MASK;
+			/* Default to pin assign C if available */
+			if (pin_assign & BIT(DP_PIN_ASSIGN_C))
+				pin_assign = BIT(DP_PIN_ASSIGN_C);
+		}
 
 		if (!pin_assign)
 			return -EINVAL;
diff --git a/drivers/video/fbdev/core/fbmem.c b/drivers/video/fbdev/core/fbmem.c
index d787a344b3b8..1704deaf4152 100644
--- a/drivers/video/fbdev/core/fbmem.c
+++ b/drivers/video/fbdev/core/fbmem.c
@@ -1117,6 +1117,8 @@ static long do_fb_ioctl(struct fb_info *info, unsigned int cmd,
 	case FBIOPUT_VSCREENINFO:
 		if (copy_from_user(&var, argp, sizeof(var)))
 			return -EFAULT;
+		/* only for kernel-internal use */
+		var.activate &= ~FB_ACTIVATE_KD_TEXT;
 		console_lock();
 		lock_fb_info(info);
 		ret = fbcon_modechange_possible(info, &var);
diff --git a/drivers/watchdog/sbsa_gwdt.c b/drivers/watchdog/sbsa_gwdt.c
index f0f1e3b2e463..4cbe6ba52754 100644
--- a/drivers/watchdog/sbsa_gwdt.c
+++ b/drivers/watchdog/sbsa_gwdt.c
@@ -121,6 +121,7 @@ static int sbsa_gwdt_set_timeout(struct watchdog_device *wdd,
 	struct sbsa_gwdt *gwdt = watchdog_get_drvdata(wdd);
 
 	wdd->timeout = timeout;
+	timeout = clamp_t(unsigned int, timeout, 1, wdd->max_hw_heartbeat_ms / 1000);
 
 	if (action)
 		writel(gwdt->clk * timeout,
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index f2abd8bfd4a0..2a7778a88f03 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2246,6 +2246,23 @@ static int btrfs_init_csum_hash(struct btrfs_fs_info *fs_info, u16 csum_type)
 
 	fs_info->csum_shash = csum_shash;
 
+	/*
+	 * Check if the checksum implementation is a fast accelerated one.
+	 * As-is this is a bit of a hack and should be replaced once the csum
+	 * implementations provide that information themselves.
+	 */
+	switch (csum_type) {
+	case BTRFS_CSUM_TYPE_CRC32:
+		if (!strstr(crypto_shash_driver_name(csum_shash), "generic"))
+			set_bit(BTRFS_FS_CSUM_IMPL_FAST, &fs_info->flags);
+		break;
+	default:
+		break;
+	}
+
+	btrfs_info(fs_info, "using %s (%s) checksum algorithm",
+			btrfs_super_csum_name(csum_type),
+			crypto_shash_driver_name(csum_shash));
 	return 0;
 }
 
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 8bf8cdb62a3a..b33505330e33 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1692,8 +1692,6 @@ static struct dentry *btrfs_mount_root(struct file_system_type *fs_type,
 	} else {
 		snprintf(s->s_id, sizeof(s->s_id), "%pg", bdev);
 		btrfs_sb(s)->bdev_holder = fs_type;
-		if (!strstr(crc32c_impl(), "generic"))
-			set_bit(BTRFS_FS_CSUM_IMPL_FAST, &fs_info->flags);
 		error = btrfs_fill_super(s, fs_devices, data);
 	}
 	if (!error)
diff --git a/fs/nfsd/nfs4callback.c b/fs/nfsd/nfs4callback.c
index af2064e36ac6..f5b7ad0847f2 100644
--- a/fs/nfsd/nfs4callback.c
+++ b/fs/nfsd/nfs4callback.c
@@ -875,8 +875,8 @@ static const struct cred *get_backchannel_cred(struct nfs4_client *clp, struct r
 		if (!kcred)
 			return NULL;
 
-		kcred->uid = ses->se_cb_sec.uid;
-		kcred->gid = ses->se_cb_sec.gid;
+		kcred->fsuid = ses->se_cb_sec.uid;
+		kcred->fsgid = ses->se_cb_sec.gid;
 		return kcred;
 	}
 }
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 5ee4973525f0..5e835bbf1ffb 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2614,11 +2614,10 @@ static int nilfs_segctor_thread(void *arg)
 	goto loop;
 
  end_thread:
-	spin_unlock(&sci->sc_state_lock);
-
 	/* end sync. */
 	sci->sc_task = NULL;
 	wake_up(&sci->sc_wait_task); /* for nilfs_segctor_kill_thread() */
+	spin_unlock(&sci->sc_state_lock);
 	return 0;
 }
 
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 775184868763..9aae60d9a32e 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -482,6 +482,7 @@ static void nilfs_put_super(struct super_block *sb)
 		up_write(&nilfs->ns_sem);
 	}
 
+	nilfs_sysfs_delete_device_group(nilfs);
 	iput(nilfs->ns_sufile);
 	iput(nilfs->ns_cpfile);
 	iput(nilfs->ns_dat);
@@ -1105,6 +1106,7 @@ nilfs_fill_super(struct super_block *sb, void *data, int silent)
 	nilfs_put_root(fsroot);
 
  failed_unload:
+	nilfs_sysfs_delete_device_group(nilfs);
 	iput(nilfs->ns_sufile);
 	iput(nilfs->ns_cpfile);
 	iput(nilfs->ns_dat);
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 38a1206cf948..d8d08fa5c340 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -87,7 +87,6 @@ void destroy_nilfs(struct the_nilfs *nilfs)
 {
 	might_sleep();
 	if (nilfs_init(nilfs)) {
-		nilfs_sysfs_delete_device_group(nilfs);
 		brelse(nilfs->ns_sbh[0]);
 		brelse(nilfs->ns_sbh[1]);
 	}
@@ -305,6 +304,10 @@ int load_nilfs(struct the_nilfs *nilfs, struct super_block *sb)
 		goto failed;
 	}
 
+	err = nilfs_sysfs_create_device_group(sb);
+	if (unlikely(err))
+		goto sysfs_error;
+
 	if (valid_fs)
 		goto skip_recovery;
 
@@ -366,6 +369,9 @@ int load_nilfs(struct the_nilfs *nilfs, struct super_block *sb)
 	goto failed;
 
  failed_unload:
+	nilfs_sysfs_delete_device_group(nilfs);
+
+ sysfs_error:
 	iput(nilfs->ns_cpfile);
 	iput(nilfs->ns_sufile);
 	iput(nilfs->ns_dat);
@@ -697,10 +703,6 @@ int init_nilfs(struct the_nilfs *nilfs, struct super_block *sb, char *data)
 	if (err)
 		goto failed_sbh;
 
-	err = nilfs_sysfs_create_device_group(sb);
-	if (err)
-		goto failed_sbh;
-
 	set_nilfs_init(nilfs);
 	err = 0;
  out:
diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 3e06e9a8cf59..42465693dbdc 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -3396,10 +3396,12 @@ void ocfs2_dlm_shutdown(struct ocfs2_super *osb,
 	ocfs2_lock_res_free(&osb->osb_nfs_sync_lockres);
 	ocfs2_lock_res_free(&osb->osb_orphan_scan.os_lockres);
 
-	ocfs2_cluster_disconnect(osb->cconn, hangup_pending);
-	osb->cconn = NULL;
+	if (osb->cconn) {
+		ocfs2_cluster_disconnect(osb->cconn, hangup_pending);
+		osb->cconn = NULL;
 
-	ocfs2_dlm_shutdown_debug(osb);
+		ocfs2_dlm_shutdown_debug(osb);
+	}
 }
 
 static int ocfs2_drop_lock(struct ocfs2_super *osb,
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 3e0b2e3e00ad..04ce30ae4404 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1922,8 +1922,7 @@ static void ocfs2_dismount_volume(struct super_block *sb, int mnt_err)
 	    !ocfs2_is_hard_readonly(osb))
 		hangup_needed = 1;
 
-	if (osb->cconn)
-		ocfs2_dlm_shutdown(osb, hangup_needed);
+	ocfs2_dlm_shutdown(osb, hangup_needed);
 
 	ocfs2_blockcheck_stats_debugfs_remove(&osb->osb_ecc_stats);
 	debugfs_remove_recursive(osb->osb_debug_root);
diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index cd7c6c4af83a..1655b7b2a5ab 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -1106,6 +1106,11 @@ static int sysctl_check_table_array(const char *path, struct ctl_table *table)
 			err |= sysctl_err(path, table, "array not allowed");
 	}
 
+	if (table->proc_handler == proc_dou8vec_minmax) {
+		if (table->maxlen != sizeof(u8))
+			err |= sysctl_err(path, table, "array not allowed");
+	}
+
 	return err;
 }
 
@@ -1121,6 +1126,7 @@ static int sysctl_check_table(const char *path, struct ctl_table *table)
 		    (table->proc_handler == proc_douintvec) ||
 		    (table->proc_handler == proc_douintvec_minmax) ||
 		    (table->proc_handler == proc_dointvec_minmax) ||
+		    (table->proc_handler == proc_dou8vec_minmax) ||
 		    (table->proc_handler == proc_dointvec_jiffies) ||
 		    (table->proc_handler == proc_dointvec_userhz_jiffies) ||
 		    (table->proc_handler == proc_dointvec_ms_jiffies) ||
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 1bd3a0356ae4..b9dd113599eb 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -811,7 +811,7 @@ static inline void __ftrace_enabled_restore(int enabled)
 #define CALLER_ADDR5 ((unsigned long)ftrace_return_address(5))
 #define CALLER_ADDR6 ((unsigned long)ftrace_return_address(6))
 
-static inline unsigned long get_lock_parent_ip(void)
+static __always_inline unsigned long get_lock_parent_ip(void)
 {
 	unsigned long addr = CALLER_ADDR0;
 
diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index a1f12e959bba..3c1deba496c9 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -380,8 +380,8 @@ extern note_buf_t __percpu *crash_notes;
 extern bool kexec_in_progress;
 
 int crash_shrink_memory(unsigned long new_size);
-size_t crash_get_memory_size(void);
 void crash_free_reserved_phys_range(unsigned long begin, unsigned long end);
+ssize_t crash_get_memory_size(void);
 
 void arch_kexec_protect_crashkres(void);
 void arch_kexec_unprotect_crashkres(void);
diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index 161eba9fd912..4393de94cb32 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -53,6 +53,8 @@ int proc_douintvec(struct ctl_table *, int, void *, size_t *, loff_t *);
 int proc_dointvec_minmax(struct ctl_table *, int, void *, size_t *, loff_t *);
 int proc_douintvec_minmax(struct ctl_table *table, int write, void *buffer,
 		size_t *lenp, loff_t *ppos);
+int proc_dou8vec_minmax(struct ctl_table *table, int write, void *buffer,
+			size_t *lenp, loff_t *ppos);
 int proc_dointvec_jiffies(struct ctl_table *, int, void *, size_t *, loff_t *);
 int proc_dointvec_userhz_jiffies(struct ctl_table *, int, void *, size_t *,
 		loff_t *);
diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index 75484f425e55..d8b320cf54ba 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -84,41 +84,41 @@ struct netns_ipv4 {
 	struct xt_table		*nat_table;
 #endif
 
-	int sysctl_icmp_echo_ignore_all;
-	int sysctl_icmp_echo_ignore_broadcasts;
-	int sysctl_icmp_ignore_bogus_error_responses;
+	u8 sysctl_icmp_echo_ignore_all;
+	u8 sysctl_icmp_echo_ignore_broadcasts;
+	u8 sysctl_icmp_ignore_bogus_error_responses;
+	u8 sysctl_icmp_errors_use_inbound_ifaddr;
 	int sysctl_icmp_ratelimit;
 	int sysctl_icmp_ratemask;
-	int sysctl_icmp_errors_use_inbound_ifaddr;
 
 	struct local_ports ip_local_ports;
 
-	int sysctl_tcp_ecn;
-	int sysctl_tcp_ecn_fallback;
+	u8 sysctl_tcp_ecn;
+	u8 sysctl_tcp_ecn_fallback;
 
-	int sysctl_ip_default_ttl;
-	int sysctl_ip_no_pmtu_disc;
-	int sysctl_ip_fwd_use_pmtu;
+	u8 sysctl_ip_default_ttl;
+	u8 sysctl_ip_no_pmtu_disc;
+	u8 sysctl_ip_fwd_use_pmtu;
 	int sysctl_ip_fwd_update_priority;
-	int sysctl_ip_nonlocal_bind;
-	int sysctl_ip_autobind_reuse;
+	u8 sysctl_ip_nonlocal_bind;
+	u8 sysctl_ip_autobind_reuse;
 	/* Shall we try to damage output packets if routing dev changes? */
-	int sysctl_ip_dynaddr;
-	int sysctl_ip_early_demux;
+	u8 sysctl_ip_dynaddr;
+	u8 sysctl_ip_early_demux;
 #ifdef CONFIG_NET_L3_MASTER_DEV
-	int sysctl_raw_l3mdev_accept;
+	u8 sysctl_raw_l3mdev_accept;
 #endif
 	int sysctl_tcp_early_demux;
 	int sysctl_udp_early_demux;
 
-	int sysctl_nexthop_compat_mode;
+	u8 sysctl_nexthop_compat_mode;
 
-	int sysctl_fwmark_reflect;
-	int sysctl_tcp_fwmark_accept;
+	u8 sysctl_fwmark_reflect;
+	u8 sysctl_tcp_fwmark_accept;
 #ifdef CONFIG_NET_L3_MASTER_DEV
-	int sysctl_tcp_l3mdev_accept;
+	u8 sysctl_tcp_l3mdev_accept;
 #endif
-	int sysctl_tcp_mtu_probing;
+	u8 sysctl_tcp_mtu_probing;
 	int sysctl_tcp_mtu_probe_floor;
 	int sysctl_tcp_base_mss;
 	int sysctl_tcp_min_snd_mss;
@@ -126,46 +126,47 @@ struct netns_ipv4 {
 	u32 sysctl_tcp_probe_interval;
 
 	int sysctl_tcp_keepalive_time;
-	int sysctl_tcp_keepalive_probes;
 	int sysctl_tcp_keepalive_intvl;
+	u8 sysctl_tcp_keepalive_probes;
 
-	int sysctl_tcp_syn_retries;
-	int sysctl_tcp_synack_retries;
-	int sysctl_tcp_syncookies;
+	u8 sysctl_tcp_syn_retries;
+	u8 sysctl_tcp_synack_retries;
+	u8 sysctl_tcp_syncookies;
 	int sysctl_tcp_reordering;
-	int sysctl_tcp_retries1;
-	int sysctl_tcp_retries2;
-	int sysctl_tcp_orphan_retries;
+	u8 sysctl_tcp_retries1;
+	u8 sysctl_tcp_retries2;
+	u8 sysctl_tcp_orphan_retries;
+	u8 sysctl_tcp_tw_reuse;
 	int sysctl_tcp_fin_timeout;
 	unsigned int sysctl_tcp_notsent_lowat;
-	int sysctl_tcp_tw_reuse;
-	int sysctl_tcp_sack;
-	int sysctl_tcp_window_scaling;
-	int sysctl_tcp_timestamps;
-	int sysctl_tcp_early_retrans;
-	int sysctl_tcp_recovery;
-	int sysctl_tcp_thin_linear_timeouts;
-	int sysctl_tcp_slow_start_after_idle;
-	int sysctl_tcp_retrans_collapse;
-	int sysctl_tcp_stdurg;
-	int sysctl_tcp_rfc1337;
-	int sysctl_tcp_abort_on_overflow;
-	int sysctl_tcp_fack;
+	u8 sysctl_tcp_sack;
+	u8 sysctl_tcp_window_scaling;
+	u8 sysctl_tcp_timestamps;
+	u8 sysctl_tcp_early_retrans;
+	u8 sysctl_tcp_recovery;
+	u8 sysctl_tcp_thin_linear_timeouts;
+	u8 sysctl_tcp_slow_start_after_idle;
+	u8 sysctl_tcp_retrans_collapse;
+	u8 sysctl_tcp_stdurg;
+	u8 sysctl_tcp_rfc1337;
+	u8 sysctl_tcp_abort_on_overflow;
+	u8 sysctl_tcp_fack; /* obsolete */
 	int sysctl_tcp_max_reordering;
-	int sysctl_tcp_dsack;
-	int sysctl_tcp_app_win;
 	int sysctl_tcp_adv_win_scale;
-	int sysctl_tcp_frto;
-	int sysctl_tcp_nometrics_save;
-	int sysctl_tcp_no_ssthresh_metrics_save;
-	int sysctl_tcp_moderate_rcvbuf;
-	int sysctl_tcp_tso_win_divisor;
-	int sysctl_tcp_workaround_signed_windows;
+	u8 sysctl_tcp_dsack;
+	u8 sysctl_tcp_app_win;
+	u8 sysctl_tcp_frto;
+	u8 sysctl_tcp_nometrics_save;
+	u8 sysctl_tcp_no_ssthresh_metrics_save;
+	u8 sysctl_tcp_moderate_rcvbuf;
+	u8 sysctl_tcp_tso_win_divisor;
+	u8 sysctl_tcp_workaround_signed_windows;
 	int sysctl_tcp_limit_output_bytes;
 	int sysctl_tcp_challenge_ack_limit;
-	int sysctl_tcp_min_tso_segs;
 	int sysctl_tcp_min_rtt_wlen;
-	int sysctl_tcp_autocorking;
+	u8 sysctl_tcp_min_tso_segs;
+	u8 sysctl_tcp_autocorking;
+	u8 sysctl_tcp_reflect_tos;
 	int sysctl_tcp_invalid_ratelimit;
 	int sysctl_tcp_pacing_ss_ratio;
 	int sysctl_tcp_pacing_ca_ratio;
@@ -183,7 +184,6 @@ struct netns_ipv4 {
 	unsigned int sysctl_tcp_fastopen_blackhole_timeout;
 	atomic_t tfo_active_disable_times;
 	unsigned long tfo_active_disable_stamp;
-	int sysctl_tcp_reflect_tos;
 
 	int sysctl_udp_wmem_min;
 	int sysctl_udp_rmem_min;
diff --git a/init/Kconfig b/init/Kconfig
index eba883d6d9ed..9807c66b24bb 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -47,6 +47,18 @@ config CLANG_VERSION
 	int
 	default $(shell,$(srctree)/scripts/clang-version.sh $(CC))
 
+config AS_IS_GNU
+	def_bool $(success,test "$(as-name)" = GNU)
+
+config AS_IS_LLVM
+	def_bool $(success,test "$(as-name)" = LLVM)
+
+config AS_VERSION
+	int
+	# Use clang version if this is the integrated assembler
+	default CLANG_VERSION if AS_IS_LLVM
+	default $(as-version)
+
 config LLD_VERSION
 	int
 	default $(shell,$(srctree)/scripts/lld-version.sh $(LD))
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 43270b07b2e0..b476591168dc 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2188,11 +2188,15 @@ static int cpuset_can_attach(struct cgroup_taskset *tset)
 static void cpuset_cancel_attach(struct cgroup_taskset *tset)
 {
 	struct cgroup_subsys_state *css;
+	struct cpuset *cs;
 
 	cgroup_taskset_first(tset, &css);
+	cs = css_cs(css);
 
 	percpu_down_write(&cpuset_rwsem);
-	css_cs(css)->attach_in_progress--;
+	cs->attach_in_progress--;
+	if (!cs->attach_in_progress)
+		wake_up(&cpuset_attach_wq);
 	percpu_up_write(&cpuset_rwsem);
 }
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index e2e1371fbb9d..f0df3bc0e641 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -11622,7 +11622,7 @@ perf_event_set_output(struct perf_event *event, struct perf_event *output_event)
 	/*
 	 * If its not a per-cpu rb, it must be the same task.
 	 */
-	if (output_event->cpu == -1 && output_event->ctx != event->ctx)
+	if (output_event->cpu == -1 && output_event->hw.target != event->hw.target)
 		goto out;
 
 	/*
diff --git a/kernel/kexec.c b/kernel/kexec.c
index c82c6c06f051..f0f0c6555454 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -110,6 +110,14 @@ static int do_kexec_load(unsigned long entry, unsigned long nr_segments,
 	unsigned long i;
 	int ret;
 
+	/*
+	 * Because we write directly to the reserved memory region when loading
+	 * crash kernels we need a serialization here to prevent multiple crash
+	 * kernels from attempting to load simultaneously.
+	 */
+	if (!kexec_trylock())
+		return -EBUSY;
+
 	if (flags & KEXEC_ON_CRASH) {
 		dest_image = &kexec_crash_image;
 		if (kexec_crash_image)
@@ -121,7 +129,8 @@ static int do_kexec_load(unsigned long entry, unsigned long nr_segments,
 	if (nr_segments == 0) {
 		/* Uninstall image */
 		kimage_free(xchg(dest_image, NULL));
-		return 0;
+		ret = 0;
+		goto out_unlock;
 	}
 	if (flags & KEXEC_ON_CRASH) {
 		/*
@@ -134,7 +143,7 @@ static int do_kexec_load(unsigned long entry, unsigned long nr_segments,
 
 	ret = kimage_alloc_init(&image, entry, nr_segments, segments, flags);
 	if (ret)
-		return ret;
+		goto out_unlock;
 
 	if (flags & KEXEC_PRESERVE_CONTEXT)
 		image->preserve_context = 1;
@@ -171,6 +180,8 @@ static int do_kexec_load(unsigned long entry, unsigned long nr_segments,
 		arch_kexec_protect_crashkres();
 
 	kimage_free(image);
+out_unlock:
+	kexec_unlock();
 	return ret;
 }
 
@@ -247,21 +258,8 @@ SYSCALL_DEFINE4(kexec_load, unsigned long, entry, unsigned long, nr_segments,
 		((flags & KEXEC_ARCH_MASK) != KEXEC_ARCH_DEFAULT))
 		return -EINVAL;
 
-	/* Because we write directly to the reserved memory
-	 * region when loading crash kernels we need a mutex here to
-	 * prevent multiple crash  kernels from attempting to load
-	 * simultaneously, and to prevent a crash kernel from loading
-	 * over the top of a in use crash kernel.
-	 *
-	 * KISS: always take the mutex.
-	 */
-	if (!mutex_trylock(&kexec_mutex))
-		return -EBUSY;
-
 	result = do_kexec_load(entry, nr_segments, segments, flags);
 
-	mutex_unlock(&kexec_mutex);
-
 	return result;
 }
 
@@ -301,21 +299,8 @@ COMPAT_SYSCALL_DEFINE4(kexec_load, compat_ulong_t, entry,
 			return -EFAULT;
 	}
 
-	/* Because we write directly to the reserved memory
-	 * region when loading crash kernels we need a mutex here to
-	 * prevent multiple crash  kernels from attempting to load
-	 * simultaneously, and to prevent a crash kernel from loading
-	 * over the top of a in use crash kernel.
-	 *
-	 * KISS: always take the mutex.
-	 */
-	if (!mutex_trylock(&kexec_mutex))
-		return -EBUSY;
-
 	result = do_kexec_load(entry, nr_segments, ksegments, flags);
 
-	mutex_unlock(&kexec_mutex);
-
 	return result;
 }
 #endif
diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
index c589c7a9562c..7a8104d48997 100644
--- a/kernel/kexec_core.c
+++ b/kernel/kexec_core.c
@@ -45,7 +45,7 @@
 #include <crypto/sha.h>
 #include "kexec_internal.h"
 
-DEFINE_MUTEX(kexec_mutex);
+atomic_t __kexec_lock = ATOMIC_INIT(0);
 
 /* Per cpu memory for storing cpu states in case of system crash. */
 note_buf_t __percpu *crash_notes;
@@ -943,7 +943,7 @@ int kexec_load_disabled;
  */
 void __noclone __crash_kexec(struct pt_regs *regs)
 {
-	/* Take the kexec_mutex here to prevent sys_kexec_load
+	/* Take the kexec_lock here to prevent sys_kexec_load
 	 * running on one cpu from replacing the crash kernel
 	 * we are using after a panic on a different cpu.
 	 *
@@ -951,7 +951,7 @@ void __noclone __crash_kexec(struct pt_regs *regs)
 	 * of memory the xchg(&kexec_crash_image) would be
 	 * sufficient.  But since I reuse the memory...
 	 */
-	if (mutex_trylock(&kexec_mutex)) {
+	if (kexec_trylock()) {
 		if (kexec_crash_image) {
 			struct pt_regs fixed_regs;
 
@@ -960,7 +960,7 @@ void __noclone __crash_kexec(struct pt_regs *regs)
 			machine_crash_shutdown(&fixed_regs);
 			machine_kexec(kexec_crash_image);
 		}
-		mutex_unlock(&kexec_mutex);
+		kexec_unlock();
 	}
 }
 STACK_FRAME_NON_STANDARD(__crash_kexec);
@@ -989,14 +989,17 @@ void crash_kexec(struct pt_regs *regs)
 	}
 }
 
-size_t crash_get_memory_size(void)
+ssize_t crash_get_memory_size(void)
 {
-	size_t size = 0;
+	ssize_t size = 0;
+
+	if (!kexec_trylock())
+		return -EBUSY;
 
-	mutex_lock(&kexec_mutex);
 	if (crashk_res.end != crashk_res.start)
 		size = resource_size(&crashk_res);
-	mutex_unlock(&kexec_mutex);
+
+	kexec_unlock();
 	return size;
 }
 
@@ -1016,7 +1019,8 @@ int crash_shrink_memory(unsigned long new_size)
 	unsigned long old_size;
 	struct resource *ram_res;
 
-	mutex_lock(&kexec_mutex);
+	if (!kexec_trylock())
+		return -EBUSY;
 
 	if (kexec_crash_image) {
 		ret = -ENOENT;
@@ -1054,7 +1058,7 @@ int crash_shrink_memory(unsigned long new_size)
 	insert_resource(&iomem_resource, ram_res);
 
 unlock:
-	mutex_unlock(&kexec_mutex);
+	kexec_unlock();
 	return ret;
 }
 
@@ -1126,7 +1130,7 @@ int kernel_kexec(void)
 {
 	int error = 0;
 
-	if (!mutex_trylock(&kexec_mutex))
+	if (!kexec_trylock())
 		return -EBUSY;
 	if (!kexec_image) {
 		error = -EINVAL;
@@ -1201,7 +1205,7 @@ int kernel_kexec(void)
 #endif
 
  Unlock:
-	mutex_unlock(&kexec_mutex);
+	kexec_unlock();
 	return error;
 }
 
diff --git a/kernel/kexec_file.c b/kernel/kexec_file.c
index fff11916aba3..b9c857782ada 100644
--- a/kernel/kexec_file.c
+++ b/kernel/kexec_file.c
@@ -343,7 +343,7 @@ SYSCALL_DEFINE5(kexec_file_load, int, kernel_fd, int, initrd_fd,
 
 	image = NULL;
 
-	if (!mutex_trylock(&kexec_mutex))
+	if (!kexec_trylock())
 		return -EBUSY;
 
 	dest_image = &kexec_image;
@@ -415,7 +415,7 @@ SYSCALL_DEFINE5(kexec_file_load, int, kernel_fd, int, initrd_fd,
 	if ((flags & KEXEC_FILE_ON_CRASH) && kexec_crash_image)
 		arch_kexec_protect_crashkres();
 
-	mutex_unlock(&kexec_mutex);
+	kexec_unlock();
 	kimage_free(image);
 	return ret;
 }
diff --git a/kernel/kexec_internal.h b/kernel/kexec_internal.h
index 39d30ccf8d87..49d4e3ab9c96 100644
--- a/kernel/kexec_internal.h
+++ b/kernel/kexec_internal.h
@@ -15,7 +15,20 @@ int kimage_is_destination_range(struct kimage *image,
 
 int machine_kexec_post_load(struct kimage *image);
 
-extern struct mutex kexec_mutex;
+/*
+ * Whatever is used to serialize accesses to the kexec_crash_image needs to be
+ * NMI safe, as __crash_kexec() can happen during nmi_panic(), so here we use a
+ * "simple" atomic variable that is acquired with a cmpxchg().
+ */
+extern atomic_t __kexec_lock;
+static inline bool kexec_trylock(void)
+{
+	return atomic_cmpxchg_acquire(&__kexec_lock, 0, 1) == 0;
+}
+static inline void kexec_unlock(void)
+{
+	atomic_set_release(&__kexec_lock, 0);
+}
 
 #ifdef CONFIG_KEXEC_FILE
 #include <linux/purgatory.h>
diff --git a/kernel/ksysfs.c b/kernel/ksysfs.c
index 35859da8bd4f..e20c19e3ba49 100644
--- a/kernel/ksysfs.c
+++ b/kernel/ksysfs.c
@@ -106,7 +106,12 @@ KERNEL_ATTR_RO(kexec_crash_loaded);
 static ssize_t kexec_crash_size_show(struct kobject *kobj,
 				       struct kobj_attribute *attr, char *buf)
 {
-	return sprintf(buf, "%zu\n", crash_get_memory_size());
+	ssize_t size = crash_get_memory_size();
+
+	if (size < 0)
+		return size;
+
+	return sprintf(buf, "%zd\n", size);
 }
 static ssize_t kexec_crash_size_store(struct kobject *kobj,
 				   struct kobj_attribute *attr,
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index bb70a7856277..57a58bc48021 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -9342,8 +9342,6 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
 		local->avg_load = (local->group_load * SCHED_CAPACITY_SCALE) /
 				  local->group_capacity;
 
-		sds->avg_load = (sds->total_load * SCHED_CAPACITY_SCALE) /
-				sds->total_capacity;
 		/*
 		 * If the local group is more loaded than the selected
 		 * busiest group don't try to pull any tasks.
@@ -9352,6 +9350,19 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
 			env->imbalance = 0;
 			return;
 		}
+
+		sds->avg_load = (sds->total_load * SCHED_CAPACITY_SCALE) /
+				sds->total_capacity;
+
+		/*
+		 * If the local group is more loaded than the average system
+		 * load, don't try to pull any tasks.
+		 */
+		if (local->avg_load >= sds->avg_load) {
+			env->imbalance = 0;
+			return;
+		}
+
 	}
 
 	/*
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index d8b7b2846313..d981abea0358 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1061,6 +1061,65 @@ int proc_douintvec_minmax(struct ctl_table *table, int write,
 				 do_proc_douintvec_minmax_conv, &param);
 }
 
+/**
+ * proc_dou8vec_minmax - read a vector of unsigned chars with min/max values
+ * @table: the sysctl table
+ * @write: %TRUE if this is a write to the sysctl file
+ * @buffer: the user buffer
+ * @lenp: the size of the user buffer
+ * @ppos: file position
+ *
+ * Reads/writes up to table->maxlen/sizeof(u8) unsigned chars
+ * values from/to the user buffer, treated as an ASCII string. Negative
+ * strings are not allowed.
+ *
+ * This routine will ensure the values are within the range specified by
+ * table->extra1 (min) and table->extra2 (max).
+ *
+ * Returns 0 on success or an error on write when the range check fails.
+ */
+int proc_dou8vec_minmax(struct ctl_table *table, int write,
+			void *buffer, size_t *lenp, loff_t *ppos)
+{
+	struct ctl_table tmp;
+	unsigned int min = 0, max = 255U, val;
+	u8 *data = table->data;
+	struct do_proc_douintvec_minmax_conv_param param = {
+		.min = &min,
+		.max = &max,
+	};
+	int res;
+
+	/* Do not support arrays yet. */
+	if (table->maxlen != sizeof(u8))
+		return -EINVAL;
+
+	if (table->extra1) {
+		min = *(unsigned int *) table->extra1;
+		if (min > 255U)
+			return -EINVAL;
+	}
+	if (table->extra2) {
+		max = *(unsigned int *) table->extra2;
+		if (max > 255U)
+			return -EINVAL;
+	}
+
+	tmp = *table;
+
+	tmp.maxlen = sizeof(val);
+	tmp.data = &val;
+	val = READ_ONCE(*data);
+	res = do_proc_douintvec(&tmp, write, buffer, lenp, ppos,
+				do_proc_douintvec_minmax_conv, &param);
+	if (res)
+		return res;
+	if (write)
+		WRITE_ONCE(*data, val);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(proc_dou8vec_minmax);
+
 static int do_proc_dopipe_max_size_conv(unsigned long *lvalp,
 					unsigned int *valp,
 					int write, void *data)
@@ -1612,6 +1671,12 @@ int proc_douintvec_minmax(struct ctl_table *table, int write,
 	return -ENOSYS;
 }
 
+int proc_dou8vec_minmax(struct ctl_table *table, int write,
+			void *buffer, size_t *lenp, loff_t *ppos)
+{
+	return -ENOSYS;
+}
+
 int proc_dointvec_jiffies(struct ctl_table *table, int write,
 		    void *buffer, size_t *lenp, loff_t *ppos)
 {
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 67829b6e07bd..3dab978c156d 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -5390,12 +5390,15 @@ int modify_ftrace_direct(unsigned long ip,
 		ret = 0;
 	}
 
-	if (unlikely(ret && new_direct)) {
-		direct->count++;
-		list_del_rcu(&new_direct->next);
-		synchronize_rcu_tasks();
-		kfree(new_direct);
-		ftrace_direct_func_count--;
+	if (ret) {
+		direct->addr = old_addr;
+		if (unlikely(new_direct)) {
+			direct->count++;
+			list_del_rcu(&new_direct->next);
+			synchronize_rcu_tasks();
+			kfree(new_direct);
+			ftrace_direct_func_count--;
+		}
 	}
 
  out_unlock:
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 70da6f3212bc..21b07c7c6ee5 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2962,6 +2962,10 @@ rb_set_commit_to_write(struct ring_buffer_per_cpu *cpu_buffer)
 		if (RB_WARN_ON(cpu_buffer,
 			       rb_is_reader_page(cpu_buffer->tail_page)))
 			return;
+		/*
+		 * No need for a memory barrier here, as the update
+		 * of the tail_page did it for this page.
+		 */
 		local_set(&cpu_buffer->commit_page->page->commit,
 			  rb_page_write(cpu_buffer->commit_page));
 		rb_inc_page(cpu_buffer, &cpu_buffer->commit_page);
@@ -2971,6 +2975,8 @@ rb_set_commit_to_write(struct ring_buffer_per_cpu *cpu_buffer)
 	while (rb_commit_index(cpu_buffer) !=
 	       rb_page_write(cpu_buffer->commit_page)) {
 
+		/* Make sure the readers see the content of what is committed. */
+		smp_wmb();
 		local_set(&cpu_buffer->commit_page->page->commit,
 			  rb_page_write(cpu_buffer->commit_page));
 		RB_WARN_ON(cpu_buffer,
@@ -4390,7 +4396,12 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
 
 	/*
 	 * Make sure we see any padding after the write update
-	 * (see rb_reset_tail())
+	 * (see rb_reset_tail()).
+	 *
+	 * In addition, a writer may be writing on the reader page
+	 * if the page has not been fully filled, so the read barrier
+	 * is also needed to make sure we see the content of what is
+	 * committed by the writer (see rb_set_commit_to_write()).
 	 */
 	smp_rmb();
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index ce45bdd9077d..482ec6606b7b 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -8895,6 +8895,7 @@ static int __remove_instance(struct trace_array *tr)
 	ftrace_destroy_function_files(tr);
 	tracefs_remove(tr->dir);
 	free_trace_buffers(tr);
+	clear_tracing_err_log(tr);
 
 	for (i = 0; i < tr->nr_topts; i++) {
 		kfree(tr->topts[i].topts);
diff --git a/mm/swapfile.c b/mm/swapfile.c
index d87d6971afc9..86ade667a7af 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -666,6 +666,7 @@ static void __del_from_avail_list(struct swap_info_struct *p)
 {
 	int nid;
 
+	assert_spin_locked(&p->lock);
 	for_each_node(nid)
 		plist_del(&p->avail_lists[nid], &swap_avail_heads[nid]);
 }
@@ -2611,8 +2612,8 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 		spin_unlock(&swap_lock);
 		goto out_dput;
 	}
-	del_from_avail_list(p);
 	spin_lock(&p->lock);
+	del_from_avail_list(p);
 	if (p->prio < 0) {
 		struct swap_info_struct *si = p;
 		int nid;
diff --git a/net/9p/trans_xen.c b/net/9p/trans_xen.c
index 220e8f4ac0cf..da056170849b 100644
--- a/net/9p/trans_xen.c
+++ b/net/9p/trans_xen.c
@@ -300,6 +300,10 @@ static void xen_9pfs_front_free(struct xen_9pfs_front_priv *priv)
 	write_unlock(&xen_9pfs_lock);
 
 	for (i = 0; i < priv->num_rings; i++) {
+		struct xen_9pfs_dataring *ring = &priv->rings[i];
+
+		cancel_work_sync(&ring->work);
+
 		if (!priv->rings[i].intf)
 			break;
 		if (priv->rings[i].irq > 0)
diff --git a/net/bluetooth/hidp/core.c b/net/bluetooth/hidp/core.c
index 0db48c812662..b946a6379433 100644
--- a/net/bluetooth/hidp/core.c
+++ b/net/bluetooth/hidp/core.c
@@ -433,7 +433,7 @@ static void hidp_set_timer(struct hidp_session *session)
 static void hidp_del_timer(struct hidp_session *session)
 {
 	if (session->idle_to > 0)
-		del_timer(&session->timer);
+		del_timer_sync(&session->timer);
 }
 
 static void hidp_process_report(struct hidp_session *session, int type,
diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 367b1dec2e75..f9d2ce9cee36 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -4647,33 +4647,27 @@ static inline int l2cap_disconnect_req(struct l2cap_conn *conn,
 
 	BT_DBG("scid 0x%4.4x dcid 0x%4.4x", scid, dcid);
 
-	mutex_lock(&conn->chan_lock);
-
-	chan = __l2cap_get_chan_by_scid(conn, dcid);
+	chan = l2cap_get_chan_by_scid(conn, dcid);
 	if (!chan) {
-		mutex_unlock(&conn->chan_lock);
 		cmd_reject_invalid_cid(conn, cmd->ident, dcid, scid);
 		return 0;
 	}
 
-	l2cap_chan_hold(chan);
-	l2cap_chan_lock(chan);
-
 	rsp.dcid = cpu_to_le16(chan->scid);
 	rsp.scid = cpu_to_le16(chan->dcid);
 	l2cap_send_cmd(conn, cmd->ident, L2CAP_DISCONN_RSP, sizeof(rsp), &rsp);
 
 	chan->ops->set_shutdown(chan);
 
+	mutex_lock(&conn->chan_lock);
 	l2cap_chan_del(chan, ECONNRESET);
+	mutex_unlock(&conn->chan_lock);
 
 	chan->ops->close(chan);
 
 	l2cap_chan_unlock(chan);
 	l2cap_chan_put(chan);
 
-	mutex_unlock(&conn->chan_lock);
-
 	return 0;
 }
 
@@ -4693,33 +4687,27 @@ static inline int l2cap_disconnect_rsp(struct l2cap_conn *conn,
 
 	BT_DBG("dcid 0x%4.4x scid 0x%4.4x", dcid, scid);
 
-	mutex_lock(&conn->chan_lock);
-
-	chan = __l2cap_get_chan_by_scid(conn, scid);
+	chan = l2cap_get_chan_by_scid(conn, scid);
 	if (!chan) {
 		mutex_unlock(&conn->chan_lock);
 		return 0;
 	}
 
-	l2cap_chan_hold(chan);
-	l2cap_chan_lock(chan);
-
 	if (chan->state != BT_DISCONN) {
 		l2cap_chan_unlock(chan);
 		l2cap_chan_put(chan);
-		mutex_unlock(&conn->chan_lock);
 		return 0;
 	}
 
+	mutex_lock(&conn->chan_lock);
 	l2cap_chan_del(chan, 0);
+	mutex_unlock(&conn->chan_lock);
 
 	chan->ops->close(chan);
 
 	l2cap_chan_unlock(chan);
 	l2cap_chan_put(chan);
 
-	mutex_unlock(&conn->chan_lock);
-
 	return 0;
 }
 
diff --git a/net/can/isotp.c b/net/can/isotp.c
index f2f0bc7f0cb4..4360f33278c1 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -1480,6 +1480,21 @@ static int isotp_init(struct sock *sk)
 	return 0;
 }
 
+static __poll_t isotp_poll(struct file *file, struct socket *sock, poll_table *wait)
+{
+	struct sock *sk = sock->sk;
+	struct isotp_sock *so = isotp_sk(sk);
+
+	__poll_t mask = datagram_poll(file, sock, wait);
+	poll_wait(file, &so->wait, wait);
+
+	/* Check for false positives due to TX state */
+	if ((mask & EPOLLWRNORM) && (so->tx.state != ISOTP_IDLE))
+		mask &= ~(EPOLLOUT | EPOLLWRNORM);
+
+	return mask;
+}
+
 static int isotp_sock_no_ioctlcmd(struct socket *sock, unsigned int cmd,
 				  unsigned long arg)
 {
@@ -1495,7 +1510,7 @@ static const struct proto_ops isotp_ops = {
 	.socketpair = sock_no_socketpair,
 	.accept = sock_no_accept,
 	.getname = isotp_getname,
-	.poll = datagram_poll,
+	.poll = isotp_poll,
 	.ioctl = isotp_sock_no_ioctlcmd,
 	.gettstamp = sock_gettstamp,
 	.listen = sock_no_listen,
diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index 57d6aac7f435..5dcbb0b7d123 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -600,7 +600,10 @@ sk_buff *j1939_tp_tx_dat_new(struct j1939_priv *priv,
 	/* reserve CAN header */
 	skb_reserve(skb, offsetof(struct can_frame, data));
 
-	memcpy(skb->cb, re_skcb, sizeof(skb->cb));
+	/* skb->cb must be large enough to hold a j1939_sk_buff_cb structure */
+	BUILD_BUG_ON(sizeof(skb->cb) < sizeof(*re_skcb));
+
+	memcpy(skb->cb, re_skcb, sizeof(*re_skcb));
 	skcb = j1939_skb_to_cb(skb);
 	if (swap_src_dst)
 		j1939_skbcb_swap(skcb);
diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index 960948290001..2ad22511b9c6 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -137,6 +137,20 @@ static void queue_process(struct work_struct *work)
 	}
 }
 
+static int netif_local_xmit_active(struct net_device *dev)
+{
+	int i;
+
+	for (i = 0; i < dev->num_tx_queues; i++) {
+		struct netdev_queue *txq = netdev_get_tx_queue(dev, i);
+
+		if (READ_ONCE(txq->xmit_lock_owner) == smp_processor_id())
+			return 1;
+	}
+
+	return 0;
+}
+
 static void poll_one_napi(struct napi_struct *napi)
 {
 	int work;
@@ -183,7 +197,10 @@ void netpoll_poll_dev(struct net_device *dev)
 	if (!ni || down_trylock(&ni->dev_lock))
 		return;
 
-	if (!netif_running(dev)) {
+	/* Some drivers will take the same locks in poll and xmit,
+	 * we can't poll if local CPU is already in xmit.
+	 */
+	if (!netif_running(dev) || netif_local_xmit_active(dev)) {
 		up(&ni->dev_lock);
 		return;
 	}
diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index a1aacf5e75a6..0bbc047e8f6e 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -755,6 +755,11 @@ void __icmp_send(struct sk_buff *skb_in, int type, int code, __be32 info,
 		room = 576;
 	room -= sizeof(struct iphdr) + icmp_param.replyopts.opt.opt.optlen;
 	room -= sizeof(struct icmphdr);
+	/* Guard against tiny mtu. We need to include at least one
+	 * IP network header for this message to make any sense.
+	 */
+	if (room <= (int)sizeof(struct iphdr))
+		goto ende;
 
 	icmp_param.data_len = skb_in->len - icmp_param.offset;
 	if (icmp_param.data_len > room)
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 439970e02ac6..3a34e9768bff 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -37,6 +37,7 @@ static int ip_local_port_range_min[] = { 1, 1 };
 static int ip_local_port_range_max[] = { 65535, 65535 };
 static int tcp_adv_win_scale_min = -31;
 static int tcp_adv_win_scale_max = 31;
+static int tcp_app_win_max = 31;
 static int tcp_min_snd_mss_min = TCP_MIN_SND_MSS;
 static int tcp_min_snd_mss_max = 65535;
 static int ip_privileged_port_min;
@@ -540,30 +541,30 @@ static struct ctl_table ipv4_net_table[] = {
 	{
 		.procname	= "icmp_echo_ignore_all",
 		.data		= &init_net.ipv4.sysctl_icmp_echo_ignore_all,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "icmp_echo_ignore_broadcasts",
 		.data		= &init_net.ipv4.sysctl_icmp_echo_ignore_broadcasts,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "icmp_ignore_bogus_error_responses",
 		.data		= &init_net.ipv4.sysctl_icmp_ignore_bogus_error_responses,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "icmp_errors_use_inbound_ifaddr",
 		.data		= &init_net.ipv4.sysctl_icmp_errors_use_inbound_ifaddr,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "icmp_ratelimit",
@@ -590,9 +591,9 @@ static struct ctl_table ipv4_net_table[] = {
 	{
 		.procname	= "raw_l3mdev_accept",
 		.data		= &init_net.ipv4.sysctl_raw_l3mdev_accept,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= proc_dou8vec_minmax,
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= SYSCTL_ONE,
 	},
@@ -600,30 +601,30 @@ static struct ctl_table ipv4_net_table[] = {
 	{
 		.procname	= "tcp_ecn",
 		.data		= &init_net.ipv4.sysctl_tcp_ecn,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "tcp_ecn_fallback",
 		.data		= &init_net.ipv4.sysctl_tcp_ecn_fallback,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "ip_dynaddr",
 		.data		= &init_net.ipv4.sysctl_ip_dynaddr,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "ip_early_demux",
 		.data		= &init_net.ipv4.sysctl_ip_early_demux,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname       = "udp_early_demux",
@@ -642,18 +643,18 @@ static struct ctl_table ipv4_net_table[] = {
 	{
 		.procname       = "nexthop_compat_mode",
 		.data           = &init_net.ipv4.sysctl_nexthop_compat_mode,
-		.maxlen         = sizeof(int),
+		.maxlen         = sizeof(u8),
 		.mode           = 0644,
-		.proc_handler   = proc_dointvec_minmax,
+		.proc_handler   = proc_dou8vec_minmax,
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= SYSCTL_ONE,
 	},
 	{
 		.procname	= "ip_default_ttl",
 		.data		= &init_net.ipv4.sysctl_ip_default_ttl,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= proc_dou8vec_minmax,
 		.extra1		= &ip_ttl_min,
 		.extra2		= &ip_ttl_max,
 	},
@@ -674,16 +675,16 @@ static struct ctl_table ipv4_net_table[] = {
 	{
 		.procname	= "ip_no_pmtu_disc",
 		.data		= &init_net.ipv4.sysctl_ip_no_pmtu_disc,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "ip_forward_use_pmtu",
 		.data		= &init_net.ipv4.sysctl_ip_fwd_use_pmtu,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "ip_forward_update_priority",
@@ -697,40 +698,40 @@ static struct ctl_table ipv4_net_table[] = {
 	{
 		.procname	= "ip_nonlocal_bind",
 		.data		= &init_net.ipv4.sysctl_ip_nonlocal_bind,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "ip_autobind_reuse",
 		.data		= &init_net.ipv4.sysctl_ip_autobind_reuse,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= proc_dou8vec_minmax,
 		.extra1         = SYSCTL_ZERO,
 		.extra2         = SYSCTL_ONE,
 	},
 	{
 		.procname	= "fwmark_reflect",
 		.data		= &init_net.ipv4.sysctl_fwmark_reflect,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "tcp_fwmark_accept",
 		.data		= &init_net.ipv4.sysctl_tcp_fwmark_accept,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 #ifdef CONFIG_NET_L3_MASTER_DEV
 	{
 		.procname	= "tcp_l3mdev_accept",
 		.data		= &init_net.ipv4.sysctl_tcp_l3mdev_accept,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= proc_dou8vec_minmax,
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= SYSCTL_ONE,
 	},
@@ -738,9 +739,9 @@ static struct ctl_table ipv4_net_table[] = {
 	{
 		.procname	= "tcp_mtu_probing",
 		.data		= &init_net.ipv4.sysctl_tcp_mtu_probing,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "tcp_base_mss",
@@ -842,9 +843,9 @@ static struct ctl_table ipv4_net_table[] = {
 	{
 		.procname	= "tcp_keepalive_probes",
 		.data		= &init_net.ipv4.sysctl_tcp_keepalive_probes,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "tcp_keepalive_intvl",
@@ -856,26 +857,26 @@ static struct ctl_table ipv4_net_table[] = {
 	{
 		.procname	= "tcp_syn_retries",
 		.data		= &init_net.ipv4.sysctl_tcp_syn_retries,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= proc_dou8vec_minmax,
 		.extra1		= &tcp_syn_retries_min,
 		.extra2		= &tcp_syn_retries_max
 	},
 	{
 		.procname	= "tcp_synack_retries",
 		.data		= &init_net.ipv4.sysctl_tcp_synack_retries,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 #ifdef CONFIG_SYN_COOKIES
 	{
 		.procname	= "tcp_syncookies",
 		.data		= &init_net.ipv4.sysctl_tcp_syncookies,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 #endif
 	{
@@ -888,24 +889,24 @@ static struct ctl_table ipv4_net_table[] = {
 	{
 		.procname	= "tcp_retries1",
 		.data		= &init_net.ipv4.sysctl_tcp_retries1,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= proc_dou8vec_minmax,
 		.extra2		= &tcp_retr1_max
 	},
 	{
 		.procname	= "tcp_retries2",
 		.data		= &init_net.ipv4.sysctl_tcp_retries2,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "tcp_orphan_retries",
 		.data		= &init_net.ipv4.sysctl_tcp_orphan_retries,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "tcp_fin_timeout",
@@ -924,9 +925,9 @@ static struct ctl_table ipv4_net_table[] = {
 	{
 		.procname	= "tcp_tw_reuse",
 		.data		= &init_net.ipv4.sysctl_tcp_tw_reuse,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= proc_dou8vec_minmax,
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= &two,
 	},
@@ -1012,88 +1013,88 @@ static struct ctl_table ipv4_net_table[] = {
 	{
 		.procname	= "tcp_sack",
 		.data		= &init_net.ipv4.sysctl_tcp_sack,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "tcp_window_scaling",
 		.data		= &init_net.ipv4.sysctl_tcp_window_scaling,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "tcp_timestamps",
 		.data		= &init_net.ipv4.sysctl_tcp_timestamps,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "tcp_early_retrans",
 		.data		= &init_net.ipv4.sysctl_tcp_early_retrans,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= proc_dou8vec_minmax,
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= &four,
 	},
 	{
 		.procname	= "tcp_recovery",
 		.data		= &init_net.ipv4.sysctl_tcp_recovery,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname       = "tcp_thin_linear_timeouts",
 		.data           = &init_net.ipv4.sysctl_tcp_thin_linear_timeouts,
-		.maxlen         = sizeof(int),
+		.maxlen         = sizeof(u8),
 		.mode           = 0644,
-		.proc_handler   = proc_dointvec
+		.proc_handler   = proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "tcp_slow_start_after_idle",
 		.data		= &init_net.ipv4.sysctl_tcp_slow_start_after_idle,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "tcp_retrans_collapse",
 		.data		= &init_net.ipv4.sysctl_tcp_retrans_collapse,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "tcp_stdurg",
 		.data		= &init_net.ipv4.sysctl_tcp_stdurg,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "tcp_rfc1337",
 		.data		= &init_net.ipv4.sysctl_tcp_rfc1337,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "tcp_abort_on_overflow",
 		.data		= &init_net.ipv4.sysctl_tcp_abort_on_overflow,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "tcp_fack",
 		.data		= &init_net.ipv4.sysctl_tcp_fack,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "tcp_max_reordering",
@@ -1105,16 +1106,18 @@ static struct ctl_table ipv4_net_table[] = {
 	{
 		.procname	= "tcp_dsack",
 		.data		= &init_net.ipv4.sysctl_tcp_dsack,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "tcp_app_win",
 		.data		= &init_net.ipv4.sysctl_tcp_app_win,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dou8vec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= &tcp_app_win_max,
 	},
 	{
 		.procname	= "tcp_adv_win_scale",
@@ -1128,46 +1131,46 @@ static struct ctl_table ipv4_net_table[] = {
 	{
 		.procname	= "tcp_frto",
 		.data		= &init_net.ipv4.sysctl_tcp_frto,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "tcp_no_metrics_save",
 		.data		= &init_net.ipv4.sysctl_tcp_nometrics_save,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "tcp_no_ssthresh_metrics_save",
 		.data		= &init_net.ipv4.sysctl_tcp_no_ssthresh_metrics_save,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= proc_dou8vec_minmax,
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= SYSCTL_ONE,
 	},
 	{
 		.procname	= "tcp_moderate_rcvbuf",
 		.data		= &init_net.ipv4.sysctl_tcp_moderate_rcvbuf,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "tcp_tso_win_divisor",
 		.data		= &init_net.ipv4.sysctl_tcp_tso_win_divisor,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "tcp_workaround_signed_windows",
 		.data		= &init_net.ipv4.sysctl_tcp_workaround_signed_windows,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "tcp_limit_output_bytes",
@@ -1186,9 +1189,9 @@ static struct ctl_table ipv4_net_table[] = {
 	{
 		.procname	= "tcp_min_tso_segs",
 		.data		= &init_net.ipv4.sysctl_tcp_min_tso_segs,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= proc_dou8vec_minmax,
 		.extra1		= SYSCTL_ONE,
 		.extra2		= &gso_max_segs,
 	},
@@ -1204,9 +1207,9 @@ static struct ctl_table ipv4_net_table[] = {
 	{
 		.procname	= "tcp_autocorking",
 		.data		= &init_net.ipv4.sysctl_tcp_autocorking,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= proc_dou8vec_minmax,
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= SYSCTL_ONE,
 	},
@@ -1277,9 +1280,9 @@ static struct ctl_table ipv4_net_table[] = {
 	{
 		.procname       = "tcp_reflect_tos",
 		.data           = &init_net.ipv4.sysctl_tcp_reflect_tos,
-		.maxlen         = sizeof(int),
+		.maxlen         = sizeof(u8),
 		.mode           = 0644,
-		.proc_handler   = proc_dointvec_minmax,
+		.proc_handler   = proc_dou8vec_minmax,
 		.extra1         = SYSCTL_ZERO,
 		.extra2         = SYSCTL_ONE,
 	},
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index e427f5040a08..c62e44224bf8 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1925,8 +1925,13 @@ struct sk_buff *__ip6_make_skb(struct sock *sk,
 	IP6_UPD_PO_STATS(net, rt->rt6i_idev, IPSTATS_MIB_OUT, skb->len);
 	if (proto == IPPROTO_ICMPV6) {
 		struct inet6_dev *idev = ip6_dst_idev(skb_dst(skb));
+		u8 icmp6_type;
 
-		ICMP6MSGOUT_INC_STATS(net, idev, icmp6_hdr(skb)->icmp6_type);
+		if (sk->sk_socket->type == SOCK_RAW && !inet_sk(sk)->hdrincl)
+			icmp6_type = fl6->fl6_icmp_type;
+		else
+			icmp6_type = icmp6_hdr(skb)->icmp6_type;
+		ICMP6MSGOUT_INC_STATS(net, idev, icmp6_type);
 		ICMP6_INC_STATS(net, idev, ICMP6_MIB_OUTMSGS);
 	}
 
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 1805cc5f7418..20cc08210c70 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1340,9 +1340,11 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 			msg->msg_name = &sin;
 			msg->msg_namelen = sizeof(sin);
 do_udp_sendmsg:
-			if (__ipv6_only_sock(sk))
-				return -ENETUNREACH;
-			return udp_sendmsg(sk, msg, len);
+			err = __ipv6_only_sock(sk) ?
+				-ENETUNREACH : udp_sendmsg(sk, msg, len);
+			msg->msg_name = sin6;
+			msg->msg_namelen = addr_len;
+			return err;
 		}
 	}
 
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index d572478c4d68..2e84360990f0 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1040,7 +1040,8 @@ static int __must_check __sta_info_destroy_part1(struct sta_info *sta)
 	list_del_rcu(&sta->list);
 	sta->removed = true;
 
-	drv_sta_pre_rcu_remove(local, sta->sdata, sta);
+	if (sta->uploaded)
+		drv_sta_pre_rcu_remove(local, sta->sdata, sta);
 
 	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN &&
 	    rcu_access_pointer(sdata->u.vlan.sta) == sta)
diff --git a/net/qrtr/Makefile b/net/qrtr/Makefile
index 1b1411d158a7..8e0605f88a73 100644
--- a/net/qrtr/Makefile
+++ b/net/qrtr/Makefile
@@ -1,5 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
-obj-$(CONFIG_QRTR) := qrtr.o ns.o
+obj-$(CONFIG_QRTR) += qrtr.o
+qrtr-y	:= af_qrtr.o ns.o
 
 obj-$(CONFIG_QRTR_SMD) += qrtr-smd.o
 qrtr-smd-y	:= smd.o
diff --git a/net/qrtr/af_qrtr.c b/net/qrtr/af_qrtr.c
new file mode 100644
index 000000000000..71c2295d4a57
--- /dev/null
+++ b/net/qrtr/af_qrtr.c
@@ -0,0 +1,1303 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2015, Sony Mobile Communications Inc.
+ * Copyright (c) 2013, The Linux Foundation. All rights reserved.
+ */
+#include <linux/module.h>
+#include <linux/netlink.h>
+#include <linux/qrtr.h>
+#include <linux/termios.h>	/* For TIOCINQ/OUTQ */
+#include <linux/spinlock.h>
+#include <linux/wait.h>
+
+#include <net/sock.h>
+
+#include "qrtr.h"
+
+#define QRTR_PROTO_VER_1 1
+#define QRTR_PROTO_VER_2 3
+
+/* auto-bind range */
+#define QRTR_MIN_EPH_SOCKET 0x4000
+#define QRTR_MAX_EPH_SOCKET 0x7fff
+#define QRTR_EPH_PORT_RANGE \
+		XA_LIMIT(QRTR_MIN_EPH_SOCKET, QRTR_MAX_EPH_SOCKET)
+
+/**
+ * struct qrtr_hdr_v1 - (I|R)PCrouter packet header version 1
+ * @version: protocol version
+ * @type: packet type; one of QRTR_TYPE_*
+ * @src_node_id: source node
+ * @src_port_id: source port
+ * @confirm_rx: boolean; whether a resume-tx packet should be send in reply
+ * @size: length of packet, excluding this header
+ * @dst_node_id: destination node
+ * @dst_port_id: destination port
+ */
+struct qrtr_hdr_v1 {
+	__le32 version;
+	__le32 type;
+	__le32 src_node_id;
+	__le32 src_port_id;
+	__le32 confirm_rx;
+	__le32 size;
+	__le32 dst_node_id;
+	__le32 dst_port_id;
+} __packed;
+
+/**
+ * struct qrtr_hdr_v2 - (I|R)PCrouter packet header later versions
+ * @version: protocol version
+ * @type: packet type; one of QRTR_TYPE_*
+ * @flags: bitmask of QRTR_FLAGS_*
+ * @optlen: length of optional header data
+ * @size: length of packet, excluding this header and optlen
+ * @src_node_id: source node
+ * @src_port_id: source port
+ * @dst_node_id: destination node
+ * @dst_port_id: destination port
+ */
+struct qrtr_hdr_v2 {
+	u8 version;
+	u8 type;
+	u8 flags;
+	u8 optlen;
+	__le32 size;
+	__le16 src_node_id;
+	__le16 src_port_id;
+	__le16 dst_node_id;
+	__le16 dst_port_id;
+};
+
+#define QRTR_FLAGS_CONFIRM_RX	BIT(0)
+
+struct qrtr_cb {
+	u32 src_node;
+	u32 src_port;
+	u32 dst_node;
+	u32 dst_port;
+
+	u8 type;
+	u8 confirm_rx;
+};
+
+#define QRTR_HDR_MAX_SIZE max_t(size_t, sizeof(struct qrtr_hdr_v1), \
+					sizeof(struct qrtr_hdr_v2))
+
+struct qrtr_sock {
+	/* WARNING: sk must be the first member */
+	struct sock sk;
+	struct sockaddr_qrtr us;
+	struct sockaddr_qrtr peer;
+};
+
+static inline struct qrtr_sock *qrtr_sk(struct sock *sk)
+{
+	BUILD_BUG_ON(offsetof(struct qrtr_sock, sk) != 0);
+	return container_of(sk, struct qrtr_sock, sk);
+}
+
+static unsigned int qrtr_local_nid = 1;
+
+/* for node ids */
+static RADIX_TREE(qrtr_nodes, GFP_ATOMIC);
+static DEFINE_SPINLOCK(qrtr_nodes_lock);
+/* broadcast list */
+static LIST_HEAD(qrtr_all_nodes);
+/* lock for qrtr_all_nodes and node reference */
+static DEFINE_MUTEX(qrtr_node_lock);
+
+/* local port allocation management */
+static DEFINE_XARRAY_ALLOC(qrtr_ports);
+
+/**
+ * struct qrtr_node - endpoint node
+ * @ep_lock: lock for endpoint management and callbacks
+ * @ep: endpoint
+ * @ref: reference count for node
+ * @nid: node id
+ * @qrtr_tx_flow: tree of qrtr_tx_flow, keyed by node << 32 | port
+ * @qrtr_tx_lock: lock for qrtr_tx_flow inserts
+ * @rx_queue: receive queue
+ * @item: list item for broadcast list
+ */
+struct qrtr_node {
+	struct mutex ep_lock;
+	struct qrtr_endpoint *ep;
+	struct kref ref;
+	unsigned int nid;
+
+	struct radix_tree_root qrtr_tx_flow;
+	struct mutex qrtr_tx_lock; /* for qrtr_tx_flow */
+
+	struct sk_buff_head rx_queue;
+	struct list_head item;
+};
+
+/**
+ * struct qrtr_tx_flow - tx flow control
+ * @resume_tx: waiters for a resume tx from the remote
+ * @pending: number of waiting senders
+ * @tx_failed: indicates that a message with confirm_rx flag was lost
+ */
+struct qrtr_tx_flow {
+	struct wait_queue_head resume_tx;
+	int pending;
+	int tx_failed;
+};
+
+#define QRTR_TX_FLOW_HIGH	10
+#define QRTR_TX_FLOW_LOW	5
+
+static int qrtr_local_enqueue(struct qrtr_node *node, struct sk_buff *skb,
+			      int type, struct sockaddr_qrtr *from,
+			      struct sockaddr_qrtr *to);
+static int qrtr_bcast_enqueue(struct qrtr_node *node, struct sk_buff *skb,
+			      int type, struct sockaddr_qrtr *from,
+			      struct sockaddr_qrtr *to);
+static struct qrtr_sock *qrtr_port_lookup(int port);
+static void qrtr_port_put(struct qrtr_sock *ipc);
+
+/* Release node resources and free the node.
+ *
+ * Do not call directly, use qrtr_node_release.  To be used with
+ * kref_put_mutex.  As such, the node mutex is expected to be locked on call.
+ */
+static void __qrtr_node_release(struct kref *kref)
+{
+	struct qrtr_node *node = container_of(kref, struct qrtr_node, ref);
+	struct radix_tree_iter iter;
+	struct qrtr_tx_flow *flow;
+	unsigned long flags;
+	void __rcu **slot;
+
+	spin_lock_irqsave(&qrtr_nodes_lock, flags);
+	if (node->nid != QRTR_EP_NID_AUTO)
+		radix_tree_delete(&qrtr_nodes, node->nid);
+	spin_unlock_irqrestore(&qrtr_nodes_lock, flags);
+
+	list_del(&node->item);
+	mutex_unlock(&qrtr_node_lock);
+
+	skb_queue_purge(&node->rx_queue);
+
+	/* Free tx flow counters */
+	radix_tree_for_each_slot(slot, &node->qrtr_tx_flow, &iter, 0) {
+		flow = *slot;
+		radix_tree_iter_delete(&node->qrtr_tx_flow, &iter, slot);
+		kfree(flow);
+	}
+	kfree(node);
+}
+
+/* Increment reference to node. */
+static struct qrtr_node *qrtr_node_acquire(struct qrtr_node *node)
+{
+	if (node)
+		kref_get(&node->ref);
+	return node;
+}
+
+/* Decrement reference to node and release as necessary. */
+static void qrtr_node_release(struct qrtr_node *node)
+{
+	if (!node)
+		return;
+	kref_put_mutex(&node->ref, __qrtr_node_release, &qrtr_node_lock);
+}
+
+/**
+ * qrtr_tx_resume() - reset flow control counter
+ * @node:	qrtr_node that the QRTR_TYPE_RESUME_TX packet arrived on
+ * @skb:	resume_tx packet
+ */
+static void qrtr_tx_resume(struct qrtr_node *node, struct sk_buff *skb)
+{
+	struct qrtr_ctrl_pkt *pkt = (struct qrtr_ctrl_pkt *)skb->data;
+	u64 remote_node = le32_to_cpu(pkt->client.node);
+	u32 remote_port = le32_to_cpu(pkt->client.port);
+	struct qrtr_tx_flow *flow;
+	unsigned long key;
+
+	key = remote_node << 32 | remote_port;
+
+	rcu_read_lock();
+	flow = radix_tree_lookup(&node->qrtr_tx_flow, key);
+	rcu_read_unlock();
+	if (flow) {
+		spin_lock(&flow->resume_tx.lock);
+		flow->pending = 0;
+		spin_unlock(&flow->resume_tx.lock);
+		wake_up_interruptible_all(&flow->resume_tx);
+	}
+
+	consume_skb(skb);
+}
+
+/**
+ * qrtr_tx_wait() - flow control for outgoing packets
+ * @node:	qrtr_node that the packet is to be send to
+ * @dest_node:	node id of the destination
+ * @dest_port:	port number of the destination
+ * @type:	type of message
+ *
+ * The flow control scheme is based around the low and high "watermarks". When
+ * the low watermark is passed the confirm_rx flag is set on the outgoing
+ * message, which will trigger the remote to send a control message of the type
+ * QRTR_TYPE_RESUME_TX to reset the counter. If the high watermark is hit
+ * further transmision should be paused.
+ *
+ * Return: 1 if confirm_rx should be set, 0 otherwise or errno failure
+ */
+static int qrtr_tx_wait(struct qrtr_node *node, int dest_node, int dest_port,
+			int type)
+{
+	unsigned long key = (u64)dest_node << 32 | dest_port;
+	struct qrtr_tx_flow *flow;
+	int confirm_rx = 0;
+	int ret;
+
+	/* Never set confirm_rx on non-data packets */
+	if (type != QRTR_TYPE_DATA)
+		return 0;
+
+	mutex_lock(&node->qrtr_tx_lock);
+	flow = radix_tree_lookup(&node->qrtr_tx_flow, key);
+	if (!flow) {
+		flow = kzalloc(sizeof(*flow), GFP_KERNEL);
+		if (flow) {
+			init_waitqueue_head(&flow->resume_tx);
+			if (radix_tree_insert(&node->qrtr_tx_flow, key, flow)) {
+				kfree(flow);
+				flow = NULL;
+			}
+		}
+	}
+	mutex_unlock(&node->qrtr_tx_lock);
+
+	/* Set confirm_rx if we where unable to find and allocate a flow */
+	if (!flow)
+		return 1;
+
+	spin_lock_irq(&flow->resume_tx.lock);
+	ret = wait_event_interruptible_locked_irq(flow->resume_tx,
+						  flow->pending < QRTR_TX_FLOW_HIGH ||
+						  flow->tx_failed ||
+						  !node->ep);
+	if (ret < 0) {
+		confirm_rx = ret;
+	} else if (!node->ep) {
+		confirm_rx = -EPIPE;
+	} else if (flow->tx_failed) {
+		flow->tx_failed = 0;
+		confirm_rx = 1;
+	} else {
+		flow->pending++;
+		confirm_rx = flow->pending == QRTR_TX_FLOW_LOW;
+	}
+	spin_unlock_irq(&flow->resume_tx.lock);
+
+	return confirm_rx;
+}
+
+/**
+ * qrtr_tx_flow_failed() - flag that tx of confirm_rx flagged messages failed
+ * @node:	qrtr_node that the packet is to be send to
+ * @dest_node:	node id of the destination
+ * @dest_port:	port number of the destination
+ *
+ * Signal that the transmission of a message with confirm_rx flag failed. The
+ * flow's "pending" counter will keep incrementing towards QRTR_TX_FLOW_HIGH,
+ * at which point transmission would stall forever waiting for the resume TX
+ * message associated with the dropped confirm_rx message.
+ * Work around this by marking the flow as having a failed transmission and
+ * cause the next transmission attempt to be sent with the confirm_rx.
+ */
+static void qrtr_tx_flow_failed(struct qrtr_node *node, int dest_node,
+				int dest_port)
+{
+	unsigned long key = (u64)dest_node << 32 | dest_port;
+	struct qrtr_tx_flow *flow;
+
+	rcu_read_lock();
+	flow = radix_tree_lookup(&node->qrtr_tx_flow, key);
+	rcu_read_unlock();
+	if (flow) {
+		spin_lock_irq(&flow->resume_tx.lock);
+		flow->tx_failed = 1;
+		spin_unlock_irq(&flow->resume_tx.lock);
+	}
+}
+
+/* Pass an outgoing packet socket buffer to the endpoint driver. */
+static int qrtr_node_enqueue(struct qrtr_node *node, struct sk_buff *skb,
+			     int type, struct sockaddr_qrtr *from,
+			     struct sockaddr_qrtr *to)
+{
+	struct qrtr_hdr_v1 *hdr;
+	size_t len = skb->len;
+	int rc, confirm_rx;
+
+	confirm_rx = qrtr_tx_wait(node, to->sq_node, to->sq_port, type);
+	if (confirm_rx < 0) {
+		kfree_skb(skb);
+		return confirm_rx;
+	}
+
+	hdr = skb_push(skb, sizeof(*hdr));
+	hdr->version = cpu_to_le32(QRTR_PROTO_VER_1);
+	hdr->type = cpu_to_le32(type);
+	hdr->src_node_id = cpu_to_le32(from->sq_node);
+	hdr->src_port_id = cpu_to_le32(from->sq_port);
+	if (to->sq_port == QRTR_PORT_CTRL) {
+		hdr->dst_node_id = cpu_to_le32(node->nid);
+		hdr->dst_port_id = cpu_to_le32(QRTR_PORT_CTRL);
+	} else {
+		hdr->dst_node_id = cpu_to_le32(to->sq_node);
+		hdr->dst_port_id = cpu_to_le32(to->sq_port);
+	}
+
+	hdr->size = cpu_to_le32(len);
+	hdr->confirm_rx = !!confirm_rx;
+
+	rc = skb_put_padto(skb, ALIGN(len, 4) + sizeof(*hdr));
+
+	if (!rc) {
+		mutex_lock(&node->ep_lock);
+		rc = -ENODEV;
+		if (node->ep)
+			rc = node->ep->xmit(node->ep, skb);
+		else
+			kfree_skb(skb);
+		mutex_unlock(&node->ep_lock);
+	}
+	/* Need to ensure that a subsequent message carries the otherwise lost
+	 * confirm_rx flag if we dropped this one */
+	if (rc && confirm_rx)
+		qrtr_tx_flow_failed(node, to->sq_node, to->sq_port);
+
+	return rc;
+}
+
+/* Lookup node by id.
+ *
+ * callers must release with qrtr_node_release()
+ */
+static struct qrtr_node *qrtr_node_lookup(unsigned int nid)
+{
+	struct qrtr_node *node;
+	unsigned long flags;
+
+	mutex_lock(&qrtr_node_lock);
+	spin_lock_irqsave(&qrtr_nodes_lock, flags);
+	node = radix_tree_lookup(&qrtr_nodes, nid);
+	node = qrtr_node_acquire(node);
+	spin_unlock_irqrestore(&qrtr_nodes_lock, flags);
+	mutex_unlock(&qrtr_node_lock);
+
+	return node;
+}
+
+/* Assign node id to node.
+ *
+ * This is mostly useful for automatic node id assignment, based on
+ * the source id in the incoming packet.
+ */
+static void qrtr_node_assign(struct qrtr_node *node, unsigned int nid)
+{
+	unsigned long flags;
+
+	if (node->nid != QRTR_EP_NID_AUTO || nid == QRTR_EP_NID_AUTO)
+		return;
+
+	spin_lock_irqsave(&qrtr_nodes_lock, flags);
+	radix_tree_insert(&qrtr_nodes, nid, node);
+	node->nid = nid;
+	spin_unlock_irqrestore(&qrtr_nodes_lock, flags);
+}
+
+/**
+ * qrtr_endpoint_post() - post incoming data
+ * @ep: endpoint handle
+ * @data: data pointer
+ * @len: size of data in bytes
+ *
+ * Return: 0 on success; negative error code on failure
+ */
+int qrtr_endpoint_post(struct qrtr_endpoint *ep, const void *data, size_t len)
+{
+	struct qrtr_node *node = ep->node;
+	const struct qrtr_hdr_v1 *v1;
+	const struct qrtr_hdr_v2 *v2;
+	struct qrtr_sock *ipc;
+	struct sk_buff *skb;
+	struct qrtr_cb *cb;
+	size_t size;
+	unsigned int ver;
+	size_t hdrlen;
+
+	if (len == 0 || len & 3)
+		return -EINVAL;
+
+	skb = __netdev_alloc_skb(NULL, len, GFP_ATOMIC | __GFP_NOWARN);
+	if (!skb)
+		return -ENOMEM;
+
+	cb = (struct qrtr_cb *)skb->cb;
+
+	/* Version field in v1 is little endian, so this works for both cases */
+	ver = *(u8*)data;
+
+	switch (ver) {
+	case QRTR_PROTO_VER_1:
+		if (len < sizeof(*v1))
+			goto err;
+		v1 = data;
+		hdrlen = sizeof(*v1);
+
+		cb->type = le32_to_cpu(v1->type);
+		cb->src_node = le32_to_cpu(v1->src_node_id);
+		cb->src_port = le32_to_cpu(v1->src_port_id);
+		cb->confirm_rx = !!v1->confirm_rx;
+		cb->dst_node = le32_to_cpu(v1->dst_node_id);
+		cb->dst_port = le32_to_cpu(v1->dst_port_id);
+
+		size = le32_to_cpu(v1->size);
+		break;
+	case QRTR_PROTO_VER_2:
+		if (len < sizeof(*v2))
+			goto err;
+		v2 = data;
+		hdrlen = sizeof(*v2) + v2->optlen;
+
+		cb->type = v2->type;
+		cb->confirm_rx = !!(v2->flags & QRTR_FLAGS_CONFIRM_RX);
+		cb->src_node = le16_to_cpu(v2->src_node_id);
+		cb->src_port = le16_to_cpu(v2->src_port_id);
+		cb->dst_node = le16_to_cpu(v2->dst_node_id);
+		cb->dst_port = le16_to_cpu(v2->dst_port_id);
+
+		if (cb->src_port == (u16)QRTR_PORT_CTRL)
+			cb->src_port = QRTR_PORT_CTRL;
+		if (cb->dst_port == (u16)QRTR_PORT_CTRL)
+			cb->dst_port = QRTR_PORT_CTRL;
+
+		size = le32_to_cpu(v2->size);
+		break;
+	default:
+		pr_err("qrtr: Invalid version %d\n", ver);
+		goto err;
+	}
+
+	if (!size || len != ALIGN(size, 4) + hdrlen)
+		goto err;
+
+	if ((cb->type == QRTR_TYPE_NEW_SERVER ||
+	     cb->type == QRTR_TYPE_RESUME_TX) &&
+	    size < sizeof(struct qrtr_ctrl_pkt))
+		goto err;
+
+	if (cb->dst_port != QRTR_PORT_CTRL && cb->type != QRTR_TYPE_DATA &&
+	    cb->type != QRTR_TYPE_RESUME_TX)
+		goto err;
+
+	skb_put_data(skb, data + hdrlen, size);
+
+	qrtr_node_assign(node, cb->src_node);
+
+	if (cb->type == QRTR_TYPE_NEW_SERVER) {
+		/* Remote node endpoint can bridge other distant nodes */
+		const struct qrtr_ctrl_pkt *pkt;
+
+		pkt = data + hdrlen;
+		qrtr_node_assign(node, le32_to_cpu(pkt->server.node));
+	}
+
+	if (cb->type == QRTR_TYPE_RESUME_TX) {
+		qrtr_tx_resume(node, skb);
+	} else {
+		ipc = qrtr_port_lookup(cb->dst_port);
+		if (!ipc)
+			goto err;
+
+		if (sock_queue_rcv_skb(&ipc->sk, skb)) {
+			qrtr_port_put(ipc);
+			goto err;
+		}
+
+		qrtr_port_put(ipc);
+	}
+
+	return 0;
+
+err:
+	kfree_skb(skb);
+	return -EINVAL;
+
+}
+EXPORT_SYMBOL_GPL(qrtr_endpoint_post);
+
+/**
+ * qrtr_alloc_ctrl_packet() - allocate control packet skb
+ * @pkt: reference to qrtr_ctrl_pkt pointer
+ *
+ * Returns newly allocated sk_buff, or NULL on failure
+ *
+ * This function allocates a sk_buff large enough to carry a qrtr_ctrl_pkt and
+ * on success returns a reference to the control packet in @pkt.
+ */
+static struct sk_buff *qrtr_alloc_ctrl_packet(struct qrtr_ctrl_pkt **pkt)
+{
+	const int pkt_len = sizeof(struct qrtr_ctrl_pkt);
+	struct sk_buff *skb;
+
+	skb = alloc_skb(QRTR_HDR_MAX_SIZE + pkt_len, GFP_KERNEL);
+	if (!skb)
+		return NULL;
+
+	skb_reserve(skb, QRTR_HDR_MAX_SIZE);
+	*pkt = skb_put_zero(skb, pkt_len);
+
+	return skb;
+}
+
+/**
+ * qrtr_endpoint_register() - register a new endpoint
+ * @ep: endpoint to register
+ * @nid: desired node id; may be QRTR_EP_NID_AUTO for auto-assignment
+ * Return: 0 on success; negative error code on failure
+ *
+ * The specified endpoint must have the xmit function pointer set on call.
+ */
+int qrtr_endpoint_register(struct qrtr_endpoint *ep, unsigned int nid)
+{
+	struct qrtr_node *node;
+
+	if (!ep || !ep->xmit)
+		return -EINVAL;
+
+	node = kzalloc(sizeof(*node), GFP_KERNEL);
+	if (!node)
+		return -ENOMEM;
+
+	kref_init(&node->ref);
+	mutex_init(&node->ep_lock);
+	skb_queue_head_init(&node->rx_queue);
+	node->nid = QRTR_EP_NID_AUTO;
+	node->ep = ep;
+
+	INIT_RADIX_TREE(&node->qrtr_tx_flow, GFP_KERNEL);
+	mutex_init(&node->qrtr_tx_lock);
+
+	qrtr_node_assign(node, nid);
+
+	mutex_lock(&qrtr_node_lock);
+	list_add(&node->item, &qrtr_all_nodes);
+	mutex_unlock(&qrtr_node_lock);
+	ep->node = node;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(qrtr_endpoint_register);
+
+/**
+ * qrtr_endpoint_unregister - unregister endpoint
+ * @ep: endpoint to unregister
+ */
+void qrtr_endpoint_unregister(struct qrtr_endpoint *ep)
+{
+	struct qrtr_node *node = ep->node;
+	struct sockaddr_qrtr src = {AF_QIPCRTR, node->nid, QRTR_PORT_CTRL};
+	struct sockaddr_qrtr dst = {AF_QIPCRTR, qrtr_local_nid, QRTR_PORT_CTRL};
+	struct radix_tree_iter iter;
+	struct qrtr_ctrl_pkt *pkt;
+	struct qrtr_tx_flow *flow;
+	struct sk_buff *skb;
+	void __rcu **slot;
+
+	mutex_lock(&node->ep_lock);
+	node->ep = NULL;
+	mutex_unlock(&node->ep_lock);
+
+	/* Notify the local controller about the event */
+	skb = qrtr_alloc_ctrl_packet(&pkt);
+	if (skb) {
+		pkt->cmd = cpu_to_le32(QRTR_TYPE_BYE);
+		qrtr_local_enqueue(NULL, skb, QRTR_TYPE_BYE, &src, &dst);
+	}
+
+	/* Wake up any transmitters waiting for resume-tx from the node */
+	mutex_lock(&node->qrtr_tx_lock);
+	radix_tree_for_each_slot(slot, &node->qrtr_tx_flow, &iter, 0) {
+		flow = *slot;
+		wake_up_interruptible_all(&flow->resume_tx);
+	}
+	mutex_unlock(&node->qrtr_tx_lock);
+
+	qrtr_node_release(node);
+	ep->node = NULL;
+}
+EXPORT_SYMBOL_GPL(qrtr_endpoint_unregister);
+
+/* Lookup socket by port.
+ *
+ * Callers must release with qrtr_port_put()
+ */
+static struct qrtr_sock *qrtr_port_lookup(int port)
+{
+	struct qrtr_sock *ipc;
+
+	if (port == QRTR_PORT_CTRL)
+		port = 0;
+
+	rcu_read_lock();
+	ipc = xa_load(&qrtr_ports, port);
+	if (ipc)
+		sock_hold(&ipc->sk);
+	rcu_read_unlock();
+
+	return ipc;
+}
+
+/* Release acquired socket. */
+static void qrtr_port_put(struct qrtr_sock *ipc)
+{
+	sock_put(&ipc->sk);
+}
+
+/* Remove port assignment. */
+static void qrtr_port_remove(struct qrtr_sock *ipc)
+{
+	struct qrtr_ctrl_pkt *pkt;
+	struct sk_buff *skb;
+	int port = ipc->us.sq_port;
+	struct sockaddr_qrtr to;
+
+	to.sq_family = AF_QIPCRTR;
+	to.sq_node = QRTR_NODE_BCAST;
+	to.sq_port = QRTR_PORT_CTRL;
+
+	skb = qrtr_alloc_ctrl_packet(&pkt);
+	if (skb) {
+		pkt->cmd = cpu_to_le32(QRTR_TYPE_DEL_CLIENT);
+		pkt->client.node = cpu_to_le32(ipc->us.sq_node);
+		pkt->client.port = cpu_to_le32(ipc->us.sq_port);
+
+		skb_set_owner_w(skb, &ipc->sk);
+		qrtr_bcast_enqueue(NULL, skb, QRTR_TYPE_DEL_CLIENT, &ipc->us,
+				   &to);
+	}
+
+	if (port == QRTR_PORT_CTRL)
+		port = 0;
+
+	__sock_put(&ipc->sk);
+
+	xa_erase(&qrtr_ports, port);
+
+	/* Ensure that if qrtr_port_lookup() did enter the RCU read section we
+	 * wait for it to up increment the refcount */
+	synchronize_rcu();
+}
+
+/* Assign port number to socket.
+ *
+ * Specify port in the integer pointed to by port, and it will be adjusted
+ * on return as necesssary.
+ *
+ * Port may be:
+ *   0: Assign ephemeral port in [QRTR_MIN_EPH_SOCKET, QRTR_MAX_EPH_SOCKET]
+ *   <QRTR_MIN_EPH_SOCKET: Specified; requires CAP_NET_ADMIN
+ *   >QRTR_MIN_EPH_SOCKET: Specified; available to all
+ */
+static int qrtr_port_assign(struct qrtr_sock *ipc, int *port)
+{
+	int rc;
+
+	if (!*port) {
+		rc = xa_alloc(&qrtr_ports, port, ipc, QRTR_EPH_PORT_RANGE,
+				GFP_KERNEL);
+	} else if (*port < QRTR_MIN_EPH_SOCKET && !capable(CAP_NET_ADMIN)) {
+		rc = -EACCES;
+	} else if (*port == QRTR_PORT_CTRL) {
+		rc = xa_insert(&qrtr_ports, 0, ipc, GFP_KERNEL);
+	} else {
+		rc = xa_insert(&qrtr_ports, *port, ipc, GFP_KERNEL);
+	}
+
+	if (rc == -EBUSY)
+		return -EADDRINUSE;
+	else if (rc < 0)
+		return rc;
+
+	sock_hold(&ipc->sk);
+
+	return 0;
+}
+
+/* Reset all non-control ports */
+static void qrtr_reset_ports(void)
+{
+	struct qrtr_sock *ipc;
+	unsigned long index;
+
+	rcu_read_lock();
+	xa_for_each_start(&qrtr_ports, index, ipc, 1) {
+		sock_hold(&ipc->sk);
+		ipc->sk.sk_err = ENETRESET;
+		ipc->sk.sk_error_report(&ipc->sk);
+		sock_put(&ipc->sk);
+	}
+	rcu_read_unlock();
+}
+
+/* Bind socket to address.
+ *
+ * Socket should be locked upon call.
+ */
+static int __qrtr_bind(struct socket *sock,
+		       const struct sockaddr_qrtr *addr, int zapped)
+{
+	struct qrtr_sock *ipc = qrtr_sk(sock->sk);
+	struct sock *sk = sock->sk;
+	int port;
+	int rc;
+
+	/* rebinding ok */
+	if (!zapped && addr->sq_port == ipc->us.sq_port)
+		return 0;
+
+	port = addr->sq_port;
+	rc = qrtr_port_assign(ipc, &port);
+	if (rc)
+		return rc;
+
+	/* unbind previous, if any */
+	if (!zapped)
+		qrtr_port_remove(ipc);
+	ipc->us.sq_port = port;
+
+	sock_reset_flag(sk, SOCK_ZAPPED);
+
+	/* Notify all open ports about the new controller */
+	if (port == QRTR_PORT_CTRL)
+		qrtr_reset_ports();
+
+	return 0;
+}
+
+/* Auto bind to an ephemeral port. */
+static int qrtr_autobind(struct socket *sock)
+{
+	struct sock *sk = sock->sk;
+	struct sockaddr_qrtr addr;
+
+	if (!sock_flag(sk, SOCK_ZAPPED))
+		return 0;
+
+	addr.sq_family = AF_QIPCRTR;
+	addr.sq_node = qrtr_local_nid;
+	addr.sq_port = 0;
+
+	return __qrtr_bind(sock, &addr, 1);
+}
+
+/* Bind socket to specified sockaddr. */
+static int qrtr_bind(struct socket *sock, struct sockaddr *saddr, int len)
+{
+	DECLARE_SOCKADDR(struct sockaddr_qrtr *, addr, saddr);
+	struct qrtr_sock *ipc = qrtr_sk(sock->sk);
+	struct sock *sk = sock->sk;
+	int rc;
+
+	if (len < sizeof(*addr) || addr->sq_family != AF_QIPCRTR)
+		return -EINVAL;
+
+	if (addr->sq_node != ipc->us.sq_node)
+		return -EINVAL;
+
+	lock_sock(sk);
+	rc = __qrtr_bind(sock, addr, sock_flag(sk, SOCK_ZAPPED));
+	release_sock(sk);
+
+	return rc;
+}
+
+/* Queue packet to local peer socket. */
+static int qrtr_local_enqueue(struct qrtr_node *node, struct sk_buff *skb,
+			      int type, struct sockaddr_qrtr *from,
+			      struct sockaddr_qrtr *to)
+{
+	struct qrtr_sock *ipc;
+	struct qrtr_cb *cb;
+
+	ipc = qrtr_port_lookup(to->sq_port);
+	if (!ipc || &ipc->sk == skb->sk) { /* do not send to self */
+		if (ipc)
+			qrtr_port_put(ipc);
+		kfree_skb(skb);
+		return -ENODEV;
+	}
+
+	cb = (struct qrtr_cb *)skb->cb;
+	cb->src_node = from->sq_node;
+	cb->src_port = from->sq_port;
+
+	if (sock_queue_rcv_skb(&ipc->sk, skb)) {
+		qrtr_port_put(ipc);
+		kfree_skb(skb);
+		return -ENOSPC;
+	}
+
+	qrtr_port_put(ipc);
+
+	return 0;
+}
+
+/* Queue packet for broadcast. */
+static int qrtr_bcast_enqueue(struct qrtr_node *node, struct sk_buff *skb,
+			      int type, struct sockaddr_qrtr *from,
+			      struct sockaddr_qrtr *to)
+{
+	struct sk_buff *skbn;
+
+	mutex_lock(&qrtr_node_lock);
+	list_for_each_entry(node, &qrtr_all_nodes, item) {
+		skbn = skb_clone(skb, GFP_KERNEL);
+		if (!skbn)
+			break;
+		skb_set_owner_w(skbn, skb->sk);
+		qrtr_node_enqueue(node, skbn, type, from, to);
+	}
+	mutex_unlock(&qrtr_node_lock);
+
+	qrtr_local_enqueue(NULL, skb, type, from, to);
+
+	return 0;
+}
+
+static int qrtr_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
+{
+	DECLARE_SOCKADDR(struct sockaddr_qrtr *, addr, msg->msg_name);
+	int (*enqueue_fn)(struct qrtr_node *, struct sk_buff *, int,
+			  struct sockaddr_qrtr *, struct sockaddr_qrtr *);
+	__le32 qrtr_type = cpu_to_le32(QRTR_TYPE_DATA);
+	struct qrtr_sock *ipc = qrtr_sk(sock->sk);
+	struct sock *sk = sock->sk;
+	struct qrtr_node *node;
+	struct sk_buff *skb;
+	size_t plen;
+	u32 type;
+	int rc;
+
+	if (msg->msg_flags & ~(MSG_DONTWAIT))
+		return -EINVAL;
+
+	if (len > 65535)
+		return -EMSGSIZE;
+
+	lock_sock(sk);
+
+	if (addr) {
+		if (msg->msg_namelen < sizeof(*addr)) {
+			release_sock(sk);
+			return -EINVAL;
+		}
+
+		if (addr->sq_family != AF_QIPCRTR) {
+			release_sock(sk);
+			return -EINVAL;
+		}
+
+		rc = qrtr_autobind(sock);
+		if (rc) {
+			release_sock(sk);
+			return rc;
+		}
+	} else if (sk->sk_state == TCP_ESTABLISHED) {
+		addr = &ipc->peer;
+	} else {
+		release_sock(sk);
+		return -ENOTCONN;
+	}
+
+	node = NULL;
+	if (addr->sq_node == QRTR_NODE_BCAST) {
+		if (addr->sq_port != QRTR_PORT_CTRL &&
+		    qrtr_local_nid != QRTR_NODE_BCAST) {
+			release_sock(sk);
+			return -ENOTCONN;
+		}
+		enqueue_fn = qrtr_bcast_enqueue;
+	} else if (addr->sq_node == ipc->us.sq_node) {
+		enqueue_fn = qrtr_local_enqueue;
+	} else {
+		node = qrtr_node_lookup(addr->sq_node);
+		if (!node) {
+			release_sock(sk);
+			return -ECONNRESET;
+		}
+		enqueue_fn = qrtr_node_enqueue;
+	}
+
+	plen = (len + 3) & ~3;
+	skb = sock_alloc_send_skb(sk, plen + QRTR_HDR_MAX_SIZE,
+				  msg->msg_flags & MSG_DONTWAIT, &rc);
+	if (!skb) {
+		rc = -ENOMEM;
+		goto out_node;
+	}
+
+	skb_reserve(skb, QRTR_HDR_MAX_SIZE);
+
+	rc = memcpy_from_msg(skb_put(skb, len), msg, len);
+	if (rc) {
+		kfree_skb(skb);
+		goto out_node;
+	}
+
+	if (ipc->us.sq_port == QRTR_PORT_CTRL) {
+		if (len < 4) {
+			rc = -EINVAL;
+			kfree_skb(skb);
+			goto out_node;
+		}
+
+		/* control messages already require the type as 'command' */
+		skb_copy_bits(skb, 0, &qrtr_type, 4);
+	}
+
+	type = le32_to_cpu(qrtr_type);
+	rc = enqueue_fn(node, skb, type, &ipc->us, addr);
+	if (rc >= 0)
+		rc = len;
+
+out_node:
+	qrtr_node_release(node);
+	release_sock(sk);
+
+	return rc;
+}
+
+static int qrtr_send_resume_tx(struct qrtr_cb *cb)
+{
+	struct sockaddr_qrtr remote = { AF_QIPCRTR, cb->src_node, cb->src_port };
+	struct sockaddr_qrtr local = { AF_QIPCRTR, cb->dst_node, cb->dst_port };
+	struct qrtr_ctrl_pkt *pkt;
+	struct qrtr_node *node;
+	struct sk_buff *skb;
+	int ret;
+
+	node = qrtr_node_lookup(remote.sq_node);
+	if (!node)
+		return -EINVAL;
+
+	skb = qrtr_alloc_ctrl_packet(&pkt);
+	if (!skb)
+		return -ENOMEM;
+
+	pkt->cmd = cpu_to_le32(QRTR_TYPE_RESUME_TX);
+	pkt->client.node = cpu_to_le32(cb->dst_node);
+	pkt->client.port = cpu_to_le32(cb->dst_port);
+
+	ret = qrtr_node_enqueue(node, skb, QRTR_TYPE_RESUME_TX, &local, &remote);
+
+	qrtr_node_release(node);
+
+	return ret;
+}
+
+static int qrtr_recvmsg(struct socket *sock, struct msghdr *msg,
+			size_t size, int flags)
+{
+	DECLARE_SOCKADDR(struct sockaddr_qrtr *, addr, msg->msg_name);
+	struct sock *sk = sock->sk;
+	struct sk_buff *skb;
+	struct qrtr_cb *cb;
+	int copied, rc;
+
+	lock_sock(sk);
+
+	if (sock_flag(sk, SOCK_ZAPPED)) {
+		release_sock(sk);
+		return -EADDRNOTAVAIL;
+	}
+
+	skb = skb_recv_datagram(sk, flags & ~MSG_DONTWAIT,
+				flags & MSG_DONTWAIT, &rc);
+	if (!skb) {
+		release_sock(sk);
+		return rc;
+	}
+	cb = (struct qrtr_cb *)skb->cb;
+
+	copied = skb->len;
+	if (copied > size) {
+		copied = size;
+		msg->msg_flags |= MSG_TRUNC;
+	}
+
+	rc = skb_copy_datagram_msg(skb, 0, msg, copied);
+	if (rc < 0)
+		goto out;
+	rc = copied;
+
+	if (addr) {
+		/* There is an anonymous 2-byte hole after sq_family,
+		 * make sure to clear it.
+		 */
+		memset(addr, 0, sizeof(*addr));
+
+		addr->sq_family = AF_QIPCRTR;
+		addr->sq_node = cb->src_node;
+		addr->sq_port = cb->src_port;
+		msg->msg_namelen = sizeof(*addr);
+	}
+
+out:
+	if (cb->confirm_rx)
+		qrtr_send_resume_tx(cb);
+
+	skb_free_datagram(sk, skb);
+	release_sock(sk);
+
+	return rc;
+}
+
+static int qrtr_connect(struct socket *sock, struct sockaddr *saddr,
+			int len, int flags)
+{
+	DECLARE_SOCKADDR(struct sockaddr_qrtr *, addr, saddr);
+	struct qrtr_sock *ipc = qrtr_sk(sock->sk);
+	struct sock *sk = sock->sk;
+	int rc;
+
+	if (len < sizeof(*addr) || addr->sq_family != AF_QIPCRTR)
+		return -EINVAL;
+
+	lock_sock(sk);
+
+	sk->sk_state = TCP_CLOSE;
+	sock->state = SS_UNCONNECTED;
+
+	rc = qrtr_autobind(sock);
+	if (rc) {
+		release_sock(sk);
+		return rc;
+	}
+
+	ipc->peer = *addr;
+	sock->state = SS_CONNECTED;
+	sk->sk_state = TCP_ESTABLISHED;
+
+	release_sock(sk);
+
+	return 0;
+}
+
+static int qrtr_getname(struct socket *sock, struct sockaddr *saddr,
+			int peer)
+{
+	struct qrtr_sock *ipc = qrtr_sk(sock->sk);
+	struct sockaddr_qrtr qaddr;
+	struct sock *sk = sock->sk;
+
+	lock_sock(sk);
+	if (peer) {
+		if (sk->sk_state != TCP_ESTABLISHED) {
+			release_sock(sk);
+			return -ENOTCONN;
+		}
+
+		qaddr = ipc->peer;
+	} else {
+		qaddr = ipc->us;
+	}
+	release_sock(sk);
+
+	qaddr.sq_family = AF_QIPCRTR;
+
+	memcpy(saddr, &qaddr, sizeof(qaddr));
+
+	return sizeof(qaddr);
+}
+
+static int qrtr_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
+{
+	void __user *argp = (void __user *)arg;
+	struct qrtr_sock *ipc = qrtr_sk(sock->sk);
+	struct sock *sk = sock->sk;
+	struct sockaddr_qrtr *sq;
+	struct sk_buff *skb;
+	struct ifreq ifr;
+	long len = 0;
+	int rc = 0;
+
+	lock_sock(sk);
+
+	switch (cmd) {
+	case TIOCOUTQ:
+		len = sk->sk_sndbuf - sk_wmem_alloc_get(sk);
+		if (len < 0)
+			len = 0;
+		rc = put_user(len, (int __user *)argp);
+		break;
+	case TIOCINQ:
+		skb = skb_peek(&sk->sk_receive_queue);
+		if (skb)
+			len = skb->len;
+		rc = put_user(len, (int __user *)argp);
+		break;
+	case SIOCGIFADDR:
+		if (copy_from_user(&ifr, argp, sizeof(ifr))) {
+			rc = -EFAULT;
+			break;
+		}
+
+		sq = (struct sockaddr_qrtr *)&ifr.ifr_addr;
+		*sq = ipc->us;
+		if (copy_to_user(argp, &ifr, sizeof(ifr))) {
+			rc = -EFAULT;
+			break;
+		}
+		break;
+	case SIOCADDRT:
+	case SIOCDELRT:
+	case SIOCSIFADDR:
+	case SIOCGIFDSTADDR:
+	case SIOCSIFDSTADDR:
+	case SIOCGIFBRDADDR:
+	case SIOCSIFBRDADDR:
+	case SIOCGIFNETMASK:
+	case SIOCSIFNETMASK:
+		rc = -EINVAL;
+		break;
+	default:
+		rc = -ENOIOCTLCMD;
+		break;
+	}
+
+	release_sock(sk);
+
+	return rc;
+}
+
+static int qrtr_release(struct socket *sock)
+{
+	struct sock *sk = sock->sk;
+	struct qrtr_sock *ipc;
+
+	if (!sk)
+		return 0;
+
+	lock_sock(sk);
+
+	ipc = qrtr_sk(sk);
+	sk->sk_shutdown = SHUTDOWN_MASK;
+	if (!sock_flag(sk, SOCK_DEAD))
+		sk->sk_state_change(sk);
+
+	sock_set_flag(sk, SOCK_DEAD);
+	sock_orphan(sk);
+	sock->sk = NULL;
+
+	if (!sock_flag(sk, SOCK_ZAPPED))
+		qrtr_port_remove(ipc);
+
+	skb_queue_purge(&sk->sk_receive_queue);
+
+	release_sock(sk);
+	sock_put(sk);
+
+	return 0;
+}
+
+static const struct proto_ops qrtr_proto_ops = {
+	.owner		= THIS_MODULE,
+	.family		= AF_QIPCRTR,
+	.bind		= qrtr_bind,
+	.connect	= qrtr_connect,
+	.socketpair	= sock_no_socketpair,
+	.accept		= sock_no_accept,
+	.listen		= sock_no_listen,
+	.sendmsg	= qrtr_sendmsg,
+	.recvmsg	= qrtr_recvmsg,
+	.getname	= qrtr_getname,
+	.ioctl		= qrtr_ioctl,
+	.gettstamp	= sock_gettstamp,
+	.poll		= datagram_poll,
+	.shutdown	= sock_no_shutdown,
+	.release	= qrtr_release,
+	.mmap		= sock_no_mmap,
+	.sendpage	= sock_no_sendpage,
+};
+
+static struct proto qrtr_proto = {
+	.name		= "QIPCRTR",
+	.owner		= THIS_MODULE,
+	.obj_size	= sizeof(struct qrtr_sock),
+};
+
+static int qrtr_create(struct net *net, struct socket *sock,
+		       int protocol, int kern)
+{
+	struct qrtr_sock *ipc;
+	struct sock *sk;
+
+	if (sock->type != SOCK_DGRAM)
+		return -EPROTOTYPE;
+
+	sk = sk_alloc(net, AF_QIPCRTR, GFP_KERNEL, &qrtr_proto, kern);
+	if (!sk)
+		return -ENOMEM;
+
+	sock_set_flag(sk, SOCK_ZAPPED);
+
+	sock_init_data(sock, sk);
+	sock->ops = &qrtr_proto_ops;
+
+	ipc = qrtr_sk(sk);
+	ipc->us.sq_family = AF_QIPCRTR;
+	ipc->us.sq_node = qrtr_local_nid;
+	ipc->us.sq_port = 0;
+
+	return 0;
+}
+
+static const struct net_proto_family qrtr_family = {
+	.owner	= THIS_MODULE,
+	.family	= AF_QIPCRTR,
+	.create	= qrtr_create,
+};
+
+static int __init qrtr_proto_init(void)
+{
+	int rc;
+
+	rc = proto_register(&qrtr_proto, 1);
+	if (rc)
+		return rc;
+
+	rc = sock_register(&qrtr_family);
+	if (rc) {
+		proto_unregister(&qrtr_proto);
+		return rc;
+	}
+
+	qrtr_ns_init();
+
+	return rc;
+}
+postcore_initcall(qrtr_proto_init);
+
+static void __exit qrtr_proto_fini(void)
+{
+	qrtr_ns_remove();
+	sock_unregister(qrtr_family.family);
+	proto_unregister(&qrtr_proto);
+}
+module_exit(qrtr_proto_fini);
+
+MODULE_DESCRIPTION("Qualcomm IPC-router driver");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS_NETPROTO(PF_QIPCRTR);
diff --git a/net/qrtr/ns.c b/net/qrtr/ns.c
index fe81e0385168..713e9940d88b 100644
--- a/net/qrtr/ns.c
+++ b/net/qrtr/ns.c
@@ -273,7 +273,7 @@ static struct qrtr_server *server_add(unsigned int service,
 	return NULL;
 }
 
-static int server_del(struct qrtr_node *node, unsigned int port)
+static int server_del(struct qrtr_node *node, unsigned int port, bool bcast)
 {
 	struct qrtr_lookup *lookup;
 	struct qrtr_server *srv;
@@ -286,7 +286,7 @@ static int server_del(struct qrtr_node *node, unsigned int port)
 	radix_tree_delete(&node->servers, port);
 
 	/* Broadcast the removal of local servers */
-	if (srv->node == qrtr_ns.local_node)
+	if (srv->node == qrtr_ns.local_node && bcast)
 		service_announce_del(&qrtr_ns.bcast_sq, srv);
 
 	/* Announce the service's disappearance to observers */
@@ -372,7 +372,7 @@ static int ctrl_cmd_bye(struct sockaddr_qrtr *from)
 		}
 		slot = radix_tree_iter_resume(slot, &iter);
 		rcu_read_unlock();
-		server_del(node, srv->port);
+		server_del(node, srv->port, true);
 		rcu_read_lock();
 	}
 	rcu_read_unlock();
@@ -458,10 +458,13 @@ static int ctrl_cmd_del_client(struct sockaddr_qrtr *from,
 		kfree(lookup);
 	}
 
-	/* Remove the server belonging to this port */
+	/* Remove the server belonging to this port but don't broadcast
+	 * DEL_SERVER. Neighbours would've already removed the server belonging
+	 * to this port due to the DEL_CLIENT broadcast from qrtr_port_remove().
+	 */
 	node = node_get(node_id);
 	if (node)
-		server_del(node, port);
+		server_del(node, port, false);
 
 	/* Advertise the removal of this client to all local servers */
 	local_node = node_get(qrtr_ns.local_node);
@@ -574,7 +577,7 @@ static int ctrl_cmd_del_server(struct sockaddr_qrtr *from,
 	if (!node)
 		return -ENOENT;
 
-	return server_del(node, port);
+	return server_del(node, port, true);
 }
 
 static int ctrl_cmd_new_lookup(struct sockaddr_qrtr *from,
diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
deleted file mode 100644
index 13448ca5aeff..000000000000
--- a/net/qrtr/qrtr.c
+++ /dev/null
@@ -1,1288 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * Copyright (c) 2015, Sony Mobile Communications Inc.
- * Copyright (c) 2013, The Linux Foundation. All rights reserved.
- */
-#include <linux/module.h>
-#include <linux/netlink.h>
-#include <linux/qrtr.h>
-#include <linux/termios.h>	/* For TIOCINQ/OUTQ */
-#include <linux/spinlock.h>
-#include <linux/wait.h>
-
-#include <net/sock.h>
-
-#include "qrtr.h"
-
-#define QRTR_PROTO_VER_1 1
-#define QRTR_PROTO_VER_2 3
-
-/* auto-bind range */
-#define QRTR_MIN_EPH_SOCKET 0x4000
-#define QRTR_MAX_EPH_SOCKET 0x7fff
-#define QRTR_EPH_PORT_RANGE \
-		XA_LIMIT(QRTR_MIN_EPH_SOCKET, QRTR_MAX_EPH_SOCKET)
-
-/**
- * struct qrtr_hdr_v1 - (I|R)PCrouter packet header version 1
- * @version: protocol version
- * @type: packet type; one of QRTR_TYPE_*
- * @src_node_id: source node
- * @src_port_id: source port
- * @confirm_rx: boolean; whether a resume-tx packet should be send in reply
- * @size: length of packet, excluding this header
- * @dst_node_id: destination node
- * @dst_port_id: destination port
- */
-struct qrtr_hdr_v1 {
-	__le32 version;
-	__le32 type;
-	__le32 src_node_id;
-	__le32 src_port_id;
-	__le32 confirm_rx;
-	__le32 size;
-	__le32 dst_node_id;
-	__le32 dst_port_id;
-} __packed;
-
-/**
- * struct qrtr_hdr_v2 - (I|R)PCrouter packet header later versions
- * @version: protocol version
- * @type: packet type; one of QRTR_TYPE_*
- * @flags: bitmask of QRTR_FLAGS_*
- * @optlen: length of optional header data
- * @size: length of packet, excluding this header and optlen
- * @src_node_id: source node
- * @src_port_id: source port
- * @dst_node_id: destination node
- * @dst_port_id: destination port
- */
-struct qrtr_hdr_v2 {
-	u8 version;
-	u8 type;
-	u8 flags;
-	u8 optlen;
-	__le32 size;
-	__le16 src_node_id;
-	__le16 src_port_id;
-	__le16 dst_node_id;
-	__le16 dst_port_id;
-};
-
-#define QRTR_FLAGS_CONFIRM_RX	BIT(0)
-
-struct qrtr_cb {
-	u32 src_node;
-	u32 src_port;
-	u32 dst_node;
-	u32 dst_port;
-
-	u8 type;
-	u8 confirm_rx;
-};
-
-#define QRTR_HDR_MAX_SIZE max_t(size_t, sizeof(struct qrtr_hdr_v1), \
-					sizeof(struct qrtr_hdr_v2))
-
-struct qrtr_sock {
-	/* WARNING: sk must be the first member */
-	struct sock sk;
-	struct sockaddr_qrtr us;
-	struct sockaddr_qrtr peer;
-};
-
-static inline struct qrtr_sock *qrtr_sk(struct sock *sk)
-{
-	BUILD_BUG_ON(offsetof(struct qrtr_sock, sk) != 0);
-	return container_of(sk, struct qrtr_sock, sk);
-}
-
-static unsigned int qrtr_local_nid = 1;
-
-/* for node ids */
-static RADIX_TREE(qrtr_nodes, GFP_ATOMIC);
-static DEFINE_SPINLOCK(qrtr_nodes_lock);
-/* broadcast list */
-static LIST_HEAD(qrtr_all_nodes);
-/* lock for qrtr_all_nodes and node reference */
-static DEFINE_MUTEX(qrtr_node_lock);
-
-/* local port allocation management */
-static DEFINE_XARRAY_ALLOC(qrtr_ports);
-
-/**
- * struct qrtr_node - endpoint node
- * @ep_lock: lock for endpoint management and callbacks
- * @ep: endpoint
- * @ref: reference count for node
- * @nid: node id
- * @qrtr_tx_flow: tree of qrtr_tx_flow, keyed by node << 32 | port
- * @qrtr_tx_lock: lock for qrtr_tx_flow inserts
- * @rx_queue: receive queue
- * @item: list item for broadcast list
- */
-struct qrtr_node {
-	struct mutex ep_lock;
-	struct qrtr_endpoint *ep;
-	struct kref ref;
-	unsigned int nid;
-
-	struct radix_tree_root qrtr_tx_flow;
-	struct mutex qrtr_tx_lock; /* for qrtr_tx_flow */
-
-	struct sk_buff_head rx_queue;
-	struct list_head item;
-};
-
-/**
- * struct qrtr_tx_flow - tx flow control
- * @resume_tx: waiters for a resume tx from the remote
- * @pending: number of waiting senders
- * @tx_failed: indicates that a message with confirm_rx flag was lost
- */
-struct qrtr_tx_flow {
-	struct wait_queue_head resume_tx;
-	int pending;
-	int tx_failed;
-};
-
-#define QRTR_TX_FLOW_HIGH	10
-#define QRTR_TX_FLOW_LOW	5
-
-static int qrtr_local_enqueue(struct qrtr_node *node, struct sk_buff *skb,
-			      int type, struct sockaddr_qrtr *from,
-			      struct sockaddr_qrtr *to);
-static int qrtr_bcast_enqueue(struct qrtr_node *node, struct sk_buff *skb,
-			      int type, struct sockaddr_qrtr *from,
-			      struct sockaddr_qrtr *to);
-static struct qrtr_sock *qrtr_port_lookup(int port);
-static void qrtr_port_put(struct qrtr_sock *ipc);
-
-/* Release node resources and free the node.
- *
- * Do not call directly, use qrtr_node_release.  To be used with
- * kref_put_mutex.  As such, the node mutex is expected to be locked on call.
- */
-static void __qrtr_node_release(struct kref *kref)
-{
-	struct qrtr_node *node = container_of(kref, struct qrtr_node, ref);
-	struct radix_tree_iter iter;
-	struct qrtr_tx_flow *flow;
-	unsigned long flags;
-	void __rcu **slot;
-
-	spin_lock_irqsave(&qrtr_nodes_lock, flags);
-	if (node->nid != QRTR_EP_NID_AUTO)
-		radix_tree_delete(&qrtr_nodes, node->nid);
-	spin_unlock_irqrestore(&qrtr_nodes_lock, flags);
-
-	list_del(&node->item);
-	mutex_unlock(&qrtr_node_lock);
-
-	skb_queue_purge(&node->rx_queue);
-
-	/* Free tx flow counters */
-	radix_tree_for_each_slot(slot, &node->qrtr_tx_flow, &iter, 0) {
-		flow = *slot;
-		radix_tree_iter_delete(&node->qrtr_tx_flow, &iter, slot);
-		kfree(flow);
-	}
-	kfree(node);
-}
-
-/* Increment reference to node. */
-static struct qrtr_node *qrtr_node_acquire(struct qrtr_node *node)
-{
-	if (node)
-		kref_get(&node->ref);
-	return node;
-}
-
-/* Decrement reference to node and release as necessary. */
-static void qrtr_node_release(struct qrtr_node *node)
-{
-	if (!node)
-		return;
-	kref_put_mutex(&node->ref, __qrtr_node_release, &qrtr_node_lock);
-}
-
-/**
- * qrtr_tx_resume() - reset flow control counter
- * @node:	qrtr_node that the QRTR_TYPE_RESUME_TX packet arrived on
- * @skb:	resume_tx packet
- */
-static void qrtr_tx_resume(struct qrtr_node *node, struct sk_buff *skb)
-{
-	struct qrtr_ctrl_pkt *pkt = (struct qrtr_ctrl_pkt *)skb->data;
-	u64 remote_node = le32_to_cpu(pkt->client.node);
-	u32 remote_port = le32_to_cpu(pkt->client.port);
-	struct qrtr_tx_flow *flow;
-	unsigned long key;
-
-	key = remote_node << 32 | remote_port;
-
-	rcu_read_lock();
-	flow = radix_tree_lookup(&node->qrtr_tx_flow, key);
-	rcu_read_unlock();
-	if (flow) {
-		spin_lock(&flow->resume_tx.lock);
-		flow->pending = 0;
-		spin_unlock(&flow->resume_tx.lock);
-		wake_up_interruptible_all(&flow->resume_tx);
-	}
-
-	consume_skb(skb);
-}
-
-/**
- * qrtr_tx_wait() - flow control for outgoing packets
- * @node:	qrtr_node that the packet is to be send to
- * @dest_node:	node id of the destination
- * @dest_port:	port number of the destination
- * @type:	type of message
- *
- * The flow control scheme is based around the low and high "watermarks". When
- * the low watermark is passed the confirm_rx flag is set on the outgoing
- * message, which will trigger the remote to send a control message of the type
- * QRTR_TYPE_RESUME_TX to reset the counter. If the high watermark is hit
- * further transmision should be paused.
- *
- * Return: 1 if confirm_rx should be set, 0 otherwise or errno failure
- */
-static int qrtr_tx_wait(struct qrtr_node *node, int dest_node, int dest_port,
-			int type)
-{
-	unsigned long key = (u64)dest_node << 32 | dest_port;
-	struct qrtr_tx_flow *flow;
-	int confirm_rx = 0;
-	int ret;
-
-	/* Never set confirm_rx on non-data packets */
-	if (type != QRTR_TYPE_DATA)
-		return 0;
-
-	mutex_lock(&node->qrtr_tx_lock);
-	flow = radix_tree_lookup(&node->qrtr_tx_flow, key);
-	if (!flow) {
-		flow = kzalloc(sizeof(*flow), GFP_KERNEL);
-		if (flow) {
-			init_waitqueue_head(&flow->resume_tx);
-			if (radix_tree_insert(&node->qrtr_tx_flow, key, flow)) {
-				kfree(flow);
-				flow = NULL;
-			}
-		}
-	}
-	mutex_unlock(&node->qrtr_tx_lock);
-
-	/* Set confirm_rx if we where unable to find and allocate a flow */
-	if (!flow)
-		return 1;
-
-	spin_lock_irq(&flow->resume_tx.lock);
-	ret = wait_event_interruptible_locked_irq(flow->resume_tx,
-						  flow->pending < QRTR_TX_FLOW_HIGH ||
-						  flow->tx_failed ||
-						  !node->ep);
-	if (ret < 0) {
-		confirm_rx = ret;
-	} else if (!node->ep) {
-		confirm_rx = -EPIPE;
-	} else if (flow->tx_failed) {
-		flow->tx_failed = 0;
-		confirm_rx = 1;
-	} else {
-		flow->pending++;
-		confirm_rx = flow->pending == QRTR_TX_FLOW_LOW;
-	}
-	spin_unlock_irq(&flow->resume_tx.lock);
-
-	return confirm_rx;
-}
-
-/**
- * qrtr_tx_flow_failed() - flag that tx of confirm_rx flagged messages failed
- * @node:	qrtr_node that the packet is to be send to
- * @dest_node:	node id of the destination
- * @dest_port:	port number of the destination
- *
- * Signal that the transmission of a message with confirm_rx flag failed. The
- * flow's "pending" counter will keep incrementing towards QRTR_TX_FLOW_HIGH,
- * at which point transmission would stall forever waiting for the resume TX
- * message associated with the dropped confirm_rx message.
- * Work around this by marking the flow as having a failed transmission and
- * cause the next transmission attempt to be sent with the confirm_rx.
- */
-static void qrtr_tx_flow_failed(struct qrtr_node *node, int dest_node,
-				int dest_port)
-{
-	unsigned long key = (u64)dest_node << 32 | dest_port;
-	struct qrtr_tx_flow *flow;
-
-	rcu_read_lock();
-	flow = radix_tree_lookup(&node->qrtr_tx_flow, key);
-	rcu_read_unlock();
-	if (flow) {
-		spin_lock_irq(&flow->resume_tx.lock);
-		flow->tx_failed = 1;
-		spin_unlock_irq(&flow->resume_tx.lock);
-	}
-}
-
-/* Pass an outgoing packet socket buffer to the endpoint driver. */
-static int qrtr_node_enqueue(struct qrtr_node *node, struct sk_buff *skb,
-			     int type, struct sockaddr_qrtr *from,
-			     struct sockaddr_qrtr *to)
-{
-	struct qrtr_hdr_v1 *hdr;
-	size_t len = skb->len;
-	int rc, confirm_rx;
-
-	confirm_rx = qrtr_tx_wait(node, to->sq_node, to->sq_port, type);
-	if (confirm_rx < 0) {
-		kfree_skb(skb);
-		return confirm_rx;
-	}
-
-	hdr = skb_push(skb, sizeof(*hdr));
-	hdr->version = cpu_to_le32(QRTR_PROTO_VER_1);
-	hdr->type = cpu_to_le32(type);
-	hdr->src_node_id = cpu_to_le32(from->sq_node);
-	hdr->src_port_id = cpu_to_le32(from->sq_port);
-	if (to->sq_port == QRTR_PORT_CTRL) {
-		hdr->dst_node_id = cpu_to_le32(node->nid);
-		hdr->dst_port_id = cpu_to_le32(QRTR_PORT_CTRL);
-	} else {
-		hdr->dst_node_id = cpu_to_le32(to->sq_node);
-		hdr->dst_port_id = cpu_to_le32(to->sq_port);
-	}
-
-	hdr->size = cpu_to_le32(len);
-	hdr->confirm_rx = !!confirm_rx;
-
-	rc = skb_put_padto(skb, ALIGN(len, 4) + sizeof(*hdr));
-
-	if (!rc) {
-		mutex_lock(&node->ep_lock);
-		rc = -ENODEV;
-		if (node->ep)
-			rc = node->ep->xmit(node->ep, skb);
-		else
-			kfree_skb(skb);
-		mutex_unlock(&node->ep_lock);
-	}
-	/* Need to ensure that a subsequent message carries the otherwise lost
-	 * confirm_rx flag if we dropped this one */
-	if (rc && confirm_rx)
-		qrtr_tx_flow_failed(node, to->sq_node, to->sq_port);
-
-	return rc;
-}
-
-/* Lookup node by id.
- *
- * callers must release with qrtr_node_release()
- */
-static struct qrtr_node *qrtr_node_lookup(unsigned int nid)
-{
-	struct qrtr_node *node;
-	unsigned long flags;
-
-	spin_lock_irqsave(&qrtr_nodes_lock, flags);
-	node = radix_tree_lookup(&qrtr_nodes, nid);
-	node = qrtr_node_acquire(node);
-	spin_unlock_irqrestore(&qrtr_nodes_lock, flags);
-
-	return node;
-}
-
-/* Assign node id to node.
- *
- * This is mostly useful for automatic node id assignment, based on
- * the source id in the incoming packet.
- */
-static void qrtr_node_assign(struct qrtr_node *node, unsigned int nid)
-{
-	unsigned long flags;
-
-	if (node->nid != QRTR_EP_NID_AUTO || nid == QRTR_EP_NID_AUTO)
-		return;
-
-	spin_lock_irqsave(&qrtr_nodes_lock, flags);
-	radix_tree_insert(&qrtr_nodes, nid, node);
-	node->nid = nid;
-	spin_unlock_irqrestore(&qrtr_nodes_lock, flags);
-}
-
-/**
- * qrtr_endpoint_post() - post incoming data
- * @ep: endpoint handle
- * @data: data pointer
- * @len: size of data in bytes
- *
- * Return: 0 on success; negative error code on failure
- */
-int qrtr_endpoint_post(struct qrtr_endpoint *ep, const void *data, size_t len)
-{
-	struct qrtr_node *node = ep->node;
-	const struct qrtr_hdr_v1 *v1;
-	const struct qrtr_hdr_v2 *v2;
-	struct qrtr_sock *ipc;
-	struct sk_buff *skb;
-	struct qrtr_cb *cb;
-	size_t size;
-	unsigned int ver;
-	size_t hdrlen;
-
-	if (len == 0 || len & 3)
-		return -EINVAL;
-
-	skb = __netdev_alloc_skb(NULL, len, GFP_ATOMIC | __GFP_NOWARN);
-	if (!skb)
-		return -ENOMEM;
-
-	cb = (struct qrtr_cb *)skb->cb;
-
-	/* Version field in v1 is little endian, so this works for both cases */
-	ver = *(u8*)data;
-
-	switch (ver) {
-	case QRTR_PROTO_VER_1:
-		if (len < sizeof(*v1))
-			goto err;
-		v1 = data;
-		hdrlen = sizeof(*v1);
-
-		cb->type = le32_to_cpu(v1->type);
-		cb->src_node = le32_to_cpu(v1->src_node_id);
-		cb->src_port = le32_to_cpu(v1->src_port_id);
-		cb->confirm_rx = !!v1->confirm_rx;
-		cb->dst_node = le32_to_cpu(v1->dst_node_id);
-		cb->dst_port = le32_to_cpu(v1->dst_port_id);
-
-		size = le32_to_cpu(v1->size);
-		break;
-	case QRTR_PROTO_VER_2:
-		if (len < sizeof(*v2))
-			goto err;
-		v2 = data;
-		hdrlen = sizeof(*v2) + v2->optlen;
-
-		cb->type = v2->type;
-		cb->confirm_rx = !!(v2->flags & QRTR_FLAGS_CONFIRM_RX);
-		cb->src_node = le16_to_cpu(v2->src_node_id);
-		cb->src_port = le16_to_cpu(v2->src_port_id);
-		cb->dst_node = le16_to_cpu(v2->dst_node_id);
-		cb->dst_port = le16_to_cpu(v2->dst_port_id);
-
-		if (cb->src_port == (u16)QRTR_PORT_CTRL)
-			cb->src_port = QRTR_PORT_CTRL;
-		if (cb->dst_port == (u16)QRTR_PORT_CTRL)
-			cb->dst_port = QRTR_PORT_CTRL;
-
-		size = le32_to_cpu(v2->size);
-		break;
-	default:
-		pr_err("qrtr: Invalid version %d\n", ver);
-		goto err;
-	}
-
-	if (!size || len != ALIGN(size, 4) + hdrlen)
-		goto err;
-
-	if (cb->dst_port != QRTR_PORT_CTRL && cb->type != QRTR_TYPE_DATA &&
-	    cb->type != QRTR_TYPE_RESUME_TX)
-		goto err;
-
-	skb_put_data(skb, data + hdrlen, size);
-
-	qrtr_node_assign(node, cb->src_node);
-
-	if (cb->type == QRTR_TYPE_RESUME_TX) {
-		qrtr_tx_resume(node, skb);
-	} else {
-		ipc = qrtr_port_lookup(cb->dst_port);
-		if (!ipc)
-			goto err;
-
-		if (sock_queue_rcv_skb(&ipc->sk, skb)) {
-			qrtr_port_put(ipc);
-			goto err;
-		}
-
-		qrtr_port_put(ipc);
-	}
-
-	return 0;
-
-err:
-	kfree_skb(skb);
-	return -EINVAL;
-
-}
-EXPORT_SYMBOL_GPL(qrtr_endpoint_post);
-
-/**
- * qrtr_alloc_ctrl_packet() - allocate control packet skb
- * @pkt: reference to qrtr_ctrl_pkt pointer
- *
- * Returns newly allocated sk_buff, or NULL on failure
- *
- * This function allocates a sk_buff large enough to carry a qrtr_ctrl_pkt and
- * on success returns a reference to the control packet in @pkt.
- */
-static struct sk_buff *qrtr_alloc_ctrl_packet(struct qrtr_ctrl_pkt **pkt)
-{
-	const int pkt_len = sizeof(struct qrtr_ctrl_pkt);
-	struct sk_buff *skb;
-
-	skb = alloc_skb(QRTR_HDR_MAX_SIZE + pkt_len, GFP_KERNEL);
-	if (!skb)
-		return NULL;
-
-	skb_reserve(skb, QRTR_HDR_MAX_SIZE);
-	*pkt = skb_put_zero(skb, pkt_len);
-
-	return skb;
-}
-
-/**
- * qrtr_endpoint_register() - register a new endpoint
- * @ep: endpoint to register
- * @nid: desired node id; may be QRTR_EP_NID_AUTO for auto-assignment
- * Return: 0 on success; negative error code on failure
- *
- * The specified endpoint must have the xmit function pointer set on call.
- */
-int qrtr_endpoint_register(struct qrtr_endpoint *ep, unsigned int nid)
-{
-	struct qrtr_node *node;
-
-	if (!ep || !ep->xmit)
-		return -EINVAL;
-
-	node = kzalloc(sizeof(*node), GFP_KERNEL);
-	if (!node)
-		return -ENOMEM;
-
-	kref_init(&node->ref);
-	mutex_init(&node->ep_lock);
-	skb_queue_head_init(&node->rx_queue);
-	node->nid = QRTR_EP_NID_AUTO;
-	node->ep = ep;
-
-	INIT_RADIX_TREE(&node->qrtr_tx_flow, GFP_KERNEL);
-	mutex_init(&node->qrtr_tx_lock);
-
-	qrtr_node_assign(node, nid);
-
-	mutex_lock(&qrtr_node_lock);
-	list_add(&node->item, &qrtr_all_nodes);
-	mutex_unlock(&qrtr_node_lock);
-	ep->node = node;
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(qrtr_endpoint_register);
-
-/**
- * qrtr_endpoint_unregister - unregister endpoint
- * @ep: endpoint to unregister
- */
-void qrtr_endpoint_unregister(struct qrtr_endpoint *ep)
-{
-	struct qrtr_node *node = ep->node;
-	struct sockaddr_qrtr src = {AF_QIPCRTR, node->nid, QRTR_PORT_CTRL};
-	struct sockaddr_qrtr dst = {AF_QIPCRTR, qrtr_local_nid, QRTR_PORT_CTRL};
-	struct radix_tree_iter iter;
-	struct qrtr_ctrl_pkt *pkt;
-	struct qrtr_tx_flow *flow;
-	struct sk_buff *skb;
-	void __rcu **slot;
-
-	mutex_lock(&node->ep_lock);
-	node->ep = NULL;
-	mutex_unlock(&node->ep_lock);
-
-	/* Notify the local controller about the event */
-	skb = qrtr_alloc_ctrl_packet(&pkt);
-	if (skb) {
-		pkt->cmd = cpu_to_le32(QRTR_TYPE_BYE);
-		qrtr_local_enqueue(NULL, skb, QRTR_TYPE_BYE, &src, &dst);
-	}
-
-	/* Wake up any transmitters waiting for resume-tx from the node */
-	mutex_lock(&node->qrtr_tx_lock);
-	radix_tree_for_each_slot(slot, &node->qrtr_tx_flow, &iter, 0) {
-		flow = *slot;
-		wake_up_interruptible_all(&flow->resume_tx);
-	}
-	mutex_unlock(&node->qrtr_tx_lock);
-
-	qrtr_node_release(node);
-	ep->node = NULL;
-}
-EXPORT_SYMBOL_GPL(qrtr_endpoint_unregister);
-
-/* Lookup socket by port.
- *
- * Callers must release with qrtr_port_put()
- */
-static struct qrtr_sock *qrtr_port_lookup(int port)
-{
-	struct qrtr_sock *ipc;
-
-	if (port == QRTR_PORT_CTRL)
-		port = 0;
-
-	rcu_read_lock();
-	ipc = xa_load(&qrtr_ports, port);
-	if (ipc)
-		sock_hold(&ipc->sk);
-	rcu_read_unlock();
-
-	return ipc;
-}
-
-/* Release acquired socket. */
-static void qrtr_port_put(struct qrtr_sock *ipc)
-{
-	sock_put(&ipc->sk);
-}
-
-/* Remove port assignment. */
-static void qrtr_port_remove(struct qrtr_sock *ipc)
-{
-	struct qrtr_ctrl_pkt *pkt;
-	struct sk_buff *skb;
-	int port = ipc->us.sq_port;
-	struct sockaddr_qrtr to;
-
-	to.sq_family = AF_QIPCRTR;
-	to.sq_node = QRTR_NODE_BCAST;
-	to.sq_port = QRTR_PORT_CTRL;
-
-	skb = qrtr_alloc_ctrl_packet(&pkt);
-	if (skb) {
-		pkt->cmd = cpu_to_le32(QRTR_TYPE_DEL_CLIENT);
-		pkt->client.node = cpu_to_le32(ipc->us.sq_node);
-		pkt->client.port = cpu_to_le32(ipc->us.sq_port);
-
-		skb_set_owner_w(skb, &ipc->sk);
-		qrtr_bcast_enqueue(NULL, skb, QRTR_TYPE_DEL_CLIENT, &ipc->us,
-				   &to);
-	}
-
-	if (port == QRTR_PORT_CTRL)
-		port = 0;
-
-	__sock_put(&ipc->sk);
-
-	xa_erase(&qrtr_ports, port);
-
-	/* Ensure that if qrtr_port_lookup() did enter the RCU read section we
-	 * wait for it to up increment the refcount */
-	synchronize_rcu();
-}
-
-/* Assign port number to socket.
- *
- * Specify port in the integer pointed to by port, and it will be adjusted
- * on return as necesssary.
- *
- * Port may be:
- *   0: Assign ephemeral port in [QRTR_MIN_EPH_SOCKET, QRTR_MAX_EPH_SOCKET]
- *   <QRTR_MIN_EPH_SOCKET: Specified; requires CAP_NET_ADMIN
- *   >QRTR_MIN_EPH_SOCKET: Specified; available to all
- */
-static int qrtr_port_assign(struct qrtr_sock *ipc, int *port)
-{
-	int rc;
-
-	if (!*port) {
-		rc = xa_alloc(&qrtr_ports, port, ipc, QRTR_EPH_PORT_RANGE,
-				GFP_KERNEL);
-	} else if (*port < QRTR_MIN_EPH_SOCKET && !capable(CAP_NET_ADMIN)) {
-		rc = -EACCES;
-	} else if (*port == QRTR_PORT_CTRL) {
-		rc = xa_insert(&qrtr_ports, 0, ipc, GFP_KERNEL);
-	} else {
-		rc = xa_insert(&qrtr_ports, *port, ipc, GFP_KERNEL);
-	}
-
-	if (rc == -EBUSY)
-		return -EADDRINUSE;
-	else if (rc < 0)
-		return rc;
-
-	sock_hold(&ipc->sk);
-
-	return 0;
-}
-
-/* Reset all non-control ports */
-static void qrtr_reset_ports(void)
-{
-	struct qrtr_sock *ipc;
-	unsigned long index;
-
-	rcu_read_lock();
-	xa_for_each_start(&qrtr_ports, index, ipc, 1) {
-		sock_hold(&ipc->sk);
-		ipc->sk.sk_err = ENETRESET;
-		ipc->sk.sk_error_report(&ipc->sk);
-		sock_put(&ipc->sk);
-	}
-	rcu_read_unlock();
-}
-
-/* Bind socket to address.
- *
- * Socket should be locked upon call.
- */
-static int __qrtr_bind(struct socket *sock,
-		       const struct sockaddr_qrtr *addr, int zapped)
-{
-	struct qrtr_sock *ipc = qrtr_sk(sock->sk);
-	struct sock *sk = sock->sk;
-	int port;
-	int rc;
-
-	/* rebinding ok */
-	if (!zapped && addr->sq_port == ipc->us.sq_port)
-		return 0;
-
-	port = addr->sq_port;
-	rc = qrtr_port_assign(ipc, &port);
-	if (rc)
-		return rc;
-
-	/* unbind previous, if any */
-	if (!zapped)
-		qrtr_port_remove(ipc);
-	ipc->us.sq_port = port;
-
-	sock_reset_flag(sk, SOCK_ZAPPED);
-
-	/* Notify all open ports about the new controller */
-	if (port == QRTR_PORT_CTRL)
-		qrtr_reset_ports();
-
-	return 0;
-}
-
-/* Auto bind to an ephemeral port. */
-static int qrtr_autobind(struct socket *sock)
-{
-	struct sock *sk = sock->sk;
-	struct sockaddr_qrtr addr;
-
-	if (!sock_flag(sk, SOCK_ZAPPED))
-		return 0;
-
-	addr.sq_family = AF_QIPCRTR;
-	addr.sq_node = qrtr_local_nid;
-	addr.sq_port = 0;
-
-	return __qrtr_bind(sock, &addr, 1);
-}
-
-/* Bind socket to specified sockaddr. */
-static int qrtr_bind(struct socket *sock, struct sockaddr *saddr, int len)
-{
-	DECLARE_SOCKADDR(struct sockaddr_qrtr *, addr, saddr);
-	struct qrtr_sock *ipc = qrtr_sk(sock->sk);
-	struct sock *sk = sock->sk;
-	int rc;
-
-	if (len < sizeof(*addr) || addr->sq_family != AF_QIPCRTR)
-		return -EINVAL;
-
-	if (addr->sq_node != ipc->us.sq_node)
-		return -EINVAL;
-
-	lock_sock(sk);
-	rc = __qrtr_bind(sock, addr, sock_flag(sk, SOCK_ZAPPED));
-	release_sock(sk);
-
-	return rc;
-}
-
-/* Queue packet to local peer socket. */
-static int qrtr_local_enqueue(struct qrtr_node *node, struct sk_buff *skb,
-			      int type, struct sockaddr_qrtr *from,
-			      struct sockaddr_qrtr *to)
-{
-	struct qrtr_sock *ipc;
-	struct qrtr_cb *cb;
-
-	ipc = qrtr_port_lookup(to->sq_port);
-	if (!ipc || &ipc->sk == skb->sk) { /* do not send to self */
-		if (ipc)
-			qrtr_port_put(ipc);
-		kfree_skb(skb);
-		return -ENODEV;
-	}
-
-	cb = (struct qrtr_cb *)skb->cb;
-	cb->src_node = from->sq_node;
-	cb->src_port = from->sq_port;
-
-	if (sock_queue_rcv_skb(&ipc->sk, skb)) {
-		qrtr_port_put(ipc);
-		kfree_skb(skb);
-		return -ENOSPC;
-	}
-
-	qrtr_port_put(ipc);
-
-	return 0;
-}
-
-/* Queue packet for broadcast. */
-static int qrtr_bcast_enqueue(struct qrtr_node *node, struct sk_buff *skb,
-			      int type, struct sockaddr_qrtr *from,
-			      struct sockaddr_qrtr *to)
-{
-	struct sk_buff *skbn;
-
-	mutex_lock(&qrtr_node_lock);
-	list_for_each_entry(node, &qrtr_all_nodes, item) {
-		skbn = skb_clone(skb, GFP_KERNEL);
-		if (!skbn)
-			break;
-		skb_set_owner_w(skbn, skb->sk);
-		qrtr_node_enqueue(node, skbn, type, from, to);
-	}
-	mutex_unlock(&qrtr_node_lock);
-
-	qrtr_local_enqueue(NULL, skb, type, from, to);
-
-	return 0;
-}
-
-static int qrtr_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
-{
-	DECLARE_SOCKADDR(struct sockaddr_qrtr *, addr, msg->msg_name);
-	int (*enqueue_fn)(struct qrtr_node *, struct sk_buff *, int,
-			  struct sockaddr_qrtr *, struct sockaddr_qrtr *);
-	__le32 qrtr_type = cpu_to_le32(QRTR_TYPE_DATA);
-	struct qrtr_sock *ipc = qrtr_sk(sock->sk);
-	struct sock *sk = sock->sk;
-	struct qrtr_node *node;
-	struct sk_buff *skb;
-	size_t plen;
-	u32 type;
-	int rc;
-
-	if (msg->msg_flags & ~(MSG_DONTWAIT))
-		return -EINVAL;
-
-	if (len > 65535)
-		return -EMSGSIZE;
-
-	lock_sock(sk);
-
-	if (addr) {
-		if (msg->msg_namelen < sizeof(*addr)) {
-			release_sock(sk);
-			return -EINVAL;
-		}
-
-		if (addr->sq_family != AF_QIPCRTR) {
-			release_sock(sk);
-			return -EINVAL;
-		}
-
-		rc = qrtr_autobind(sock);
-		if (rc) {
-			release_sock(sk);
-			return rc;
-		}
-	} else if (sk->sk_state == TCP_ESTABLISHED) {
-		addr = &ipc->peer;
-	} else {
-		release_sock(sk);
-		return -ENOTCONN;
-	}
-
-	node = NULL;
-	if (addr->sq_node == QRTR_NODE_BCAST) {
-		if (addr->sq_port != QRTR_PORT_CTRL &&
-		    qrtr_local_nid != QRTR_NODE_BCAST) {
-			release_sock(sk);
-			return -ENOTCONN;
-		}
-		enqueue_fn = qrtr_bcast_enqueue;
-	} else if (addr->sq_node == ipc->us.sq_node) {
-		enqueue_fn = qrtr_local_enqueue;
-	} else {
-		node = qrtr_node_lookup(addr->sq_node);
-		if (!node) {
-			release_sock(sk);
-			return -ECONNRESET;
-		}
-		enqueue_fn = qrtr_node_enqueue;
-	}
-
-	plen = (len + 3) & ~3;
-	skb = sock_alloc_send_skb(sk, plen + QRTR_HDR_MAX_SIZE,
-				  msg->msg_flags & MSG_DONTWAIT, &rc);
-	if (!skb) {
-		rc = -ENOMEM;
-		goto out_node;
-	}
-
-	skb_reserve(skb, QRTR_HDR_MAX_SIZE);
-
-	rc = memcpy_from_msg(skb_put(skb, len), msg, len);
-	if (rc) {
-		kfree_skb(skb);
-		goto out_node;
-	}
-
-	if (ipc->us.sq_port == QRTR_PORT_CTRL) {
-		if (len < 4) {
-			rc = -EINVAL;
-			kfree_skb(skb);
-			goto out_node;
-		}
-
-		/* control messages already require the type as 'command' */
-		skb_copy_bits(skb, 0, &qrtr_type, 4);
-	}
-
-	type = le32_to_cpu(qrtr_type);
-	rc = enqueue_fn(node, skb, type, &ipc->us, addr);
-	if (rc >= 0)
-		rc = len;
-
-out_node:
-	qrtr_node_release(node);
-	release_sock(sk);
-
-	return rc;
-}
-
-static int qrtr_send_resume_tx(struct qrtr_cb *cb)
-{
-	struct sockaddr_qrtr remote = { AF_QIPCRTR, cb->src_node, cb->src_port };
-	struct sockaddr_qrtr local = { AF_QIPCRTR, cb->dst_node, cb->dst_port };
-	struct qrtr_ctrl_pkt *pkt;
-	struct qrtr_node *node;
-	struct sk_buff *skb;
-	int ret;
-
-	node = qrtr_node_lookup(remote.sq_node);
-	if (!node)
-		return -EINVAL;
-
-	skb = qrtr_alloc_ctrl_packet(&pkt);
-	if (!skb)
-		return -ENOMEM;
-
-	pkt->cmd = cpu_to_le32(QRTR_TYPE_RESUME_TX);
-	pkt->client.node = cpu_to_le32(cb->dst_node);
-	pkt->client.port = cpu_to_le32(cb->dst_port);
-
-	ret = qrtr_node_enqueue(node, skb, QRTR_TYPE_RESUME_TX, &local, &remote);
-
-	qrtr_node_release(node);
-
-	return ret;
-}
-
-static int qrtr_recvmsg(struct socket *sock, struct msghdr *msg,
-			size_t size, int flags)
-{
-	DECLARE_SOCKADDR(struct sockaddr_qrtr *, addr, msg->msg_name);
-	struct sock *sk = sock->sk;
-	struct sk_buff *skb;
-	struct qrtr_cb *cb;
-	int copied, rc;
-
-	lock_sock(sk);
-
-	if (sock_flag(sk, SOCK_ZAPPED)) {
-		release_sock(sk);
-		return -EADDRNOTAVAIL;
-	}
-
-	skb = skb_recv_datagram(sk, flags & ~MSG_DONTWAIT,
-				flags & MSG_DONTWAIT, &rc);
-	if (!skb) {
-		release_sock(sk);
-		return rc;
-	}
-	cb = (struct qrtr_cb *)skb->cb;
-
-	copied = skb->len;
-	if (copied > size) {
-		copied = size;
-		msg->msg_flags |= MSG_TRUNC;
-	}
-
-	rc = skb_copy_datagram_msg(skb, 0, msg, copied);
-	if (rc < 0)
-		goto out;
-	rc = copied;
-
-	if (addr) {
-		/* There is an anonymous 2-byte hole after sq_family,
-		 * make sure to clear it.
-		 */
-		memset(addr, 0, sizeof(*addr));
-
-		addr->sq_family = AF_QIPCRTR;
-		addr->sq_node = cb->src_node;
-		addr->sq_port = cb->src_port;
-		msg->msg_namelen = sizeof(*addr);
-	}
-
-out:
-	if (cb->confirm_rx)
-		qrtr_send_resume_tx(cb);
-
-	skb_free_datagram(sk, skb);
-	release_sock(sk);
-
-	return rc;
-}
-
-static int qrtr_connect(struct socket *sock, struct sockaddr *saddr,
-			int len, int flags)
-{
-	DECLARE_SOCKADDR(struct sockaddr_qrtr *, addr, saddr);
-	struct qrtr_sock *ipc = qrtr_sk(sock->sk);
-	struct sock *sk = sock->sk;
-	int rc;
-
-	if (len < sizeof(*addr) || addr->sq_family != AF_QIPCRTR)
-		return -EINVAL;
-
-	lock_sock(sk);
-
-	sk->sk_state = TCP_CLOSE;
-	sock->state = SS_UNCONNECTED;
-
-	rc = qrtr_autobind(sock);
-	if (rc) {
-		release_sock(sk);
-		return rc;
-	}
-
-	ipc->peer = *addr;
-	sock->state = SS_CONNECTED;
-	sk->sk_state = TCP_ESTABLISHED;
-
-	release_sock(sk);
-
-	return 0;
-}
-
-static int qrtr_getname(struct socket *sock, struct sockaddr *saddr,
-			int peer)
-{
-	struct qrtr_sock *ipc = qrtr_sk(sock->sk);
-	struct sockaddr_qrtr qaddr;
-	struct sock *sk = sock->sk;
-
-	lock_sock(sk);
-	if (peer) {
-		if (sk->sk_state != TCP_ESTABLISHED) {
-			release_sock(sk);
-			return -ENOTCONN;
-		}
-
-		qaddr = ipc->peer;
-	} else {
-		qaddr = ipc->us;
-	}
-	release_sock(sk);
-
-	qaddr.sq_family = AF_QIPCRTR;
-
-	memcpy(saddr, &qaddr, sizeof(qaddr));
-
-	return sizeof(qaddr);
-}
-
-static int qrtr_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
-{
-	void __user *argp = (void __user *)arg;
-	struct qrtr_sock *ipc = qrtr_sk(sock->sk);
-	struct sock *sk = sock->sk;
-	struct sockaddr_qrtr *sq;
-	struct sk_buff *skb;
-	struct ifreq ifr;
-	long len = 0;
-	int rc = 0;
-
-	lock_sock(sk);
-
-	switch (cmd) {
-	case TIOCOUTQ:
-		len = sk->sk_sndbuf - sk_wmem_alloc_get(sk);
-		if (len < 0)
-			len = 0;
-		rc = put_user(len, (int __user *)argp);
-		break;
-	case TIOCINQ:
-		skb = skb_peek(&sk->sk_receive_queue);
-		if (skb)
-			len = skb->len;
-		rc = put_user(len, (int __user *)argp);
-		break;
-	case SIOCGIFADDR:
-		if (copy_from_user(&ifr, argp, sizeof(ifr))) {
-			rc = -EFAULT;
-			break;
-		}
-
-		sq = (struct sockaddr_qrtr *)&ifr.ifr_addr;
-		*sq = ipc->us;
-		if (copy_to_user(argp, &ifr, sizeof(ifr))) {
-			rc = -EFAULT;
-			break;
-		}
-		break;
-	case SIOCADDRT:
-	case SIOCDELRT:
-	case SIOCSIFADDR:
-	case SIOCGIFDSTADDR:
-	case SIOCSIFDSTADDR:
-	case SIOCGIFBRDADDR:
-	case SIOCSIFBRDADDR:
-	case SIOCGIFNETMASK:
-	case SIOCSIFNETMASK:
-		rc = -EINVAL;
-		break;
-	default:
-		rc = -ENOIOCTLCMD;
-		break;
-	}
-
-	release_sock(sk);
-
-	return rc;
-}
-
-static int qrtr_release(struct socket *sock)
-{
-	struct sock *sk = sock->sk;
-	struct qrtr_sock *ipc;
-
-	if (!sk)
-		return 0;
-
-	lock_sock(sk);
-
-	ipc = qrtr_sk(sk);
-	sk->sk_shutdown = SHUTDOWN_MASK;
-	if (!sock_flag(sk, SOCK_DEAD))
-		sk->sk_state_change(sk);
-
-	sock_set_flag(sk, SOCK_DEAD);
-	sock_orphan(sk);
-	sock->sk = NULL;
-
-	if (!sock_flag(sk, SOCK_ZAPPED))
-		qrtr_port_remove(ipc);
-
-	skb_queue_purge(&sk->sk_receive_queue);
-
-	release_sock(sk);
-	sock_put(sk);
-
-	return 0;
-}
-
-static const struct proto_ops qrtr_proto_ops = {
-	.owner		= THIS_MODULE,
-	.family		= AF_QIPCRTR,
-	.bind		= qrtr_bind,
-	.connect	= qrtr_connect,
-	.socketpair	= sock_no_socketpair,
-	.accept		= sock_no_accept,
-	.listen		= sock_no_listen,
-	.sendmsg	= qrtr_sendmsg,
-	.recvmsg	= qrtr_recvmsg,
-	.getname	= qrtr_getname,
-	.ioctl		= qrtr_ioctl,
-	.gettstamp	= sock_gettstamp,
-	.poll		= datagram_poll,
-	.shutdown	= sock_no_shutdown,
-	.release	= qrtr_release,
-	.mmap		= sock_no_mmap,
-	.sendpage	= sock_no_sendpage,
-};
-
-static struct proto qrtr_proto = {
-	.name		= "QIPCRTR",
-	.owner		= THIS_MODULE,
-	.obj_size	= sizeof(struct qrtr_sock),
-};
-
-static int qrtr_create(struct net *net, struct socket *sock,
-		       int protocol, int kern)
-{
-	struct qrtr_sock *ipc;
-	struct sock *sk;
-
-	if (sock->type != SOCK_DGRAM)
-		return -EPROTOTYPE;
-
-	sk = sk_alloc(net, AF_QIPCRTR, GFP_KERNEL, &qrtr_proto, kern);
-	if (!sk)
-		return -ENOMEM;
-
-	sock_set_flag(sk, SOCK_ZAPPED);
-
-	sock_init_data(sock, sk);
-	sock->ops = &qrtr_proto_ops;
-
-	ipc = qrtr_sk(sk);
-	ipc->us.sq_family = AF_QIPCRTR;
-	ipc->us.sq_node = qrtr_local_nid;
-	ipc->us.sq_port = 0;
-
-	return 0;
-}
-
-static const struct net_proto_family qrtr_family = {
-	.owner	= THIS_MODULE,
-	.family	= AF_QIPCRTR,
-	.create	= qrtr_create,
-};
-
-static int __init qrtr_proto_init(void)
-{
-	int rc;
-
-	rc = proto_register(&qrtr_proto, 1);
-	if (rc)
-		return rc;
-
-	rc = sock_register(&qrtr_family);
-	if (rc) {
-		proto_unregister(&qrtr_proto);
-		return rc;
-	}
-
-	qrtr_ns_init();
-
-	return rc;
-}
-postcore_initcall(qrtr_proto_init);
-
-static void __exit qrtr_proto_fini(void)
-{
-	qrtr_ns_remove();
-	sock_unregister(qrtr_family.family);
-	proto_unregister(&qrtr_proto);
-}
-module_exit(qrtr_proto_fini);
-
-MODULE_DESCRIPTION("Qualcomm IPC-router driver");
-MODULE_LICENSE("GPL v2");
-MODULE_ALIAS_NETPROTO(PF_QIPCRTR);
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index e9b4ea3d934f..3a68d65f7d15 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1831,6 +1831,10 @@ static int sctp_sendmsg_to_asoc(struct sctp_association *asoc,
 		err = sctp_wait_for_sndbuf(asoc, &timeo, msg_len);
 		if (err)
 			goto err;
+		if (unlikely(sinfo->sinfo_stream >= asoc->stream.outcnt)) {
+			err = -EINVAL;
+			goto err;
+		}
 	}
 
 	if (sctp_state(asoc, CLOSED)) {
diff --git a/net/sctp/stream_interleave.c b/net/sctp/stream_interleave.c
index 6b13f737ebf2..e3aad75cb11d 100644
--- a/net/sctp/stream_interleave.c
+++ b/net/sctp/stream_interleave.c
@@ -1162,7 +1162,8 @@ static void sctp_generate_iftsn(struct sctp_outq *q, __u32 ctsn)
 
 #define _sctp_walk_ifwdtsn(pos, chunk, end) \
 	for (pos = chunk->subh.ifwdtsn_hdr->skip; \
-	     (void *)pos < (void *)chunk->subh.ifwdtsn_hdr->skip + (end); pos++)
+	     (void *)pos <= (void *)chunk->subh.ifwdtsn_hdr->skip + (end) - \
+			    sizeof(struct sctp_ifwdtsn_skip); pos++)
 
 #define sctp_walk_ifwdtsn(pos, ch) \
 	_sctp_walk_ifwdtsn((pos), (ch), ntohs((ch)->chunk_hdr->length) - \
diff --git a/net/sunrpc/svcauth_unix.c b/net/sunrpc/svcauth_unix.c
index 97c0bddba7a3..60754a292589 100644
--- a/net/sunrpc/svcauth_unix.c
+++ b/net/sunrpc/svcauth_unix.c
@@ -424,14 +424,23 @@ static int unix_gid_hash(kuid_t uid)
 	return hash_long(from_kuid(&init_user_ns, uid), GID_HASHBITS);
 }
 
-static void unix_gid_put(struct kref *kref)
+static void unix_gid_free(struct rcu_head *rcu)
 {
-	struct cache_head *item = container_of(kref, struct cache_head, ref);
-	struct unix_gid *ug = container_of(item, struct unix_gid, h);
+	struct unix_gid *ug = container_of(rcu, struct unix_gid, rcu);
+	struct cache_head *item = &ug->h;
+
 	if (test_bit(CACHE_VALID, &item->flags) &&
 	    !test_bit(CACHE_NEGATIVE, &item->flags))
 		put_group_info(ug->gi);
-	kfree_rcu(ug, rcu);
+	kfree(ug);
+}
+
+static void unix_gid_put(struct kref *kref)
+{
+	struct cache_head *item = container_of(kref, struct cache_head, ref);
+	struct unix_gid *ug = container_of(item, struct unix_gid, h);
+
+	call_rcu(&ug->rcu, unix_gid_free);
 }
 
 static int unix_gid_match(struct cache_head *corig, struct cache_head *cnew)
diff --git a/scripts/Kconfig.include b/scripts/Kconfig.include
index a5fe72c504ff..6d37cb780452 100644
--- a/scripts/Kconfig.include
+++ b/scripts/Kconfig.include
@@ -42,6 +42,12 @@ $(error-if,$(failure,command -v $(LD)),linker '$(LD)' not found)
 # Fail if the linker is gold as it's not capable of linking the kernel proper
 $(error-if,$(success, $(LD) -v | grep -q gold), gold linker '$(LD)' not supported)
 
+# Get the assembler name, version, and error out if it is not supported.
+as-info := $(shell,$(srctree)/scripts/as-version.sh $(CC) $(CLANG_FLAGS))
+$(error-if,$(success,test -z "$(as-info)"),Sorry$(comma) this assembler is not supported.)
+as-name := $(shell,set -- $(as-info) && echo $1)
+as-version := $(shell,set -- $(as-info) && echo $2)
+
 # machine bit flags
 #  $(m32-flag): -m32 if the compiler supports it, or an empty string otherwise.
 #  $(m64-flag): -m64 if the compiler supports it, or an empty string otherwise.
diff --git a/scripts/as-version.sh b/scripts/as-version.sh
new file mode 100755
index 000000000000..532270bd4b7e
--- /dev/null
+++ b/scripts/as-version.sh
@@ -0,0 +1,69 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# Print the assembler name and its version in a 5 or 6-digit form.
+# Also, perform the minimum version check.
+# (If it is the integrated assembler, return 0 as the version, and
+# skip the version check.)
+
+set -e
+
+# Convert the version string x.y.z to a canonical 5 or 6-digit form.
+get_canonical_version()
+{
+	IFS=.
+	set -- $1
+
+	# If the 2nd or 3rd field is missing, fill it with a zero.
+	#
+	# The 4th field, if present, is ignored.
+	# This occurs in development snapshots as in 2.35.1.20201116
+	echo $((10000 * $1 + 100 * ${2:-0} + ${3:-0}))
+}
+
+# Clang fails to handle -Wa,--version unless -fno-integrated-as is given.
+# We check -fintegrated-as, expecting it is explicitly passed in for the
+# integrated assembler case.
+check_integrated_as()
+{
+	while [ $# -gt 0 ]; do
+		if [ "$1" = -fintegrated-as ]; then
+			# For the integrated assembler, we do not check the
+			# version here. It is the same as the clang version, and
+			# it has been already checked by scripts/cc-version.sh.
+			echo LLVM 0
+			exit 0
+		fi
+		shift
+	done
+}
+
+check_integrated_as "$@"
+
+orig_args="$@"
+
+# Get the first line of the --version output.
+IFS='
+'
+set -- $(LC_ALL=C "$@" -Wa,--version -c -x assembler /dev/null -o /dev/null 2>/dev/null)
+
+# Split the line on spaces.
+IFS=' '
+set -- $1
+
+if [ "$1" = GNU -a "$2" = assembler ]; then
+	shift $(($# - 1))
+	version=$1
+	name=GNU
+else
+	echo "$orig_args: unknown assembler invoked" >&2
+	exit 1
+fi
+
+# Some distributions append a package release number, as in 2.34-4.fc32
+# Trim the hyphen and any characters that follow.
+version=${version%-*}
+
+cversion=$(get_canonical_version $version)
+
+echo $name $cversion
diff --git a/scripts/dummy-tools/gcc b/scripts/dummy-tools/gcc
index 346757a87dbc..485427f40dba 100755
--- a/scripts/dummy-tools/gcc
+++ b/scripts/dummy-tools/gcc
@@ -67,6 +67,12 @@ if arg_contain -E "$@"; then
 	fi
 fi
 
+# To set CONFIG_AS_IS_GNU
+if arg_contain -Wa,--version "$@"; then
+	echo "GNU assembler (scripts/dummy-tools) 2.50"
+	exit 0
+fi
+
 if arg_contain -S "$@"; then
 	# For scripts/gcc-x86-*-has-stack-protector.sh
 	if arg_contain -fstack-protector "$@"; then
diff --git a/sound/firewire/tascam/tascam-stream.c b/sound/firewire/tascam/tascam-stream.c
index eb07e1decf9b..47de9727ac73 100644
--- a/sound/firewire/tascam/tascam-stream.c
+++ b/sound/firewire/tascam/tascam-stream.c
@@ -475,7 +475,7 @@ int snd_tscm_stream_start_duplex(struct snd_tscm *tscm, unsigned int rate)
 
 		err = amdtp_domain_start(&tscm->domain, 0);
 		if (err < 0)
-			return err;
+			goto error;
 
 		if (!amdtp_stream_wait_callback(&tscm->rx_stream,
 						CALLBACK_TIMEOUT) ||
diff --git a/sound/i2c/cs8427.c b/sound/i2c/cs8427.c
index 8634d4f466b3..e8c4c39cea12 100644
--- a/sound/i2c/cs8427.c
+++ b/sound/i2c/cs8427.c
@@ -553,10 +553,13 @@ int snd_cs8427_iec958_active(struct snd_i2c_device *cs8427, int active)
 	if (snd_BUG_ON(!cs8427))
 		return -ENXIO;
 	chip = cs8427->private_data;
-	if (active)
+	if (active) {
 		memcpy(chip->playback.pcm_status,
 		       chip->playback.def_status, 24);
-	chip->playback.pcm_ctl->vd[0].access &= ~SNDRV_CTL_ELEM_ACCESS_INACTIVE;
+		chip->playback.pcm_ctl->vd[0].access &= ~SNDRV_CTL_ELEM_ACCESS_INACTIVE;
+	} else {
+		chip->playback.pcm_ctl->vd[0].access |= SNDRV_CTL_ELEM_ACCESS_INACTIVE;
+	}
 	snd_ctl_notify(cs8427->bus->card,
 		       SNDRV_CTL_EVENT_MASK_VALUE | SNDRV_CTL_EVENT_MASK_INFO,
 		       &chip->playback.pcm_ctl->id);
diff --git a/sound/pci/emu10k1/emupcm.c b/sound/pci/emu10k1/emupcm.c
index 8d2c101d66a2..1c4388b847d1 100644
--- a/sound/pci/emu10k1/emupcm.c
+++ b/sound/pci/emu10k1/emupcm.c
@@ -1232,7 +1232,7 @@ static int snd_emu10k1_capture_mic_close(struct snd_pcm_substream *substream)
 {
 	struct snd_emu10k1 *emu = snd_pcm_substream_chip(substream);
 
-	emu->capture_interrupt = NULL;
+	emu->capture_mic_interrupt = NULL;
 	emu->pcm_capture_mic_substream = NULL;
 	return 0;
 }
@@ -1340,7 +1340,7 @@ static int snd_emu10k1_capture_efx_close(struct snd_pcm_substream *substream)
 {
 	struct snd_emu10k1 *emu = snd_pcm_substream_chip(substream);
 
-	emu->capture_interrupt = NULL;
+	emu->capture_efx_interrupt = NULL;
 	emu->pcm_capture_efx_substream = NULL;
 	return 0;
 }
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 2af9cd7b7999..18309fa17fb8 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -2632,6 +2632,7 @@ static const struct snd_pci_quirk alc882_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1462, 0xda57, "MSI Z270-Gaming", ALC1220_FIXUP_GB_DUAL_CODECS),
 	SND_PCI_QUIRK_VENDOR(0x1462, "MSI", ALC882_FIXUP_GPIO3),
 	SND_PCI_QUIRK(0x147b, 0x107a, "Abit AW9D-MAX", ALC882_FIXUP_ABIT_AW9D_MAX),
+	SND_PCI_QUIRK(0x1558, 0x3702, "Clevo X370SN[VW]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x50d3, "Clevo PC50[ER][CDF]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x65d1, "Clevo PB51[ER][CDF]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x65d2, "Clevo PB51R[CDF]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
diff --git a/sound/pci/hda/patch_sigmatel.c b/sound/pci/hda/patch_sigmatel.c
index 6fc0c4e77cd1..76c5a2b64ef5 100644
--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -1707,6 +1707,7 @@ static const struct snd_pci_quirk stac925x_fixup_tbl[] = {
 };
 
 static const struct hda_pintbl ref92hd73xx_pin_configs[] = {
+	// Port A-H
 	{ 0x0a, 0x02214030 },
 	{ 0x0b, 0x02a19040 },
 	{ 0x0c, 0x01a19020 },
@@ -1715,9 +1716,12 @@ static const struct hda_pintbl ref92hd73xx_pin_configs[] = {
 	{ 0x0f, 0x01014010 },
 	{ 0x10, 0x01014020 },
 	{ 0x11, 0x01014030 },
+	// CD in
 	{ 0x12, 0x02319040 },
+	// Digial Mic ins
 	{ 0x13, 0x90a000f0 },
 	{ 0x14, 0x90a000f0 },
+	// Digital outs
 	{ 0x22, 0x01452050 },
 	{ 0x23, 0x01452050 },
 	{}
@@ -1758,6 +1762,7 @@ static const struct hda_pintbl alienware_m17x_pin_configs[] = {
 };
 
 static const struct hda_pintbl intel_dg45id_pin_configs[] = {
+	// Analog outputs
 	{ 0x0a, 0x02214230 },
 	{ 0x0b, 0x02A19240 },
 	{ 0x0c, 0x01013214 },
@@ -1765,6 +1770,9 @@ static const struct hda_pintbl intel_dg45id_pin_configs[] = {
 	{ 0x0e, 0x01A19250 },
 	{ 0x0f, 0x01011212 },
 	{ 0x10, 0x01016211 },
+	// Digital output
+	{ 0x22, 0x01451380 },
+	{ 0x23, 0x40f000f0 },
 	{}
 };
 
@@ -1955,6 +1963,8 @@ static const struct snd_pci_quirk stac92hd73xx_fixup_tbl[] = {
 				"DFI LanParty", STAC_92HD73XX_REF),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_DFI, 0x3101,
 				"DFI LanParty", STAC_92HD73XX_REF),
+	SND_PCI_QUIRK(PCI_VENDOR_ID_INTEL, 0x5001,
+				"Intel DP45SG", STAC_92HD73XX_INTEL),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_INTEL, 0x5002,
 				"Intel DG45ID", STAC_92HD73XX_INTEL),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_INTEL, 0x5003,
diff --git a/sound/soc/codecs/hdac_hdmi.c b/sound/soc/codecs/hdac_hdmi.c
index 2c1305bf0572..6de3e47b92d8 100644
--- a/sound/soc/codecs/hdac_hdmi.c
+++ b/sound/soc/codecs/hdac_hdmi.c
@@ -436,23 +436,28 @@ static int hdac_hdmi_setup_audio_infoframe(struct hdac_device *hdev,
 	return 0;
 }
 
-static int hdac_hdmi_set_tdm_slot(struct snd_soc_dai *dai,
-		unsigned int tx_mask, unsigned int rx_mask,
-		int slots, int slot_width)
+static int hdac_hdmi_set_stream(struct snd_soc_dai *dai,
+				void *stream, int direction)
 {
 	struct hdac_hdmi_priv *hdmi = snd_soc_dai_get_drvdata(dai);
 	struct hdac_device *hdev = hdmi->hdev;
 	struct hdac_hdmi_dai_port_map *dai_map;
 	struct hdac_hdmi_pcm *pcm;
+	struct hdac_stream *hstream;
 
-	dev_dbg(&hdev->dev, "%s: strm_tag: %d\n", __func__, tx_mask);
+	if (!stream)
+		return -EINVAL;
+
+	hstream = (struct hdac_stream *)stream;
+
+	dev_dbg(&hdev->dev, "%s: strm_tag: %d\n", __func__, hstream->stream_tag);
 
 	dai_map = &hdmi->dai_map[dai->id];
 
 	pcm = hdac_hdmi_get_pcm_from_cvt(hdmi, dai_map->cvt);
 
 	if (pcm)
-		pcm->stream_tag = (tx_mask << 4);
+		pcm->stream_tag = (hstream->stream_tag << 4);
 
 	return 0;
 }
@@ -1544,7 +1549,7 @@ static const struct snd_soc_dai_ops hdmi_dai_ops = {
 	.startup = hdac_hdmi_pcm_open,
 	.shutdown = hdac_hdmi_pcm_close,
 	.hw_params = hdac_hdmi_set_hw_params,
-	.set_tdm_slot = hdac_hdmi_set_tdm_slot,
+	.set_stream = hdac_hdmi_set_stream,
 };
 
 /*
diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
index 558d34fbd331..61aa2c47fbd5 100644
--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -969,9 +969,16 @@ static void btf_dump_emit_struct_def(struct btf_dump *d,
 	if (is_struct)
 		btf_dump_emit_bit_padding(d, off, t->size * 8, align, false, lvl + 1);
 
-	if (vlen)
+	/*
+	 * Keep `struct empty {}` on a single line,
+	 * only print newline when there are regular or padding fields.
+	 */
+	if (vlen || t->size) {
 		btf_dump_printf(d, "\n");
-	btf_dump_printf(d, "%s}", pfx(lvl));
+		btf_dump_printf(d, "%s}", pfx(lvl));
+	} else {
+		btf_dump_printf(d, "}");
+	}
 	if (packed)
 		btf_dump_printf(d, " __attribute__((packed))");
 }
diff --git a/tools/testing/selftests/intel_pstate/aperf.c b/tools/testing/selftests/intel_pstate/aperf.c
index f6cd03a87493..a8acf3996973 100644
--- a/tools/testing/selftests/intel_pstate/aperf.c
+++ b/tools/testing/selftests/intel_pstate/aperf.c
@@ -10,8 +10,12 @@
 #include <sched.h>
 #include <errno.h>
 #include <string.h>
+#include <time.h>
 #include "../kselftest.h"
 
+#define MSEC_PER_SEC	1000L
+#define NSEC_PER_MSEC	1000000L
+
 void usage(char *name) {
 	printf ("Usage: %s cpunum\n", name);
 }
@@ -22,7 +26,7 @@ int main(int argc, char **argv) {
 	long long tsc, old_tsc, new_tsc;
 	long long aperf, old_aperf, new_aperf;
 	long long mperf, old_mperf, new_mperf;
-	struct timeb before, after;
+	struct timespec before, after;
 	long long int start, finish, total;
 	cpu_set_t cpuset;
 
@@ -55,7 +59,10 @@ int main(int argc, char **argv) {
 		return 1;
 	}
 
-	ftime(&before);
+	if (clock_gettime(CLOCK_MONOTONIC, &before) < 0) {
+		perror("clock_gettime");
+		return 1;
+	}
 	pread(fd, &old_tsc,  sizeof(old_tsc), 0x10);
 	pread(fd, &old_aperf,  sizeof(old_mperf), 0xe7);
 	pread(fd, &old_mperf,  sizeof(old_aperf), 0xe8);
@@ -64,7 +71,10 @@ int main(int argc, char **argv) {
 		sqrt(i);
 	}
 
-	ftime(&after);
+	if (clock_gettime(CLOCK_MONOTONIC, &after) < 0) {
+		perror("clock_gettime");
+		return 1;
+	}
 	pread(fd, &new_tsc,  sizeof(new_tsc), 0x10);
 	pread(fd, &new_aperf,  sizeof(new_mperf), 0xe7);
 	pread(fd, &new_mperf,  sizeof(new_aperf), 0xe8);
@@ -73,11 +83,11 @@ int main(int argc, char **argv) {
 	aperf = new_aperf-old_aperf;
 	mperf = new_mperf-old_mperf;
 
-	start = before.time*1000 + before.millitm;
-	finish = after.time*1000 + after.millitm;
+	start = before.tv_sec*MSEC_PER_SEC + before.tv_nsec/NSEC_PER_MSEC;
+	finish = after.tv_sec*MSEC_PER_SEC + after.tv_nsec/NSEC_PER_MSEC;
 	total = finish - start;
 
-	printf("runTime: %4.2f\n", 1.0*total/1000);
+	printf("runTime: %4.2f\n", 1.0*total/MSEC_PER_SEC);
 	printf("freq: %7.0f\n", tsc / (1.0*aperf / (1.0 * mperf)) / total);
 	return 0;
 }
