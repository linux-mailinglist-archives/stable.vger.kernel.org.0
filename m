Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA541353EA9
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:34:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238254AbhDEJHU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:07:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:51420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238161AbhDEJHH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:07:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CED1613A5;
        Mon,  5 Apr 2021 09:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613621;
        bh=sv2npbch/fm+Qb1D2o9pjkfxFI9GqFDf7UDnay+PbO4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y8GBkRZXERKZQ9GqwEFTKYM8KUq2U4T1VoBsuaVkL8DJBO4IKDgdMG4wZ7PTHZGkE
         1FCnBYGk5doHh+9Y5raqCf5gR3itSek8pxVM03JfQcxHi3MiztgowD48/62MB5Q8ez
         RJgmlK2P3BX/aY/sWyyGk6C2a/P+G1qMiXERUZ84=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 003/126] virtiofs: Fail dax mount if device does not support it
Date:   Mon,  5 Apr 2021 10:52:45 +0200
Message-Id: <20210405085031.160465045@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085031.040238881@linuxfoundation.org>
References: <20210405085031.040238881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vivek Goyal <vgoyal@redhat.com>

[ Upstream commit 3f9b9efd82a84f27e95d0414f852caf1fa839e83 ]

Right now "mount -t virtiofs -o dax myfs /mnt/virtiofs" succeeds even
if filesystem deivce does not have a cache window and hence DAX can't
be supported.

This gives a false sense to user that they are using DAX with virtiofs
but fact of the matter is that they are not.

Fix this by returning error if dax can't be supported and user has asked
for it.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/virtio_fs.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index d2c0e58c6416..3d83c9e12848 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -1324,8 +1324,15 @@ static int virtio_fs_fill_super(struct super_block *sb, struct fs_context *fsc)
 
 	/* virtiofs allocates and installs its own fuse devices */
 	ctx->fudptr = NULL;
-	if (ctx->dax)
+	if (ctx->dax) {
+		if (!fs->dax_dev) {
+			err = -EINVAL;
+			pr_err("virtio-fs: dax can't be enabled as filesystem"
+			       " device does not support it.\n");
+			goto err_free_fuse_devs;
+		}
 		ctx->dax_dev = fs->dax_dev;
+	}
 	err = fuse_fill_super_common(sb, ctx);
 	if (err < 0)
 		goto err_free_fuse_devs;
-- 
2.30.1



