Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E9D2383393
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239273AbhEQPAN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:00:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:51142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241525AbhEQO6A (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:58:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F9CD619A8;
        Mon, 17 May 2021 14:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261554;
        bh=5seu/4toI80QsUrn2Jl9ip5YB23x62l8RoaabHGFDbM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b41Hx2uidiKvKIQbk/MNgae3FxwuViukkAatUBDBkdO66iMSWiOEEa/V8ghMoQesP
         BYs8mDbFvjbUQsTjF5d2zgnP/qvPW4+3mcsqlt8P1xUwf7TDLf9CEF6K2IvD1NFM09
         bolX590ecUYfJgrDWh2jz6FiX4JiUHBnUKHFVuPI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 128/329] f2fs: fix to avoid touching checkpointed data in get_victim()
Date:   Mon, 17 May 2021 16:00:39 +0200
Message-Id: <20210517140306.442697515@linuxfoundation.org>
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

[ Upstream commit 61461fc921b756ae16e64243f72af2bfc2e620db ]

In CP disabling mode, there are two issues when using LFS or SSR | AT_SSR
mode to select victim:

1. LFS is set to find source section during GC, the victim should have
no checkpointed data, since after GC, section could not be set free for
reuse.

Previously, we only check valid chpt blocks in current segment rather
than section, fix it.

2. SSR | AT_SSR are set to find target segment for writes which can be
fully filled by checkpointed and newly written blocks, we should never
select such segment, otherwise it can cause panic or data corruption
during allocation, potential case is described as below:

 a) target segment has 'n' (n < 512) ckpt valid blocks
 b) GC migrates 'n' valid blocks to other segment (segment is still
    in dirty list)
 c) GC migrates '512 - n' blocks to target segment (segment has 'n'
    cp_vblocks and '512 - n' vblocks)
 d) If GC selects target segment via {AT,}SSR allocator, however there
    is no free space in targe segment.

Fixes: 4354994f097d ("f2fs: checkpoint disabling")
Fixes: 093749e296e2 ("f2fs: support age threshold based garbage collection")
Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/f2fs.h    |  1 +
 fs/f2fs/gc.c      | 28 ++++++++++++++++++++--------
 fs/f2fs/segment.c | 36 +++++++++++++++++++++---------------
 fs/f2fs/segment.h | 14 +++++++++++++-
 4 files changed, 55 insertions(+), 24 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index e72ed7baf17f..c9d54652a518 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -3322,6 +3322,7 @@ block_t f2fs_get_unusable_blocks(struct f2fs_sb_info *sbi);
 int f2fs_disable_cp_again(struct f2fs_sb_info *sbi, block_t unusable);
 void f2fs_release_discard_addrs(struct f2fs_sb_info *sbi);
 int f2fs_npages_for_summary_flush(struct f2fs_sb_info *sbi, bool for_ra);
+bool f2fs_segment_has_free_slot(struct f2fs_sb_info *sbi, int segno);
 void f2fs_init_inmem_curseg(struct f2fs_sb_info *sbi);
 void f2fs_save_inmem_curseg(struct f2fs_sb_info *sbi);
 void f2fs_restore_inmem_curseg(struct f2fs_sb_info *sbi);
diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index b206797d202b..f4e426352aad 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -392,10 +392,6 @@ static void add_victim_entry(struct f2fs_sb_info *sbi,
 		if (p->gc_mode == GC_AT &&
 			get_valid_blocks(sbi, segno, true) == 0)
 			return;
-
-		if (p->alloc_mode == AT_SSR &&
-			get_seg_entry(sbi, segno)->ckpt_valid_blocks == 0)
-			return;
 	}
 
 	for (i = 0; i < sbi->segs_per_sec; i++)
@@ -728,11 +724,27 @@ retry:
 
 		if (sec_usage_check(sbi, secno))
 			goto next;
+
 		/* Don't touch checkpointed data */
