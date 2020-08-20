Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC3F24B890
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 13:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729418AbgHTLX3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 07:23:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:37066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730085AbgHTKHK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:07:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB3662067C;
        Thu, 20 Aug 2020 10:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597918029;
        bh=g7N0/vZFIa6paeWPq/ZEJNnxKB6/Yh9dRDNC5swfV/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OhHJW/vr+RTqiyINyOT7nNB2N434w+eUfLsnnp9SX70e0wUHYJbcuUbmCPqL+3+tl
         VNaFpGxpr1xXfbBKyJ9je8iOdSA9z+1Sk8fT6wfd8I4emSfaqbocxWQfV35b7kgXRH
         v3hrtHbYofgjak8B4NoWJyqRyDXpOUkmUJZC2DlM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 4.14 029/228] xattr: break delegations in {set,remove}xattr
Date:   Thu, 20 Aug 2020 11:20:04 +0200
Message-Id: <20200820091608.992828603@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091607.532711107@linuxfoundation.org>
References: <20200820091607.532711107@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frank van der Linden <fllinden@amazon.com>

commit 08b5d5014a27e717826999ad20e394a8811aae92 upstream.

set/removexattr on an exported filesystem should break NFS delegations.
This is true in general, but also for the upcoming support for
RFC 8726 (NFSv4 extended attribute support). Make sure that they do.

Additionally, they need to grow a _locked variant, since callers might
call this with i_rwsem held (like the NFS server code).

Cc: stable@vger.kernel.org # v4.9+
Cc: linux-fsdevel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Frank van der Linden <fllinden@amazon.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/xattr.c            |   84 +++++++++++++++++++++++++++++++++++++++++++++-----
 include/linux/xattr.h |    2 +
 2 files changed, 79 insertions(+), 7 deletions(-)

--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -204,10 +204,22 @@ int __vfs_setxattr_noperm(struct dentry
 	return error;
 }
 
-
+/**
+ * __vfs_setxattr_locked: set an extended attribute while holding the inode
+ * lock
+ *
+ *  @dentry - object to perform setxattr on
+ *  @name - xattr name to set
+ *  @value - value to set @name to
+ *  @size - size of @value
+ *  @flags - flags to pass into filesystem operations
+ *  @delegated_inode - on return, will contain an inode pointer that
+ *  a delegation was broken on, NULL if none.
+ */
 int
-vfs_setxattr(struct dentry *dentry, const char *name, const void *value,
-		size_t size, int flags)
+__vfs_setxattr_locked(struct dentry *dentry, const char *name,
+		const void *value, size_t size, int flags,
+		struct inode **delegated_inode)
 {
 	struct inode *inode = dentry->d_inode;
 	int error;
@@ -216,15 +228,40 @@ vfs_setxattr(struct dentry *dentry, cons
 	if (error)
 		return error;
 
-	inode_lock(inode);
 	error = security_inode_setxattr(dentry, name, value, size, flags);
 	if (error)
 		goto out;
 
+	error = try_break_deleg(inode, delegated_inode);
+	if (error)
+		goto out;
+
 	error = __vfs_setxattr_noperm(dentry, name, value, size, flags);
 
 out:
+	return error;
+}
+EXPORT_SYMBOL_GPL(__vfs_setxattr_locked);
+
+int
+vfs_setxattr(struct dentry *dentry, const char *name, const void *value,
+		size_t size, int flags)
+{
+	struct inode *inode = dentry->d_inode;
+	struct inode *delegated_inode = NULL;
+	int error;
+
+retry_deleg:
+	inode_lock(inode);
+	error = __vfs_setxattr_locked(dentry, name, value, size, flags,
+	    &delegated_inode);
 	inode_unlock(inode);
+
+	if (delegated_inode) {
+		error = break_deleg_wait(&delegated_inode);
+		if (!error)
+			goto retry_deleg;
+	}
 	return error;
 }
 EXPORT_SYMBOL_GPL(vfs_setxattr);
@@ -380,8 +417,18 @@ __vfs_removexattr(struct dentry *dentry,
 }
 EXPORT_SYMBOL(__vfs_removexattr);
 
+/**
+ * __vfs_removexattr_locked: set an extended attribute while holding the inode
+ * lock
+ *
+ *  @dentry - object to perform setxattr on
+ *  @name - name of xattr to remove
+ *  @delegated_inode - on return, will contain an inode pointer that
+ *  a delegation was broken on, NULL if none.
+ */
 int
-vfs_removexattr(struct dentry *dentry, const char *name)
+__vfs_removexattr_locked(struct dentry *dentry, const char *name,
+		struct inode **delegated_inode)
 {
 	struct inode *inode = dentry->d_inode;
 	int error;
@@ -390,11 +437,14 @@ vfs_removexattr(struct dentry *dentry, c
 	if (error)
 		return error;
 
-	inode_lock(inode);
 	error = security_inode_removexattr(dentry, name);
 	if (error)
 		goto out;
 
+	error = try_break_deleg(inode, delegated_inode);
+	if (error)
+		goto out;
+
 	error = __vfs_removexattr(dentry, name);
 
 	if (!error) {
@@ -403,12 +453,32 @@ vfs_removexattr(struct dentry *dentry, c
 	}
 
 out:
+	return error;
+}
+EXPORT_SYMBOL_GPL(__vfs_removexattr_locked);
+
+int
+vfs_removexattr(struct dentry *dentry, const char *name)
+{
+	struct inode *inode = dentry->d_inode;
+	struct inode *delegated_inode = NULL;
+	int error;
+
+retry_deleg:
+	inode_lock(inode);
+	error = __vfs_removexattr_locked(dentry, name, &delegated_inode);
 	inode_unlock(inode);
+
+	if (delegated_inode) {
+		error = break_deleg_wait(&delegated_inode);
+		if (!error)
+			goto retry_deleg;
+	}
+
 	return error;
 }
 EXPORT_SYMBOL_GPL(vfs_removexattr);
 
-
 /*
  * Extended attribute SET operations
  */
--- a/include/linux/xattr.h
+++ b/include/linux/xattr.h
@@ -52,8 +52,10 @@ ssize_t vfs_getxattr(struct dentry *, co
 ssize_t vfs_listxattr(struct dentry *d, char *list, size_t size);
 int __vfs_setxattr(struct dentry *, struct inode *, const char *, const void *, size_t, int);
 int __vfs_setxattr_noperm(struct dentry *, const char *, const void *, size_t, int);
+int __vfs_setxattr_locked(struct dentry *, const char *, const void *, size_t, int, struct inode **);
 int vfs_setxattr(struct dentry *, const char *, const void *, size_t, int);
 int __vfs_removexattr(struct dentry *, const char *);
+int __vfs_removexattr_locked(struct dentry *, const char *, struct inode **);
 int vfs_removexattr(struct dentry *, const char *);
 
 ssize_t generic_listxattr(struct dentry *dentry, char *buffer, size_t buffer_size);


