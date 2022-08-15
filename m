Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C70F4594CA7
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343528AbiHPBAg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 21:00:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349150AbiHPA6L (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:58:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9CCE33427;
        Mon, 15 Aug 2022 13:49:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70030B8114A;
        Mon, 15 Aug 2022 20:49:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B956BC433D6;
        Mon, 15 Aug 2022 20:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596566;
        bh=7IK/drlHk1T+rvVggqUV2frGwTPfHLuz+70ozCIkTT0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BpXv8F2d91j3sCqDPkOjD8TVL/+okJshPU65iyQRSAZcb78FVeiwMcdAVI9R5iVBp
         m2u73um950ZwCGI2QxjhnTo1+iNxavr91sqggTxLQwSD8RZFlUOHTsdT9T2+X59rua
         IPwfeiQulvWBun7pNxzzDH7zJs2WBhOaa1EjCz/0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 1087/1157] btrfs: convert count_max_extents() to use fs_info->max_extent_size
Date:   Mon, 15 Aug 2022 20:07:23 +0200
Message-Id: <20220815180523.678201270@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naohiro Aota <naohiro.aota@wdc.com>

[ Upstream commit 7d7672bc5d1038c745716c397d892d21e29de71c ]

If count_max_extents() uses BTRFS_MAX_EXTENT_SIZE to calculate the number
of extents needed, btrfs release the metadata reservation too much on its
way to write out the data.

Now that BTRFS_MAX_EXTENT_SIZE is replaced with fs_info->max_extent_size,
convert count_max_extents() to use it instead, and fix the calculation of
the metadata reservation.

CC: stable@vger.kernel.org # 5.12+
Fixes: d8e3fb106f39 ("btrfs: zoned: use ZONE_APPEND write for zoned mode")
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ctree.h          | 21 +++++++++++++--------
 fs/btrfs/delalloc-space.c |  6 +++---
 fs/btrfs/inode.c          | 16 ++++++++--------
 3 files changed, 24 insertions(+), 19 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 364c71ad7cce..d306db5dbdc2 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -107,14 +107,6 @@ struct btrfs_ioctl_encoded_io_args;
 #define BTRFS_STAT_CURR		0
 #define BTRFS_STAT_PREV		1
 
-/*
- * Count how many BTRFS_MAX_EXTENT_SIZE cover the @size
- */
-static inline u32 count_max_extents(u64 size)
-{
-	return div_u64(size + BTRFS_MAX_EXTENT_SIZE - 1, BTRFS_MAX_EXTENT_SIZE);
-}
-
 static inline unsigned long btrfs_chunk_item_size(int num_stripes)
 {
 	BUG_ON(num_stripes == 0);
@@ -4017,6 +4009,19 @@ static inline bool btrfs_is_zoned(const struct btrfs_fs_info *fs_info)
 	return fs_info->zone_size > 0;
 }
 
