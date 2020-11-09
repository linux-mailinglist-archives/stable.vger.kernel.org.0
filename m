Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4462C2AB96D
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:09:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731806AbgKINJM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:09:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:34060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731796AbgKINJL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:09:11 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9796F2076E;
        Mon,  9 Nov 2020 13:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927350;
        bh=ivEq7/C6eolLtW4B5zm6JLS1e/4PE7t2CW1tALfUhs8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OxGAYdjupATq4pd9hBYv9VtJ1LgtubCfHBe8+zkoDrltnvU+ue/hpSnwEP7IUT/S3
         7wx+8l2dnBoZB/F8CUFjEAWy0eOu/oyib/piMkjLWNhzNI6CcwVyfp7QZHr3m7q411
         kvB6hj/aW4GCfNrnsnzCH/DjXy5t3O2jstnqCbDM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 4.19 29/71] btrfs: tree-checker: Verify inode item
Date:   Mon,  9 Nov 2020 13:55:23 +0100
Message-Id: <20201109125021.272942487@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125019.906191744@linuxfoundation.org>
References: <20201109125019.906191744@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit 496245cac57e26d8b738d85c7a29cf9a47610f3f upstream.

There is a report in kernel bugzilla about mismatch file type in dir
item and inode item.

This inspires us to check inode mode in inode item.

This patch will check the following members:

- inode key objectid
  Should be ROOT_DIR_DIR or [256, (u64)-256] or FREE_INO.

- inode key offset
  Should be 0

- inode item generation
- inode item transid
  No newer than sb generation + 1.
  The +1 is for log tree.

- inode item mode
  No unknown bits.
  No invalid S_IF* bit.
  NOTE: S_IFMT check is not enough, need to check every know type.

- inode item nlink
  Dir should have no more link than 1.

- inode item flags

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ctree.h        |   15 +++++++
 fs/btrfs/tree-checker.c |   94 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 109 insertions(+)

