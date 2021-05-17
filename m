Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A18F38333D
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241453AbhEQO4a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:56:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:48034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241779AbhEQOx5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:53:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D51DF619A4;
        Mon, 17 May 2021 14:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261463;
        bh=8mGtGjOgX4hSNx1mTSWhIVGIR8/WjeBDoGn9QAh5wc8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FKVThhHac4m8KCJ3mwoXuMd2VpVohJd0VLghyDegA8N+My1pkKjtW4fwgZMVtUCk+
         5jsXAujr6tuzAkoswlAooRT66YB3jU0SbZllyJ/cCUndjSRiAarpX9he1Avw6OOi9j
         7IKaBen0ytzlR3qBp0V3eJPrg62coPA3Zsl58VG0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 116/329] f2fs: fix panic during f2fs_resize_fs()
Date:   Mon, 17 May 2021 16:00:27 +0200
Message-Id: <20210517140306.029755431@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit 3ab0598e6d860ef49d029943ba80f627c15c15d6 ]

f2fs_resize_fs() hangs in below callstack with testcase:
- mkfs 16GB image & mount image
- dd 8GB fileA
- dd 8GB fileB
- sync
- rm fileA
- sync
- resize filesystem to 8GB

kernel BUG at segment.c:2484!
Call Trace:
 allocate_segment_by_default+0x92/0xf0 [f2fs]
 f2fs_allocate_data_block+0x44b/0x7e0 [f2fs]
 do_write_page+0x5a/0x110 [f2fs]
 f2fs_outplace_write_data+0x55/0x100 [f2fs]
 f2fs_do_write_data_page+0x392/0x850 [f2fs]
 move_data_page+0x233/0x320 [f2fs]
 do_garbage_collect+0x14d9/0x1660 [f2fs]
 free_segment_range+0x1f7/0x310 [f2fs]
 f2fs_resize_fs+0x118/0x330 [f2fs]
 __f2fs_ioctl+0x487/0x3680 [f2fs]
 __x64_sys_ioctl+0x8e/0xd0
 do_syscall_64+0x33/0x80
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

The root cause is we forgot to check that whether we have enough space
in resized filesystem to store all valid blocks in before-resizing
filesystem, then allocator will run out-of-space during block migration
in free_segment_range().

Fixes: b4b10061ef98 ("f2fs: refactor resize_fs to avoid meta updates in progress")
Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/gc.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 21ceec733066..b206797d202b 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -1979,7 +1979,20 @@ int f2fs_resize_fs(struct f2fs_sb_info *sbi, __u64 block_count)
 
 	/* stop CP to protect MAIN_SEC in free_segment_range */
 	f2fs_lock_op(sbi);
+
+	spin_lock(&sbi->stat_lock);
+	if (shrunk_blocks + valid_user_blocks(sbi) +
+		sbi->current_reserved_blocks + sbi->unusable_block_count +
+		F2FS_OPTION(sbi).root_reserved_blocks > sbi->user_block_count)
+		err = -ENOSPC;
+	spin_unlock(&sbi->stat_lock);
+
+	if (err)
+		goto out_unlock;
+
 	err = free_segment_range(sbi, secs, true);
+
+out_unlock:
 	f2fs_unlock_op(sbi);
 	up_write(&sbi->gc_lock);
 	if (err)
-- 
2.30.2



