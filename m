Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 173884F2B69
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234143AbiDEIj1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:39:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234299AbiDEIYn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:24:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BDB212AAF;
        Tue,  5 Apr 2022 01:20:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2DC2CB81BAC;
        Tue,  5 Apr 2022 08:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 800F8C385A0;
        Tue,  5 Apr 2022 08:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146808;
        bh=wt7/eOzFliMfzNXF4yRCBSFOwqdn1Tbu6qHHX3GK3EY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jHPL5IcXKwWs8jKFlqH4J4wG4JTL6G9fAFwXs9yz+OjcDwKFjyMiXxWpy2SJpsqLx
         Sv8Pg2HwdSVtffcQb5X2TUC33fxe6Tu4h29p4K56nTIV0IjgabYHFBU3IV5Xmfx/G9
         S64vnvuzAJgDCgIN/skDTYSt7qB5ZlfUPvsFqFuE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <chao@kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0879/1126] f2fs: dont get FREEZE lock in f2fs_evict_inode in frozen fs
Date:   Tue,  5 Apr 2022 09:27:06 +0200
Message-Id: <20220405070433.332698561@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

From: Jaegeuk Kim <jaegeuk@kernel.org>

[ Upstream commit ba900534f807f0b327c92d5141c85d2313e2d55c ]

Let's purge inode cache in order to avoid the below deadlock.

[freeze test]                         shrinkder
freeze_super
 - pwercpu_down_write(SB_FREEZE_FS)
                                       - super_cache_scan
                                         - down_read(&sb->s_umount)
                                           - prune_icache_sb
                                            - dispose_list
                                             - evict
                                              - f2fs_evict_inode
thaw_super
 - down_write(&sb->s_umount);
                                              - __percpu_down_read(SB_FREEZE_FS)

Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/ABI/testing/sysfs-fs-f2fs | 1 +
 fs/f2fs/debug.c                         | 1 +
 fs/f2fs/f2fs.h                          | 1 +
 fs/f2fs/inode.c                         | 6 ++++--
 fs/f2fs/super.c                         | 4 ++++
 5 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-fs-f2fs b/Documentation/ABI/testing/sysfs-fs-f2fs
index 2416b03ff283..137f16feee08 100644
--- a/Documentation/ABI/testing/sysfs-fs-f2fs
+++ b/Documentation/ABI/testing/sysfs-fs-f2fs
@@ -430,6 +430,7 @@ Description:	Show status of f2fs superblock in real time.
 		0x800  SBI_QUOTA_SKIP_FLUSH  skip flushing quota in current CP
 		0x1000 SBI_QUOTA_NEED_REPAIR quota file may be corrupted
 		0x2000 SBI_IS_RESIZEFS       resizefs is in process
+		0x4000 SBI_IS_FREEZING       freefs is in process
 		====== ===================== =================================
 
 What:		/sys/fs/f2fs/<disk>/ckpt_thread_ioprio
diff --git a/fs/f2fs/debug.c b/fs/f2fs/debug.c
index 8c50518475a9..07ad0d81f0c5 100644
--- a/fs/f2fs/debug.c
+++ b/fs/f2fs/debug.c
@@ -338,6 +338,7 @@ static char *s_flag[] = {
 	[SBI_QUOTA_SKIP_FLUSH]	= " quota_skip_flush",
 	[SBI_QUOTA_NEED_REPAIR]	= " quota_need_repair",
 	[SBI_IS_RESIZEFS]	= " resizefs",
+	[SBI_IS_FREEZING]	= " freezefs",
 };
 
 static int stat_show(struct seq_file *s, void *v)
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 68b44015514f..2514597f5b26 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1267,6 +1267,7 @@ enum {
 	SBI_QUOTA_SKIP_FLUSH,			/* skip flushing quota in current CP */
 	SBI_QUOTA_NEED_REPAIR,			/* quota file may be corrupted */
 	SBI_IS_RESIZEFS,			/* resizefs is in process */
+	SBI_IS_FREEZING,			/* freezefs is in process */
 };
 
 enum {
diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index ab8e0c06c78c..71f232dcf3c2 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -778,7 +778,8 @@ void f2fs_evict_inode(struct inode *inode)
 	f2fs_remove_ino_entry(sbi, inode->i_ino, UPDATE_INO);
 	f2fs_remove_ino_entry(sbi, inode->i_ino, FLUSH_INO);
 
-	sb_start_intwrite(inode->i_sb);
+	if (!is_sbi_flag_set(sbi, SBI_IS_FREEZING))
+		sb_start_intwrite(inode->i_sb);
 	set_inode_flag(inode, FI_NO_ALLOC);
 	i_size_write(inode, 0);
 retry:
@@ -809,7 +810,8 @@ void f2fs_evict_inode(struct inode *inode)
 		if (dquot_initialize_needed(inode))
 			set_sbi_flag(sbi, SBI_QUOTA_NEED_REPAIR);
 	}
-	sb_end_intwrite(inode->i_sb);
+	if (!is_sbi_flag_set(sbi, SBI_IS_FREEZING))
+		sb_end_intwrite(inode->i_sb);
 no_delete:
 	dquot_drop(inode);
 
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index c674826b615f..c4f8510fac93 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1662,11 +1662,15 @@ static int f2fs_freeze(struct super_block *sb)
 	/* ensure no checkpoint required */
 	if (!llist_empty(&F2FS_SB(sb)->cprc_info.issue_list))
 		return -EINVAL;
+
+	/* to avoid deadlock on f2fs_evict_inode->SB_FREEZE_FS */
+	set_sbi_flag(F2FS_SB(sb), SBI_IS_FREEZING);
 	return 0;
 }
 
 static int f2fs_unfreeze(struct super_block *sb)
 {
+	clear_sbi_flag(F2FS_SB(sb), SBI_IS_FREEZING);
 	return 0;
 }
 
-- 
2.34.1



