Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA7765FA019
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 16:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbiJJOUl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 10:20:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiJJOUk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 10:20:40 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94EC36527B;
        Mon, 10 Oct 2022 07:20:39 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 35013219BB;
        Mon, 10 Oct 2022 14:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1665411638; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=7JJ6mlAv5c4L4mWnrMy5YG0YPzapcaA10L7MOoXEv64=;
        b=CuWo+r2J5ScDMzSnfNDfMo1n/K3xwfq7PECZzG8rfAGHism/a76r9YWTuw9PYOnNCp0u6l
        MNfCTY3oAjKaChYfcIrQTa0peP7Wddg1PJbC/px79zAseNscr0utngg32uHfdflp5LrZIU
        Vb4YobD3DNJ64IC+JG1GZdnQJUGerpM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1665411638;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=7JJ6mlAv5c4L4mWnrMy5YG0YPzapcaA10L7MOoXEv64=;
        b=/OdhxkaO59+lkk79bOK4AnVBfQDG/FPdqfQa+uuJGcE1qwn2BM5Nr4QRRWrwD/lhqmry7D
        m3qkXDu5Ar0tcRDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 00A8613479;
        Mon, 10 Oct 2022 14:20:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id muNaOTUqRGMbGQAAMHmgww
        (envelope-from <lhenriques@suse.de>); Mon, 10 Oct 2022 14:20:37 +0000
From:   =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>
To:     "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>
Cc:     linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>,
        stable@vger.kernel.org
Subject: [PATCH] ext4: fix a NULL pointer when validating an inode bitmap
Date:   Mon, 10 Oct 2022 15:20:35 +0100
Message-Id: <20221010142035.2051-1-lhenriques@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It's possible to hit a NULL pointer exception while accessing the
sb->s_group_info in ext4_validate_inode_bitmap(), when calling
ext4_get_group_info().

 EXT4-fs (loop0): warning: mounting unchecked fs, running e2fsck is recommended
 EXT4-fs error (device loop0): ext4_clear_blocks:866: inode #32: comm mount: attempt to clear invalid blocks 16777450 len 1
 EXT4-fs error (device loop0): ext4_free_branches:1012: inode #32: comm mount: invalid indirect mapped block 1258291200 (level 1)
 EXT4-fs error (device loop0): ext4_free_branches:1012: inode #32: comm mount: invalid indirect mapped block 7379847 (level 2)
 BUG: kernel NULL pointer dereference, address: 0000000000000000
 ...
 RIP: 0010:ext4_read_inode_bitmap+0x21b/0x5a0
 ...
 Call Trace:
  <TASK>
  ext4_free_inode+0x172/0x5c0
  ext4_evict_inode+0x4a5/0x730
  evict+0xc1/0x1c0
  ext4_setup_system_zone+0x2ea/0x380
  ext4_fill_super+0x249f/0x3910
  ? ext4_reconfigure+0x880/0x880
  ? snprintf+0x49/0x60
  ? ext4_reconfigure+0x880/0x880
  get_tree_bdev+0x169/0x260
  vfs_get_tree+0x16/0x70
  path_mount+0x77d/0xa30
  __x64_sys_mount+0x101/0x140
  do_syscall_64+0x3c/0x80
  entry_SYSCALL_64_after_hwframe+0x46/0xb0

Fix the issue by adding an extra NULL check.  And, while there, also ensure the
right error code (-EFSCORRUPTED) is propagated to user-space.  EUCLEAN is more
informative than ENOMEM.

CC: stable@vger.kernel.org
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216541
Signed-off-by: Luís Henriques <lhenriques@suse.de>
---
 fs/ext4/ext4.h     | 17 ++++++++++-------
 fs/ext4/ialloc.c   |  2 +-
 fs/ext4/indirect.c | 14 ++++++++++++--
 3 files changed, 23 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 3bf9a6926798..91317f592999 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3323,13 +3323,16 @@ static inline
 struct ext4_group_info *ext4_get_group_info(struct super_block *sb,
 					    ext4_group_t group)
 {
-	 struct ext4_group_info **grp_info;
-	 long indexv, indexh;
-	 BUG_ON(group >= EXT4_SB(sb)->s_groups_count);
-	 indexv = group >> (EXT4_DESC_PER_BLOCK_BITS(sb));
-	 indexh = group & ((EXT4_DESC_PER_BLOCK(sb)) - 1);
-	 grp_info = sbi_array_rcu_deref(EXT4_SB(sb), s_group_info, indexv);
-	 return grp_info[indexh];
+	struct ext4_group_info **grp_info;
+	long indexv, indexh;
+
+	BUG_ON(group >= EXT4_SB(sb)->s_groups_count);
+	if (!EXT4_SB(sb)->s_group_info)
+		return NULL;
+	indexv = group >> (EXT4_DESC_PER_BLOCK_BITS(sb));
+	indexh = group & ((EXT4_DESC_PER_BLOCK(sb)) - 1);
+	grp_info = sbi_array_rcu_deref(EXT4_SB(sb), s_group_info, indexv);
+	return grp_info[indexh];
 }
 
 /*
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 208b87ce8858..0e8d35d05b69 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -91,7 +91,7 @@ static int ext4_validate_inode_bitmap(struct super_block *sb,
 
 	if (buffer_verified(bh))
 		return 0;
-	if (EXT4_MB_GRP_IBITMAP_CORRUPT(grp))
+	if (!grp || EXT4_MB_GRP_IBITMAP_CORRUPT(grp))
 		return -EFSCORRUPTED;
 
 	ext4_lock_group(sb, block_group);
diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index 860fc5119009..e5ac5c2363df 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -148,6 +148,7 @@ static Indirect *ext4_get_branch(struct inode *inode, int depth,
 	struct super_block *sb = inode->i_sb;
 	Indirect *p = chain;
 	struct buffer_head *bh;
+	unsigned int key;
 	int ret = -EIO;
 
 	*err = 0;
@@ -156,9 +157,18 @@ static Indirect *ext4_get_branch(struct inode *inode, int depth,
 	if (!p->key)
 		goto no_block;
 	while (--depth) {
-		bh = sb_getblk(sb, le32_to_cpu(p->key));
+		key = le32_to_cpu(p->key);
+		bh = sb_getblk(sb, key);
 		if (unlikely(!bh)) {
-			ret = -ENOMEM;
+			/*
+			 * sb_getblk() masks different errors by always
+			 * returning NULL.  Let's distinguish at least the case
+			 * where the block is out of range.
+			 */
+			if (key > ext4_blocks_count(EXT4_SB(sb)->s_es))
+				ret = -EFSCORRUPTED;
+			else
+				ret = -ENOMEM;
 			goto failure;
 		}
 
