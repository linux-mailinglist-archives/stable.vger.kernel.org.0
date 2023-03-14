Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC396B94AE
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 13:48:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232302AbjCNMr6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 08:47:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232036AbjCNMqo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 08:46:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 522EC13538;
        Tue, 14 Mar 2023 05:45:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 97E5861784;
        Tue, 14 Mar 2023 12:44:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19F47C433D2;
        Tue, 14 Mar 2023 12:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678797861;
        bh=6wOjxvU0pf9ThQYGKLb7k1KPzfrr1cdG3+OV1Kq/b5Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kvk4CBw9prjPPDFkPZgGT48Oj4emg5pTjkrPVGlMX3AmoVBqWeMEOyyaznoXy3y0b
         CXDK+NB3KcY9A+Jreif7TDLBIcU9gvJvJLns7M0+wXno5pZxToydr5h2+piRJdjnbU
         LvVx89GCSz2bOIrZhTAU5UGkfj+MP/Ke5JJSoglTs38ARsFzy1yhZaQUJ3abcfzMNX
         ZEjUusaC6hVlUE97GLPcyuIjp0GX7k9R/BCnXNzdOR6XQXu/I9kPDVKYMvLwGjeZi2
         iYH9dNwj93m4tYfkC3Pw0aHKjoxzU0TEEENWgqis1Y7A6S6b7u3EPN79nJ7E61AXhn
         algnmTPdI12jw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Baokun Li <libaokun1@huawei.com>,
        syzbot+77d6fcc37bbb92f26048@syzkaller.appspotmail.com,
        Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>,
        Sasha Levin <sashal@kernel.org>, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 5/7] ext4: fix task hung in ext4_xattr_delete_inode
Date:   Tue, 14 Mar 2023 08:44:10 -0400
Message-Id: <20230314124412.471364-5-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230314124412.471364-1-sashal@kernel.org>
References: <20230314124412.471364-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit 0f7bfd6f8164be32dbbdf36aa1e5d00485c53cd7 ]

Syzbot reported a hung task problem:
==================================================================
INFO: task syz-executor232:5073 blocked for more than 143 seconds.
      Not tainted 6.2.0-rc2-syzkaller-00024-g512dee0c00ad #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-exec232 state:D stack:21024 pid:5073 ppid:5072 flags:0x00004004
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5244 [inline]
 __schedule+0x995/0xe20 kernel/sched/core.c:6555
 schedule+0xcb/0x190 kernel/sched/core.c:6631
 __wait_on_freeing_inode fs/inode.c:2196 [inline]
 find_inode_fast+0x35a/0x4c0 fs/inode.c:950
 iget_locked+0xb1/0x830 fs/inode.c:1273
 __ext4_iget+0x22e/0x3ed0 fs/ext4/inode.c:4861
 ext4_xattr_inode_iget+0x68/0x4e0 fs/ext4/xattr.c:389
 ext4_xattr_inode_dec_ref_all+0x1a7/0xe50 fs/ext4/xattr.c:1148
 ext4_xattr_delete_inode+0xb04/0xcd0 fs/ext4/xattr.c:2880
 ext4_evict_inode+0xd7c/0x10b0 fs/ext4/inode.c:296
 evict+0x2a4/0x620 fs/inode.c:664
 ext4_orphan_cleanup+0xb60/0x1340 fs/ext4/orphan.c:474
 __ext4_fill_super fs/ext4/super.c:5516 [inline]
 ext4_fill_super+0x81cd/0x8700 fs/ext4/super.c:5644
 get_tree_bdev+0x400/0x620 fs/super.c:1282
 vfs_get_tree+0x88/0x270 fs/super.c:1489
 do_new_mount+0x289/0xad0 fs/namespace.c:3145
 do_mount fs/namespace.c:3488 [inline]
 __do_sys_mount fs/namespace.c:3697 [inline]
 __se_sys_mount+0x2d3/0x3c0 fs/namespace.c:3674
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7fa5406fd5ea
RSP: 002b:00007ffc7232f968 EFLAGS: 00000202 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007fa5406fd5ea
RDX: 0000000020000440 RSI: 0000000020000000 RDI: 00007ffc7232f970
RBP: 00007ffc7232f970 R08: 00007ffc7232f9b0 R09: 0000000000000432
R10: 0000000000804a03 R11: 0000000000000202 R12: 0000000000000004
R13: 0000555556a7a2c0 R14: 00007ffc7232f9b0 R15: 0000000000000000
 </TASK>
==================================================================

The problem is that the inode contains an xattr entry with ea_inum of 15
when cleaning up an orphan inode <15>. When evict inode <15>, the reference
counting of the corresponding EA inode is decreased. When EA inode <15> is
found by find_inode_fast() in __ext4_iget(), it is found that the EA inode
holds the I_FREEING flag and waits for the EA inode to complete deletion.
As a result, when inode <15> is being deleted, we wait for inode <15> to
complete the deletion, resulting in an infinite loop and triggering Hung
Task. To solve this problem, we only need to check whether the ino of EA
inode and parent is the same before getting EA inode.

Link: https://syzkaller.appspot.com/bug?extid=77d6fcc37bbb92f26048
Reported-by: syzbot+77d6fcc37bbb92f26048@syzkaller.appspotmail.com
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20230110133436.996350-1-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/xattr.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index cf794afbd52fb..74e1e14d04778 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -384,6 +384,17 @@ static int ext4_xattr_inode_iget(struct inode *parent, unsigned long ea_ino,
 	struct inode *inode;
 	int err;
 
+	/*
+	 * We have to check for this corruption early as otherwise
+	 * iget_locked() could wait indefinitely for the state of our
+	 * parent inode.
+	 */
+	if (parent->i_ino == ea_ino) {
+		ext4_error(parent->i_sb,
+			   "Parent and EA inode have the same ino %lu", ea_ino);
+		return -EFSCORRUPTED;
+	}
+
 	inode = ext4_iget(parent->i_sb, ea_ino, EXT4_IGET_NORMAL);
 	if (IS_ERR(inode)) {
 		err = PTR_ERR(inode);
-- 
2.39.2

