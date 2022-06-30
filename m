Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43CDD561CE4
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 16:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236947AbiF3OLv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 10:11:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236878AbiF3OKx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 10:10:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD08D36B7D;
        Thu, 30 Jun 2022 06:55:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1E116B82AF4;
        Thu, 30 Jun 2022 13:55:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F6CFC341CB;
        Thu, 30 Jun 2022 13:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656597344;
        bh=HP2qV5LrHhp9bKrd7hSE3trP3eHldB16bon3al1pziA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pIQ9Ebky842iy+MyXwC38n0aRMpHRS1XKa+fwuXQ7SrLMkGgn+U1VnYNTQF4+h7xI
         1pFc6rnJkl2BAOxrVdBUM3bIl7UElsWkWy7bwg8S5tmuvZtcJPJggYtnvnQRfKv+g8
         QxwYmajyV/r21rzgK74kiZIHMuDerwGikbmSMc/w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Seth Forshee <sforshee@digitalocean.com>,
        Christoph Hellwig <hch@lst.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        "Christian Brauner (Microsoft)" <brauner@kernel.org>
Subject: [PATCH 5.15 14/28] fs: move mapping helpers
Date:   Thu, 30 Jun 2022 15:47:10 +0200
Message-Id: <20220630133233.347526772@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220630133232.926711493@linuxfoundation.org>
References: <20220630133232.926711493@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Christian Brauner <christian.brauner@ubuntu.com>

commit a793d79ea3e041081cd7cbd8ee43d0b5e4914a2b upstream.

The low-level mapping helpers were so far crammed into fs.h. They are
out of place there. The fs.h header should just contain the higher-level
mapping helpers that interact directly with vfs objects such as struct
super_block or struct inode and not the bare mapping helpers. Similarly,
only vfs and specific fs code shall interact with low-level mapping
helpers. And so they won't be made accessible automatically through
regular {g,u}id helpers.

Link: https://lore.kernel.org/r/20211123114227.3124056-3-brauner@kernel.org (v1)
Link: https://lore.kernel.org/r/20211130121032.3753852-3-brauner@kernel.org (v2)
Link: https://lore.kernel.org/r/20211203111707.3901969-3-brauner@kernel.org
Cc: Seth Forshee <sforshee@digitalocean.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
CC: linux-fsdevel@vger.kernel.org
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Seth Forshee <sforshee@digitalocean.com>
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smbacl.c             |    1 
 fs/ksmbd/smbacl.h             |    1 
 fs/open.c                     |    1 
 fs/posix_acl.c                |    1 
 fs/xfs/xfs_linux.h            |    1 
 include/linux/fs.h            |   91 -------------------------------------
 include/linux/mnt_idmapping.h |  101 ++++++++++++++++++++++++++++++++++++++++++
 security/commoncap.c          |    1 
 8 files changed, 108 insertions(+), 90 deletions(-)
 create mode 100644 include/linux/mnt_idmapping.h

--- a/fs/ksmbd/smbacl.c
+++ b/fs/ksmbd/smbacl.c
@@ -9,6 +9,7 @@
 #include <linux/fs.h>
 #include <linux/slab.h>
 #include <linux/string.h>
+#include <linux/mnt_idmapping.h>
 
 #include "smbacl.h"
 #include "smb_common.h"
--- a/fs/ksmbd/smbacl.h
+++ b/fs/ksmbd/smbacl.h
@@ -11,6 +11,7 @@
 #include <linux/fs.h>
 #include <linux/namei.h>
 #include <linux/posix_acl.h>
+#include <linux/mnt_idmapping.h>
 
 #include "mgmt/tree_connect.h"
 
--- a/fs/open.c
+++ b/fs/open.c
@@ -32,6 +32,7 @@
 #include <linux/ima.h>
 #include <linux/dnotify.h>
 #include <linux/compat.h>
+#include <linux/mnt_idmapping.h>
 
 #include "internal.h"
 
--- a/fs/posix_acl.c
+++ b/fs/posix_acl.c
@@ -23,6 +23,7 @@
 #include <linux/export.h>
 #include <linux/user_namespace.h>
 #include <linux/namei.h>
