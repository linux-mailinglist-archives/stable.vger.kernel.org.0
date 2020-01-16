Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47D3013ED12
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:01:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405746AbgAPRlh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:41:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:59264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405739AbgAPRlg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:41:36 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5D7124724;
        Thu, 16 Jan 2020 17:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196495;
        bh=lqrIGMuhw2YUdZMNtbC+hPhbBIxoi+KdmiQHRp4jedg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g9jQsq3oUg98Ms9bAlSSyZT8Oq914S6Dp5Rsba9Mj4AlRb7UahjKvqGg0XBM4lTGg
         wMngyNGbV6QeCxY4CTD7B3lXS/qRFrQVUqKGChcN/ktmZUwFQludX9U216hVHtfrWB
         uBekmljBfm07mk1b6tZpu5w59sN8/x9dqgWg6RVE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.9 238/251] f2fs: fix potential overflow
Date:   Thu, 16 Jan 2020 12:36:27 -0500
Message-Id: <20200116173641.22137-198-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116173641.22137-1-sashal@kernel.org>
References: <20200116173641.22137-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit a9af3fdcc4258af406879eca63d82e9d6baa892e ]

In build_sit_entries(), if valid_blocks in SIT block is smaller than
valid_blocks in journal, for below calculation:

sbi->discard_blks += old_valid_blocks - se->valid_blocks;

There will be two times potential overflow:
- old_valid_blocks - se->valid_blocks will overflow, and be a very
large number.
- sbi->discard_blks += result will overflow again, comes out a correct
result accidently.

Anyway, it should be fixed.

Fixes: d600af236da5 ("f2fs: avoid unneeded loop in build_sit_entries")
Fixes: 1f43e2ad7bff ("f2fs: introduce CP_TRIMMED_FLAG to avoid unneeded discard")
Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/data.c | 2 +-
 fs/f2fs/file.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 0206c8c20784..b2cccd4083b8 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -1267,7 +1267,7 @@ static int f2fs_write_data_page(struct page *page,
 	loff_t i_size = i_size_read(inode);
 	const pgoff_t end_index = ((unsigned long long) i_size)
 							>> PAGE_SHIFT;
-	loff_t psize = (page->index + 1) << PAGE_SHIFT;
+	loff_t psize = (loff_t)(page->index + 1) << PAGE_SHIFT;
 	unsigned offset = 0;
 	bool need_balance_fs = false;
 	int err = 0;
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index f46ac1651bd5..e3c438c8b8ce 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -980,7 +980,7 @@ static int __clone_blkaddrs(struct inode *src_inode, struct inode *dst_inode,
 				}
 				dn.ofs_in_node++;
 				i++;
-				new_size = (dst + i) << PAGE_SHIFT;
+				new_size = (loff_t)(dst + i) << PAGE_SHIFT;
 				if (dst_inode->i_size < new_size)
 					f2fs_i_size_write(dst_inode, new_size);
 			} while (--ilen && (do_replace[i] || blkaddr[i] == NULL_ADDR));
-- 
2.20.1

