Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFF9640E271
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:16:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243183AbhIPQiN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:38:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:45392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243221AbhIPQgF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:36:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 06D8A6138D;
        Thu, 16 Sep 2021 16:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809301;
        bh=+Ykzp3S/c4i5bfjmtv1I9kQLib6/o3VBcPl3qIbBJKM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zdLkgcLa9clv4OtqC512YT0UPiz29fOnmofA4sXJ+aJm5us+1NJpl0pOme4Wox2JH
         /D8rDpcO4LmdVzl5ZVMQPiQbd0k7KyjPeZz0s63GXdJF9wK7MmSSpdDhop4mc5iMY5
         991UMc1KGssV8HzpZR4SEskIK3+E7/d+1Drxp+Ms=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Laurent Dufour <ldufour@linux.ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 103/380] powerpc/numa: Consider the max NUMA node for migratable LPAR
Date:   Thu, 16 Sep 2021 17:57:40 +0200
Message-Id: <20210916155807.536607599@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurent Dufour <ldufour@linux.ibm.com>

[ Upstream commit 9c7248bb8de31f51c693bfa6a6ea53b1c07e0fa8 ]

When a LPAR is migratable, we should consider the maximum possible NUMA
node instead of the number of NUMA nodes from the actual system.

The DT property 'ibm,current-associativity-domains' defines the maximum
number of nodes the LPAR can see when running on that box. But if the
LPAR is being migrated on another box, it may see up to the nodes
defined by 'ibm,max-associativity-domains'. So if a LPAR is migratable,
that value should be used.

Unfortunately, there is no easy way to know if an LPAR is migratable or
not. The hypervisor exports the property 'ibm,migratable-partition' in
the case it set to migrate partition, but that would not mean that the
current partition is migratable.

Without this patch, when a LPAR is started on a 2 node box and then
migrated to a 3 node box, the hypervisor may spread the LPAR's CPUs on
the 3rd node. In that case if a CPU from that 3rd node is added to the
LPAR, it will be wrongly assigned to the node because the kernel has
been set to use up to 2 nodes (the configuration of the departure node).
With this patch applies, the CPU is correctly added to the 3rd node.

Fixes: f9f130ff2ec9 ("powerpc/numa: Detect support for coregroup")
Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>
Reviewed-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210511073136.17795-1-ldufour@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/mm/numa.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/mm/numa.c b/arch/powerpc/mm/numa.c
index f2bf98bdcea2..094a1076fd1f 100644
--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -893,7 +893,7 @@ static void __init setup_node_data(int nid, u64 start_pfn, u64 end_pfn)
 static void __init find_possible_nodes(void)
 {
 	struct device_node *rtas;
-	const __be32 *domains;
+	const __be32 *domains = NULL;
 	int prop_length, max_nodes;
 	u32 i;
 
@@ -909,9 +909,14 @@ static void __init find_possible_nodes(void)
 	 * it doesn't exist, then fallback on ibm,max-associativity-domains.
 	 * Current denotes what the platform can support compared to max
 	 * which denotes what the Hypervisor can support.
+	 *
+	 * If the LPAR is migratable, new nodes might be activated after a LPM,
+	 * so we should consider the max number in that case.
 	 */
-	domains = of_get_property(rtas, "ibm,current-associativity-domains",
-					&prop_length);
+	if (!of_get_property(of_root, "ibm,migratable-partition", NULL))
+		domains = of_get_property(rtas,
+					  "ibm,current-associativity-domains",
+					  &prop_length);
 	if (!domains) {
 		domains = of_get_property(rtas, "ibm,max-associativity-domains",
 					&prop_length);
@@ -920,6 +925,8 @@ static void __init find_possible_nodes(void)
 	}
 
 	max_nodes = of_read_number(&domains[min_common_depth], 1);
+	pr_info("Partition configured for %d NUMA nodes.\n", max_nodes);
+
 	for (i = 0; i < max_nodes; i++) {
 		if (!node_possible(i))
 			node_set(i, node_possible_map);
-- 
2.30.2



