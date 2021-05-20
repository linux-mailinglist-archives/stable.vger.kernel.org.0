Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACDEB38A595
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236561AbhETKRg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:17:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:48688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231841AbhETKPe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:15:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF36F6199F;
        Thu, 20 May 2021 09:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503950;
        bh=vLfRw2WTNjqjJkMLxt8NVWiaJ6QLsHZqxHasHhARcSk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p+6iBd0sPJ+EdoTtXqUpnvotX9cu3gDzqe8wDyQMrL67kRo2p5+WYJ0jH0AL6nvW0
         WfKjBIV1F4Wizvhpm1xhCY+68DGhg87dWWYbcDBnIUrpg1S6JIjZ2tUDPDSNakRiFq
         k/fpe/0pkhwEMDwj7/OvVpTnqPY+blCczrQ3XpHI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.14 027/323] btrfs: fix metadata extent leak after failure to create subvolume
Date:   Thu, 20 May 2021 11:18:39 +0200
Message-Id: <20210520092121.036985364@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit 67addf29004c5be9fa0383c82a364bb59afc7f84 upstream.

When creating a subvolume we allocate an extent buffer for its root node
after starting a transaction. We setup a root item for the subvolume that
points to that extent buffer and then attempt to insert the root item into
the root tree - however if that fails, due to ENOMEM for example, we do
not free the extent buffer previously allocated and we do not abort the
transaction (as at that point we did nothing that can not be undone).

This means that we effectively do not return the metadata extent back to
the free space cache/tree and we leave a delayed reference for it which
causes a metadata extent item to be added to the extent tree, in the next
transaction commit, without having backreferences. When this happens
'btrfs check' reports the following:

  $ btrfs check /dev/sdi
  Opening filesystem to check...
  Checking filesystem on /dev/sdi
  UUID: dce2cb9d-025f-4b05-a4bf-cee0ad3785eb
  [1/7] checking root items
  [2/7] checking extents
  ref mismatch on [30425088 16384] extent item 1, found 0
  backref 30425088 root 256 not referenced back 0x564a91c23d70
  incorrect global backref count on 30425088 found 1 wanted 0
  backpointer mismatch on [30425088 16384]
  owner ref check failed [30425088 16384]
  ERROR: errors found in extent allocation tree or chunk allocation
  [3/7] checking free space cache
  [4/7] checking fs roots
  [5/7] checking only csums items (without verifying data)
  [6/7] checking root refs
  [7/7] checking quota groups skipped (not enabled on this FS)
  found 212992 bytes used, error(s) found
  total csum bytes: 0
  total tree bytes: 131072
  total fs tree bytes: 32768
  total extent tree bytes: 16384
  btree space waste bytes: 124669
  file data blocks allocated: 65536
   referenced 65536

So fix this by freeing the metadata extent if btrfs_insert_root() returns
an error.

CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ioctl.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -527,8 +527,6 @@ static noinline int create_subvol(struct
 	btrfs_set_root_otransid(root_item, trans->transid);
 
 	btrfs_tree_unlock(leaf);
-	free_extent_buffer(leaf);
-	leaf = NULL;
 
 	btrfs_set_root_dirid(root_item, new_dirid);
 
@@ -537,8 +535,22 @@ static noinline int create_subvol(struct
 	key.type = BTRFS_ROOT_ITEM_KEY;
 	ret = btrfs_insert_root(trans, fs_info->tree_root, &key,
 				root_item);
-	if (ret)
+	if (ret) {
+		/*
+		 * Since we don't abort the transaction in this case, free the
+		 * tree block so that we don't leak space and leave the
+		 * filesystem in an inconsistent state (an extent item in the
+		 * extent tree without backreferences). Also no need to have
+		 * the tree block locked since it is not in any tree at this
+		 * point, so no other task can find it and use it.
+		 */
+		btrfs_free_tree_block(trans, root, leaf, 0, 1);
+		free_extent_buffer(leaf);
 		goto fail;
+	}
+
+	free_extent_buffer(leaf);
+	leaf = NULL;
 
 	key.offset = (u64)-1;
 	new_root = btrfs_read_fs_root_no_name(fs_info, &key);


