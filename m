Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA5144ABC17
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:45:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384853AbiBGLaX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:30:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383881AbiBGLXy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:23:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 147EEC0401C5;
        Mon,  7 Feb 2022 03:23:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6311B8111C;
        Mon,  7 Feb 2022 11:23:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D062C004E1;
        Mon,  7 Feb 2022 11:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233028;
        bh=/tGzveDzfTBR4qxgZ0fj0VvGpTMLFFUP9H5ABeVidT0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hzBb6oTzslXsmzBvC8y06E+A8SLrVur7SzMqx7Wee/KLHmX/iKXi0ghHy5Eo9KPgh
         +Aca4TwAqf/j8yHIPD3D+KPkX13SJYoXYv8YNHl5iADJMjL2wVGVX5Maf7DNrzf0Xm
         A44O1hgzZXfMYLBOfa0MqXZ7QD2njRDjNCP3RraU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Yin <yinxin.x@bytedance.com>,
        Harshad Shirwadkar <harshadshirwadkar@gmail.com>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 5.10 68/74] ext4: modify the logic of ext4_mb_new_blocks_simple
Date:   Mon,  7 Feb 2022 12:07:06 +0100
Message-Id: <20220207103759.457691273@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103757.232676988@linuxfoundation.org>
References: <20220207103757.232676988@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Yin <yinxin.x@bytedance.com>

commit 31a074a0c62dc0d2bfb9b543142db4fe27f9e5eb upstream.

For now in ext4_mb_new_blocks_simple, if we found a block which
should be excluded then will switch to next group, this may
probably cause 'group' run out of range.

Change to check next block in the same group when get a block should
be excluded. Also change the search range to EXT4_CLUSTERS_PER_GROUP
and add error checking.

Signed-off-by: Xin Yin <yinxin.x@bytedance.com>
Reviewed-by: Harshad Shirwadkar <harshadshirwadkar@gmail.com>
Link: https://lore.kernel.org/r/20220110035141.1980-3-yinxin.x@bytedance.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/mballoc.c |   26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -5173,7 +5173,8 @@ static ext4_fsblk_t ext4_mb_new_blocks_s
 	struct super_block *sb = ar->inode->i_sb;
 	ext4_group_t group;
 	ext4_grpblk_t blkoff;
-	int i = sb->s_blocksize;
+	ext4_grpblk_t max = EXT4_CLUSTERS_PER_GROUP(sb);
+	ext4_grpblk_t i = 0;
 	ext4_fsblk_t goal, block;
 	struct ext4_super_block *es = EXT4_SB(sb)->s_es;
 
@@ -5195,19 +5196,26 @@ static ext4_fsblk_t ext4_mb_new_blocks_s
 		ext4_get_group_no_and_offset(sb,
 			max(ext4_group_first_block_no(sb, group), goal),
 			NULL, &blkoff);
-		i = mb_find_next_zero_bit(bitmap_bh->b_data, sb->s_blocksize,
+		while (1) {
+			i = mb_find_next_zero_bit(bitmap_bh->b_data, max,
 						blkoff);
+			if (i >= max)
+				break;
+			if (ext4_fc_replay_check_excluded(sb,
+				ext4_group_first_block_no(sb, group) + i)) {
+				blkoff = i + 1;
+			} else
+				break;
+		}
 		brelse(bitmap_bh);
-		if (i >= sb->s_blocksize)
-			continue;
-		if (ext4_fc_replay_check_excluded(sb,
-			ext4_group_first_block_no(sb, group) + i))
-			continue;
-		break;
+		if (i < max)
+			break;
 	}
 
-	if (group >= ext4_get_groups_count(sb) && i >= sb->s_blocksize)
+	if (group >= ext4_get_groups_count(sb) || i >= max) {
+		*errp = -ENOSPC;
 		return 0;
+	}
 
 	block = ext4_group_first_block_no(sb, group) + i;
 	ext4_mb_mark_bb(sb, block, 1, 1);


