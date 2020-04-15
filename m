Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 190191AA1F3
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 14:58:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S370234AbgDOMsN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 08:48:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:34884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408963AbgDOLnJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 07:43:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9916F20936;
        Wed, 15 Apr 2020 11:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586950989;
        bh=hTRxnYZ1co6Pn1/bWbg7KuCbkL9xS1F43IkbvJiqbr8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o0lA0kIPPz7CW97jnwF097bOd5rsyywi/F4nCqOnEKr9eYQqLpwC9Qw0XjJGSzEHs
         kcPrtZ4/kmG9GSQTd3PduBX/tDj/97Ex0pg2RNu1Kkgprh5XlYmQQQWU4urb4ceJrU
         csICgW4R0jwex1ARmoeWgfkwKR1IoolhMy7BJqH8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.5 036/106] f2fs: fix to update f2fs_super_block fields under sb_lock
Date:   Wed, 15 Apr 2020 07:41:16 -0400
Message-Id: <20200415114226.13103-36-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415114226.13103-1-sashal@kernel.org>
References: <20200415114226.13103-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit a4ba5dfc5c88e49bb03385abfdd28c5a0acfbb54 ]

Fields in struct f2fs_super_block should be updated under coverage
of sb_lock, fix to adjust update_sb_metadata() for that rule.

Fixes: 04f0b2eaa3b3 ("f2fs: ioctl for removing a range from F2FS")
Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/gc.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index b3d3996232901..d6705ded0141a 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -1432,12 +1432,19 @@ static int free_segment_range(struct f2fs_sb_info *sbi, unsigned int start,
 static void update_sb_metadata(struct f2fs_sb_info *sbi, int secs)
 {
 	struct f2fs_super_block *raw_sb = F2FS_RAW_SUPER(sbi);
-	int section_count = le32_to_cpu(raw_sb->section_count);
-	int segment_count = le32_to_cpu(raw_sb->segment_count);
-	int segment_count_main = le32_to_cpu(raw_sb->segment_count_main);
-	long long block_count = le64_to_cpu(raw_sb->block_count);
+	int section_count;
+	int segment_count;
+	int segment_count_main;
+	long long block_count;
 	int segs = secs * sbi->segs_per_sec;
 
+	down_write(&sbi->sb_lock);
+
+	section_count = le32_to_cpu(raw_sb->section_count);
+	segment_count = le32_to_cpu(raw_sb->segment_count);
+	segment_count_main = le32_to_cpu(raw_sb->segment_count_main);
+	block_count = le64_to_cpu(raw_sb->block_count);
+
 	raw_sb->section_count = cpu_to_le32(section_count + secs);
 	raw_sb->segment_count = cpu_to_le32(segment_count + segs);
 	raw_sb->segment_count_main = cpu_to_le32(segment_count_main + segs);
@@ -1451,6 +1458,8 @@ static void update_sb_metadata(struct f2fs_sb_info *sbi, int secs)
 		raw_sb->devs[last_dev].total_segments =
 						cpu_to_le32(dev_segs + segs);
 	}
+
+	up_write(&sbi->sb_lock);
 }
 
 static void update_fs_metadata(struct f2fs_sb_info *sbi, int secs)
-- 
2.20.1

