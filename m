Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 947FB3CE51D
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344294AbhGSPrr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:47:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:46660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349865AbhGSPp0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:45:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5116760C40;
        Mon, 19 Jul 2021 16:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711964;
        bh=kKMCEHCS9EGuoSCxnMrK/LQAQe697nLK2NLSkDtwF9Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CeZdBbOwB75ObpbShW29PgmOvVTVZ2KJBYONfFBIoRUb8wZRI5dNyklc0rJdzejVf
         wwODP5RBnLrjg5zPGylGkt46zwzk5ldYht2pjGW/bIlEQXfhY78daaN5me0oWz35DT
         scKokrQ7VQV+sxdH5l+uF+X1X6NijwCrCjRcht1M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhihao Cheng <chengzhihao1@huawei.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 199/292] ubifs: Set/Clear I_LINKABLE under i_lock for whiteout inode
Date:   Mon, 19 Jul 2021 16:54:21 +0200
Message-Id: <20210719144949.031103544@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhihao Cheng <chengzhihao1@huawei.com>

[ Upstream commit a801fcfeef96702fa3f9b22ad56c5eb1989d9221 ]

xfstests-generic/476 reports a warning message as below:

WARNING: CPU: 2 PID: 30347 at fs/inode.c:361 inc_nlink+0x52/0x70
Call Trace:
  do_rename+0x502/0xd40 [ubifs]
  ubifs_rename+0x8b/0x180 [ubifs]
  vfs_rename+0x476/0x1080
  do_renameat2+0x67c/0x7b0
  __x64_sys_renameat2+0x6e/0x90
  do_syscall_64+0x66/0xe0
  entry_SYSCALL_64_after_hwframe+0x44/0xae

Following race case can cause this:
         rename_whiteout(Thread 1)             wb_workfn(Thread 2)
ubifs_rename
  do_rename
                                          __writeback_single_inode
					    spin_lock(&inode->i_lock)
    whiteout->i_state |= I_LINKABLE
                                            inode->i_state &= ~dirty;
---- How race happens on i_state:
    (tmp = whiteout->i_state | I_LINKABLE)
		                           (tmp = inode->i_state & ~dirty)
    (whiteout->i_state = tmp)
		                           (inode->i_state = tmp)
----
					    spin_unlock(&inode->i_lock)
    inc_nlink(whiteout)
    WARN_ON(!(inode->i_state & I_LINKABLE)) !!!

Fix to add i_lock to avoid i_state update race condition.

Fixes: 9e0a1fff8db56ea ("ubifs: Implement RENAME_WHITEOUT")
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ubifs/dir.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index d9d8d7794eff..af1ea5fcd38d 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -1337,7 +1337,10 @@ static int do_rename(struct inode *old_dir, struct dentry *old_dentry,
 			goto out_release;
 		}
 
+		spin_lock(&whiteout->i_lock);
 		whiteout->i_state |= I_LINKABLE;
+		spin_unlock(&whiteout->i_lock);
+
 		whiteout_ui = ubifs_inode(whiteout);
 		whiteout_ui->data = dev;
 		whiteout_ui->data_len = ubifs_encode_dev(dev, MKDEV(0, 0));
@@ -1430,7 +1433,11 @@ static int do_rename(struct inode *old_dir, struct dentry *old_dentry,
 
 		inc_nlink(whiteout);
 		mark_inode_dirty(whiteout);
+
+		spin_lock(&whiteout->i_lock);
 		whiteout->i_state &= ~I_LINKABLE;
+		spin_unlock(&whiteout->i_lock);
+
 		iput(whiteout);
 	}
 
-- 
2.30.2



