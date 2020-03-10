Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 202FC17FC86
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:21:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730526AbgCJNFp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:05:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:51042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730362AbgCJNFn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:05:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8285720409;
        Tue, 10 Mar 2020 13:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845543;
        bh=Xu+0x46z+TMykDwIjVuv4R0qLWv/64ldHyKMxrrzxnU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hmiyJ5OA5brYJ/z7d/GO5nZNqItwgxXJzKlxm7y5THFbiNffXvV2lqLWyxoxI1WoL
         qZbogar12Hv0BmISnCRTHRo0EkpEvxeTzfwXEpo3k5eOMok9sJLhtmVOVx23A+KelW
         cHLdUlqFDrB5lXr6piRfmLHzBzt/4Ug5GRwVszFg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Suraj Jitindar Singh <surajjs@amazon.com>,
        Theodore Tso <tytso@mit.edu>, Balbir Singh <sblbir@amazon.com>,
        stable@kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 005/126] ext4: fix potential race between s_group_info online resizing and access
Date:   Tue, 10 Mar 2020 13:40:26 +0100
Message-Id: <20200310124204.161646705@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310124203.704193207@linuxfoundation.org>
References: <20200310124203.704193207@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suraj Jitindar Singh <surajjs@amazon.com>

[ Upstream commit df3da4ea5a0fc5d115c90d5aa6caa4dd433750a7 ]

