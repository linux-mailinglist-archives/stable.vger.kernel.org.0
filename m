Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 623CB52CEA7
	for <lists+stable@lfdr.de>; Thu, 19 May 2022 10:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbiESIuh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 May 2022 04:50:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbiESIug (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 May 2022 04:50:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3D1FA9C2EA
        for <stable@vger.kernel.org>; Thu, 19 May 2022 01:50:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652950234;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=p92fXrJQ4gGF6gXdL4rpxaBMAzMtQCdZw00jmCIxVH0=;
        b=J39bcAzJztYFSwE9BX6Tudg2rkA7laSXEa5GEFjdykUTKvjgJgau9tTj0kStiBbCcZ8Pst
        veH0FIR1l8rv6LioJjRgs+vDpZ/rcZEUOnmKGdaiIg4CcVHO3GJPoxDKTRLII6ORIK0/Wt
        UZ95f3GMtJjZ1+BkCzPv0XcIfV61/04=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-638-AYYgi-E3OmePuQW2dI8JAw-1; Thu, 19 May 2022 04:50:33 -0400
X-MC-Unique: AYYgi-E3OmePuQW2dI8JAw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BD516802803;
        Thu, 19 May 2022 08:50:32 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 95948400E114;
        Thu, 19 May 2022 08:50:31 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH] assoc_array: Fix BUG_ON during garbage collect
From:   David Howells <dhowells@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     stable@vger.kernel.org,
        Stephen Brennan <stephen.s.brennan@oracle.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        keyrings@vger.kernel.org, dhowells@redhat.com,
        linux-kernel@vger.kernel.org
Date:   Thu, 19 May 2022 09:50:30 +0100
Message-ID: <165295023086.3361286.8662079860706628540.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Brennan <stephen.s.brennan@oracle.com>

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
node, because there was only one available slot (slot 0). Thus, the
internal node was retained. At slot 1, the node had one leaf, and was
able to be folded in successfully. The remaining nodes had no leaves,
and so were removed. By the end of the compression stage, there were 14
free slots, and only 3 leaf nodes. The tree was ascended and then its
parent node was compressed. When this node was seen, it could not be
folded, due to the internal node it contained.

The invariant for compression in this function is: whenever
nr_leaves_on_branch < ASSOC_ARRAY_FAN_OUT, the node should contain all
leaf nodes. The compression step currently cannot guarantee this, given
the corner case shown above.

To fix this issue, retry compression whenever we have retained a node,
and yet nr_leaves_on_branch < ASSOC_ARRAY_FAN_OUT. This second
compression will then allow the node in slot 1 to be folded in,
satisfying the invariant. Below is the output of the reproducer once the
fix is applied:

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

Changes
=======
DH:
 - Use false instead of 0.
 - Reorder the inserted lines in a couple of places to put retained before
   next_slot.

ver #2)
 - Fix typo in pr_devel, correct comparison to "<="


Fixes: 3cb989501c26 ("Add a generic associative array implementation.")
Cc: <stable@vger.kernel.org>
Signed-off-by: Stephen Brennan <stephen.s.brennan@oracle.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Jarkko Sakkinen <jarkko@kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>
cc: keyrings@vger.kernel.org
Link: https://lore.kernel.org/r/20220511225517.407935-1-stephen.s.brennan@oracle.com/ # v1
Link: https://lore.kernel.org/r/20220512215045.489140-1-stephen.s.brennan@oracle.com/ # v2
---

 lib/assoc_array.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/lib/assoc_array.c b/lib/assoc_array.c
index 079c72e26493..ca0b4f360c1a 100644
--- a/lib/assoc_array.c
+++ b/lib/assoc_array.c
@@ -1461,6 +1461,7 @@ int assoc_array_gc(struct assoc_array *array,
 	struct assoc_array_ptr *cursor, *ptr;
 	struct assoc_array_ptr *new_root, *new_parent, **new_ptr_pp;
 	unsigned long nr_leaves_on_tree;
+	bool retained;
 	int keylen, slot, nr_free, next_slot, i;
 
 	pr_devel("-->%s()\n", __func__);
@@ -1536,6 +1537,7 @@ int assoc_array_gc(struct assoc_array *array,
 		goto descend;
 	}
 
+retry_compress:
 	pr_devel("-- compress node %p --\n", new_n);
 
 	/* Count up the number of empty slots in this node and work out the
@@ -1553,6 +1555,7 @@ int assoc_array_gc(struct assoc_array *array,
 	pr_devel("free=%d, leaves=%lu\n", nr_free, new_n->nr_leaves_on_branch);
 
 	/* See what we can fold in */
+	retained = false;
 	next_slot = 0;
 	for (slot = 0; slot < ASSOC_ARRAY_FAN_OUT; slot++) {
 		struct assoc_array_shortcut *s;
@@ -1602,9 +1605,14 @@ int assoc_array_gc(struct assoc_array *array,
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


