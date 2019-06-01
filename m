Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CA6931ECD
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 15:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728506AbfFANir (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 09:38:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:48752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728497AbfFANVZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Jun 2019 09:21:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E764272E7;
        Sat,  1 Jun 2019 13:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559395285;
        bh=GUBnE26ObaEZ2rJdkXbyFoQ6Kso2IScR5Y/JntbeDtU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bkcrFf4eq+8nheCLmBt/XLZkpXSzFGZPWhVvnFCwh1SpWY4H1WIKk95nAFBQAQ/80
         3U2upBWnx2OOBEm0rRFPXuN25FgNrwL+ngS7S+xiw0i0Rkh49xPglJ3T62t1aCnA1q
         aPcet33tiyonMO051xA2mteQ/hKFyOL3bLRXG+NY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.0 048/173] f2fs: fix to avoid panic in dec_valid_node_count()
Date:   Sat,  1 Jun 2019 09:17:20 -0400
Message-Id: <20190601131934.25053-48-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190601131934.25053-1-sashal@kernel.org>
References: <20190601131934.25053-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit ea6d7e72fea49402aa445345aade7a26b81732e3 ]

As Jungyeon reported in bugzilla:

https://bugzilla.kernel.org/show_bug.cgi?id=203213

- Overview
When mounting the attached crafted image and running program, I got this error.
Additionally, it hangs on sync after running the this script.

The image is intentionally fuzzed from a normal f2fs image for testing and I enabled option CONFIG_F2FS_CHECK_FS on.

- Reproduces
mkdir test
mount -t f2fs tmp.img test
cp a.out test
cd test
sudo ./a.out
sync

 kernel BUG at fs/f2fs/f2fs.h:2012!
 RIP: 0010:truncate_node+0x2c9/0x2e0
 Call Trace:
  f2fs_truncate_xattr_node+0xa1/0x130
  f2fs_remove_inode_page+0x82/0x2d0
  f2fs_evict_inode+0x2a3/0x3a0
  evict+0xba/0x180
  __dentry_kill+0xbe/0x160
  dentry_kill+0x46/0x180
  dput+0xbb/0x100
  do_renameat2+0x3c9/0x550
  __x64_sys_rename+0x17/0x20
  do_syscall_64+0x43/0xf0
  entry_SYSCALL_64_after_hwframe+0x44/0xa9

The reason is dec_valid_node_count() will trigger kernel panic due to
inconsistent count in between inode.i_blocks and actual block.

To avoid panic, let's just print debug message and set SBI_NEED_FSCK to
give a hint to fsck for latter repairing.

Signed-off-by: Chao Yu <yuchao0@huawei.com>
[Jaegeuk Kim: fix build warning and add unlikely]
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/f2fs.h | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 2149d1f190d62..1686d09db3f1a 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -2028,7 +2028,6 @@ static inline void dec_valid_node_count(struct f2fs_sb_info *sbi,
 
 	f2fs_bug_on(sbi, !sbi->total_valid_block_count);
 	f2fs_bug_on(sbi, !sbi->total_valid_node_count);
-	f2fs_bug_on(sbi, !is_inode && !inode->i_blocks);
 
 	sbi->total_valid_node_count--;
 	sbi->total_valid_block_count--;
@@ -2038,10 +2037,19 @@ static inline void dec_valid_node_count(struct f2fs_sb_info *sbi,
 
 	spin_unlock(&sbi->stat_lock);
 
-	if (is_inode)
+	if (is_inode) {
 		dquot_free_inode(inode);
-	else
+	} else {
+		if (unlikely(inode->i_blocks == 0)) {
+			f2fs_msg(sbi->sb, KERN_WARNING,
+				"Inconsistent i_blocks, ino:%lu, iblocks:%llu",
+				inode->i_ino,
+				(unsigned long long)inode->i_blocks);
+			set_sbi_flag(sbi, SBI_NEED_FSCK);
+			return;
+		}
 		f2fs_i_blocks_write(inode, 1, false, true);
+	}
 }
 
 static inline unsigned int valid_node_count(struct f2fs_sb_info *sbi)
-- 
2.20.1

