Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AABA452647B
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 16:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349969AbiEMOcu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 10:32:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352782AbiEMOba (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 10:31:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32CDD1B0929;
        Fri, 13 May 2022 07:29:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C134C62153;
        Fri, 13 May 2022 14:29:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 315ACC34100;
        Fri, 13 May 2022 14:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652452153;
        bh=NZYCTgSa5rYe0Xq/7j2xCZxXEpq7IUeSinHuJIj0uEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dsz2l+mnPpCPswwuRVeRJrtCkaZOHlsEkFRbvohiLMI3sZDORKc1SDaZK6DL2v5jS
         pN1+wD7O2MO9zCPVPyTU5PUe4ry6O8ZPC5Jm8MbJj2UGoQ1RH26cLR01kkx02kB0SF
         MQxnPmJ2bjkKk4+kpG8tsNpP6V92R247ogamWaeE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Huang, Ying" <ying.huang@intel.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Zi Yan <ziy@nvidia.com>, Oscar Salvador <osalvador@suse.de>,
        Yang Shi <shy828301@gmail.com>,
        zhongjiang-ali <zhongjiang-ali@linux.alibaba.com>,
        Xunlei Pang <xlpang@linux.alibaba.com>,
        Mel Gorman <mgorman@techsingularity.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.17 11/12] mm,migrate: fix establishing demotion target
Date:   Fri, 13 May 2022 16:24:11 +0200
Message-Id: <20220513142228.985137985@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220513142228.651822943@linuxfoundation.org>
References: <20220513142228.651822943@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
 mm/migrate.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -3085,18 +3085,21 @@ static int establish_migrate_target(int
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


