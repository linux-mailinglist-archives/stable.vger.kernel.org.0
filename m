Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6133B59E302
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354285AbiHWKYt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:24:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354899AbiHWKWX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:22:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 106C513F2D;
        Tue, 23 Aug 2022 02:03:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB69CB81C53;
        Tue, 23 Aug 2022 09:03:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F10EC433C1;
        Tue, 23 Aug 2022 09:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245415;
        bh=2VWKfxtQ5ExyRo+X1gZyywgtIu3OQS7nZSsQWwD9TLw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ho3Wk9ndJF+OqHrntSJxRqe3+dbxODMK+Py8dzndkQJQVTKBkTnx7p0ZaB2T+fk7i
         kwk1cwBJxqnBT42SIyNgnmEr/7iRiIwFfGZTCHAol89P3jAACmIuUCPM/uvot3yrY8
         IZxZBZeXE95PBoc01tSF52XfvcvxlMI48rE3941A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+d273f7d7f58afd93be48@syzkaller.appspotmail.com,
        Jan Kara <jack@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 041/287] ext2: Add more validity checks for inode counts
Date:   Tue, 23 Aug 2022 10:23:30 +0200
Message-Id: <20220823080101.649109026@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080100.268827165@linuxfoundation.org>
References: <20220823080100.268827165@linuxfoundation.org>
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
index ad9fd08f66ba..44a1f356aca2 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -1088,9 +1088,10 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
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
@@ -1100,6 +1101,13 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
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
 	sbi->s_group_desc = kmalloc_array (db_count,
-- 
2.35.1