+#include <linux/mnt_idmapping.h>
 
 static struct posix_acl **acl_by_type(struct inode *inode, int type)
 {
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -61,6 +61,7 @@ typedef __u32			xfs_nlink_t;
 #include <linux/ratelimit.h>
 #include <linux/rhashtable.h>
 #include <linux/xattr.h>
+#include <linux/mnt_idmapping.h>
 
 #include <asm/page.h>
 #include <asm/div64.h>
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -41,6 +41,7 @@
 #include <linux/stddef.h>
 #include <linux/mount.h>
 #include <linux/cred.h>
+#include <linux/mnt_idmapping.h>
 
 #include <asm/byteorder.h>
 #include <uapi/linux/fs.h>
@@ -1627,34 +1628,6 @@ static inline void i_gid_write(struct in
 }
 
 /**
- * kuid_into_mnt - map a kuid down into a mnt_userns
- * @mnt_userns: user namespace of the relevant mount
- * @kuid: kuid to be mapped
- *
- * Return: @kuid mapped according to @mnt_userns.
- * If @kuid has no mapping INVALID_UID is returned.
- */
-static inline kuid_t kuid_into_mnt(struct user_namespace *mnt_userns,
-				   kuid_t kuid)
-{
-	return make_kuid(mnt_userns, __kuid_val(kuid));
-}
-
-/**
- * kgid_into_mnt - map a kgid down into a mnt_userns
- * @mnt_userns: user namespace of the relevant mount
- * @kgid: kgid to be mapped
- *
- * Return: @kgid mapped according to @mnt_userns.
- * If @kgid has no mapping INVALID_GID is returned.
- */
-static inline kgid_t kgid_into_mnt(struct user_namespace *mnt_userns,
-				   kgid_t kgid)
-{
-	return make_kgid(mnt_userns, __kgid_val(kgid));
-}
-
-/**
  * i_uid_into_mnt - map an inode's i_uid down into a mnt_userns
  * @mnt_userns: user namespace of the mount the inode was found from
  * @inode: inode to map
@@ -1683,68 +1656,6 @@ static inline kgid_t i_gid_into_mnt(stru
 }
 
 /**
- * kuid_from_mnt - map a kuid up into a mnt_userns
- * @mnt_userns: user namespace of the relevant mount
- * @kuid: kuid to be mapped
- *
- * Return: @kuid mapped up according to @mnt_userns.
- * If @kuid has no mapping INVALID_UID is returned.
- */
-static inline kuid_t kuid_from_mnt(struct user_namespace *mnt_userns,
-				   kuid_t kuid)
-{
-	return KUIDT_INIT(from_kuid(mnt_userns, kuid));
-}
-
-/**
- * kgid_from_mnt - map a kgid up into a mnt_userns
- * @mnt_userns: user namespace of the relevant mount
- * @kgid: kgid to be mapped
- *
- * Return: @kgid mapped up according to @mnt_userns.
- * If @kgid has no mapping INVALID_GID is returned.
- */
-static inline kgid_t kgid_from_mnt(struct user_namespace *mnt_userns,
-				   kgid_t kgid)
-{
-	return KGIDT_INIT(from_kgid(mnt_userns, kgid));
-}
-
-/**
- * mapped_fsuid - return caller's fsuid mapped up into a mnt_userns
- * @mnt_userns: user namespace of the relevant mount
- *
- * Use this helper to initialize a new vfs or filesystem object based on
- * the caller's fsuid. A common example is initializing the i_uid field of
- * a newly allocated inode triggered by a creation event such as mkdir or
- * O_CREAT. Other examples include the allocation of quotas for a specific
- * user.
- *
- * Return: the caller's current fsuid mapped up according to @mnt_userns.
- */
-static inline kuid_t mapped_fsuid(struct user_namespace *mnt_userns)
-{
-	return kuid_from_mnt(mnt_userns, current_fsuid());
-}
-
-/**
- * mapped_fsgid - return caller's fsgid mapped up into a mnt_userns
- * @mnt_userns: user namespace of the relevant mount
- *
- * Use this helper to initialize a new vfs or filesystem object based on
- * the caller's fsgid. A common example is initializing the i_gid field of
- * a newly allocated inode triggered by a creation event such as mkdir or
- * O_CREAT. Other examples include the allocation of quotas for a specific
- * user.
- *
- * Return: the caller's current fsgid mapped up according to @mnt_userns.
- */
-static inline kgid_t mapped_fsgid(struct user_namespace *mnt_userns)
-{
-	return kgid_from_mnt(mnt_userns, current_fsgid());
-}
-
-/**
  * inode_fsuid_set - initialize inode's i_uid field with callers fsuid
  * @inode: inode to initialize
  * @mnt_userns: user namespace of the mount the inode was found from
--- /dev/null
+++ b/include/linux/mnt_idmapping.h
@@ -0,0 +1,101 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_MNT_IDMAPPING_H
+#define _LINUX_MNT_IDMAPPING_H
+
+#include <linux/types.h>
+#include <linux/uidgid.h>
+
+struct user_namespace;
+extern struct user_namespace init_user_ns;
+
+/**
+ * kuid_into_mnt - map a kuid down into a mnt_userns
+ * @mnt_userns: user namespace of the relevant mount
+ * @kuid: kuid to be mapped
+ *
+ * Return: @kuid mapped according to @mnt_userns.
+ * If @kuid has no mapping INVALID_UID is returned.
+ */
+static inline kuid_t kuid_into_mnt(struct user_namespace *mnt_userns,
+				   kuid_t kuid)
+{
+	return make_kuid(mnt_userns, __kuid_val(kuid));
+}
+
+/**
+ * kgid_into_mnt - map a kgid down into a mnt_userns
+ * @mnt_userns: user namespace of the relevant mount
+ * @kgid: kgid to be mapped
+ *
+ * Return: @kgid mapped according to @mnt_userns.
+ * If @kgid has no mapping INVALID_GID is returned.
+ */
+static inline kgid_t kgid_into_mnt(struct user_namespace *mnt_userns,
+				   kgid_t kgid)
+{
+	return make_kgid(mnt_userns, __kgid_val(kgid));
+}
+
+/**
+ * kuid_from_mnt - map a kuid up into a mnt_userns
+ * @mnt_userns: user namespace of the relevant mount
+ * @kuid: kuid to be mapped
+ *
+ * Return: @kuid mapped up according to @mnt_userns.
+ * If @kuid has no mapping INVALID_UID is returned.
+ */
+static inline kuid_t kuid_from_mnt(struct user_namespace *mnt_userns,
+				   kuid_t kuid)
+{
+	return KUIDT_INIT(from_kuid(mnt_userns, kuid));
+}
+
+/**
+ * kgid_from_mnt - map a kgid up into a mnt_userns
+ * @mnt_userns: user namespace of the relevant mount
+ * @kgid: kgid to be mapped
+ *
+ * Return: @kgid mapped up according to @mnt_userns.
+ * If @kgid has no mapping INVALID_GID is returned.
+ */
+static inline kgid_t kgid_from_mnt(struct user_namespace *mnt_userns,
+				   kgid_t kgid)
+{
+	return KGIDT_INIT(from_kgid(mnt_userns, kgid));
+}
+
+/**
+ * mapped_fsuid - return caller's fsuid mapped up into a mnt_userns
+ * @mnt_userns: user namespace of the relevant mount
+ *
+ * Use this helper to initialize a new vfs or filesystem object based on
+ * the caller's fsuid. A common example is initializing the i_uid field of
+ * a newly allocated inode triggered by a creation event such as mkdir or
+ * O_CREAT. Other examples include the allocation of quotas for a specific
+ * user.
+ *
+ * Return: the caller's current fsuid mapped up according to @mnt_userns.
+ */
+static inline kuid_t mapped_fsuid(struct user_namespace *mnt_userns)
+{
+	return kuid_from_mnt(mnt_userns, current_fsuid());
+}
+
+/**
+ * mapped_fsgid - return caller's fsgid mapped up into a mnt_userns
+ * @mnt_userns: user namespace of the relevant mount
+ *
+ * Use this helper to initialize a new vfs or filesystem object based on
+ * the caller's fsgid. A common example is initializing the i_gid field of
+ * a newly allocated inode triggered by a creation event such as mkdir or
+ * O_CREAT. Other examples include the allocation of quotas for a specific
+ * user.
+ *
+ * Return: the caller's current fsgid mapped up according to @mnt_userns.
+ */
+static inline kgid_t mapped_fsgid(struct user_namespace *mnt_userns)
+{
+	return kgid_from_mnt(mnt_userns, current_fsgid());
+}
+
+#endif /* _LINUX_MNT_IDMAPPING_H */
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -24,6 +24,7 @@
 #include <linux/user_namespace.h>
 #include <linux/binfmts.h>
 #include <linux/personality.h>
+#include <linux/mnt_idmapping.h>
 
 /*
  * If a non-root user executes a setuid-root binary in


