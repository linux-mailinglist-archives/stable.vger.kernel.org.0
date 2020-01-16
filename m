Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0753F13E5E3
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:18:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390901AbgAPROB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:14:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:60368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390897AbgAPROA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:14:00 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BC7D246AF;
        Thu, 16 Jan 2020 17:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194840;
        bh=NnkXc8tGaRoFiHxEw95AwiPZ4oJfjR1x1ZE+tmEwVCg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=viGfBus8Oj3T27qbkr7M90YE4XC3EXWJdV3zsqxg+LRq1dCbcJKcKtiCl+OPi52Ax
         6iEZHc3jVYK2C8IfIL4BqdcmYaf7NsskLYP04/7XXFHOGwKpcKx8hzFSOATlVfuhWf
         HcIx8ZKKOXR923Ww63bijrxT9UQ3JiJm5emisb3Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.19 639/671] f2fs: fix potential overflow
Date:   Thu, 16 Jan 2020 12:04:37 -0500
Message-Id: <20200116170509.12787-376-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit 1f0d5c911b64165c9754139a26c8c2fad352c132 ]

We expect 64-bit calculation result from below statement, however
in 32-bit machine, looped left shift operation on pgoff_t type
variable may cause overflow issue, fix it by forcing type cast.

page->index << PAGE_SHIFT;

Fixes: 26de9b117130 ("f2fs: avoid unnecessary updating inode during fsync")
Fixes: 0a2aa8fbb969 ("f2fs: refactor __exchange_data_block for speed up")
Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/data.c | 2 +-
 fs/f2fs/file.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index a7436ad19458..c81a1f3f0a10 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -1857,7 +1857,7 @@ static int __write_data_page(struct page *page, bool *submitted,
 	loff_t i_size = i_size_read(inode);
 	const pgoff_t end_index = ((unsigned long long) i_size)
 							>> PAGE_SHIFT;
-	loff_t psize = (page->index + 1) << PAGE_SHIFT;
+	loff_t psize = (loff_t)(page->index + 1) << PAGE_SHIFT;
 	unsigned offset = 0;
 	bool need_balance_fs = false;
 	int err = 0;
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 5eef2a8b29ab..59b5c0b032bb 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1101,7 +1101,7 @@ static int __clone_blkaddrs(struct inode *src_inode, struct inode *dst_inode,
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

