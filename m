Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 957AD30CCA1
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 21:04:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240246AbhBBUCS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 15:02:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:38220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232746AbhBBNpl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:45:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3105664F7F;
        Tue,  2 Feb 2021 13:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273258;
        bh=yEL208lpOLWOpnghea95w7bnVa2xJmcmeIrj12o8q78=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XxbMkW5xuxz9dkqiO+6IPm/Q3pVL2V7086YhQCN0bH17aHF63fStTdsv9SoLXFzuk
         fANlXgQDdvDdnipoLgD6qR2iu79GzgdgjI2dVWsC1u34c8q/9HGY8BchG1GSX/tDyX
         llVJXtaQ9TmshjqdhXMiq7P5TS/EfXuqLN90rhzg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.10 038/142] btrfs: fix possible free space tree corruption with online conversion
Date:   Tue,  2 Feb 2021 14:36:41 +0100
Message-Id: <20210202132959.282532488@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit 2f96e40212d435b328459ba6b3956395eed8fa9f upstream.

While running btrfs/011 in a loop I would often ASSERT() while trying to
add a new free space entry that already existed, or get an EEXIST while
adding a new block to the extent tree, which is another indication of
double allocation.

This occurs because when we do the free space tree population, we create
the new root and then populate the tree and commit the transaction.
The problem is when you create a new root, the root node and commit root
node are the same.  During this initial transaction commit we will run
all of the delayed refs that were paused during the free space tree
generation, and thus begin to cache block groups.  While caching block
groups the caching thread will be reading from the main root for the
free space tree, so as we make allocations we'll be changing the free
space tree, which can cause us to add the same range twice which results
in either the ASSERT(ret != -EEXIST); in __btrfs_add_free_space, or in a
variety of different errors when running delayed refs because of a
double allocation.

Fix this by marking the fs_info as unsafe to load the free space tree,
and fall back on the old slow method.  We could be smarter than this,
for example caching the block group while we're populating the free
space tree, but since this is a serious problem I've opted for the
simplest solution.

CC: stable@vger.kernel.org # 4.9+
Fixes: a5ed91828518 ("Btrfs: implement the free space B-tree")
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/block-group.c     |   10 +++++++++-
 fs/btrfs/ctree.h           |    3 +++
 fs/btrfs/free-space-tree.c |   10 +++++++++-
 3 files changed, 21 insertions(+), 2 deletions(-)

--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -639,7 +639,15 @@ static noinline void caching_thread(stru
 	mutex_lock(&caching_ctl->mutex);
 	down_read(&fs_info->commit_root_sem);
 
-	if (btrfs_fs_compat_ro(fs_info, FREE_SPACE_TREE))
+	/*
+	 * If we are in the transaction that populated the free space tree we
+	 * can't actually cache from the free space tree as our commit root and
+	 * real root are the same, so we could change the contents of the blocks
+	 * while caching.  Instead do the slow caching in this case, and after
+	 * the transaction has committed we will be safe.
+	 */
+	if (btrfs_fs_compat_ro(fs_info, FREE_SPACE_TREE) &&
+	    !(test_bit(BTRFS_FS_FREE_SPACE_TREE_UNTRUSTED, &fs_info->flags)))
 		ret = load_free_space_tree(caching_ctl);
 	else
 		ret = load_extent_tree_free(caching_ctl);
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -146,6 +146,9 @@ enum {
 	BTRFS_FS_STATE_DEV_REPLACING,
 	/* The btrfs_fs_info created for self-tests */
 	BTRFS_FS_STATE_DUMMY_FS_INFO,
+
+	/* Indicate that we can't trust the free space tree for caching yet */
+	BTRFS_FS_FREE_SPACE_TREE_UNTRUSTED,
 };
 
 #define BTRFS_BACKREF_REV_MAX		256
--- a/fs/btrfs/free-space-tree.c
+++ b/fs/btrfs/free-space-tree.c
@@ -1152,6 +1152,7 @@ int btrfs_create_free_space_tree(struct
 		return PTR_ERR(trans);
 
 	set_bit(BTRFS_FS_CREATING_FREE_SPACE_TREE, &fs_info->flags);
+	set_bit(BTRFS_FS_FREE_SPACE_TREE_UNTRUSTED, &fs_info->flags);
 	free_space_root = btrfs_create_tree(trans,
 					    BTRFS_FREE_SPACE_TREE_OBJECTID);
 	if (IS_ERR(free_space_root)) {
@@ -1173,11 +1174,18 @@ int btrfs_create_free_space_tree(struct
 	btrfs_set_fs_compat_ro(fs_info, FREE_SPACE_TREE);
 	btrfs_set_fs_compat_ro(fs_info, FREE_SPACE_TREE_VALID);
 	clear_bit(BTRFS_FS_CREATING_FREE_SPACE_TREE, &fs_info->flags);
+	ret = btrfs_commit_transaction(trans);
 
-	return btrfs_commit_transaction(trans);
+	/*
+	 * Now that we've committed the transaction any reading of our commit
+	 * root will be safe, so we can cache from the free space tree now.
+	 */
+	clear_bit(BTRFS_FS_FREE_SPACE_TREE_UNTRUSTED, &fs_info->flags);
+	return ret;
 
 abort:
 	clear_bit(BTRFS_FS_CREATING_FREE_SPACE_TREE, &fs_info->flags);
+	clear_bit(BTRFS_FS_FREE_SPACE_TREE_UNTRUSTED, &fs_info->flags);
 	btrfs_abort_transaction(trans, ret);
 	btrfs_end_transaction(trans);
 	return ret;


