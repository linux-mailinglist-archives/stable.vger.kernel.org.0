Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF01A4E9FFC
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 21:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343521AbiC1ToS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 15:44:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343606AbiC1ToI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 15:44:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF24C65480;
        Mon, 28 Mar 2022 12:42:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 471CD612B5;
        Mon, 28 Mar 2022 19:42:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03D1BC34111;
        Mon, 28 Mar 2022 19:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648496541;
        bh=Ho/BjnVNGfweAgBtMiS7dBtzUEAbt0AM1Wjb60i/UUs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TDLZa+VaNAtwlieI6dmRL6auO3GEFPwnMIifx5a5nAoXuK6ePpaz8IOEjNCaCkJzo
         ut9gwcvtnJhcyktbpJXLqsS3ZxiDjN/VemASPUPhqqAgKp+w1srQCLaTwkXf6JgsdF
         Zpfr0Fw8/AYw0Sf8ZSTpkTqk4zQcNpnO+w4dpo22YFtB5Cok+OmQA9bDZ1IN/SRPIm
         VVNWWTbu9Gt741ypNOYjWDGbHqbtzxi7tiu1SYNO0blxMlFJtZBnHOPyKDGQ9McsSc
         IfiY66m0ULuqNS135/j7BrNQw71hfztxf7FEPtsouYGHKs94+ve1V8khxSS041IBHt
         iifd51w1AeHxg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
        Sasha Levin <sashal@kernel.org>, yuchao0@huawei.com,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.17 18/21] f2fs: use spin_lock to avoid hang
Date:   Mon, 28 Mar 2022 15:41:53 -0400
Message-Id: <20220328194157.1585642-18-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220328194157.1585642-1-sashal@kernel.org>
References: <20220328194157.1585642-1-sashal@kernel.org>
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

From: Jaegeuk Kim <jaegeuk@kernel.org>

[ Upstream commit 98237fcda4a24e67b0a4498c17d5aa4ad4537bc7 ]

[14696.634553] task:cat             state:D stack:    0 pid:1613738 ppid:1613735 flags:0x00000004
[14696.638285] Call Trace:
[14696.639038]  <TASK>
[14696.640032]  __schedule+0x302/0x930
[14696.640969]  schedule+0x58/0xd0
[14696.641799]  schedule_preempt_disabled+0x18/0x30
[14696.642890]  __mutex_lock.constprop.0+0x2fb/0x4f0
[14696.644035]  ? mod_objcg_state+0x10c/0x310
[14696.645040]  ? obj_cgroup_charge+0xe1/0x170
[14696.646067]  __mutex_lock_slowpath+0x13/0x20
[14696.647126]  mutex_lock+0x34/0x40
[14696.648070]  stat_show+0x25/0x17c0 [f2fs]
[14696.649218]  seq_read_iter+0x120/0x4b0
[14696.650289]  ? aa_file_perm+0x12a/0x500
[14696.651357]  ? lru_cache_add+0x1c/0x20
[14696.652470]  seq_read+0xfd/0x140
[14696.653445]  full_proxy_read+0x5c/0x80
[14696.654535]  vfs_read+0xa0/0x1a0
[14696.655497]  ksys_read+0x67/0xe0
[14696.656502]  __x64_sys_read+0x1a/0x20
[14696.657580]  do_syscall_64+0x3b/0xc0
[14696.658671]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[14696.660068] RIP: 0033:0x7efe39df1cb2
[14696.661133] RSP: 002b:00007ffc8badd948 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
[14696.662958] RAX: ffffffffffffffda RBX: 0000000000020000 RCX: 00007efe39df1cb2
[14696.664757] RDX: 0000000000020000 RSI: 00007efe399df000 RDI: 0000000000000003
[14696.666542] RBP: 00007efe399df000 R08: 00007efe399de010 R09: 00007efe399de010
[14696.668363] R10: 0000000000000022 R11: 0000000000000246 R12: 0000000000000000
[14696.670155] R13: 0000000000000003 R14: 0000000000020000 R15: 0000000000020000
[14696.671965]  </TASK>
[14696.672826] task:umount          state:D stack:    0 pid:1614985 ppid:1614984 flags:0x00004000
[14696.674930] Call Trace:
[14696.675903]  <TASK>
[14696.676780]  __schedule+0x302/0x930
[14696.677927]  schedule+0x58/0xd0
[14696.679019]  schedule_preempt_disabled+0x18/0x30
[14696.680412]  __mutex_lock.constprop.0+0x2fb/0x4f0
[14696.681783]  ? destroy_inode+0x65/0x80
[14696.683006]  __mutex_lock_slowpath+0x13/0x20
[14696.684305]  mutex_lock+0x34/0x40
[14696.685442]  f2fs_destroy_stats+0x1e/0x60 [f2fs]
[14696.686803]  f2fs_put_super+0x158/0x390 [f2fs]
[14696.688238]  generic_shutdown_super+0x7a/0x120
[14696.689621]  kill_block_super+0x27/0x50
[14696.690894]  kill_f2fs_super+0x7f/0x100 [f2fs]
[14696.692311]  deactivate_locked_super+0x35/0xa0
[14696.693698]  deactivate_super+0x40/0x50
[14696.694985]  cleanup_mnt+0x139/0x190
[14696.696209]  __cleanup_mnt+0x12/0x20
[14696.697390]  task_work_run+0x64/0xa0
[14696.698587]  exit_to_user_mode_prepare+0x1b7/0x1c0
[14696.700053]  syscall_exit_to_user_mode+0x27/0x50
[14696.701418]  do_syscall_64+0x48/0xc0
[14696.702630]  entry_SYSCALL_64_after_hwframe+0x44/0xae

Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/debug.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/fs/f2fs/debug.c b/fs/f2fs/debug.c
index 07ad0d81f0c5..b449c7a372a4 100644
--- a/fs/f2fs/debug.c
+++ b/fs/f2fs/debug.c
@@ -21,7 +21,7 @@
 #include "gc.h"
 
 static LIST_HEAD(f2fs_stat_list);
