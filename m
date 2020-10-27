Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 859DB29BCD1
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:41:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1811097AbgJ0QhP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:37:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:41672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1801877AbgJ0Po7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:44:59 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 063A42416E;
        Tue, 27 Oct 2020 15:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813458;
        bh=/f3oVI6t4eM+8B9b7VE1pSXr06lHdbkOQzzCXsJyyXo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ItDDwxOZdbxRvTqxCok4yWHpFULLhEhUKp2xn4g8eF6vvqV7TD0v9wQffk94dEzen
         f9sITkSaQrDApw7SK0sN6eJlBQDMFGQiZEJ3ljYts0Y8cVqtl5D4P5PfXxHbURGNJ1
         nJkKuWYsRQtonRwzigmytGgIYRFqh3XFnzArVdqs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dai Ngo <dai.ngo@oracle.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 559/757] NFSv4.2: Fix NFS4ERR_STALE error when doing inter server copy
Date:   Tue, 27 Oct 2020 14:53:29 +0100
Message-Id: <20201027135516.719903113@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dai Ngo <dai.ngo@oracle.com>

[ Upstream commit 0cfcd405e758ba1d277e58436fb32f06888c3e41 ]

NFS_FS=y as dependency of CONFIG_NFSD_V4_2_INTER_SSC still have
build errors and some configs with NFSD=m to get NFS4ERR_STALE
error when doing inter server copy.

Added ops table in nfs_common for knfsd to access NFS client modules.

Fixes: 3ac3711adb88 ("NFSD: Fix NFS server build errors")
Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4file.c       | 38 ++++++++++++++---
 fs/nfs/nfs4super.c      |  5 +++
 fs/nfs/super.c          | 17 ++++++++
 fs/nfs_common/Makefile  |  1 +
 fs/nfs_common/nfs_ssc.c | 94 +++++++++++++++++++++++++++++++++++++++++
 fs/nfsd/Kconfig         |  2 +-
 fs/nfsd/nfs4proc.c      |  3 +-
 include/linux/nfs_ssc.h | 67 +++++++++++++++++++++++++++++
 8 files changed, 219 insertions(+), 8 deletions(-)
 create mode 100644 fs/nfs_common/nfs_ssc.c
 create mode 100644 include/linux/nfs_ssc.h

diff --git a/fs/nfs/nfs4file.c b/fs/nfs/nfs4file.c
index fdfc77486acee..984938024011b 100644
--- a/fs/nfs/nfs4file.c
+++ b/fs/nfs/nfs4file.c
@@ -9,6 +9,7 @@
 #include <linux/falloc.h>
 #include <linux/mount.h>
 #include <linux/nfs_fs.h>
+#include <linux/nfs_ssc.h>
 #include "delegation.h"
 #include "internal.h"
 #include "iostat.h"
