Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 295983C4BED
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242496AbhGLHAv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:00:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:34892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242878AbhGLHAa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:00:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D25F6052B;
        Mon, 12 Jul 2021 06:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073062;
        bh=lXM3YdMo6ySLHDWcdqaZIO3/XtPQ7RMfO721EgtjdrM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B9vHsFX0wLQb7PtSkNFCsrgkRvKgda1ELcb+KP0WiyMNGTdEWV58ARJ+dNlVuDQ/O
         Gz3N6FMfE6wvK45dHc9KuLJPu6bzpBPH9943rD1nmHpczR1OKwqPTSwGcUOkKtwM7M
         KuaHp40w3fYjeLKhyjm7/6w650tS6p2A9q8raFDE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Greg Kurz <groug@kaod.org>,
        Max Reitz <mreitz@redhat.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.12 113/700] fuse: Fix crash if superblock of submount gets killed early
Date:   Mon, 12 Jul 2021 08:03:16 +0200
Message-Id: <20210712060940.856907966@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
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


