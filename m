Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B765B3EB7EE
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 17:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241197AbhHMPKG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 11:10:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:51406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241292AbhHMPJI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 11:09:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 44B596109D;
        Fri, 13 Aug 2021 15:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628867321;
        bh=cZF+gyiBCJw0XZHtF3PVJAZBdgXcVwz2oOH2/y3iHqE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FoDN4dpEmjgJ/ltrxigDThcgUnERgmj4KyP98gkMkjCUBiIK3eGu5bXkCGzzIXAgs
         9j6aZReS6A5xs3eJb8XeMTYINyt2qeC5hMQrg0qlWZFf9ibulE25XTwf6uOILHYQ7b
         xk6XlAcnET9NfW6mKnyt/5Vl/aYSansVL5P4C//0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alois Wohlschlager <alois1@gmx-topmail.de>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 4.4 25/25] ovl: prevent private clone if bind mount is not allowed
Date:   Fri, 13 Aug 2021 17:06:49 +0200
Message-Id: <20210813150521.531089718@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210813150520.718161915@linuxfoundation.org>
References: <20210813150520.718161915@linuxfoundation.org>
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
@@ -1830,6 +1830,20 @@ void drop_collected_mounts(struct vfsmou
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
@@ -1844,16 +1858,27 @@ struct vfsmount *clone_private_mount(str
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
 
@@ -2169,19 +2194,6 @@ static int do_change_type(struct path *p
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


