Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FB5828AC9
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387396AbfEWTq4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:46:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:47938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387867AbfEWTN7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:13:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 278C6217D9;
        Thu, 23 May 2019 19:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558638838;
        bh=Yt3FjdJeDqmwJIX+H6jtdQ7dkyINtBL76TztmOZ5O+s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fz+3yuiPf3VBr+g51dusjIKpNWv0FPLeXpaaX1/kE2jUkrJnmSpallH3Qne3jAheg
         OIiFc5HOk8ldI1JfoY/uXrimLEiL4fYx8lfyE3ZzAsCp89V/ce07eBKBsXFlkpAh5r
         DtnQZmWmjbSWRVGj6roR7YaZLKlhJrxbUXjCw1/k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 63/77] apparmorfs: fix use-after-free on symlink traversal
Date:   Thu, 23 May 2019 21:06:21 +0200
Message-Id: <20190523181728.674674667@linuxfoundation.org>
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

[ Upstream commit f51dcd0f621caac5380ce90fbbeafc32ce4517ae ]

symlink body shouldn't be freed without an RCU delay.  Switch apparmorfs
to ->destroy_inode() and use of call_rcu(); free both the inode and symlink
body in the callback.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/apparmorfs.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/security/apparmor/apparmorfs.c b/security/apparmor/apparmorfs.c
index 0e03377bb83ea..dd746bd69a9b2 100644
--- a/security/apparmor/apparmorfs.c
+++ b/security/apparmor/apparmorfs.c
@@ -126,17 +126,22 @@ static int aafs_show_path(struct seq_file *seq, struct dentry *dentry)
 	return 0;
 }
 
-static void aafs_evict_inode(struct inode *inode)
+static void aafs_i_callback(struct rcu_head *head)
 {
-	truncate_inode_pages_final(&inode->i_data);
-	clear_inode(inode);
+	struct inode *inode = container_of(head, struct inode, i_rcu);
 	if (S_ISLNK(inode->i_mode))
 		kfree(inode->i_link);
+	free_inode_nonrcu(inode);
+}
+
+static void aafs_destroy_inode(struct inode *inode)
+{
+	call_rcu(&inode->i_rcu, aafs_i_callback);
 }
 
 static const struct super_operations aafs_super_ops = {
 	.statfs = simple_statfs,
-	.evict_inode = aafs_evict_inode,
+	.destroy_inode = aafs_destroy_inode,
 	.show_path = aafs_show_path,
 };
 
-- 
2.20.1



