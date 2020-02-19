Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 983AD163AD4
	for <lists+stable@lfdr.de>; Wed, 19 Feb 2020 04:10:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728213AbgBSDK3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 22:10:29 -0500
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:23187 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728203AbgBSDK2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Feb 2020 22:10:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1582081828; x=1613617828;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=DhMXLWHV7d0ROSCfd/lCm0V7ffWZv48HScuqDT9+n30=;
  b=p4EHHQoztmHOVq17tJdK3NUqmzuzr56Q1P0QSXTrWRBbaCjGghyoa5vp
   b8dPuzZw6PKmyjpSvkEe03FYpqERdMmdAURGx8jtmHa8RrfyGs2FePR0e
   iWl8Cl9Kb1mHrNJtY3FGKzrvUVqb3unkO1kE8cXtTNd43Rt7BBIKfgzoJ
   E=;
IronPort-SDR: 5+qfslswfqxx2QKJijJrc0FF/YD8iucDC3YBnqtR0poUqW5sBF5qtHaHn8MC3jPlLsFgmBMDs2
 Y/3K5vltLOzQ==
X-IronPort-AV: E=Sophos;i="5.70,458,1574121600"; 
   d="scan'208";a="17534441"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 19 Feb 2020 03:10:25 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com (Postfix) with ESMTPS id BA401A2B89;
        Wed, 19 Feb 2020 03:10:23 +0000 (UTC)
Received: from EX13D30UWC001.ant.amazon.com (10.43.162.128) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 19 Feb 2020 03:10:22 +0000
Received: from u3c3f5cfe23135f.ant.amazon.com (10.43.161.235) by
 EX13D30UWC001.ant.amazon.com (10.43.162.128) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 19 Feb 2020 03:10:22 +0000
From:   Suraj Jitindar Singh <surajjs@amazon.com>
To:     <linux-ext4@vger.kernel.org>
CC:     <tytso@mit.edu>, <sblbir@amazon.com>, <sjitindarsingh@gmail.com>,
        "Suraj Jitindar Singh" <surajjs@amazon.com>,
        <stable@vger.kernel.org>
Subject: [PATCH 2/3] ext4: fix potential race between s_group_info online resizing and access
Date:   Tue, 18 Feb 2020 19:08:50 -0800
Message-ID: <20200219030851.2678-3-surajjs@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200219030851.2678-1-surajjs@amazon.com>
References: <20200219030851.2678-1-surajjs@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.235]
X-ClientProxiedBy: EX13D33UWB004.ant.amazon.com (10.43.161.225) To
 EX13D30UWC001.ant.amazon.com (10.43.162.128)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

During an online resize an array of pointers to s_group_info gets replaced
so it can get enlarged. If there is a concurrent access to the array in
ext4_get_group_info() and this memory has been reused then this can lead to
an invalid memory access.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=206443
Signed-off-by: Suraj Jitindar Singh <surajjs@amazon.com>
Cc: stable@vger.kernel.org
---
 fs/ext4/ext4.h    |  6 +++---
 fs/ext4/mballoc.c | 10 ++++++----
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 236fc6500340..3f4aaaae7da6 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
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
index f64838187559..0d9b17afc85f 100644
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
@@ -2369,13 +2369,15 @@ int ext4_mb_alloc_groupinfo(struct super_block *sb, ext4_group_t ngroups)
 		ext4_msg(sb, KERN_ERR, "can't allocate buddy meta group");
 		return -ENOMEM;
 	}
-	if (sbi->s_group_info) {
+	old_groupinfo = sbi->s_group_info;
+	if (sbi->s_group_info)
 		memcpy(new_groupinfo, sbi->s_group_info,
 		       sbi->s_group_info_size * sizeof(*sbi->s_group_info));
-		kvfree(sbi->s_group_info);
-	}
 	sbi->s_group_info = new_groupinfo;
+	rcu_assign_pointer(sbi->s_group_info, new_groupinfo);
 	sbi->s_group_info_size = size / sizeof(*sbi->s_group_info);
+	if (old_groupinfo)
+		ext4_kvfree_array_rcu(old_groupinfo);
 	ext4_debug("allocated s_groupinfo array for %d meta_bg's\n", 
 		   sbi->s_group_info_size);
 	return 0;
-- 
2.17.1

