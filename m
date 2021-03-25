Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFCA4348EE7
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 12:26:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbhCYLZ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 07:25:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:33480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229592AbhCYLZC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 07:25:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0790861A23;
        Thu, 25 Mar 2021 11:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616671501;
        bh=Fzdx5aZ7zCEqKQPLAHn/8eKtaEqL4xhrG7HXdzrDLGw=;
        h=From:To:Cc:Subject:Date:From;
        b=finq/th1Qi3LP0Dg0D2ILCjo8cf9NS7hHpXq6EQXxT/FjDtU6mXiTTX5WACx3finu
         zxz0kOUCYkjhHEA3HGcboc+b14BQ+pNVjtJbyA8m5M53XFVfkADRD5I5HsalBMw6n0
         ufUCXq1JQCPGWr2jxjChGbojA7AlFEHe1cgOlZlp002Fmh8sWmG7UHO4+CyCdAlJfJ
         UgxfYgtTh2SXAQIfU5U92yRlDQHl3eYJ3uk2KMp6wqDKaff1l5sf3z1JzGgIrGbGlm
         6vK3hWkwuDHpwsCbEkWGGttvDdv/6UdvSHN7ArOR8tSkl0W2aEgv0KSujdOboZOTyJ
         CGgGMoGw4+htw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vivek Goyal <vgoyal@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        virtualization@lists.linux-foundation.org,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 01/44] virtiofs: Fail dax mount if device does not support it
Date:   Thu, 25 Mar 2021 07:24:16 -0400
Message-Id: <20210325112459.1926846-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 8868ac31a3c0..4ee6f734ba83 100644
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

