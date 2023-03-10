Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8D76B41EC
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 14:57:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231364AbjCJN55 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 08:57:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231383AbjCJN5x (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 08:57:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04B1A10FBB6
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 05:57:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E370B822BF
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 13:57:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3918C433EF;
        Fri, 10 Mar 2023 13:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678456661;
        bh=rv/+sNTyjAtIKfSftO6PLtF/hk99jZf4GcTu2Mc3q44=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TUYUslT5TUoHXJbiyXIgaZXYjTrk9BOZah9XPJrMwofcq3fKJa+jNasT+4Qt6AI8G
         msJ8v9D0ha9Wx+i/ShfhiuBT68YXZzGdxbhsrH2vtLPMelNS3bkjoidLWS6wecM50I
         EMLX4jOVzoNmjArUY1tMG2s6PmXhzq2d+P+yHdHo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yangtao Li <frank.li@vivo.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 049/211] f2fs: introduce IS_F2FS_IPU_* macro
Date:   Fri, 10 Mar 2023 14:37:09 +0100
Message-Id: <20230310133720.226359618@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yangtao Li <frank.li@vivo.com>

[ Upstream commit fdb7ccc3f9cb316c399b072c7a75a106678eb421 ]

IS_F2FS_IPU_* macro can be used to identify whether
f2fs ipu related policies are enabled.

BTW, convert to use BIT() instead of open code.

