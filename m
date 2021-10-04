Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E38E420886
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 11:41:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbhJDJmu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 05:42:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:47326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232308AbhJDJmu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 05:42:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 27F3561248;
        Mon,  4 Oct 2021 09:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633340461;
        bh=LFGYce04zHd4wRLvnwkaX9ya85ncXl0PzyuWpTA66uA=;
        h=Subject:To:Cc:From:Date:From;
        b=qhJXpBh87I1hThh9vSm4Gk1ZfDnWJh28QLHOcYArScDRcx8vs/icAYnQ0pfBInQIi
         ez3on6XqRp12MNzCAa9/Bote3/u2FCzzUI+GW8R5gVwDHYMlNE0GGHYmkr9RriKT0p
         u7B8n6kcvaNRCsgwq9e95awdQjeA+kcNOdRqgDhc=
Subject: FAILED: patch "[PATCH] ext4: fix reserved space counter leakage" failed to apply to 4.9-stable tree
To:     jefflexu@linux.alibaba.com, enwlinux@gmail.com,
        hsiangkao@linux.alibaba.com, tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 04 Oct 2021 11:40:54 +0200
Message-ID: <1633340454131135@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6fed83957f21eff11c8496e9f24253b03d2bc1dc Mon Sep 17 00:00:00 2001
From: Jeffle Xu <jefflexu@linux.alibaba.com>
Date: Mon, 23 Aug 2021 14:13:58 +0800
Subject: [PATCH] ext4: fix reserved space counter leakage

When ext4_insert_delayed block receives and recovers from an error from
ext4_es_insert_delayed_block(), e.g., ENOMEM, it does not release the
space it has reserved for that block insertion as it should. One effect
of this bug is that s_dirtyclusters_counter is not decremented and
remains incorrectly elevated until the file system has been unmounted.
This can result in premature ENOSPC returns and apparent loss of free
space.

Another effect of this bug is that
/sys/fs/ext4/<dev>/delayed_allocation_blocks can remain non-zero even
after syncfs has been executed on the filesystem.

Besides, add check for s_dirtyclusters_counter when inode is going to be
evicted and freed. s_dirtyclusters_counter can still keep non-zero until
inode is written back in .evict_inode(), and thus the check is delayed
to .destroy_inode().

Fixes: 51865fda28e5 ("ext4: let ext4 maintain extent status tree")
Cc: stable@kernel.org
Suggested-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
Reviewed-by: Eric Whitney <enwlinux@gmail.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Link: https://lore.kernel.org/r/20210823061358.84473-1-jefflexu@linux.alibaba.com

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 2a076d236ba1..9df1ab070fa5 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1628,6 +1628,7 @@ static int ext4_insert_delayed_block(struct inode *inode, ext4_lblk_t lblk)
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	int ret;
 	bool allocated = false;
+	bool reserved = false;
 
 	/*
 	 * If the cluster containing lblk is shared with a delayed,
@@ -1644,6 +1645,7 @@ static int ext4_insert_delayed_block(struct inode *inode, ext4_lblk_t lblk)
 		ret = ext4_da_reserve_space(inode);
 		if (ret != 0)   /* ENOSPC */
 			goto errout;
+		reserved = true;
 	} else {   /* bigalloc */
 		if (!ext4_es_scan_clu(inode, &ext4_es_is_delonly, lblk)) {
 			if (!ext4_es_scan_clu(inode,
@@ -1656,6 +1658,7 @@ static int ext4_insert_delayed_block(struct inode *inode, ext4_lblk_t lblk)
 					ret = ext4_da_reserve_space(inode);
 					if (ret != 0)   /* ENOSPC */
 						goto errout;
+					reserved = true;
 				} else {
 					allocated = true;
 				}
@@ -1666,6 +1669,8 @@ static int ext4_insert_delayed_block(struct inode *inode, ext4_lblk_t lblk)
 	}
 
 	ret = ext4_es_insert_delayed_block(inode, lblk, allocated);
+	if (ret && reserved)
+		ext4_da_release_space(inode, 1);
 
 errout:
 	return ret;
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index feca816b6bf3..a52f1572daa5 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1352,6 +1352,12 @@ static void ext4_destroy_inode(struct inode *inode)
 				true);
 		dump_stack();
 	}
+
+	if (EXT4_I(inode)->i_reserved_data_blocks)
+		ext4_msg(inode->i_sb, KERN_ERR,
+			 "Inode %lu (%p): i_reserved_data_blocks (%u) not cleared!",
+			 inode->i_ino, EXT4_I(inode),
+			 EXT4_I(inode)->i_reserved_data_blocks);
 }
 
 static void init_once(void *foo)

