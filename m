Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75EC839047D
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 17:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231891AbhEYPEV convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 25 May 2021 11:04:21 -0400
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:30138 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231890AbhEYPES (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 May 2021 11:04:18 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-390-TbeyHIyPO7ixY4ulWm630A-1; Tue, 25 May 2021 11:02:44 -0400
X-MC-Unique: TbeyHIyPO7ixY4ulWm630A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BEE8A801B15;
        Tue, 25 May 2021 15:02:42 +0000 (UTC)
Received: from bahia.lan (ovpn-113-46.ams2.redhat.com [10.36.113.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AC6695D723;
        Tue, 25 May 2021 15:02:37 +0000 (UTC)
From:   Greg Kurz <groug@kaod.org>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Vivek Goyal <vgoyal@redhat.com>, virtio-fs@redhat.com,
        Greg Kurz <groug@kaod.org>, mreitz@redhat.com,
        stable@vger.kernel.org
Subject: [PATCH 1/4] fuse: Fix crash in fuse_dentry_automount() error path
Date:   Tue, 25 May 2021 17:02:27 +0200
Message-Id: <20210525150230.157586-2-groug@kaod.org>
In-Reply-To: <20210525150230.157586-1-groug@kaod.org>
References: <20210525150230.157586-1-groug@kaod.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kaod.org
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Cc: mreitz@redhat.com
Cc: stable@vger.kernel.org # v5.10+
Signed-off-by: Greg Kurz <groug@kaod.org>
---
 fs/fuse/dir.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 1b6c001a7dd1..01559061cbfb 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -339,8 +339,12 @@ static struct vfsmount *fuse_dentry_automount(struct path *path)
 
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
-- 
2.31.1

