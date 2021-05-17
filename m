Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44EC43835B3
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242527AbhEQPYE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:24:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:56030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244429AbhEQPUl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:20:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D8F4613EA;
        Mon, 17 May 2021 14:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262056;
        bh=VJjqpe0kZ1NNitQ/KSUTDwGZS4KAXmPIWNGEs4Y+SKA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VXvLOim2efDxW8oYGPEkXlutOkDIbGYkZq4jutRU1DiChdCIaxEU778s5AQXUTC0L
         Cfzp+cqtFAYjresrUhXSq5FCEo7mGmlqV0dXmjWBVs8irefVvvf1x1tZ5ibejAtFoS
         PaKGAtwDzjeS7NvkA8g/4Pg+ERt48mKdWSd5AnOc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 105/289] f2fs: fix to align to section for fallocate() on pinned file
Date:   Mon, 17 May 2021 16:00:30 +0200
Message-Id: <20210517140308.714460394@linuxfoundation.org>
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

[ Upstream commit e1175f02291141bbd924fc578299305fcde35855 ]

Now, fallocate() on a pinned file only allocates blocks which aligns
to segment rather than section, so GC may try to migrate pinned file's
block, and after several times of failure, pinned file's block could
be migrated to other place, however user won't be aware of such
condition, and then old obsolete block address may be readed/written
incorrectly.

To avoid such condition, let's try to allocate pinned file's blocks
with section alignment.

Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/f2fs.h    |  2 +-
 fs/f2fs/file.c    | 19 +++++++++----------
 fs/f2fs/segment.c | 34 ++++++++++++++++++++++++++--------
 3 files changed, 36 insertions(+), 19 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index f116150e45e3..c2973a1dead6 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -3289,7 +3289,7 @@ void f2fs_get_new_segment(struct f2fs_sb_info *sbi,
 			unsigned int *newseg, bool new_sec, int dir);
 void f2fs_allocate_segment_for_resize(struct f2fs_sb_info *sbi, int type,
 					unsigned int start, unsigned int end);
-void f2fs_allocate_new_segment(struct f2fs_sb_info *sbi, int type);
+void f2fs_allocate_new_section(struct f2fs_sb_info *sbi, int type);
 void f2fs_allocate_new_segments(struct f2fs_sb_info *sbi);
 int f2fs_trim_fs(struct f2fs_sb_info *sbi, struct fstrim_range *range);
 bool f2fs_exist_trim_candidates(struct f2fs_sb_info *sbi,
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index df963686c4dc..e926770f89c5 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1643,27 +1643,26 @@ static int expand_inode_data(struct inode *inode, loff_t offset,
 		return 0;
 
 	if (f2fs_is_pinned_file(inode)) {
-		block_t len = (map.m_len >> sbi->log_blocks_per_seg) <<
-					sbi->log_blocks_per_seg;
+		block_t sec_blks = BLKS_PER_SEC(sbi);
+		block_t sec_len = roundup(map.m_len, sec_blks);
 		block_t done = 0;
 
-		if (map.m_len % sbi->blocks_per_seg)
-			len += sbi->blocks_per_seg;
-
-		map.m_len = sbi->blocks_per_seg;
+		map.m_len = sec_blks;
 next_alloc:
 		if (has_not_enough_free_secs(sbi, 0,
 			GET_SEC_FROM_SEG(sbi, overprovision_segments(sbi)))) {
 			down_write(&sbi->gc_lock);
 			err = f2fs_gc(sbi, true, false, false, NULL_SEGNO);
-			if (err && err != -ENODATA && err != -EAGAIN)
+			if (err && err != -ENODATA && err != -EAGAIN) {
+				map.m_len = done;
 				goto out_err;
+			}
 		}
 
 		down_write(&sbi->pin_sem);
 
 		f2fs_lock_op(sbi);
-		f2fs_allocate_new_segment(sbi, CURSEG_COLD_DATA_PINNED);
+		f2fs_allocate_new_section(sbi, CURSEG_COLD_DATA_PINNED);
 		f2fs_unlock_op(sbi);
 
 		map.m_seg_type = CURSEG_COLD_DATA_PINNED;
@@ -1672,9 +1671,9 @@ next_alloc:
 		up_write(&sbi->pin_sem);
 
 		done += map.m_len;
-		len -= map.m_len;
+		sec_len -= map.m_len;
 		map.m_lblk += map.m_len;
-		if (!err && len)
+		if (!err && sec_len)
 			goto next_alloc;
 
 		map.m_len = done;
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index f9e7280c39d9..d696d4713333 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -2903,7 +2903,8 @@ unlock:
 	up_read(&SM_I(sbi)->curseg_lock);
 }
 
-static void __allocate_new_segment(struct f2fs_sb_info *sbi, int type)
+static void __allocate_new_segment(struct f2fs_sb_info *sbi, int type,
+								bool new_sec)
 {
 	struct curseg_info *curseg = CURSEG_I(sbi, type);
 	unsigned int old_segno;
@@ -2911,10 +2912,22 @@ static void __allocate_new_segment(struct f2fs_sb_info *sbi, int type)
 	if (!curseg->inited)
 		goto alloc;
 
-	if (!curseg->next_blkoff &&
-		!get_valid_blocks(sbi, curseg->segno, false) &&
-		!get_ckpt_valid_blocks(sbi, curseg->segno))
-		return;
+	if (curseg->next_blkoff ||
+		get_valid_blocks(sbi, curseg->segno, new_sec))
+		goto alloc;
+
+	if (new_sec) {
+		unsigned int segno = START_SEGNO(curseg->segno);
+		int i;
+
+		for (i = 0; i < sbi->segs_per_sec; i++, segno++) {
+			if (get_ckpt_valid_blocks(sbi, segno))
+				goto alloc;
+		}
+	} else {
+		if (!get_ckpt_valid_blocks(sbi, curseg->segno))
+			return;
+	}
 
 alloc:
 	old_segno = curseg->segno;
@@ -2922,10 +2935,15 @@ alloc:
 	locate_dirty_segment(sbi, old_segno);
 }
 
-void f2fs_allocate_new_segment(struct f2fs_sb_info *sbi, int type)
+static void __allocate_new_section(struct f2fs_sb_info *sbi, int type)
+{
+	__allocate_new_segment(sbi, type, true);
+}
+
+void f2fs_allocate_new_section(struct f2fs_sb_info *sbi, int type)
 {
 	down_write(&SIT_I(sbi)->sentry_lock);
-	__allocate_new_segment(sbi, type);
+	__allocate_new_section(sbi, type);
 	up_write(&SIT_I(sbi)->sentry_lock);
 }
 
@@ -2935,7 +2953,7 @@ void f2fs_allocate_new_segments(struct f2fs_sb_info *sbi)
 
 	down_write(&SIT_I(sbi)->sentry_lock);
 	for (i = CURSEG_HOT_DATA; i <= CURSEG_COLD_DATA; i++)
-		__allocate_new_segment(sbi, i);
+		__allocate_new_segment(sbi, i, false);
 	up_write(&SIT_I(sbi)->sentry_lock);
 }
 
-- 
2.30.2



