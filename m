Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8AAF50F889
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 11:43:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346665AbiDZJIv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 05:08:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244323AbiDZJGY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 05:06:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A540FC8488;
        Tue, 26 Apr 2022 01:47:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3ADE6B81CB3;
        Tue, 26 Apr 2022 08:47:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9384C385A0;
        Tue, 26 Apr 2022 08:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962861;
        bh=yij2d1Ux7ctNvj7P7J9HDGOnvtH6jjc+nI7oka++9FQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xsrD4euY7v+y4w5W0N3BR2eTFTPkp/G+emBM/GpECuDFv/wSKnK7nPFUxunMUN896
         IgujwGhRiiB+6I2wtoyVaG97h/VfuY5gEouShsnoOn2OX97rKhaQd+OjFrc0S+ne4b
         JnGzCwyqgYRgGB4eMiOr0SC/ouWR1wmYVoU7NLXg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Seth Forshee <sforshee@digitalocean.com>,
        Christoph Hellwig <hch@lst.de>, regressions@lists.linux.dev,
        "Christian Brauner (Microsoft)" <brauner@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.17 114/146] fs: fix acl translation
Date:   Tue, 26 Apr 2022 10:21:49 +0200
Message-Id: <20220426081753.258552761@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081750.051179617@linuxfoundation.org>
References: <20220426081750.051179617@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Brauner <brauner@kernel.org>

commit 705191b03d507744c7e097f78d583621c14988ac upstream.

Last cycle we extended the idmapped mounts infrastructure to support
idmapped mounts of idmapped filesystems (No such filesystem yet exist.).
Since then, the meaning of an idmapped mount is a mount whose idmapping
is different from the filesystems idmapping.

While doing that work we missed to adapt the acl translation helpers.
They still assume that checking for the identity mapping is enough.  But
they need to use the no_idmapping() helper instead.

Note, POSIX ACLs are always translated right at the userspace-kernel
boundary using the caller's current idmapping and the initial idmapping.
The order depends on whether we're coming from or going to userspace.
The filesystem's idmapping doesn't matter at the border.

Consequently, if a non-idmapped mount is passed we need to make sure to
always pass the initial idmapping as the mount's idmapping and not the
filesystem idmapping.  Since it's irrelevant here it would yield invalid
ids and prevent setting acls for filesystems that are mountable in a
userns and support posix acls (tmpfs and fuse).

I verified the regression reported in [1] and verified that this patch
fixes it.  A regression test will be added to xfstests in parallel.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=215849 [1]
Fixes: bd303368b776 ("fs: support mapped mounts of mapped filesystems")
Cc: Seth Forshee <sforshee@digitalocean.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: <stable@vger.kernel.org> # 5.17
Cc: <regressions@lists.linux.dev>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/posix_acl.c                  |   10 ++++++++++
 fs/xattr.c                      |    6 ++++--
 include/linux/posix_acl_xattr.h |    4 ++++
 3 files changed, 18 insertions(+), 2 deletions(-)

--- a/fs/posix_acl.c
+++ b/fs/posix_acl.c
@@ -759,9 +759,14 @@ static void posix_acl_fix_xattr_userns(
 }
 
 void posix_acl_fix_xattr_from_user(struct user_namespace *mnt_userns,
+				   struct inode *inode,
 				   void *value, size_t size)
 {
 	struct user_namespace *user_ns = current_user_ns();
+
+	/* Leave ids untouched on non-idmapped mounts. */
+	if (no_idmapping(mnt_userns, i_user_ns(inode)))
+		mnt_userns = &init_user_ns;
 	if ((user_ns == &init_user_ns) && (mnt_userns == &init_user_ns))
 		return;
 	posix_acl_fix_xattr_userns(&init_user_ns, user_ns, mnt_userns, value,
@@ -769,9 +774,14 @@ void posix_acl_fix_xattr_from_user(struc
 }
 
 void posix_acl_fix_xattr_to_user(struct user_namespace *mnt_userns,
+				 struct inode *inode,
 				 void *value, size_t size)
 {
 	struct user_namespace *user_ns = current_user_ns();
+
+	/* Leave ids untouched on non-idmapped mounts. */
+	if (no_idmapping(mnt_userns, i_user_ns(inode)))
+		mnt_userns = &init_user_ns;
 	if ((user_ns == &init_user_ns) && (mnt_userns == &init_user_ns))
 		return;
 	posix_acl_fix_xattr_userns(user_ns, &init_user_ns, mnt_userns, value,
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -569,7 +569,8 @@ setxattr(struct user_namespace *mnt_user
 		}
 		if ((strcmp(kname, XATTR_NAME_POSIX_ACL_ACCESS) == 0) ||
 		    (strcmp(kname, XATTR_NAME_POSIX_ACL_DEFAULT) == 0))
-			posix_acl_fix_xattr_from_user(mnt_userns, kvalue, size);
+			posix_acl_fix_xattr_from_user(mnt_userns, d_inode(d),
+						      kvalue, size);
 	}
 
 	error = vfs_setxattr(mnt_userns, d, kname, kvalue, size, flags);
@@ -667,7 +668,8 @@ getxattr(struct user_namespace *mnt_user
 	if (error > 0) {
 		if ((strcmp(kname, XATTR_NAME_POSIX_ACL_ACCESS) == 0) ||
 		    (strcmp(kname, XATTR_NAME_POSIX_ACL_DEFAULT) == 0))
-			posix_acl_fix_xattr_to_user(mnt_userns, kvalue, error);
+			posix_acl_fix_xattr_to_user(mnt_userns, d_inode(d),
+						    kvalue, error);
 		if (size && copy_to_user(value, kvalue, error))
 			error = -EFAULT;
 	} else if (error == -ERANGE && size >= XATTR_SIZE_MAX) {
--- a/include/linux/posix_acl_xattr.h
+++ b/include/linux/posix_acl_xattr.h
@@ -34,15 +34,19 @@ posix_acl_xattr_count(size_t size)
 
 #ifdef CONFIG_FS_POSIX_ACL
 void posix_acl_fix_xattr_from_user(struct user_namespace *mnt_userns,
+				   struct inode *inode,
 				   void *value, size_t size);
 void posix_acl_fix_xattr_to_user(struct user_namespace *mnt_userns,
+				   struct inode *inode,
 				 void *value, size_t size);
 #else
 static inline void posix_acl_fix_xattr_from_user(struct user_namespace *mnt_userns,
+						 struct inode *inode,
 						 void *value, size_t size)
 {
 }
 static inline void posix_acl_fix_xattr_to_user(struct user_namespace *mnt_userns,
+					       struct inode *inode,
 					       void *value, size_t size)
 {
 }