@@ -314,9 +315,8 @@ static loff_t nfs42_remap_file_range(struct file *src_file, loff_t src_off,
 static int read_name_gen = 1;
 #define SSC_READ_NAME_BODY "ssc_read_%d"
 
-struct file *
-nfs42_ssc_open(struct vfsmount *ss_mnt, struct nfs_fh *src_fh,
-		nfs4_stateid *stateid)
+static struct file *__nfs42_ssc_open(struct vfsmount *ss_mnt,
+		struct nfs_fh *src_fh, nfs4_stateid *stateid)
 {
 	struct nfs_fattr fattr;
 	struct file *filep, *res;
@@ -398,14 +398,40 @@ nfs42_ssc_open(struct vfsmount *ss_mnt, struct nfs_fh *src_fh,
 	fput(filep);
 	goto out_free_name;
 }
-EXPORT_SYMBOL_GPL(nfs42_ssc_open);
-void nfs42_ssc_close(struct file *filep)
+
+static void __nfs42_ssc_close(struct file *filep)
 {
 	struct nfs_open_context *ctx = nfs_file_open_context(filep);
 
 	ctx->state->flags = 0;
 }
-EXPORT_SYMBOL_GPL(nfs42_ssc_close);
+
+static const struct nfs4_ssc_client_ops nfs4_ssc_clnt_ops_tbl = {
+	.sco_open = __nfs42_ssc_open,
+	.sco_close = __nfs42_ssc_close,
+};
+
+/**
+ * nfs42_ssc_register_ops - Wrapper to register NFS_V4 ops in nfs_common
+ *
+ * Return values:
+ *   None
+ */
+void nfs42_ssc_register_ops(void)
+{
+	nfs42_ssc_register(&nfs4_ssc_clnt_ops_tbl);
+}
+
+/**
+ * nfs42_ssc_unregister_ops - wrapper to un-register NFS_V4 ops in nfs_common
+ *
+ * Return values:
+ *   None.
+ */
+void nfs42_ssc_unregister_ops(void)
+{
+	nfs42_ssc_unregister(&nfs4_ssc_clnt_ops_tbl);
+}
 #endif /* CONFIG_NFS_V4_2 */
 
 const struct file_operations nfs4_file_operations = {
diff --git a/fs/nfs/nfs4super.c b/fs/nfs/nfs4super.c
index 0c1ab846b83dd..93f5c1678ec29 100644
--- a/fs/nfs/nfs4super.c
+++ b/fs/nfs/nfs4super.c
@@ -7,6 +7,7 @@
 #include <linux/mount.h>
 #include <linux/nfs4_mount.h>
 #include <linux/nfs_fs.h>
+#include <linux/nfs_ssc.h>
 #include "delegation.h"
 #include "internal.h"
 #include "nfs4_fs.h"
@@ -279,6 +280,9 @@ static int __init init_nfs_v4(void)
 	if (err)
 		goto out2;
 
+#ifdef CONFIG_NFS_V4_2
+	nfs42_ssc_register_ops();
+#endif
 	register_nfs_version(&nfs_v4);
 	return 0;
 out2:
@@ -297,6 +301,7 @@ static void __exit exit_nfs_v4(void)
 	unregister_nfs_version(&nfs_v4);
 #ifdef CONFIG_NFS_V4_2
 	nfs4_xattr_cache_exit();
+	nfs42_ssc_unregister_ops();
 #endif
 	nfs4_unregister_sysctl();
 	nfs_idmap_quit();
diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index 7a70287f21a2c..f7dad8227a5f4 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -57,6 +57,7 @@
 #include <linux/rcupdate.h>
 
 #include <linux/uaccess.h>
+#include <linux/nfs_ssc.h>
 
 #include "nfs4_fs.h"
 #include "callback.h"
@@ -85,6 +86,10 @@ const struct super_operations nfs_sops = {
 };
 EXPORT_SYMBOL_GPL(nfs_sops);
 
+static const struct nfs_ssc_client_ops nfs_ssc_clnt_ops_tbl = {
+	.sco_sb_deactive = nfs_sb_deactive,
+};
+
 #if IS_ENABLED(CONFIG_NFS_V4)
 static int __init register_nfs4_fs(void)
 {
@@ -106,6 +111,16 @@ static void unregister_nfs4_fs(void)
 }
 #endif
 
+static void nfs_ssc_register_ops(void)
+{
+	nfs_ssc_register(&nfs_ssc_clnt_ops_tbl);
+}
+
+static void nfs_ssc_unregister_ops(void)
+{
+	nfs_ssc_unregister(&nfs_ssc_clnt_ops_tbl);
+}
+
 static struct shrinker acl_shrinker = {
 	.count_objects	= nfs_access_cache_count,
 	.scan_objects	= nfs_access_cache_scan,
@@ -133,6 +148,7 @@ int __init register_nfs_fs(void)
 	ret = register_shrinker(&acl_shrinker);
 	if (ret < 0)
 		goto error_3;
+	nfs_ssc_register_ops();
 	return 0;
 error_3:
 	nfs_unregister_sysctl();
@@ -152,6 +168,7 @@ void __exit unregister_nfs_fs(void)
 	unregister_shrinker(&acl_shrinker);
 	nfs_unregister_sysctl();
 	unregister_nfs4_fs();
+	nfs_ssc_unregister_ops();
 	unregister_filesystem(&nfs_fs_type);
 }
 
diff --git a/fs/nfs_common/Makefile b/fs/nfs_common/Makefile
index 4bebe834c0091..fa82f5aaa6d95 100644
--- a/fs/nfs_common/Makefile
+++ b/fs/nfs_common/Makefile
@@ -7,3 +7,4 @@ obj-$(CONFIG_NFS_ACL_SUPPORT) += nfs_acl.o
 nfs_acl-objs := nfsacl.o
 
 obj-$(CONFIG_GRACE_PERIOD) += grace.o
+obj-$(CONFIG_GRACE_PERIOD) += nfs_ssc.o
diff --git a/fs/nfs_common/nfs_ssc.c b/fs/nfs_common/nfs_ssc.c
new file mode 100644
index 0000000000000..f43bbb3739134
--- /dev/null
+++ b/fs/nfs_common/nfs_ssc.c
@@ -0,0 +1,94 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * fs/nfs_common/nfs_ssc_comm.c
+ *
+ * Helper for knfsd's SSC to access ops in NFS client modules
+ *
+ * Author: Dai Ngo <dai.ngo@oracle.com>
+ *
+ * Copyright (c) 2020, Oracle and/or its affiliates.
+ */
+
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/nfs_ssc.h>
+#include "../nfs/nfs4_fs.h"
+
+MODULE_LICENSE("GPL");
+
+struct nfs_ssc_client_ops_tbl nfs_ssc_client_tbl;
+EXPORT_SYMBOL_GPL(nfs_ssc_client_tbl);
+
+#ifdef CONFIG_NFS_V4_2
+/**
+ * nfs42_ssc_register - install the NFS_V4 client ops in the nfs_ssc_client_tbl
+ * @ops: NFS_V4 ops to be installed
+ *
+ * Return values:
+ *   None
+ */
+void nfs42_ssc_register(const struct nfs4_ssc_client_ops *ops)
+{
+	nfs_ssc_client_tbl.ssc_nfs4_ops = ops;
+}
+EXPORT_SYMBOL_GPL(nfs42_ssc_register);
+
+/**
+ * nfs42_ssc_unregister - uninstall the NFS_V4 client ops from
+ *				the nfs_ssc_client_tbl
+ * @ops: ops to be uninstalled
+ *
+ * Return values:
+ *   None
+ */
+void nfs42_ssc_unregister(const struct nfs4_ssc_client_ops *ops)
+{
+	if (nfs_ssc_client_tbl.ssc_nfs4_ops != ops)
+		return;
+
+	nfs_ssc_client_tbl.ssc_nfs4_ops = NULL;
+}
+EXPORT_SYMBOL_GPL(nfs42_ssc_unregister);
+#endif /* CONFIG_NFS_V4_2 */
+
+#ifdef CONFIG_NFS_V4_2
+/**
+ * nfs_ssc_register - install the NFS_FS client ops in the nfs_ssc_client_tbl
+ * @ops: NFS_FS ops to be installed
+ *
+ * Return values:
+ *   None
+ */
+void nfs_ssc_register(const struct nfs_ssc_client_ops *ops)
+{
+	nfs_ssc_client_tbl.ssc_nfs_ops = ops;
+}
+EXPORT_SYMBOL_GPL(nfs_ssc_register);
+
+/**
+ * nfs_ssc_unregister - uninstall the NFS_FS client ops from
+ *				the nfs_ssc_client_tbl
+ * @ops: ops to be uninstalled
+ *
+ * Return values:
+ *   None
+ */
+void nfs_ssc_unregister(const struct nfs_ssc_client_ops *ops)
+{
+	if (nfs_ssc_client_tbl.ssc_nfs_ops != ops)
+		return;
+	nfs_ssc_client_tbl.ssc_nfs_ops = NULL;
+}
+EXPORT_SYMBOL_GPL(nfs_ssc_unregister);
+
+#else
+void nfs_ssc_register(const struct nfs_ssc_client_ops *ops)
+{
+}
+EXPORT_SYMBOL_GPL(nfs_ssc_register);
+
+void nfs_ssc_unregister(const struct nfs_ssc_client_ops *ops)
+{
+}
+EXPORT_SYMBOL_GPL(nfs_ssc_unregister);
+#endif /* CONFIG_NFS_V4_2 */
diff --git a/fs/nfsd/Kconfig b/fs/nfsd/Kconfig
index 99d2cae91bd68..f368f3215f88f 100644
--- a/fs/nfsd/Kconfig
+++ b/fs/nfsd/Kconfig
@@ -136,7 +136,7 @@ config NFSD_FLEXFILELAYOUT
 
 config NFSD_V4_2_INTER_SSC
 	bool "NFSv4.2 inter server to server COPY"
-	depends on NFSD_V4 && NFS_V4_1 && NFS_V4_2 && NFS_FS=y
+	depends on NFSD_V4 && NFS_V4_1 && NFS_V4_2
 	help
 	  This option enables support for NFSv4.2 inter server to
 	  server copy where the destination server calls the NFSv4.2
diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index eaf50eafa9359..84e10aef14175 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -38,6 +38,7 @@
 #include <linux/slab.h>
 #include <linux/kthread.h>
 #include <linux/sunrpc/addr.h>
+#include <linux/nfs_ssc.h>
 
 #include "idmap.h"
 #include "cache.h"
@@ -1247,7 +1248,7 @@ nfsd4_interssc_connect(struct nl4_server *nss, struct svc_rqst *rqstp,
 static void
 nfsd4_interssc_disconnect(struct vfsmount *ss_mnt)
 {
-	nfs_sb_deactive(ss_mnt->mnt_sb);
+	nfs_do_sb_deactive(ss_mnt->mnt_sb);
 	mntput(ss_mnt);
 }
 
diff --git a/include/linux/nfs_ssc.h b/include/linux/nfs_ssc.h
new file mode 100644
index 0000000000000..f5ba0fbff72fe
--- /dev/null
+++ b/include/linux/nfs_ssc.h
@@ -0,0 +1,67 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * include/linux/nfs_ssc.h
+ *
+ * Author: Dai Ngo <dai.ngo@oracle.com>
+ *
+ * Copyright (c) 2020, Oracle and/or its affiliates.
+ */
+
+#include <linux/nfs_fs.h>
+
+extern struct nfs_ssc_client_ops_tbl nfs_ssc_client_tbl;
+
+/*
+ * NFS_V4
+ */
+struct nfs4_ssc_client_ops {
+	struct file *(*sco_open)(struct vfsmount *ss_mnt,
+		struct nfs_fh *src_fh, nfs4_stateid *stateid);
+	void (*sco_close)(struct file *filep);
+};
+
+/*
+ * NFS_FS
+ */
+struct nfs_ssc_client_ops {
+	void (*sco_sb_deactive)(struct super_block *sb);
+};
+
+struct nfs_ssc_client_ops_tbl {
+	const struct nfs4_ssc_client_ops *ssc_nfs4_ops;
+	const struct nfs_ssc_client_ops *ssc_nfs_ops;
+};
+
+extern void nfs42_ssc_register_ops(void);
+extern void nfs42_ssc_unregister_ops(void);
+
+extern void nfs42_ssc_register(const struct nfs4_ssc_client_ops *ops);
+extern void nfs42_ssc_unregister(const struct nfs4_ssc_client_ops *ops);
+
+#ifdef CONFIG_NFSD_V4_2_INTER_SSC
+static inline struct file *nfs42_ssc_open(struct vfsmount *ss_mnt,
+		struct nfs_fh *src_fh, nfs4_stateid *stateid)
+{
+	if (nfs_ssc_client_tbl.ssc_nfs4_ops)
+		return (*nfs_ssc_client_tbl.ssc_nfs4_ops->sco_open)(ss_mnt, src_fh, stateid);
+	return ERR_PTR(-EIO);
+}
+
+static inline void nfs42_ssc_close(struct file *filep)
+{
+	if (nfs_ssc_client_tbl.ssc_nfs4_ops)
+		(*nfs_ssc_client_tbl.ssc_nfs4_ops->sco_close)(filep);
+}
+#endif
+
+/*
+ * NFS_FS
+ */
+extern void nfs_ssc_register(const struct nfs_ssc_client_ops *ops);
+extern void nfs_ssc_unregister(const struct nfs_ssc_client_ops *ops);
+
+static inline void nfs_do_sb_deactive(struct super_block *sb)
+{
+	if (nfs_ssc_client_tbl.ssc_nfs_ops)
+		(*nfs_ssc_client_tbl.ssc_nfs_ops->sco_sb_deactive)(sb);
+}
-- 
2.25.1



