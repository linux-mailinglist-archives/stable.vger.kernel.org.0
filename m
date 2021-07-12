Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C56B13C5207
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349713AbhGLHoc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:44:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:46250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345921AbhGLHjM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:39:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7E4A6128E;
        Mon, 12 Jul 2021 07:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075248;
        bh=lXM3YdMo6ySLHDWcdqaZIO3/XtPQ7RMfO721EgtjdrM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ik7E7GNaIE4QtIyMvHt5HVeQ50Lz+Gly3AD+uKTGvme1r6TCXmbXWUcEwJ56kva0x
         +r8K2NVrS7+yNSqa+K29tUm8HC+48W5ag/uyWn6Z76PX02QiJ+nsXTcFczIsk2FyG0
         5q6UEYRmkMMvWI7nYB4oeOpfhdGwQGd3mH2cDQjM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Greg Kurz <groug@kaod.org>,
        Max Reitz <mreitz@redhat.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.13 121/800] fuse: Fix crash if superblock of submount gets killed early
Date:   Mon, 12 Jul 2021 08:02:24 +0200
Message-Id: <20210712060929.973484401@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
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
@@ -346,15 +346,15 @@ static struct vfsmount *fuse_dentry_auto
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


