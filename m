Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 484FF55DB0F
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345384AbiF1MQf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jun 2022 08:16:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345383AbiF1MQd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jun 2022 08:16:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D009327177
        for <stable@vger.kernel.org>; Tue, 28 Jun 2022 05:16:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6BA4A61139
        for <stable@vger.kernel.org>; Tue, 28 Jun 2022 12:16:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBD24C3411D;
        Tue, 28 Jun 2022 12:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656418591;
        bh=WJGLxH6yfKFTAVtza7751IrTIZFrca/ZNgtnabaxh9E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PfPt09AgX/iW2bSMFI2bX0XiGQLH95npHSAO9zAA1C63vT4mpbNY0Nz4fYKnBBWEj
         1/hd7zI5LuNYmR3TVZGDbDsHEghaDvDFG6Z5oEGOE2h6h5pu0sZj3xNxaGLrn43Q1y
         IhvH21sayAwsl19UTZo2qU8dj/7w0jt8ubmj93UyX8CnvJSzwMV5k5mSTgFcJw6wKe
         +ndHZCn53hihh/aLyaiT5wJHpq01/Sml3pSoOLnu/Tu9HMFr7uLSXzg7V/535hkjuk
         pWiLMm34/BDWjB1Ah8UGjA1pHAyb4tVt8vwBmlUvxbWJNvP2DQD7xb6s67/z38PA/w
         pEGnCBjqlI6WQ==
From:   Christian Brauner <brauner@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Christian Brauner <christian.brauner@ubuntu.com>,
        stable@vger.kernel.org
Subject: [PATCH 02/12] fs: move mapping helpers
Date:   Tue, 28 Jun 2022 14:16:10 +0200
Message-Id: <20220628121620.188722-3-brauner@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220628102244.wymkrob3cfys2h7i@wittgenstein>
References: <20220628121620.188722-1-brauner@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=11117; i=brauner@kernel.org; h=from:subject; bh=Vf/GOfhcOLg+Myjp7/VLzda0+oemQ1X/ucrSw3iT5to=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSTt+shXIiYpatLad649NcPyrL1mcOeRPQHxLwy+3HGbxT+h h3VCRykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwEQ6djAy/JhzV8/yflFTS3t5WV7+uy 3yS94fe2zu2W1hWP9pWkL6N4Z/qrdqrj5a1v2Jsyj19pZFz1Nd3p/1mvWi5tv5PCGjcEF+PgA=
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
---
 fs/ksmbd/smbacl.c             |   1 +
 fs/ksmbd/smbacl.h             |   1 +
 fs/open.c                     |   1 +
 fs/posix_acl.c                |   1 +
 fs/xfs/xfs_linux.h            |   1 +
 include/linux/fs.h            |  91 +-----------------------------
 include/linux/mnt_idmapping.h | 101 ++++++++++++++++++++++++++++++++++
 security/commoncap.c          |   1 +
 8 files changed, 108 insertions(+), 90 deletions(-)
 create mode 100644 include/linux/mnt_idmapping.h

diff --git a/fs/ksmbd/smbacl.c b/fs/ksmbd/smbacl.c
index 7e57ffdb4ce3..7a6675fe57f7 100644
--- a/fs/ksmbd/smbacl.c
+++ b/fs/ksmbd/smbacl.c
@@ -9,6 +9,7 @@
 #include <linux/fs.h>
 #include <linux/slab.h>
 #include <linux/string.h>
+#include <linux/mnt_idmapping.h>
 
 #include "smbacl.h"
 #include "smb_common.h"
diff --git a/fs/ksmbd/smbacl.h b/fs/ksmbd/smbacl.h
index 73e08cad412b..eba1ebb9e92e 100644
--- a/fs/ksmbd/smbacl.h
+++ b/fs/ksmbd/smbacl.h
@@ -11,6 +11,7 @@
 #include <linux/fs.h>
 #include <linux/namei.h>
 #include <linux/posix_acl.h>
+#include <linux/mnt_idmapping.h>
 
 #include "mgmt/tree_connect.h"
 
diff --git a/fs/open.c b/fs/open.c
index e0df1536eb69..3d2a95ca6404 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -32,6 +32,7 @@
 #include <linux/ima.h>
 #include <linux/dnotify.h>
 #include <linux/compat.h>
+#include <linux/mnt_idmapping.h>
 
 #include "internal.h"
 
diff --git a/fs/posix_acl.c b/fs/posix_acl.c
index f5c25f580dd9..f7cacce3c3e2 100644
--- a/fs/posix_acl.c
+++ b/fs/posix_acl.c
@@ -23,6 +23,7 @@
 #include <linux/export.h>
 #include <linux/user_namespace.h>
 #include <linux/namei.h>
+#include <linux/mnt_idmapping.h>
 
 static struct posix_acl **acl_by_type(struct inode *inode, int type)
 {
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index c174262a074e..09a8fba84ff9 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -61,6 +61,7 @@ typedef __u32			xfs_nlink_t;
 #include <linux/ratelimit.h>
 #include <linux/rhashtable.h>
 #include <linux/xattr.h>
+#include <linux/mnt_idmapping.h>
 
 #include <asm/page.h>
 #include <asm/div64.h>
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 5720473b94b1..b1d446d71c3f 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -41,6 +41,7 @@
 #include <linux/stddef.h>
 #include <linux/mount.h>
 #include <linux/cred.h>
+#include <linux/mnt_idmapping.h>
 
 #include <asm/byteorder.h>
 #include <uapi/linux/fs.h>
@@ -1626,34 +1627,6 @@ static inline void i_gid_write(struct inode *inode, gid_t gid)
 	inode->i_gid = make_kgid(inode->i_sb->s_user_ns, gid);
 }
 
-/**
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
 /**
  * i_uid_into_mnt - map an inode's i_uid down into a mnt_userns
  * @mnt_userns: user namespace of the mount the inode was found from
@@ -1682,68 +1655,6 @@ static inline kgid_t i_gid_into_mnt(struct user_namespace *mnt_userns,
 	return kgid_into_mnt(mnt_userns, inode->i_gid);
 }
 
-/**
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
 /**
  * inode_fsuid_set - initialize inode's i_uid field with callers fsuid
  * @inode: inode to initialize
diff --git a/include/linux/mnt_idmapping.h b/include/linux/mnt_idmapping.h
new file mode 100644
index 000000000000..47c7811fadfe
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
diff --git a/security/commoncap.c b/security/commoncap.c
index 3f810d37b71b..09479f71ee2e 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -24,6 +24,7 @@
 #include <linux/user_namespace.h>
 #include <linux/binfmts.h>
 #include <linux/personality.h>
+#include <linux/mnt_idmapping.h>
 
 /*
  * If a non-root user executes a setuid-root binary in
-- 
2.34.1

