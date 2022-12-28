Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44741658337
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:45:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235065AbiL1QpA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:45:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234424AbiL1Qog (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:44:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76D761CB35
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:40:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 153F761576
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23B22C433D2;
        Wed, 28 Dec 2022 16:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245620;
        bh=WBSylKWzXsCQ90vpG6DNlzMS6ha4uJBzIU7RLo3BUGg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dtV/+JcNGDoPfWzI29kZjIBw99djjP9gndaLEKp7beNSXpKAsRPEOHjafNzWj5RBW
         iJUxReg3qf703Db7cHj9XkSx5bQghpCdCS5PFZvkAMy7Cr9nRCRxf9faP4FnukFlgw
         CJiP/WbGIOPE+IZ/+1nWnjjWf1TKXjeXi7+c7cpQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+7902cd7684bc35306224@syzkaller.appspotmail.com,
        Shigeru Yoshida <syoshida@redhat.com>, Jan Kara <jack@suse.cz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0893/1073] udf: Avoid double brelse() in udf_rename()
Date:   Wed, 28 Dec 2022 15:41:21 +0100
Message-Id: <20221228144352.285930984@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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
index 865e658535b1..0e30a50060d9 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -1091,8 +1091,9 @@ static int udf_rename(struct user_namespace *mnt_userns, struct inode *old_dir,
 		return -EINVAL;
 
 	ofi = udf_find_entry(old_dir, &old_dentry->d_name, &ofibh, &ocfi);
-	if (IS_ERR(ofi)) {
-		retval = PTR_ERR(ofi);
+	if (!ofi || IS_ERR(ofi)) {
+		if (IS_ERR(ofi))
+			retval = PTR_ERR(ofi);
 		goto end_rename;
 	}
 
@@ -1101,8 +1102,7 @@ static int udf_rename(struct user_namespace *mnt_userns, struct inode *old_dir,
 
 	brelse(ofibh.sbh);
 	tloc = lelb_to_cpu(ocfi.icb.extLocation);
-	if (!ofi || udf_get_lb_pblock(old_dir->i_sb, &tloc, 0)
-	    != old_inode->i_ino)
+	if (udf_get_lb_pblock(old_dir->i_sb, &tloc, 0) != old_inode->i_ino)
 		goto end_rename;
 
 	nfi = udf_find_entry(new_dir, &new_dentry->d_name, &nfibh, &ncfi);
-- 
2.35.1



