Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B04CBCD439
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727675AbfJFRXq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:23:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:48426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727664AbfJFRXp (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:23:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 502802080F;
        Sun,  6 Oct 2019 17:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570382624;
        bh=1xmyzwQAzoyVvQOqY0GRDWplegq/1md/Px3CgQEdzOE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HOZ788+BajqYuhtdxGoGped7l3fo3vkrboIuLH8iAX9CAaT+2WorqYgTt8oa1mdkw
         p2/l1eujScp+iQ5FlNmvvlJFtrIOZBu1bRhrwH2IQ8e2DloG+4UrgPNSkHSA58cxOX
         AI+346W4uGwWlNrx9Nm6xRoNpsSddM2Xub3i6Nn4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-s390@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 27/47] hypfs: Fix error number left in struct pointer member
Date:   Sun,  6 Oct 2019 19:21:14 +0200
Message-Id: <20191006172018.321876174@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006172016.873463083@linuxfoundation.org>
References: <20191006172016.873463083@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 2a17123130d30..224aeda1e8ccf 100644
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



