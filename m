Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEDF355E275
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345471AbiF1MQt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jun 2022 08:16:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345464AbiF1MQs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jun 2022 08:16:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DF3223BCA
        for <stable@vger.kernel.org>; Tue, 28 Jun 2022 05:16:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6C1FB81D2D
        for <stable@vger.kernel.org>; Tue, 28 Jun 2022 12:16:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABC7BC341CA;
        Tue, 28 Jun 2022 12:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656418604;
        bh=cD33U5r4XYT0ngS5eTuLjOJTYGONIWNy6OYXPbBP1lE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TS/hpYf/pRHXEcbI2XnxsomVoZrSq7wDcA3FNOo90LqYkZdLaLUi7E9qQUt/VUJ6/
         mRa7NuZLahHGhKia/TUJNQ/d5C80uDU87QiPNwUTbfG702xBXXPaMbbu2QSl31PsQC
         7iCsnt5HduZ0VfSZ/Q+i0kntwF0muJ4CtkR8zpGj8L7lBHsliJUKGVabWiaKa1scZC
         h87WizlDaXARrf+qoGqE0ixryAu3X9VO3F9MH16vXbbtRuKqx4V4vR//ptf+WblMQj
         8ps+LliYZ1Z0BlzXrE49b0ZM285nreMyS9SZmtErF2DNUklRiOWkV/zRptdfdBkYf6
         L0naiaa0vDj/g==
From:   Christian Brauner <brauner@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Christian Brauner <brauner@kernel.org>, stable@vger.kernel.org
Subject: [PATCH 11/12] fs: fix acl translation
Date:   Tue, 28 Jun 2022 14:16:19 +0200
Message-Id: <20220628121620.188722-12-brauner@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220628102244.wymkrob3cfys2h7i@wittgenstein>
References: <20220628121620.188722-1-brauner@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5200; h=from:subject; bh=cD33U5r4XYT0ngS5eTuLjOJTYGONIWNy6OYXPbBP1lE=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSTt+igYE/7MaNNSi80ZytmvtOa4hHg5CNQLr6nW2pp57LOx sOO+jlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgInsmcnIMDP95KwP7551XRa76Si8a1 +snetLOduuKdzZy5pFA5S4DBj+B9hvO/7p2zo261SZ9Zs3ih9+vMO6LGfj6wnLT5wu/TJnHRsA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Cc: <stable@vger.kernel.org> # 5.15+
Cc: <regressions@lists.linux.dev>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
---
 fs/posix_acl.c                  | 10 ++++++++++
 fs/xattr.c                      |  6 ++++--
 include/linux/posix_acl_xattr.h |  4 ++++
 3 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/fs/posix_acl.c b/fs/posix_acl.c
index d6c7b620fb8f..ceb1e3b86857 100644
--- a/fs/posix_acl.c
+++ b/fs/posix_acl.c
@@ -760,9 +760,14 @@ static void posix_acl_fix_xattr_userns(
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
@@ -770,9 +775,14 @@ void posix_acl_fix_xattr_from_user(struct user_namespace *mnt_userns,
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
diff --git a/fs/xattr.c b/fs/xattr.c
index 5c8c5175b385..998045165916 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -569,7 +569,8 @@ setxattr(struct user_namespace *mnt_userns, struct dentry *d,
 		}
 		if ((strcmp(kname, XATTR_NAME_POSIX_ACL_ACCESS) == 0) ||
 		    (strcmp(kname, XATTR_NAME_POSIX_ACL_DEFAULT) == 0))
-			posix_acl_fix_xattr_from_user(mnt_userns, kvalue, size);
+			posix_acl_fix_xattr_from_user(mnt_userns, d_inode(d),
+						      kvalue, size);
 	}
 
 	error = vfs_setxattr(mnt_userns, d, kname, kvalue, size, flags);
@@ -667,7 +668,8 @@ getxattr(struct user_namespace *mnt_userns, struct dentry *d,
 	if (error > 0) {
 		if ((strcmp(kname, XATTR_NAME_POSIX_ACL_ACCESS) == 0) ||
 		    (strcmp(kname, XATTR_NAME_POSIX_ACL_DEFAULT) == 0))
-			posix_acl_fix_xattr_to_user(mnt_userns, kvalue, error);
+			posix_acl_fix_xattr_to_user(mnt_userns, d_inode(d),
+						    kvalue, error);
 		if (size && copy_to_user(value, kvalue, error))
 			error = -EFAULT;
 	} else if (error == -ERANGE && size >= XATTR_SIZE_MAX) {
diff --git a/include/linux/posix_acl_xattr.h b/include/linux/posix_acl_xattr.h
index 060e8d203181..1766e1de6956 100644
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
-- 
2.34.1

