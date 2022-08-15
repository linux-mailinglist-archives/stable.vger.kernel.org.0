Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA2FF5945B5
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349038AbiHOWaW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350570AbiHOW07 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:26:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ACA55F9E;
        Mon, 15 Aug 2022 12:45:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0367AB80EAB;
        Mon, 15 Aug 2022 19:45:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4920BC433C1;
        Mon, 15 Aug 2022 19:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592720;
        bh=Ll3VrOpxsVmeadqheby9L6HRHAFePhaWMYtkUoqpQtY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Iq9A8kFwBEgJ7ovw9teq8KFFlWW811EeqTyszpJk5WEMf+gtA9WUYq58aX/7+6Y3D
         z/mu/0o6HaY5W1nyW6XjDjGCI3ShoIoFjWd53B4NWdvbSQ7sQzoVHS1s5wz9lSqTg8
         gxg5Tk0GIFF/MLQOMyhbi0ElnPfnuftLEWqbvg2w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+d273f7d7f58afd93be48@syzkaller.appspotmail.com,
        Jan Kara <jack@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0155/1157] ext2: Add more validity checks for inode counts
Date:   Mon, 15 Aug 2022 19:51:51 +0200
Message-Id: <20220815180445.881843213@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
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