--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1459,6 +1459,21 @@ do {
 
 #define BTRFS_INODE_ROOT_ITEM_INIT	(1 << 31)
 
+#define BTRFS_INODE_FLAG_MASK						\
+	(BTRFS_INODE_NODATASUM |					\
+	 BTRFS_INODE_NODATACOW |					\
+	 BTRFS_INODE_READONLY |						\
+	 BTRFS_INODE_NOCOMPRESS |					\
+	 BTRFS_INODE_PREALLOC |						\
+	 BTRFS_INODE_SYNC |						\
+	 BTRFS_INODE_IMMUTABLE |					\
+	 BTRFS_INODE_APPEND |						\
+	 BTRFS_INODE_NODUMP |						\
+	 BTRFS_INODE_NOATIME |						\
+	 BTRFS_INODE_DIRSYNC |						\
+	 BTRFS_INODE_COMPRESS |						\
+	 BTRFS_INODE_ROOT_ITEM_INIT)
+
 struct btrfs_map_token {
 	const struct extent_buffer *eb;
 	char *kaddr;
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -671,6 +671,97 @@ static int check_dev_item(struct btrfs_f
 	return 0;
 }
 
+/* Inode item error output has the same format as dir_item_err() */
+#define inode_item_err(fs_info, eb, slot, fmt, ...)			\
+	dir_item_err(fs_info, eb, slot, fmt, __VA_ARGS__)
+
+static int check_inode_item(struct btrfs_fs_info *fs_info,
+			    struct extent_buffer *leaf,
+			    struct btrfs_key *key, int slot)
+{
+	struct btrfs_inode_item *iitem;
+	u64 super_gen = btrfs_super_generation(fs_info->super_copy);
+	u32 valid_mask = (S_IFMT | S_ISUID | S_ISGID | S_ISVTX | 0777);
+	u32 mode;
+
+	if ((key->objectid < BTRFS_FIRST_FREE_OBJECTID ||
+	     key->objectid > BTRFS_LAST_FREE_OBJECTID) &&
+	    key->objectid != BTRFS_ROOT_TREE_DIR_OBJECTID &&
+	    key->objectid != BTRFS_FREE_INO_OBJECTID) {
+		generic_err(fs_info, leaf, slot,
+	"invalid key objectid: has %llu expect %llu or [%llu, %llu] or %llu",
+			    key->objectid, BTRFS_ROOT_TREE_DIR_OBJECTID,
+			    BTRFS_FIRST_FREE_OBJECTID,
+			    BTRFS_LAST_FREE_OBJECTID,
+			    BTRFS_FREE_INO_OBJECTID);
+		return -EUCLEAN;
+	}
+	if (key->offset != 0) {
+		inode_item_err(fs_info, leaf, slot,
+			"invalid key offset: has %llu expect 0",
+			key->offset);
+		return -EUCLEAN;
+	}
+	iitem = btrfs_item_ptr(leaf, slot, struct btrfs_inode_item);
+
+	/* Here we use super block generation + 1 to handle log tree */
+	if (btrfs_inode_generation(leaf, iitem) > super_gen + 1) {
+		inode_item_err(fs_info, leaf, slot,
+			"invalid inode generation: has %llu expect (0, %llu]",
+			       btrfs_inode_generation(leaf, iitem),
+			       super_gen + 1);
+		return -EUCLEAN;
+	}
+	/* Note for ROOT_TREE_DIR_ITEM, mkfs could set its transid 0 */
+	if (btrfs_inode_transid(leaf, iitem) > super_gen + 1) {
+		inode_item_err(fs_info, leaf, slot,
+			"invalid inode generation: has %llu expect [0, %llu]",
+			       btrfs_inode_transid(leaf, iitem), super_gen + 1);
+		return -EUCLEAN;
+	}
+
+	/*
+	 * For size and nbytes it's better not to be too strict, as for dir
+	 * item its size/nbytes can easily get wrong, but doesn't affect
+	 * anything in the fs. So here we skip the check.
+	 */
+	mode = btrfs_inode_mode(leaf, iitem);
+	if (mode & ~valid_mask) {
+		inode_item_err(fs_info, leaf, slot,
+			       "unknown mode bit detected: 0x%x",
+			       mode & ~valid_mask);
+		return -EUCLEAN;
+	}
+
+	/*
+	 * S_IFMT is not bit mapped so we can't completely rely on is_power_of_2,
+	 * but is_power_of_2() can save us from checking FIFO/CHR/DIR/REG.
+	 * Only needs to check BLK, LNK and SOCKS
+	 */
+	if (!is_power_of_2(mode & S_IFMT)) {
+		if (!S_ISLNK(mode) && !S_ISBLK(mode) && !S_ISSOCK(mode)) {
+			inode_item_err(fs_info, leaf, slot,
+			"invalid mode: has 0%o expect valid S_IF* bit(s)",
+				       mode & S_IFMT);
+			return -EUCLEAN;
+		}
+	}
+	if (S_ISDIR(mode) && btrfs_inode_nlink(leaf, iitem) > 1) {
+		inode_item_err(fs_info, leaf, slot,
+		       "invalid nlink: has %u expect no more than 1 for dir",
+			btrfs_inode_nlink(leaf, iitem));
+		return -EUCLEAN;
+	}
+	if (btrfs_inode_flags(leaf, iitem) & ~BTRFS_INODE_FLAG_MASK) {
+		inode_item_err(fs_info, leaf, slot,
+			       "unknown flags detected: 0x%llx",
+			       btrfs_inode_flags(leaf, iitem) &
+			       ~BTRFS_INODE_FLAG_MASK);
+		return -EUCLEAN;
+	}
+	return 0;
+}
+
 /*
  * Common point to switch the item-specific validation.
  */
@@ -704,6 +795,9 @@ static int check_leaf_item(struct btrfs_
 	case BTRFS_DEV_ITEM_KEY:
 		ret = check_dev_item(fs_info, leaf, key, slot);
 		break;
+	case BTRFS_INODE_ITEM_KEY:
+		ret = check_inode_item(fs_info, leaf, key, slot);
+		break;
 	}
 	return ret;
 }


