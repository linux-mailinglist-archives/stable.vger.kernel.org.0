Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 563F731BCEF
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:38:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231437AbhBOPhn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:37:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:49648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231247AbhBOPfl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:35:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 67E9F64E7B;
        Mon, 15 Feb 2021 15:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403100;
        bh=c9oTIPCJxOABCDcp2YEZVO2qtD25V6Z2kSdaxHbHbRM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T9X67jzfeqO5g09i1IalyW0LGDF76sb4eDuWLXsP9B8YW7071SXmAKRLyk45E1Py7
         r1FE4iryQ+ClzbLB1xGGiyo8CEGDqhbs2Mr7buXWqFrXdh8OIp3krLw6PZH243CFQL
         kcRoReaN50G2RSeRklc7+cLxFuHL+fTJZr6vfzls=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Michael Labriola <michael.d.labriola@gmail.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 027/104] ovl: skip getxattr of security labels
Date:   Mon, 15 Feb 2021 16:26:40 +0100
Message-Id: <20210215152720.357560526@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152719.459796636@linuxfoundation.org>
References: <20210215152719.459796636@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit 03fedf93593c82538b18476d8c4f0e8f8435ea70 ]

When inode has no listxattr op of its own (e.g. squashfs) vfs_listxattr
calls the LSM inode_listsecurity hooks to list the xattrs that LSMs will
intercept in inode_getxattr hooks.

When selinux LSM is installed but not initialized, it will list the
security.selinux xattr in inode_listsecurity, but will not intercept it
in inode_getxattr.  This results in -ENODATA for a getxattr call for an
xattr returned by listxattr.

This situation was manifested as overlayfs failure to copy up lower
files from squashfs when selinux is built-in but not initialized,
because ovl_copy_xattr() iterates the lower inode xattrs by
vfs_listxattr() and vfs_getxattr().

ovl_copy_xattr() skips copy up of security labels that are indentified by
inode_copy_up_xattr LSM hooks, but it does that after vfs_getxattr().
Since we are not going to copy them, skip vfs_getxattr() of the security
labels.

Reported-by: Michael Labriola <michael.d.labriola@gmail.com>
Tested-by: Michael Labriola <michael.d.labriola@gmail.com>
Link: https://lore.kernel.org/linux-unionfs/2nv9d47zt7.fsf@aldarion.sourceruckus.org/
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/copy_up.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 955ecd4030f04..89d5d59c7d7a4 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -84,6 +84,14 @@ int ovl_copy_xattr(struct super_block *sb, struct dentry *old,
 
 		if (ovl_is_private_xattr(sb, name))
 			continue;
+
+		error = security_inode_copy_up_xattr(name);
+		if (error < 0 && error != -EOPNOTSUPP)
+			break;
+		if (error == 1) {
+			error = 0;
+			continue; /* Discard */
+		}
 retry:
 		size = vfs_getxattr(old, name, value, value_size);
 		if (size == -ERANGE)
@@ -107,13 +115,6 @@ retry:
 			goto retry;
 		}
 
-		error = security_inode_copy_up_xattr(name);
-		if (error < 0 && error != -EOPNOTSUPP)
-			break;
-		if (error == 1) {
-			error = 0;
-			continue; /* Discard */
-		}
 		error = vfs_setxattr(new, name, value, size, 0);
 		if (error) {
 			if (error != -EOPNOTSUPP || ovl_must_copy_xattr(name))
-- 
2.27.0



