Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA8476BB2F5
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:40:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232897AbjCOMkn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:40:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232889AbjCOMkT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:40:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 819F2A0F00
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:39:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B4CB4613F9
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:38:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C760AC433D2;
        Wed, 15 Mar 2023 12:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883905;
        bh=zsmF720APCBajZh9S+EnYtfO31hpvlfxzUefjgN/uv8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FXXAdkWGtvdbqp3EBfwWtDRe0h9fIqmhYKZlqEFL0jRx1oN0eYx6Ca96THFY7x/0P
         VbNY+hb6wQPtSxOcz2AIoC/j6Me5nywoI34sWXghk/EeV2JIHAxhx1OoIM8lFuN8Xv
         Sssw4+tVCQKgjOJsMloLKdZPw/Pjqp3EumzEVpLs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Qu Wenruo <wqu@suse.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 6.2 004/141] btrfs: fix block group item corruption after inserting new block group
Date:   Wed, 15 Mar 2023 13:11:47 +0100
Message-Id: <20230315115740.094480653@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115739.932786806@linuxfoundation.org>
References: <20230315115739.932786806@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit 675dfe1223a69e270b3d52cb0211c8a501455cec upstream.

We can often end up inserting a block group item, for a new block group,
with a wrong value for the used bytes field.

This happens if for the new allocated block group, in the same transaction
that created the block group, we have tasks allocating extents from it as
well as tasks removing extents from it.

For example:

1) Task A creates a metadata block group X;

2) Two extents are allocated from block group X, so its "used" field is
   updated to 32K, and its "commit_used" field remains as 0;

3) Transaction commit starts, by some task B, and it enters
   btrfs_start_dirty_block_groups(). There it tries to update the block
   group item for block group X, which currently has its "used" field with
   a value of 32K. But that fails since the block group item was not yet
   inserted, and so on failure update_block_group_item() sets the
   "commit_used" field of the block group back to 0;

4) The block group item is inserted by task A, when for example
   btrfs_create_pending_block_groups() is called when releasing its
   transaction handle. This results in insert_block_group_item() inserting
   the block group item in the extent tree (or block group tree), with a
   "used" field having a value of 32K, but without updating the
   "commit_used" field in the block group, which remains with value of 0;

5) The two extents are freed from block X, so its "used" field changes
   from 32K to 0;

6) The transaction commit by task B continues, it enters
   btrfs_write_dirty_block_groups() which calls update_block_group_item()
   for block group X, and there it decides to skip the block group item
   update, because "used" has a value of 0 and "commit_used" has a value
   of 0 too.

   As a result, we end up with a block item having a 32K "used" field but
   no extents allocated from it.

When this issue happens, a btrfs check reports an error like this:

   [1/7] checking root items
   [2/7] checking extents
   block group [1104150528 1073741824] used 39796736 but extent items used 0
   ERROR: errors found in extent allocation tree or chunk allocation
   (...)

Fix this by making insert_block_group_item() update the block group's
"commit_used" field.

Fixes: 7248e0cebbef ("btrfs: skip update of block group item if used bytes are the same")
CC: stable@vger.kernel.org # 6.2+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/block-group.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -2350,18 +2350,29 @@ static int insert_block_group_item(struc
 	struct btrfs_block_group_item bgi;
 	struct btrfs_root *root = btrfs_block_group_root(fs_info);
 	struct btrfs_key key;
+	u64 old_commit_used;
+	int ret;
 
 	spin_lock(&block_group->lock);
 	btrfs_set_stack_block_group_used(&bgi, block_group->used);
 	btrfs_set_stack_block_group_chunk_objectid(&bgi,
 						   block_group->global_root_id);
 	btrfs_set_stack_block_group_flags(&bgi, block_group->flags);
+	old_commit_used = block_group->commit_used;
+	block_group->commit_used = block_group->used;
 	key.objectid = block_group->start;
 	key.type = BTRFS_BLOCK_GROUP_ITEM_KEY;
 	key.offset = block_group->length;
 	spin_unlock(&block_group->lock);
 
-	return btrfs_insert_item(trans, root, &key, &bgi, sizeof(bgi));
+	ret = btrfs_insert_item(trans, root, &key, &bgi, sizeof(bgi));
+	if (ret < 0) {
+		spin_lock(&block_group->lock);
+		block_group->commit_used = old_commit_used;
+		spin_unlock(&block_group->lock);
+	}
+
+	return ret;
 }
 
 static int insert_dev_extent(struct btrfs_trans_handle *trans,


