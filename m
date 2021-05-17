Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60A133835B6
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236513AbhEQPYF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:24:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:56032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244434AbhEQPUl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:20:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D4AE6191E;
        Mon, 17 May 2021 14:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262065;
        bh=Pqc1o9/4hTjOoqOmrH0cNAD78daRn3lAI+HwYx066GI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NryiLDJ6NVHnHimYtNu4gZ2htCWwi2Ib1k7jPLDxYegXKNhdhfoY8o8U3JrxS/uto
         SWYmQAG35ERb8oWnFDGgKSjb4xFih5WWQ19UL/fdYoW5c+fk2iSMo1HPMPVcLy/6aH
         5378A0XS7zK9RVqzjmMaILOttohyPch1ZLFbDQLA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 106/289] f2fs: fix to update last i_size if fallocate partially succeeds
Date:   Mon, 17 May 2021 16:00:31 +0200
Message-Id: <20210517140308.745584553@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit 88f2cfc5fa90326edb569b4a81bb38ed4dcd3108 ]

In the case of expanding pinned file, map.m_lblk and map.m_len
will update in each round of section allocation, so in error
path, last i_size will be calculated with wrong m_lblk and m_len,
fix it.

Fixes: f5a53edcf01e ("f2fs: support aligned pinned file")
Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index e926770f89c5..9f857e5709b6 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1616,9 +1616,10 @@ static int expand_inode_data(struct inode *inode, loff_t offset,
 	struct f2fs_map_blocks map = { .m_next_pgofs = NULL,
 			.m_next_extent = NULL, .m_seg_type = NO_CHECK_TYPE,
 			.m_may_create = true };
-	pgoff_t pg_end;
+	pgoff_t pg_start, pg_end;
 	loff_t new_size = i_size_read(inode);
 	loff_t off_end;
+	block_t expanded = 0;
 	int err;
 
 	err = inode_newsize_ok(inode, (len + offset));
@@ -1631,11 +1632,12 @@ static int expand_inode_data(struct inode *inode, loff_t offset,
 
 	f2fs_balance_fs(sbi, true);
 
+	pg_start = ((unsigned long long)offset) >> PAGE_SHIFT;
 	pg_end = ((unsigned long long)offset + len) >> PAGE_SHIFT;
 	off_end = (offset + len) & (PAGE_SIZE - 1);
 
-	map.m_lblk = ((unsigned long long)offset) >> PAGE_SHIFT;
-	map.m_len = pg_end - map.m_lblk;
+	map.m_lblk = pg_start;
+	map.m_len = pg_end - pg_start;
 	if (off_end)
 		map.m_len++;
 
@@ -1645,7 +1647,6 @@ static int expand_inode_data(struct inode *inode, loff_t offset,
 	if (f2fs_is_pinned_file(inode)) {
 		block_t sec_blks = BLKS_PER_SEC(sbi);
 		block_t sec_len = roundup(map.m_len, sec_blks);
-		block_t done = 0;
 
 		map.m_len = sec_blks;
 next_alloc:
@@ -1653,10 +1654,8 @@ next_alloc:
 			GET_SEC_FROM_SEG(sbi, overprovision_segments(sbi)))) {
 			down_write(&sbi->gc_lock);
 			err = f2fs_gc(sbi, true, false, false, NULL_SEGNO);
-			if (err && err != -ENODATA && err != -EAGAIN) {
-				map.m_len = done;
+			if (err && err != -ENODATA && err != -EAGAIN)
 				goto out_err;
-			}
 		}
 
 		down_write(&sbi->pin_sem);
@@ -1670,24 +1669,25 @@ next_alloc:
 
 		up_write(&sbi->pin_sem);
 
-		done += map.m_len;
+		expanded += map.m_len;
 		sec_len -= map.m_len;
 		map.m_lblk += map.m_len;
 		if (!err && sec_len)
 			goto next_alloc;
 
-		map.m_len = done;
+		map.m_len = expanded;
 	} else {
 		err = f2fs_map_blocks(inode, &map, 1, F2FS_GET_BLOCK_PRE_AIO);
+		expanded = map.m_len;
 	}
 out_err:
 	if (err) {
 		pgoff_t last_off;
 
-		if (!map.m_len)
+		if (!expanded)
 			return err;
 
-		last_off = map.m_lblk + map.m_len - 1;
+		last_off = pg_start + expanded - 1;
 
 		/* update new size to the failed position */
 		new_size = (last_off == pg_end) ? offset + len :
-- 
2.30.2



