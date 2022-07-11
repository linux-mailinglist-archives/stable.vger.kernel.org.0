Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EE2056FC22
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:39:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbiGKJjr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:39:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233190AbiGKJjJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:39:09 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD0DA88776;
        Mon, 11 Jul 2022 02:20:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B7424CE125D;
        Mon, 11 Jul 2022 09:20:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C72BEC34115;
        Mon, 11 Jul 2022 09:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531200;
        bh=iUrCCyu6FmQeyI8wW+k15UMGbAoBl7LzosdxiG9JmyM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CkamW7MFAnAPhP93X6vPieifCtw4j3sk8byVkmTb6KlM4qSKoTFiHsR54H/YYv9lh
         ekab/iQN567b9fcKkkaz1QWn3xyk0mZ5SE3fN1KWSP1h4OZn+0YhY/0iiTK7lb3OZg
         Svuhepw0K4VEOt+YPxkuHrEmD6bXEVtrwEu/ZqnE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Anand Jain <anand.jain@oracle.com>,
        Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 020/230] btrfs: rename btrfs_alloc_chunk to btrfs_create_chunk
Date:   Mon, 11 Jul 2022 11:04:36 +0200
Message-Id: <20220711090604.646648146@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikolay Borisov <nborisov@suse.com>

[ Upstream commit f6f39f7a0add4e7fd120a709545b57586a1d0393 ]

The user facing function used to allocate new chunks is
btrfs_chunk_alloc, unfortunately there is yet another similar sounding
function - btrfs_alloc_chunk. This creates confusion, especially since
the latter function can be considered "private" in the sense that it
implements the first stage of chunk creation and as such is called by
btrfs_chunk_alloc.

To avoid the awkwardness that comes with having similarly named but
distinctly different in their purpose function rename btrfs_alloc_chunk
to btrfs_create_chunk, given that the main purpose of this function is
to orchestrate the whole process of allocating a chunk - reserving space
into devices, deciding on characteristics of the stripe size and
creating the in-memory structures.

Reviewed-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/block-group.c |  6 +++---
 fs/btrfs/volumes.c     | 10 +++++-----
 fs/btrfs/volumes.h     |  2 +-
 fs/btrfs/zoned.c       |  2 +-
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 37418b183b07..aadc1203ad88 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -3400,7 +3400,7 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans, u64 flags)
 	 */
 	check_system_chunk(trans, flags);
 
-	bg = btrfs_alloc_chunk(trans, flags);
+	bg = btrfs_create_chunk(trans, flags);
 	if (IS_ERR(bg)) {
 		ret = PTR_ERR(bg);
 		goto out;
@@ -3461,7 +3461,7 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans, u64 flags)
 		const u64 sys_flags = btrfs_system_alloc_profile(trans->fs_info);
 		struct btrfs_block_group *sys_bg;
 
-		sys_bg = btrfs_alloc_chunk(trans, sys_flags);
+		sys_bg = btrfs_create_chunk(trans, sys_flags);
 		if (IS_ERR(sys_bg)) {
 			ret = PTR_ERR(sys_bg);
 			btrfs_abort_transaction(trans, ret);
@@ -3754,7 +3754,7 @@ void check_system_chunk(struct btrfs_trans_handle *trans, u64 type)
 		 * could deadlock on an extent buffer since our caller may be
 		 * COWing an extent buffer from the chunk btree.
 		 */
-		bg = btrfs_alloc_chunk(trans, flags);
+		bg = btrfs_create_chunk(trans, flags);
 		if (IS_ERR(bg)) {
 			ret = PTR_ERR(bg);
 		} else if (!(type & BTRFS_BLOCK_GROUP_SYSTEM)) {
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 378e03a93e10..b75ce79a2540 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3131,7 +3131,7 @@ int btrfs_remove_chunk(struct btrfs_trans_handle *trans, u64 chunk_offset)
 		const u64 sys_flags = btrfs_system_alloc_profile(fs_info);
 		struct btrfs_block_group *sys_bg;
 
-		sys_bg = btrfs_alloc_chunk(trans, sys_flags);
+		sys_bg = btrfs_create_chunk(trans, sys_flags);
 		if (IS_ERR(sys_bg)) {
 			ret = PTR_ERR(sys_bg);
 			btrfs_abort_transaction(trans, ret);
@@ -5010,7 +5010,7 @@ static void check_raid1c34_incompat_flag(struct btrfs_fs_info *info, u64 type)
 }
 
 /*
- * Structure used internally for __btrfs_alloc_chunk() function.
+ * Structure used internally for btrfs_create_chunk() function.
  * Wraps needed parameters.
  */
 struct alloc_chunk_ctl {
@@ -5414,7 +5414,7 @@ static struct btrfs_block_group *create_chunk(struct btrfs_trans_handle *trans,
 	return block_group;
 }
 
-struct btrfs_block_group *btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
+struct btrfs_block_group *btrfs_create_chunk(struct btrfs_trans_handle *trans,
 					    u64 type)
 {
 	struct btrfs_fs_info *info = trans->fs_info;
@@ -5615,12 +5615,12 @@ static noinline int init_first_rw_device(struct btrfs_trans_handle *trans)
 	 */
 
 	alloc_profile = btrfs_metadata_alloc_profile(fs_info);
-	meta_bg = btrfs_alloc_chunk(trans, alloc_profile);
+	meta_bg = btrfs_create_chunk(trans, alloc_profile);
 	if (IS_ERR(meta_bg))
 		return PTR_ERR(meta_bg);
 
 	alloc_profile = btrfs_system_alloc_profile(fs_info);
-	sys_bg = btrfs_alloc_chunk(trans, alloc_profile);
+	sys_bg = btrfs_create_chunk(trans, alloc_profile);
 	if (IS_ERR(sys_bg))
 		return PTR_ERR(sys_bg);
 
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 4db10d071d67..d86a6f9f166c 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -454,7 +454,7 @@ int btrfs_get_io_geometry(struct btrfs_fs_info *fs_info, struct extent_map *map,
 			  struct btrfs_io_geometry *io_geom);
 int btrfs_read_sys_array(struct btrfs_fs_info *fs_info);
 int btrfs_read_chunk_tree(struct btrfs_fs_info *fs_info);
-struct btrfs_block_group *btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
+struct btrfs_block_group *btrfs_create_chunk(struct btrfs_trans_handle *trans,
 					    u64 type);
 void btrfs_mapping_tree_free(struct extent_map_tree *tree);
 blk_status_t btrfs_map_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 596b2148807d..3bc2f92cd197 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -636,7 +636,7 @@ int btrfs_check_zoned_mode(struct btrfs_fs_info *fs_info)
 
 	/*
 	 * stripe_size is always aligned to BTRFS_STRIPE_LEN in
-	 * __btrfs_alloc_chunk(). Since we want stripe_len == zone_size,
+	 * btrfs_create_chunk(). Since we want stripe_len == zone_size,
 	 * check the alignment here.
 	 */
 	if (!IS_ALIGNED(zone_size, BTRFS_STRIPE_LEN)) {
-- 
2.35.1



