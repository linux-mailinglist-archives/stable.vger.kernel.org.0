Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D289A24B698
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 12:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731234AbgHTKho (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 06:37:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:40408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730227AbgHTKSQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:18:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60E2D20658;
        Thu, 20 Aug 2020 10:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597918696;
        bh=H8RqazvfPLcg8AnArJgxOeTbU03gYJDKrjnii7Iyc+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HLiD4Xl2dTO5VeKX0fqXlGapy8iQ2YXRpTVtX4Ofji/hYgMnoTfW7pRYcFJj9qAIw
         l5fKVip43ehY1eY7FZF6+B91wRWn3uLhXr9b6QhNG/MMag7cCDmqSu4bfoBn1MrClJ
         Qj4IgXSYnbzhIEnq4eCtEeDL6tJQGeoRPPPxaaYI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        linux-nfs@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 006/149] nfs: Move call to security_inode_listsecurity into nfs_listxattr
Date:   Thu, 20 Aug 2020 11:21:23 +0200
Message-Id: <20200820092126.000846141@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820092125.688850368@linuxfoundation.org>
References: <20200820092125.688850368@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit c4803c497fbdb37e96af614813a7cfb434b6682a ]

Add a nfs_listxattr operation.  Move the call to security_inode_listsecurity
from list operation of the "security.*" xattr handler to nfs_listxattr.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Trond Myklebust <trond.myklebust@primarydata.com>
Cc: Anna Schumaker <anna.schumaker@netapp.com>
Cc: linux-nfs@vger.kernel.org
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c          | 53 ++++++++++++++++++++++++++------------
 fs/xattr.c                 |  4 +++
 security/smack/smack_lsm.c |  2 --
 3 files changed, 40 insertions(+), 19 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 0308b56896382..566afcc36adb5 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -6296,10 +6296,6 @@ static size_t nfs4_xattr_list_nfs4_acl(const struct xattr_handler *handler,
 }
 
 #ifdef CONFIG_NFS_V4_SECURITY_LABEL
-static inline int nfs4_server_supports_labels(struct nfs_server *server)
-{
-	return server->caps & NFS_CAP_SECURITY_LABEL;
-}
 
 static int nfs4_xattr_set_nfs4_label(const struct xattr_handler *handler,
 				     struct dentry *dentry, const char *key,
@@ -6321,29 +6317,34 @@ static int nfs4_xattr_get_nfs4_label(const struct xattr_handler *handler,
 	return -EOPNOTSUPP;
 }
 
-static size_t nfs4_xattr_list_nfs4_label(const struct xattr_handler *handler,
-					 struct dentry *dentry, char *list,
-					 size_t list_len, const char *name,
-					 size_t name_len)
+static ssize_t
+nfs4_listxattr_nfs4_label(struct inode *inode, char *list, size_t list_len)
 {
-	size_t len = 0;
+	int len = 0;
 
-	if (nfs_server_capable(d_inode(dentry), NFS_CAP_SECURITY_LABEL)) {
-		len = security_inode_listsecurity(d_inode(dentry), NULL, 0);
-		if (list && len <= list_len)
-			security_inode_listsecurity(d_inode(dentry), list, len);
+	if (nfs_server_capable(inode, NFS_CAP_SECURITY_LABEL)) {
+		len = security_inode_listsecurity(inode, list, list_len);
+		if (list_len && len > list_len)
+			return -ERANGE;
 	}
 	return len;
 }
 
 static const struct xattr_handler nfs4_xattr_nfs4_label_handler = {
 	.prefix = XATTR_SECURITY_PREFIX,
-	.list	= nfs4_xattr_list_nfs4_label,
 	.get	= nfs4_xattr_get_nfs4_label,
 	.set	= nfs4_xattr_set_nfs4_label,
 };
-#endif
 
+#else
+
+static ssize_t
+nfs4_listxattr_nfs4_label(struct inode *inode, char *list, size_t list_len)
+{
+	return 0;
+}
+
+#endif
 
 /*
  * nfs_fhget will use either the mounted_on_fileid or the fileid
@@ -8773,6 +8774,24 @@ const struct nfs4_minor_version_ops *nfs_v4_minor_ops[] = {
 #endif
 };
 
+ssize_t nfs4_listxattr(struct dentry *dentry, char *list, size_t size)
+{
+	ssize_t error, error2;
+
+	error = generic_listxattr(dentry, list, size);
+	if (error < 0)
+		return error;
+	if (list) {
+		list += error;
+		size -= error;
+	}
+
+	error2 = nfs4_listxattr_nfs4_label(d_inode(dentry), list, size);
+	if (error2 < 0)
+		return error2;
+	return error + error2;
+}
+
 static const struct inode_operations nfs4_dir_inode_operations = {
 	.create		= nfs_create,
 	.lookup		= nfs_lookup,
@@ -8789,7 +8808,7 @@ static const struct inode_operations nfs4_dir_inode_operations = {
 	.setattr	= nfs_setattr,
 	.getxattr	= generic_getxattr,
 	.setxattr	= generic_setxattr,
-	.listxattr	= generic_listxattr,
+	.listxattr	= nfs4_listxattr,
 	.removexattr	= generic_removexattr,
 };
 
@@ -8799,7 +8818,7 @@ static const struct inode_operations nfs4_file_inode_operations = {
 	.setattr	= nfs_setattr,
 	.getxattr	= generic_getxattr,
 	.setxattr	= generic_setxattr,
-	.listxattr	= generic_listxattr,
+	.listxattr	= nfs4_listxattr,
 	.removexattr	= generic_removexattr,
 };
 
diff --git a/fs/xattr.c b/fs/xattr.c
index 09441c396798d..5ba5565609eed 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -735,6 +735,8 @@ generic_listxattr(struct dentry *dentry, char *buffer, size_t buffer_size)
 
 	if (!buffer) {
 		for_each_xattr_handler(handlers, handler) {
+			if (!handler->list)
+				continue;
 			size += handler->list(handler, dentry, NULL, 0,
 					      NULL, 0);
 		}
@@ -742,6 +744,8 @@ generic_listxattr(struct dentry *dentry, char *buffer, size_t buffer_size)
 		char *buf = buffer;
 
 		for_each_xattr_handler(handlers, handler) {
+			if (!handler->list)
+				continue;
 			size = handler->list(handler, dentry, buf, buffer_size,
 					     NULL, 0);
 			if (size > buffer_size)
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 716433e630529..d37c1963e8ca3 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -1513,8 +1513,6 @@ static int smack_inode_getsecurity(const struct inode *inode,
  * @inode: the object
  * @buffer: where they go
  * @buffer_size: size of buffer
- *
- * Returns 0 on success, -EINVAL otherwise
  */
 static int smack_inode_listsecurity(struct inode *inode, char *buffer,
 				    size_t buffer_size)
-- 
2.25.1



