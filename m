Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B830231C12
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 15:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727931AbfFANSr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 09:18:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:45846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727927AbfFANSq (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Jun 2019 09:18:46 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51605251C3;
        Sat,  1 Jun 2019 13:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559395125;
        bh=J2yOwORdmrecDjLFH3ISsJjO+lk7FMepCgKXfVDcXOc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uWi2OVM3QKGbPaVHURootw6iJvIUYFHMW8Tnlhp9V0uwrAjtJjyJkdeQuWUicio9K
         KqJdyw3Qdlh6aShSloqENrySy3qj0fQ0QnYAa8w+TaHESpiHfziPhbALsW+fiVWq+I
         ANC9Q0/livnlwQJ5zLZNTC1qMBTSJZkQ7jL01QA8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.1 049/186] f2fs: fix to avoid panic in dec_valid_block_count()
Date:   Sat,  1 Jun 2019 09:14:25 -0400
Message-Id: <20190601131653.24205-49-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190601131653.24205-1-sashal@kernel.org>
References: <20190601131653.24205-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

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
index 7bea1bc6589fd..74f06f12110f1 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1789,6 +1789,7 @@ static inline int inc_valid_block_count(struct f2fs_sb_info *sbi,
 	return -ENOSPC;
 }
 
+void f2fs_msg(struct super_block *sb, const char *level, const char *fmt, ...);
 static inline void dec_valid_block_count(struct f2fs_sb_info *sbi,
 						struct inode *inode,
 						block_t count)
@@ -1797,13 +1798,21 @@ static inline void dec_valid_block_count(struct f2fs_sb_info *sbi,
 
 	spin_lock(&sbi->stat_lock);
 	f2fs_bug_on(sbi, sbi->total_valid_block_count < (block_t) count);
-	f2fs_bug_on(sbi, inode->i_blocks < sectors);
 	sbi->total_valid_block_count -= (block_t)count;
 	if (sbi->reserved_blocks &&
 		sbi->current_reserved_blocks < sbi->reserved_blocks)
 		sbi->current_reserved_blocks = min(sbi->reserved_blocks,
 					sbi->current_reserved_blocks + count);
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
 
@@ -2817,7 +2826,6 @@ static inline void f2fs_update_iostat(struct f2fs_sb_info *sbi,
 
 bool f2fs_is_valid_blkaddr(struct f2fs_sb_info *sbi,
 					block_t blkaddr, int type);
-void f2fs_msg(struct super_block *sb, const char *level, const char *fmt, ...);
 static inline void verify_blkaddr(struct f2fs_sb_info *sbi,
 					block_t blkaddr, int type)
 {
-- 
2.20.1

