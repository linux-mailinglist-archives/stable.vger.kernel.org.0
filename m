Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6A9A3C4800
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236966AbhGLGfj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:35:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:54296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237787AbhGLGew (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:34:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 06498610CC;
        Mon, 12 Jul 2021 06:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071494;
        bh=8wEe6pPYayhsMqChzZqG9CLsksACtKrtM/ZsWywEUz0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r1qFFTCywpKbD/LlsUw7hfXGKJlWT5/KSWMhmdPrXsDnbgTxUeHnJ/GROxJsCQ6z+
         ZXs1g1qKN9eAd+rGgZirx0G0aTj5bXxflDNP1faCVqTSJ8pdr19N11hx0U9lYp2yzt
         WJLhsLkTRoDO6tdHMSFEzWc506a7Q4QG4p17qA5Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Greg Kurz <groug@kaod.org>,
        Max Reitz <mreitz@redhat.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.10 093/593] fuse: Fix crash in fuse_dentry_automount() error path
Date:   Mon, 12 Jul 2021 08:04:13 +0200
Message-Id: <20210712060853.436592806@linuxfoundation.org>
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

commit d92d88f0568e97c437eeb79d9c9609bd8277406f upstream.

If fuse_fill_super_submount() returns an error, the error path
triggers a crash:

[   26.206673] BUG: kernel NULL pointer dereference, address: 0000000000000000
[...]
[   26.226362] RIP: 0010:__list_del_entry_valid+0x25/0x90
[...]
[   26.247938] Call Trace:
[   26.248300]  fuse_mount_remove+0x2c/0x70 [fuse]
[   26.248892]  virtio_kill_sb+0x22/0x160 [virtiofs]
[   26.249487]  deactivate_locked_super+0x36/0xa0
[   26.250077]  fuse_dentry_automount+0x178/0x1a0 [fuse]

The crash happens because fuse_mount_remove() assumes that the FUSE
mount was already added to list under the FUSE connection, but this
only done after fuse_fill_super_submount() has returned success.

This means that until fuse_fill_super_submount() has returned success,
the FUSE mount isn't actually owned by the superblock. We should thus
reclaim ownership by clearing sb->s_fs_info, which will skip the call
to fuse_mount_remove(), and perform rollback, like virtio_fs_get_tree()
already does for the root sb.

Fixes: bf109c64040f ("fuse: implement crossmounts")
Cc: stable@vger.kernel.org # v5.10+
Signed-off-by: Greg Kurz <groug@kaod.org>
Reviewed-by: Max Reitz <mreitz@redhat.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/fuse/dir.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -340,8 +340,12 @@ static struct vfsmount *fuse_dentry_auto
 
 	/* Initialize superblock, making @mp_fi its root */
 	err = fuse_fill_super_submount(sb, mp_fi);
-	if (err)
+	if (err) {
+		fuse_conn_put(fc);
+		kfree(fm);
+		sb->s_fs_info = NULL;
 		goto out_put_sb;
+	}
 
 	sb->s_flags |= SB_ACTIVE;
 	fsc->root = dget(sb->s_root);


