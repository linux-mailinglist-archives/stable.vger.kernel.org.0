Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1E9488410
	for <lists+stable@lfdr.de>; Sat,  8 Jan 2022 15:44:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234479AbiAHOov (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Jan 2022 09:44:51 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:49454 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234477AbiAHOov (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Jan 2022 09:44:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 06CF3B8091D
        for <stable@vger.kernel.org>; Sat,  8 Jan 2022 14:44:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E6FAC36AE9;
        Sat,  8 Jan 2022 14:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641653088;
        bh=YarXPlpdGCo9Wrlbf1cq9T+hCjvbYXxi4y6xhDtPVco=;
        h=Subject:To:Cc:From:Date:From;
        b=WKrX0GLvNYUzWKOuiVr9J8ZnDntwqte0fCvYsUVcUgDEEZo0LHXDJZp4SbgS+WX7z
         9yg3wdpSXYRRdAR9QcJweU34q01RUJK9wK92NiRJEJ6aMFiVPTKYj+IkW7iNjMknGt
         2qICjmAgoKlSNFY4kEaS7Qng/PaqSvyHzAV56jpE=
Subject: FAILED: patch "[PATCH] cgroup: Use open-time cgroup namespace for process migration" failed to apply to 5.10-stable tree
To:     tj@kernel.org, ebiederm@xmission.com, mkoutny@suse.com,
        oleg@redhat.com, torvalds@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 08 Jan 2022 15:44:38 +0100
Message-ID: <1641653078213225@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e57457641613fef0d147ede8bd6a3047df588b95 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Thu, 6 Jan 2022 11:02:29 -1000
Subject: [PATCH] cgroup: Use open-time cgroup namespace for process migration
 perm checks
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

cgroup process migration permission checks are performed at write time as
whether a given operation is allowed or not is dependent on the content of
the write - the PID. This currently uses current's cgroup namespace which is
a potential security weakness as it may allow scenarios where a less
privileged process tricks a more privileged one into writing into a fd that
it created.

This patch makes cgroup remember the cgroup namespace at the time of open
and uses it for migration permission checks instad of current's. Note that
this only applies to cgroup2 as cgroup1 doesn't have namespace support.

This also fixes a use-after-free bug on cgroupns reported in

 https://lore.kernel.org/r/00000000000048c15c05d0083397@google.com

Note that backporting this fix also requires the preceding patch.

Reported-by: "Eric W. Biederman" <ebiederm@xmission.com>
Suggested-by: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Michal Koutný <mkoutny@suse.com>
Reported-by: syzbot+50f5cf33a284ce738b62@syzkaller.appspotmail.com
Link: https://lore.kernel.org/r/00000000000048c15c05d0083397@google.com
Fixes: 5136f6365ce3 ("cgroup: implement "nsdelegate" mount option")
Signed-off-by: Tejun Heo <tj@kernel.org>

diff --git a/kernel/cgroup/cgroup-internal.h b/kernel/cgroup/cgroup-internal.h
index cf637bc4ab45..6e36e854b512 100644
--- a/kernel/cgroup/cgroup-internal.h
+++ b/kernel/cgroup/cgroup-internal.h
@@ -68,6 +68,8 @@ static inline struct cgroup_fs_context *cgroup_fc2context(struct fs_context *fc)
 struct cgroup_pidlist;
 
 struct cgroup_file_ctx {
+	struct cgroup_namespace	*ns;
+
 	struct {
 		void			*trigger;
 	} psi;
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index a84631d08d98..cafb8c114a21 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -3822,14 +3822,19 @@ static int cgroup_file_open(struct kernfs_open_file *of)
 	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
 	if (!ctx)
 		return -ENOMEM;
+
+	ctx->ns = current->nsproxy->cgroup_ns;
+	get_cgroup_ns(ctx->ns);
 	of->priv = ctx;
 
 	if (!cft->open)
 		return 0;
 
 	ret = cft->open(of);
-	if (ret)
+	if (ret) {
+		put_cgroup_ns(ctx->ns);
 		kfree(ctx);
+	}
 	return ret;
 }
 
@@ -3840,13 +3845,14 @@ static void cgroup_file_release(struct kernfs_open_file *of)
 
 	if (cft->release)
 		cft->release(of);
+	put_cgroup_ns(ctx->ns);
 	kfree(ctx);
 }
 
 static ssize_t cgroup_file_write(struct kernfs_open_file *of, char *buf,
 				 size_t nbytes, loff_t off)
 {
-	struct cgroup_namespace *ns = current->nsproxy->cgroup_ns;
+	struct cgroup_file_ctx *ctx = of->priv;
 	struct cgroup *cgrp = of->kn->parent->priv;
 	struct cftype *cft = of_cft(of);
 	struct cgroup_subsys_state *css;
@@ -3863,7 +3869,7 @@ static ssize_t cgroup_file_write(struct kernfs_open_file *of, char *buf,
 	 */
 	if ((cgrp->root->flags & CGRP_ROOT_NS_DELEGATE) &&
 	    !(cft->flags & CFTYPE_NS_DELEGATABLE) &&
-	    ns != &init_cgroup_ns && ns->root_cset->dfl_cgrp == cgrp)
+	    ctx->ns != &init_cgroup_ns && ctx->ns->root_cset->dfl_cgrp == cgrp)
 		return -EPERM;
 
 	if (cft->write)
@@ -4853,9 +4859,9 @@ static int cgroup_may_write(const struct cgroup *cgrp, struct super_block *sb)
 
 static int cgroup_procs_write_permission(struct cgroup *src_cgrp,
 					 struct cgroup *dst_cgrp,
-					 struct super_block *sb)
+					 struct super_block *sb,
+					 struct cgroup_namespace *ns)
 {
-	struct cgroup_namespace *ns = current->nsproxy->cgroup_ns;
 	struct cgroup *com_cgrp = src_cgrp;
 	int ret;
 
@@ -4884,11 +4890,12 @@ static int cgroup_procs_write_permission(struct cgroup *src_cgrp,
 
 static int cgroup_attach_permissions(struct cgroup *src_cgrp,
 				     struct cgroup *dst_cgrp,
-				     struct super_block *sb, bool threadgroup)
+				     struct super_block *sb, bool threadgroup,
+				     struct cgroup_namespace *ns)
 {
 	int ret = 0;
 
-	ret = cgroup_procs_write_permission(src_cgrp, dst_cgrp, sb);
+	ret = cgroup_procs_write_permission(src_cgrp, dst_cgrp, sb, ns);
 	if (ret)
 		return ret;
 
@@ -4905,6 +4912,7 @@ static int cgroup_attach_permissions(struct cgroup *src_cgrp,
 static ssize_t __cgroup_procs_write(struct kernfs_open_file *of, char *buf,
 				    bool threadgroup)
 {
+	struct cgroup_file_ctx *ctx = of->priv;
 	struct cgroup *src_cgrp, *dst_cgrp;
 	struct task_struct *task;
 	const struct cred *saved_cred;
@@ -4932,7 +4940,8 @@ static ssize_t __cgroup_procs_write(struct kernfs_open_file *of, char *buf,
 	 */
 	saved_cred = override_creds(of->file->f_cred);
 	ret = cgroup_attach_permissions(src_cgrp, dst_cgrp,
-					of->file->f_path.dentry->d_sb, threadgroup);
+					of->file->f_path.dentry->d_sb,
+					threadgroup, ctx->ns);
 	revert_creds(saved_cred);
 	if (ret)
 		goto out_finish;
@@ -6152,7 +6161,8 @@ static int cgroup_css_set_fork(struct kernel_clone_args *kargs)
 		goto err;
 
 	ret = cgroup_attach_permissions(cset->dfl_cgrp, dst_cgrp, sb,
-					!(kargs->flags & CLONE_THREAD));
+					!(kargs->flags & CLONE_THREAD),
+					current->nsproxy->cgroup_ns);
 	if (ret)
 		goto err;
 