-		if (unlikely(is_sbi_flag_set(sbi, SBI_CP_DISABLED) &&
-					get_ckpt_valid_blocks(sbi, segno) &&
-					p.alloc_mode == LFS))
-			goto next;
+		if (unlikely(is_sbi_flag_set(sbi, SBI_CP_DISABLED))) {
+			if (p.alloc_mode == LFS) {
+				/*
+				 * LFS is set to find source section during GC.
+				 * The victim should have no checkpointed data.
+				 */
+				if (get_ckpt_valid_blocks(sbi, segno, true))
+					goto next;
+			} else {
+				/*
+				 * SSR | AT_SSR are set to find target segment
+				 * for writes which can be full by checkpointed
+				 * and newly written blocks.
+				 */
+				if (!f2fs_segment_has_free_slot(sbi, segno))
+					goto next;
+			}
+		}
+
 		if (gc_type == BG_GC && test_bit(secno, dirty_i->victim_secmap))
 			goto next;
 
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 86bbba93c349..ab0a2d2de9a9 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -878,7 +878,7 @@ static void locate_dirty_segment(struct f2fs_sb_info *sbi, unsigned int segno)
 	mutex_lock(&dirty_i->seglist_lock);
 
 	valid_blocks = get_valid_blocks(sbi, segno, false);
-	ckpt_valid_blocks = get_ckpt_valid_blocks(sbi, segno);
+	ckpt_valid_blocks = get_ckpt_valid_blocks(sbi, segno, false);
 
 	if (valid_blocks == 0 && (!is_sbi_flag_set(sbi, SBI_CP_DISABLED) ||
 		ckpt_valid_blocks == usable_blocks)) {
@@ -963,7 +963,7 @@ static unsigned int get_free_segment(struct f2fs_sb_info *sbi)
 	for_each_set_bit(segno, dirty_i->dirty_segmap[DIRTY], MAIN_SEGS(sbi)) {
 		if (get_valid_blocks(sbi, segno, false))
 			continue;
-		if (get_ckpt_valid_blocks(sbi, segno))
+		if (get_ckpt_valid_blocks(sbi, segno, false))
 			continue;
 		mutex_unlock(&dirty_i->seglist_lock);
 		return segno;
@@ -2653,6 +2653,23 @@ static void __refresh_next_blkoff(struct f2fs_sb_info *sbi,
 		seg->next_blkoff++;
 }
 
+bool f2fs_segment_has_free_slot(struct f2fs_sb_info *sbi, int segno)
+{
+	struct seg_entry *se = get_seg_entry(sbi, segno);
+	int entries = SIT_VBLOCK_MAP_SIZE / sizeof(unsigned long);
+	unsigned long *target_map = SIT_I(sbi)->tmp_map;
+	unsigned long *ckpt_map = (unsigned long *)se->ckpt_valid_map;
+	unsigned long *cur_map = (unsigned long *)se->cur_valid_map;
+	int i, pos;
+
+	for (i = 0; i < entries; i++)
+		target_map[i] = ckpt_map[i] | cur_map[i];
+
+	pos = __find_rev_next_zero_bit(target_map, sbi->blocks_per_seg, 0);
+
+	return pos < sbi->blocks_per_seg;
+}
+
 /*
  * This function always allocates a used segment(from dirty seglist) by SSR
  * manner, so it should recover the existing segment information of valid blocks
@@ -2923,19 +2940,8 @@ static void __allocate_new_segment(struct f2fs_sb_info *sbi, int type,
 		get_valid_blocks(sbi, curseg->segno, new_sec))
 		goto alloc;
 
-	if (new_sec) {
-		unsigned int segno = START_SEGNO(curseg->segno);
-		int i;
-
-		for (i = 0; i < sbi->segs_per_sec; i++, segno++) {
-			if (get_ckpt_valid_blocks(sbi, segno))
-				goto alloc;
-		}
-	} else {
-		if (!get_ckpt_valid_blocks(sbi, curseg->segno))
-			return;
-	}
-
+	if (!get_ckpt_valid_blocks(sbi, curseg->segno, new_sec))
+		return;
 alloc:
 	old_segno = curseg->segno;
 	SIT_I(sbi)->s_ops->allocate_segment(sbi, type, true);
diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index 229814b4f4a6..1bf33fc27b8f 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -361,8 +361,20 @@ static inline unsigned int get_valid_blocks(struct f2fs_sb_info *sbi,
 }
 
 static inline unsigned int get_ckpt_valid_blocks(struct f2fs_sb_info *sbi,
-				unsigned int segno)
+				unsigned int segno, bool use_section)
 {
+	if (use_section && __is_large_section(sbi)) {
+		unsigned int start_segno = START_SEGNO(segno);
+		unsigned int blocks = 0;
+		int i;
+
+		for (i = 0; i < sbi->segs_per_sec; i++, start_segno++) {
+			struct seg_entry *se = get_seg_entry(sbi, start_segno);
+
+			blocks += se->ckpt_valid_blocks;
+		}
+		return blocks;
+	}
 	return get_seg_entry(sbi, segno)->ckpt_valid_blocks;
 }
 
-- 
2.30.2



