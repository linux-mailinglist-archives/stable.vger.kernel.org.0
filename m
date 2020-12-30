Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DFCB2E794E
	for <lists+stable@lfdr.de>; Wed, 30 Dec 2020 14:13:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727179AbgL3NEt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Dec 2020 08:04:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:53862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727178AbgL3NEt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Dec 2020 08:04:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D67C82246B;
        Wed, 30 Dec 2020 13:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609333414;
        bh=C9hcqauHOaCCV2L6Dik3xMUE0f5g0Niw9GjqsOC0III=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c9Z8tFKNvdckG3VLkBsyoxvCkDMbEsJCRe01X8tamqh3fZcxsImyeUjhFrvIdK05c
         ror1iUb/ADttJhAwUjbkk2OHsZyT9OGbgdplCezN70SxBAEFp5haNvr8hvkxAsc7Pq
         aVXdeOl2GckDuEQ49plSHSdhqsozcegqS5T2tDxPzdO6FUzMPLzSgov0hEhjaUybna
         6pgn+IHbAOBcU6JvxPh6xv0PuOiQ76z545am+X39C7d6x+kGx48biMiJ1oX4qUL03h
         rQ9LvKWTYGWXNrGwUR3sCMlASw0KUix6HXZjqNz8dfWFIkK3/VG7LqN9L+obVnFP4x
         h+nXBaVLTWrRw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chao Yu <yuchao0@huawei.com>,
        syzbot+ca9a785f8ac472085994@syzkaller.appspotmail.com,
        Anant Thazhemadam <anant.thazhemadam@gmail.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.10 15/31] f2fs: fix shift-out-of-bounds in sanity_check_raw_super()
Date:   Wed, 30 Dec 2020 08:02:57 -0500
Message-Id: <20201230130314.3636961-15-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201230130314.3636961-1-sashal@kernel.org>
References: <20201230130314.3636961-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit e584bbe821229a3e7cc409eecd51df66f9268c21 ]

syzbot reported a bug which could cause shift-out-of-bounds issue,
fix it.

Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:120
 ubsan_epilogue+0xb/0x5a lib/ubsan.c:148
 __ubsan_handle_shift_out_of_bounds.cold+0xb1/0x181 lib/ubsan.c:395
 sanity_check_raw_super fs/f2fs/super.c:2812 [inline]
 read_raw_super_block fs/f2fs/super.c:3267 [inline]
 f2fs_fill_super.cold+0x16c9/0x16f6 fs/f2fs/super.c:3519
 mount_bdev+0x34d/0x410 fs/super.c:1366
 legacy_get_tree+0x105/0x220 fs/fs_context.c:592
 vfs_get_tree+0x89/0x2f0 fs/super.c:1496
 do_new_mount fs/namespace.c:2896 [inline]
 path_mount+0x12ae/0x1e70 fs/namespace.c:3227
 do_mount fs/namespace.c:3240 [inline]
 __do_sys_mount fs/namespace.c:3448 [inline]
 __se_sys_mount fs/namespace.c:3425 [inline]
 __x64_sys_mount+0x27f/0x300 fs/namespace.c:3425
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Reported-by: syzbot+ca9a785f8ac472085994@syzkaller.appspotmail.com
Signed-off-by: Anant Thazhemadam <anant.thazhemadam@gmail.com>
Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/super.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index ba859eeca69a3..822ae8c8fa39a 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -2744,7 +2744,6 @@ static int sanity_check_raw_super(struct f2fs_sb_info *sbi,
 	block_t total_sections, blocks_per_seg;
 	struct f2fs_super_block *raw_super = (struct f2fs_super_block *)
 					(bh->b_data + F2FS_SUPER_OFFSET);
-	unsigned int blocksize;
 	size_t crc_offset = 0;
 	__u32 crc = 0;
 
@@ -2778,10 +2777,10 @@ static int sanity_check_raw_super(struct f2fs_sb_info *sbi,
 	}
 
 	/* Currently, support only 4KB block size */
-	blocksize = 1 << le32_to_cpu(raw_super->log_blocksize);
-	if (blocksize != F2FS_BLKSIZE) {
-		f2fs_info(sbi, "Invalid blocksize (%u), supports only 4KB",
-			  blocksize);
+	if (le32_to_cpu(raw_super->log_blocksize) != F2FS_BLKSIZE_BITS) {
+		f2fs_info(sbi, "Invalid log_blocksize (%u), supports only %u",
+			  le32_to_cpu(raw_super->log_blocksize),
+			  F2FS_BLKSIZE_BITS);
 		return -EFSCORRUPTED;
 	}
 
-- 
2.27.0

