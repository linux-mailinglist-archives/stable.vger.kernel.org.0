Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 822D0171228
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 09:14:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728468AbgB0IN6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 03:13:58 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:32859 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726999AbgB0IN6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Feb 2020 03:13:58 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 6940121EAE;
        Thu, 27 Feb 2020 03:13:57 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 27 Feb 2020 03:13:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=N5tGbS
        AiSHzKzvfijEPPIfUQ77TyWq3iL/rCNpDGLzc=; b=QYpV7+3q9KRTmodO96wGd1
        BwVCBwKBKKefRBb51FM87r7wR8/OVLttcunC/y6JpNh38iiVoRuzf4fzOq0l4154
        RSAliuth7AEUMH4Qz315TiSjQd1qkDqVJAYfSIMPMNHPjl+234aDRK3NKp5l2MBd
        Zk0rL1fx2YCJRB/foTGbpWqM0tBLPFhkZaXHOfscFVbehw+BIieAu+akh/1pheOT
        JWRYYedoqA0KHBmmo8wNB5Q2he1yXMNLlEqRHTUUmnUzSbCSrSHQCiYLoNJsBILm
        brhSL9NHF197ZBay91SfJn8XIcQNl/Pn9U0FlxY4bYj053alOlrmYYYowirY5q5Q
        ==
X-ME-Sender: <xms:RHpXXodo9O5gr0QDufyxw30IHcLiP6gExdr8PJ1D5ysNNrnZkiBY4A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrleehgdduvdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhep
    ghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:RHpXXm_10mDBTporZkQ_W6lDYD3bDvFmCHfIT9YyWhd2n5MeI6zFEQ>
    <xmx:RHpXXpEEyg6zsUB5fqviARG-vtHVWbG90vu3nhfkrBDiEeURfUDRMg>
    <xmx:RHpXXmmSLpNUBAkiXkXZc4ULwfMZRxNYKy8xE4kL5wdhb0X44zQ_Nw>
    <xmx:RXpXXn17nVeoQXLkyEq3R2KVhDst60BgB3i5nzBn5y49kHYnM_Wufw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 88B16328005E;
        Thu, 27 Feb 2020 03:13:56 -0500 (EST)
Subject: FAILED: patch "[PATCH] ext4: fix potential race between s_group_info online resizing" failed to apply to 4.9-stable tree
To:     surajjs@amazon.com, sblbir@amazon.com, tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 27 Feb 2020 09:13:55 +0100
Message-ID: <1582791235108148@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From df3da4ea5a0fc5d115c90d5aa6caa4dd433750a7 Mon Sep 17 00:00:00 2001
From: Suraj Jitindar Singh <surajjs@amazon.com>
Date: Tue, 18 Feb 2020 19:08:50 -0800
Subject: [PATCH] ext4: fix potential race between s_group_info online resizing
 and access

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

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index b51003f75568..b1ece5329738 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1462,7 +1462,7 @@ struct ext4_sb_info {
 #endif
 
 	/* for buddy allocator */
-	struct ext4_group_info ***s_group_info;
+	struct ext4_group_info ** __rcu *s_group_info;
 	struct inode *s_buddy_cache;
 	spinlock_t s_md_lock;
 	unsigned short *s_mb_offsets;
@@ -2994,13 +2994,13 @@ static inline
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
index f64838187559..1b46fb63692a 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2356,7 +2356,7 @@ int ext4_mb_alloc_groupinfo(struct super_block *sb, ext4_group_t ngroups)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	unsigned size;
-	struct ext4_group_info ***new_groupinfo;
+	struct ext4_group_info ***old_groupinfo, ***new_groupinfo;
 
 	size = (ngroups + EXT4_DESC_PER_BLOCK(sb) - 1) >>
 		EXT4_DESC_PER_BLOCK_BITS(sb);
@@ -2369,13 +2369,16 @@ int ext4_mb_alloc_groupinfo(struct super_block *sb, ext4_group_t ngroups)
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
@@ -2387,6 +2390,7 @@ int ext4_mb_add_groupinfo(struct super_block *sb, ext4_group_t group,
 {
 	int i;
 	int metalen = 0;
+	int idx = group >> EXT4_DESC_PER_BLOCK_BITS(sb);
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct ext4_group_info **meta_group_info;
 	struct kmem_cache *cachep = get_groupinfo_cache(sb->s_blocksize_bits);
@@ -2405,12 +2409,12 @@ int ext4_mb_add_groupinfo(struct super_block *sb, ext4_group_t group,
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
@@ -2458,8 +2462,13 @@ int ext4_mb_add_groupinfo(struct super_block *sb, ext4_group_t group,
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
@@ -2472,6 +2481,7 @@ static int ext4_mb_init_backend(struct super_block *sb)
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	int err;
 	struct ext4_group_desc *desc;
+	struct ext4_group_info ***group_info;
 	struct kmem_cache *cachep;
 
 	err = ext4_mb_alloc_groupinfo(sb, ngroups);
@@ -2507,11 +2517,16 @@ err_freebuddy:
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
 
@@ -2700,7 +2715,7 @@ int ext4_mb_release(struct super_block *sb)
 	ext4_group_t ngroups = ext4_get_groups_count(sb);
 	ext4_group_t i;
 	int num_meta_group_infos;
-	struct ext4_group_info *grinfo;
+	struct ext4_group_info *grinfo, ***group_info;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct kmem_cache *cachep = get_groupinfo_cache(sb->s_blocksize_bits);
 
@@ -2719,9 +2734,12 @@ int ext4_mb_release(struct super_block *sb)
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

