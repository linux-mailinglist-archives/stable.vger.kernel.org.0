Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD54348F44
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 12:27:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231237AbhCYL0n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 07:26:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:34364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230455AbhCYL0J (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 07:26:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4001161A34;
        Thu, 25 Mar 2021 11:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616671561;
        bh=sv2npbch/fm+Qb1D2o9pjkfxFI9GqFDf7UDnay+PbO4=;
        h=From:To:Cc:Subject:Date:From;
        b=k/bw2jZj8ic8UN+O0UyW81xfPt0DYz5dJzawqVoWEoM/j0pD4NWZSK70lTPfDn3hM
         YGMiNxadMgtE0GXZ4Ibr+aF2tPYBuZoq2LvNQV6SB6HX8qGv6eKxMUmjsnu2wyyFeD
         UX9QazlDpMEmlB7eVmVUZTNuV5jNNSr+LIY0QsBSKL+VEuY7EKmtlG1whm4fBdFbd/
         yuOIqNTplNrwDchN0J8MgR8HFUFxNgUn+i4VA6R4d21e0ry4M69N82xKxmqyfGuqVP
         f7FC10WU6kMFdLzmjfFS/nDbj2KmlfMT4FzPTUnx5Bh5BLrwVuN5lx4+n1r6ApRrWk
         A/YuP7efZVPpg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vivek Goyal <vgoyal@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        virtualization@lists.linux-foundation.org,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 01/39] virtiofs: Fail dax mount if device does not support it
Date:   Thu, 25 Mar 2021 07:25:20 -0400
Message-Id: <20210325112558.1927423-1-sashal@kernel.org>
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

