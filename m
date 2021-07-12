Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E95E3C47FF
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236056AbhGLGfh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:35:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:55158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237804AbhGLGex (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:34:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 50F5C610D1;
        Mon, 12 Jul 2021 06:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071496;
        bh=g39a+9144TT9EJR5P0Pu/0vGnFAWftgmV3cV/o7Hmro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2KUrWQI0HSf5ad6PilJcXCygn2F1iWyGigU5vRz4nVRIsJjcO1HasiyNZTdQavdYZ
         5yE5w5U7t815h/1AlofGxn6uYACg/UKa2MQP1qn7rk/vWIHj4u719fP1cMeesMmK6l
         BYCOzQG+iUgW0fdUQhqcbaXt9zCYwcQdCXr6UycM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Greg Kurz <groug@kaod.org>,
        Max Reitz <mreitz@redhat.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.10 094/593] fuse: Fix crash if superblock of submount gets killed early
Date:   Mon, 12 Jul 2021 08:04:14 +0200
Message-Id: <20210712060853.549495636@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kurz <groug@kaod.org>

commit e3a43f2a95393000778f8f302d48795add2fc4a8 upstream.

As soon as fuse_dentry_automount() does up_write(&sb->s_umount), the
superblock can theoretically be killed. If this happens before the
submount was added to the &fc->mounts list, fuse_mount_remove() later
crashes in list_del_init() because it assumes the submount to be
already there.

Add the submount before dropping sb->s_umount to fix the inconsistency.
It is okay to nest fc->killsb under sb->s_umount, we already do this
on the ->kill_sb() path.

Signed-off-by: Greg Kurz <groug@kaod.org>
Fixes: bf109c64040f ("fuse: implement crossmounts")
Cc: stable@vger.kernel.org # v5.10+
Reviewed-by: Max Reitz <mreitz@redhat.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/fuse/dir.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -347,15 +347,15 @@ static struct vfsmount *fuse_dentry_auto
 		goto out_put_sb;
 	}
 
+	down_write(&fc->killsb);
+	list_add_tail(&fm->fc_entry, &fc->mounts);
+	up_write(&fc->killsb);
+
 	sb->s_flags |= SB_ACTIVE;
 	fsc->root = dget(sb->s_root);
 	/* We are done configuring the superblock, so unlock it */
 	up_write(&sb->s_umount);
 
-	down_write(&fc->killsb);
-	list_add_tail(&fm->fc_entry, &fc->mounts);
-	up_write(&fc->killsb);
-
 	/* Create the submount */
 	mnt = vfs_create_mount(fsc);
 	if (IS_ERR(mnt)) {


