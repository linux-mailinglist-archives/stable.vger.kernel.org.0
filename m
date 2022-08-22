Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 049A659B902
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 08:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232550AbiHVGHh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 02:07:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232684AbiHVGHg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 02:07:36 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02FEB2654F;
        Sun, 21 Aug 2022 23:07:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1661148454; x=1692684454;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lUs7q7deSsOOqxioRxIXgetMwUWmkuQT+pTVOxyBoAU=;
  b=HSpm3UBWJfedakxd1HBZNNrYAqnJEtgVVFd9s923fU37gvXYTD+dmJrN
   NxN+fR2htTcOz5gexgCwhlJKXpNK6arJgnl/FC+/TrDM2z0F9Myt+w4Ib
   hUamf9x09CqmFYZBqkd6ryaioF/qHld8h/SOVgu+a14Z9D6DaQr7uz2h8
   NrzzhJgSAUkUgd0ivAbAPuBTQi9zVEQFL8nvk+7vLa+NdHAP4ttqdzU+q
   dch6es7Wm5JDVOn9zqQO4w8isFwlFyPyA0LIeRjo3I2oe+jzl8vzdKW0C
   yejuqF/evE8mjuBGS6frqXZQY85zC36RZ/GHHQNFxbaY30lz2oKZG3K92
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,254,1654531200"; 
   d="scan'208";a="321397078"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 22 Aug 2022 14:07:34 +0800
IronPort-SDR: iSj37ZPvmCVWsFGbCL9TApEPZmgX1Utl8GAn22J6fSFHKiRW1lIpZst5okWaBrgrEN0CjuK0Pn
 h4Z1XS6rOFhQwi3SA/SYQj1Za6AFsAFjUeNQa5LukDM6DMbLuxiNY+TneA0F3EWW0csqOMGbzr
 qqRSeoruVBJI59FpS9aAIYGUQP9/FyaFnJqWd0+maEBRyO4L4pb0Mo3gQRW33/DwwCiJw0ARR9
 VuS4Zp06nPo9ek4ZMD9/itQGvHrnpoJUZWhPIdfouQWrMLnD4YhXXt1y6m9gmSAUaDxkrOqiMn
 zMi5MIOVWj4+QckO5DRhCYpH
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Aug 2022 22:28:16 -0700
IronPort-SDR: uSap/AO9oL7HvxUH324IelDFAViW8OfMdedNZql9h9H5D+T+dMnLPMnRsEJukXD3nx5nshj5oV
 btm4rPLD52x4qBF5gJ18XsK+CPnVfxP8WGhx0aQaSoK1kAMeiwpDyRbAtSMOOkgBO3zQm8PEs4
 /WTH14B8YmWM89ttRBxB89xHhj0NdLXO7pJlgdSXSf5sX+E7SDgWeEBgNGRM33G6eC6hTXQNT/
 dEiLq5S6hNoHJzNN088z0Jgs+KRAuooDD+aEkYWre+Pa9NRXsArofNvIuAqBTGs/NU4lANkRTY
 KLA=
WDCIronportException: Internal
Received: from unknown (HELO naota-xeon.wdc.com) ([10.225.50.191])
  by uls-op-cesaip02.wdc.com with ESMTP; 21 Aug 2022 23:07:33 -0700
From:   Naohiro Aota <naohiro.aota@wdc.com>
To:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Cc:     Naohiro Aota <naohiro.aota@wdc.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH STABLE 5.15 5/5] btrfs: convert count_max_extents() to use fs_info->max_extent_size
Date:   Mon, 22 Aug 2022 15:07:04 +0900
Message-Id: <20220822060704.1278361-6-naohiro.aota@wdc.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220822060704.1278361-1-naohiro.aota@wdc.com>
References: <20220822060704.1278361-1-naohiro.aota@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 7d7672bc5d1038c745716c397d892d21e29de71c upstream

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
---
 fs/btrfs/ctree.h          | 21 +++++++++++++--------
 fs/btrfs/delalloc-space.c |  6 +++---
 fs/btrfs/inode.c          | 16 ++++++++--------
 3 files changed, 24 insertions(+), 19 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index e751eb1b5514..1831135fef1a 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -105,14 +105,6 @@ struct btrfs_ref;
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
@@ -3878,6 +3870,19 @@ static inline bool btrfs_is_zoned(const struct btrfs_fs_info *fs_info)
 	return fs_info->zoned != 0;
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
index 40c4d6ba3fb9..b934429c2435 100644
--- a/fs/btrfs/delalloc-space.c
+++ b/fs/btrfs/delalloc-space.c
@@ -273,7 +273,7 @@ static void calc_inode_reservations(struct btrfs_fs_info *fs_info,
 				    u64 num_bytes, u64 *meta_reserve,
 				    u64 *qgroup_reserve)
 {
-	u64 nr_extents = count_max_extents(num_bytes);
+	u64 nr_extents = count_max_extents(fs_info, num_bytes);
 	u64 csum_leaves = btrfs_csum_bytes_to_leaves(fs_info, num_bytes);
 	u64 inode_update = btrfs_calc_metadata_size(fs_info, 1);
 
@@ -347,7 +347,7 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes)
 	 * needs to free the reservation we just made.
 	 */
 	spin_lock(&inode->lock);
-	nr_extents = count_max_extents(num_bytes);
+	nr_extents = count_max_extents(fs_info, num_bytes);
 	btrfs_mod_outstanding_extents(inode, nr_extents);
 	inode->csum_bytes += num_bytes;
 	btrfs_calculate_inode_block_rsv_size(fs_info, inode);
@@ -410,7 +410,7 @@ void btrfs_delalloc_release_extents(struct btrfs_inode *inode, u64 num_bytes)
 	unsigned num_extents;
 
 	spin_lock(&inode->lock);
-	num_extents = count_max_extents(num_bytes);
+	num_extents = count_max_extents(fs_info, num_bytes);
 	btrfs_mod_outstanding_extents(inode, -num_extents);
 	btrfs_calculate_inode_block_rsv_size(fs_info, inode);
 	spin_unlock(&inode->lock);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 91417cdbf70d..ac6ba984973c 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2049,10 +2049,10 @@ void btrfs_split_delalloc_extent(struct inode *inode,
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
 
@@ -2109,10 +2109,10 @@ void btrfs_merge_delalloc_extent(struct inode *inode, struct extent_state *new,
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
@@ -2191,7 +2191,7 @@ void btrfs_set_delalloc_extent(struct inode *inode, struct extent_state *state,
 	if (!(state->state & EXTENT_DELALLOC) && (*bits & EXTENT_DELALLOC)) {
 		struct btrfs_root *root = BTRFS_I(inode)->root;
 		u64 len = state->end + 1 - state->start;
-		u32 num_extents = count_max_extents(len);
+		u32 num_extents = count_max_extents(fs_info, len);
 		bool do_list = !btrfs_is_free_space_inode(BTRFS_I(inode));
 
 		spin_lock(&BTRFS_I(inode)->lock);
@@ -2233,7 +2233,7 @@ void btrfs_clear_delalloc_extent(struct inode *vfs_inode,
 	struct btrfs_inode *inode = BTRFS_I(vfs_inode);
 	struct btrfs_fs_info *fs_info = btrfs_sb(vfs_inode->i_sb);
 	u64 len = state->end + 1 - state->start;
-	u32 num_extents = count_max_extents(len);
+	u32 num_extents = count_max_extents(fs_info, len);
 
 	if ((state->state & EXTENT_DEFRAG) && (*bits & EXTENT_DEFRAG)) {
 		spin_lock(&inode->lock);
-- 
2.37.2

