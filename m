Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6550923A5CF
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728785AbgHCMb7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:31:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:59760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729251AbgHCMb6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:31:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74722204EC;
        Mon,  3 Aug 2020 12:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457917;
        bh=GhoJwhUqFNW1/a5nctkhs7PjmOrcsypD+HOW4I0FNbM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t3DSekTkN4pm7jSzwG3czl2siEjR4ZkVtAY5QqXTNtwp7iYGCFWASfj9Ai9ZvYHS4
         1ylhu471FjDfpPlDl/lmI9tzKDwguvFbHDkS0KMeqIk0blqtI4VMsgSPHi0ZJTKq3J
         00rADrYEqYjXwbLmmKCxdHsHKWdInqMr6mnaMutY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yoon Jungyeon <jungyeon@gatech.edu>,
        Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 09/56] btrfs: inode: Verify inode mode to avoid NULL pointer dereference
Date:   Mon,  3 Aug 2020 14:19:24 +0200
Message-Id: <20200803121850.766021165@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121850.306734207@linuxfoundation.org>
References: <20200803121850.306734207@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 6bf9e4bd6a277840d3fe8c5d5d530a1fbd3db592 ]

[BUG]
When accessing a file on a crafted image, btrfs can crash in block layer:

  BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
  PGD 136501067 P4D 136501067 PUD 124519067 PMD 0
  CPU: 3 PID: 0 Comm: swapper/3 Not tainted 5.0.0-rc8-default #252
  RIP: 0010:end_bio_extent_readpage+0x144/0x700
  Call Trace:
   <IRQ>
   blk_update_request+0x8f/0x350
   blk_mq_end_request+0x1a/0x120
   blk_done_softirq+0x99/0xc0
   __do_softirq+0xc7/0x467
   irq_exit+0xd1/0xe0
   call_function_single_interrupt+0xf/0x20
   </IRQ>
  RIP: 0010:default_idle+0x1e/0x170

[CAUSE]
The crafted image has a tricky corruption, the INODE_ITEM has a
different type against its parent dir:

        item 20 key (268 INODE_ITEM 0) itemoff 2808 itemsize 160
                generation 13 transid 13 size 1048576 nbytes 1048576
                block group 0 mode 121644 links 1 uid 0 gid 0 rdev 0
                sequence 9 flags 0x0(none)

This mode number 0120000 means it's a symlink.

But the dir item think it's still a regular file:

        item 8 key (264 DIR_INDEX 5) itemoff 3707 itemsize 32
                location key (268 INODE_ITEM 0) type FILE
                transid 13 data_len 0 name_len 2
                name: f4
        item 40 key (264 DIR_ITEM 51821248) itemoff 1573 itemsize 32
                location key (268 INODE_ITEM 0) type FILE
                transid 13 data_len 0 name_len 2
                name: f4

For symlink, we don't set BTRFS_I(inode)->io_tree.ops and leave it
empty, as symlink is only designed to have inlined extent, all handled
by tree block read.  Thus no need to trigger btrfs_submit_bio_hook() for
inline file extent.

However end_bio_extent_readpage() expects tree->ops populated, as it's
reading regular data extent.  This causes NULL pointer dereference.

[FIX]
This patch fixes the problem in two ways:

- Verify inode mode against its dir item when looking up inode
  So in btrfs_lookup_dentry() if we find inode mode mismatch with dir
  item, we error out so that corrupted inode will not be accessed.

- Verify inode mode when getting extent mapping
  Only regular file should have regular or preallocated extent.
  If we found regular/preallocated file extent for symlink or
  the rest, we error out before submitting the read bio.

With this fix that crafted image can be rejected gracefully:

  BTRFS critical (device loop0): inode mode mismatch with dir: inode mode=0121644 btrfs type=7 dir type=1

Reported-by: Yoon Jungyeon <jungyeon@gatech.edu>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=202763
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c             | 41 +++++++++++++++++++++++++++++-------
 fs/btrfs/tests/inode-tests.c |  1 +
 2 files changed, 34 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 8dd2702ce859e..7befb7c12bd32 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5553,12 +5553,14 @@ no_delete:
 }
 
 /*
- * this returns the key found in the dir entry in the location pointer.
+ * Return the key found in the dir entry in the location pointer, fill @type
+ * with BTRFS_FT_*, and return 0.
+ *
  * If no dir entries were found, returns -ENOENT.
  * If found a corrupted location in dir entry, returns -EUCLEAN.
  */
 static int btrfs_inode_by_name(struct inode *dir, struct dentry *dentry,
-			       struct btrfs_key *location)
+			       struct btrfs_key *location, u8 *type)
 {
 	const char *name = dentry->d_name.name;
 	int namelen = dentry->d_name.len;
@@ -5591,6 +5593,8 @@ static int btrfs_inode_by_name(struct inode *dir, struct dentry *dentry,
 			   __func__, name, btrfs_ino(BTRFS_I(dir)),
 			   location->objectid, location->type, location->offset);
 	}
