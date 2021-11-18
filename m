Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C84A1455789
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 09:59:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243644AbhKRJBp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 04:01:45 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:58261 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244902AbhKRJBf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Nov 2021 04:01:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1637225915; x=1668761915;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dOSKCxK1aH8xJIGccwj2MgufmxoL2N8c9WFbiBk9+wA=;
  b=fEimCknF3syxTFW2GyLLs7T7RyAfQ4JdQf/tZ/gFN5mrSxoJ3iZ0R0IB
   lRBPPo2wznYi6Jj90DaMaO93S9yCApYWh9L8DhC4giiqT7Q2Zu85zP/Wa
   CxuwpbavR4K6QsAZuTKMh3sTqzfjl/W4vgErQwrRErl9dAiewECoEW34Q
   ZvWjGDc+NbXhBizY1sE/v06PTQP382Jf4FaiK4W6JYZam+QcKe6eeG33J
   p4CgnGhecu328Yy/aCOGtzngbf/OEzKpIhDYE7QdDCyVCMALpfoAIAqQR
   yy7a49qmZnXR2Y3RyYomFf4KZvLWaIMqN2KI/lfIhUI7vzfcjgYLkqAhs
   A==;
X-IronPort-AV: E=Sophos;i="5.87,244,1631548800"; 
   d="scan'208";a="297759025"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 18 Nov 2021 16:58:27 +0800
IronPort-SDR: NS1DM0EHIwihAAn6R4+yoebFK0iXnLJSJAItK9+yTWyjikrmCqNF3pQk9L9JfOrmrJ3nGem1zE
 i8Y5FOgh5Vs8R+m3hILWmwggNuBpB9okGi3EvzKlSNuVjP7/y+h890ovHPCcrm37bTjpnA5vC8
 mgfRHBxmmO2tr0ySsOLYg61LP1BZavEGFFek39ZkLPqIWv2g4UhVxkHzQ2NfXsroSWAX6ItCRP
 KlsiZjrcCk0dT1dr8zqimSrqmPs0/7wpLc4BzVDCkgPbsD7jseAzv/3TPOsYbyR0hsOckuxUkC
 5uaMXlNZND7ePX9I0GshJXPd
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2021 00:33:28 -0800
IronPort-SDR: YeZsRl6IBZ/lg+ufIwmmjyUVS+2H3op1VEfif37JDOMe0/0y5m1607BVa4I8xn9fDDiobh8KlW
 tew+PljqihTjtbi4YlpoPTcKbh+BWMW4rQkSc6tGRUdMDGm+UqwK/7IduWuDFoLDaBwS88tJfR
 xNqu14v9Oudg0+d8ENUyRHTxJeGpsFLDfeVqQrGXek0Lr4+fvURxLAbhe7Pofnyn9gkhFT1+uR
 DDgYV/pWspPi5Vch5ZLXKS2Atcmi7fLXw8JwVNFJ5UUocfJY1P4+HLlM06qLHg2TQuAp4POSTw
 GKY=
WDCIronportException: Internal
Received: from unknown (HELO redsun60.ssa.fujisawa.hgst.com) ([10.149.66.36])
  by uls-op-cesaip01.wdc.com with ESMTP; 18 Nov 2021 00:58:25 -0800
From:   Johannes Thumshirn <johannes.thumshirn@wdc.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org,
        Naohiro Aota <naohiro.aota@wdc.com>,
        David Sterba <dsterba@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH for-5.15.x 1/6] btrfs: introduce btrfs_is_data_reloc_root
Date:   Thu, 18 Nov 2021 17:58:13 +0900
Message-Id: <04ade7dd079c065161302c626045a8a88d089d8d.1637225333.git.johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1637225333.git.johannes.thumshirn@wdc.com>
References: <cover.1637225333.git.johannes.thumshirn@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 37f00a6d2e9c97d6e7b5c3d47c49b714c3d0b99f upstream

There are several places in our codebase where we check if a root is the
root of the data reloc tree and subsequent patches will introduce more.

Factor out the check into a small helper function instead of open coding
it multiple times.

Reviewed-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/ctree.h       |  5 +++++
 fs/btrfs/disk-io.c     |  2 +-
 fs/btrfs/extent-tree.c |  2 +-
 fs/btrfs/inode.c       | 19 ++++++++-----------
 fs/btrfs/relocation.c  |  3 +--
 5 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index c0cebcf745ce..5b990881052c 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3842,6 +3842,11 @@ static inline bool btrfs_is_zoned(const struct btrfs_fs_info *fs_info)
 	return fs_info->zoned != 0;
 }
 
+static inline bool btrfs_is_data_reloc_root(const struct btrfs_root *root)
+{
+	return root->root_key.objectid == BTRFS_DATA_RELOC_TREE_OBJECTID;
+}
+
 /*
  * We use page status Private2 to indicate there is an ordered extent with
  * unfinished IO.
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 6965ed081346..f63d8a7e6dae 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1500,7 +1500,7 @@ static int btrfs_init_fs_root(struct btrfs_root *root, dev_t anon_dev)
 		goto fail;
 
 	if (root->root_key.objectid != BTRFS_TREE_LOG_OBJECTID &&
-	    root->root_key.objectid != BTRFS_DATA_RELOC_TREE_OBJECTID) {
+	    !btrfs_is_data_reloc_root(root)) {
 		set_bit(BTRFS_ROOT_SHAREABLE, &root->state);
 		btrfs_check_and_init_root_item(&root->root_item);
 	}
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 0ab456cb4bf8..45e020c9fdc9 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2376,7 +2376,7 @@ int btrfs_cross_ref_exist(struct btrfs_root *root, u64 objectid, u64 offset,
 
 out:
 	btrfs_free_path(path);
-	if (root->root_key.objectid == BTRFS_DATA_RELOC_TREE_OBJECTID)
+	if (btrfs_is_data_reloc_root(root))
 		WARN_ON(ret > 0);
 	return ret;
 }
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 7c096ab9bb5e..85663bccde8a 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1151,7 +1151,7 @@ static noinline int cow_file_range(struct btrfs_inode *inode,
 	 * fails during the stage where it updates the bytenr of file extent
 	 * items.
 	 */
