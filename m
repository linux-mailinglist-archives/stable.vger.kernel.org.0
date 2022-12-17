Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04B1564FAB3
	for <lists+stable@lfdr.de>; Sat, 17 Dec 2022 16:45:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231476AbiLQPkr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Dec 2022 10:40:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231341AbiLQPjt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Dec 2022 10:39:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0541E140B6;
        Sat, 17 Dec 2022 07:31:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7EBE860C12;
        Sat, 17 Dec 2022 15:30:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DEA3C433F1;
        Sat, 17 Dec 2022 15:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671291057;
        bh=BowzC+1wtg5HcIzYbI1eN1IcmjSsvBhKPRqRe+WFERI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dCA/PyYDkdCtFB4t99iFxecbUKLcWfAiKv1pZMU1AFxRV6TIpoqspuIZ/NiSqyn3N
         oja3rEARqKhGh+Y0bM0wufVJrFkp4UHiyPKT2caESaiidqjfiZuSwGPm6XdHhQqPQa
         VYpocT/PhJVFrzPMxF1907k6SPmXYwrYywA/oi6N0L1BNPksanZPPYwx6xdc4WIQJS
         1N4aAQ51XRu6h2VKi4kjfHmGTQx+bf4LLzRpfrKOPstV7DmcxGlfQTgPTE9iqc0Yyk
         GUlep1tkE80WVS9WFQigj9Qki2p2ZqkwtIEDGY0f/GgAxK4GSYgFlbWLbiE6ZA0hJ2
         QkOyKGa0rUlGg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shigeru Yoshida <syoshida@redhat.com>,
        syzbot+7902cd7684bc35306224@syzkaller.appspotmail.com,
        Jan Kara <jack@suse.cz>, Sasha Levin <sashal@kernel.org>,
        jack@suse.com
Subject: [PATCH AUTOSEL 4.9 2/8] udf: Avoid double brelse() in udf_rename()
Date:   Sat, 17 Dec 2022 10:30:46 -0500
Message-Id: <20221217153053.99513-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221217153053.99513-1-sashal@kernel.org>
References: <20221217153053.99513-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shigeru Yoshida <syoshida@redhat.com>

[ Upstream commit c791730f2554a9ebb8f18df9368dc27d4ebc38c2 ]

syzbot reported a warning like below [1]:

VFS: brelse: Trying to free free buffer
WARNING: CPU: 2 PID: 7301 at fs/buffer.c:1145 __brelse+0x67/0xa0
...
Call Trace:
 <TASK>
 invalidate_bh_lru+0x99/0x150
 smp_call_function_many_cond+0xe2a/0x10c0
 ? generic_remap_file_range_prep+0x50/0x50
 ? __brelse+0xa0/0xa0
 ? __mutex_lock+0x21c/0x12d0
 ? smp_call_on_cpu+0x250/0x250
 ? rcu_read_lock_sched_held+0xb/0x60
 ? lock_release+0x587/0x810
 ? __brelse+0xa0/0xa0
 ? generic_remap_file_range_prep+0x50/0x50
 on_each_cpu_cond_mask+0x3c/0x80
 blkdev_flush_mapping+0x13a/0x2f0
 blkdev_put_whole+0xd3/0xf0
 blkdev_put+0x222/0x760
 deactivate_locked_super+0x96/0x160
 deactivate_super+0xda/0x100
 cleanup_mnt+0x222/0x3d0
 task_work_run+0x149/0x240
 ? task_work_cancel+0x30/0x30
 do_exit+0xb29/0x2a40
 ? reacquire_held_locks+0x4a0/0x4a0
 ? do_raw_spin_lock+0x12a/0x2b0
 ? mm_update_next_owner+0x7c0/0x7c0
 ? rwlock_bug.part.0+0x90/0x90
 ? zap_other_threads+0x234/0x2d0
 do_group_exit+0xd0/0x2a0
 __x64_sys_exit_group+0x3a/0x50
 do_syscall_64+0x34/0xb0
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

The cause of the issue is that brelse() is called on both ofibh.sbh
and ofibh.ebh by udf_find_entry() when it returns NULL.  However,
brelse() is called by udf_rename(), too.  So, b_count on buffer_head
becomes unbalanced.

This patch fixes the issue by not calling brelse() by udf_rename()
when udf_find_entry() returns NULL.

Link: https://syzkaller.appspot.com/bug?id=8297f45698159c6bca8a1f87dc983667c1a1c851 [1]
Reported-by: syzbot+7902cd7684bc35306224@syzkaller.appspotmail.com
Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20221023095741.271430-1-syoshida@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/namei.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index aefa939176e1..0ab842460ed3 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -1112,8 +1112,9 @@ static int udf_rename(struct inode *old_dir, struct dentry *old_dentry,
 		return -EINVAL;
 
 	ofi = udf_find_entry(old_dir, &old_dentry->d_name, &ofibh, &ocfi);
-	if (IS_ERR(ofi)) {
-		retval = PTR_ERR(ofi);
+	if (!ofi || IS_ERR(ofi)) {
+		if (IS_ERR(ofi))
+			retval = PTR_ERR(ofi);
 		goto end_rename;
 	}
 
@@ -1122,8 +1123,7 @@ static int udf_rename(struct inode *old_dir, struct dentry *old_dentry,
 
 	brelse(ofibh.sbh);
 	tloc = lelb_to_cpu(ocfi.icb.extLocation);
-	if (!ofi || udf_get_lb_pblock(old_dir->i_sb, &tloc, 0)
-	    != old_inode->i_ino)
+	if (udf_get_lb_pblock(old_dir->i_sb, &tloc, 0) != old_inode->i_ino)
 		goto end_rename;
 
 	nfi = udf_find_entry(new_dir, &new_dentry->d_name, &nfibh, &ncfi);
-- 
2.35.1

