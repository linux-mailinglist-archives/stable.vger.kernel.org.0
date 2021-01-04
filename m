Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC6102E9A7E
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:13:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728430AbhADQK3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 11:10:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:36472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728324AbhADQAY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 11:00:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A4249224DF;
        Mon,  4 Jan 2021 16:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609776009;
        bh=AKkNC5q/jAs62BW+60Z1IRvF09A1w+UnMmEbaouPr50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ix45OOme0k8g82co2vYbx9L9tT0pSF52cE4Psowb4p+g8jMyrIqjqS4TtdAKIN7Ds
         tYQkwUDcJ4xFCV8ZULdbM583Xf9EWc+HX68lZ3MUBkx53DOfO1Ze3Xfnq4V2mJI5pJ
         fW554z9S28fISri2uv2KUZr1Rik1GdlhAdsxCqLk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+ca9a785f8ac472085994@syzkaller.appspotmail.com,
        Anant Thazhemadam <anant.thazhemadam@gmail.com>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.4 29/47] f2fs: fix shift-out-of-bounds in sanity_check_raw_super()
Date:   Mon,  4 Jan 2021 16:57:28 +0100
Message-Id: <20210104155707.153228321@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210104155705.740576914@linuxfoundation.org>
References: <20210104155705.740576914@linuxfoundation.org>
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
@@ -2523,7 +2523,6 @@ static int sanity_check_raw_super(struct
 	block_t total_sections, blocks_per_seg;
 	struct f2fs_super_block *raw_super = (struct f2fs_super_block *)
 					(bh->b_data + F2FS_SUPER_OFFSET);
-	unsigned int blocksize;
 	size_t crc_offset = 0;
 	__u32 crc = 0;
 
@@ -2557,10 +2556,10 @@ static int sanity_check_raw_super(struct
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
 


