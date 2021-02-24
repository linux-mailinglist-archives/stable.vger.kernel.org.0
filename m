Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86399323CCF
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:06:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235430AbhBXM4A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 07:56:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:50301 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235320AbhBXMxa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 07:53:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2CCEB64DD3;
        Wed, 24 Feb 2021 12:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171083;
        bh=FXmGM1ooEssuDdSf7p7UmMUFP3S6LlN04pHCgAIs4IY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jIQfBRg2HbNDNKOigWmYCGGfqkcIW+iRHfwpfenr28uVOn/i1ZjnihqZYSaTE58T+
         1+og3Mimu0hrngNJmeGXpw4YIGfRQPu7JxMQkfOz/LLH8vPDu5D5pxnU2B1YWBNHc+
         cqpcuPYojy5fnGVlShY9qSjaRPUzsZQ99AO3wklSrWUTawQ/uC7ks+YJxUDEEAsm+C
         2ZgVmnrAPZmjqFVQgXKXvDC31AH54GCrRDvTBvL1mnE/IYDg3Cs00i5fmScMpI9ioj
         myhUcvEM290yjTNEC0cair16OYxuFz4QnvqO0jY0doUu+4P4luyn4I8JpZnu1PNIrr
         j9GLJ5V1UJL/A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.11 42/67] f2fs: fix to set/clear I_LINKABLE under i_lock
Date:   Wed, 24 Feb 2021 07:50:00 -0500
Message-Id: <20210224125026.481804-42-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125026.481804-1-sashal@kernel.org>
References: <20210224125026.481804-1-sashal@kernel.org>
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
index 6edb1ab579a18..8878049685769 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -855,7 +855,11 @@ static int __f2fs_tmpfile(struct inode *dir, struct dentry *dentry,
 
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
@@ -1041,7 +1045,11 @@ static int f2fs_rename(struct inode *old_dir, struct dentry *old_dentry,
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

