Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A3B754071B
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347435AbiFGRmT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:42:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347428AbiFGRll (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:41:41 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C35CF12719E;
        Tue,  7 Jun 2022 10:34:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 924B8CE23E6;
        Tue,  7 Jun 2022 17:34:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A170C34119;
        Tue,  7 Jun 2022 17:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623246;
        bh=jX8QTwt73otRSW6zTu2tK0g7rFyV7AUN7a0gWWpywq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zJ+G8Ki8Ch4LossEmZAi0WacOvijw+aCUTMaD7RoEDaxbdegB0YqGVoPTrHNqCzyK
         bzBy4vnDQw8cS/mc64TvY3uM13raDdASUyWezRk8XNI7txscDRDHx7wc4QYrLH3fu9
         UNSvQWbv8xlynrXVAHqLE96kmzqC8lgE0Ja1Zqak=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Yan <yanming@tju.edu.cn>,
        Chao Yu <chao.yu@oppo.com>, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.10 349/452] f2fs: fix to do sanity check on total_data_blocks
Date:   Tue,  7 Jun 2022 19:03:26 +0200
Message-Id: <20220607164918.957727424@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <chao@kernel.org>

commit 6b8beca0edd32075a769bfe4178ca00c0dcd22a9 upstream.

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
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/f2fs.h    |    4 ++--
 fs/f2fs/segment.c |   33 ++++++++++++++++++++++-----------
 fs/f2fs/segment.h |    1 +
 3 files changed, 25 insertions(+), 13 deletions(-)

--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1021,8 +1021,8 @@ enum count_type {
  */
 #define PAGE_TYPE_OF_BIO(type)	((type) > META ? META : (type))
 enum page_type {
-	DATA,
-	NODE,
+	DATA = 0,
+	NODE = 1,	/* should not change this */
 	META,
 	NR_PAGE_TYPE,
 	META_FLUSH,
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -4423,7 +4423,7 @@ static int build_sit_entries(struct f2fs
 	unsigned int i, start, end;
 	unsigned int readed, start_blk = 0;
 	int err = 0;
-	block_t total_node_blocks = 0;
+	block_t sit_valid_blocks[2] = {0, 0};
 
 	do {
 		readed = f2fs_ra_meta_pages(sbi, start_blk, BIO_MAX_PAGES,
@@ -4448,8 +4448,8 @@ static int build_sit_entries(struct f2fs
 			if (err)
 				return err;
 			seg_info_from_raw_sit(se, &sit);
-			if (IS_NODESEG(se->type))
-				total_node_blocks += se->valid_blocks;
+
+			sit_valid_blocks[SE_PAGETYPE(se)] += se->valid_blocks;
 
 			/* build discard map only one time */
 			if (is_set_ckpt_flags(sbi, CP_TRIMMED_FLAG)) {
@@ -4487,15 +4487,15 @@ static int build_sit_entries(struct f2fs
 		sit = sit_in_journal(journal, i);
 
 		old_valid_blocks = se->valid_blocks;
-		if (IS_NODESEG(se->type))
-			total_node_blocks -= old_valid_blocks;
+
+		sit_valid_blocks[SE_PAGETYPE(se)] -= old_valid_blocks;
 
 		err = check_block_count(sbi, start, &sit);
 		if (err)
 			break;
 		seg_info_from_raw_sit(se, &sit);
-		if (IS_NODESEG(se->type))
-			total_node_blocks += se->valid_blocks;
+
+		sit_valid_blocks[SE_PAGETYPE(se)] += se->valid_blocks;
 
 		if (is_set_ckpt_flags(sbi, CP_TRIMMED_FLAG)) {
 			memset(se->discard_map, 0xff, SIT_VBLOCK_MAP_SIZE);
@@ -4515,13 +4515,24 @@ static int build_sit_entries(struct f2fs
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
+	}
+
+	if (sit_valid_blocks[DATA] + sit_valid_blocks[NODE] >
+				valid_user_blocks(sbi)) {
+		f2fs_err(sbi, "SIT is corrupted data# %u %u vs %u",
+			 sit_valid_blocks[DATA], sit_valid_blocks[NODE],
+			 valid_user_blocks(sbi));
+		return -EFSCORRUPTED;
 	}
 
-	return err;
+	return 0;
 }
 
 static void init_free_segmap(struct f2fs_sb_info *sbi)
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -24,6 +24,7 @@
 
 #define IS_DATASEG(t)	((t) <= CURSEG_COLD_DATA)
 #define IS_NODESEG(t)	((t) >= CURSEG_HOT_NODE && (t) <= CURSEG_COLD_NODE)
+#define SE_PAGETYPE(se)	((IS_NODESEG((se)->type) ? NODE : DATA))
 
 static inline void sanity_check_seg_type(struct f2fs_sb_info *sbi,
 						unsigned short seg_type)


