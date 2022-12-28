Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83D2365806C
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:17:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234545AbiL1QRt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:17:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234607AbiL1QQ7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:16:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2B9AEB
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:14:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EE66FB816F4
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:14:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53787C433F0;
        Wed, 28 Dec 2022 16:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244085;
        bh=hAnQXHnsB5FABuRd+DVJNnaTy+h1U5fx1aL0xOiYnXg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MCWh8CBE4iGkxBhnb6+olk4xa/+zVX+jASbvOVxwUph5yOeh1qvcfhB+Pe6MHz2wx
         f5VSi8Jf8s5fpTM8KxHsEQgCXz1gLuaYm18s0uG3OFeS3OWqmF0B3LMSZINt1vz7H/
         5K7kFRmrKG5I5cPmIm+O+U1v5zT0peU7q07qPjBU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+40642be9b7e0bb28e0df@syzkaller.appspotmail.com,
        Chao Yu <chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0607/1146] f2fs: fix to avoid accessing uninitialized spinlock
Date:   Wed, 28 Dec 2022 15:35:46 +0100
Message-Id: <20221228144346.659272243@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Chao Yu <chao@kernel.org>

[ Upstream commit cc249e4cba9a6002c9d9e1438daf8440a160bc9e ]

syzbot reports a kernel bug:

 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x1e3/0x2cb lib/dump_stack.c:106
 assign_lock_key+0x22a/0x240 kernel/locking/lockdep.c:981
 register_lock_class+0x287/0x9b0 kernel/locking/lockdep.c:1294
 __lock_acquire+0xe4/0x1f60 kernel/locking/lockdep.c:4934
 lock_acquire+0x1a7/0x400 kernel/locking/lockdep.c:5668
 __raw_spin_lock include/linux/spinlock_api_smp.h:133 [inline]
 _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:154
 spin_lock include/linux/spinlock.h:350 [inline]
 f2fs_save_errors fs/f2fs/super.c:3868 [inline]
 f2fs_handle_error+0x29/0x230 fs/f2fs/super.c:3896
 f2fs_iget+0x215/0x4bb0 fs/f2fs/inode.c:516
 f2fs_fill_super+0x47d3/0x7b50 fs/f2fs/super.c:4222
 mount_bdev+0x26c/0x3a0 fs/super.c:1401
 legacy_get_tree+0xea/0x180 fs/fs_context.c:610
 vfs_get_tree+0x88/0x270 fs/super.c:1531
 do_new_mount+0x289/0xad0 fs/namespace.c:3040
 do_mount fs/namespace.c:3383 [inline]
 __do_sys_mount fs/namespace.c:3591 [inline]
 __se_sys_mount+0x2e3/0x3d0 fs/namespace.c:3568
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

F2FS-fs (loop1): Failed to read F2FS meta data inode

The root cause is if sbi->error_lock may be accessed before
its initialization, fix it.

Link: https://lore.kernel.org/linux-f2fs-devel/0000000000007edb6605ecbb6442@google.com/T/#u
Reported-by: syzbot+40642be9b7e0bb28e0df@syzkaller.appspotmail.com
Fixes: 95fa90c9e5a7 ("f2fs: support recording errors into superblock")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/super.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 696f094c4505..67d51f527606 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -4188,6 +4188,9 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 	if (err)
 		goto free_bio_info;
 
+	spin_lock_init(&sbi->error_lock);
+	memcpy(sbi->errors, raw_super->s_errors, MAX_F2FS_ERRORS);
+
 	init_f2fs_rwsem(&sbi->cp_rwsem);
 	init_f2fs_rwsem(&sbi->quota_sem);
 	init_waitqueue_head(&sbi->cp_wait);
@@ -4255,9 +4258,6 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 		goto free_devices;
 	}
 
-	spin_lock_init(&sbi->error_lock);
-	memcpy(sbi->errors, raw_super->s_errors, MAX_F2FS_ERRORS);
-
 	sbi->total_valid_node_count =
 				le32_to_cpu(sbi->ckpt->valid_node_count);
 	percpu_counter_set(&sbi->total_valid_inode_count,
-- 
2.35.1



