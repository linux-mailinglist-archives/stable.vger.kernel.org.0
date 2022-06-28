Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B453855CA9A
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345411AbiF1MQf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jun 2022 08:16:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345384AbiF1MQe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jun 2022 08:16:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1B8525C76
        for <stable@vger.kernel.org>; Tue, 28 Jun 2022 05:16:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A4DEFB81855
        for <stable@vger.kernel.org>; Tue, 28 Jun 2022 12:16:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 744C0C341CB;
        Tue, 28 Jun 2022 12:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656418590;
        bh=Z7QdSQH8tofeo10jfD+WMYgjjq5/AbeySHQ370P4utg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ItdZ9t/UwPh89fk4bbJ8TTA0F/9pMsPmVA/kPSbZjgPJJsAOknP1mYzKbqyug8tan
         Q8Dob1nEsG676RC+7IMEdblZJQlCFXqDTQ+7pXocXm7Ik43ScIgxHmNIcbYb1odTWV
         7VUqKOV88jtTimA56viYalrP29YTX+OJlVOHG2IdlFm596uH1LUl+BWQtd37/ayjj5
         qdehS3CmNY8nSE6TCtoJ1o5PCRi/ieIRgP8AW58bV82NmpP6dQUaf59vq7CRKMkFDI
         sHHksMpwftcaVAphYlnp57maJVmAKc5yfpXHICVFEehsDSiu3VY9OunaUFIHW2Lm6o
         XsAwYyWMkLOGQ==
From:   Christian Brauner <brauner@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Christian Brauner <christian.brauner@ubuntu.com>,
        stable@vger.kernel.org
Subject: [PATCH 01/12] fs: add is_idmapped_mnt() helper
Date:   Tue, 28 Jun 2022 14:16:09 +0200
Message-Id: <20220628121620.188722-2-brauner@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220628102244.wymkrob3cfys2h7i@wittgenstein>
References: <20220628121620.188722-1-brauner@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5017; i=brauner@kernel.org; h=from:subject; bh=UpvC0Eoox50eYv9QvSnv55I9jTyv69RoGlJ2QEa3vDQ=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSTt+sibdO6S9drm1gOLt9d21S3c8uyg5EMbC06Nzo/XH1fs iv8p0lHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCRXbmMDK8W3XB68XH9IwlTNfeg1h 3pvEeXTA9+OuXMiuK9u3P7999kZGhuv27OU1EjfPn1ri0nHVv2f/vzebHss00xLRtY1NOiHrEDAA==
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

commit bb49e9e730c2906a958eee273a7819f401543d6c upstream.

Multiple places open-code the same check to determine whether a given
mount is idmapped. Introduce a simple helper function that can be used
instead. This allows us to get rid of the fragile open-coding. We will
later change the check that is used to determine whether a given mount
is idmapped. Introducing a helper allows us to do this in a single
place instead of doing it for multiple places.

Link: https://lore.kernel.org/r/20211123114227.3124056-2-brauner@kernel.org (v1)
Link: https://lore.kernel.org/r/20211130121032.3753852-2-brauner@kernel.org (v2)
Link: https://lore.kernel.org/r/20211203111707.3901969-2-brauner@kernel.org
Cc: Seth Forshee <sforshee@digitalocean.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
CC: linux-fsdevel@vger.kernel.org
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Seth Forshee <sforshee@digitalocean.com>
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
---
 fs/cachefiles/bind.c |  2 +-
 fs/ecryptfs/main.c   |  2 +-
 fs/namespace.c       |  2 +-
 fs/nfsd/export.c     |  2 +-
 fs/overlayfs/super.c |  2 +-
 fs/proc_namespace.c  |  2 +-
 include/linux/fs.h   | 14 ++++++++++++++
 7 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/fs/cachefiles/bind.c b/fs/cachefiles/bind.c
index d463d89f5db8..146291be6263 100644
--- a/fs/cachefiles/bind.c
+++ b/fs/cachefiles/bind.c
@@ -117,7 +117,7 @@ static int cachefiles_daemon_add_cache(struct cachefiles_cache *cache)
 	root = path.dentry;
 
 	ret = -EINVAL;
