Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC7E468D858
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:08:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232279AbjBGNIu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:08:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232276AbjBGNIt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:08:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D14E44482
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:08:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B1AF2613EA
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:08:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A30DFC433A0;
        Tue,  7 Feb 2023 13:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675775298;
        bh=XBg4KXqhiXdT0HgyOEdy7u4fjvrriCevx0gwhZ0Awyg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w+W0iBk+AiYbq+l8XAh/CZwk2aBvQuDJz/fbSeMWzj97ty08z6Dx+7gKjFB+bGdGS
         Yr4jR21OCp1qv/5XQcwPnAWqsQGOQ/TbgNPlX4XF6EuyefcBqkNIyZILpn7SLrpGtM
         dSDaN7buAPSWT1iFSqrFMga9glxdWLHoz//dl17w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot <syzbot+40642be9b7e0bb28e0df@syzkaller.appspotmail.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Chao Yu <chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.1 202/208] f2fs: initialize locks earlier in f2fs_fill_super()
Date:   Tue,  7 Feb 2023 13:57:36 +0100
Message-Id: <20230207125643.651721875@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

commit 92b4cf5b48955a4bdd15fe4e2067db8ebd87f04c upstream.

syzbot is reporting lockdep warning at f2fs_handle_error() [1], for
spin_lock(&sbi->error_lock) is called before spin_lock_init() is called.
For safe locking in error handling, move initialization of locks (and
obvious structures) in f2fs_fill_super() to immediately after memory
allocation.

Link: https://syzkaller.appspot.com/bug?extid=40642be9b7e0bb28e0df [1]
Reported-by: syzbot <syzbot+40642be9b7e0bb28e0df@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Tested-by: syzbot <syzbot+40642be9b7e0bb28e0df@syzkaller.appspotmail.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/super.c |   38 ++++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 18 deletions(-)

--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -4095,6 +4095,24 @@ try_onemore:
 
 	sbi->sb = sb;
 
+	/* initialize locks within allocated memory */
+	init_f2fs_rwsem(&sbi->gc_lock);
+	mutex_init(&sbi->writepages);
+	init_f2fs_rwsem(&sbi->cp_global_sem);
+	init_f2fs_rwsem(&sbi->node_write);
+	init_f2fs_rwsem(&sbi->node_change);
+	spin_lock_init(&sbi->stat_lock);
+	init_f2fs_rwsem(&sbi->cp_rwsem);
+	init_f2fs_rwsem(&sbi->quota_sem);
+	init_waitqueue_head(&sbi->cp_wait);
+	spin_lock_init(&sbi->error_lock);
+
+	for (i = 0; i < NR_INODE_TYPE; i++) {
+		INIT_LIST_HEAD(&sbi->inode_list[i]);
+		spin_lock_init(&sbi->inode_lock[i]);
+	}
+	mutex_init(&sbi->flush_lock);
+
 	/* Load the checksum driver */
 	sbi->s_chksum_driver = crypto_alloc_shash("crc32", 0, 0);
 	if (IS_ERR(sbi->s_chksum_driver)) {
@@ -4118,6 +4136,8 @@ try_onemore:
 	sb->s_fs_info = sbi;
 	sbi->raw_super = raw_super;
 
+	memcpy(sbi->errors, raw_super->s_errors, MAX_F2FS_ERRORS);
+
 	/* precompute checksum seed for metadata */
 	if (f2fs_sb_has_inode_chksum(sbi))
 		sbi->s_chksum_seed = f2fs_chksum(sbi, ~0, raw_super->uuid,
@@ -4174,26 +4194,14 @@ try_onemore:
 
 	/* init f2fs-specific super block info */
 	sbi->valid_super_block = valid_super_block;
-	init_f2fs_rwsem(&sbi->gc_lock);
-	mutex_init(&sbi->writepages);
-	init_f2fs_rwsem(&sbi->cp_global_sem);
-	init_f2fs_rwsem(&sbi->node_write);
-	init_f2fs_rwsem(&sbi->node_change);
 
 	/* disallow all the data/node/meta page writes */
 	set_sbi_flag(sbi, SBI_POR_DOING);
-	spin_lock_init(&sbi->stat_lock);
 
 	err = f2fs_init_write_merge_io(sbi);
 	if (err)
 		goto free_bio_info;
 
-	spin_lock_init(&sbi->error_lock);
-	memcpy(sbi->errors, raw_super->s_errors, MAX_F2FS_ERRORS);
-
-	init_f2fs_rwsem(&sbi->cp_rwsem);
-	init_f2fs_rwsem(&sbi->quota_sem);
-	init_waitqueue_head(&sbi->cp_wait);
 	init_sb_info(sbi);
 
 	err = f2fs_init_iostat(sbi);
@@ -4271,12 +4279,6 @@ try_onemore:
 	limit_reserve_root(sbi);
 	adjust_unusable_cap_perc(sbi);
 
-	for (i = 0; i < NR_INODE_TYPE; i++) {
-		INIT_LIST_HEAD(&sbi->inode_list[i]);
-		spin_lock_init(&sbi->inode_lock[i]);
-	}
-	mutex_init(&sbi->flush_lock);
-
 	f2fs_init_extent_cache_info(sbi);
 
 	f2fs_init_ino_entry_info(sbi);


