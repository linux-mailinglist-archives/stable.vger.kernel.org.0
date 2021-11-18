Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B559145578C
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 09:59:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244930AbhKRJBq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 04:01:46 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:5639 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244889AbhKRJBg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Nov 2021 04:01:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1637225916; x=1668761916;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Wu2mkK4/Z0F4flcQj1uMXgMl1r5L0y+zLwmcRny/fy4=;
  b=p7U/xkZCZ5EPwWBcU9b/2H3E+0Vp/0oenZMxZq7X++0H/89tFb3agDRO
   krOU8/AkvVN4nI8AFfnn/M/QoAWB9UCJ8jn2grDx+N1/rkaRXeHXcpG36
   sh8Ieouow7hgn9i7diEXxFoxJJXpK+bfne7xjGZ7ejTFX1OI42sPzPwkN
   yU8V8G/EqodvoOFyuU3KC8QlBB8Mrf5CJsuNGL2Xdm+g0O6IyY8qryW0i
   C045VtH5GS8Y3gZ/HPgNaF6knFziAF9tUlaGdDzchSqVH06QbacS7KCgj
   EceTph8gKuIu6XAit4sb3hZPCYUP7o0RviVuVMK4kzMh1364BoxugWBu+
   w==;
X-IronPort-AV: E=Sophos;i="5.87,244,1631548800"; 
   d="scan'208";a="190749233"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 18 Nov 2021 16:58:35 +0800
IronPort-SDR: Uc3iC6tkv5qANKHZurNBsTz83hXrizF+tVQwvgw2D0ctQrrYfg7yy1Jnftwn18dxRNLHOHG5+w
 NiWUE/rOSFJOs6MEn3HRlBjCeUdIozhtTitD7gvVI2VJyRK97QVyPD4CXjzfNUng5icXlaL3WZ
 RRi8ucoaU0k7/d+Sp9p8LfoNTjvNwZ+1cdTXSUuGA9O+hRHthrCa3+hxOTPMJ2deLLVLPdDZzc
 fFjLqA21Hejg/wFb19qSAXFRZZKAIPSNMHA9qs9SiKKUiS+izXXBWc/nsjB/LyaeHx6fcxosE9
 WgB/0dvFqQ3SujGyKkkkjQaC
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2021 00:33:35 -0800
IronPort-SDR: a+ACesNdo6aT5hgn6ZymbZqFIY9ebIZiuhT6TTa+CaH5OD6QiDdsacQSeNu+7oAJlpHKabKS6b
 ULZDJCiuL5gW2GrBksLKTjCoWbpSZTU7s5Z4nos6TetO3Rj2AcC3vggD9Y+2a8+J8/T0h3teEu
 7NumzHqbnr3QoE5alKn3+TtZr7Qr7NA3ByTRDynOLVkbhILO/BhVapqH4tCE/pqzFRB2qD7yR7
 KcfsUJ7ej68I70LU65tzfDAtFY4zSLLKdVjqqF+zuqLCmFnj7KlfiQiy7qlXfvMhHgbFV+7rOx
 Atg=
WDCIronportException: Internal
Received: from unknown (HELO redsun60.ssa.fujisawa.hgst.com) ([10.149.66.36])
  by uls-op-cesaip01.wdc.com with ESMTP; 18 Nov 2021 00:58:33 -0800
From:   Johannes Thumshirn <johannes.thumshirn@wdc.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org,
        Naohiro Aota <naohiro.aota@wdc.com>,
        David Sterba <dsterba@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH for-5.15.x 6/6] btrfs: zoned: allow preallocation for relocation inodes
Date:   Thu, 18 Nov 2021 17:58:18 +0900
Message-Id: <f53fa091456972561fc4abce280bc5773dbe8254.1637225333.git.johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1637225333.git.johannes.thumshirn@wdc.com>
References: <cover.1637225333.git.johannes.thumshirn@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 960a3166aed015887cd54423a6589ae4d0b65bd5 upstream

Now that we use a dedicated block group and regular writes for data
relocation, we can preallocate the space needed for a relocated inode,
just like we do in regular mode.

Essentially this reverts commit 32430c614844 ("btrfs: zoned: enable
relocation on a zoned filesystem") as it is not needed anymore.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/relocation.c | 35 ++---------------------------------
 1 file changed, 2 insertions(+), 33 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 2e4f109723af..d81bee621d37 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2852,31 +2852,6 @@ static noinline_for_stack int prealloc_file_extent_cluster(
 	if (ret)
 		return ret;
 
-	/*
-	 * On a zoned filesystem, we cannot preallocate the file region.
-	 * Instead, we dirty and fiemap_write the region.
-	 */
-	if (btrfs_is_zoned(inode->root->fs_info)) {
-		struct btrfs_root *root = inode->root;
-		struct btrfs_trans_handle *trans;
-
-		end = cluster->end - offset + 1;
-		trans = btrfs_start_transaction(root, 1);
-		if (IS_ERR(trans))
-			return PTR_ERR(trans);
-
-		inode->vfs_inode.i_ctime = current_time(&inode->vfs_inode);
-		i_size_write(&inode->vfs_inode, end);
-		ret = btrfs_update_inode(trans, root, inode);
-		if (ret) {
-			btrfs_abort_transaction(trans, ret);
-			btrfs_end_transaction(trans);
-			return ret;
-		}
-
-		return btrfs_end_transaction(trans);
-	}
-
 	btrfs_inode_lock(&inode->vfs_inode, 0);
 	for (nr = 0; nr < cluster->nr; nr++) {
 		start = cluster->boundary[nr] - offset;
@@ -3084,7 +3059,6 @@ static int relocate_one_page(struct inode *inode, struct file_ra_state *ra,
 static int relocate_file_extent_cluster(struct inode *inode,
 					struct file_extent_cluster *cluster)
 {
-	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	u64 offset = BTRFS_I(inode)->index_cnt;
 	unsigned long index;
 	unsigned long last_index;
@@ -3114,8 +3088,6 @@ static int relocate_file_extent_cluster(struct inode *inode,
 	for (index = (cluster->start - offset) >> PAGE_SHIFT;
 	     index <= last_index && !ret; index++)
 		ret = relocate_one_page(inode, ra, cluster, &cluster_nr, index);
-	if (btrfs_is_zoned(fs_info) && !ret)
-		ret = btrfs_wait_ordered_range(inode, 0, (u64)-1);
 	if (ret == 0)
 		WARN_ON(cluster_nr != cluster->nr);
 out:
@@ -3770,12 +3742,8 @@ static int __insert_orphan_inode(struct btrfs_trans_handle *trans,
 	struct btrfs_path *path;
 	struct btrfs_inode_item *item;
 	struct extent_buffer *leaf;
-	u64 flags = BTRFS_INODE_NOCOMPRESS | BTRFS_INODE_PREALLOC;
 	int ret;
 
-	if (btrfs_is_zoned(trans->fs_info))
-		flags &= ~BTRFS_INODE_PREALLOC;
-
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
@@ -3790,7 +3758,8 @@ static int __insert_orphan_inode(struct btrfs_trans_handle *trans,
 	btrfs_set_inode_generation(leaf, item, 1);
 	btrfs_set_inode_size(leaf, item, 0);
 	btrfs_set_inode_mode(leaf, item, S_IFREG | 0600);
-	btrfs_set_inode_flags(leaf, item, flags);
+	btrfs_set_inode_flags(leaf, item, BTRFS_INODE_NOCOMPRESS |
+					  BTRFS_INODE_PREALLOC);
 	btrfs_mark_buffer_dirty(leaf);
 out:
 	btrfs_free_path(path);
-- 
2.32.0

