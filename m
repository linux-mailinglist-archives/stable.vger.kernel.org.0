Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 932832E99B3
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:06:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728924AbhADQCs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 11:02:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:40050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728923AbhADQCr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 11:02:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D137922507;
        Mon,  4 Jan 2021 16:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609776127;
        bh=HIM2v6vI3cY74c/MGF1FQ3nkAj/6I+7FVjZptPJnY4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yFE9mT3LDDuaE6Z9sZsVnHidKUxe/6d3CFgls4ZbT6HT5nfWYuaJN8AEZRSlYcpix
         zaTlnYV1TDbKLkTkxDEJWOzAuIkBZ/cgiH8YyAacWXYdyhwzo4VZrjcKMNLnxQep47
         6Cudx3JrRWqDrjZVrUn8EXAtSgqGxKaYSWBVqoCA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+ca9a785f8ac472085994@syzkaller.appspotmail.com,
        Anant Thazhemadam <anant.thazhemadam@gmail.com>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.10 32/63] f2fs: fix shift-out-of-bounds in sanity_check_raw_super()
Date:   Mon,  4 Jan 2021 16:57:25 +0100
Message-Id: <20210104155710.379545360@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210104155708.800470590@linuxfoundation.org>
References: <20210104155708.800470590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

commit e584bbe821229a3e7cc409eecd51df66f9268c21 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/f2fs/super.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -2744,7 +2744,6 @@ static int sanity_check_raw_super(struct
 	block_t total_sections, blocks_per_seg;
 	struct f2fs_super_block *raw_super = (struct f2fs_super_block *)
 					(bh->b_data + F2FS_SUPER_OFFSET);
-	unsigned int blocksize;
 	size_t crc_offset = 0;
 	__u32 crc = 0;
 
@@ -2778,10 +2777,10 @@ static int sanity_check_raw_super(struct
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
 


