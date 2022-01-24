Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6A949A9EA
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:29:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1323829AbiAYD3n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:29:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386882AbiAXVGb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:06:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4161CC0612AD;
        Mon, 24 Jan 2022 12:07:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0A872B8123D;
        Mon, 24 Jan 2022 20:07:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6163DC340E5;
        Mon, 24 Jan 2022 20:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054821;
        bh=cHJfuW1rxuxGH3zObCKuUchcjxNQLuugkv/ck4wFPfA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vVXMauRC/XNp4VaCM468CbacGp8NC9tDvkKyQm54Zuq/ZHVxXgHjj4FatwNRKqRnd
         ddCt97JoqOMNG/ml4CZadfN0qxaroAWqPZMtFAbAt6gtbwXwSPvzuQ/czK4fT+l03L
         tBf6qzuoDg6I5v5b2sl13Li3wwTqmW9nZ0yl78jA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Subject: [PATCH 5.10 515/563] f2fs: fix to reserve space for IO align feature
Date:   Mon, 24 Jan 2022 19:44:40 +0100
Message-Id: <20220124184042.260404504@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <chao@kernel.org>

commit 300a842937fbcfb5a189cea9ba15374fdb0b5c6b upstream.

https://bugzilla.kernel.org/show_bug.cgi?id=204137

With below script, we will hit panic during new segment allocation:

DISK=bingo.img
MOUNT_DIR=/mnt/f2fs

dd if=/dev/zero of=$DISK bs=1M count=105
mkfs.f2fe -a 1 -o 19 -t 1 -z 1 -f -q $DISK

mount -t f2fs $DISK $MOUNT_DIR -o "noinline_dentry,flush_merge,noextent_cache,mode=lfs,io_bits=7,fsync_mode=strict"

for (( i = 0; i < 4096; i++ )); do
	name=`head /dev/urandom | tr -dc A-Za-z0-9 | head -c 10`
	mkdir $MOUNT_DIR/$name
done

umount $MOUNT_DIR
rm $DISK

---
 fs/f2fs/f2fs.h    |   11 +++++++++++
 fs/f2fs/segment.h |    3 ++-
 fs/f2fs/super.c   |   44 ++++++++++++++++++++++++++++++++++++++++++++
 fs/f2fs/sysfs.c   |    4 +++-
 4 files changed, 60 insertions(+), 2 deletions(-)

--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -955,6 +955,7 @@ struct f2fs_sm_info {
 	unsigned int segment_count;	/* total # of segments */
 	unsigned int main_segments;	/* # of segments in main area */
 	unsigned int reserved_segments;	/* # of reserved segments */
+	unsigned int additional_reserved_segments;/* reserved segs for IO align feature */
 	unsigned int ovp_segments;	/* # of overprovision segments */
 
 	/* a threshold to reclaim prefree segments */
@@ -1984,6 +1985,11 @@ static inline int inc_valid_block_count(
 
 	if (!__allow_reserved_blocks(sbi, inode, true))
 		avail_user_block_count -= F2FS_OPTION(sbi).root_reserved_blocks;
+
+	if (F2FS_IO_ALIGNED(sbi))
+		avail_user_block_count -= sbi->blocks_per_seg *
+				SM_I(sbi)->additional_reserved_segments;
+
 	if (unlikely(is_sbi_flag_set(sbi, SBI_CP_DISABLED))) {
 		if (avail_user_block_count > sbi->unusable_block_count)
 			avail_user_block_count -= sbi->unusable_block_count;
@@ -2229,6 +2235,11 @@ static inline int inc_valid_node_count(s
 
 	if (!__allow_reserved_blocks(sbi, inode, false))
 		valid_block_count += F2FS_OPTION(sbi).root_reserved_blocks;
+
+	if (F2FS_IO_ALIGNED(sbi))
+		valid_block_count += sbi->blocks_per_seg *
+				SM_I(sbi)->additional_reserved_segments;
+
 	user_block_count = sbi->user_block_count;
 	if (unlikely(is_sbi_flag_set(sbi, SBI_CP_DISABLED)))
 		user_block_count -= sbi->unusable_block_count;
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -539,7 +539,8 @@ static inline unsigned int free_segments
 
 static inline unsigned int reserved_segments(struct f2fs_sb_info *sbi)
 {
-	return SM_I(sbi)->reserved_segments;
+	return SM_I(sbi)->reserved_segments +
+			SM_I(sbi)->additional_reserved_segments;
 }
 
 static inline unsigned int free_sections(struct f2fs_sb_info *sbi)
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -289,6 +289,46 @@ static inline void limit_reserve_root(st
 					   F2FS_OPTION(sbi).s_resgid));
 }
 
+static inline int adjust_reserved_segment(struct f2fs_sb_info *sbi)
+{
+	unsigned int sec_blks = sbi->blocks_per_seg * sbi->segs_per_sec;
+	unsigned int avg_vblocks;
+	unsigned int wanted_reserved_segments;
+	block_t avail_user_block_count;
+
+	if (!F2FS_IO_ALIGNED(sbi))
+		return 0;
+
+	/* average valid block count in section in worst case */
+	avg_vblocks = sec_blks / F2FS_IO_SIZE(sbi);
+
+	/*
+	 * we need enough free space when migrating one section in worst case
+	 */
+	wanted_reserved_segments = (F2FS_IO_SIZE(sbi) / avg_vblocks) *
+						reserved_segments(sbi);
+	wanted_reserved_segments -= reserved_segments(sbi);
+
+	avail_user_block_count = sbi->user_block_count -
+				sbi->current_reserved_blocks -
+				F2FS_OPTION(sbi).root_reserved_blocks;
+
+	if (wanted_reserved_segments * sbi->blocks_per_seg >
+					avail_user_block_count) {
+		f2fs_err(sbi, "IO align feature can't grab additional reserved segment: %u, available segments: %u",
+			wanted_reserved_segments,
+			avail_user_block_count >> sbi->log_blocks_per_seg);
+		return -ENOSPC;
+	}
+
+	SM_I(sbi)->additional_reserved_segments = wanted_reserved_segments;
+
+	f2fs_info(sbi, "IO align feature needs additional reserved segment: %u",
+			 wanted_reserved_segments);
+
+	return 0;
+}
+
 static inline void adjust_unusable_cap_perc(struct f2fs_sb_info *sbi)
 {
 	if (!F2FS_OPTION(sbi).unusable_cap_perc)
@@ -3736,6 +3776,10 @@ try_onemore:
 		goto free_nm;
 	}
 
+	err = adjust_reserved_segment(sbi);
+	if (err)
+		goto free_nm;
+
 	/* For write statistics */
 	if (sb->s_bdev->bd_part)
 		sbi->sectors_written_start =
--- a/fs/f2fs/sysfs.c
+++ b/fs/f2fs/sysfs.c
@@ -330,7 +330,9 @@ out:
 	if (a->struct_type == RESERVED_BLOCKS) {
 		spin_lock(&sbi->stat_lock);
 		if (t > (unsigned long)(sbi->user_block_count -
-				F2FS_OPTION(sbi).root_reserved_blocks)) {
+				F2FS_OPTION(sbi).root_reserved_blocks -
+				sbi->blocks_per_seg *
+				SM_I(sbi)->additional_reserved_segments)) {
 			spin_unlock(&sbi->stat_lock);
 			return -EINVAL;
 		}


