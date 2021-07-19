Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 268AF3CD913
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242537AbhGSO0d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:26:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:37472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242464AbhGSOZO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:25:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB05361003;
        Mon, 19 Jul 2021 15:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707153;
        bh=MSE0HJyv0gZvHrLGTwE0yeCLH3UFQ08Cfn7dQaC4XZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=okDjMMqDVarcYn8UEudZkgNktu5HL/5EyofB65qvbf/8r4n71a8AjbAd8PM8Ev1YV
         TxuB/YxJ10DsQ0A8W0gYNEjMNCGeUcyvPKyJPatCRfuTo+6LkoqZaZHniISPWQIKlD
         JBBOD6kgrRBwjtLbUZtqYQNAy4Hqg6ddJTksniq8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "zhangyi (F)" <yi.zhang@huawei.com>,
        Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 049/245] block_dump: remove block_dump feature in mark_inode_dirty()
Date:   Mon, 19 Jul 2021 16:49:51 +0200
Message-Id: <20210719144941.984586178@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.288257948@linuxfoundation.org>
References: <20210719144940.288257948@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zhangyi (F) <yi.zhang@huawei.com>

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
index 2de656ecc48b..008710314240 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -2088,28 +2088,6 @@ int dirtytime_interval_handler(struct ctl_table *table, int write,
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
  *	__mark_inode_dirty -	internal function
  *	@inode: inode to mark
@@ -2168,9 +2146,6 @@ void __mark_inode_dirty(struct inode *inode, int flags)
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



