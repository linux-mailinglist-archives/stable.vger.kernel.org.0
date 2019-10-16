Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DBD7D9F8F
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:23:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395370AbfJPVzv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 17:55:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:46880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387517AbfJPVzu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:55:50 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A30F2218DE;
        Wed, 16 Oct 2019 21:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571262949;
        bh=/Qm60I01/MSUA1yqo/Wb5JuM5yJfsbegXMZ5KP1CZ4Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wxXJJYhcRTz26fjqqHHZSrTjQH39dZZnrJ2ImHMk4jaQg43wvIcyrhX70yLwJQEA0
         +Yf6Y5NlL4Bre/COa9zGyl2nFPLP8NR8E2nuP0+B1fZ52GZaKa+u58Un9/twMQ7W1T
         ahCJ9p8+hc6fmTXJYnWBTXZShIKRSI1ng5P5wXBc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Icenowy Zheng <icenowy@aosc.io>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 02/65] f2fs: use EINVAL for superblock with invalid magic
Date:   Wed, 16 Oct 2019 14:50:16 -0700
Message-Id: <20191016214757.197686639@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214756.457746573@linuxfoundation.org>
References: <20191016214756.457746573@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Icenowy Zheng <icenowy@aosc.io>

[ Upstream commit 38fb6d0ea34299d97b031ed64fe994158b6f8eb3 ]

The kernel mount_block_root() function expects -EACESS or -EINVAL for a
unmountable filesystem when trying to mount the root with different
filesystem types.

However, in 5.3-rc1 the behavior when F2FS code cannot find valid block
changed to return -EFSCORRUPTED(-EUCLEAN), and this error code makes
mount_block_root() fail when trying to probe F2FS.

When the magic number of the superblock mismatches, it has a high
probability that it's just not a F2FS. In this case return -EINVAL seems
to be a better result, and this return value can make mount_block_root()
probing work again.

Return -EINVAL when the superblock has magic mismatch, -EFSCORRUPTED in
other cases (the magic matches but the superblock cannot be recognized).

