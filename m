Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E628239BCB6
	for <lists+stable@lfdr.de>; Fri,  4 Jun 2021 18:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231229AbhFDQOF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 4 Jun 2021 12:14:05 -0400
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:54551 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231285AbhFDQOE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Jun 2021 12:14:04 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-570-R4Pyq-bqMRaU5LPdJd6bOA-1; Fri, 04 Jun 2021 12:12:16 -0400
X-MC-Unique: R4Pyq-bqMRaU5LPdJd6bOA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6AA31180FD6E;
        Fri,  4 Jun 2021 16:12:15 +0000 (UTC)
Received: from bahia.lan (ovpn-112-232.ams2.redhat.com [10.36.112.232])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CA7F060D06;
        Fri,  4 Jun 2021 16:12:13 +0000 (UTC)
From:   Greg Kurz <groug@kaod.org>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     linux-kernel@vger.kernel.org, Max Reitz <mreitz@redhat.com>,
        linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com,
        Vivek Goyal <vgoyal@redhat.com>, Greg Kurz <groug@kaod.org>,
        stable@vger.kernel.org
Subject: [PATCH v2 3/7] fuse: Fix infinite loop in sget_fc()
Date:   Fri,  4 Jun 2021 18:11:52 +0200
Message-Id: <20210604161156.408496-4-groug@kaod.org>
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

We don't set the SB_BORN flag on submounts. This is wrong as these
superblocks are then considered as partially constructed or dying
in the rest of the code and can break some assumptions.

One such case is when you have a virtiofs filesystem with submounts
and you try to mount it again : virtio_fs_get_tree() tries to obtain
a superblock with sget_fc(). The logic in sget_fc() is to loop until
it has either found an existing matching superblock with SB_BORN set
or to create a brand new one. It is assumed that a superblock without
SB_BORN is transient and the loop is restarted. Forgetting to set
SB_BORN on submounts hence causes sget_fc() to retry forever.

Setting SB_BORN requires special care, i.e. a write barrier for
super_cache_count() which can check SB_BORN without taking any lock.
We should call vfs_get_tree() to deal with that but this requires
to have a proper ->get_tree() implementation for submounts, which
is a bigger piece of work. Go for a simple bug fix in the meatime.

Fixes: bf109c64040f ("fuse: implement crossmounts")
Cc: mreitz@redhat.com
Cc: stable@vger.kernel.org # v5.10+
Signed-off-by: Greg Kurz <groug@kaod.org>
---
 fs/fuse/dir.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 3fd1b71e546b..3fa8604c21d5 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -352,6 +352,17 @@ static struct vfsmount *fuse_dentry_automount(struct path *path)
 
 	sb->s_flags |= SB_ACTIVE;
 	fsc->root = dget(sb->s_root);
+
+	/*
+	 * FIXME: setting SB_BORN requires a write barrier for
+	 *        super_cache_count(). We should actually come
+	 *        up with a proper ->get_tree() implementation
+	 *        for submounts and call vfs_get_tree() to take
+	 *        care of the write barrier.
+	 */
+	smp_wmb();
+	sb->s_flags |= SB_BORN;
+
 	/* We are done configuring the superblock, so unlock it */
 	up_write(&sb->s_umount);
 
-- 
2.31.1

