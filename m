Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A00DD44355
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389710AbfFMQ2o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:28:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:53368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730943AbfFMIfm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:35:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70D5220851;
        Thu, 13 Jun 2019 08:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560414940;
        bh=syq1Gx9UY15BZ1F/DXaJMoqRWfqNyuoQf1lqnzj7ODI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HmAHqk+o2QISpn3CTT+qhPZ7tqohQ3DDd5Y+G7wTFR7o3hchoQ6eFJE1bx8h9Qt1m
         53jlRsWWrd4WILrjPIDpeo/HCLHGYJCvCdjBxcBu4CFsNwsf71mR3Btqma0/1dwin5
         o/gPtrNgbVD4dbUrycxKvoKk0GVHJkH989Rt93sA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 28/81] f2fs: fix to avoid panic in dec_valid_block_count()
Date:   Thu, 13 Jun 2019 10:33:11 +0200
Message-Id: <20190613075651.205726912@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075649.074682929@linuxfoundation.org>
References: <20190613075649.074682929@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 5e159cd349bf3a31fb7e35c23a93308eb30f4f71 ]

As Jungyeon reported in bugzilla:

https://bugzilla.kernel.org/show_bug.cgi?id=203209

- Overview
When mounting the attached crafted image and running program, I got this error.
Additionally, it hangs on sync after the this script.

The image is intentionally fuzzed from a normal f2fs image for testing and I enabled option CONFIG_F2FS_CHECK_FS on.

- Reproduces
cc poc_01.c
./run.sh f2fs
sync

 kernel BUG at fs/f2fs/f2fs.h:1788!
 RIP: 0010:f2fs_truncate_data_blocks_range+0x342/0x350
 Call Trace:
  f2fs_truncate_blocks+0x36d/0x3c0
  f2fs_truncate+0x88/0x110
  f2fs_setattr+0x3e1/0x460
  notify_change+0x2da/0x400
  do_truncate+0x6d/0xb0
  do_sys_ftruncate+0xf1/0x160
  do_syscall_64+0x43/0xf0
  entry_SYSCALL_64_after_hwframe+0x44/0xa9

The reason is dec_valid_block_count() will trigger kernel panic due to
inconsistent count in between inode.i_blocks and actual block.

To avoid panic, let's just print debug message and set SBI_NEED_FSCK to
give a hint to fsck for latter repairing.

Signed-off-by: Chao Yu <yuchao0@huawei.com>
[Jaegeuk Kim: fix build warning and add unlikely]
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/f2fs.h | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 406d93b51a0b..6caae471c1a4 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1550,6 +1550,7 @@ enospc:
 	return -ENOSPC;
 }
 
+void f2fs_msg(struct super_block *sb, const char *level, const char *fmt, ...);
 static inline void dec_valid_block_count(struct f2fs_sb_info *sbi,
 						struct inode *inode,
 						block_t count)
@@ -1558,9 +1559,17 @@ static inline void dec_valid_block_count(struct f2fs_sb_info *sbi,
 
 	spin_lock(&sbi->stat_lock);
 	f2fs_bug_on(sbi, sbi->total_valid_block_count < (block_t) count);
-	f2fs_bug_on(sbi, inode->i_blocks < sectors);
 	sbi->total_valid_block_count -= (block_t)count;
 	spin_unlock(&sbi->stat_lock);
+	if (unlikely(inode->i_blocks < sectors)) {
+		f2fs_msg(sbi->sb, KERN_WARNING,
+			"Inconsistent i_blocks, ino:%lu, iblocks:%llu, sectors:%llu",
+			inode->i_ino,
+			(unsigned long long)inode->i_blocks,
+			(unsigned long long)sectors);
+		set_sbi_flag(sbi, SBI_NEED_FSCK);
+		return;
+	}
 	f2fs_i_blocks_write(inode, count, false, true);
 }
 
@@ -2382,7 +2391,6 @@ static inline void f2fs_update_iostat(struct f2fs_sb_info *sbi,
 
 bool f2fs_is_valid_blkaddr(struct f2fs_sb_info *sbi,
 					block_t blkaddr, int type);
-void f2fs_msg(struct super_block *sb, const char *level, const char *fmt, ...);
 static inline void verify_blkaddr(struct f2fs_sb_info *sbi,
 					block_t blkaddr, int type)
 {
-- 
2.20.1