Signed-off-by: Yangtao Li <frank.li@vivo.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: c5bf83483382 ("f2fs: fix to set ipu policy")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/data.c    | 25 ++++++++++---------------
 fs/f2fs/segment.c |  4 ++--
 fs/f2fs/segment.h | 15 +++++++++++++++
 fs/f2fs/super.c   |  4 ++--
 4 files changed, 29 insertions(+), 19 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 5263d97bef1dd..a28d05895f5c7 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -2535,34 +2535,29 @@ static inline bool check_inplace_update_policy(struct inode *inode,
 				struct f2fs_io_info *fio)
 {
 	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
-	unsigned int policy = SM_I(sbi)->ipu_policy;
 
-	if (policy & (0x1 << F2FS_IPU_HONOR_OPU_WRITE) &&
-			is_inode_flag_set(inode, FI_OPU_WRITE))
+	if (IS_F2FS_IPU_HONOR_OPU_WRITE(sbi) &&
+	    is_inode_flag_set(inode, FI_OPU_WRITE))
 		return false;
-	if (policy & (0x1 << F2FS_IPU_FORCE))
+	if (IS_F2FS_IPU_FORCE(sbi))
 		return true;
-	if (policy & (0x1 << F2FS_IPU_SSR) && f2fs_need_SSR(sbi))
+	if (IS_F2FS_IPU_SSR(sbi) && f2fs_need_SSR(sbi))
 		return true;
-	if (policy & (0x1 << F2FS_IPU_UTIL) &&
-			utilization(sbi) > SM_I(sbi)->min_ipu_util)
+	if (IS_F2FS_IPU_UTIL(sbi) && utilization(sbi) > SM_I(sbi)->min_ipu_util)
 		return true;
-	if (policy & (0x1 << F2FS_IPU_SSR_UTIL) && f2fs_need_SSR(sbi) &&
-			utilization(sbi) > SM_I(sbi)->min_ipu_util)
+	if (IS_F2FS_IPU_SSR_UTIL(sbi) && f2fs_need_SSR(sbi) &&
+	    utilization(sbi) > SM_I(sbi)->min_ipu_util)
 		return true;
 
 	/*
 	 * IPU for rewrite async pages
 	 */
-	if (policy & (0x1 << F2FS_IPU_ASYNC) &&
-			fio && fio->op == REQ_OP_WRITE &&
-			!(fio->op_flags & REQ_SYNC) &&
-			!IS_ENCRYPTED(inode))
+	if (IS_F2FS_IPU_ASYNC(sbi) && fio && fio->op == REQ_OP_WRITE &&
+	    !(fio->op_flags & REQ_SYNC) && !IS_ENCRYPTED(inode))
 		return true;
 
 	/* this is only set during fdatasync */
-	if (policy & (0x1 << F2FS_IPU_FSYNC) &&
-			is_inode_flag_set(inode, FI_NEED_IPU))
+	if (IS_F2FS_IPU_FSYNC(sbi) && is_inode_flag_set(inode, FI_NEED_IPU))
 		return true;
 
 	if (unlikely(fio && is_sbi_flag_set(sbi, SBI_CP_DISABLED) &&
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index cf430f34d1968..06cae55265841 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -3498,7 +3498,7 @@ int f2fs_inplace_write_data(struct f2fs_io_info *fio)
 
 	stat_inc_inplace_blocks(fio->sbi);
 
-	if (fio->bio && !(SM_I(sbi)->ipu_policy & (1 << F2FS_IPU_NOCACHE)))
+	if (fio->bio && !IS_F2FS_IPU_NOCACHE(sbi))
 		err = f2fs_merge_page_bio(fio);
 	else
 		err = f2fs_submit_page_bio(fio);
@@ -5137,7 +5137,7 @@ int f2fs_build_segment_manager(struct f2fs_sb_info *sbi)
 		sm_info->rec_prefree_segments = DEF_MAX_RECLAIM_PREFREE_SEGMENTS;
 
 	if (!f2fs_lfs_mode(sbi))
-		sm_info->ipu_policy = 1 << F2FS_IPU_FSYNC;
+		sm_info->ipu_policy = BIT(F2FS_IPU_FSYNC);
 	sm_info->min_ipu_util = DEF_MIN_IPU_UTIL;
 	sm_info->min_fsync_blocks = DEF_MIN_FSYNC_BLOCKS;
 	sm_info->min_seq_blocks = sbi->blocks_per_seg;
diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index 3ad1b7b6fa946..e77518c49f388 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -681,6 +681,21 @@ enum {
 	F2FS_IPU_HONOR_OPU_WRITE,
 };
 
+#define F2FS_IPU_POLICY(name)					\
+static inline int IS_##name(struct f2fs_sb_info *sbi)		\
+{								\
+	return SM_I(sbi)->ipu_policy & BIT(name);		\
+}
+
+F2FS_IPU_POLICY(F2FS_IPU_FORCE);
+F2FS_IPU_POLICY(F2FS_IPU_SSR);
+F2FS_IPU_POLICY(F2FS_IPU_UTIL);
+F2FS_IPU_POLICY(F2FS_IPU_SSR_UTIL);
+F2FS_IPU_POLICY(F2FS_IPU_FSYNC);
+F2FS_IPU_POLICY(F2FS_IPU_ASYNC);
+F2FS_IPU_POLICY(F2FS_IPU_NOCACHE);
+F2FS_IPU_POLICY(F2FS_IPU_HONOR_OPU_WRITE);
+
 static inline unsigned int curseg_segno(struct f2fs_sb_info *sbi,
 		int type)
 {
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 1f812b9ce985b..87d56a9883e65 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -4089,8 +4089,8 @@ static void f2fs_tuning_parameters(struct f2fs_sb_info *sbi)
 		if (f2fs_block_unit_discard(sbi))
 			SM_I(sbi)->dcc_info->discard_granularity =
 						MIN_DISCARD_GRANULARITY;
-		SM_I(sbi)->ipu_policy = 1 << F2FS_IPU_FORCE |
-					1 << F2FS_IPU_HONOR_OPU_WRITE;
+		SM_I(sbi)->ipu_policy = BIT(F2FS_IPU_FORCE) |
+					BIT(F2FS_IPU_HONOR_OPU_WRITE);
 	}
 
 	sbi->readdir_ra = true;
-- 
2.39.2



