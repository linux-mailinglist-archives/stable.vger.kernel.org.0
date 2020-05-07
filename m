Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 515071C8F43
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 16:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728817AbgEGOaW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 10:30:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:59174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728812AbgEGOaW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 May 2020 10:30:22 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E5A72083B;
        Thu,  7 May 2020 14:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588861821;
        bh=LeHCs5TUDusUjeNEfndr0UAM6RWKmcCX6pSKfwjK5ag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PGPN1iZAYAVC4qJkLUBmGhlUaHyM+Bx8uDp+OFlForWUcOPNoP4t3mFtwc902h+ee
         Knt0bgXpNqYiDgz+eoTncw7owwv7jFtaodu4Sa6ZMDNUL8ELoM8J2wIBUIGffNP+JY
         TAi+6VJ01GCH1jM0Uojgmr25aMFT/4JEK336jCdU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andreas Gruenbacher <agruenba@redhat.com>,
        Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 2/9] nfs: Fix potential posix_acl refcnt leak in nfs3_set_acl
Date:   Thu,  7 May 2020 10:30:11 -0400
Message-Id: <20200507143018.27195-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200507143018.27195-1-sashal@kernel.org>
References: <20200507143018.27195-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 7648f939cb919b9d15c21fff8cd9eba908d595dc ]

nfs3_set_acl keeps track of the acl it allocated locally to determine if an acl
needs to be released at the end.  This results in a memory leak when the
function allocates an acl as well as a default acl.  Fix by releasing acls
that differ from the acl originally passed into nfs3_set_acl.

Fixes: b7fa0554cf1b ("[PATCH] NFS: Add support for NFSv3 ACLs")
Reported-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs3acl.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/fs/nfs/nfs3acl.c b/fs/nfs/nfs3acl.c
index 1ebe2fc7cda27..05c697d5b4779 100644
--- a/fs/nfs/nfs3acl.c
+++ b/fs/nfs/nfs3acl.c
@@ -213,37 +213,45 @@ int nfs3_proc_setacls(struct inode *inode, struct posix_acl *acl,
 
 int nfs3_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 {
-	struct posix_acl *alloc = NULL, *dfacl = NULL;
+	struct posix_acl *orig = acl, *dfacl = NULL, *alloc;
 	int status;
 
 	if (S_ISDIR(inode->i_mode)) {
 		switch(type) {
 		case ACL_TYPE_ACCESS:
-			alloc = dfacl = get_acl(inode, ACL_TYPE_DEFAULT);
+			alloc = get_acl(inode, ACL_TYPE_DEFAULT);
 			if (IS_ERR(alloc))
 				goto fail;
+			dfacl = alloc;
 			break;
 
 		case ACL_TYPE_DEFAULT:
-			dfacl = acl;
-			alloc = acl = get_acl(inode, ACL_TYPE_ACCESS);
+			alloc = get_acl(inode, ACL_TYPE_ACCESS);
 			if (IS_ERR(alloc))
 				goto fail;
+			dfacl = acl;
+			acl = alloc;
 			break;
 		}
 	}
 
 	if (acl == NULL) {
-		alloc = acl = posix_acl_from_mode(inode->i_mode, GFP_KERNEL);
+		alloc = posix_acl_from_mode(inode->i_mode, GFP_KERNEL);
 		if (IS_ERR(alloc))
 			goto fail;
+		acl = alloc;
 	}
 	status = __nfs3_proc_setacls(inode, acl, dfacl);
-	posix_acl_release(alloc);
+out:
+	if (acl != orig)
+		posix_acl_release(acl);
+	if (dfacl != orig)
+		posix_acl_release(dfacl);
 	return status;
 
 fail:
-	return PTR_ERR(alloc);
+	status = PTR_ERR(alloc);
+	goto out;
 }
 
 const struct xattr_handler *nfs3_xattr_handlers[] = {
-- 
2.20.1

