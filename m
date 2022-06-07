Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57985542529
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 08:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234896AbiFHBap (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 21:30:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231328AbiFHBWu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 21:22:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4AEC1957B6;
        Tue,  7 Jun 2022 12:18:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7BE3961976;
        Tue,  7 Jun 2022 19:18:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89A80C34115;
        Tue,  7 Jun 2022 19:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629493;
        bh=ZarOxv6OC6Lb7v0F8skjQkznp1Vq8KrFhn6FrSySwWs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QGEBgJFUsqbipf/tCn/IpzP3HlBfKEunEBlY3Gz88iEvbTzdHB8xVB83OCC2LaMPp
         zbE+7Z8zu1bz8apvB+tLXsy6q/uhe9VgAvsoPJxmOpINjQggasFk1R66bfY9WhkGCm
         0Qgc4O4ylbZMFPCslNraHVXOYj+MdUbPNUi4Ptb4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Yan <yanming@tju.edu.cn>,
        Chao Yu <chao.yu@oppo.com>, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.18 710/879] f2fs: fix to clear dirty inode in f2fs_evict_inode()
Date:   Tue,  7 Jun 2022 19:03:48 +0200
Message-Id: <20220607165023.462494488@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <chao@kernel.org>

commit f2db71053dc0409fae785096ad19cce4c8a95af7 upstream.

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
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/inode.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -796,8 +796,22 @@ retry:
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