-	if (root->root_key.objectid == BTRFS_DATA_RELOC_TREE_OBJECTID)
+	if (btrfs_is_data_reloc_root(root))
 		min_alloc_size = num_bytes;
 	else
 		min_alloc_size = fs_info->sectorsize;
@@ -1187,8 +1187,7 @@ static noinline int cow_file_range(struct btrfs_inode *inode,
 		if (ret)
 			goto out_drop_extent_cache;
 
-		if (root->root_key.objectid ==
-		    BTRFS_DATA_RELOC_TREE_OBJECTID) {
+		if (btrfs_is_data_reloc_root(root)) {
 			ret = btrfs_reloc_clone_csums(inode, start,
 						      cur_alloc_size);
 			/*
@@ -1504,8 +1503,7 @@ static int fallback_to_cow(struct btrfs_inode *inode, struct page *locked_page,
 			   int *page_started, unsigned long *nr_written)
 {
 	const bool is_space_ino = btrfs_is_free_space_inode(inode);
-	const bool is_reloc_ino = (inode->root->root_key.objectid ==
-				   BTRFS_DATA_RELOC_TREE_OBJECTID);
+	const bool is_reloc_ino = btrfs_is_data_reloc_root(inode->root);
 	const u64 range_bytes = end + 1 - start;
 	struct extent_io_tree *io_tree = &inode->io_tree;
 	u64 range_start = start;
@@ -1867,8 +1865,7 @@ static noinline int run_delalloc_nocow(struct btrfs_inode *inode,
 			btrfs_dec_nocow_writers(fs_info, disk_bytenr);
 		nocow = false;
 
-		if (root->root_key.objectid ==
-		    BTRFS_DATA_RELOC_TREE_OBJECTID)
+		if (btrfs_is_data_reloc_root(root))
 			/*
 			 * Error handled later, as we must prevent
 			 * extent_clear_unlock_delalloc() in error handler
@@ -2207,7 +2204,7 @@ void btrfs_clear_delalloc_extent(struct inode *vfs_inode,
 		if (btrfs_is_testing(fs_info))
 			return;
 
-		if (root->root_key.objectid != BTRFS_DATA_RELOC_TREE_OBJECTID &&
+		if (!btrfs_is_data_reloc_root(root) &&
 		    do_list && !(state->state & EXTENT_NORESERVE) &&
 		    (*bits & EXTENT_CLEAR_DATA_RESV))
 			btrfs_free_reserved_data_space_noquota(fs_info, len);
@@ -2532,7 +2529,7 @@ blk_status_t btrfs_submit_data_bio(struct inode *inode, struct bio *bio,
 		goto mapit;
 	} else if (async && !skip_sum) {
 		/* csum items have already been cloned */
-		if (root->root_key.objectid == BTRFS_DATA_RELOC_TREE_OBJECTID)
+		if (btrfs_is_data_reloc_root(root))
 			goto mapit;
 		/* we're doing a write, do the async checksumming */
 		ret = btrfs_wq_submit_bio(inode, bio, mirror_num, bio_flags,
@@ -3304,7 +3301,7 @@ unsigned int btrfs_verify_data_csum(struct btrfs_io_bio *io_bio, u32 bio_offset,
 		u64 file_offset = pg_off + page_offset(page);
 		int ret;
 
-		if (root->root_key.objectid == BTRFS_DATA_RELOC_TREE_OBJECTID &&
+		if (btrfs_is_data_reloc_root(root) &&
 		    test_range_bit(io_tree, file_offset,
 				   file_offset + sectorsize - 1,
 				   EXTENT_NODATASUM, 1, NULL)) {
@@ -4005,7 +4002,7 @@ noinline int btrfs_update_inode(struct btrfs_trans_handle *trans,
 	 * without delay
 	 */
 	if (!btrfs_is_free_space_inode(inode)
-	    && root->root_key.objectid != BTRFS_DATA_RELOC_TREE_OBJECTID
+	    && !btrfs_is_data_reloc_root(root)
 	    && !test_bit(BTRFS_FS_LOG_RECOVERING, &fs_info->flags)) {
 		btrfs_update_root_times(trans, root);
 
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 914d403b4415..2e4f109723af 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4386,8 +4386,7 @@ int btrfs_reloc_cow_block(struct btrfs_trans_handle *trans,
 	if (!rc)
 		return 0;
 
-	BUG_ON(rc->stage == UPDATE_DATA_PTRS &&
-	       root->root_key.objectid == BTRFS_DATA_RELOC_TREE_OBJECTID);
+	BUG_ON(rc->stage == UPDATE_DATA_PTRS && btrfs_is_data_reloc_root(root));
 
 	level = btrfs_header_level(buf);
 	if (btrfs_header_generation(buf) <=
-- 
2.32.0

