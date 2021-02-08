Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C372313CAB
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 19:09:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233684AbhBHSIc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 13:08:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:46610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235037AbhBHSDf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 13:03:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AEDD464EE0;
        Mon,  8 Feb 2021 17:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612807174;
        bh=kCphD7he7R7cuZCTQfKGPb34zJ/F338shRYWlceXJoA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tk/dpmXYXqiEFHuseEYunSygMPhGwkhtr5cu8lgsUkyRCmdc9aM3YtIE6gGnz66uT
         8O4fxpBqR12/zNo7irxRktxdHXJW50dYGD8g4F2va6e7eWcz6rEg3Sl/cFOQdA9lv2
         r0U8dzcWK9VasqKhVoAsrszyD1mbsMXI4LvWcKwvtFUp1R9uzraKpezPzBM/7I1zLo
         VU4fD94fWIMUF0lcQu17eB1y14B+hJhoLRPxnv3ypnCn2o9kAGhsCAGAi7mLy8JskF
         0wa70VgtOSTYMQicSeiIFZposqZL2fDUdMbmYSoBUJqCNzoZHZefmCviKbIzd7LGYO
         lNENbhkdYDUTQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Michael Labriola <michael.d.labriola@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-unionfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 06/14] ovl: skip getxattr of security labels
Date:   Mon,  8 Feb 2021 12:59:18 -0500
Message-Id: <20210208175926.2092211-6-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210208175926.2092211-1-sashal@kernel.org>
References: <20210208175926.2092211-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 6eb0b882ad231..e164f489d01d9 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -79,6 +79,14 @@ int ovl_copy_xattr(struct dentry *old, struct dentry *new)
 
 		if (ovl_is_private_xattr(name))
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
@@ -102,13 +110,6 @@ int ovl_copy_xattr(struct dentry *old, struct dentry *new)
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
 		if (error)
 			break;
-- 
2.27.0