+/*
+ * Count how many fs_info->max_extent_size cover the @size
+ */
+static inline u32 count_max_extents(struct btrfs_fs_info *fs_info, u64 size)
+{
+#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
+	if (!fs_info)
+		return div_u64(size + BTRFS_MAX_EXTENT_SIZE - 1, BTRFS_MAX_EXTENT_SIZE);
+#endif
+
+	return div_u64(size + fs_info->max_extent_size - 1, fs_info->max_extent_size);
+}
+
 static inline bool btrfs_is_data_reloc_root(const struct btrfs_root *root)
 {
 	return root->root_key.objectid == BTRFS_DATA_RELOC_TREE_OBJECTID;
diff --git a/fs/btrfs/delalloc-space.c b/fs/btrfs/delalloc-space.c
index 36ab0859a263..1e8f17ff829e 100644
--- a/fs/btrfs/delalloc-space.c
+++ b/fs/btrfs/delalloc-space.c
@@ -273,7 +273,7 @@ static void calc_inode_reservations(struct btrfs_fs_info *fs_info,
 				    u64 num_bytes, u64 disk_num_bytes,
 				    u64 *meta_reserve, u64 *qgroup_reserve)
 {
-	u64 nr_extents = count_max_extents(num_bytes);
+	u64 nr_extents = count_max_extents(fs_info, num_bytes);
 	u64 csum_leaves = btrfs_csum_bytes_to_leaves(fs_info, disk_num_bytes);
 	u64 inode_update = btrfs_calc_metadata_size(fs_info, 1);
 
@@ -350,7 +350,7 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes,
 	 * needs to free the reservation we just made.
 	 */
 	spin_lock(&inode->lock);
-	nr_extents = count_max_extents(num_bytes);
+	nr_extents = count_max_extents(fs_info, num_bytes);
 	btrfs_mod_outstanding_extents(inode, nr_extents);
 	inode->csum_bytes += disk_num_bytes;
 	btrfs_calculate_inode_block_rsv_size(fs_info, inode);
@@ -413,7 +413,7 @@ void btrfs_delalloc_release_extents(struct btrfs_inode *inode, u64 num_bytes)
 	unsigned num_extents;
 
 	spin_lock(&inode->lock);
-	num_extents = count_max_extents(num_bytes);
+	num_extents = count_max_extents(fs_info, num_bytes);
 	btrfs_mod_outstanding_extents(inode, -num_extents);
 	btrfs_calculate_inode_block_rsv_size(fs_info, inode);
 	spin_unlock(&inode->lock);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index d9123bfeae8d..30e454197fb9 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2217,10 +2217,10 @@ void btrfs_split_delalloc_extent(struct inode *inode,
 		 * applies here, just in reverse.
 		 */
 		new_size = orig->end - split + 1;
-		num_extents = count_max_extents(new_size);
+		num_extents = count_max_extents(fs_info, new_size);
 		new_size = split - orig->start;
-		num_extents += count_max_extents(new_size);
-		if (count_max_extents(size) >= num_extents)
+		num_extents += count_max_extents(fs_info, new_size);
+		if (count_max_extents(fs_info, size) >= num_extents)
 			return;
 	}
 
@@ -2277,10 +2277,10 @@ void btrfs_merge_delalloc_extent(struct inode *inode, struct extent_state *new,
 	 * this case.
 	 */
 	old_size = other->end - other->start + 1;
-	num_extents = count_max_extents(old_size);
+	num_extents = count_max_extents(fs_info, old_size);
 	old_size = new->end - new->start + 1;
-	num_extents += count_max_extents(old_size);
-	if (count_max_extents(new_size) >= num_extents)
+	num_extents += count_max_extents(fs_info, old_size);
+	if (count_max_extents(fs_info, new_size) >= num_extents)
 		return;
 
 	spin_lock(&BTRFS_I(inode)->lock);
@@ -2359,7 +2359,7 @@ void btrfs_set_delalloc_extent(struct inode *inode, struct extent_state *state,
 	if (!(state->state & EXTENT_DELALLOC) && (*bits & EXTENT_DELALLOC)) {
 		struct btrfs_root *root = BTRFS_I(inode)->root;
 		u64 len = state->end + 1 - state->start;
-		u32 num_extents = count_max_extents(len);
+		u32 num_extents = count_max_extents(fs_info, len);
 		bool do_list = !btrfs_is_free_space_inode(BTRFS_I(inode));
 
 		spin_lock(&BTRFS_I(inode)->lock);
@@ -2401,7 +2401,7 @@ void btrfs_clear_delalloc_extent(struct inode *vfs_inode,
 	struct btrfs_inode *inode = BTRFS_I(vfs_inode);
 	struct btrfs_fs_info *fs_info = btrfs_sb(vfs_inode->i_sb);
 	u64 len = state->end + 1 - state->start;
-	u32 num_extents = count_max_extents(len);
+	u32 num_extents = count_max_extents(fs_info, len);
 
 	if ((state->state & EXTENT_DEFRAG) && (*bits & EXTENT_DEFRAG)) {
 		spin_lock(&inode->lock);
-- 
2.35.1



