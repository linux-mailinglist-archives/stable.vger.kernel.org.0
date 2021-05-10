Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 740C33787CA
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233030AbhEJLSz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:18:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:46276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236659AbhEJLIZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:08:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0AADE619B2;
        Mon, 10 May 2021 11:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644573;
        bh=Y7ekhyb+XSJ4OgJm7ILGcgfzw8TrCe8/USJ16LFGbGA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sbPMF7XcJhrQr3hOhuLT1eJZstS5uhw45IUpkx293UzQ+q6NBI3RKbdcIumJAnseG
         6Wqxz7o9SCH1Hbg+6sWv6QV6MhOu+/3qm8WwsNKRTjEK0kkYhAx/SRysrhJfA0d52R
         1bffjUSuUkGc0aWkAbyLH/DLCLQDezramo5KSwbo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 137/384] btrfs: do proper error handling in create_reloc_root
Date:   Mon, 10 May 2021 12:18:46 +0200
Message-Id: <20210510102019.410447094@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 84c50ba5214c2f3c1be4a931d521ec19f55dfdc8 ]

We do memory allocations here, read blocks from disk, all sorts of
operations that could easily fail at any given point.  Instead of
panicing the box, simply return the error back up the chain, all callers
at this point have proper error handling.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/relocation.c | 34 ++++++++++++++++++++++++++++------
 1 file changed, 28 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index bf269ee17e68..b445b3073dea 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -733,10 +733,12 @@ static struct btrfs_root *create_reloc_root(struct btrfs_trans_handle *trans,
 	struct extent_buffer *eb;
 	struct btrfs_root_item *root_item;
 	struct btrfs_key root_key;
-	int ret;
+	int ret = 0;
+	bool must_abort = false;
 
 	root_item = kmalloc(sizeof(*root_item), GFP_NOFS);
-	BUG_ON(!root_item);
+	if (!root_item)
+		return ERR_PTR(-ENOMEM);
 
 	root_key.objectid = BTRFS_TREE_RELOC_OBJECTID;
 	root_key.type = BTRFS_ROOT_ITEM_KEY;
@@ -748,7 +750,9 @@ static struct btrfs_root *create_reloc_root(struct btrfs_trans_handle *trans,
 		/* called by btrfs_init_reloc_root */
 		ret = btrfs_copy_root(trans, root, root->commit_root, &eb,
 				      BTRFS_TREE_RELOC_OBJECTID);
-		BUG_ON(ret);
+		if (ret)
+			goto fail;
+
 		/*
 		 * Set the last_snapshot field to the generation of the commit
 		 * root - like this ctree.c:btrfs_block_can_be_shared() behaves
@@ -769,9 +773,16 @@ static struct btrfs_root *create_reloc_root(struct btrfs_trans_handle *trans,
 		 */
 		ret = btrfs_copy_root(trans, root, root->node, &eb,
 				      BTRFS_TREE_RELOC_OBJECTID);
-		BUG_ON(ret);
+		if (ret)
+			goto fail;
 	}
 
+	/*
+	 * We have changed references at this point, we must abort the
+	 * transaction if anything fails.
+	 */
+	must_abort = true;
+
 	memcpy(root_item, &root->root_item, sizeof(*root_item));
 	btrfs_set_root_bytenr(root_item, eb->start);
 	btrfs_set_root_level(root_item, btrfs_header_level(eb));
@@ -789,14 +800,25 @@ static struct btrfs_root *create_reloc_root(struct btrfs_trans_handle *trans,
 
 	ret = btrfs_insert_root(trans, fs_info->tree_root,
 				&root_key, root_item);
-	BUG_ON(ret);
+	if (ret)
+		goto fail;
+
 	kfree(root_item);
 
 	reloc_root = btrfs_read_tree_root(fs_info->tree_root, &root_key);
-	BUG_ON(IS_ERR(reloc_root));
+	if (IS_ERR(reloc_root)) {
+		ret = PTR_ERR(reloc_root);
+		goto abort;
+	}
 	set_bit(BTRFS_ROOT_SHAREABLE, &reloc_root->state);
 	reloc_root->last_trans = trans->transid;
 	return reloc_root;
+fail:
+	kfree(root_item);
+abort:
+	if (must_abort)
+		btrfs_abort_transaction(trans, ret);
+	return ERR_PTR(ret);
 }
 
 /*
-- 
2.30.2



