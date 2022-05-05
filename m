Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A166651C294
	for <lists+stable@lfdr.de>; Thu,  5 May 2022 16:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344831AbiEEOdc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 May 2022 10:33:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbiEEOdb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 May 2022 10:33:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 744A524BE0;
        Thu,  5 May 2022 07:29:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 22306B82DA4;
        Thu,  5 May 2022 14:29:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21FC8C385A8;
        Thu,  5 May 2022 14:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651760988;
        bh=N3cfcZ5R177Vy3ShBjYhQisk3rhZYNwWw0AXe+7cFhw=;
        h=From:To:Cc:Subject:Date:From;
        b=WVYXrUIFs641fCAlWtqH+Q3leAL9deBOOIh/RfcMd7tKmEr8vmjp+3qnxy++3zriP
         oYpYWFiC4G/G5rPnqhkQja9Dgu6xxpeOfAMKxUKvXmBj7yM12b6H6e8s+wVERHmoHT
         U7u8xPfTWb2axgiIk12fGizSgmPtpET6qPTlix1Q9rsTUlUYzrUYjdLBCH6LY3LHY6
         S1fxVwLP/WWVnX0xuKq68GzxBpqezqd4k/a/ZvyNRbZ2VWPJoQ9C00daaKgYFQfpKU
         BsxTfdrXtg5H0sgZwrA7YmgygM6RobbuR/jP6dcjSDhV/73umbK/ameX6YmU6X9n86
         kXgAg2PTBq2RA==
From:   Chao Yu <chao@kernel.org>
To:     jaegeuk@kernel.org
Cc:     linux-f2fs-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Chao Yu <chao@kernel.org>,
        stable@vger.kernel.org, Ming Yan <yanming@tju.edu.cn>,
        Chao Yu <chao.yu@oppo.com>
Subject: [PATCH v2] f2fs: fix to do sanity check on total_data_blocks
Date:   Thu,  5 May 2022 22:15:07 +0800
Message-Id: <20220505141507.6616-1-chao@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

As Yanming reported in bugzilla:

https://bugzilla.kernel.org/show_bug.cgi?id=215916

The kernel message is shown below:

kernel BUG at fs/f2fs/segment.c:2560!
Call Trace:
 allocate_segment_by_default+0x228/0x440
 f2fs_allocate_data_block+0x13d1/0x31f0
 do_write_page+0x18d/0x710
 f2fs_outplace_write_data+0x151/0x250
 f2fs_do_write_data_page+0xef9/0x1980
 move_data_page+0x6af/0xbc0
 do_garbage_collect+0x312f/0x46f0
 f2fs_gc+0x6b0/0x3bc0
 f2fs_balance_fs+0x921/0x2260
 f2fs_write_single_data_page+0x16be/0x2370
 f2fs_write_cache_pages+0x428/0xd00
 f2fs_write_data_pages+0x96e/0xd50
 do_writepages+0x168/0x550
 __writeback_single_inode+0x9f/0x870
 writeback_sb_inodes+0x47d/0xb20
 __writeback_inodes_wb+0xb2/0x200
 wb_writeback+0x4bd/0x660
 wb_workfn+0x5f3/0xab0
 process_one_work+0x79f/0x13e0
 worker_thread+0x89/0xf60
 kthread+0x26a/0x300
 ret_from_fork+0x22/0x30
RIP: 0010:new_curseg+0xe8d/0x15f0

The root cause is: ckpt.valid_block_count is inconsistent with SIT table,
stat info indicates filesystem has free blocks, but SIT table indicates
filesystem has no free segment.

So that during garbage colloection, it triggers panic when LFS allocator
fails to find free segment.

This patch tries to fix this issue by checking consistency in between
ckpt.valid_block_count and block accounted from SIT.

Cc: stable@vger.kernel.org
Reported-by: Ming Yan <yanming@tju.edu.cn>
Signed-off-by: Chao Yu <chao.yu@oppo.com>
---
v2:
- adjust check condition according to the case Jaegeuk mentioned.
 fs/f2fs/segment.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 3a3e2cec2ac4..942d6d8c18e6 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -4462,6 +4462,7 @@ static int build_sit_entries(struct f2fs_sb_info *sbi)
 	unsigned int readed, start_blk = 0;
 	int err = 0;
 	block_t total_node_blocks = 0;
+	block_t total_data_blocks = 0;
 
 	do {
 		readed = f2fs_ra_meta_pages(sbi, start_blk, BIO_MAX_VECS,
@@ -4488,6 +4489,8 @@ static int build_sit_entries(struct f2fs_sb_info *sbi)
 			seg_info_from_raw_sit(se, &sit);
 			if (IS_NODESEG(se->type))
 				total_node_blocks += se->valid_blocks;
+			else
+				total_data_blocks += se->valid_blocks;
 
 			if (f2fs_block_unit_discard(sbi)) {
 				/* build discard map only one time */
@@ -4529,6 +4532,8 @@ static int build_sit_entries(struct f2fs_sb_info *sbi)
 		old_valid_blocks = se->valid_blocks;
 		if (IS_NODESEG(se->type))
 			total_node_blocks -= old_valid_blocks;
+		else
+			total_data_blocks -= old_valid_blocks;
 
 		err = check_block_count(sbi, start, &sit);
 		if (err)
@@ -4536,6 +4541,8 @@ static int build_sit_entries(struct f2fs_sb_info *sbi)
 		seg_info_from_raw_sit(se, &sit);
 		if (IS_NODESEG(se->type))
 			total_node_blocks += se->valid_blocks;
+		else
+			total_data_blocks += se->valid_blocks;
 
 		if (f2fs_block_unit_discard(sbi)) {
 			if (is_set_ckpt_flags(sbi, CP_TRIMMED_FLAG)) {
@@ -4557,13 +4564,24 @@ static int build_sit_entries(struct f2fs_sb_info *sbi)
 	}
 	up_read(&curseg->journal_rwsem);
 
-	if (!err && total_node_blocks != valid_node_count(sbi)) {
+	if (err)
+		return err;
+
+	if (total_node_blocks != valid_node_count(sbi)) {
 		f2fs_err(sbi, "SIT is corrupted node# %u vs %u",
 			 total_node_blocks, valid_node_count(sbi));
-		err = -EFSCORRUPTED;
+		return -EFSCORRUPTED;
 	}
 
-	return err;
+	if (total_data_blocks + total_node_blocks >
+				valid_user_blocks(sbi)) {
+		f2fs_err(sbi, "SIT is corrupted data# %u %u vs %u",
+			 total_data_blocks, total_node_blocks,
+			 valid_user_blocks(sbi));
+		return -EFSCORRUPTED;
+	}
+
+	return 0;
 }
 
 static void init_free_segmap(struct f2fs_sb_info *sbi)
-- 
2.32.0