+	if (!ret)
+		*type = btrfs_dir_type(path->nodes[0], di);
 out:
 	btrfs_free_path(path);
 	return ret;
@@ -5826,6 +5830,11 @@ static struct inode *new_simple_dir(struct super_block *s,
 	return inode;
 }
 
+static inline u8 btrfs_inode_type(struct inode *inode)
+{
+	return btrfs_type_by_mode[(inode->i_mode & S_IFMT) >> S_SHIFT];
+}
+
 struct inode *btrfs_lookup_dentry(struct inode *dir, struct dentry *dentry)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(dir->i_sb);
@@ -5833,18 +5842,31 @@ struct inode *btrfs_lookup_dentry(struct inode *dir, struct dentry *dentry)
 	struct btrfs_root *root = BTRFS_I(dir)->root;
 	struct btrfs_root *sub_root = root;
 	struct btrfs_key location;
+	u8 di_type = 0;
 	int index;
 	int ret = 0;
 
 	if (dentry->d_name.len > BTRFS_NAME_LEN)
 		return ERR_PTR(-ENAMETOOLONG);
 
-	ret = btrfs_inode_by_name(dir, dentry, &location);
+	ret = btrfs_inode_by_name(dir, dentry, &location, &di_type);
 	if (ret < 0)
 		return ERR_PTR(ret);
 
 	if (location.type == BTRFS_INODE_ITEM_KEY) {
 		inode = btrfs_iget(dir->i_sb, &location, root, NULL);
+		if (IS_ERR(inode))
+			return inode;
+
+		/* Do extra check against inode mode with di_type */
+		if (btrfs_inode_type(inode) != di_type) {
+			btrfs_crit(fs_info,
+"inode mode mismatch with dir: inode mode=0%o btrfs type=%u dir type=%u",
+				  inode->i_mode, btrfs_inode_type(inode),
+				  di_type);
+			iput(inode);
+			return ERR_PTR(-EUCLEAN);
+		}
 		return inode;
 	}
 
@@ -6455,11 +6477,6 @@ fail:
 	return ERR_PTR(ret);
 }
 
-static inline u8 btrfs_inode_type(struct inode *inode)
-{
-	return btrfs_type_by_mode[(inode->i_mode & S_IFMT) >> S_SHIFT];
-}
-
 /*
  * utility function to add 'inode' into 'parent_inode' with
  * a give name and a given sequence number.
@@ -6993,6 +7010,14 @@ struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
 	extent_start = found_key.offset;
 	if (found_type == BTRFS_FILE_EXTENT_REG ||
 	    found_type == BTRFS_FILE_EXTENT_PREALLOC) {
+		/* Only regular file could have regular/prealloc extent */
+		if (!S_ISREG(inode->vfs_inode.i_mode)) {
+			ret = -EUCLEAN;
+			btrfs_crit(fs_info,
+		"regular/prealloc extent found for non-regular inode %llu",
+				   btrfs_ino(inode));
+			goto out;
+		}
 		extent_end = extent_start +
 		       btrfs_file_extent_num_bytes(leaf, item);
 
diff --git a/fs/btrfs/tests/inode-tests.c b/fs/btrfs/tests/inode-tests.c
index 64043f0288206..648633aae968c 100644
--- a/fs/btrfs/tests/inode-tests.c
+++ b/fs/btrfs/tests/inode-tests.c
@@ -232,6 +232,7 @@ static noinline int test_btrfs_get_extent(u32 sectorsize, u32 nodesize)
 		return ret;
 	}
 
+	inode->i_mode = S_IFREG;
 	BTRFS_I(inode)->location.type = BTRFS_INODE_ITEM_KEY;
 	BTRFS_I(inode)->location.objectid = BTRFS_FIRST_FREE_OBJECTID;
 	BTRFS_I(inode)->location.offset = 0;
-- 
2.25.1



