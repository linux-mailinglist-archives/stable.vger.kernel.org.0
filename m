Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F8EA217106
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729974AbgGGPXY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:23:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:36384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729966AbgGGPXW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:23:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59F32208C3;
        Tue,  7 Jul 2020 15:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135401;
        bh=SDYgL+60Cc5HwO1CKauf2tQ2K13tykHdnW4vG5neRoA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xwUriVum8ANvfKubgj2O2ubei21euADyHYZTZaEYND0RrBl2oPZkbWCw2HSwqs+dF
         B8FQom6mu4yhTUKTGdOpqkiwn9dKNsrCyGcT84OrlZ2GpC7v3ny2+EFe0lmB8kiygo
         VJEpmnsiSfQinBjDKV7LFwv6P1vOEpNB4pvdJL74=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 006/112] btrfs: block-group: refactor how we delete one block group item
Date:   Tue,  7 Jul 2020 17:16:11 +0200
Message-Id: <20200707145801.239600248@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145800.925304888@linuxfoundation.org>
References: <20200707145800.925304888@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 7357623a7f4beb4ac76005f8fac9fc0230f9a67e ]

When deleting a block group item, it's pretty straight forward, just
delete the item pointed by the key.  However it will not be that
straight-forward for incoming skinny block group item.

So refactor the block group item deletion into a new function,
remove_block_group_item(), also to make the already lengthy
btrfs_remove_block_group() a little shorter.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/block-group.c | 37 +++++++++++++++++++++++++------------
 1 file changed, 25 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 0c17f18b47940..d80857d00b0fb 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -863,11 +863,34 @@ static void clear_incompat_bg_bits(struct btrfs_fs_info *fs_info, u64 flags)
 	}
 }
 
+static int remove_block_group_item(struct btrfs_trans_handle *trans,
+				   struct btrfs_path *path,
+				   struct btrfs_block_group *block_group)
+{
+	struct btrfs_fs_info *fs_info = trans->fs_info;
+	struct btrfs_root *root;
+	struct btrfs_key key;
+	int ret;
+
+	root = fs_info->extent_root;
+	key.objectid = block_group->start;
+	key.type = BTRFS_BLOCK_GROUP_ITEM_KEY;
+	key.offset = block_group->length;
+
+	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
+	if (ret > 0)
+		ret = -ENOENT;
+	if (ret < 0)
+		return ret;
+
+	ret = btrfs_del_item(trans, root, path);
+	return ret;
+}
+
 int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 			     u64 group_start, struct extent_map *em)
 {
 	struct btrfs_fs_info *fs_info = trans->fs_info;
-	struct btrfs_root *root = fs_info->extent_root;
 	struct btrfs_path *path;
 	struct btrfs_block_group *block_group;
 	struct btrfs_free_cluster *cluster;
@@ -1068,10 +1091,6 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 
 	spin_unlock(&block_group->space_info->lock);
 
-	key.objectid = block_group->start;
-	key.type = BTRFS_BLOCK_GROUP_ITEM_KEY;
-	key.offset = block_group->length;
-
 	mutex_lock(&fs_info->chunk_mutex);
 	spin_lock(&block_group->lock);
 	block_group->removed = 1;
@@ -1107,16 +1126,10 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 	if (ret)
 		goto out;
 
-	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
-	if (ret > 0)
-		ret = -EIO;
+	ret = remove_block_group_item(trans, path, block_group);
 	if (ret < 0)
 		goto out;
 
-	ret = btrfs_del_item(trans, root, path);
-	if (ret)
-		goto out;
-
 	if (remove_em) {
 		struct extent_map_tree *em_tree;
 
-- 
2.25.1



