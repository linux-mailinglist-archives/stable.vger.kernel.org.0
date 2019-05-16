Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E59F20582
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 13:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728095AbfEPLlR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 07:41:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:49948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727432AbfEPLlQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 May 2019 07:41:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F4E0216F4;
        Thu, 16 May 2019 11:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558006876;
        bh=IMJiCZPSYS+y4kCm9xDnxJHtTTXzXjnfjEhhpmvOUww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wJbGsCUo50qXQUPbFGkuOzS79HG+LdsGWegXTYznk0vef0yhgMAFxDkXehYppYPvX
         KaOUcQYMiuhs95G3vxtDb90y4CyRd2rLOzbEQ93bIUac4s0in/1ObJZ3hfgoGWs9a8
         0j6a87C2GmYlU0tK68KGkFrN7FiYO5H4wL4wM7S8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Al Viro <viro@zeniv.linux.org.uk>, Sasha Levin <sashal@kernel.org>,
        linux-security-module@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 07/16] securityfs: fix use-after-free on symlink traversal
Date:   Thu, 16 May 2019 07:40:58 -0400
Message-Id: <20190516114107.8963-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190516114107.8963-1-sashal@kernel.org>
References: <20190516114107.8963-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 46c874419652bbefdfed17420fd6e88d8a31d9ec ]

symlink body shouldn't be freed without an RCU delay.  Switch securityfs
to ->destroy_inode() and use of call_rcu(); free both the inode and symlink
body in the callback.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/inode.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/security/inode.c b/security/inode.c
index 8dd9ca8848e43..829f15672e01f 100644
--- a/security/inode.c
+++ b/security/inode.c
@@ -26,17 +26,22 @@
 static struct vfsmount *mount;
 static int mount_count;
 
-static void securityfs_evict_inode(struct inode *inode)
+static void securityfs_i_callback(struct rcu_head *head)
 {
-	truncate_inode_pages_final(&inode->i_data);
-	clear_inode(inode);
+	struct inode *inode = container_of(head, struct inode, i_rcu);
 	if (S_ISLNK(inode->i_mode))
 		kfree(inode->i_link);
+	free_inode_nonrcu(inode);
+}
+
+static void securityfs_destroy_inode(struct inode *inode)
+{
+	call_rcu(&inode->i_rcu, securityfs_i_callback);
 }
 
 static const struct super_operations securityfs_super_operations = {
 	.statfs		= simple_statfs,
-	.evict_inode	= securityfs_evict_inode,
+	.destroy_inode	= securityfs_destroy_inode,
 };
 
 static int fill_super(struct super_block *sb, void *data, int silent)
-- 
2.20.1

