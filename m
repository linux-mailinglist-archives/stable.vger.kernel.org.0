Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93D6F323DCB
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:23:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234815AbhBXNTF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:19:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:58436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234103AbhBXNIk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 08:08:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A0BF64F9E;
        Wed, 24 Feb 2021 12:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171298;
        bh=jsqqPb9DXofZgOnQ9AAwrQBlYq22ff7hsEVbWseEDWc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fhOKr6c9tiQP8L7nFqj1Ep0B9y45RY9fQAH1iG6OpXqp+l3/aSWpDdPnApDEbS0Ex
         U6z+1ijYt2u7LZ74ZLJMFYbnC6BvFIrr26+tQxMvh0alNGH6dz4cJO+r8E0/Nz9b+Z
         u7L9wjY8N0OR2dmLPZJbPQYRitpeQz0lmbM9LabHuZTy6qrQcm0OdV7EukcIB88FNb
         NaCTvqU/LsINx4tXcubKuDNPurK8YFyCGbZpGhD+CeJISpG/3/rnCElWOgncL8WR6v
         drb2DNqi7XoRF3sWf1Xxp7kn7ApLa40ZNyEkfaeUIsW8xHnXEtOavEREfr4iHzlHkT
         qO5+THfefuc5Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.19 18/26] f2fs: fix to set/clear I_LINKABLE under i_lock
Date:   Wed, 24 Feb 2021 07:54:26 -0500
Message-Id: <20210224125435.483539-18-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125435.483539-1-sashal@kernel.org>
References: <20210224125435.483539-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit 46085f37fc9e12d5c3539fb768b5ad7951e72acf ]

fsstress + fault injection test case reports a warning message as
below:

WARNING: CPU: 13 PID: 6226 at fs/inode.c:361 inc_nlink+0x32/0x40
Call Trace:
 f2fs_init_inode_metadata+0x25c/0x4a0 [f2fs]
 f2fs_add_inline_entry+0x153/0x3b0 [f2fs]
 f2fs_add_dentry+0x75/0x80 [f2fs]
 f2fs_do_add_link+0x108/0x160 [f2fs]
 f2fs_rename2+0x6ab/0x14f0 [f2fs]
 vfs_rename+0x70c/0x940
 do_renameat2+0x4d8/0x4f0
 __x64_sys_renameat2+0x4b/0x60
 do_syscall_64+0x33/0x80
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Following race case can cause this:
Thread A				Kworker
- f2fs_rename
 - f2fs_create_whiteout
  - __f2fs_tmpfile
   - f2fs_i_links_write
    - f2fs_mark_inode_dirty_sync
     - mark_inode_dirty_sync
					- writeback_single_inode
					 - __writeback_single_inode
					  - spin_lock(&inode->i_lock)
   - inode->i_state |= I_LINKABLE
					  - inode->i_state &= ~dirty
					  - spin_unlock(&inode->i_lock)
 - f2fs_add_link
  - f2fs_do_add_link
   - f2fs_add_dentry
    - f2fs_add_inline_entry
     - f2fs_init_inode_metadata
      - f2fs_i_links_write
       - inc_nlink
        - WARN_ON(!(inode->i_state & I_LINKABLE))

Fix to add i_lock to avoid i_state update race condition.

Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/namei.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index 8617e742d0878..e20a0f9e68455 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -772,7 +772,11 @@ static int __f2fs_tmpfile(struct inode *dir, struct dentry *dentry,
 
 	if (whiteout) {
 		f2fs_i_links_write(inode, false);
+
+		spin_lock(&inode->i_lock);
 		inode->i_state |= I_LINKABLE;
+		spin_unlock(&inode->i_lock);
+
 		*whiteout = inode;
 	} else {
 		d_tmpfile(dentry, inode);
@@ -966,7 +970,11 @@ static int f2fs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		err = f2fs_add_link(old_dentry, whiteout);
 		if (err)
 			goto put_out_dir;
+
+		spin_lock(&whiteout->i_lock);
 		whiteout->i_state &= ~I_LINKABLE;
+		spin_unlock(&whiteout->i_lock);
+
 		iput(whiteout);
 	}
 
-- 
2.27.0

