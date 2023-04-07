Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9186DB66C
	for <lists+stable@lfdr.de>; Sat,  8 Apr 2023 00:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230357AbjDGWWW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Apr 2023 18:22:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230321AbjDGWWT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Apr 2023 18:22:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92DC7D301;
        Fri,  7 Apr 2023 15:22:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 27C0564847;
        Fri,  7 Apr 2023 22:22:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BED1C433EF;
        Fri,  7 Apr 2023 22:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680906122;
        bh=e+1EPnY6m0unHmJv6Brp4D1ggDzNIRdroTGBiXJ13GA=;
        h=Date:To:From:Subject:From;
        b=Aa+Xq9ohXHs+8NPiQFJp1wcC35XJq9PC6doKAw9My8OTpWXMcYxERQ4wmYnKXR/mv
         Vhy2SLOOa+jJx6BK0deF5dsTKNxLeBjF12rHF/2Q3z0JV21+qYiS73ENiHiG2jEkM1
         jUe48OOHpkZBJLN8weijeiEiNget0yPISbWTbERE=
Date:   Fri, 07 Apr 2023 15:22:01 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        Liam.Howlett@Oracle.com, zhangpeng.00@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-fix-a-potential-memory-leak-oob-access-or-other-unpredictable-bug.patch added to mm-hotfixes-unstable branch
Message-Id: <20230407222202.7BED1C433EF@smtp.kernel.org>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: maple_tree: fix a potential memory leak, OOB access, or other unpredictable bug
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maple_tree-fix-a-potential-memory-leak-oob-access-or-other-unpredictable-bug.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-fix-a-potential-memory-leak-oob-access-or-other-unpredictable-bug.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

maple_tree-fix-a-potential-memory-leak-oob-access-or-other-unpredictable-bug.patch
mm-kfence-improve-the-performance-of-__kfence_alloc-and-__kfence_free.patch
maple_tree-simplify-mas_wr_node_walk.patch

