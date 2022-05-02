Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E846E5175AD
	for <lists+stable@lfdr.de>; Mon,  2 May 2022 19:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386657AbiEBRWs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 May 2022 13:22:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378055AbiEBRWp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 May 2022 13:22:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A7DBA1B3
        for <stable@vger.kernel.org>; Mon,  2 May 2022 10:19:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D12E7613FB
        for <stable@vger.kernel.org>; Mon,  2 May 2022 17:19:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33AEBC385B1;
        Mon,  2 May 2022 17:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651511955;
        bh=c5MuQ/JXRiVLbhhiyknX1S3uoFCryf9542M7F64eTww=;
        h=Subject:To:Cc:From:Date:From;
        b=fgjkD5Yz5Wh+9nwQC2Zk5ebKNd8zPp9nb9t1WwQkFhA1fy2v3LKBwohoUHISOZXkV
         BP+xdZsy99+okYZiYh+jGvKbSz+9i4M8Hn7q+2y6SE+GZtQxLceMppKTjc8Xg4ghH/
         P7CnsaRiTlRO6MU5BafJVkmINVP5lCDzdEsqTwqc=
Subject: FAILED: patch "[PATCH] btrfs: zoned: use dedicated lock for data relocation" failed to apply to 5.15-stable tree
To:     naohiro.aota@wdc.com, dsterba@suse.com, johannes.thumshirn@wdc.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 02 May 2022 19:19:10 +0200
Message-ID: <165151195021699@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 5f0addf7b89085f8e0a2593faa419d6111612b9b Mon Sep 17 00:00:00 2001
From: Naohiro Aota <naohiro.aota@wdc.com>
Date: Mon, 18 Apr 2022 16:15:03 +0900
Subject: [PATCH] btrfs: zoned: use dedicated lock for data relocation

Currently, we use btrfs_inode_{lock,unlock}() to grant an exclusive
writeback of the relocation data inode in
btrfs_zoned_data_reloc_{lock,unlock}(). However, that can cause a deadlock
in the following path.

Thread A takes btrfs_inode_lock() and waits for metadata reservation by
e.g, waiting for writeback:

prealloc_file_extent_cluster()
  - btrfs_inode_lock(&inode->vfs_inode, 0);
  - btrfs_prealloc_file_range()
  ...
    - btrfs_replace_file_extents()
      - btrfs_start_transaction
      ...
        - btrfs_reserve_metadata_bytes()

Thread B (e.g, doing a writeback work) needs to wait for the inode lock to
continue writeback process:

do_writepages
  - btrfs_writepages
    - extent_writpages
      - btrfs_zoned_data_reloc_lock(BTRFS_I(inode));
        - btrfs_inode_lock()

The deadlock is caused by relying on the vfs_inode's lock. By using it, we
introduced unnecessary exclusion of writeback and
btrfs_prealloc_file_range(). Also, the lock at this point is useless as we
don't have any dirty pages in the inode yet.

Introduce fs_info->zoned_data_reloc_io_lock and use it for the exclusive
writeback.

Fixes: 35156d852762 ("btrfs: zoned: only allow one process to add pages to a relocation inode")
CC: stable@vger.kernel.org # 5.16.x: 869f4cdc73f9: btrfs: zoned: encapsulate inode locking for zoned relocation
CC: stable@vger.kernel.org # 5.16.x
CC: stable@vger.kernel.org # 5.17
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 4db17bd05a21..604a4d54cf0d 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1060,6 +1060,7 @@ struct btrfs_fs_info {
 	 */
 	spinlock_t relocation_bg_lock;
 	u64 data_reloc_bg;
+	struct mutex zoned_data_reloc_io_lock;
 
 	u64 nr_global_roots;
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index cebd7a78c964..20e70eb88465 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3156,6 +3156,7 @@ void btrfs_init_fs_info(struct btrfs_fs_info *fs_info)
 	mutex_init(&fs_info->reloc_mutex);
 	mutex_init(&fs_info->delalloc_root_mutex);
 	mutex_init(&fs_info->zoned_meta_io_lock);
+	mutex_init(&fs_info->zoned_data_reloc_io_lock);
 	seqlock_init(&fs_info->profiles_lock);
 
 	INIT_LIST_HEAD(&fs_info->dirty_cowonly_roots);
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index cbf016a7bb5d..6dee76248cb4 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -359,7 +359,7 @@ static inline void btrfs_zoned_data_reloc_lock(struct btrfs_inode *inode)
 	struct btrfs_root *root = inode->root;
 
 	if (btrfs_is_data_reloc_root(root) && btrfs_is_zoned(root->fs_info))
-		btrfs_inode_lock(&inode->vfs_inode, 0);
+		mutex_lock(&root->fs_info->zoned_data_reloc_io_lock);
 }
 
 static inline void btrfs_zoned_data_reloc_unlock(struct btrfs_inode *inode)
@@ -367,7 +367,7 @@ static inline void btrfs_zoned_data_reloc_unlock(struct btrfs_inode *inode)
 	struct btrfs_root *root = inode->root;
 
 	if (btrfs_is_data_reloc_root(root) && btrfs_is_zoned(root->fs_info))
-		btrfs_inode_unlock(&inode->vfs_inode, 0);
+		mutex_unlock(&root->fs_info->zoned_data_reloc_io_lock);
 }
 
 #endif

