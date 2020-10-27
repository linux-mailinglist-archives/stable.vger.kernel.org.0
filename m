Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25E7029B677
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:31:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1796824AbgJ0PUB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:20:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:60560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1796131AbgJ0PT7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:19:59 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14CD921527;
        Tue, 27 Oct 2020 15:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811997;
        bh=rLlQ/65Wbn4kCW5kCjELKYW2A5VJIWr9VAOSkskIb04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P68Zp8FjeX8XR3QVOrcOLl2udygBa902KP8iJVSasYtOv2Sk9O2fTKLXuEKwC6pIJ
         2PoVfKWfxMo9SkgufikgxthvYvp/ClueH5G1YvK2bB58zEfSdZnmFV5wGQ3rjpJKM1
         y1IXuH+xs674+6rzhGDruuK+An/0loYsXblvhsKM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juri Lelli <jlelli@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 057/757] net: openvswitch: fix to make sure flow_lookup() is not preempted
Date:   Tue, 27 Oct 2020 14:45:07 +0100
Message-Id: <20201027135453.227917833@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eelco Chaudron <echaudro@redhat.com>

[ Upstream commit f981fc3d515a588c389242b7e3a71487b40571a5 ]

The flow_lookup() function uses per CPU variables, which must be called
with BH disabled. However, this is fine in the general NAPI use case
where the local BH is disabled. But, it's also called from the netlink
context. The below patch makes sure that even in the netlink path, the
BH is disabled.

In addition, u64_stats_update_begin() requires a lock to ensure one writer
which is not ensured here. Making it per-CPU and disabling NAPI (softirq)
ensures that there is always only one writer.

Fixes: eac87c413bf9 ("net: openvswitch: reorder masks array based on usage")
Reported-by: Juri Lelli <jlelli@redhat.com>
Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
Link: https://lore.kernel.org/r/160295903253.7789.826736662555102345.stgit@ebuild
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/openvswitch/flow_table.c |   58 +++++++++++++++++++++++++------------------
 net/openvswitch/flow_table.h |    8 ++++-
 2 files changed, 41 insertions(+), 25 deletions(-)

--- a/net/openvswitch/flow_table.c
+++ b/net/openvswitch/flow_table.c
@@ -172,7 +172,7 @@ static struct table_instance *table_inst
 
 static void __mask_array_destroy(struct mask_array *ma)
 {
-	free_percpu(ma->masks_usage_cntr);
+	free_percpu(ma->masks_usage_stats);
 	kfree(ma);
 }
 
@@ -196,15 +196,15 @@ static void tbl_mask_array_reset_counter
 		ma->masks_usage_zero_cntr[i] = 0;
 
 		for_each_possible_cpu(cpu) {
-			u64 *usage_counters = per_cpu_ptr(ma->masks_usage_cntr,
-							  cpu);
+			struct mask_array_stats *stats;
 			unsigned int start;
 			u64 counter;
 
+			stats = per_cpu_ptr(ma->masks_usage_stats, cpu);
 			do {
-				start = u64_stats_fetch_begin_irq(&ma->syncp);
-				counter = usage_counters[i];
-			} while (u64_stats_fetch_retry_irq(&ma->syncp, start));
+				start = u64_stats_fetch_begin_irq(&stats->syncp);
+				counter = stats->usage_cntrs[i];
+			} while (u64_stats_fetch_retry_irq(&stats->syncp, start));
 
 			ma->masks_usage_zero_cntr[i] += counter;
 		}
@@ -227,9 +227,10 @@ static struct mask_array *tbl_mask_array
 					     sizeof(struct sw_flow_mask *) *
 					     size);
 
