Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD66B4AFA78
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 19:37:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239590AbiBISha (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 13:37:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239606AbiBISfx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 13:35:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD0D8C05CB98;
        Wed,  9 Feb 2022 10:35:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5974061B86;
        Wed,  9 Feb 2022 18:35:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D00C2C340E7;
        Wed,  9 Feb 2022 18:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644431751;
        bh=XbJzmONg6PfFSqJz05Fe0uDUaA4SE1XLPthkybjldms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h3s5pc8MkcW7k4yUHk1heSQnPlTxRsitzC1JEYr4nxS5NLGIAc8eyJ/6/EiXh5/+W
         BBXONwoo+v5z8IbQlCH/jLAeXNvQdc79+f7/taRHzAcnBsLOBzsjvdi7cgDnaLVTkD
         5t8zgnaRH8lY+ZRsdTAdluoKwuo0SQSYyl/cYvloi+f2P1rKLlj/kcmyFxLPG0Zj6x
         WrvsXs3ouDxC1U3arGAuBUCA/tgmBUQj0F3Ke3+tPhd6Pz+xvewFlJyfRZuUGB8wu8
         2r1v0CjQkSSf/ZNpNh4z7bnMv+pVtwR0zN4EPUKLqTU/VGXXxX4T1fQNXXSHrXd5a4
         3kHvqnW/n5MuA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Darrick J. Wong" <djwong@kernel.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>,
        Christian Brauner <brauner@kernel.org>,
        Sasha Levin <sashal@kernel.org>, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 22/42] vfs: make sync_filesystem return errors from ->sync_fs
Date:   Wed,  9 Feb 2022 13:32:54 -0500
Message-Id: <20220209183335.46545-22-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220209183335.46545-1-sashal@kernel.org>
References: <20220209183335.46545-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 5679897eb104cec9e99609c3f045a0c20603da4c ]

Strangely, sync_filesystem ignores the return code from the ->sync_fs
call, which means that syscalls like syncfs(2) never see the error.
This doesn't seem right, so fix that.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/sync.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/fs/sync.c b/fs/sync.c
index 3ce8e2137f310..c7690016453e4 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -29,7 +29,7 @@
  */
 int sync_filesystem(struct super_block *sb)
 {
-	int ret;
+	int ret = 0;
 
 	/*
 	 * We need to be protected against the filesystem going from
@@ -52,15 +52,21 @@ int sync_filesystem(struct super_block *sb)
 	 * at a time.
 	 */
 	writeback_inodes_sb(sb, WB_REASON_SYNC);
-	if (sb->s_op->sync_fs)
-		sb->s_op->sync_fs(sb, 0);
+	if (sb->s_op->sync_fs) {
+		ret = sb->s_op->sync_fs(sb, 0);
+		if (ret)
+			return ret;
+	}
 	ret = sync_blockdev_nowait(sb->s_bdev);
-	if (ret < 0)
+	if (ret)
 		return ret;
 
 	sync_inodes_sb(sb);
-	if (sb->s_op->sync_fs)
-		sb->s_op->sync_fs(sb, 1);
+	if (sb->s_op->sync_fs) {
+		ret = sb->s_op->sync_fs(sb, 1);
+		if (ret)
+			return ret;
+	}
 	return sync_blockdev(sb->s_bdev);
 }
 EXPORT_SYMBOL(sync_filesystem);
-- 
2.34.1

