Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7B2C287F0
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390362AbfEWTZQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:25:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:36510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391054AbfEWTZJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:25:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0015A2133D;
        Thu, 23 May 2019 19:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639508;
        bh=m5qC+82P5K9BXdU+ypEv7VBPEXPh/Ox/e4oI2RBIThA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rQPdxyZTcah5iepMtWnaXgeG+xiLSSwq9sGcVrgID0p0Uub/RLTnmWOu11imPvqOF
         mzJUy4u3Y5Dzx7oDsZBZbswlw+plkNlhXUMYXiMsZJubryATFWT7s5LI6GKU7qgvtS
         tCmpyXuboH3UZaAqoyzI3R0Aql6IWTjGVmz7BkPs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 114/139] apparmorfs: fix use-after-free on symlink traversal
Date:   Thu, 23 May 2019 21:06:42 +0200
Message-Id: <20190523181734.727126644@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181720.120897565@linuxfoundation.org>
References: <20190523181720.120897565@linuxfoundation.org>
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
index 3f80a684c232a..665853dd517ca 100644
--- a/security/apparmor/apparmorfs.c
+++ b/security/apparmor/apparmorfs.c
@@ -123,17 +123,22 @@ static int aafs_show_path(struct seq_file *seq, struct dentry *dentry)
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



