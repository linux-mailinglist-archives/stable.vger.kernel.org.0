Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56C06C1744
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 19:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730338AbfI2RhN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 13:37:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:50122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730347AbfI2RhK (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 13:37:10 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9EDCE21925;
        Sun, 29 Sep 2019 17:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569778629;
        bh=A7GZAnfAyDSBIRqcMyz/rqC9/Sv2BmrCZAvB7h4kXBI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v61iZ58IN3JVEDMCApeVLGbpjZEHsoil7+bTadVkCkH4vwX/5mg0ky6HTh7nQiEdn
         hVV+F/O0R81I5LB3PQR4uwWdQRpEDVglUMX5C29l3dpZL2qWlPU26FABkS79dRXgHq
         eF6XVqESwOWcoUeGEelO0Wz92+9DOb2YZDMRUryc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-s390@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.4 7/9] hypfs: Fix error number left in struct pointer member
Date:   Sun, 29 Sep 2019 13:36:52 -0400
Message-Id: <20190929173655.10178-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190929173655.10178-1-sashal@kernel.org>
References: <20190929173655.10178-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit b54c64f7adeb241423cd46598f458b5486b0375e ]

In hypfs_fill_super(), if hypfs_create_update_file() fails,
sbi->update_file is left holding an error number.  This is passed to
hypfs_kill_super() which doesn't check for this.

Fix this by not setting sbi->update_value until after we've checked for
error.

Fixes: 24bbb1faf3f0 ("[PATCH] s390_hypfs filesystem")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
cc: Heiko Carstens <heiko.carstens@de.ibm.com>
cc: linux-s390@vger.kernel.org
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/hypfs/inode.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/s390/hypfs/inode.c b/arch/s390/hypfs/inode.c
index c670279b33f0c..1de3fdfc35378 100644
--- a/arch/s390/hypfs/inode.c
+++ b/arch/s390/hypfs/inode.c
@@ -267,7 +267,7 @@ static int hypfs_show_options(struct seq_file *s, struct dentry *root)
 static int hypfs_fill_super(struct super_block *sb, void *data, int silent)
 {
 	struct inode *root_inode;
-	struct dentry *root_dentry;
+	struct dentry *root_dentry, *update_file;
 	int rc = 0;
 	struct hypfs_sb_info *sbi;
 
@@ -298,9 +298,10 @@ static int hypfs_fill_super(struct super_block *sb, void *data, int silent)
 		rc = hypfs_diag_create_files(root_dentry);
 	if (rc)
 		return rc;
-	sbi->update_file = hypfs_create_update_file(root_dentry);
-	if (IS_ERR(sbi->update_file))
-		return PTR_ERR(sbi->update_file);
+	update_file = hypfs_create_update_file(root_dentry);
+	if (IS_ERR(update_file))
+		return PTR_ERR(update_file);
+	sbi->update_file = update_file;
 	hypfs_update_update(sb);
 	pr_info("Hypervisor filesystem mounted\n");
 	return 0;
-- 
2.20.1

