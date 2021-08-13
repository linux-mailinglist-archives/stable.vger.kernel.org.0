Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A81F83EB8D1
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 17:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241154AbhHMPQ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 11:16:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:56440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242127AbhHMPPI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 11:15:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C42B61139;
        Fri, 13 Aug 2021 15:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628867673;
        bh=pqPfENO0Zr3FJrZp4QR5X01+7v20jsFviacrXnDEjME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XJ0AKI3iWrXE9YHH8Z1XAVqTUR7FZlhIuLteIRmSSLHztzbHRx3EHydVvoKnRRQQe
         OhNv0/tKiUFINhxHUFXzhk7S79u7a7dhVoy3y171D9OuK6NAawNWGgOnigNDbRJ1o+
         Nv2Ek3MXgHh8ZVvFE7t3+c2uxUf3EcwVX3MGvjWs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alois Wohlschlager <alois1@gmx-topmail.de>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.10 18/19] ovl: prevent private clone if bind mount is not allowed
Date:   Fri, 13 Aug 2021 17:07:35 +0200
Message-Id: <20210813150523.220586263@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210813150522.623322501@linuxfoundation.org>
References: <20210813150522.623322501@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

commit 427215d85e8d1476da1a86b8d67aceb485eb3631 upstream.

Add the following checks from __do_loopback() to clone_private_mount() as
well:

 - verify that the mount is in the current namespace

 - verify that there are no locked children

Reported-by: Alois Wohlschlager <alois1@gmx-topmail.de>
Fixes: c771d683a62e ("vfs: introduce clone_private_mount()")
Cc: <stable@vger.kernel.org> # v3.18
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/namespace.c |   42 ++++++++++++++++++++++++++++--------------
 1 file changed, 28 insertions(+), 14 deletions(-)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1919,6 +1919,20 @@ void drop_collected_mounts(struct vfsmou
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
  *
@@ -1933,10 +1947,19 @@ struct vfsmount *clone_private_mount(con
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
 
@@ -1944,6 +1967,10 @@ struct vfsmount *clone_private_mount(con
 	new_mnt->mnt_ns = MNT_NS_INTERNAL;
 
 	return &new_mnt->mnt;
+
+invalid:
+	up_read(&namespace_sem);
+	return ERR_PTR(-EINVAL);
 }
 EXPORT_SYMBOL_GPL(clone_private_mount);
 
@@ -2295,19 +2322,6 @@ static int do_change_type(struct path *p
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