-	new->masks_usage_cntr = __alloc_percpu(sizeof(u64) * size,
-					       __alignof__(u64));
-	if (!new->masks_usage_cntr) {
+	new->masks_usage_stats = __alloc_percpu(sizeof(struct mask_array_stats) +
+						sizeof(u64) * size,
+						__alignof__(u64));
+	if (!new->masks_usage_stats) {
 		kfree(new);
 		return NULL;
 	}
@@ -723,6 +724,8 @@ static struct sw_flow *masked_flow_looku
 
 /* Flow lookup does full lookup on flow table. It starts with
  * mask from index passed in *index.
+ * This function MUST be called with BH disabled due to the use
+ * of CPU specific variables.
  */
 static struct sw_flow *flow_lookup(struct flow_table *tbl,
 				   struct table_instance *ti,
@@ -732,7 +735,7 @@ static struct sw_flow *flow_lookup(struc
 				   u32 *n_cache_hit,
 				   u32 *index)
 {
-	u64 *usage_counters = this_cpu_ptr(ma->masks_usage_cntr);
+	struct mask_array_stats *stats = this_cpu_ptr(ma->masks_usage_stats);
 	struct sw_flow *flow;
 	struct sw_flow_mask *mask;
 	int i;
@@ -742,9 +745,9 @@ static struct sw_flow *flow_lookup(struc
 		if (mask) {
 			flow = masked_flow_lookup(ti, key, mask, n_mask_hit);
 			if (flow) {
-				u64_stats_update_begin(&ma->syncp);
-				usage_counters[*index]++;
-				u64_stats_update_end(&ma->syncp);
+				u64_stats_update_begin(&stats->syncp);
+				stats->usage_cntrs[*index]++;
+				u64_stats_update_end(&stats->syncp);
 				(*n_cache_hit)++;
 				return flow;
 			}
@@ -763,9 +766,9 @@ static struct sw_flow *flow_lookup(struc
 		flow = masked_flow_lookup(ti, key, mask, n_mask_hit);
 		if (flow) { /* Found */
 			*index = i;
-			u64_stats_update_begin(&ma->syncp);
-			usage_counters[*index]++;
-			u64_stats_update_end(&ma->syncp);
+			u64_stats_update_begin(&stats->syncp);
+			stats->usage_cntrs[*index]++;
+			u64_stats_update_end(&stats->syncp);
 			return flow;
 		}
 	}
@@ -851,9 +854,17 @@ struct sw_flow *ovs_flow_tbl_lookup(stru
 	struct mask_array *ma = rcu_dereference_ovsl(tbl->mask_array);
 	u32 __always_unused n_mask_hit;
 	u32 __always_unused n_cache_hit;
+	struct sw_flow *flow;
 	u32 index = 0;
 
-	return flow_lookup(tbl, ti, ma, key, &n_mask_hit, &n_cache_hit, &index);
+	/* This function gets called trough the netlink interface and therefore
+	 * is preemptible. However, flow_lookup() function needs to be called
+	 * with BH disabled due to CPU specific variables.
+	 */
+	local_bh_disable();
+	flow = flow_lookup(tbl, ti, ma, key, &n_mask_hit, &n_cache_hit, &index);
+	local_bh_enable();
+	return flow;
 }
 
 struct sw_flow *ovs_flow_tbl_lookup_exact(struct flow_table *tbl,
@@ -1109,7 +1120,6 @@ void ovs_flow_masks_rebalance(struct flo
 
 	for (i = 0; i < ma->max; i++)  {
 		struct sw_flow_mask *mask;
-		unsigned int start;
 		int cpu;
 
 		mask = rcu_dereference_ovsl(ma->masks[i]);
@@ -1120,14 +1130,16 @@ void ovs_flow_masks_rebalance(struct flo
 		masks_and_count[i].counter = 0;
 
 		for_each_possible_cpu(cpu) {
-			u64 *usage_counters = per_cpu_ptr(ma->masks_usage_cntr,
-							  cpu);
+			struct mask_array_stats *stats;
+			unsigned int start;
 			u64 counter;
 
+			stats = per_cpu_ptr(ma->masks_usage_stats, cpu);
 			do {
-				start = u64_stats_fetch_begin_irq(&ma->syncp);
-				counter = usage_counters[i];
-			} while (u64_stats_fetch_retry_irq(&ma->syncp, start));
+				start = u64_stats_fetch_begin_irq(&stats->syncp);
+				counter = stats->usage_cntrs[i];
+			} while (u64_stats_fetch_retry_irq(&stats->syncp,
+							   start));
 
 			masks_and_count[i].counter += counter;
 		}
--- a/net/openvswitch/flow_table.h
+++ b/net/openvswitch/flow_table.h
@@ -38,12 +38,16 @@ struct mask_count {
 	u64 counter;
 };
 
+struct mask_array_stats {
+	struct u64_stats_sync syncp;
+	u64 usage_cntrs[];
+};
+
 struct mask_array {
 	struct rcu_head rcu;
 	int count, max;
-	u64 __percpu *masks_usage_cntr;
+	struct mask_array_stats __percpu *masks_usage_stats;
 	u64 *masks_usage_zero_cntr;
-	struct u64_stats_sync syncp;
 	struct sw_flow_mask __rcu *masks[];
 };
 


