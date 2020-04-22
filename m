Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD4111B41FE
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728122AbgDVKFH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:05:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:55956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728113AbgDVKFF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:05:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA2662078C;
        Wed, 22 Apr 2020 10:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587549904;
        bh=EpreRY4bMnPgHjQHgFvmmqBOrNaiPhQwMWKf8fFhGrE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MMsizcYZaVN8SYm0ROcb4EqTR+9cADZclbnjBrKvVbunbJNx1BjsKiOXOX3TcKkT+
         +5x2n/Ew5Kg0MsBwLDEsDg5hCICyRZ8UGY1NTLyKhjFfTyebwN02PK8pKAsprch/gu
         jVXx6nz+i4dGeaXsIM0GkhC9J/TvYVOFisNEhdlc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 013/125] btrfs: track reloc roots based on their commit root bytenr
Date:   Wed, 22 Apr 2020 11:55:30 +0200
Message-Id: <20200422095035.210674248@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095032.909124119@linuxfoundation.org>
References: <20200422095032.909124119@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit ea287ab157c2816bf12aad4cece41372f9d146b4 ]

We always search the commit root of the extent tree for looking up back
references, however we track the reloc roots based on their current
bytenr.

This is wrong, if we commit the transaction between relocating tree
blocks we could end up in this code in build_backref_tree

  if (key.objectid == key.offset) {
	  /*
	   * Only root blocks of reloc trees use backref
	   * pointing to itself.
	   */
	  root = find_reloc_root(rc, cur->bytenr);
	  ASSERT(root);
	  cur->root = root;
	  break;
  }

find_reloc_root() is looking based on the bytenr we had in the commit
root, but if we've COWed this reloc root we will not find that bytenr,
and we will trip over the ASSERT(root).

Fix this by using the commit_root->start bytenr for indexing the commit
root.  Then we change the __update_reloc_root() caller to be used when
we switch the commit root for the reloc root during commit.

This fixes the panic I was seeing when we started throttling relocation
for delayed refs.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/relocation.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 97bc85ca508c2..8d98e8e248b7a 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1296,7 +1296,7 @@ static int __must_check __add_reloc_root(struct btrfs_root *root)
 	if (!node)
 		return -ENOMEM;
 
-	node->bytenr = root->node->start;
+	node->bytenr = root->commit_root->start;
 	node->data = root;
 
 	spin_lock(&rc->reloc_root_tree.lock);
@@ -1328,10 +1328,11 @@ static void __del_reloc_root(struct btrfs_root *root)
 	if (rc && root->node) {
 		spin_lock(&rc->reloc_root_tree.lock);
 		rb_node = tree_search(&rc->reloc_root_tree.rb_root,
-				      root->node->start);
+				      root->commit_root->start);
 		if (rb_node) {
 			node = rb_entry(rb_node, struct mapping_node, rb_node);
 			rb_erase(&node->rb_node, &rc->reloc_root_tree.rb_root);
+			RB_CLEAR_NODE(&node->rb_node);
 		}
 		spin_unlock(&rc->reloc_root_tree.lock);
 		if (!node)
@@ -1349,7 +1350,7 @@ static void __del_reloc_root(struct btrfs_root *root)
  * helper to update the 'address of tree root -> reloc tree'
  * mapping
  */
-static int __update_reloc_root(struct btrfs_root *root, u64 new_bytenr)
+static int __update_reloc_root(struct btrfs_root *root)
 {
 	struct rb_node *rb_node;
 	struct mapping_node *node = NULL;
@@ -1357,7 +1358,7 @@ static int __update_reloc_root(struct btrfs_root *root, u64 new_bytenr)
 
 	spin_lock(&rc->reloc_root_tree.lock);
 	rb_node = tree_search(&rc->reloc_root_tree.rb_root,
-			      root->node->start);
+			      root->commit_root->start);
 	if (rb_node) {
 		node = rb_entry(rb_node, struct mapping_node, rb_node);
 		rb_erase(&node->rb_node, &rc->reloc_root_tree.rb_root);
@@ -1369,7 +1370,7 @@ static int __update_reloc_root(struct btrfs_root *root, u64 new_bytenr)
 	BUG_ON((struct btrfs_root *)node->data != root);
 
 	spin_lock(&rc->reloc_root_tree.lock);
-	node->bytenr = new_bytenr;
+	node->bytenr = root->node->start;
 	rb_node = tree_insert(&rc->reloc_root_tree.rb_root,
 			      node->bytenr, &node->rb_node);
 	spin_unlock(&rc->reloc_root_tree.lock);
@@ -1519,6 +1520,7 @@ int btrfs_update_reloc_root(struct btrfs_trans_handle *trans,
 	}
 
 	if (reloc_root->commit_root != reloc_root->node) {
+		__update_reloc_root(reloc_root);
 		btrfs_set_root_node(root_item, reloc_root->node);
 		free_extent_buffer(reloc_root->commit_root);
 		reloc_root->commit_root = btrfs_root_node(reloc_root);
@@ -4717,11 +4719,6 @@ int btrfs_reloc_cow_block(struct btrfs_trans_handle *trans,
 	BUG_ON(rc->stage == UPDATE_DATA_PTRS &&
 	       root->root_key.objectid == BTRFS_DATA_RELOC_TREE_OBJECTID);
 
-	if (root->root_key.objectid == BTRFS_TREE_RELOC_OBJECTID) {
-		if (buf == root->node)
-			__update_reloc_root(root, cow->start);
-	}
-
 	level = btrfs_header_level(buf);
 	if (btrfs_header_generation(buf) <=
 	    btrfs_root_last_snapshot(&root->root_item))
-- 
2.20.1



