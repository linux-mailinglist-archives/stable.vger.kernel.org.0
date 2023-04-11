Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 917416DD106
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 06:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbjDKEhv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 00:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbjDKEhu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 00:37:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2DFE10DC;
        Mon, 10 Apr 2023 21:37:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D63161F27;
        Tue, 11 Apr 2023 04:37:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95C91C433EF;
        Tue, 11 Apr 2023 04:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681187868;
        bh=Gae+XT0KkZG+Xqo7hiJSie1samATP5Tw4z6ya6g8EDU=;
        h=Date:To:From:Subject:From;
        b=xRleMGLLzLQfN8PsWUevgCP5anxnTbYz4eZvG6V8ZWB0998NhXALDU+ikvmmR66+8
         HbVcXdvigMhEJdovFnNyZnlT4JJzqkEHTqiQVtMLC+1vVacCVeTfGIarg+FdY6Upp5
         HkrpNg6UBSydGCrq+UuS0LDXWjVWyonEW4UmQ1L8=
Date:   Mon, 10 Apr 2023 21:37:47 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        Liam.Howlett@Oracle.com, zhangpeng.00@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-fix-a-potential-memory-leak-oob-access-or-other-unpredictable-bug.patch added to mm-hotfixes-unstable branch
Message-Id: <20230411043748.95C91C433EF@smtp.kernel.org>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
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
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
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

maple_tree-fix-a-potential-memory-leak-oob-access-or-other-unpredictable-bug.patch
mm-kfence-improve-the-performance-of-__kfence_alloc-and-__kfence_free.patch
maple_tree-simplify-mas_wr_node_walk.patch
maple_tree-use-correct-variable-type-in-sizeof.patch

