Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA393EB313
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 11:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239872AbhHMJCm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 05:02:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:58804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239704AbhHMJCl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 05:02:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C43E6024A;
        Fri, 13 Aug 2021 09:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628845335;
        bh=0dGuW6J2+6AL1hyHdffBucegBJdW5Wzjuhgjm3LCh8k=;
        h=Subject:To:Cc:From:Date:From;
        b=nbC1bRuYEQYlZyVy26W6EQSVbEUEhoSHvjB3I92qMgX00O9Pud5GxcXxBjTly9DPk
         mGDnK+k+dBwcaTjGU6ASKJSqZ723g46SCMVlH29bmNv0ChLfCPsBvNo3yi3GMHIHsM
         GZ754mqkYQ8cnw/X1wTp56kGJ+zDjxy9gppKHYlI=
Subject: FAILED: patch "[PATCH] ovl: prevent private clone if bind mount is not allowed" failed to apply to 4.9-stable tree
To:     mszeredi@redhat.com, alois1@gmx-topmail.de, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 13 Aug 2021 11:02:05 +0200
Message-ID: <1628845325236177@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 427215d85e8d1476da1a86b8d67aceb485eb3631 Mon Sep 17 00:00:00 2001
From: Miklos Szeredi <mszeredi@redhat.com>
Date: Mon, 9 Aug 2021 10:19:47 +0200
Subject: [PATCH] ovl: prevent private clone if bind mount is not allowed

Add the following checks from __do_loopback() to clone_private_mount() as
well:

 - verify that the mount is in the current namespace

 - verify that there are no locked children

Reported-by: Alois Wohlschlager <alois1@gmx-topmail.de>
Fixes: c771d683a62e ("vfs: introduce clone_private_mount()")
Cc: <stable@vger.kernel.org> # v3.18
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>

diff --git a/fs/namespace.c b/fs/namespace.c
index ab4174a3c802..f79d9471cb76 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1938,6 +1938,20 @@ void drop_collected_mounts(struct vfsmount *mnt)
 	namespace_unlock();
 }
 
+static bool has_locked_children(struct mount *mnt, struct dentry *dentry)
+{
+	struct mount *child;
+
+	list_for_each_entry(child, &mnt->mnt_mounts, mnt_child) {
+		if (!is_subdir(child->mnt_mountpoint, dentry))
+			continue;
+
+		if (child->mnt.mnt_flags & MNT_LOCKED)
+			return true;
+	}
+	return false;
+}
+
 /**
  * clone_private_mount - create a private clone of a path
  * @path: path to clone
@@ -1953,10 +1967,19 @@ struct vfsmount *clone_private_mount(const struct path *path)
 	struct mount *old_mnt = real_mount(path->mnt);
 	struct mount *new_mnt;
 
+	down_read(&namespace_sem);
 	if (IS_MNT_UNBINDABLE(old_mnt))
-		return ERR_PTR(-EINVAL);
+		goto invalid;
+
+	if (!check_mnt(old_mnt))
+		goto invalid;
+
+	if (has_locked_children(old_mnt, path->dentry))
+		goto invalid;
 
 	new_mnt = clone_mnt(old_mnt, path->dentry, CL_PRIVATE);
+	up_read(&namespace_sem);
+
 	if (IS_ERR(new_mnt))
 		return ERR_CAST(new_mnt);
 
@@ -1964,6 +1987,10 @@ struct vfsmount *clone_private_mount(const struct path *path)
 	new_mnt->mnt_ns = MNT_NS_INTERNAL;
 
 	return &new_mnt->mnt;
+
+invalid:
+	up_read(&namespace_sem);
+	return ERR_PTR(-EINVAL);
 }
 EXPORT_SYMBOL_GPL(clone_private_mount);
 
@@ -2315,19 +2342,6 @@ static int do_change_type(struct path *path, int ms_flags)
 	return err;
 }
 
-static bool has_locked_children(struct mount *mnt, struct dentry *dentry)
-{
-	struct mount *child;
-	list_for_each_entry(child, &mnt->mnt_mounts, mnt_child) {
-		if (!is_subdir(child->mnt_mountpoint, dentry))
-			continue;
-
-		if (child->mnt.mnt_flags & MNT_LOCKED)
-			return true;
-	}
-	return false;
-}
-
 static struct mount *__do_loopback(struct path *old_path, int recurse)
 {
 	struct mount *mnt = ERR_PTR(-EINVAL), *old = real_mount(old_path->mnt);

