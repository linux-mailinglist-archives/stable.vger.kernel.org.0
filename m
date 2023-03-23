Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97CB36C5C25
	for <lists+stable@lfdr.de>; Thu, 23 Mar 2023 02:33:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbjCWBdu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 21:33:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230305AbjCWBda (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 21:33:30 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E8481706;
        Wed, 22 Mar 2023 18:33:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 41AF1CE1E82;
        Thu, 23 Mar 2023 01:32:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CE4FC433D2;
        Thu, 23 Mar 2023 01:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679535127;
        bh=wjO4KPdVvfWc7rQps3wR9G8S2KwuotLJIIxssvvWYpE=;
        h=Date:To:From:Subject:From;
        b=opO99Uy4u3vK7bRpdGC6qCgEMr8JuZhGlcWuUXDrUiGHkZ8f1ogvAbN81m9iNW+XF
         UoSSPMT84f2xQw7eGY87AIHhIId3BkxPQJF7MzBlFcda2YurQJvhmz8v7rOSbxZ0ep
         BzKrV2HxpAOR36mTa9qb19qsAPSrBxAge5+5kG9c=
Date:   Wed, 22 Mar 2023 18:32:06 -0700
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        stable@vger.kernel.org, snild@sony.com, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maple_tree-fix-mas_skip_node-end-slot-detection.patch removed from -mm tree
Message-Id: <20230323013207.6CE4FC433D2@smtp.kernel.org>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: fix mas_skip_node() end slot detection
has been removed from the -mm tree.  Its filename was
     maple_tree-fix-mas_skip_node-end-slot-detection.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: fix mas_skip_node() end slot detection
Date: Tue, 7 Mar 2023 13:02:46 -0500

Patch series "Fix mas_skip_node() for mas_empty_area()", v2.

mas_empty_area() was incorrectly returning an error when there was room. 
The issue was tracked down to mas_skip_node() using the incorrect
end-of-slot count.  Instead of using the nodes hard limit, the limit of
data should be used.

mas_skip_node() was also setting the min and max to that of the child
node, which was unnecessary.  Within these limits being set, there was
also a bug that corrupted the maple state's max if the offset was set to
the maximum node pivot.  The bug was without consequence unless there was
a sufficient gap in the next child node which would cause an error to be
returned.

This patch set fixes these errors by removing the limit setting from
mas_skip_node() and uses the mas_data_end() for slot limits, and adds
tests for all failures discovered.


This patch (of 2):

mas_skip_node() is used to move the maple state to the node with a higher
limit.  It does this by walking up the tree and increasing the slot count.
Since slot count may not be able to be increased, it may need to walk up
multiple times to find room to walk right to a higher limit node.  The
limit of slots that was being used was the node limit and not the last
location of data in the node.  This would cause the maple state to be
shifted outside actual data and enter an error state, thus returning
-EBUSY.

The result of the incorrect error state means that mas_awalk() would
return an error instead of finding the allocation space.

The fix is to use mas_data_end() in mas_skip_node() to detect the nodes
data end point and continue walking the tree up until it is safe to move
to a node with a higher limit.

The walk up the tree also sets the maple state limits so remove the buggy
code from mas_skip_node().  Setting the limits had the unfortunate side
effect of triggering another bug if the parent node was full and the there
was no suitable gap in the second last child, but room in the next child.

mas_skip_node() may also be passed a maple state in an error state from
mas_anode_descend() when no allocations are available.  Return on such an
error state immediately.

Link: https://lkml.kernel.org/r/20230307180247.2220303-1-Liam.Howlett@oracle.com
Link: https://lkml.kernel.org/r/20230307180247.2220303-2-Liam.Howlett@oracle.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: Snild Dolkow <snild@sony.com>
  Link: https://lore.kernel.org/linux-mm/cb8dc31a-fef2-1d09-f133-e9f7b9f9e77a@sony.com/
Tested-by: Snild Dolkow <snild@sony.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/lib/maple_tree.c~maple_tree-fix-mas_skip_node-end-slot-detection
+++ a/lib/maple_tree.c
@@ -5099,35 +5099,21 @@ static inline bool mas_rewind_node(struc
  */
 static inline bool mas_skip_node(struct ma_state *mas)
 {
-	unsigned char slot, slot_count;
-	unsigned long *pivots;
-	enum maple_type mt;
+	if (mas_is_err(mas))
+		return false;
 
-	mt = mte_node_type(mas->node);
-	slot_count = mt_slots[mt] - 1;
 	do {
 		if (mte_is_root(mas->node)) {
-			slot = mas->offset;
-			if (slot > slot_count) {
+			if (mas->offset >= mas_data_end(mas)) {
 				mas_set_err(mas, -EBUSY);
 				return false;
 			}
 		} else {
 			mas_ascend(mas);
-			slot = mas->offset;
-			mt = mte_node_type(mas->node);
-			slot_count = mt_slots[mt] - 1;
 		}
-	} while (slot > slot_count);
-
-	mas->offset = ++slot;
-	pivots = ma_pivots(mas_mn(mas), mt);
-	if (slot > 0)
-		mas->min = pivots[slot - 1] + 1;
-
-	if (slot <= slot_count)
-		mas->max = pivots[slot];
+	} while (mas->offset >= mas_data_end(mas));
 
+	mas->offset++;
 	return true;
 }
 
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

maple_tree-be-more-cautious-about-dead-nodes.patch
maple_tree-detect-dead-nodes-in-mas_start.patch
maple_tree-fix-freeing-of-nodes-in-rcu-mode.patch
maple_tree-remove-extra-smp_wmb-from-mas_dead_leaves.patch
maple_tree-fix-write-memory-barrier-of-nodes-once-dead-for-rcu-mode.patch
maple_tree-add-smp_rmb-to-dead-node-detection.patch
maple_tree-add-rcu-lock-checking-to-rcu-callback-functions.patch
mm-enable-maple-tree-rcu-mode-by-default.patch

