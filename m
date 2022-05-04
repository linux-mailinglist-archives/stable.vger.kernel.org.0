Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BDD451AA42
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356412AbiEDRWc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:22:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357531AbiEDRPG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:15:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9906354FAA;
        Wed,  4 May 2022 09:58:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 19B8C61770;
        Wed,  4 May 2022 16:58:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67248C385A5;
        Wed,  4 May 2022 16:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683519;
        bh=avrp5V52/RWBvb9OIRTAiIAQJ114dZ8pv4NK9C94dDQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o5tJr5gS2xUa0HfD7rPDK+AHxZG2QgQ+G3JDNFuJQjTtVL4+Mi0d6I9J29JvjapgR
         S3YjT5jk0kD8s2XFjntupBZ7hC7UDTTAcvBF/8oD3s5IEJvikkwrFZStWKLphPQw8C
         nRxJbdUxPupNYBPDLM4tBsDzvJ3IwN6HUcKxX+Jc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Naohiro Aota <naohiro.aota@wdc.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.17 194/225] btrfs: zoned: use dedicated lock for data relocation
Date:   Wed,  4 May 2022 18:47:12 +0200
Message-Id: <20220504153127.535820605@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
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

commit 5f0addf7b89085f8e0a2593faa419d6111612b9b upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ctree.h   |    1 +
 fs/btrfs/disk-io.c |    1 +
 fs/btrfs/zoned.h   |    4 ++--
 3 files changed, 4 insertions(+), 2 deletions(-)

--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1029,6 +1029,7 @@ struct btrfs_fs_info {
 	 */
 	spinlock_t relocation_bg_lock;
 	u64 data_reloc_bg;
+	struct mutex zoned_data_reloc_io_lock;
 
 	spinlock_t zone_active_bgs_lock;
 	struct list_head zone_active_bgs;
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3068,6 +3068,7 @@ void btrfs_init_fs_info(struct btrfs_fs_
 	mutex_init(&fs_info->reloc_mutex);
 	mutex_init(&fs_info->delalloc_root_mutex);
 	mutex_init(&fs_info->zoned_meta_io_lock);
+	mutex_init(&fs_info->zoned_data_reloc_io_lock);
 	seqlock_init(&fs_info->profiles_lock);
 
 	INIT_LIST_HEAD(&fs_info->dirty_cowonly_roots);
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -359,7 +359,7 @@ static inline void btrfs_zoned_data_relo
 	struct btrfs_root *root = inode->root;
 
 	if (btrfs_is_data_reloc_root(root) && btrfs_is_zoned(root->fs_info))
-		btrfs_inode_lock(&inode->vfs_inode, 0);
+		mutex_lock(&root->fs_info->zoned_data_reloc_io_lock);
 }
 
 static inline void btrfs_zoned_data_reloc_unlock(struct btrfs_inode *inode)
@@ -367,7 +367,7 @@ static inline void btrfs_zoned_data_relo
 	struct btrfs_root *root = inode->root;
 
 	if (btrfs_is_data_reloc_root(root) && btrfs_is_zoned(root->fs_info))
-		btrfs_inode_unlock(&inode->vfs_inode, 0);
+		mutex_unlock(&root->fs_info->zoned_data_reloc_io_lock);
 }
 
 #endif


