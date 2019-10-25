Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C486E4CDB
	for <lists+stable@lfdr.de>; Fri, 25 Oct 2019 15:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2632810AbfJYN4O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Oct 2019 09:56:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:50504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2632795AbfJYN4O (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Oct 2019 09:56:14 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C54B222CB;
        Fri, 25 Oct 2019 13:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572011773;
        bh=NcEaAectkCFyZ7qca4yYHQDM+lDAU9HA63XtClUPuzA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uaeAnNRjOcwx6bnQ73txwedDDJ9HGmaTTkRrYOHXIuIBSiubcSNd2hdphqAbFyBHs
         jA9cq7lMXMb/IJQUUanL9NHZtzV/y1zupgPdB/ZkajETq10a2DxPlAd/bY/LiHrx4r
         aa9WrzqZCwgFMK6YlxDJlWZOkS19nfD/Uao/0a4I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.19 05/37] f2fs: fix to do sanity check on valid node/block count
Date:   Fri, 25 Oct 2019 09:55:29 -0400
Message-Id: <20191025135603.25093-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191025135603.25093-1-sashal@kernel.org>
References: <20191025135603.25093-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit 7b63f72f73af57bb040f03b9713ec9979d8911f4 ]

As Jungyeon reported in bugzilla:

https://bugzilla.kernel.org/show_bug.cgi?id=203229

- Overview
When mounting the attached crafted image, following errors are reported.
Additionally, it hangs on sync after trying to mount it.

The image is intentionally fuzzed from a normal f2fs image for testing.
Compile options for F2FS are as follows.
CONFIG_F2FS_FS=y
CONFIG_F2FS_STAT_FS=y
CONFIG_F2FS_FS_XATTR=y
CONFIG_F2FS_FS_POSIX_ACL=y
CONFIG_F2FS_CHECK_FS=y

- Reproduces
mkdir test
mount -t f2fs tmp.img test
sync

- Kernel message
 kernel BUG at fs/f2fs/recovery.c:591!
 RIP: 0010:recover_data+0x12d8/0x1780
 Call Trace:
  f2fs_recover_fsync_data+0x613/0x710
  f2fs_fill_super+0x1043/0x1aa0
  mount_bdev+0x16d/0x1a0
  mount_fs+0x4a/0x170
  vfs_kern_mount+0x5d/0x100
  do_mount+0x200/0xcf0
  ksys_mount+0x79/0xc0
  __x64_sys_mount+0x1c/0x20
  do_syscall_64+0x43/0xf0
  entry_SYSCALL_64_after_hwframe+0x44/0xa9

With corrupted image wihch has out-of-range valid node/block count, during
recovery, once we failed due to no free space, it will trigger kernel
panic.

Adding sanity check on valid node/block count in f2fs_sanity_check_ckpt()
to detect such condition, so that potential panic can be avoided.

Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/super.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 6851afc3bf805..3fc96cffe6ac5 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -2344,7 +2344,8 @@ int f2fs_sanity_check_ckpt(struct f2fs_sb_info *sbi)
 	unsigned int log_blocks_per_seg;
 	unsigned int segment_count_main;
 	unsigned int cp_pack_start_sum, cp_payload;
-	block_t user_block_count;
+	block_t user_block_count, valid_user_blocks;
+	block_t avail_node_count, valid_node_count;
 	int i, j;
 
 	total = le32_to_cpu(raw_super->segment_count);
@@ -2379,6 +2380,24 @@ int f2fs_sanity_check_ckpt(struct f2fs_sb_info *sbi)
 		return 1;
 	}
 
+	valid_user_blocks = le64_to_cpu(ckpt->valid_block_count);
+	if (valid_user_blocks > user_block_count) {
+		f2fs_msg(sbi->sb, KERN_ERR,
+			"Wrong valid_user_blocks: %u, user_block_count: %u",
+			valid_user_blocks, user_block_count);
+		return 1;
+	}
+
+	valid_node_count = le32_to_cpu(ckpt->valid_node_count);
+	avail_node_count = sbi->total_node_count - sbi->nquota_files -
+						F2FS_RESERVED_NODE_NUM;
+	if (valid_node_count > avail_node_count) {
+		f2fs_msg(sbi->sb, KERN_ERR,
+			"Wrong valid_node_count: %u, avail_node_count: %u",
+			valid_node_count, avail_node_count);
+		return 1;
+	}
+
 	main_segs = le32_to_cpu(raw_super->segment_count_main);
 	blocks_per_seg = sbi->blocks_per_seg;
 
-- 
2.20.1

