Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59139CA17B
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 17:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730488AbfJCP4R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 11:56:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:38042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730541AbfJCP4Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 11:56:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8906921848;
        Thu,  3 Oct 2019 15:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570118174;
        bh=xVnqa8oy56HQ1o0nv3jNb85HbXSpjVFmjg9sZlCBZws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TE32caY8yc1e89Jtp9ulhy3fZ/Iu1sSTQpxfkvh0ejyouw9zt8iB4ygakChQCsIVa
         wBVH/w81DjlJXHgeUVA3DC1COylMJqwVgnE94fzuutTIMXDQOtZw0371SGN02ey4rs
         D7v1LahmRrhHSLGhu8Eoo2/EjSHZWzqlG/c0jdDo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 17/99] f2fs: fix to do sanity check on segment bitmap of LFS curseg
Date:   Thu,  3 Oct 2019 17:52:40 +0200
Message-Id: <20191003154302.103100907@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154252.297991283@linuxfoundation.org>
References: <20191003154252.297991283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit c854f4d681365498f53ba07843a16423625aa7e9 ]

As Jungyeon Reported in bugzilla:

https://bugzilla.kernel.org/show_bug.cgi?id=203233

- Reproduces
gcc poc_13.c
./run.sh f2fs

- Kernel messages
 F2FS-fs (sdb): Bitmap was wrongly set, blk:4608
 kernel BUG at fs/f2fs/segment.c:2133!
 RIP: 0010:update_sit_entry+0x35d/0x3e0
 Call Trace:
  f2fs_allocate_data_block+0x16c/0x5a0
  do_write_page+0x57/0x100
  f2fs_do_write_node_page+0x33/0xa0
  __write_node_page+0x270/0x4e0
  f2fs_sync_node_pages+0x5df/0x670
  f2fs_write_checkpoint+0x364/0x13a0
  f2fs_sync_fs+0xa3/0x130
  f2fs_do_sync_file+0x1a6/0x810
  do_fsync+0x33/0x60
  __x64_sys_fsync+0xb/0x10
  do_syscall_64+0x43/0x110
  entry_SYSCALL_64_after_hwframe+0x44/0xa9

The testcase fails because that, in fuzzed image, current segment was
allocated with LFS type, its .next_blkoff should point to an unused
block address, but actually, its bitmap shows it's not. So during
allocation, f2fs crash when setting bitmap.

Introducing sanity_check_curseg() to check such inconsistence of
current in-used segment.

Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/segment.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 6802cd754eda0..e482cca005a61 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -2262,6 +2262,41 @@ static int build_dirty_segmap(struct f2fs_sb_info *sbi)
 	return init_victim_secmap(sbi);
 }
 
+static int sanity_check_curseg(struct f2fs_sb_info *sbi)
+{
+	int i;
+
+	/*
+	 * In LFS/SSR curseg, .next_blkoff should point to an unused blkaddr;
+	 * In LFS curseg, all blkaddr after .next_blkoff should be unused.
+	 */
+	for (i = 0; i < NO_CHECK_TYPE; i++) {
+		struct curseg_info *curseg = CURSEG_I(sbi, i);
+		struct seg_entry *se = get_seg_entry(sbi, curseg->segno);
+		unsigned int blkofs = curseg->next_blkoff;
+
+		if (f2fs_test_bit(blkofs, se->cur_valid_map))
+			goto out;
+
+		if (curseg->alloc_type == SSR)
+			continue;
+
+		for (blkofs += 1; blkofs < sbi->blocks_per_seg; blkofs++) {
+			if (!f2fs_test_bit(blkofs, se->cur_valid_map))
+				continue;
+out:
+			f2fs_msg(sbi->sb, KERN_ERR,
+				"Current segment's next free block offset is "
+				"inconsistent with bitmap, logtype:%u, "
+				"segno:%u, type:%u, next_blkoff:%u, blkofs:%u",
+				i, curseg->segno, curseg->alloc_type,
+				curseg->next_blkoff, blkofs);
+			return -EINVAL;
+		}
+	}
+	return 0;
+}
+
 /*
  * Update min, max modified time for cost-benefit GC algorithm
  */
@@ -2350,6 +2385,10 @@ int build_segment_manager(struct f2fs_sb_info *sbi)
 	if (err)
 		return err;
 
+	err = sanity_check_curseg(sbi);
+	if (err)
+		return err;
+
 	init_min_max_mtime(sbi);
 	return 0;
 }
-- 
2.20.1



