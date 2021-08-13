Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A23A33EB89D
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 17:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241890AbhHMPOw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 11:14:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:55830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242306AbhHMPN6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 11:13:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 38CA1610CF;
        Fri, 13 Aug 2021 15:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628867599;
        bh=VBGyfnUg6DGOxMfJcdM3Weayrc0snt2lcM+yQmYYt/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nBi2ivddyQ22gObxyqn+sMmCxb5npdzHanwx3aqy5MegwlLxcOQ7zw2od2TNI681y
         MU2DPGCHymJIWO3uYC9NRzCwAyAT3sRmHuZLUPsZJCyhRiDrU4nVxafbDEApLe3Ejx
         TfTy+5keL/oaZARGSc+5TRYxVytKGeOF8wEVSJvk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 5.4 18/27] btrfs: make btrfs_qgroup_reserve_data take btrfs_inode
Date:   Fri, 13 Aug 2021 17:07:16 +0200
Message-Id: <20210813150523.965889074@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210813150523.364549385@linuxfoundation.org>
References: <20210813150523.364549385@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikolay Borisov <nborisov@suse.com>

commit 7661a3e033ab782366e0e1f4b6aad0df3555fcbd upstream

There's only a single use of vfs_inode in a tracepoint so let's take
btrfs_inode directly.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/delalloc-space.c |    2 +-
 fs/btrfs/file.c           |    7 ++++---
 fs/btrfs/qgroup.c         |   10 +++++-----
 fs/btrfs/qgroup.h         |    2 +-
 4 files changed, 11 insertions(+), 10 deletions(-)

--- a/fs/btrfs/delalloc-space.c
+++ b/fs/btrfs/delalloc-space.c
@@ -151,7 +151,7 @@ int btrfs_check_data_free_space(struct i
 		return ret;
 
 	/* Use new btrfs_qgroup_reserve_data to reserve precious data space. */
-	ret = btrfs_qgroup_reserve_data(inode, reserved, start, len);
+	ret = btrfs_qgroup_reserve_data(BTRFS_I(inode), reserved, start, len);
 	if (ret < 0)
 		btrfs_free_reserved_data_space_noquota(inode, start, len);
 	else
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -3149,7 +3149,7 @@ reserve_space:
 						  &cached_state);
 		if (ret)
 			goto out;
-		ret = btrfs_qgroup_reserve_data(inode, &data_reserved,
+		ret = btrfs_qgroup_reserve_data(BTRFS_I(inode), &data_reserved,
 						alloc_start, bytes_to_reserve);
 		if (ret) {
 			unlock_extent_cached(&BTRFS_I(inode)->io_tree, lockstart,
@@ -3322,8 +3322,9 @@ static long btrfs_fallocate(struct file
 				free_extent_map(em);
 				break;
 			}
-			ret = btrfs_qgroup_reserve_data(inode, &data_reserved,
-					cur_offset, last_byte - cur_offset);
+			ret = btrfs_qgroup_reserve_data(BTRFS_I(inode),
+					&data_reserved, cur_offset,
+					last_byte - cur_offset);
 			if (ret < 0) {
 				cur_offset = last_byte;
 				free_extent_map(em);
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -3425,11 +3425,11 @@ btrfs_qgroup_rescan_resume(struct btrfs_
  *       same @reserved, caller must ensure when error happens it's OK
  *       to free *ALL* reserved space.
  */
-int btrfs_qgroup_reserve_data(struct inode *inode,
+int btrfs_qgroup_reserve_data(struct btrfs_inode *inode,
 			struct extent_changeset **reserved_ret, u64 start,
 			u64 len)
 {
-	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_root *root = inode->root;
 	struct ulist_node *unode;
 	struct ulist_iterator uiter;
 	struct extent_changeset *reserved;
@@ -3452,12 +3452,12 @@ int btrfs_qgroup_reserve_data(struct ino
 	reserved = *reserved_ret;
 	/* Record already reserved space */
 	orig_reserved = reserved->bytes_changed;
-	ret = set_record_extent_bits(&BTRFS_I(inode)->io_tree, start,
+	ret = set_record_extent_bits(&inode->io_tree, start,
 			start + len -1, EXTENT_QGROUP_RESERVED, reserved);
 
 	/* Newly reserved space */
 	to_reserve = reserved->bytes_changed - orig_reserved;
-	trace_btrfs_qgroup_reserve_data(inode, start, len,
+	trace_btrfs_qgroup_reserve_data(&inode->vfs_inode, start, len,
 					to_reserve, QGROUP_RESERVE);
 	if (ret < 0)
 		goto cleanup;
@@ -3471,7 +3471,7 @@ cleanup:
 	/* cleanup *ALL* already reserved ranges */
 	ULIST_ITER_INIT(&uiter);
 	while ((unode = ulist_next(&reserved->range_changed, &uiter)))
-		clear_extent_bit(&BTRFS_I(inode)->io_tree, unode->val,
+		clear_extent_bit(&inode->io_tree, unode->val,
 				 unode->aux, EXTENT_QGROUP_RESERVED, 0, 0, NULL);
 	/* Also free data bytes of already reserved one */
 	btrfs_qgroup_free_refroot(root->fs_info, root->root_key.objectid,
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -344,7 +344,7 @@ int btrfs_verify_qgroup_counts(struct bt
 #endif
 
 /* New io_tree based accurate qgroup reserve API */
-int btrfs_qgroup_reserve_data(struct inode *inode,
+int btrfs_qgroup_reserve_data(struct btrfs_inode *inode,
 			struct extent_changeset **reserved, u64 start, u64 len);
 int btrfs_qgroup_release_data(struct inode *inode, u64 start, u64 len);
 int btrfs_qgroup_free_data(struct inode *inode,


