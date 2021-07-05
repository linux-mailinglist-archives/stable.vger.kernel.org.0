Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5D2F3BBFD8
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 17:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232582AbhGEPd2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 11:33:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:58662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231986AbhGEPcv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 11:32:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7BB8A619A4;
        Mon,  5 Jul 2021 15:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625499014;
        bh=bBqbVgGtHhYTPkgSoIkjqz5PTnzkvCn2RFMFe4PV48k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lYOvcxeHNInQSMgC5xznojE1udcEeyk8DnUo0RFBekuE2GmaPKXo8GtyJGjOyXWVK
         3rUZImmsMCKzkpuaPcrQGw28cKSAsNWTTpbDz3JbpzSsCzeD5wyzo6QbAhB14gQZJh
         EPcNC5YoYWQMJxBu6F2cIWu+rTylP0aHPHURPL2QT2k5vUALbre7EsvU9i8w6WJ8kS
         rDoydmc6M0brjUhiaAl14NEh37m/RYGcNo/Jc64qbowE9XZx3N0gkFHYYsqRMVWmHt
         vNfTrdcZ+SzKpsQ+sjsvDUWoFTr4lz475GQCLA27FJydoY4dO4z4JoVPW1b7RatUYP
         I7Ok6y3mYvTuQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "zhangyi (F)" <yi.zhang@huawei.com>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 10/41] block_dump: remove block_dump feature in mark_inode_dirty()
Date:   Mon,  5 Jul 2021 11:29:30 -0400
Message-Id: <20210705153001.1521447-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705153001.1521447-1-sashal@kernel.org>
References: <20210705153001.1521447-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "zhangyi (F)" <yi.zhang@huawei.com>

[ Upstream commit 12e0613715e1cf305fffafaf0e89d810d9a85cc0 ]

block_dump is an old debugging interface, one of it's functions is used
to print the information about who write which file on disk. If we
enable block_dump through /proc/sys/vm/block_dump and turn on debug log
level, we can gather information about write process name, target file
name and disk from kernel message. This feature is realized in
block_dump___mark_inode_dirty(), it print above information into kernel
message directly when marking inode dirty, so it is noisy and can easily
trigger log storm. At the same time, get the dentry refcount is also not
safe, we found it will lead to deadlock on ext4 file system with
data=journal mode.

After tracepoints has been introduced into the kernel, we got a
tracepoint in __mark_inode_dirty(), which is a better replacement of
block_dump___mark_inode_dirty(). The only downside is that it only trace
the inode number and not a file name, but it probably doesn't matter
because the original printed file name in block_dump is not accurate in
some cases, and we can still find it through the inode number and device
id. So this patch delete the dirting inode part of block_dump feature.

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20210313030146.2882027-2-yi.zhang@huawei.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fs-writeback.c | 25 -------------------------
 1 file changed, 25 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 90dddb507e4a..0d0f014b09ec 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -2196,28 +2196,6 @@ int dirtytime_interval_handler(struct ctl_table *table, int write,
 	return ret;
 }
 
-static noinline void block_dump___mark_inode_dirty(struct inode *inode)
-{
-	if (inode->i_ino || strcmp(inode->i_sb->s_id, "bdev")) {
-		struct dentry *dentry;
-		const char *name = "?";
-
-		dentry = d_find_alias(inode);
-		if (dentry) {
-			spin_lock(&dentry->d_lock);
-			name = (const char *) dentry->d_name.name;
-		}
-		printk(KERN_DEBUG
-		       "%s(%d): dirtied inode %lu (%s) on %s\n",
-		       current->comm, task_pid_nr(current), inode->i_ino,
-		       name, inode->i_sb->s_id);
-		if (dentry) {
-			spin_unlock(&dentry->d_lock);
-			dput(dentry);
-		}
-	}
-}
-
 /**
  * __mark_inode_dirty -	internal function
  *
@@ -2277,9 +2255,6 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 	    (dirtytime && (inode->i_state & I_DIRTY_INODE)))
 		return;
 
-	if (unlikely(block_dump))
-		block_dump___mark_inode_dirty(inode);
-
 	spin_lock(&inode->i_lock);
 	if (dirtytime && (inode->i_state & I_DIRTY_INODE))
 		goto out_unlock_inode;
-- 
2.30.2

