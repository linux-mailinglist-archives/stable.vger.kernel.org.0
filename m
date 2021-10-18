Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 556F1431DEE
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234394AbhJRNz6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:55:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:58186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234470AbhJRNxz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:53:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 69BEA619E8;
        Mon, 18 Oct 2021 13:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564363;
        bh=XSHwBJqeCkBTXUAnj6oXoJ6/34/7iMzUiKRJ/rsQYjk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V9TE8D5ShkmV3CJKw2GB+ec5vGLoK9Ovurlcm9mtFyJ7EcWzAUncB9UGtJpobxJc+
         wkvGd1/1o1/81f3PtGr3eZzZNlP6eQFnkEDahmWRiQOhYWp3OoIF5lLDwpVia7hdOv
         DMdiZ+JF82Jam4ICuZU8q0TGpmFv1R1WJuX6aL54=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.14 034/151] btrfs: update refs for any root except tree log roots
Date:   Mon, 18 Oct 2021 15:23:33 +0200
Message-Id: <20211018132341.802630101@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit d175209be04d7d263fa1a54cde7608c706c9d0d7 upstream.

I hit a stuck relocation on btrfs/061 during my overnight testing.  This
turned out to be because we had left over extent entries in our extent
root for a data reloc inode that no longer existed.  This happened
because in btrfs_drop_extents() we only update refs if we have SHAREABLE
set or we are the tree_root.  This regression was introduced by
aeb935a45581 ("btrfs: don't set SHAREABLE flag for data reloc tree")
where we stopped setting SHAREABLE for the data reloc tree.

The problem here is we actually do want to update extent references for
data extents in the data reloc tree, in fact we only don't want to
update extent references if the file extents are in the log tree.
Update this check to only skip updating references in the case of the
log tree.

This is relatively rare, because you have to be running scrub at the
same time, which is what btrfs/061 does.  The data reloc inode has its
extents pre-allocated, and then we copy the extent into the
pre-allocated chunks.  We theoretically should never be calling
btrfs_drop_extents() on a data reloc inode.  The exception of course is
with scrub, if our pre-allocated extent falls inside of the block group
we are scrubbing, then the block group will be marked read only and we
will be forced to cow that extent.  This means we will call
btrfs_drop_extents() on that range when we COW that file extent.

This isn't really problematic if we do this, the data reloc inode
requires that our extent lengths match exactly with the extent we are
copying, thankfully we validate the extent is correct with
get_new_location(), so if we happen to COW only part of the extent we
won't link it in when we do the relocation, so we are safe from any
other shenanigans that arise because of this interaction with scrub.

Fixes: aeb935a45581 ("btrfs: don't set SHAREABLE flag for data reloc tree")
CC: stable@vger.kernel.org # 5.8+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/file.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -733,8 +733,7 @@ int btrfs_drop_extents(struct btrfs_tran
 	if (args->start >= inode->disk_i_size && !args->replace_extent)
 		modify_tree = 0;
 
-	update_refs = (test_bit(BTRFS_ROOT_SHAREABLE, &root->state) ||
-		       root == fs_info->tree_root);
+	update_refs = (root->root_key.objectid != BTRFS_TREE_LOG_OBJECTID);
 	while (1) {
 		recow = 0;
 		ret = btrfs_lookup_file_extent(trans, root, path, ino,


