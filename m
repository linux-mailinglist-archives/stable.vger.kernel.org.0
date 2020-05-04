Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3CE71C4542
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 20:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731107AbgEDSNx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 14:13:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:56236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731104AbgEDSBD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 14:01:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DDCC2073B;
        Mon,  4 May 2020 18:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588615263;
        bh=0iBARj4TxwISLi/XhODDCPesSt/fsZtgRkxuEPlml6Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zl5obtgwKEPZtqCOYIpHuoY2KfZukm+2XcV1jD8PaN6MZaw6h8qaW5JwFLGMRpAJQ
         J0j0sYtev4Ll5HiemMM4/uBpaNtmoInQtmu/OaDcdPN91LjEZ9RmvYkoefazlMfCGu
         CJ9Q+Uk0DVYIRbzk1yuWz7K4HrNm8peSEyFPGjzc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 4.14 24/26] nfs: Fix potential posix_acl refcnt leak in nfs3_set_acl
Date:   Mon,  4 May 2020 19:57:38 +0200
Message-Id: <20200504165447.897342672@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504165442.494398840@linuxfoundation.org>
References: <20200504165442.494398840@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

commit 7648f939cb919b9d15c21fff8cd9eba908d595dc upstream.

nfs3_set_acl keeps track of the acl it allocated locally to determine if an acl
needs to be released at the end.  This results in a memory leak when the
function allocates an acl as well as a default acl.  Fix by releasing acls
that differ from the acl originally passed into nfs3_set_acl.

Fixes: b7fa0554cf1b ("[PATCH] NFS: Add support for NFSv3 ACLs")
Reported-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs3acl.c |   22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

--- a/fs/nfs/nfs3acl.c
+++ b/fs/nfs/nfs3acl.c
@@ -253,37 +253,45 @@ int nfs3_proc_setacls(struct inode *inod
 
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


