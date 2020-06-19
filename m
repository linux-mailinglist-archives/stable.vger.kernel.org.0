Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55DE62010D4
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391578AbgFSPeb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:34:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:36614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393903AbgFSPch (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:32:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65A4720734;
        Fri, 19 Jun 2020 15:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580756;
        bh=LRtF0ol0E5xrY/TP7vBKd8wccCxYeetSbp8974+YILI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yogwpQfVZ6/d0t9WCLVnplyXMzeCJyU2oCT2xMVUi+FsmyGW8dvGYYefOVVDcvq1H
         LwsFYw7mhrTTMobjLvlJfoewqm03vNRdmkOR/SwoCeofEn/cjGc0w4q6aAmJCtyJbR
         t039jqbM0fz2t4hJzBWwAFgIE9C4EXRMFnyy6Ekc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.7 371/376] f2fs: fix checkpoint=disable:%u%%
Date:   Fri, 19 Jun 2020 16:34:49 +0200
Message-Id: <20200619141727.854313296@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaegeuk Kim <jaegeuk@kernel.org>

commit 1ae18f71cb522684bac1718f5c188fb5e30eb23d upstream.

When parsing the mount option, we don't have sbi->user_block_count.
Should do it after getting it.

Cc: <stable@vger.kernel.org>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/f2fs/f2fs.h  |    1 +
 fs/f2fs/super.c |   25 +++++++++++++++++++------
 2 files changed, 20 insertions(+), 6 deletions(-)

--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -139,6 +139,7 @@ struct f2fs_mount_info {
 	int fs_mode;			/* fs mode: LFS or ADAPTIVE */
 	int bggc_mode;			/* bggc mode: off, on or sync */
 	bool test_dummy_encryption;	/* test dummy encryption */
+	block_t unusable_cap_perc;	/* percentage for cap */
 	block_t unusable_cap;		/* Amount of space allowed to be
 					 * unusable when disabling checkpoint
 					 */
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -284,6 +284,22 @@ static inline void limit_reserve_root(st
 					   F2FS_OPTION(sbi).s_resgid));
 }
 
+static inline void adjust_unusable_cap_perc(struct f2fs_sb_info *sbi)
+{
+	if (!F2FS_OPTION(sbi).unusable_cap_perc)
+		return;
+
+	if (F2FS_OPTION(sbi).unusable_cap_perc == 100)
+		F2FS_OPTION(sbi).unusable_cap = sbi->user_block_count;
+	else
+		F2FS_OPTION(sbi).unusable_cap = (sbi->user_block_count / 100) *
+					F2FS_OPTION(sbi).unusable_cap_perc;
+
+	f2fs_info(sbi, "Adjust unusable cap for checkpoint=disable = %u / %u%%",
+			F2FS_OPTION(sbi).unusable_cap,
+			F2FS_OPTION(sbi).unusable_cap_perc);
+}
+
 static void init_once(void *foo)
 {
 	struct f2fs_inode_info *fi = (struct f2fs_inode_info *) foo;
@@ -795,12 +811,7 @@ static int parse_options(struct super_bl
 				return -EINVAL;
 			if (arg < 0 || arg > 100)
 				return -EINVAL;
-			if (arg == 100)
-				F2FS_OPTION(sbi).unusable_cap =
-					sbi->user_block_count;
-			else
-				F2FS_OPTION(sbi).unusable_cap =
-					(sbi->user_block_count / 100) *	arg;
+			F2FS_OPTION(sbi).unusable_cap_perc = arg;
 			set_opt(sbi, DISABLE_CHECKPOINT);
 			break;
 		case Opt_checkpoint_disable_cap:
@@ -1845,6 +1856,7 @@ skip:
 		(test_opt(sbi, POSIX_ACL) ? SB_POSIXACL : 0);
 
 	limit_reserve_root(sbi);
+	adjust_unusable_cap_perc(sbi);
 	*flags = (*flags & ~SB_LAZYTIME) | (sb->s_flags & SB_LAZYTIME);
 	return 0;
 restore_gc:
@@ -3521,6 +3533,7 @@ try_onemore:
 	sbi->reserved_blocks = 0;
 	sbi->current_reserved_blocks = 0;
 	limit_reserve_root(sbi);
+	adjust_unusable_cap_perc(sbi);
 
 	for (i = 0; i < NR_INODE_TYPE; i++) {
 		INIT_LIST_HEAD(&sbi->inode_list[i]);


