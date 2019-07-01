Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 551BC44352
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731104AbfFMQ2n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:28:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:53394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730944AbfFMIfo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:35:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07CA320B7C;
        Thu, 13 Jun 2019 08:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560414943;
        bh=GtSWW75F0XdhVgcrmrN6VY/WoR8Vo3dIaE8DIRITH8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jlz/HWD0EySW5Tezm/4u6Jprnv/DhfgNmkbfJ585m6kzyL95Ex4C/fj6wcY+pqeWL
         wNLkZ4/RvdB1hNyxeJ5WdO8b0B/2IcOQcT5RIOABQ99EYhpQSQv6o5ML4k6jCJLJ4k
         wU3UqLpFFSRknoFvZz1h6CyiG2idwi2W8zY7mUFQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 29/81] f2fs: fix to do sanity check on valid block count of segment
Date:   Thu, 13 Jun 2019 10:33:12 +0200
Message-Id: <20190613075651.277733724@linuxfoundation.org>
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

[ Upstream commit e95bcdb2fefa129f37bd9035af1d234ca92ee4ef ]

As Jungyeon reported in bugzilla:

https://bugzilla.kernel.org/show_bug.cgi?id=203233

- Overview
When mounting the attached crafted image and running program, following errors are reported.
Additionally, it hangs on sync after running program.

The image is intentionally fuzzed from a normal f2fs image for testing.
Compile options for F2FS are as follows.
CONFIG_F2FS_FS=y
CONFIG_F2FS_STAT_FS=y
CONFIG_F2FS_FS_XATTR=y
CONFIG_F2FS_FS_POSIX_ACL=y
CONFIG_F2FS_CHECK_FS=y

- Reproduces
cc poc_13.c
mkdir test
mount -t f2fs tmp.img test
cp a.out test
cd test
sudo ./a.out
sync

- Kernel messages
 F2FS-fs (sdb): Bitmap was wrongly set, blk:4608
 kernel BUG at fs/f2fs/segment.c:2102!
 RIP: 0010:update_sit_entry+0x394/0x410
 Call Trace:
  f2fs_allocate_data_block+0x16f/0x660
  do_write_page+0x62/0x170
  f2fs_do_write_node_page+0x33/0xa0
  __write_node_page+0x270/0x4e0
  f2fs_sync_node_pages+0x5df/0x670
  f2fs_write_checkpoint+0x372/0x1400
  f2fs_sync_fs+0xa3/0x130
  f2fs_do_sync_file+0x1a6/0x810
  do_fsync+0x33/0x60
  __x64_sys_fsync+0xb/0x10
  do_syscall_64+0x43/0xf0
  entry_SYSCALL_64_after_hwframe+0x44/0xa9

sit.vblocks and sum valid block count in sit.valid_map may be
inconsistent, segment w/ zero vblocks will be treated as free
segment, while allocating in free segment, we may allocate a
free block, if its bitmap is valid previously, it can cause
kernel crash due to bitmap verification failure.

Anyway, to avoid further serious metadata inconsistence and
corruption, it is necessary and worth to detect SIT
inconsistence. So let's enable check_block_count() to verify
vblocks and valid_map all the time rather than do it only
CONFIG_F2FS_CHECK_FS is enabled.

Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/segment.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index 47348d98165b..e3d8826c5113 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -641,7 +641,6 @@ static inline void verify_block_addr(struct f2fs_io_info *fio, block_t blk_addr)
 static inline int check_block_count(struct f2fs_sb_info *sbi,
 		int segno, struct f2fs_sit_entry *raw_sit)
 {
-#ifdef CONFIG_F2FS_CHECK_FS
 	bool is_valid  = test_bit_le(0, raw_sit->valid_map) ? true : false;
 	int valid_blocks = 0;
 	int cur_pos = 0, next_pos;
@@ -668,7 +667,7 @@ static inline int check_block_count(struct f2fs_sb_info *sbi,
 		set_sbi_flag(sbi, SBI_NEED_FSCK);
 		return -EINVAL;
 	}
-#endif
+
 	/* check segment usage, and check boundary of a given segment number */
 	if (unlikely(GET_SIT_VBLOCKS(raw_sit) > sbi->blocks_per_seg
 					|| segno > TOTAL_SEGS(sbi) - 1)) {
-- 
2.20.1



