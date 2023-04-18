Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B84676E62E4
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231715AbjDRMgY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:36:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231721AbjDRMgX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:36:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6114A12C82
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:36:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F06AF63291
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:36:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 105A1C433EF;
        Tue, 18 Apr 2023 12:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821377;
        bh=i6HxBiD9/LXxNfA/AN22gQPCf9PxocqiN7cRdN03i8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UpZ9layBoTPMjkOtX14FfwxUTDwEWMratLGwTOulaFjtpP9YcM5ilQWjta5VRi+cH
         yf6CgamhtzToGXDxeSF0+GqLqOxzIumgMeANZbIzoXyB1pfL0Rqu7xrYsJ/WIf+mdN
         /NYiOpXV09o2EVOmJVqjiHTIkvOTTFFbb8Muhn5A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 104/124] powerpc/pseries: Add a helper for form1 cpu distance
Date:   Tue, 18 Apr 2023 14:22:03 +0200
Message-Id: <20230418120313.608633993@linuxfoundation.org>
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

[ Upstream commit ef31cb83d19c4c589d650747cd5a7e502be9f665 ]

This helper is only used with the dispatch trace log collection.
A later patch will add Form2 affinity support and this change helps
in keeping that simpler. Also add a comment explaining we don't expect
the code to be called with FORM0

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Reviewed-by: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210812132223.225214-5-aneesh.kumar@linux.ibm.com
Stable-dep-of: b277fc793daf ("powerpc/papr_scm: Update the NUMA distance table for the target node")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/topology.h   |  4 ++--
 arch/powerpc/mm/numa.c                | 10 +++++++++-
 arch/powerpc/platforms/pseries/lpar.c |  4 ++--
 3 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/include/asm/topology.h b/arch/powerpc/include/asm/topology.h
index 1604920d8d2de..b239ef589ae06 100644
--- a/arch/powerpc/include/asm/topology.h
+++ b/arch/powerpc/include/asm/topology.h
@@ -36,7 +36,7 @@ static inline int pcibus_to_node(struct pci_bus *bus)
 				 cpu_all_mask :				\
 				 cpumask_of_node(pcibus_to_node(bus)))
 
-extern int cpu_distance(__be32 *cpu1_assoc, __be32 *cpu2_assoc);
+int cpu_relative_distance(__be32 *cpu1_assoc, __be32 *cpu2_assoc);
 extern int __node_distance(int, int);
 #define node_distance(a, b) __node_distance(a, b)
 
@@ -84,7 +84,7 @@ static inline void sysfs_remove_device_from_node(struct device *dev,
 
 static inline void update_numa_cpu_lookup_table(unsigned int cpu, int node) {}
 
-static inline int cpu_distance(__be32 *cpu1_assoc, __be32 *cpu2_assoc)
+static inline int cpu_relative_distance(__be32 *cpu1_assoc, __be32 *cpu2_assoc)
 {
 	return 0;
 }
diff --git a/arch/powerpc/mm/numa.c b/arch/powerpc/mm/numa.c
index e61593ae25c9e..010476abec344 100644
--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -166,7 +166,7 @@ static void unmap_cpu_from_node(unsigned long cpu)
 }
 #endif /* CONFIG_HOTPLUG_CPU || CONFIG_PPC_SPLPAR */
 
-int cpu_distance(__be32 *cpu1_assoc, __be32 *cpu2_assoc)
+static int __cpu_form1_relative_distance(__be32 *cpu1_assoc, __be32 *cpu2_assoc)
 {
 	int dist = 0;
 
@@ -182,6 +182,14 @@ int cpu_distance(__be32 *cpu1_assoc, __be32 *cpu2_assoc)
 	return dist;
 }
 
+int cpu_relative_distance(__be32 *cpu1_assoc, __be32 *cpu2_assoc)
+{
+	/* We should not get called with FORM0 */
+	VM_WARN_ON(affinity_form == FORM0_AFFINITY);
+
+	return __cpu_form1_relative_distance(cpu1_assoc, cpu2_assoc);
+}
+
 /* must hold reference to node during call */
 static const __be32 *of_get_associativity(struct device_node *dev)
 {
diff --git a/arch/powerpc/platforms/pseries/lpar.c b/arch/powerpc/platforms/pseries/lpar.c
index 115d196560b8b..28396a7e77d6f 100644
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
-- 
2.39.2



