Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF63852DB73
	for <lists+stable@lfdr.de>; Thu, 19 May 2022 19:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242848AbiESRjZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 May 2022 13:39:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242747AbiESRjY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 May 2022 13:39:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FD10A30A2;
        Thu, 19 May 2022 10:39:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE6B06179A;
        Thu, 19 May 2022 17:39:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BE82C385AA;
        Thu, 19 May 2022 17:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652981962;
        bh=3ptKMVFXCY35eyA8Jfhf9bnNRJCkLn9iiBpsQz5kp2M=;
        h=Date:To:From:Subject:From;
        b=TKfmsddXpzCckxrmoix2apcW56KNu1jzDXCZOep/f/7w5UnGKLVIKY5AtObR/2VhT
         Ug+3ue+mu6satToqzJ0di/rMn0MSd5n2gl3g+2jkl9Z0eDuiaXDQezSBomS+oB/Wsk
         xG5ZBPow45BeRUSLXArvPZIWKpRzHfWoJSA7oCcc=
Date:   Thu, 19 May 2022 10:39:21 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        len.baker@gmx.com, gustavoars@kernel.org, dhowells@redhat.com,
        stephen.s.brennan@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [alternative-merged] assoc_array-fix-bug_on-during-garbage-collect.patch removed from -mm tree
Message-Id: <20220519173922.0BE82C385AA@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: lib/assoc_array.c: fix BUG_ON during garbage collect
has been removed from the -mm tree.  Its filename was
     assoc_array-fix-bug_on-during-garbage-collect.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Stephen Brennan <stephen.s.brennan@oracle.com>
Subject: lib/assoc_array.c: fix BUG_ON during garbage collect

A rare BUG_ON triggered in assoc_array_gc:

    [3430308.818153] kernel BUG at lib/assoc_array.c:1609!

Which corresponded to the statement currently at line 1593 upstream:

    BUG_ON(assoc_array_ptr_is_meta(p));

Using the data from the core dump, I was able to generate a userspace
reproducer[1] and determine the cause of the bug.

[1]: https://github.com/brenns10/kernel_stuff/tree/master/assoc_array_gc

After running the iterator on the entire branch, an internal tree node
looked like the following:

    NODE (nr_leaves_on_branch: 3)
      SLOT [0] NODE (2 leaves)
      SLOT [1] NODE (1 leaf)
      SLOT [2..f] NODE (empty)

In the userspace reproducer, the pr_devel output when compressing this
node was:

    -- compress node 0x5607cc089380 --
    free=0, leaves=0
    [0] retain node 2/1 [nx 0]
    [1] fold node 1/1 [nx 0]
    [2] fold node 0/1 [nx 2]
    [3] fold node 0/2 [nx 2]
    [4] fold node 0/3 [nx 2]
    [5] fold node 0/4 [nx 2]
    [6] fold node 0/5 [nx 2]
    [7] fold node 0/6 [nx 2]
    [8] fold node 0/7 [nx 2]
    [9] fold node 0/8 [nx 2]
    [10] fold node 0/9 [nx 2]
    [11] fold node 0/10 [nx 2]
    [12] fold node 0/11 [nx 2]
    [13] fold node 0/12 [nx 2]
    [14] fold node 0/13 [nx 2]
    [15] fold node 0/14 [nx 2]
    after: 3

At slot 0, an internal node with 2 leaves could not be folded into the
node, because there was only one available slot (slot 0).  Thus, the
internal node was retained.  At slot 1, the node had one leaf, and was
able to be folded in successfully.  The remaining nodes had no leaves, and
so were removed.  By the end of the compression stage, there were 14 free
slots, and only 3 leaf nodes.  The tree was ascended and then its parent
node was compressed.  When this node was seen, it could not be folded, due
to the internal node it contained.

The invariant for compression in this function is: whenever
nr_leaves_on_branch < ASSOC_ARRAY_FAN_OUT, the node should contain all
leaf nodes.  The compression step currently cannot guarantee this, given
the corner case shown above.

To fix this issue, retry compression whenever we have retained a node, and
yet nr_leaves_on_branch < ASSOC_ARRAY_FAN_OUT.  This second compression
will then allow the node in slot 1 to be folded in, satisfying the
invariant.  Below is the output of the reproducer once the fix is applied:

    -- compress node 0x560e9c562380 --
    free=0, leaves=0
    [0] retain node 2/1 [nx 0]
    [1] fold node 1/1 [nx 0]
    [2] fold node 0/1 [nx 2]
    [3] fold node 0/2 [nx 2]
    [4] fold node 0/3 [nx 2]
    [5] fold node 0/4 [nx 2]
    [6] fold node 0/5 [nx 2]
    [7] fold node 0/6 [nx 2]
    [8] fold node 0/7 [nx 2]
    [9] fold node 0/8 [nx 2]
    [10] fold node 0/9 [nx 2]
    [11] fold node 0/10 [nx 2]
    [12] fold node 0/11 [nx 2]
    [13] fold node 0/12 [nx 2]
    [14] fold node 0/13 [nx 2]
    [15] fold node 0/14 [nx 2]
    internal nodes remain despite enough space, retrying
    -- compress node 0x560e9c562380 --
    free=14, leaves=1
    [0] fold node 2/15 [nx 0]
    after: 3

[akpm@linux-foundation.org: fix typo in printk]
[stephen.s.brennan@oracle.com: correct comparison to "<="]
  Link: https://lkml.kernel.org/r/20220512215045.489140-1-stephen.s.brennan@oracle.com
Link: https://lkml.kernel.org/r/20220511225517.407935-1-stephen.s.brennan@oracle.com
Fixes: 3cb989501c26 ("Add a generic associative array implementation.")
Signed-off-by: Stephen Brennan <stephen.s.brennan@oracle.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Len Baker <len.baker@gmx.com>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/assoc_array.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/lib/assoc_array.c~assoc_array-fix-bug_on-during-garbage-collect
+++ a/lib/assoc_array.c
@@ -1462,6 +1462,7 @@ int assoc_array_gc(struct assoc_array *a
 	struct assoc_array_ptr *new_root, *new_parent, **new_ptr_pp;
 	unsigned long nr_leaves_on_tree;
 	int keylen, slot, nr_free, next_slot, i;
+	bool retained;
 
 	pr_devel("-->%s()\n", __func__);
 
@@ -1536,6 +1537,7 @@ continue_node:
 		goto descend;
 	}
 
+retry_compress:
 	pr_devel("-- compress node %p --\n", new_n);
 
 	/* Count up the number of empty slots in this node and work out the
@@ -1554,6 +1556,7 @@ continue_node:
 
 	/* See what we can fold in */
 	next_slot = 0;
+	retained = 0;
 	for (slot = 0; slot < ASSOC_ARRAY_FAN_OUT; slot++) {
 		struct assoc_array_shortcut *s;
 		struct assoc_array_node *child;
@@ -1602,9 +1605,14 @@ continue_node:
 			pr_devel("[%d] retain node %lu/%d [nx %d]\n",
 				 slot, child->nr_leaves_on_branch, nr_free + 1,
 				 next_slot);
+			retained = true;
 		}
 	}
 
+	if (retained && new_n->nr_leaves_on_branch <= ASSOC_ARRAY_FAN_OUT) {
+		pr_devel("internal nodes remain despite enough space, retrying\n");
+		goto retry_compress;
+	}
 	pr_devel("after: %lu\n", new_n->nr_leaves_on_branch);
 
 	nr_leaves_on_tree = new_n->nr_leaves_on_branch;
_

Patches currently in -mm which might be from stephen.s.brennan@oracle.com are


