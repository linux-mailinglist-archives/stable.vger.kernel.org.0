Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64E933C4BF2
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242904AbhGLHAy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:00:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:35158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239044AbhGLHAg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:00:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0822B60233;
        Mon, 12 Jul 2021 06:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073068;
        bh=or+btZn9+aTZ/4lEwHOGcgaG5cjaF5ouSCshgtB6UeU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IW1IAqemiQm00QTs84wLEqiaF8e6yVBQvI3e9/HzEBCcTN9fU6MZQmPaWAtLYFdoz
         Lzzmk9LSw8GQQ4hTg80fiQMjJ8PDCEdJLLZKcco4rdY78XCv8M5JfPACmV//6mMgDu
         FXUjoCTOncYqCeno8a1emThXkM9G9inqKeyiinx8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Greg Kurz <groug@kaod.org>,
        Max Reitz <mreitz@redhat.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.12 114/700] fuse: Fix infinite loop in sget_fc()
Date:   Mon, 12 Jul 2021 08:03:17 +0200
Message-Id: <20210712060941.019322442@linuxfoundation.org>
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
@@ -352,6 +352,17 @@ static struct vfsmount *fuse_dentry_auto
 
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
 


