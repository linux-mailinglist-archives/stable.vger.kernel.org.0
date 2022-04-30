Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68D96515D72
	for <lists+stable@lfdr.de>; Sat, 30 Apr 2022 15:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380852AbiD3NXb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Apr 2022 09:23:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378527AbiD3NX1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 30 Apr 2022 09:23:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE5A91003;
        Sat, 30 Apr 2022 06:20:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 397EE60E75;
        Sat, 30 Apr 2022 13:20:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A47AC385AA;
        Sat, 30 Apr 2022 13:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651324804;
        bh=2bW4XRxDo/i043/+6bLD3Znmhyws4zpnzO2sCxB8iVQ=;
        h=From:To:Cc:Subject:Date:From;
        b=SRjSBFTBQ63LLRy4sAt0JbBplYktN00OuAXZi11yBuRoO3+L7cHXJQph96aL+kcCk
         wVSQ+DjHfTSlluniONQj9vMIR/QCdh6fi8rTLjGURKoZoH5l32PxI7lx2mDI9DirGp
         5N40WzcNhEjcvuYfVH/qEHMyf82JThBDFceOH/PcFwEeInHVrSOQZ6ONOO9ZVf9TZk
         X7ptYFgBn875tTyo3bY7D7TW3gViar0EYbSLFOKYRA7M73TJGoOb3M8D9DJu+hKs1X
         bnNo9Iq6QE9lEe/uZ2/LKD85xfdaixcS4SVefxeWcS86HcWqvylNiP+Xq9MWlsI6uY
         RQp8SDwCW9v9g==
From:   Chao Yu <chao@kernel.org>
To:     jaegeuk@kernel.org
Cc:     linux-f2fs-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Chao Yu <chao@kernel.org>,
        stable@vger.kernel.org, Ming Yan <yanming@tju.edu.cn>,
        Chao Yu <chao.yu@oppo.com>
Subject: [PATCH] f2fs: fix to clear dirty inode in f2fs_evict_inode()
Date:   Sat, 30 Apr 2022 21:19:24 +0800
Message-Id: <20220430131924.10218-1-chao@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

As Yanming reported in bugzilla:

https://bugzilla.kernel.org/show_bug.cgi?id=215904

The kernel message is shown below:

kernel BUG at fs/f2fs/inode.c:825!
Call Trace:
 evict+0x282/0x4e0
 __dentry_kill+0x2b2/0x4d0
 shrink_dentry_list+0x17c/0x4f0
 shrink_dcache_parent+0x143/0x1e0
 do_one_tree+0x9/0x30
 shrink_dcache_for_umount+0x51/0x120
 generic_shutdown_super+0x5c/0x3a0
 kill_block_super+0x90/0xd0
 kill_f2fs_super+0x225/0x310
 deactivate_locked_super+0x78/0xc0
 cleanup_mnt+0x2b7/0x480
 task_work_run+0xc8/0x150
 exit_to_user_mode_prepare+0x14a/0x150
 syscall_exit_to_user_mode+0x1d/0x40
 do_syscall_64+0x48/0x90

The root cause is: inode node and dnode node share the same nid,
so during f2fs_evict_inode(), dnode node truncation will invalidate
its NAT entry, so when truncating inode node, it fails due to
invalid NAT entry, result in inode is still marked as dirty, fix
this issue by clearing dirty for inode and setting SBI_NEED_FSCK
flag in filesystem.

output from dump.f2fs:
[print_node_info: 354] Node ID [0xf:15] is inode
i_nid[0]                      		[0x       f : 15]

Cc: stable@vger.kernel.org
Reported-by: Ming Yan <yanming@tju.edu.cn>
Signed-off-by: Chao Yu <chao.yu@oppo.com>
---
 fs/f2fs/inode.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index 234b8ed02644..030474b842ce 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -795,8 +795,22 @@ void f2fs_evict_inode(struct inode *inode)
 		f2fs_lock_op(sbi);
 		err = f2fs_remove_inode_page(inode);
 		f2fs_unlock_op(sbi);
-		if (err == -ENOENT)
+		if (err == -ENOENT) {
 			err = 0;
+
+			/*
+			 * in fuzzed image, another node may has the same
+			 * block address as inode's, if it was truncated
+			 * previously, truncation of inode node will fail.
+			 */
+			if (is_inode_flag_set(inode, FI_DIRTY_INODE)) {
+				f2fs_warn(F2FS_I_SB(inode),
+					"f2fs_evict_inode: inconsistent node id, ino:%lu",
+					inode->i_ino);
+				f2fs_inode_synced(inode);
+				set_sbi_flag(sbi, SBI_NEED_FSCK);
+			}
+		}
 	}
 
 	/* give more chances, if ENOMEM case */
-- 
2.25.1

