Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B675F344314
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:51:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231370AbhCVMsd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:48:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:40980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230220AbhCVMox (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:44:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 12E786188B;
        Mon, 22 Mar 2021 12:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416920;
        bh=VJ0Hy3KGMAZvmLIly0o6oiF4S5eiylnw3YSn4zQq1ZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qGith+I72o/U0eUDmIthRZHJb2Vz2zL8en4bm1yQCTqCXvsTGCVRvjHYCM2Pjtqch
         ZIhz6Myely0ffVnNRFxvUJ/fFaXETCaL1q5017hyUsSO5FVHIdK4pIdSGgVydyErbm
         C9NZ5AMJCYf1oPHCXTH+M5Ze50lX9ZN1ffHC/S48=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Gaja Sophie Peters <gaja.peters@math.uni-hamburg.de>,
        David Howells <dhowells@redhat.com>,
        Jeffrey Altman <jaltman@auristor.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org
Subject: [PATCH 5.4 17/60] afs: Stop listxattr() from listing "afs.*" attributes
Date:   Mon, 22 Mar 2021 13:28:05 +0100
Message-Id: <20210322121922.953670150@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121922.372583154@linuxfoundation.org>
References: <20210322121922.372583154@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

commit a7889c6320b9200e3fe415238f546db677310fa9 upstream.

afs_listxattr() lists all the available special afs xattrs (i.e. those in
the "afs.*" space), no matter what type of server we're dealing with.  But
OpenAFS servers, for example, cannot deal with some of the extra-capable
attributes that AuriStor (YFS) servers provide.  Unfortunately, the
presence of the afs.yfs.* attributes causes errors[1] for anything that
tries to read them if the server is of the wrong type.

Fix the problem by removing afs_listxattr() so that none of the special
xattrs are listed (AFS doesn't support xattrs).  It does mean, however,
that getfattr won't list them, though they can still be accessed with
getxattr() and setxattr().

This can be tested with something like:

	getfattr -d -m ".*" /afs/example.com/path/to/file

With this change, none of the afs.* attributes should be visible.

Changes:
ver #2:
 - Hide all of the afs.* xattrs, not just the ACL ones.

Fixes: ae46578b963f ("afs: Get YFS ACLs and information through xattrs")
Reported-by: Gaja Sophie Peters <gaja.peters@math.uni-hamburg.de>
Signed-off-by: David Howells <dhowells@redhat.com>
Tested-by: Gaja Sophie Peters <gaja.peters@math.uni-hamburg.de>
Reviewed-by: Jeffrey Altman <jaltman@auristor.com>
Reviewed-by: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Link: http://lists.infradead.org/pipermail/linux-afs/2021-March/003502.html [1]
Link: http://lists.infradead.org/pipermail/linux-afs/2021-March/003567.html # v1
Link: http://lists.infradead.org/pipermail/linux-afs/2021-March/003573.html # v2
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/afs/dir.c      |    1 -
 fs/afs/file.c     |    1 -
 fs/afs/inode.c    |    1 -
 fs/afs/internal.h |    1 -
 fs/afs/mntpt.c    |    1 -
 fs/afs/xattr.c    |   23 -----------------------
 6 files changed, 28 deletions(-)

--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -69,7 +69,6 @@ const struct inode_operations afs_dir_in
 	.permission	= afs_permission,
 	.getattr	= afs_getattr,
 	.setattr	= afs_setattr,
-	.listxattr	= afs_listxattr,
 };
 
 const struct address_space_operations afs_dir_aops = {
--- a/fs/afs/file.c
+++ b/fs/afs/file.c
@@ -42,7 +42,6 @@ const struct inode_operations afs_file_i
 	.getattr	= afs_getattr,
 	.setattr	= afs_setattr,
 	.permission	= afs_permission,
-	.listxattr	= afs_listxattr,
 };
 
 const struct address_space_operations afs_fs_aops = {
--- a/fs/afs/inode.c
+++ b/fs/afs/inode.c
@@ -27,7 +27,6 @@
 
 static const struct inode_operations afs_symlink_inode_operations = {
 	.get_link	= page_get_link,
-	.listxattr	= afs_listxattr,
 };
 
 static noinline void dump_vnode(struct afs_vnode *vnode, struct afs_vnode *parent_vnode)
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -1354,7 +1354,6 @@ extern int afs_launder_page(struct page
  * xattr.c
  */
 extern const struct xattr_handler *afs_xattr_handlers[];
-extern ssize_t afs_listxattr(struct dentry *, char *, size_t);
 
 /*
  * yfsclient.c
--- a/fs/afs/mntpt.c
+++ b/fs/afs/mntpt.c
@@ -32,7 +32,6 @@ const struct inode_operations afs_mntpt_
 	.lookup		= afs_mntpt_lookup,
 	.readlink	= page_readlink,
 	.getattr	= afs_getattr,
-	.listxattr	= afs_listxattr,
 };
 
 const struct inode_operations afs_autocell_inode_operations = {
--- a/fs/afs/xattr.c
+++ b/fs/afs/xattr.c
@@ -11,29 +11,6 @@
 #include <linux/xattr.h>
 #include "internal.h"
 
-static const char afs_xattr_list[] =
-	"afs.acl\0"
-	"afs.cell\0"
-	"afs.fid\0"
-	"afs.volume\0"
-	"afs.yfs.acl\0"
-	"afs.yfs.acl_inherited\0"
-	"afs.yfs.acl_num_cleaned\0"
-	"afs.yfs.vol_acl";
-
-/*
- * Retrieve a list of the supported xattrs.
- */
-ssize_t afs_listxattr(struct dentry *dentry, char *buffer, size_t size)
-{
-	if (size == 0)
-		return sizeof(afs_xattr_list);
-	if (size < sizeof(afs_xattr_list))
-		return -ERANGE;
-	memcpy(buffer, afs_xattr_list, sizeof(afs_xattr_list));
-	return sizeof(afs_xattr_list);
-}
-
 /*
  * Get a file's ACL.
  */