-static DEFINE_MUTEX(f2fs_stat_mutex);
+static DEFINE_RAW_SPINLOCK(f2fs_stat_lock);
 #ifdef CONFIG_DEBUG_FS
 static struct dentry *f2fs_debugfs_root;
 #endif
@@ -345,8 +345,9 @@ static int stat_show(struct seq_file *s, void *v)
 {
 	struct f2fs_stat_info *si;
 	int i = 0, j = 0;
+	unsigned long flags;
 
-	mutex_lock(&f2fs_stat_mutex);
+	raw_spin_lock_irqsave(&f2fs_stat_lock, flags);
 	list_for_each_entry(si, &f2fs_stat_list, stat_list) {
 		update_general_status(si->sbi);
 
@@ -574,7 +575,7 @@ static int stat_show(struct seq_file *s, void *v)
 		seq_printf(s, "  - paged : %llu KB\n",
 				si->page_mem >> 10);
 	}
-	mutex_unlock(&f2fs_stat_mutex);
+	raw_spin_unlock_irqrestore(&f2fs_stat_lock, flags);
 	return 0;
 }
 
@@ -585,6 +586,7 @@ int f2fs_build_stats(struct f2fs_sb_info *sbi)
 {
 	struct f2fs_super_block *raw_super = F2FS_RAW_SUPER(sbi);
 	struct f2fs_stat_info *si;
+	unsigned long flags;
 	int i;
 
 	si = f2fs_kzalloc(sbi, sizeof(struct f2fs_stat_info), GFP_KERNEL);
@@ -620,9 +622,9 @@ int f2fs_build_stats(struct f2fs_sb_info *sbi)
 	atomic_set(&sbi->max_aw_cnt, 0);
 	atomic_set(&sbi->max_vw_cnt, 0);
 
-	mutex_lock(&f2fs_stat_mutex);
+	raw_spin_lock_irqsave(&f2fs_stat_lock, flags);
 	list_add_tail(&si->stat_list, &f2fs_stat_list);
-	mutex_unlock(&f2fs_stat_mutex);
+	raw_spin_unlock_irqrestore(&f2fs_stat_lock, flags);
 
 	return 0;
 }
@@ -630,10 +632,11 @@ int f2fs_build_stats(struct f2fs_sb_info *sbi)
 void f2fs_destroy_stats(struct f2fs_sb_info *sbi)
 {
 	struct f2fs_stat_info *si = F2FS_STAT(sbi);
+	unsigned long flags;
 
-	mutex_lock(&f2fs_stat_mutex);
+	raw_spin_lock_irqsave(&f2fs_stat_lock, flags);
 	list_del(&si->stat_list);
-	mutex_unlock(&f2fs_stat_mutex);
+	raw_spin_unlock_irqrestore(&f2fs_stat_lock, flags);
 
 	kfree(si);
 }
-- 
2.34.1

