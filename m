Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB8158BEDC
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:33:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242194AbiHHBdV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:33:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242126AbiHHBcp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:32:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2F0ECE08;
        Sun,  7 Aug 2022 18:32:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D060B80DC0;
        Mon,  8 Aug 2022 01:32:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ED1EC433C1;
        Mon,  8 Aug 2022 01:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922342;
        bh=Ll3VrOpxsVmeadqheby9L6HRHAFePhaWMYtkUoqpQtY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T/+xKW8foK/5W1nr9jPRLOlhEHRHv1Z/jZabrfga+FDoDdkIa3BH+Wy5L2SDjpMoy
         8Ay5cAYZ1eCK6LR0bpYh922qnJXQWhd7PF586SJZC7lwzkMituCvn9uOgzOT/3gNnB
         ACPRBlRBY+5Dy6ibFF/TmcpF+OJPjwODnYPw1llRTM/Gdc/Z3kDyo0RH9ZiPWiVDyJ
         Je8Uj81+X5NO7ZQOCmdJ43HxK71nfmBisq7/tuLL+37nMsNtWKpjlYiTDVYOG9NQLX
         J8/JQsRqOG6zQshzAVceqqXmstBqlRf0EPD19gzKP/uXHpIdctAZ5/PeXs6HbrwGQj
         CcWiMCIjREnuQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jan Kara <jack@suse.cz>,
        syzbot+d273f7d7f58afd93be48@syzkaller.appspotmail.com,
        Sasha Levin <sashal@kernel.org>, jack@suse.com,
        linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 15/58] ext2: Add more validity checks for inode counts
Date:   Sun,  7 Aug 2022 21:30:33 -0400
Message-Id: <20220808013118.313965-15-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013118.313965-1-sashal@kernel.org>
References: <20220808013118.313965-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Jan Kara <jack@suse.cz>

[ Upstream commit fa78f336937240d1bc598db817d638086060e7e9 ]

Add checks verifying number of inodes stored in the superblock matches
the number computed from number of inodes per group. Also verify we have
at least one block worth of inodes per group. This prevents crashes on
corrupted filesystems.

Reported-by: syzbot+d273f7d7f58afd93be48@syzkaller.appspotmail.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext2/super.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index f6a19f6d9f6d..cdffa2a041af 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -1059,9 +1059,10 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 			sbi->s_frags_per_group);
 		goto failed_mount;
 	}
-	if (sbi->s_inodes_per_group > sb->s_blocksize * 8) {
+	if (sbi->s_inodes_per_group < sbi->s_inodes_per_block ||
+	    sbi->s_inodes_per_group > sb->s_blocksize * 8) {
 		ext2_msg(sb, KERN_ERR,
-			"error: #inodes per group too big: %lu",
+			"error: invalid #inodes per group: %lu",
 			sbi->s_inodes_per_group);
 		goto failed_mount;
 	}
@@ -1071,6 +1072,13 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 	sbi->s_groups_count = ((le32_to_cpu(es->s_blocks_count) -
 				le32_to_cpu(es->s_first_data_block) - 1)
 					/ EXT2_BLOCKS_PER_GROUP(sb)) + 1;
+	if ((u64)sbi->s_groups_count * sbi->s_inodes_per_group !=
+	    le32_to_cpu(es->s_inodes_count)) {
+		ext2_msg(sb, KERN_ERR, "error: invalid #inodes: %u vs computed %llu",
+			 le32_to_cpu(es->s_inodes_count),
+			 (u64)sbi->s_groups_count * sbi->s_inodes_per_group);
+		goto failed_mount;
+	}
 	db_count = (sbi->s_groups_count + EXT2_DESC_PER_BLOCK(sb) - 1) /
 		   EXT2_DESC_PER_BLOCK(sb);
 	sbi->s_group_desc = kmalloc_array(db_count,
-- 
2.35.1