Fixes: 10f966bbf521 ("f2fs: use generic EFSBADCRC/EFSCORRUPTED")
Signed-off-by: Icenowy Zheng <icenowy@aosc.io>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/super.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 344aa861774bd..e70975ca723b7 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1814,11 +1814,11 @@ static int sanity_check_raw_super(struct f2fs_sb_info *sbi,
 	struct super_block *sb = sbi->sb;
 	unsigned int blocksize;
 
-	if (F2FS_SUPER_MAGIC != le32_to_cpu(raw_super->magic)) {
+	if (le32_to_cpu(raw_super->magic) != F2FS_SUPER_MAGIC) {
 		f2fs_msg(sb, KERN_INFO,
 			"Magic Mismatch, valid(0x%x) - read(0x%x)",
 			F2FS_SUPER_MAGIC, le32_to_cpu(raw_super->magic));
-		return 1;
+		return -EINVAL;
 	}
 
 	/* Currently, support only 4KB page cache size */
@@ -1826,7 +1826,7 @@ static int sanity_check_raw_super(struct f2fs_sb_info *sbi,
 		f2fs_msg(sb, KERN_INFO,
 			"Invalid page_cache_size (%lu), supports only 4KB\n",
 			PAGE_SIZE);
-		return 1;
+		return -EFSCORRUPTED;
 	}
 
 	/* Currently, support only 4KB block size */
@@ -1835,7 +1835,7 @@ static int sanity_check_raw_super(struct f2fs_sb_info *sbi,
 		f2fs_msg(sb, KERN_INFO,
 			"Invalid blocksize (%u), supports only 4KB\n",
 			blocksize);
-		return 1;
+		return -EFSCORRUPTED;
 	}
 
 	/* check log blocks per segment */
@@ -1843,7 +1843,7 @@ static int sanity_check_raw_super(struct f2fs_sb_info *sbi,
 		f2fs_msg(sb, KERN_INFO,
 			"Invalid log blocks per segment (%u)\n",
 			le32_to_cpu(raw_super->log_blocks_per_seg));
-		return 1;
+		return -EFSCORRUPTED;
 	}
 
 	/* Currently, support 512/1024/2048/4096 bytes sector size */
@@ -1853,7 +1853,7 @@ static int sanity_check_raw_super(struct f2fs_sb_info *sbi,
 				F2FS_MIN_LOG_SECTOR_SIZE) {
 		f2fs_msg(sb, KERN_INFO, "Invalid log sectorsize (%u)",
 			le32_to_cpu(raw_super->log_sectorsize));
-		return 1;
+		return -EFSCORRUPTED;
 	}
 	if (le32_to_cpu(raw_super->log_sectors_per_block) +
 		le32_to_cpu(raw_super->log_sectorsize) !=
@@ -1862,7 +1862,7 @@ static int sanity_check_raw_super(struct f2fs_sb_info *sbi,
 			"Invalid log sectors per block(%u) log sectorsize(%u)",
 			le32_to_cpu(raw_super->log_sectors_per_block),
 			le32_to_cpu(raw_super->log_sectorsize));
-		return 1;
+		return -EFSCORRUPTED;
 	}
 
 	segment_count = le32_to_cpu(raw_super->segment_count);
@@ -1878,7 +1878,7 @@ static int sanity_check_raw_super(struct f2fs_sb_info *sbi,
 		f2fs_msg(sb, KERN_INFO,
 			"Invalid segment count (%u)",
 			segment_count);
-		return 1;
+		return -EFSCORRUPTED;
 	}
 
 	if (total_sections > segment_count ||
@@ -1887,35 +1887,35 @@ static int sanity_check_raw_super(struct f2fs_sb_info *sbi,
 		f2fs_msg(sb, KERN_INFO,
 			"Invalid segment/section count (%u, %u x %u)",
 			segment_count, total_sections, segs_per_sec);
-		return 1;
+		return -EFSCORRUPTED;
 	}
 
 	if ((segment_count / segs_per_sec) < total_sections) {
 		f2fs_msg(sb, KERN_INFO,
 			"Small segment_count (%u < %u * %u)",
 			segment_count, segs_per_sec, total_sections);
-		return 1;
+		return -EFSCORRUPTED;
 	}
 
 	if (segment_count > (le64_to_cpu(raw_super->block_count) >> 9)) {
 		f2fs_msg(sb, KERN_INFO,
 			"Wrong segment_count / block_count (%u > %llu)",
 			segment_count, le64_to_cpu(raw_super->block_count));
-		return 1;
+		return -EFSCORRUPTED;
 	}
 
 	if (secs_per_zone > total_sections || !secs_per_zone) {
 		f2fs_msg(sb, KERN_INFO,
 			"Wrong secs_per_zone / total_sections (%u, %u)",
 			secs_per_zone, total_sections);
-		return 1;
+		return -EFSCORRUPTED;
 	}
 	if (le32_to_cpu(raw_super->extension_count) > F2FS_MAX_EXTENSION) {
 		f2fs_msg(sb, KERN_INFO,
 			"Corrupted extension count (%u > %u)",
 			le32_to_cpu(raw_super->extension_count),
 			F2FS_MAX_EXTENSION);
-		return 1;
+		return -EFSCORRUPTED;
 	}
 
 	if (le32_to_cpu(raw_super->cp_payload) >
@@ -1924,7 +1924,7 @@ static int sanity_check_raw_super(struct f2fs_sb_info *sbi,
 			"Insane cp_payload (%u > %u)",
 			le32_to_cpu(raw_super->cp_payload),
 			blocks_per_seg - F2FS_CP_PACKS);
-		return 1;
+		return -EFSCORRUPTED;
 	}
 
 	/* check reserved ino info */
@@ -1936,12 +1936,12 @@ static int sanity_check_raw_super(struct f2fs_sb_info *sbi,
 			le32_to_cpu(raw_super->node_ino),
 			le32_to_cpu(raw_super->meta_ino),
 			le32_to_cpu(raw_super->root_ino));
-		return 1;
+		return -EFSCORRUPTED;
 	}
 
 	/* check CP/SIT/NAT/SSA/MAIN_AREA area boundary */
 	if (sanity_check_area_boundary(sbi, bh))
-		return 1;
+		return -EFSCORRUPTED;
 
 	return 0;
 }
@@ -2216,11 +2216,11 @@ static int read_raw_super_block(struct f2fs_sb_info *sbi,
 		}
 
 		/* sanity checking of raw super */
-		if (sanity_check_raw_super(sbi, bh)) {
+		err = sanity_check_raw_super(sbi, bh);
+		if (err) {
 			f2fs_msg(sb, KERN_ERR,
 				"Can't find valid F2FS filesystem in %dth superblock",
 				block + 1);
-			err = -EFSCORRUPTED;
 			brelse(bh);
 			continue;
 		}
-- 
2.20.1



