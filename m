Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6415939BCB2
	for <lists+stable@lfdr.de>; Fri,  4 Jun 2021 18:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbhFDQOC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 4 Jun 2021 12:14:02 -0400
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:49006 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229822AbhFDQOB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Jun 2021 12:14:01 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-441-qyATIiLGPKW1OSiO_cFJ0g-1; Fri, 04 Jun 2021 12:12:13 -0400
X-MC-Unique: qyATIiLGPKW1OSiO_cFJ0g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C26C5802938;
        Fri,  4 Jun 2021 16:12:11 +0000 (UTC)
Received: from bahia.lan (ovpn-112-232.ams2.redhat.com [10.36.112.232])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2F2F7687CE;
        Fri,  4 Jun 2021 16:12:09 +0000 (UTC)
From:   Greg Kurz <groug@kaod.org>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     linux-kernel@vger.kernel.org, Max Reitz <mreitz@redhat.com>,
        linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com,
        Vivek Goyal <vgoyal@redhat.com>, Greg Kurz <groug@kaod.org>,
        stable@vger.kernel.org
Subject: [PATCH v2 1/7] fuse: Fix crash in fuse_dentry_automount() error path
Date:   Fri,  4 Jun 2021 18:11:50 +0200
Message-Id: <20210604161156.408496-2-groug@kaod.org>
In-Reply-To: <20210604161156.408496-1-groug@kaod.org>
References: <20210604161156.408496-1-groug@kaod.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=groug@kaod.org
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
Reviewed-by: Max Reitz <mreitz@redhat.com>
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

