Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B7DB608674
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231552AbiJVHtx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:49:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231683AbiJVHs7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:48:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBDF920B109;
        Sat, 22 Oct 2022 00:45:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7998260AD9;
        Sat, 22 Oct 2022 07:42:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8965AC433C1;
        Sat, 22 Oct 2022 07:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424524;
        bh=EdvmEvgLC/BcJJ495YvPMTi0CYghNIjjTCg4DPI5gko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q9uUtLtn/H9+xCvgkhRmbHJka+ayUddCX2gQ3674XOUpNw9eSpJy56UYZuIHlWmk3
         z5j8HmAntZvlAwiY1OZlzHBHHH7ct2BKN9erxshz7/fDSuVz7h1XNF1lEi9eDThxqi
         31ATDIbnQ0uzrvEVrmOCu5RxScHuCqw858kXry7g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Christian Brauner (Microsoft)" <brauner@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Seth Forshee <sforshee@kernel.org>
Subject: [PATCH 5.19 179/717] ntfs3: rework xattr handlers and switch to POSIX ACL VFS helpers
Date:   Sat, 22 Oct 2022 09:20:58 +0200
Message-Id: <20221022072447.251114074@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit a26aa12384158116c0d80d50e0bdc7b3323551e2 ]

The xattr code in ntfs3 is currently a bit confused. For example, it
defines a POSIX ACL i_op->set_acl() method but instead of relying on the
generic POSIX ACL VFS helpers it defines its own set of xattr helpers
with the consequence that i_op->set_acl() is currently dead code.

Switch ntfs3 to rely on the VFS POSIX ACL xattr handlers. Also remove
i_op->{g,s}et_acl() methods from symlink inode operations. Symlinks
don't support xattrs.

This is a preliminary change for the following patches which move
handling idmapped mounts directly in posix_acl_xattr_set().

This survives POSIX ACL xfstests.

Fixes: be71b5cba2e6 ("fs/ntfs3: Add attrib operations")
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Reviewed-by: Seth Forshee (DigitalOcean) <sforshee@kernel.org>>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/inode.c |   2 -
 fs/ntfs3/xattr.c | 102 +++--------------------------------------------
 2 files changed, 6 insertions(+), 98 deletions(-)

diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index 803ff4c63c31..3b94ad22d9c0 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -1941,8 +1941,6 @@ const struct inode_operations ntfs_link_inode_operations = {
 	.setattr	= ntfs3_setattr,
 	.listxattr	= ntfs_listxattr,
 	.permission	= ntfs_permission,
-	.get_acl	= ntfs_get_acl,
-	.set_acl	= ntfs_set_acl,
 };
 
 const struct address_space_operations ntfs_aops = {
diff --git a/fs/ntfs3/xattr.c b/fs/ntfs3/xattr.c
index e3d443ccb9be..19ce48726b00 100644
--- a/fs/ntfs3/xattr.c
+++ b/fs/ntfs3/xattr.c
@@ -625,67 +625,6 @@ int ntfs_set_acl(struct user_namespace *mnt_userns, struct inode *inode,
 	return ntfs_set_acl_ex(mnt_userns, inode, acl, type, false);
 }
 
-static int ntfs_xattr_get_acl(struct user_namespace *mnt_userns,
-			      struct inode *inode, int type, void *buffer,
-			      size_t size)
-{
-	struct posix_acl *acl;
-	int err;
-
-	if (!(inode->i_sb->s_flags & SB_POSIXACL)) {
-		ntfs_inode_warn(inode, "add mount option \"acl\" to use acl");
-		return -EOPNOTSUPP;
-	}
-
-	acl = ntfs_get_acl(inode, type, false);
-	if (IS_ERR(acl))
-		return PTR_ERR(acl);
-
-	if (!acl)
-		return -ENODATA;
-
-	err = posix_acl_to_xattr(&init_user_ns, acl, buffer, size);
-	posix_acl_release(acl);
-
-	return err;
-}
-
-static int ntfs_xattr_set_acl(struct user_namespace *mnt_userns,
-			      struct inode *inode, int type, const void *value,
-			      size_t size)
-{
-	struct posix_acl *acl;
-	int err;
-
-	if (!(inode->i_sb->s_flags & SB_POSIXACL)) {
-		ntfs_inode_warn(inode, "add mount option \"acl\" to use acl");
-		return -EOPNOTSUPP;
-	}
-
-	if (!inode_owner_or_capable(mnt_userns, inode))
-		return -EPERM;
-
-	if (!value) {
-		acl = NULL;
-	} else {
-		acl = posix_acl_from_xattr(&init_user_ns, value, size);
-		if (IS_ERR(acl))
-			return PTR_ERR(acl);
-
-		if (acl) {
-			err = posix_acl_valid(&init_user_ns, acl);
-			if (err)
-				goto release_and_out;
-		}
-	}
-
-	err = ntfs_set_acl(mnt_userns, inode, acl, type);
-
-release_and_out:
-	posix_acl_release(acl);
-	return err;
-}
-
 /*
  * ntfs_init_acl - Initialize the ACLs of a new inode.
  *
@@ -852,23 +791,6 @@ static int ntfs_getxattr(const struct xattr_handler *handler, struct dentry *de,
 		goto out;
 	}
 
-#ifdef CONFIG_NTFS3_FS_POSIX_ACL
-	if ((name_len == sizeof(XATTR_NAME_POSIX_ACL_ACCESS) - 1 &&
-	     !memcmp(name, XATTR_NAME_POSIX_ACL_ACCESS,
-		     sizeof(XATTR_NAME_POSIX_ACL_ACCESS))) ||
-	    (name_len == sizeof(XATTR_NAME_POSIX_ACL_DEFAULT) - 1 &&
-	     !memcmp(name, XATTR_NAME_POSIX_ACL_DEFAULT,
-		     sizeof(XATTR_NAME_POSIX_ACL_DEFAULT)))) {
-		/* TODO: init_user_ns? */
-		err = ntfs_xattr_get_acl(
-			&init_user_ns, inode,
-			name_len == sizeof(XATTR_NAME_POSIX_ACL_ACCESS) - 1
-				? ACL_TYPE_ACCESS
-				: ACL_TYPE_DEFAULT,
-			buffer, size);
-		goto out;
-	}
-#endif
 	/* Deal with NTFS extended attribute. */
 	err = ntfs_get_ea(inode, name, name_len, buffer, size, NULL);
 
@@ -981,22 +903,6 @@ static noinline int ntfs_setxattr(const struct xattr_handler *handler,
 		goto out;
 	}
 
-#ifdef CONFIG_NTFS3_FS_POSIX_ACL
-	if ((name_len == sizeof(XATTR_NAME_POSIX_ACL_ACCESS) - 1 &&
-	     !memcmp(name, XATTR_NAME_POSIX_ACL_ACCESS,
-		     sizeof(XATTR_NAME_POSIX_ACL_ACCESS))) ||
-	    (name_len == sizeof(XATTR_NAME_POSIX_ACL_DEFAULT) - 1 &&
-	     !memcmp(name, XATTR_NAME_POSIX_ACL_DEFAULT,
-		     sizeof(XATTR_NAME_POSIX_ACL_DEFAULT)))) {
-		err = ntfs_xattr_set_acl(
-			mnt_userns, inode,
-			name_len == sizeof(XATTR_NAME_POSIX_ACL_ACCESS) - 1
-				? ACL_TYPE_ACCESS
-				: ACL_TYPE_DEFAULT,
-			value, size);
-		goto out;
-	}
-#endif
 	/* Deal with NTFS extended attribute. */
 	err = ntfs_set_ea(inode, name, name_len, value, size, flags, 0);
 
@@ -1086,7 +992,7 @@ static bool ntfs_xattr_user_list(struct dentry *dentry)
 }
 
 // clang-format off
-static const struct xattr_handler ntfs_xattr_handler = {
+static const struct xattr_handler ntfs_other_xattr_handler = {
 	.prefix	= "",
 	.get	= ntfs_getxattr,
 	.set	= ntfs_setxattr,
@@ -1094,7 +1000,11 @@ static const struct xattr_handler ntfs_xattr_handler = {
 };
 
 const struct xattr_handler *ntfs_xattr_handlers[] = {
-	&ntfs_xattr_handler,
+#ifdef CONFIG_NTFS3_FS_POSIX_ACL
+	&posix_acl_access_xattr_handler,
+	&posix_acl_default_xattr_handler,
+#endif
+	&ntfs_other_xattr_handler,
 	NULL,
 };
 // clang-format on
-- 
2.35.1



