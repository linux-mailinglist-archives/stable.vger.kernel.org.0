Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A5BD200F2F
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404066AbgFSPQZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:16:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:46862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392456AbgFSPQV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:16:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D06F2080C;
        Fri, 19 Jun 2020 15:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579780;
        bh=EQ7lDuxRpxaj16xgX8ON5CSy/bZW3vAV9Hyv58dsPro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S9rKvG2LAFT4icu1RCRsum9V/T2CMcuw/NXbAkoddf43di9EkUd3VphtcEjiyxK0W
         FddQDOuJOiAb07EMy9aAxkIMyeZi4zCgXI/BW2TslQB6aJ33cXv0G0fhpVWuk4V2bd
         9KlKQfnQze45oyFH4GbJrIDGNab3lBuElCmj4eDk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.4 256/261] f2fs: fix checkpoint=disable:%u%%
Date:   Fri, 19 Jun 2020 16:34:27 +0200
Message-Id: <20200619141702.135038535@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
References: <20200619141649.878808811@linuxfoundation.org>
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
@@ -138,6 +138,7 @@ struct f2fs_mount_info {
 	int alloc_mode;			/* segment allocation policy */
 	int fsync_mode;			/* fsync policy */
 	bool test_dummy_encryption;	/* test dummy encryption */
+	block_t unusable_cap_perc;	/* percentage for cap */
 	block_t unusable_cap;		/* Amount of space allowed to be
 					 * unusable when disabling checkpoint
 					 */
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -277,6 +277,22 @@ static inline void limit_reserve_root(st
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
@@ -790,12 +806,7 @@ static int parse_options(struct super_bl
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
@@ -1735,6 +1746,7 @@ skip:
 		(test_opt(sbi, POSIX_ACL) ? SB_POSIXACL : 0);
 
 	limit_reserve_root(sbi);
+	adjust_unusable_cap_perc(sbi);
 	*flags = (*flags & ~SB_LAZYTIME) | (sb->s_flags & SB_LAZYTIME);
 	return 0;
 restore_gc:
@@ -3397,6 +3409,7 @@ try_onemore:
 	sbi->reserved_blocks = 0;
 	sbi->current_reserved_blocks = 0;
 	limit_reserve_root(sbi);
+	adjust_unusable_cap_perc(sbi);
 
 	for (i = 0; i < NR_INODE_TYPE; i++) {
 		INIT_LIST_HEAD(&sbi->inode_list[i]);


