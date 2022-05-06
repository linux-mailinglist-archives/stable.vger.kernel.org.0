Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91EAD51CE25
	for <lists+stable@lfdr.de>; Fri,  6 May 2022 04:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387922AbiEFBbk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 May 2022 21:31:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352523AbiEFBbj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 May 2022 21:31:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0D3E5AA40;
        Thu,  5 May 2022 18:27:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8CF2C61FDA;
        Fri,  6 May 2022 01:27:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2C60C385A8;
        Fri,  6 May 2022 01:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651800476;
        bh=cAQOYpc/BEuhdKQNkv+uO9klIjSDcos54VSXN3Bdukc=;
        h=From:To:Cc:Subject:Date:From;
        b=rWKsLO0QcrSt83NQ1T1YLZz8Li0i5s2WmCn5oA0rg94MpMAoHyJ9Mh2Hm15iVZQ8G
         CqZp6MkRGMh1soC1erACMyQ/SHoPhFyCuJUiwQZuInVTNhrCH6KY6pXx7Y4cJ5NgaB
         nP8Fh8AfsFGkUrArR8pcLjs+08PlnTVoHfPAS+o3Eo1yUkl6P1haNxcaoq9B2ozKaX
         FQuXPttB6lSZ32Ydp5JDTdwFP+6n13LmOxNs1bOXRVIi2puy05SHdGushwRhpfa9Bc
         FbdxfR8nXPLZCqcIHxc7fbf6YmPxhgZJatNKGf4JXgT2To3mrvwSdoKP8k+KBwII2L
         qa2QZOIceX6Nw==
From:   Chao Yu <chao@kernel.org>
To:     jaegeuk@kernel.org
Cc:     linux-f2fs-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Chao Yu <chao@kernel.org>,
        stable@vger.kernel.org, Ming Yan <yanming@tju.edu.cn>,
        Chao Yu <chao.yu@oppo.com>
Subject: [PATCH v3] f2fs: fix to do sanity check on total_data_blocks
Date:   Fri,  6 May 2022 09:27:51 +0800
Message-Id: <20220506012751.3547772-1-chao@kernel.org>
X-Mailer: git-send-email 2.25.1
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
v3:
- clean up codes.
 fs/f2fs/segment.c | 36 +++++++++++++++++++++++++-----------
 1 file changed, 25 insertions(+), 11 deletions(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 3a3e2cec2ac4..cf466b84500d 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -4461,7 +4461,8 @@ static int build_sit_entries(struct f2fs_sb_info *sbi)
 	unsigned int i, start, end;
 	unsigned int readed, start_blk = 0;
 	int err = 0;
-	block_t total_node_blocks = 0;
+	block_t sit_valid_blocks[2] = {0, 0};
+	int type;
 
 	do {
 		readed = f2fs_ra_meta_pages(sbi, start_blk, BIO_MAX_VECS,
@@ -4486,8 +4487,9 @@ static int build_sit_entries(struct f2fs_sb_info *sbi)
 			if (err)
 				return err;
 			seg_info_from_raw_sit(se, &sit);
-			if (IS_NODESEG(se->type))
-				total_node_blocks += se->valid_blocks;
+
+			type = IS_NODESEG(se->type) ? NODE : DATA;
+			sit_valid_blocks[type] += se->valid_blocks;
 
 			if (f2fs_block_unit_discard(sbi)) {
 				/* build discard map only one time */
@@ -4527,15 +4529,16 @@ static int build_sit_entries(struct f2fs_sb_info *sbi)
 		sit = sit_in_journal(journal, i);
 
 		old_valid_blocks = se->valid_blocks;
-		if (IS_NODESEG(se->type))
-			total_node_blocks -= old_valid_blocks;
+
+		type = IS_NODESEG(se->type) ? NODE : DATA;
+		sit_valid_blocks[type] -= old_valid_blocks;
 
 		err = check_block_count(sbi, start, &sit);
 		if (err)
 			break;
 		seg_info_from_raw_sit(se, &sit);
-		if (IS_NODESEG(se->type))
-			total_node_blocks += se->valid_blocks;
+
+		sit_valid_blocks[type] += se->valid_blocks;
 
 		if (f2fs_block_unit_discard(sbi)) {
 			if (is_set_ckpt_flags(sbi, CP_TRIMMED_FLAG)) {
@@ -4557,13 +4560,24 @@ static int build_sit_entries(struct f2fs_sb_info *sbi)
 	}
 	up_read(&curseg->journal_rwsem);
 
-	if (!err && total_node_blocks != valid_node_count(sbi)) {
+	if (err)
+		return err;
+
+	if (sit_valid_blocks[NODE] != valid_node_count(sbi)) {
 		f2fs_err(sbi, "SIT is corrupted node# %u vs %u",
-			 total_node_blocks, valid_node_count(sbi));
-		err = -EFSCORRUPTED;
+			 sit_valid_blocks[NODE], valid_node_count(sbi));
+		return -EFSCORRUPTED;
 	}
 
-	return err;
+	if (sit_valid_blocks[DATA] + sit_valid_blocks[NODE] >
+				valid_user_blocks(sbi)) {
+		f2fs_err(sbi, "SIT is corrupted data# %u %u vs %u",
+			 sit_valid_blocks[DATA], sit_valid_blocks[NODE],
+			 valid_user_blocks(sbi));
+		return -EFSCORRUPTED;
+	}
+
+	return 0;
 }
 
 static void init_free_segmap(struct f2fs_sb_info *sbi)
-- 
2.25.1

