Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5461E56FD2F
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233948AbiGKJvh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:51:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233809AbiGKJui (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:50:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7C50248FF;
        Mon, 11 Jul 2022 02:24:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E6B66112E;
        Mon, 11 Jul 2022 09:24:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 633D7C341C0;
        Mon, 11 Jul 2022 09:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531496;
        bh=yZtrHS6oc+q1zJ4xFjTvui4hoYjxxt2NUH81KemFZrI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sYT2OHsaeYfS9NUWDXqu8O/qxAN7rXGPM7/ujrxr+waDRqnpkUrosrtoJVvuhocn+
         7W38AwrD/95Bb0R/aMj7KakiOzyV+3VdZjJ6W8pYB3NYg6ouG1ZokZRQ7wHZ1eXT++
         Pe4DmHSFRpBdTKfJrvSk59tmh/faQbBjSImgwyQk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Naohiro Aota <naohiro.aota@wdc.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 125/230] btrfs: zoned: use dedicated lock for data relocation
Date:   Mon, 11 Jul 2022 11:06:21 +0200
Message-Id: <20220711090607.610632602@linuxfoundation.org>
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

From: Naohiro Aota <naohiro.aota@wdc.com>

[ Upstream commit 5f0addf7b89085f8e0a2593faa419d6111612b9b ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ctree.h   | 1 +
 fs/btrfs/disk-io.c | 1 +
 fs/btrfs/zoned.h   | 4 ++--
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index cc72d8981c47..d1838de0b39c 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1027,6 +1027,7 @@ struct btrfs_fs_info {
 	 */
 	spinlock_t relocation_bg_lock;
 	u64 data_reloc_bg;
+	struct mutex zoned_data_reloc_io_lock;
 
 #ifdef CONFIG_BTRFS_FS_REF_VERIFY
 	spinlock_t ref_verify_lock;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 233d894f6feb..909d19656316 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2914,6 +2914,7 @@ void btrfs_init_fs_info(struct btrfs_fs_info *fs_info)
 	mutex_init(&fs_info->reloc_mutex);
 	mutex_init(&fs_info->delalloc_root_mutex);
 	mutex_init(&fs_info->zoned_meta_io_lock);
+	mutex_init(&fs_info->zoned_data_reloc_io_lock);
 	seqlock_init(&fs_info->profiles_lock);
 
 	INIT_LIST_HEAD(&fs_info->dirty_cowonly_roots);
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index d680c3ee918a..3a826f7c2040 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -330,7 +330,7 @@ static inline void btrfs_zoned_data_reloc_lock(struct btrfs_inode *inode)
 	struct btrfs_root *root = inode->root;
 
 	if (btrfs_is_data_reloc_root(root) && btrfs_is_zoned(root->fs_info))
-		btrfs_inode_lock(&inode->vfs_inode, 0);
+		mutex_lock(&root->fs_info->zoned_data_reloc_io_lock);
 }
 
 static inline void btrfs_zoned_data_reloc_unlock(struct btrfs_inode *inode)
@@ -338,7 +338,7 @@ static inline void btrfs_zoned_data_reloc_unlock(struct btrfs_inode *inode)
 	struct btrfs_root *root = inode->root;
 
 	if (btrfs_is_data_reloc_root(root) && btrfs_is_zoned(root->fs_info))
-		btrfs_inode_unlock(&inode->vfs_inode, 0);
+		mutex_unlock(&root->fs_info->zoned_data_reloc_io_lock);
 }
 
 #endif
-- 
2.35.1



