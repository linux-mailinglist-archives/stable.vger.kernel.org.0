Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD9314D51
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 16:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728340AbfEFOuK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:50:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:51504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729597AbfEFOtj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:49:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0E0621530;
        Mon,  6 May 2019 14:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557154179;
        bh=Hnb7z3+7JBqf/LXbuVAtgRZVI934LRCWUyNEAg07ttQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NAFf8ULk5aPoDrmm/RMZsHcbxDwIyRb20j4GBjXSLxjNX5wgr4hDA9BngI1pks2BS
         3oKNei4pRsFsXc6SsZRbY1qKA+BQMCXRFm5tpV3IKaHkRUEk8878vLOopEEWJhGYbj
         QxeJfEbBOWocv4BhqhWsUD6iANfqsfNLcFAgEfqM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 41/62] debugfs: fix use-after-free on symlink traversal
Date:   Mon,  6 May 2019 16:33:12 +0200
Message-Id: <20190506143054.696253573@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143051.102535767@linuxfoundation.org>
References: <20190506143051.102535767@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 93b919da64c15b90953f96a536e5e61df896ca57 ]

symlink body shouldn't be freed without an RCU delay.  Switch debugfs to
->destroy_inode() and use of call_rcu(); free both the inode and symlink
body in the callback.  Similar to solution for bpf, only here it's even
more obvious that ->evict_inode() can be dropped.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/debugfs/inode.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index 77e9cd7a0137..20ee612017bf 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -170,19 +170,24 @@ static int debugfs_show_options(struct seq_file *m, struct dentry *root)
 	return 0;
 }
 
-static void debugfs_evict_inode(struct inode *inode)
+static void debugfs_i_callback(struct rcu_head *head)
 {
-	truncate_inode_pages_final(&inode->i_data);
-	clear_inode(inode);
+	struct inode *inode = container_of(head, struct inode, i_rcu);
 	if (S_ISLNK(inode->i_mode))
 		kfree(inode->i_link);
+	free_inode_nonrcu(inode);
+}
+
+static void debugfs_destroy_inode(struct inode *inode)
+{
+	call_rcu(&inode->i_rcu, debugfs_i_callback);
 }
 
 static const struct super_operations debugfs_super_operations = {
 	.statfs		= simple_statfs,
 	.remount_fs	= debugfs_remount,
 	.show_options	= debugfs_show_options,
-	.evict_inode	= debugfs_evict_inode,
+	.destroy_inode	= debugfs_destroy_inode,
 };
 
 static struct vfsmount *debugfs_automount(struct path *path)
-- 
2.20.1



