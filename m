Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F79A6AA1AD
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 22:42:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232100AbjCCVmC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 16:42:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232019AbjCCVli (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 16:41:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9625D637F2;
        Fri,  3 Mar 2023 13:41:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2DE346190F;
        Fri,  3 Mar 2023 21:41:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C2EAC433EF;
        Fri,  3 Mar 2023 21:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677879686;
        bh=28+v0AZXtdLnjA1qVQTal/PjRTzRuO/Je+nT+ocQfY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VOja8Bq5Pnh3ryf9S7vYIsZI01JSuCPbr+S4LwW4PF4zSTRsaV4r26jcvzoMLDgA6
         gTUZmWnkh2nOCP2pAmwetAdGTE713vtB29WoACndMAmGVXTfzq8LghNhAY4ygmQNzs
         1lxMWlyjiJ4AeJDR+MACs02yNhTJfJ/ExYn9DWMUmHzqm+9Wm9WlKDTxJE7lEUUi2d
         vb7azBXcYxm6GSOHaFxcbC3tI2KKlQtJZq9/K4SIZ99/2NntWvpxeuM40COKqzNnUq
         1jN9cj+S0ykwzpi9ZPsz2gLRs9Q96/Y7nr2jPjQ0WUM1gbqxe3gc8eZ3hJKom1SK9u
         l2e04xMLg7Kjw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yong-Xuan Wang <yongxuan.wang@sifive.com>,
        Pierre Gondois <pierre.gondois@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>, gregkh@linuxfoundation.org
Subject: [PATCH AUTOSEL 6.2 11/64] cacheinfo: Fix shared_cpu_map to handle shared caches at different levels
Date:   Fri,  3 Mar 2023 16:40:13 -0500
Message-Id: <20230303214106.1446460-11-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230303214106.1446460-1-sashal@kernel.org>
References: <20230303214106.1446460-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yong-Xuan Wang <yongxuan.wang@sifive.com>

[ Upstream commit 198102c9103fc78d8478495971947af77edb05c1 ]

The cacheinfo sets up the shared_cpu_map by checking whether the caches
with the same index are shared between CPUs. However, this will trigger
slab-out-of-bounds access if the CPUs do not have the same cache hierarchy.
Another problem is the mismatched shared_cpu_map when the shared cache does
not have the same index between CPUs.

CPU0	I	D	L3
index	0	1	2	x
	^	^	^	^
index	0	1	2	3
CPU1	I	D	L2	L3

This patch checks each cache is shared with all caches on other CPUs.

Reviewed-by: Pierre Gondois <pierre.gondois@arm.com>
Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
Link: https://lore.kernel.org/r/20230117105133.4445-2-yongxuan.wang@sifive.com
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/cacheinfo.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/base/cacheinfo.c b/drivers/base/cacheinfo.c
index 950b22cdb5f7c..f05acf3c16c6b 100644
--- a/drivers/base/cacheinfo.c
+++ b/drivers/base/cacheinfo.c
@@ -256,7 +256,7 @@ static int cache_shared_cpu_map_setup(unsigned int cpu)
 {
 	struct cpu_cacheinfo *this_cpu_ci = get_cpu_cacheinfo(cpu);
 	struct cacheinfo *this_leaf, *sib_leaf;
-	unsigned int index;
+	unsigned int index, sib_index;
 	int ret = 0;
 
 	if (this_cpu_ci->cpu_map_populated)
@@ -284,11 +284,13 @@ static int cache_shared_cpu_map_setup(unsigned int cpu)
 
 			if (i == cpu || !sib_cpu_ci->info_list)
 				continue;/* skip if itself or no cacheinfo */
-
-			sib_leaf = per_cpu_cacheinfo_idx(i, index);
-			if (cache_leaves_are_shared(this_leaf, sib_leaf)) {
-				cpumask_set_cpu(cpu, &sib_leaf->shared_cpu_map);
-				cpumask_set_cpu(i, &this_leaf->shared_cpu_map);
+			for (sib_index = 0; sib_index < cache_leaves(i); sib_index++) {
+				sib_leaf = per_cpu_cacheinfo_idx(i, sib_index);
+				if (cache_leaves_are_shared(this_leaf, sib_leaf)) {
+					cpumask_set_cpu(cpu, &sib_leaf->shared_cpu_map);
+					cpumask_set_cpu(i, &this_leaf->shared_cpu_map);
+					break;
+				}
 			}
 		}
 		/* record the maximum cache line size */
@@ -302,7 +304,7 @@ static int cache_shared_cpu_map_setup(unsigned int cpu)
 static void cache_shared_cpu_map_remove(unsigned int cpu)
 {
 	struct cacheinfo *this_leaf, *sib_leaf;
-	unsigned int sibling, index;
+	unsigned int sibling, index, sib_index;
 
 	for (index = 0; index < cache_leaves(cpu); index++) {
 		this_leaf = per_cpu_cacheinfo_idx(cpu, index);
@@ -313,9 +315,14 @@ static void cache_shared_cpu_map_remove(unsigned int cpu)
 			if (sibling == cpu || !sib_cpu_ci->info_list)
 				continue;/* skip if itself or no cacheinfo */
 
-			sib_leaf = per_cpu_cacheinfo_idx(sibling, index);
-			cpumask_clear_cpu(cpu, &sib_leaf->shared_cpu_map);
-			cpumask_clear_cpu(sibling, &this_leaf->shared_cpu_map);
+			for (sib_index = 0; sib_index < cache_leaves(sibling); sib_index++) {
+				sib_leaf = per_cpu_cacheinfo_idx(sibling, sib_index);
+				if (cache_leaves_are_shared(this_leaf, sib_leaf)) {
+					cpumask_clear_cpu(cpu, &sib_leaf->shared_cpu_map);
+					cpumask_clear_cpu(sibling, &this_leaf->shared_cpu_map);
+					break;
+				}
+			}
 		}
 	}
 }
-- 
2.39.2

