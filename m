Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF1401743F6
	for <lists+stable@lfdr.de>; Sat, 29 Feb 2020 01:51:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726525AbgB2Ave (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Feb 2020 19:51:34 -0500
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:32050 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726359AbgB2Ave (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Feb 2020 19:51:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1582937493; x=1614473493;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=m3Ql53woLO/F9XUNDm4u00M8dKSU85m/fDMF/FcpdPw=;
  b=G7hlqb+CpTV9F+KylXb2FwiLxKYa1cSAPZPOAZuWX6JI7dzUM6DWavcM
   pzabnHxFLAJ7iQ9/jSvzYA53qmU3iZ8LTqJ5E674aQjeCgGuVyUb3NDjU
   FslWEVfH1W1QUPLS/dgKFQjA9RrqKaaUguDQWctPkXgraooM7X6jEGo76
   I=;
IronPort-SDR: pUG+RhIXZy6Z9pIiNHL1u3klBQIZ/Z0yPKUYnMzDqRUYyzP8IMr41FDx9sBChYkzk0Ql4VQbB2
 HWosIHrMje/w==
X-IronPort-AV: E=Sophos;i="5.70,498,1574121600"; 
   d="scan'208";a="28239118"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-c300ac87.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 29 Feb 2020 00:51:32 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-c300ac87.us-west-2.amazon.com (Postfix) with ESMTPS id 3F4D6A21A6;
        Sat, 29 Feb 2020 00:51:31 +0000 (UTC)
Received: from EX13D30UWC001.ant.amazon.com (10.43.162.128) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Sat, 29 Feb 2020 00:51:30 +0000
Received: from u3c3f5cfe23135f.ant.amazon.com (10.43.160.8) by
 EX13D30UWC001.ant.amazon.com (10.43.162.128) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Sat, 29 Feb 2020 00:51:30 +0000
From:   Suraj Jitindar Singh <surajjs@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <tytso@mit.edu>, <surajjs@amazon.com>, <stable@kernel.org>
Subject: [PATCH 4.4.x 4.9.x 2/3] ext4: fix potential race between s_group_info online resizing and access
Date:   Fri, 28 Feb 2020 16:51:18 -0800
Message-ID: <20200229005119.14635-2-surajjs@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200229005119.14635-1-surajjs@amazon.com>
References: <1582790919145241@kroah.com>
 <20200229005119.14635-1-surajjs@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.8]
X-ClientProxiedBy: EX13D19UWC002.ant.amazon.com (10.43.162.179) To
 EX13D30UWC001.ant.amazon.com (10.43.162.128)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit df3da4ea5a0fc5d115c90d5aa6caa4dd433750a7 upstream.

During an online resize an array of pointers to s_group_info gets replaced
so it can get enlarged. If there is a concurrent access to the array in
ext4_get_group_info() and this memory has been reused then this can lead to
an invalid memory access.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=206443
Link: https://lore.kernel.org/r/20200221053458.730016-3-tytso@mit.edu
Signed-off-by: Suraj Jitindar Singh <surajjs@amazon.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Balbir Singh <sblbir@amazon.com>
Cc: stable@kernel.org # 4.4.x
Cc: stable@kernel.org # 4.9.x

---

Changes against upstream:
none
---
 fs/ext4/ext4.h    |  8 ++++----
 fs/ext4/mballoc.c | 52 +++++++++++++++++++++++++++++++----------------
 2 files changed, 39 insertions(+), 21 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 87634a82294a..42a4f5058b40 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1427,7 +1427,7 @@ struct ext4_sb_info {
 #endif
 
 	/* for buddy allocator */
-	struct ext4_group_info ***s_group_info;
+	struct ext4_group_info ** __rcu *s_group_info;
 	struct inode *s_buddy_cache;
 	spinlock_t s_md_lock;
 	unsigned short *s_mb_offsets;
@@ -2810,13 +2810,13 @@ static inline
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
index a49d0e5d7baf..f3431ebe2a42 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2377,7 +2377,7 @@ int ext4_mb_alloc_groupinfo(struct super_block *sb, ext4_group_t ngroups)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	unsigned size;
-	struct ext4_group_info ***new_groupinfo;
+	struct ext4_group_info ***old_groupinfo, ***new_groupinfo;
 
 	size = (ngroups + EXT4_DESC_PER_BLOCK(sb) - 1) >>
 		EXT4_DESC_PER_BLOCK_BITS(sb);
@@ -2390,13 +2390,16 @@ int ext4_mb_alloc_groupinfo(struct super_block *sb, ext4_group_t ngroups)
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
@@ -2408,6 +2411,7 @@ int ext4_mb_add_groupinfo(struct super_block *sb, ext4_group_t group,
 {
 	int i;
 	int metalen = 0;
+	int idx = group >> EXT4_DESC_PER_BLOCK_BITS(sb);
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct ext4_group_info **meta_group_info;
 	struct kmem_cache *cachep = get_groupinfo_cache(sb->s_blocksize_bits);
@@ -2426,12 +2430,12 @@ int ext4_mb_add_groupinfo(struct super_block *sb, ext4_group_t group,
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
@@ -2479,8 +2483,13 @@ int ext4_mb_add_groupinfo(struct super_block *sb, ext4_group_t group,
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
@@ -2493,6 +2502,7 @@ static int ext4_mb_init_backend(struct super_block *sb)
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	int err;
 	struct ext4_group_desc *desc;
+	struct ext4_group_info ***group_info;
 	struct kmem_cache *cachep;
 
 	err = ext4_mb_alloc_groupinfo(sb, ngroups);
@@ -2527,11 +2537,16 @@ static int ext4_mb_init_backend(struct super_block *sb)
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
 
@@ -2720,7 +2735,7 @@ int ext4_mb_release(struct super_block *sb)
 	ext4_group_t ngroups = ext4_get_groups_count(sb);
 	ext4_group_t i;
 	int num_meta_group_infos;
-	struct ext4_group_info *grinfo;
+	struct ext4_group_info *grinfo, ***group_info;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct kmem_cache *cachep = get_groupinfo_cache(sb->s_blocksize_bits);
 
@@ -2738,9 +2753,12 @@ int ext4_mb_release(struct super_block *sb)
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
2.17.1