During an online resize an array of pointers to s_group_info gets replaced
so it can get enlarged. If there is a concurrent access to the array in
ext4_get_group_info() and this memory has been reused then this can lead to
an invalid memory access.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=206443
Link: https://lore.kernel.org/r/20200221053458.730016-3-tytso@mit.edu
Signed-off-by: Suraj Jitindar Singh <surajjs@amazon.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Balbir Singh <sblbir@amazon.com>
Cc: stable@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/ext4.h    |  8 ++++----
 fs/ext4/mballoc.c | 52 +++++++++++++++++++++++++++++++----------------
 2 files changed, 39 insertions(+), 21 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 8b55abdd7249a..4aa0f8f7d9a0e 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1442,7 +1442,7 @@ struct ext4_sb_info {
 #endif
 
 	/* for buddy allocator */
-	struct ext4_group_info ***s_group_info;
+	struct ext4_group_info ** __rcu *s_group_info;
 	struct inode *s_buddy_cache;
 	spinlock_t s_md_lock;
 	unsigned short *s_mb_offsets;
@@ -2832,13 +2832,13 @@ static inline
 struct ext4_group_info *ext4_get_group_info(struct super_block *sb,
 					    ext4_group_t group)
 {
-	 struct ext4_group_info ***grp_info;
+	 struct ext4_group_info **grp_info;
 	 long indexv, indexh;
 	 BUG_ON(group >= EXT4_SB(sb)->s_groups_count);
-	 grp_info = EXT4_SB(sb)->s_group_info;
 	 indexv = group >> (EXT4_DESC_PER_BLOCK_BITS(sb));
 	 indexh = group & ((EXT4_DESC_PER_BLOCK(sb)) - 1);
-	 return grp_info[indexv][indexh];
+	 grp_info = sbi_array_rcu_deref(EXT4_SB(sb), s_group_info, indexv);
+	 return grp_info[indexh];
 }
 
 /*
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index fb865216edb9b..745a89d30a57a 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2389,7 +2389,7 @@ int ext4_mb_alloc_groupinfo(struct super_block *sb, ext4_group_t ngroups)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	unsigned size;
-	struct ext4_group_info ***new_groupinfo;
+	struct ext4_group_info ***old_groupinfo, ***new_groupinfo;
 
 	size = (ngroups + EXT4_DESC_PER_BLOCK(sb) - 1) >>
 		EXT4_DESC_PER_BLOCK_BITS(sb);
@@ -2402,13 +2402,16 @@ int ext4_mb_alloc_groupinfo(struct super_block *sb, ext4_group_t ngroups)
 		ext4_msg(sb, KERN_ERR, "can't allocate buddy meta group");
 		return -ENOMEM;
 	}
-	if (sbi->s_group_info) {
-		memcpy(new_groupinfo, sbi->s_group_info,
+	rcu_read_lock();
+	old_groupinfo = rcu_dereference(sbi->s_group_info);
+	if (old_groupinfo)
+		memcpy(new_groupinfo, old_groupinfo,
 		       sbi->s_group_info_size * sizeof(*sbi->s_group_info));
-		kvfree(sbi->s_group_info);
-	}
-	sbi->s_group_info = new_groupinfo;
+	rcu_read_unlock();
+	rcu_assign_pointer(sbi->s_group_info, new_groupinfo);
 	sbi->s_group_info_size = size / sizeof(*sbi->s_group_info);
+	if (old_groupinfo)
+		ext4_kvfree_array_rcu(old_groupinfo);
 	ext4_debug("allocated s_groupinfo array for %d meta_bg's\n", 
 		   sbi->s_group_info_size);
 	return 0;
@@ -2420,6 +2423,7 @@ int ext4_mb_add_groupinfo(struct super_block *sb, ext4_group_t group,
 {
 	int i;
 	int metalen = 0;
+	int idx = group >> EXT4_DESC_PER_BLOCK_BITS(sb);
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct ext4_group_info **meta_group_info;
 	struct kmem_cache *cachep = get_groupinfo_cache(sb->s_blocksize_bits);
@@ -2438,12 +2442,12 @@ int ext4_mb_add_groupinfo(struct super_block *sb, ext4_group_t group,
 				 "for a buddy group");
 			goto exit_meta_group_info;
 		}
-		sbi->s_group_info[group >> EXT4_DESC_PER_BLOCK_BITS(sb)] =
-			meta_group_info;
+		rcu_read_lock();
+		rcu_dereference(sbi->s_group_info)[idx] = meta_group_info;
+		rcu_read_unlock();
 	}
 
-	meta_group_info =
-		sbi->s_group_info[group >> EXT4_DESC_PER_BLOCK_BITS(sb)];
+	meta_group_info = sbi_array_rcu_deref(sbi, s_group_info, idx);
 	i = group & (EXT4_DESC_PER_BLOCK(sb) - 1);
 
 	meta_group_info[i] = kmem_cache_zalloc(cachep, GFP_NOFS);
@@ -2491,8 +2495,13 @@ int ext4_mb_add_groupinfo(struct super_block *sb, ext4_group_t group,
 exit_group_info:
 	/* If a meta_group_info table has been allocated, release it now */
 	if (group % EXT4_DESC_PER_BLOCK(sb) == 0) {
-		kfree(sbi->s_group_info[group >> EXT4_DESC_PER_BLOCK_BITS(sb)]);
-		sbi->s_group_info[group >> EXT4_DESC_PER_BLOCK_BITS(sb)] = NULL;
+		struct ext4_group_info ***group_info;
+
+		rcu_read_lock();
+		group_info = rcu_dereference(sbi->s_group_info);
+		kfree(group_info[idx]);
+		group_info[idx] = NULL;
+		rcu_read_unlock();
 	}
 exit_meta_group_info:
 	return -ENOMEM;
@@ -2505,6 +2514,7 @@ static int ext4_mb_init_backend(struct super_block *sb)
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	int err;
 	struct ext4_group_desc *desc;
+	struct ext4_group_info ***group_info;
 	struct kmem_cache *cachep;
 
 	err = ext4_mb_alloc_groupinfo(sb, ngroups);
@@ -2539,11 +2549,16 @@ err_freebuddy:
 	while (i-- > 0)
 		kmem_cache_free(cachep, ext4_get_group_info(sb, i));
 	i = sbi->s_group_info_size;
+	rcu_read_lock();
+	group_info = rcu_dereference(sbi->s_group_info);
 	while (i-- > 0)
-		kfree(sbi->s_group_info[i]);
+		kfree(group_info[i]);
+	rcu_read_unlock();
 	iput(sbi->s_buddy_cache);
 err_freesgi:
-	kvfree(sbi->s_group_info);
+	rcu_read_lock();
+	kvfree(rcu_dereference(sbi->s_group_info));
+	rcu_read_unlock();
 	return -ENOMEM;
 }
 
@@ -2733,7 +2748,7 @@ int ext4_mb_release(struct super_block *sb)
 	ext4_group_t ngroups = ext4_get_groups_count(sb);
 	ext4_group_t i;
 	int num_meta_group_infos;
-	struct ext4_group_info *grinfo;
+	struct ext4_group_info *grinfo, ***group_info;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct kmem_cache *cachep = get_groupinfo_cache(sb->s_blocksize_bits);
 
@@ -2751,9 +2766,12 @@ int ext4_mb_release(struct super_block *sb)
 		num_meta_group_infos = (ngroups +
 				EXT4_DESC_PER_BLOCK(sb) - 1) >>
 			EXT4_DESC_PER_BLOCK_BITS(sb);
+		rcu_read_lock();
+		group_info = rcu_dereference(sbi->s_group_info);
 		for (i = 0; i < num_meta_group_infos; i++)
-			kfree(sbi->s_group_info[i]);
-		kvfree(sbi->s_group_info);
+			kfree(group_info[i]);
+		kvfree(group_info);
+		rcu_read_unlock();
 	}
 	kfree(sbi->s_mb_offsets);
 	kfree(sbi->s_mb_maxs);
-- 
2.20.1



