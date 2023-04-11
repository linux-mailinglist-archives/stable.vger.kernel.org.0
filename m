Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5DDE6DD089
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 05:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbjDKDzl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Apr 2023 23:55:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbjDKDzk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Apr 2023 23:55:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3559213D;
        Mon, 10 Apr 2023 20:55:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F79062103;
        Tue, 11 Apr 2023 03:55:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4D2EC433EF;
        Tue, 11 Apr 2023 03:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681185333;
        bh=MTLtll3RxVcbpQGvc5tJwoUxdP0QtrkhZgegUU0dj80=;
        h=Date:To:From:Subject:From;
        b=KfcmcTj0isWAQOy5bgUoYJ//2NcFuAn2TemUgxiZ39UYH2tfcRgnd+N6SPLoF6RdH
         MnQvY6JSb73ZesPre/NAe+SOHy6+8xzP968qs9MrzUMaRd8GlBoJTrZD7JUCa/AQ2I
         m7TEAhxW2i/QFfQpTZskvsikmgYsTUWDqtYLbZ74=
Date:   Mon, 10 Apr 2023 20:55:33 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        Liam.Howlett@Oracle.com, zhangpeng.00@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] maple_tree-fix-a-potential-memory-leak-oob-access-or-other-unpredictable-bug.patch removed from -mm tree
Message-Id: <20230411035533.B4D2EC433EF@smtp.kernel.org>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: fix a potential memory leak, OOB access, or other unpredictable bug
has been removed from the -mm tree.  Its filename was
     maple_tree-fix-a-potential-memory-leak-oob-access-or-other-unpredictable-bug.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Peng Zhang <zhangpeng.00@bytedance.com>
Subject: maple_tree: fix a potential memory leak, OOB access, or other unpredictable bug
Date: Fri, 7 Apr 2023 12:07:18 +0800

In mas_alloc_nodes(), there is such a piece of code:

while (requested) {
	...
	node->node_count = 0;
	...
}

"node->node_count = 0" means to initialize the node_count field of the new
node, but the node may not be a new node.  It may be a node that existed
before and node_count has a value, setting it to 0 will cause a memory
leak.  At this time, mas->alloc->total will be greater than the actual
number of nodes in the linked list, which may cause many other errors. 
For example, out-of-bounds access in mas_pop_node(), and mas_pop_node()
may return addresses that should not be used.  Fix it by initializing
node_count only for new nodes.

Link: https://lkml.kernel.org/r/20230407040718.99064-2-zhangpeng.00@bytedance.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

--- a/lib/maple_tree.c~maple_tree-fix-a-potential-memory-leak-oob-access-or-other-unpredictable-bug
+++ a/lib/maple_tree.c
@@ -1303,26 +1303,18 @@ static inline void mas_alloc_nodes(struc
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
 
+		if (node->node_count == 0)
+			node->slot[0]->node_count = 0;
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

maple_tree-use-correct-variable-type-in-sizeof.patch
mm-kfence-improve-the-performance-of-__kfence_alloc-and-__kfence_free.patch
maple_tree-simplify-mas_wr_node_walk.patch
maple_tree-add-a-test-case-to-check-maple_alloc.patch

