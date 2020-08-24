Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFA7324F951
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728722AbgHXJoU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 05:44:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:37732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729053AbgHXIn0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:43:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 554A12075B;
        Mon, 24 Aug 2020 08:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258604;
        bh=iMzsFT6t7SGlhIOUqQv2/+hi3POeH7jRh46e6QHr64I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AtJKQUDy+xhVGitbiSRMgjQyR0kWwKpqLprygILInpPxpStXGcsLbmK5NkLgUY9CS
         UdIHRrGQNIIG7qxR33gthJYCm7VR2MFlWFmNpXtjVBx8rVMhxKtYFfQVCVvb9L5X5a
         hGlr+g6uGo4k5l2rjnXlmQqeW1kaUFlE5gRvxQjE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+c1eff8205244ae7e11a6@syzkaller.appspotmail.com,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 106/124] afs: Fix NULL deref in afs_dynroot_depopulate()
Date:   Mon, 24 Aug 2020 10:30:40 +0200
Message-Id: <20200824082414.623751839@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082409.368269240@linuxfoundation.org>
References: <20200824082409.368269240@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 5e0b17b026eb7c6de9baa9b0d45a51b05f05abe1 ]

If an error occurs during the construction of an afs superblock, it's
possible that an error occurs after a superblock is created, but before
we've created the root dentry.  If the superblock has a dynamic root
(ie.  what's normally mounted on /afs), the afs_kill_super() will call
afs_dynroot_depopulate() to unpin any created dentries - but this will
oops if the root hasn't been created yet.

Fix this by skipping that bit of code if there is no root dentry.

This leads to an oops looking like:

	general protection fault, ...
	KASAN: null-ptr-deref in range [0x0000000000000068-0x000000000000006f]
	...
	RIP: 0010:afs_dynroot_depopulate+0x25f/0x529 fs/afs/dynroot.c:385
	...
	Call Trace:
	 afs_kill_super+0x13b/0x180 fs/afs/super.c:535
	 deactivate_locked_super+0x94/0x160 fs/super.c:335
	 afs_get_tree+0x1124/0x1460 fs/afs/super.c:598
	 vfs_get_tree+0x89/0x2f0 fs/super.c:1547
	 do_new_mount fs/namespace.c:2875 [inline]
	 path_mount+0x1387/0x2070 fs/namespace.c:3192
	 do_mount fs/namespace.c:3205 [inline]
	 __do_sys_mount fs/namespace.c:3413 [inline]
	 __se_sys_mount fs/namespace.c:3390 [inline]
	 __x64_sys_mount+0x27f/0x300 fs/namespace.c:3390
	 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
	 entry_SYSCALL_64_after_hwframe+0x44/0xa9

which is oopsing on this line:

	inode_lock(root->d_inode);

presumably because sb->s_root was NULL.

Fixes: 0da0b7fd73e4 ("afs: Display manually added cells in dynamic root mount")
Reported-by: syzbot+c1eff8205244ae7e11a6@syzkaller.appspotmail.com
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/dynroot.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/fs/afs/dynroot.c b/fs/afs/dynroot.c
index 7503899c0a1b5..f07e53ab808e3 100644
--- a/fs/afs/dynroot.c
+++ b/fs/afs/dynroot.c
@@ -289,15 +289,17 @@ void afs_dynroot_depopulate(struct super_block *sb)
 		net->dynroot_sb = NULL;
 	mutex_unlock(&net->proc_cells_lock);
 
-	inode_lock(root->d_inode);
-
-	/* Remove all the pins for dirs created for manually added cells */
-	list_for_each_entry_safe(subdir, tmp, &root->d_subdirs, d_child) {
-		if (subdir->d_fsdata) {
-			subdir->d_fsdata = NULL;
-			dput(subdir);
+	if (root) {
+		inode_lock(root->d_inode);
+
+		/* Remove all the pins for dirs created for manually added cells */
+		list_for_each_entry_safe(subdir, tmp, &root->d_subdirs, d_child) {
+			if (subdir->d_fsdata) {
+				subdir->d_fsdata = NULL;
+				dput(subdir);
+			}
 		}
-	}
 
-	inode_unlock(root->d_inode);
+		inode_unlock(root->d_inode);
+	}
 }
-- 
2.25.1



