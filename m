Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2532B401324
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 03:24:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238980AbhIFBYU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 21:24:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:39168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239545AbhIFBXC (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Sep 2021 21:23:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F14061103;
        Mon,  6 Sep 2021 01:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891288;
        bh=rb5C6WW6/bDKVBxPuN9QOIOw1p0aMDU2t+VfplnDPdM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hh57jr3FDZ9g7fRGuwxW8ADZVu9+v1rZGigIyvEPqfOiw7SochdTetkEDZLfWdoRR
         2uumf9a4KJqY/HGV5GfudLp9MxMAx8W3WFzUiKTrMTfZKMH5SzNkbGUMOLk+9231/R
         iTTlf36CW2VTMNsc4+V+ya9javr75i6yDWPPExxJMsGpIPz/YUwejkOnc22bucRuTk
         vp2nk6h2hh88FL3v93c2l6U5Jo65M9pNf4FmyRBdhwBe2FKu8f/Dg3436o19UTUqPV
         vPRncepQ0fF9OLu3Vvt8VTe2t+rBp26pXnk7YAhXT0WYJ+CdmDdH7rZMwfJ0/aVCdi
         FDQ1EiJXnYJ1Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Valentin Schneider <valentin.schneider@arm.com>,
        Geetika Moolchandani <Geetika.Moolchandani1@ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.13 28/46] sched/topology: Skip updating masks for non-online nodes
Date:   Sun,  5 Sep 2021 21:20:33 -0400
Message-Id: <20210906012052.929174-28-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210906012052.929174-1-sashal@kernel.org>
References: <20210906012052.929174-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Valentin Schneider <valentin.schneider@arm.com>

[ Upstream commit 0083242c93759dde353a963a90cb351c5c283379 ]

The scheduler currently expects NUMA node distances to be stable from
init onwards, and as a consequence builds the related data structures
once-and-for-all at init (see sched_init_numa()).

Unfortunately, on some architectures node distance is unreliable for
offline nodes and may very well change upon onlining.

Skip over offline nodes during sched_init_numa(). Track nodes that have
been onlined at least once, and trigger a build of a node's NUMA masks
when it is first onlined post-init.

Reported-by: Geetika Moolchandani <Geetika.Moolchandani1@ibm.com>
Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Valentin Schneider <valentin.schneider@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20210818074333.48645-1-srikar@linux.vnet.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/topology.c | 65 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 65 insertions(+)

diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index 55a0a243e871..41f778f3db05 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -1372,6 +1372,8 @@ int				sched_max_numa_distance;
 static int			*sched_domains_numa_distance;
 static struct cpumask		***sched_domains_numa_masks;
 int __read_mostly		node_reclaim_distance = RECLAIM_DISTANCE;
+
+static unsigned long __read_mostly *sched_numa_onlined_nodes;
 #endif
 
 /*
@@ -1719,6 +1721,16 @@ void sched_init_numa(void)
 			sched_domains_numa_masks[i][j] = mask;
 
 			for_each_node(k) {
+				/*
+				 * Distance information can be unreliable for
+				 * offline nodes, defer building the node
+				 * masks to its bringup.
+				 * This relies on all unique distance values
+				 * still being visible at init time.
+				 */
+				if (!node_online(j))
+					continue;
+
 				if (sched_debug() && (node_distance(j, k) != node_distance(k, j)))
 					sched_numa_warn("Node-distance not symmetric");
 
@@ -1772,6 +1784,53 @@ void sched_init_numa(void)
 	sched_max_numa_distance = sched_domains_numa_distance[nr_levels - 1];
 
 	init_numa_topology_type();
+
+	sched_numa_onlined_nodes = bitmap_alloc(nr_node_ids, GFP_KERNEL);
+	if (!sched_numa_onlined_nodes)
+		return;
+
+	bitmap_zero(sched_numa_onlined_nodes, nr_node_ids);
+	for_each_online_node(i)
+		bitmap_set(sched_numa_onlined_nodes, i, 1);
+}
+
+static void __sched_domains_numa_masks_set(unsigned int node)
+{
+	int i, j;
+
+	/*
+	 * NUMA masks are not built for offline nodes in sched_init_numa().
+	 * Thus, when a CPU of a never-onlined-before node gets plugged in,
+	 * adding that new CPU to the right NUMA masks is not sufficient: the
+	 * masks of that CPU's node must also be updated.
+	 */
+	if (test_bit(node, sched_numa_onlined_nodes))
+		return;
+
+	bitmap_set(sched_numa_onlined_nodes, node, 1);
+
+	for (i = 0; i < sched_domains_numa_levels; i++) {
+		for (j = 0; j < nr_node_ids; j++) {
+			if (!node_online(j) || node == j)
+				continue;
+
+			if (node_distance(j, node) > sched_domains_numa_distance[i])
+				continue;
+
+			/* Add remote nodes in our masks */
+			cpumask_or(sched_domains_numa_masks[i][node],
+				   sched_domains_numa_masks[i][node],
+				   sched_domains_numa_masks[0][j]);
+		}
+	}
+
+	/*
+	 * A new node has been brought up, potentially changing the topology
+	 * classification.
+	 *
+	 * Note that this is racy vs any use of sched_numa_topology_type :/
+	 */
+	init_numa_topology_type();
 }
 
 void sched_domains_numa_masks_set(unsigned int cpu)
@@ -1779,8 +1838,14 @@ void sched_domains_numa_masks_set(unsigned int cpu)
 	int node = cpu_to_node(cpu);
 	int i, j;
 
+	__sched_domains_numa_masks_set(node);
+
 	for (i = 0; i < sched_domains_numa_levels; i++) {
 		for (j = 0; j < nr_node_ids; j++) {
+			if (!node_online(j))
+				continue;
+
+			/* Set ourselves in the remote node's masks */
 			if (node_distance(j, node) <= sched_domains_numa_distance[i])
 				cpumask_set_cpu(cpu, sched_domains_numa_masks[i][j]);
 		}
-- 
2.30.2

