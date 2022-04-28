Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 371AA5138D8
	for <lists+stable@lfdr.de>; Thu, 28 Apr 2022 17:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349411AbiD1Pp7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Apr 2022 11:45:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349433AbiD1Ppx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Apr 2022 11:45:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70B17B820D;
        Thu, 28 Apr 2022 08:42:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E661B61FCF;
        Thu, 28 Apr 2022 15:42:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C22CAC385A0;
        Thu, 28 Apr 2022 15:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651160556;
        bh=HsbSG3CAnlJ/cEIDeoisNp5iwOSsom+ptW9Us2eqOLs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lvtjL7OoWKYGYZu5yPfrNUT5XoOWuWi6TJGPs3ijLwYyRolb0/fDrLLIGvAM/rLXB
         ui9VdXpOwMZblhcvzIMnj+CGmotU8NPH9kdWuhhgawLTtg7jnGrmADUKm1FH501Yqr
         k0FfXv2zf6IllzWN60/WKjB13/GCM746mcDf5DxY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Huang Ying <ying.huang@intel.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Zi Yan <ziy@nvidia.com>, Oscar Salvador <osalvador@suse.de>,
        Yang Shi <shy828301@gmail.com>,
        zhongjiang-ali <zhongjiang-ali@linux.alibaba.com>,
        Xunlei Pang <xlpang@linux.alibaba.com>,
        Mel Gorman <mgorman@techsingularity.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH AUTOSEL 11/14] mm,migrate: fix establishing demotion target
Date:   Thu, 28 Apr 2022 17:42:19 +0200
Message-Id: <20220428154222.1230793-11-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220428154222.1230793-1-gregkh@linuxfoundation.org>
References: <20220428154222.1230793-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3098; i=gregkh@linuxfoundation.org; h=from:subject; bh=2ZV8t8XlvoZw7kzU/r+KeXZFYrnKitmm6D3IvWd8z4w=; b=owGbwMvMwCRo6H6F97bub03G02pJDElZW+8tsKhKk3/AviXlrpfnjq+9T4uDun7d5lnN8OBB1qEX RtV+HbEsDIJMDLJiiixftvEc3V9xSNHL0PY0zBxWJpAhDFycAjCRLxEMc7ijBSZXrGCwKPq7yH/C6m UlOj+mKTAsWOJ+MmKixPEmmTbxWSVKYccNnq4+CQA=
X-Developer-Key: i=gregkh@linuxfoundation.org; a=openpgp; fpr=F4B60CC5BF78C2214A313DCB3147D40DDB2DFB29
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huang Ying <ying.huang@intel.com>

commit fc89213a636c3735eb3386f10a34c082271b4192 upstream.

In commit ac16ec835314 ("mm: migrate: support multiple target nodes
demotion"), after the first demotion target node is found, we will
continue to check the next candidate obtained via find_next_best_node().
This is to find all demotion target nodes with same NUMA distance.  But
one side effect of find_next_best_node() is that the candidate node
returned will be set in "used" parameter, even if the candidate node isn't
passed in the following NUMA distance checking, the candidate node will
not be used as demotion target node for the following nodes.  For example,
for system as follows,

node distances:
node   0   1   2   3
  0:  10  21  17  28
  1:  21  10  28  17
  2:  17  28  10  28
  3:  28  17  28  10

when we establish demotion target node for node 0, in the first round node
2 is added to the demotion target node set.  Then in the second round,
node 3 is checked and failed because distance(0, 3) > distance(0, 2).  But
node 3 is set in "used" nodemask too.  When we establish demotion target
node for node 1, there is no available node.  This is wrong, node 3 should
be set as the demotion target of node 1.

To fix this, if the candidate node is failed to pass the distance
checking, it will be cleared in "used" nodemask.  So that it can be used
for the following node.

The bug can be reproduced and fixed with this patch on a 2 socket server
machine with DRAM and PMEM.

Link: https://lkml.kernel.org/r/20220128055940.1792614-1-ying.huang@intel.com
Fixes: ac16ec835314 ("mm: migrate: support multiple target nodes demotion")
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Yang Shi <shy828301@gmail.com>
Cc: zhongjiang-ali <zhongjiang-ali@linux.alibaba.com>
Cc: Xunlei Pang <xlpang@linux.alibaba.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/migrate.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index fc0e14ecd42a..ac7673e43dda 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -3085,18 +3085,21 @@ static int establish_migrate_target(int node, nodemask_t *used,
 	if (best_distance != -1) {
 		val = node_distance(node, migration_target);
 		if (val > best_distance)
-			return NUMA_NO_NODE;
+			goto out_clear;
 	}
 
 	index = nd->nr;
 	if (WARN_ONCE(index >= DEMOTION_TARGET_NODES,
 		      "Exceeds maximum demotion target nodes\n"))
-		return NUMA_NO_NODE;
+		goto out_clear;
 
 	nd->nodes[index] = migration_target;
 	nd->nr++;
 
 	return migration_target;
+out_clear:
+	node_clear(migration_target, *used);
+	return NUMA_NO_NODE;
 }
 
 /*
-- 
2.36.0

