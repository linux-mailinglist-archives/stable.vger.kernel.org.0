Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4053C47FE
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236923AbhGLGfg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:35:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:55054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237805AbhGLGex (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:34:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0877610F7;
        Mon, 12 Jul 2021 06:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071499;
        bh=UuLPKepBpPFqNqTZWn8KjjNrCtSL8QWA/rx9s6gkB7I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vHbgk0VlrtBsC/Ntszx5EaLyYnom11V28MUqZjWjenm0q3F1h41Xq8lzeIZgUsmCA
         KC2v65TQ3obqwIttUVwusBldIYl2fcA8mryvNfvGbzrxoCV2S37GOUpXehA2l3gJMP
         TBHS7AcCLrSwKDQ2fo82+hD5WxmGCZzQvZpLaJdk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Greg Kurz <groug@kaod.org>,
        Max Reitz <mreitz@redhat.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.10 095/593] fuse: Fix infinite loop in sget_fc()
Date:   Mon, 12 Jul 2021 08:04:15 +0200
Message-Id: <20210712060853.662098246@linuxfoundation.org>
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

commit e4a9ccdd1c03b3dc58214874399d24331ea0a3ab upstream.

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
Cc: stable@vger.kernel.org # v5.10+
Signed-off-by: Greg Kurz <groug@kaod.org>
Reviewed-by: Max Reitz <mreitz@redhat.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/fuse/dir.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -353,6 +353,17 @@ static struct vfsmount *fuse_dentry_auto
 
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
 


