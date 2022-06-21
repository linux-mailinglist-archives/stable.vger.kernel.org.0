Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F612553C7B
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 23:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354879AbiFUVAx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 17:00:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355647AbiFUU6t (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 16:58:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1A663192F;
        Tue, 21 Jun 2022 13:51:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A9654B81B3E;
        Tue, 21 Jun 2022 20:51:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABE1AC385A9;
        Tue, 21 Jun 2022 20:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655844660;
        bh=4zx+vHGjc1Z54wGAa6hG50S77vC5P2VL7BusekcaqV8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QPRQ/PU8LAqDVSygbmlNP58iDmVCLcXPfKUfQT16tXtdY9xnzsk0XSc9L5hEowmhG
         OiqnZH8AfM7PM1tnUf8yYddKF11+CE+zV2ZHs3/mNkBk64n534Z8Mcb4wyTUvqiOhn
         R5r/OuL8C7+1MszQE41shlXKV/Haf97fT0zzDZ7XNRnj/4Ts14XDTdrFJt2OrwejZI
         A7N6pXCiPy1hIk17SXG7ay6qpvxBHiZ1Lblc+SNlMd5AKS8YuktXoy1N9tgByo3s8W
         rgcHnUkqHlmTum2Rgzf8g4wmyC65Cbi0wNqQCKzJuOb1CHtlz2fDe495OnLYbDCraH
         LQRWi56/MXlwA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhang Yi <yi.zhang@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Jan Kara <jack@suse.cz>,
        Ritesh Harjani <ritesh.list@gmail.com>,
        Theodore Ts'o <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>,
        adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 13/17] ext4: fix warning when submitting superblock in ext4_commit_super()
Date:   Tue, 21 Jun 2022 16:50:36 -0400
Message-Id: <20220621205041.250426-13-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220621205041.250426-1-sashal@kernel.org>
References: <20220621205041.250426-1-sashal@kernel.org>
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

From: Zhang Yi <yi.zhang@huawei.com>

[ Upstream commit 15baa7dcadf1c4f0b4f752dc054191855ff2d78e ]

We have already check the io_error and uptodate flag before submitting
the superblock buffer, and re-set the uptodate flag if it has been
failed to write out. But it was lockless and could be raced by another
ext4_commit_super(), and finally trigger '!uptodate' WARNING when
marking buffer dirty. Fix it by submit buffer directly.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ritesh Harjani <ritesh.list@gmail.com>
Link: https://lore.kernel.org/r/20220520023216.3065073-1-yi.zhang@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/super.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 91b83749ee11..c5082f0ffcb4 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5479,7 +5479,6 @@ static void ext4_update_super(struct super_block *sb)
 static int ext4_commit_super(struct super_block *sb)
 {
 	struct buffer_head *sbh = EXT4_SB(sb)->s_sbh;
-	int error = 0;
 
 	if (!sbh)
 		return -EINVAL;
@@ -5488,6 +5487,13 @@ static int ext4_commit_super(struct super_block *sb)
 
 	ext4_update_super(sb);
 
+	lock_buffer(sbh);
+	/* Buffer got discarded which means block device got invalidated */
+	if (!buffer_mapped(sbh)) {
+		unlock_buffer(sbh);
+		return -EIO;
+	}
+
 	if (buffer_write_io_error(sbh) || !buffer_uptodate(sbh)) {
 		/*
 		 * Oh, dear.  A previous attempt to write the
@@ -5502,17 +5508,21 @@ static int ext4_commit_super(struct super_block *sb)
 		clear_buffer_write_io_error(sbh);
 		set_buffer_uptodate(sbh);
 	}
-	BUFFER_TRACE(sbh, "marking dirty");
-	mark_buffer_dirty(sbh);
-	error = __sync_dirty_buffer(sbh,
-		REQ_SYNC | (test_opt(sb, BARRIER) ? REQ_FUA : 0));
+	get_bh(sbh);
+	/* Clear potential dirty bit if it was journalled update */
+	clear_buffer_dirty(sbh);
+	sbh->b_end_io = end_buffer_write_sync;
+	submit_bh(REQ_OP_WRITE,
+		  REQ_SYNC | (test_opt(sb, BARRIER) ? REQ_FUA : 0), sbh);
+	wait_on_buffer(sbh);
 	if (buffer_write_io_error(sbh)) {
 		ext4_msg(sb, KERN_ERR, "I/O error while writing "
 		       "superblock");
 		clear_buffer_write_io_error(sbh);
 		set_buffer_uptodate(sbh);
+		return -EIO;
 	}
-	return error;
+	return 0;
 }
 
 /*
-- 
2.35.1