-	if (mnt_user_ns(path.mnt) != &init_user_ns) {
+	if (is_idmapped_mnt(path.mnt)) {
 		pr_warn("File cache on idmapped mounts not supported");
 		goto error_unsupported;
 	}
diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index d66bbd2df191..2dd23a82e0de 100644
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -537,7 +537,7 @@ static struct dentry *ecryptfs_mount(struct file_system_type *fs_type, int flags
 		goto out_free;
 	}
 
-	if (mnt_user_ns(path.mnt) != &init_user_ns) {
+	if (is_idmapped_mnt(path.mnt)) {
 		rc = -EINVAL;
 		printk(KERN_ERR "Mounting on idmapped mounts currently disallowed\n");
 		goto out_free;
diff --git a/fs/namespace.c b/fs/namespace.c
index b696543adab8..5b5aa107b9f3 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -3936,7 +3936,7 @@ static int can_idmap_mount(const struct mount_kattr *kattr, struct mount *mnt)
 	 * mapping. It makes things simpler and callers can just create
 	 * another bind-mount they can idmap if they want to.
 	 */
-	if (mnt_user_ns(m) != &init_user_ns)
+	if (is_idmapped_mnt(m))
 		return -EPERM;
 
 	/* The underlying filesystem doesn't support idmapped mounts yet. */
diff --git a/fs/nfsd/export.c b/fs/nfsd/export.c
index 9421dae22737..668c7527b17e 100644
--- a/fs/nfsd/export.c
+++ b/fs/nfsd/export.c
@@ -427,7 +427,7 @@ static int check_export(struct path *path, int *flags, unsigned char *uuid)
 		return -EINVAL;
 	}
 
-	if (mnt_user_ns(path->mnt) != &init_user_ns) {
+	if (is_idmapped_mnt(path->mnt)) {
 		dprintk("exp_export: export of idmapped mounts not yet supported.\n");
 		return -EINVAL;
 	}
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 265181c110ae..7bb0a47cb615 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -873,7 +873,7 @@ static int ovl_mount_dir_noesc(const char *name, struct path *path)
 		pr_err("filesystem on '%s' not supported\n", name);
 		goto out_put;
 	}
-	if (mnt_user_ns(path->mnt) != &init_user_ns) {
+	if (is_idmapped_mnt(path->mnt)) {
 		pr_err("idmapped layers are currently not supported\n");
 		goto out_put;
 	}
diff --git a/fs/proc_namespace.c b/fs/proc_namespace.c
index 392ef5162655..49650e54d2f8 100644
--- a/fs/proc_namespace.c
+++ b/fs/proc_namespace.c
@@ -80,7 +80,7 @@ static void show_mnt_opts(struct seq_file *m, struct vfsmount *mnt)
 			seq_puts(m, fs_infop->str);
 	}
 
-	if (mnt_user_ns(mnt) != &init_user_ns)
+	if (is_idmapped_mnt(mnt))
 		seq_puts(m, ",idmapped");
 }
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 56eba723477e..5720473b94b1 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2726,6 +2726,20 @@ static inline struct user_namespace *file_mnt_user_ns(struct file *file)
 {
 	return mnt_user_ns(file->f_path.mnt);
 }
+
+/**
+ * is_idmapped_mnt - check whether a mount is mapped
+ * @mnt: the mount to check
+ *
+ * If @mnt has an idmapping attached to it @mnt is mapped.
+ *
+ * Return: true if mount is mapped, false if not.
+ */
+static inline bool is_idmapped_mnt(const struct vfsmount *mnt)
+{
+	return mnt_user_ns(mnt) != &init_user_ns;
+}
+
 extern long vfs_truncate(const struct path *, loff_t);
 int do_truncate(struct user_namespace *, struct dentry *, loff_t start,
 		unsigned int time_attrs, struct file *filp);
-- 
2.34.1

