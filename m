Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7892C621304
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:45:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234472AbiKHNpb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:45:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234516AbiKHNp3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:45:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53B3F58019
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:45:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0A578B81AEF
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:45:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57ED4C433C1;
        Tue,  8 Nov 2022 13:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915125;
        bh=czGJfvhWap4vRfkuc2UJ/6qoD5rMBXHdyFIAx9nU7I4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LxEG1JXdIE6CMBFdcZdCTbal47nIhe5RkGacBfvH8XDYF1yG0IDcyLFmL0w8xzbGB
         1Ot2jQO6eJC1EPF9rMIMoahQwBmHFMNglP5ulqUEFhDSdlE8z4LzChLGoZbN8MmHHG
         KVRFWSERFaw0PR9L86xzgnCUD3uuE2/xDwu3fUaQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 18/48] btrfs: fix inode list leak during backref walking at resolve_indirect_refs()
Date:   Tue,  8 Nov 2022 14:39:03 +0100
Message-Id: <20221108133330.147524973@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133329.533809494@linuxfoundation.org>
References: <20221108133329.533809494@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 5614dc3a47e3310fbc77ea3b67eaadd1c6417bf1 ]

During backref walking, at resolve_indirect_refs(), if we get an error
we jump to the 'out' label and call ulist_free() on the 'parents' ulist,
which frees all the elements in the ulist - however that does not free
any inode lists that may be attached to elements, through the 'aux' field
of a ulist node, so we end up leaking lists if we have any attached to
the unodes.

Fix this by calling free_leaf_list() instead of ulist_free() when we exit
from resolve_indirect_refs(). The static function free_leaf_list() is
moved up for this to be possible and it's slightly simplified by removing
unnecessary code.

Fixes: 3301958b7c1d ("Btrfs: add inodes before dropping the extent lock in find_all_leafs")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/backref.c | 36 +++++++++++++++++-------------------
 1 file changed, 17 insertions(+), 19 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 781c725e6432..a1eb573fbb10 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -589,6 +589,18 @@ unode_aux_to_inode_list(struct ulist_node *node)
 	return (struct extent_inode_elem *)(uintptr_t)node->aux;
 }
 
+static void free_leaf_list(struct ulist *ulist)
+{
+	struct ulist_node *node;
+	struct ulist_iterator uiter;
+
+	ULIST_ITER_INIT(&uiter);
+	while ((node = ulist_next(ulist, &uiter)))
+		free_inode_elem_list(unode_aux_to_inode_list(node));
+
+	ulist_free(ulist);
+}
+
 /*
  * We maintain three seperate rbtrees: one for direct refs, one for
  * indirect refs which have a key, and one for indirect refs which do not
@@ -703,7 +715,11 @@ static int resolve_indirect_refs(struct btrfs_fs_info *fs_info,
 		cond_resched();
 	}
 out:
-	ulist_free(parents);
+	/*
+	 * We may have inode lists attached to refs in the parents ulist, so we
+	 * must free them before freeing the ulist and its refs.
+	 */
+	free_leaf_list(parents);
 	return ret;
 }
 
@@ -1360,24 +1376,6 @@ static int find_parent_nodes(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-static void free_leaf_list(struct ulist *blocks)
-{
-	struct ulist_node *node = NULL;
-	struct extent_inode_elem *eie;
-	struct ulist_iterator uiter;
-
-	ULIST_ITER_INIT(&uiter);
-	while ((node = ulist_next(blocks, &uiter))) {
-		if (!node->aux)
-			continue;
-		eie = unode_aux_to_inode_list(node);
-		free_inode_elem_list(eie);
-		node->aux = 0;
-	}
-
-	ulist_free(blocks);
-}
-
 /*
  * Finds all leafs with a reference to the specified combination of bytenr and
  * offset. key_list_head will point to a list of corresponding keys (caller must
-- 
2.35.1



