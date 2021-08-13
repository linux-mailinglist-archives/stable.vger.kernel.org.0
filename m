Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22AA73EB823
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 17:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241658AbhHMPLb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 11:11:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:54318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241792AbhHMPKt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 11:10:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1CD46112F;
        Fri, 13 Aug 2021 15:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628867422;
        bh=IgfsaQrxgkElCILIIQRZoJKmG2nIIYocwH+heFZayf8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0LvpoEDVeSlEFb+VcecMSTHSD3obb09hvc17kmCCw+jucvVvQZ5M2JUa5i0wW2hia
         1YcIZJkgq7jdBDQFdo+exoZYbMM5LkUOsoYVAkqGttX7Ps+WvTaynKsf20Wab/jeZe
         7OjZ/OClisK8InSb6H2hejMCe2BrL7qRIQkzS9OA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alois Wohlschlager <alois1@gmx-topmail.de>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 4.9 30/30] ovl: prevent private clone if bind mount is not allowed
Date:   Fri, 13 Aug 2021 17:06:58 +0200
Message-Id: <20210813150523.424083989@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210813150522.445553924@linuxfoundation.org>
References: <20210813150522.445553924@linuxfoundation.org>
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
 fs/namespace.c |   42 +++++++++++++++++++++++++++---------------
 1 file changed, 27 insertions(+), 15 deletions(-)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1853,6 +1853,20 @@ void drop_collected_mounts(struct vfsmou
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
@@ -1867,16 +1881,27 @@ struct vfsmount *clone_private_mount(str
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
 
-	down_read(&namespace_sem);
 	new_mnt = clone_mnt(old_mnt, path->dentry, CL_PRIVATE);
 	up_read(&namespace_sem);
+
 	if (IS_ERR(new_mnt))
 		return ERR_CAST(new_mnt);
 
 	return &new_mnt->mnt;
+
+invalid:
+	up_read(&namespace_sem);
+	return ERR_PTR(-EINVAL);
 }
 EXPORT_SYMBOL_GPL(clone_private_mount);
 
@@ -2192,19 +2217,6 @@ static int do_change_type(struct path *p
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
 /*
  * do loopback mount.
  */


