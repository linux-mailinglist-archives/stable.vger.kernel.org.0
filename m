Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABAA1B847C
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393565AbfISWLV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:11:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:49980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393561AbfISWLU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:11:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14A7B21920;
        Thu, 19 Sep 2019 22:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568931079;
        bh=+BPb9aFqpMEOx8qFpFHPVr0Dux9gRUGsNun4XS+W0Ds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hyh5cX7fSgMp7nOGwgFbCWNk9qWbaFYSQDgvbp7K3cxycotMrr3eTiAoQqEOPKALI
         3dchvybt3kidxuCG6G7UPfs4Fx+Q8VJZt5OfyrhMBx+ofmaIrZUhDE+BRQDuP9HCvl
         6weumTbc+RTNISVFzB2ChSZqITCUGvOTo3sJCngA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        Colin Walters <walters@verbum.org>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.2 121/124] ovl: fix regression caused by overlapping layers detection
Date:   Fri, 20 Sep 2019 00:03:29 +0200
Message-Id: <20190919214823.578495152@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214819.198419517@linuxfoundation.org>
References: <20190919214819.198419517@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

commit 0be0bfd2de9dfdd2098a9c5b14bdd8f739c9165d upstream.

Once upon a time, commit 2cac0c00a6cd ("ovl: get exclusive ownership on
upper/work dirs") in v4.13 added some sanity checks on overlayfs layers.
This change caused a docker regression. The root cause was mount leaks
by docker, which as far as I know, still exist.

To mitigate the regression, commit 85fdee1eef1a ("ovl: fix regression
caused by exclusive upper/work dir protection") in v4.14 turned the
mount errors into warnings for the default index=off configuration.

Recently, commit 146d62e5a586 ("ovl: detect overlapping layers") in
v5.2, re-introduced exclusive upper/work dir checks regardless of
index=off configuration.

This changes the status quo and mount leak related bug reports have
started to re-surface. Restore the status quo to fix the regressions.
To clarify, index=off does NOT relax overlapping layers check for this
ovelayfs mount. index=off only relaxes exclusive upper/work dir checks
with another overlayfs mount.

To cover the part of overlapping layers detection that used the
exclusive upper/work dir checks to detect overlap with self upper/work
dir, add a trap also on the work base dir.

Link: https://github.com/moby/moby/issues/34672
Link: https://lore.kernel.org/linux-fsdevel/20171006121405.GA32700@veci.piliscsaba.szeredi.hu/
Link: https://github.com/containers/libpod/issues/3540
Fixes: 146d62e5a586 ("ovl: detect overlapping layers")
Cc: <stable@vger.kernel.org> # v4.19+
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Tested-by: Colin Walters <walters@verbum.org>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/filesystems/overlayfs.txt |    2 
 fs/overlayfs/ovl_entry.h                |    1 
 fs/overlayfs/super.c                    |   73 ++++++++++++++++++++------------
 3 files changed, 49 insertions(+), 27 deletions(-)

--- a/Documentation/filesystems/overlayfs.txt
+++ b/Documentation/filesystems/overlayfs.txt
@@ -302,7 +302,7 @@ beneath or above the path of another ove
 
 Using an upper layer path and/or a workdir path that are already used by
 another overlay mount is not allowed and may fail with EBUSY.  Using
-partially overlapping paths is not allowed but will not fail with EBUSY.
+partially overlapping paths is not allowed and may fail with EBUSY.
 If files are accessed from two overlayfs mounts which share or overlap the
 upper layer and/or workdir path the behavior of the overlay is undefined,
 though it will not result in a crash or deadlock.
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -66,6 +66,7 @@ struct ovl_fs {
 	bool workdir_locked;
 	/* Traps in ovl inode cache */
 	struct inode *upperdir_trap;
+	struct inode *workbasedir_trap;
 	struct inode *workdir_trap;
 	struct inode *indexdir_trap;
 	/* Inode numbers in all layers do not use the high xino_bits */
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -212,6 +212,7 @@ static void ovl_free_fs(struct ovl_fs *o
 {
 	unsigned i;
 
+	iput(ofs->workbasedir_trap);
 	iput(ofs->indexdir_trap);
 	iput(ofs->workdir_trap);
 	iput(ofs->upperdir_trap);
@@ -1003,6 +1004,25 @@ static int ovl_setup_trap(struct super_b
 	return 0;
 }
 
+/*
+ * Determine how we treat concurrent use of upperdir/workdir based on the
+ * index feature. This is papering over mount leaks of container runtimes,
+ * for example, an old overlay mount is leaked and now its upperdir is
+ * attempted to be used as a lower layer in a new overlay mount.
+ */
+static int ovl_report_in_use(struct ovl_fs *ofs, const char *name)
+{
+	if (ofs->config.index) {
+		pr_err("overlayfs: %s is in-use as upperdir/workdir of another mount, mount with '-o index=off' to override exclusive upperdir protection.\n",
+		       name);
+		return -EBUSY;
+	} else {
+		pr_warn("overlayfs: %s is in-use as upperdir/workdir of another mount, accessing files from both mounts will result in undefined behavior.\n",
+			name);
+		return 0;
+	}
+}
+
 static int ovl_get_upper(struct super_block *sb, struct ovl_fs *ofs,
 			 struct path *upperpath)
 {
@@ -1040,14 +1060,12 @@ static int ovl_get_upper(struct super_bl
 	upper_mnt->mnt_flags &= ~(MNT_NOATIME | MNT_NODIRATIME | MNT_RELATIME);
 	ofs->upper_mnt = upper_mnt;
 
-	err = -EBUSY;
 	if (ovl_inuse_trylock(ofs->upper_mnt->mnt_root)) {
 		ofs->upperdir_locked = true;
-	} else if (ofs->config.index) {
-		pr_err("overlayfs: upperdir is in-use by another mount, mount with '-o index=off' to override exclusive upperdir protection.\n");
-		goto out;
 	} else {
-		pr_warn("overlayfs: upperdir is in-use by another mount, accessing files from both mounts will result in undefined behavior.\n");
+		err = ovl_report_in_use(ofs, "upperdir");
+		if (err)
+			goto out;
 	}
 
 	err = 0;
@@ -1157,16 +1175,19 @@ static int ovl_get_workdir(struct super_
 
 	ofs->workbasedir = dget(workpath.dentry);
 
-	err = -EBUSY;
 	if (ovl_inuse_trylock(ofs->workbasedir)) {
 		ofs->workdir_locked = true;
-	} else if (ofs->config.index) {
-		pr_err("overlayfs: workdir is in-use by another mount, mount with '-o index=off' to override exclusive workdir protection.\n");
-		goto out;
 	} else {
-		pr_warn("overlayfs: workdir is in-use by another mount, accessing files from both mounts will result in undefined behavior.\n");
+		err = ovl_report_in_use(ofs, "workdir");
+		if (err)
+			goto out;
 	}
 
+	err = ovl_setup_trap(sb, ofs->workbasedir, &ofs->workbasedir_trap,
+			     "workdir");
+	if (err)
+		goto out;
+
 	err = ovl_make_workdir(sb, ofs, &workpath);
 
 out:
@@ -1313,16 +1334,16 @@ static int ovl_get_lower_layers(struct s
 		if (err < 0)
 			goto out;
 
-		err = -EBUSY;
-		if (ovl_is_inuse(stack[i].dentry)) {
-			pr_err("overlayfs: lowerdir is in-use as upperdir/workdir\n");
-			goto out;
-		}
-
 		err = ovl_setup_trap(sb, stack[i].dentry, &trap, "lowerdir");
 		if (err)
 			goto out;
 
+		if (ovl_is_inuse(stack[i].dentry)) {
+			err = ovl_report_in_use(ofs, "lowerdir");
+			if (err)
+				goto out;
+		}
+
 		mnt = clone_private_mount(&stack[i]);
 		err = PTR_ERR(mnt);
 		if (IS_ERR(mnt)) {
@@ -1469,8 +1490,8 @@ out_err:
  * - another layer of this overlayfs instance
  * - upper/work dir of any overlayfs instance
  */
-static int ovl_check_layer(struct super_block *sb, struct dentry *dentry,
-			   const char *name)
+static int ovl_check_layer(struct super_block *sb, struct ovl_fs *ofs,
+			   struct dentry *dentry, const char *name)
 {
 	struct dentry *next = dentry, *parent;
 	int err = 0;
@@ -1482,13 +1503,11 @@ static int ovl_check_layer(struct super_
 
 	/* Walk back ancestors to root (inclusive) looking for traps */
 	while (!err && parent != next) {
-		if (ovl_is_inuse(parent)) {
-			err = -EBUSY;
-			pr_err("overlayfs: %s path overlapping in-use upperdir/workdir\n",
-			       name);
-		} else if (ovl_lookup_trap_inode(sb, parent)) {
+		if (ovl_lookup_trap_inode(sb, parent)) {
 			err = -ELOOP;
 			pr_err("overlayfs: overlapping %s path\n", name);
+		} else if (ovl_is_inuse(parent)) {
+			err = ovl_report_in_use(ofs, name);
 		}
 		next = parent;
 		parent = dget_parent(next);
@@ -1509,7 +1528,8 @@ static int ovl_check_overlapping_layers(
 	int i, err;
 
 	if (ofs->upper_mnt) {
-		err = ovl_check_layer(sb, ofs->upper_mnt->mnt_root, "upperdir");
+		err = ovl_check_layer(sb, ofs, ofs->upper_mnt->mnt_root,
+				      "upperdir");
 		if (err)
 			return err;
 
@@ -1520,13 +1540,14 @@ static int ovl_check_overlapping_layers(
 		 * workbasedir.  In that case, we already have their traps in
 		 * inode cache and we will catch that case on lookup.
 		 */
-		err = ovl_check_layer(sb, ofs->workbasedir, "workdir");
+		err = ovl_check_layer(sb, ofs, ofs->workbasedir, "workdir");
 		if (err)
 			return err;
 	}
 
 	for (i = 0; i < ofs->numlower; i++) {
-		err = ovl_check_layer(sb, ofs->lower_layers[i].mnt->mnt_root,
+		err = ovl_check_layer(sb, ofs,
+				      ofs->lower_layers[i].mnt->mnt_root,
 				      "lowerdir");
 		if (err)
 			return err;


