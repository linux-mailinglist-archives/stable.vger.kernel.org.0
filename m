Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB651C16DB
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729112AbgEANxz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:53:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:34118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730777AbgEANfr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:35:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF0B9208DB;
        Fri,  1 May 2020 13:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340146;
        bh=72RfqEdt6TMkCkKEnk3nIwJvrEzmxYJ1BM+PEqooLDk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wlk1OrKFiAQD6bSpCm5AqaKW2P7BLhnxDjqOpsUpoQ+5W/yeUT3bKw1cjCSPozGo2
         UIKASU0R+IFPS2hv19Y10t8iJW7NOQxHujr8AYU9uoHJNPqiYZhp29Fv/RUNmmP0/8
         FyqqGSNhHVEvtlITRRK5nng7I/yTx4IJ/7PiqoXU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        stable@kernel.org, Ashwin H <ashwinh@vmware.com>
Subject: [PATCH 4.14 112/117] ext4: protect journal inodes blocks using block_validity
Date:   Fri,  1 May 2020 15:22:28 +0200
Message-Id: <20200501131558.377031323@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131544.291247695@linuxfoundation.org>
References: <20200501131544.291247695@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

commit 345c0dbf3a30872d9b204db96b5857cd00808cae upstream.

Add the blocks which belong to the journal inode to block_validity's
system zone so attempts to deallocate or overwrite the journal due a
corrupted file system where the journal blocks are also claimed by
another inode.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=202879
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Ashwin H <ashwinh@vmware.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/block_validity.c |   48 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/inode.c          |    4 +++
 2 files changed, 52 insertions(+)

--- a/fs/ext4/block_validity.c
+++ b/fs/ext4/block_validity.c
@@ -137,6 +137,48 @@ static void debug_print_tree(struct ext4
 	printk(KERN_CONT "\n");
 }
 
+static int ext4_protect_reserved_inode(struct super_block *sb, u32 ino)
+{
+	struct inode *inode;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct ext4_map_blocks map;
+	u32 i = 0, err = 0, num, n;
+
+	if ((ino < EXT4_ROOT_INO) ||
+	    (ino > le32_to_cpu(sbi->s_es->s_inodes_count)))
+		return -EINVAL;
+	inode = ext4_iget(sb, ino, EXT4_IGET_SPECIAL);
+	if (IS_ERR(inode))
+		return PTR_ERR(inode);
+	num = (inode->i_size + sb->s_blocksize - 1) >> sb->s_blocksize_bits;
+	while (i < num) {
+		map.m_lblk = i;
+		map.m_len = num - i;
+		n = ext4_map_blocks(NULL, inode, &map, 0);
+		if (n < 0) {
+			err = n;
+			break;
+		}
+		if (n == 0) {
+			i++;
+		} else {
+			if (!ext4_data_block_valid(sbi, map.m_pblk, n)) {
+				ext4_error(sb, "blocks %llu-%llu from inode %u "
+					   "overlap system zone", map.m_pblk,
+					   map.m_pblk + map.m_len - 1, ino);
+				err = -EFSCORRUPTED;
+				break;
+			}
+			err = add_system_zone(sbi, map.m_pblk, n);
+			if (err < 0)
+				break;
+			i += n;
+		}
+	}
+	iput(inode);
+	return err;
+}
+
 int ext4_setup_system_zone(struct super_block *sb)
 {
 	ext4_group_t ngroups = ext4_get_groups_count(sb);
@@ -171,6 +213,12 @@ int ext4_setup_system_zone(struct super_
 		if (ret)
 			return ret;
 	}
+	if (ext4_has_feature_journal(sb) && sbi->s_es->s_journal_inum) {
+		ret = ext4_protect_reserved_inode(sb,
+				le32_to_cpu(sbi->s_es->s_journal_inum));
+		if (ret)
+			return ret;
+	}
 
 	if (test_opt(sb, DEBUG))
 		debug_print_tree(EXT4_SB(sb));
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -407,6 +407,10 @@ static int __check_block_validity(struct
 				unsigned int line,
 				struct ext4_map_blocks *map)
 {
+	if (ext4_has_feature_journal(inode->i_sb) &&
+	    (inode->i_ino ==
+	     le32_to_cpu(EXT4_SB(inode->i_sb)->s_es->s_journal_inum)))
+		return 0;
 	if (!ext4_data_block_valid(EXT4_SB(inode->i_sb), map->m_pblk,
 				   map->m_len)) {
 		ext4_error_inode(inode, func, line, map->m_pblk,


