Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A26ED5FB7CA
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 17:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbiJKPz7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 11:55:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbiJKPz6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 11:55:58 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02DA12A964;
        Tue, 11 Oct 2022 08:55:55 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id A4C9A21AA7;
        Tue, 11 Oct 2022 15:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1665503754; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Gm0QjSMWCseYoG5vLxYn8KbJ5E5y4wXVnEpylDF8jUo=;
        b=aKzJhFc9JzWNPbv8vleZLOE/50ez1MY9kmlEATqqkKCS+iumxVF9XH0DfDfv2sopyIl1Is
        oSp/Lp5bpLDEx9AtJXAidk4M4oQleA0IRTyDuXcsfnpjoe+O00XA5slRLzr/oehWJjIRW/
        tpat2HRwBWzOTV1mHogoRIpTyUEDn3s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1665503754;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Gm0QjSMWCseYoG5vLxYn8KbJ5E5y4wXVnEpylDF8jUo=;
        b=53EHu0LSbAllgDDElnQ8Te1DzABX71i/CybeyiOpZM++ShYOFaqvDoBJm5E+6PRnbpNOz/
        NhIGRx7YTVkxxxBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3733E13AAC;
        Tue, 11 Oct 2022 15:55:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 81pHCgqSRWNHYwAAMHmgww
        (envelope-from <lhenriques@suse.de>); Tue, 11 Oct 2022 15:55:54 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 5022c03e;
        Tue, 11 Oct 2022 15:56:50 +0000 (UTC)
From:   =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>
To:     "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>
Cc:     linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>,
        stable@vger.kernel.org
Subject: [PATCH v2] ext4: fix a NULL pointer when validating an inode bitmap
Date:   Tue, 11 Oct 2022 16:56:24 +0100
Message-Id: <20221011155623.14840-1-lhenriques@suse.de>
In-Reply-To: <20221010142035.2051-1-lhenriques@suse.de>
References: <20221010142035.2051-1-lhenriques@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
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

This issue can be fixed by returning NULL in ext4_get_group_info() when
->s_group_info is NULL.  This also requires checking the return code from
ext4_get_group_info() when appropriate.

While there, also ensure the right error code (-EFSCORRUPTED) is propagated
to user-space.  EUCLEAN is more informative than ENOMEM.

CC: stable@vger.kernel.org
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216541
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216539
Signed-off-by: Luís Henriques <lhenriques@suse.de>
---

* Changes since v1:

I found out another bugzilla with the same issue (#216539), but on a
different place.  The pattern was the same: a call to
ext4_get_group_info() followed by a EXT4_MB_GRP_*_CORRUPT check.  I've
grep'ed the code and added the same check in (hopefully) all of them.

 fs/ext4/balloc.c   |  2 +-
 fs/ext4/ext4.h     | 17 ++++++++++-------
 fs/ext4/ialloc.c   |  6 +++---
 fs/ext4/indirect.c | 14 ++++++++++++--
 fs/ext4/mballoc.c  |  9 +++++----
 5 files changed, 31 insertions(+), 17 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 8ff4b9192a9f..1af1fc8b1891 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -377,7 +377,7 @@ static int ext4_validate_block_bitmap(struct super_block *sb,
 
 	if (buffer_verified(bh))
 		return 0;
-	if (EXT4_MB_GRP_BBITMAP_CORRUPT(grp))
+	if (!grp || EXT4_MB_GRP_BBITMAP_CORRUPT(grp))
 		return -EFSCORRUPTED;
 
 	ext4_lock_group(sb, block_group);
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index e5f2f5ca5120..1c8b5876a28a 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3324,13 +3324,16 @@ static inline
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
index 208b87ce8858..079b9c3af327 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -91,7 +91,7 @@ static int ext4_validate_inode_bitmap(struct super_block *sb,
 
 	if (buffer_verified(bh))
 		return 0;
-	if (EXT4_MB_GRP_IBITMAP_CORRUPT(grp))
+	if (!grp || EXT4_MB_GRP_IBITMAP_CORRUPT(grp))
 		return -EFSCORRUPTED;
 
 	ext4_lock_group(sb, block_group);
@@ -293,7 +293,7 @@ void ext4_free_inode(handle_t *handle, struct inode *inode)
 	}
 	if (!(sbi->s_mount_state & EXT4_FC_REPLAY)) {
 		grp = ext4_get_group_info(sb, block_group);
-		if (unlikely(EXT4_MB_GRP_IBITMAP_CORRUPT(grp))) {
+		if (unlikely(!grp || EXT4_MB_GRP_IBITMAP_CORRUPT(grp))) {
 			fatal = -EFSCORRUPTED;
 			goto error_return;
 		}
@@ -1048,7 +1048,7 @@ struct inode *__ext4_new_inode(struct user_namespace *mnt_userns,
 			 * Skip groups with already-known suspicious inode
 			 * tables
 			 */
-			if (EXT4_MB_GRP_IBITMAP_CORRUPT(grp))
+			if (!grp || EXT4_MB_GRP_IBITMAP_CORRUPT(grp))
 				goto next_group;
 		}
 
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
 
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 9dad93059945..577e4d7415c3 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2386,7 +2386,7 @@ static bool ext4_mb_good_group(struct ext4_allocation_context *ac,
 
 	BUG_ON(cr < 0 || cr >= 4);
 
-	if (unlikely(EXT4_MB_GRP_BBITMAP_CORRUPT(grp)))
+	if (unlikely(!grp || EXT4_MB_GRP_BBITMAP_CORRUPT(grp)))
 		return false;
 
 	free = grp->bb_free;
@@ -2466,7 +2466,7 @@ static int ext4_mb_good_group_nolock(struct ext4_allocation_context *ac,
 		goto out;
 	if (cr <= 2 && free < ac->ac_g_ex.fe_len)
 		goto out;
-	if (unlikely(EXT4_MB_GRP_BBITMAP_CORRUPT(grp)))
+	if (unlikely(!grp || EXT4_MB_GRP_BBITMAP_CORRUPT(grp)))
 		goto out;
 	if (should_lock) {
 		__acquire(ext4_group_lock_ptr(sb, group));
@@ -5895,6 +5895,7 @@ static void ext4_mb_clear_bb(handle_t *handle, struct inode *inode,
 	ext4_grpblk_t bit;
 	struct buffer_head *gd_bh;
 	ext4_group_t block_group;
+	struct ext4_group_info *grp_info;
 	struct ext4_sb_info *sbi;
 	struct ext4_buddy e4b;
 	unsigned int count_clusters;
@@ -5916,8 +5917,8 @@ static void ext4_mb_clear_bb(handle_t *handle, struct inode *inode,
 	overflow = 0;
 	ext4_get_group_no_and_offset(sb, block, &block_group, &bit);
 
-	if (unlikely(EXT4_MB_GRP_BBITMAP_CORRUPT(
-			ext4_get_group_info(sb, block_group))))
+	grp_info = ext4_get_group_info(sb, block_group);
+	if (unlikely(!grp_info || EXT4_MB_GRP_BBITMAP_CORRUPT(grp_info)))
 		return;
 
 	/*
