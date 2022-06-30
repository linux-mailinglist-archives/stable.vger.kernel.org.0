Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACFE0561CFC
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 16:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236658AbiF3OIi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 10:08:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236897AbiF3OHq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 10:07:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D522C48806;
        Thu, 30 Jun 2022 06:54:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9273E61FDB;
        Thu, 30 Jun 2022 13:54:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A1EAC34115;
        Thu, 30 Jun 2022 13:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656597279;
        bh=xiRTtprmP5An0sA7v5N9LMYPbpjDmy0F5HtTfS2RoTk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wRkJJp0EyG8+dafqt1Dcj21g7LGBPZOwFQDVXx/WZuWqT9c/iyX4mC0+qY7nLOVUd
         sj44dNU8YhBBhO/knu83EJ3Ivt12jf5Aq61cTHkj8jjlb23BZmIBDtp5HuhuPQlW7e
         wXNb/8/tw0iwooEw1u1F2KR3Gnixm/29XlJ4DSsQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Seth Forshee <sforshee@digitalocean.com>,
        Christoph Hellwig <hch@lst.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        "Christian Brauner (Microsoft)" <brauner@kernel.org>
Subject: [PATCH 5.15 13/28] fs: add is_idmapped_mnt() helper
Date:   Thu, 30 Jun 2022 15:47:09 +0200
Message-Id: <20220630133233.318154508@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cachefiles/bind.c |    2 +-
 fs/ecryptfs/main.c   |    2 +-
 fs/namespace.c       |    2 +-
 fs/nfsd/export.c     |    2 +-
 fs/overlayfs/super.c |    2 +-
 fs/proc_namespace.c  |    2 +-
 include/linux/fs.h   |   14 ++++++++++++++
 7 files changed, 20 insertions(+), 6 deletions(-)

--- a/fs/cachefiles/bind.c
+++ b/fs/cachefiles/bind.c
@@ -117,7 +117,7 @@ static int cachefiles_daemon_add_cache(s
 	root = path.dentry;
 
 	ret = -EINVAL;
-	if (mnt_user_ns(path.mnt) != &init_user_ns) {
+	if (is_idmapped_mnt(path.mnt)) {
 		pr_warn("File cache on idmapped mounts not supported");
 		goto error_unsupported;
 	}
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -537,7 +537,7 @@ static struct dentry *ecryptfs_mount(str
 		goto out_free;
 	}
 
-	if (mnt_user_ns(path.mnt) != &init_user_ns) {
+	if (is_idmapped_mnt(path.mnt)) {
 		rc = -EINVAL;
 		printk(KERN_ERR "Mounting on idmapped mounts currently disallowed\n");
 		goto out_free;
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -3936,7 +3936,7 @@ static int can_idmap_mount(const struct
 	 * mapping. It makes things simpler and callers can just create
 	 * another bind-mount they can idmap if they want to.
 	 */
-	if (mnt_user_ns(m) != &init_user_ns)
+	if (is_idmapped_mnt(m))
 		return -EPERM;
 
 	/* The underlying filesystem doesn't support idmapped mounts yet. */
--- a/fs/nfsd/export.c
+++ b/fs/nfsd/export.c
@@ -427,7 +427,7 @@ static int check_export(struct path *pat
 		return -EINVAL;
 	}
 
-	if (mnt_user_ns(path->mnt) != &init_user_ns) {
+	if (is_idmapped_mnt(path->mnt)) {
 		dprintk("exp_export: export of idmapped mounts not yet supported.\n");
 		return -EINVAL;
 	}
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -873,7 +873,7 @@ static int ovl_mount_dir_noesc(const cha
 		pr_err("filesystem on '%s' not supported\n", name);
 		goto out_put;
 	}
-	if (mnt_user_ns(path->mnt) != &init_user_ns) {
+	if (is_idmapped_mnt(path->mnt)) {
 		pr_err("idmapped layers are currently not supported\n");
 		goto out_put;
 	}
--- a/fs/proc_namespace.c
+++ b/fs/proc_namespace.c
@@ -80,7 +80,7 @@ static void show_mnt_opts(struct seq_fil
 			seq_puts(m, fs_infop->str);
 	}
 
-	if (mnt_user_ns(mnt) != &init_user_ns)
+	if (is_idmapped_mnt(mnt))
 		seq_puts(m, ",idmapped");
 }
 
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2726,6 +2726,20 @@ static inline struct user_namespace *fil
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


