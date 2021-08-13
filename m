Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8B483EB878
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 17:25:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242308AbhHMPN6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 11:13:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:55900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241860AbhHMPMx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 11:12:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 48E63610FE;
        Fri, 13 Aug 2021 15:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628867544;
        bh=YvIkjBL6Zh0AWo5blp1uoE4eCTU1LziVttB1wuT+OxA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ArOspDWSUSP6Ou1hxcGOZpBefDonZWToDLYMfcIhzAnGFGXgW5Nrqa6rcyi8MlauC
         cPMTOj2VpbbY28VSz+rtfQ/+ksu20P8MJlUiQmTv0ebNXPDsnu0ZaxUd8+Z/x/Sd3V
         4isOdMT0RFr2Yu39pp69W2yVgadjQFjTgRKC+n+4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alois Wohlschlager <alois1@gmx-topmail.de>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 4.19 10/11] ovl: prevent private clone if bind mount is not allowed
Date:   Fri, 13 Aug 2021 17:07:17 +0200
Message-Id: <20210813150520.398690597@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210813150520.072304554@linuxfoundation.org>
References: <20210813150520.072304554@linuxfoundation.org>
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
@@ -1799,6 +1799,20 @@ void drop_collected_mounts(struct vfsmou
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
@@ -1813,14 +1827,27 @@ struct vfsmount *clone_private_mount(con
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
 
 	return &new_mnt->mnt;
+
+invalid:
+	up_read(&namespace_sem);
+	return ERR_PTR(-EINVAL);
 }
 EXPORT_SYMBOL_GPL(clone_private_mount);
 
@@ -2136,19 +2163,6 @@ static int do_change_type(struct path *p
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


