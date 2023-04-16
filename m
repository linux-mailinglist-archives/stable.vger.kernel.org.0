Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B75846E3AC1
	for <lists+stable@lfdr.de>; Sun, 16 Apr 2023 19:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbjDPRm2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Apr 2023 13:42:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbjDPRmK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Apr 2023 13:42:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9A193A9C;
        Sun, 16 Apr 2023 10:42:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB22C61C43;
        Sun, 16 Apr 2023 17:42:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DDAEC433EF;
        Sun, 16 Apr 2023 17:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681666924;
        bh=wEO6UviCh7NVVm0cGNKFVWpO5B+A/QteLLkrZjMSb2s=;
        h=Date:To:From:Subject:From;
        b=byJyC1RwoxOwTWT1VyGr36++3OtaupzT3xXWZc6RTEMcHI3U9JGKh2flwrLj2y8QN
         MbRH2oaeIgJbj2eqr0Ix0nU+xbTcQv53eUHHBeIoK7eNneTYZy58urEUJoMOvydUi4
         K2DWnTvPqUUP2kPjzmMlS2n4+ejglkWD1crVkrk0=
Date:   Sun, 16 Apr 2023 10:42:03 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        Liam.Howlett@oracle.com, zhangpeng.00@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maple_tree-fix-a-potential-memory-leak-oob-access-or-other-unpredictable-bug.patch removed from -mm tree
Message-Id: <20230416174204.2DDAEC433EF@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: fix a potential memory leak, OOB access, or other unpredictable bug
has been removed from the -mm tree.  Its filename was
     maple_tree-fix-a-potential-memory-leak-oob-access-or-other-unpredictable-bug.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peng Zhang <zhangpeng.00@bytedance.com>
Subject: maple_tree: fix a potential memory leak, OOB access, or other unpredictable bug
Date: Tue, 11 Apr 2023 12:10:04 +0800

In mas_alloc_nodes(), "node->node_count = 0" means to initialize the
node_count field of the new node, but the node may not be a new node.  It
may be a node that existed before and node_count has a value, setting it
to 0 will cause a memory leak.  At this time, mas->alloc->total will be
greater than the actual number of nodes in the linked list, which may
cause many other errors.  For example, out-of-bounds access in
mas_pop_node(), and mas_pop_node() may return addresses that should not be
used.  Fix it by initializing node_count only for new nodes.

Also, by the way, an if-else statement was removed to simplify the code.

Link: https://lkml.kernel.org/r/20230411041005.26205-1-zhangpeng.00@bytedance.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

--- a/lib/maple_tree.c~maple_tree-fix-a-potential-memory-leak-oob-access-or-other-unpredictable-bug
+++ a/lib/maple_tree.c
@@ -1303,26 +1303,21 @@ static inline void mas_alloc_nodes(struc
 	node = mas->alloc;
 	node->request_count = 0;
 	while (requested) {
-		max_req = MAPLE_ALLOC_SLOTS;
-		if (node->node_count) {
-			unsigned int offset = node->node_count;
-
-			slots = (void **)&node->slot[offset];
-			max_req -= offset;
-		} else {
-			slots = (void **)&node->slot;
-		}
-
+		max_req = MAPLE_ALLOC_SLOTS - node->node_count;
+		slots = (void **)&node->slot[node->node_count];
 		max_req = min(requested, max_req);
 		count = mt_alloc_bulk(gfp, max_req, slots);
 		if (!count)
 			goto nomem_bulk;
 
+		if (node->node_count == 0) {
+			node->slot[0]->node_count = 0;
+			node->slot[0]->request_count = 0;
+		}
+
 		node->node_count += count;
 		allocated += count;
 		node = node->slot[0];
-		node->node_count = 0;
-		node->request_count = 0;
 		requested -= count;
 	}
 	mas->alloc->total = allocated;
_

Patches currently in -mm which might be from zhangpeng.00@bytedance.com are

mm-kfence-improve-the-performance-of-__kfence_alloc-and-__kfence_free.patch
maple_tree-simplify-mas_wr_node_walk.patch
maple_tree-use-correct-variable-type-in-sizeof.patch
maple_tree-add-a-test-case-to-check-maple_alloc.patch

