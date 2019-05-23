Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C36BA28A68
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388338AbfEWTN7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:13:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:47840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388311AbfEWTNv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:13:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5007720863;
        Thu, 23 May 2019 19:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558638830;
        bh=lXNckAZnpcx/r52Bhu7DZWMItin9YE9HIlmcNz015hY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b0D2otx9dqJ1BtqPf1Cy9c5ni6fpoU7PSqH55ULp/yhUHT9nMt7mKaB3Ja7wAGRme
         VTQKBKcaO4HiADBh3/+nkR6obmO27MTTl3X7X/Hhem4S2WRHxUG4J0gYBlTVtg+jMb
         xHtWzdFqfLufXVd6wKxgfbED5VTtMzezE5BFGrm4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 62/77] securityfs: fix use-after-free on symlink traversal
Date:   Thu, 23 May 2019 21:06:20 +0200
Message-Id: <20190523181728.540271608@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181719.982121681@linuxfoundation.org>
References: <20190523181719.982121681@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



