Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B41EB406339
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233554AbhIJArF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:47:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:48778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234387AbhIJAXQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:23:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDDE960FC0;
        Fri, 10 Sep 2021 00:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233326;
        bh=6DvBScFx4vP3kesSnhRnFcB0+Ya19xx+IsfFPVT/zUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e5X7AmbDnT2dEABoHiaSisUW+eYPIcF1gFXjOMUZPHaVJEKhw89tvZp+CbsimIfZP
         288mi1eMf8Rl6Rmc8vOMokA1TRmzy3Bh5Csf0ysUf/TNGjjAmauCOy3i64oHycsHRD
         KpNYUzKhHPaB/RWPS2bfMrweSxRI3fUSLkfrRg+vGQu+L6Ci/bwU6rbUJPQGJf+5Mr
         da0HR0xgyD5JOzFGAsUtBIA+iIwAVTej0xo4qixIr+lLwkNExCCbIZj6iG8Arhf+qX
         FxHymfSoi+KV9lJNZcVs6OUwRfN5cO9zOjQaLjUGM5fuVIKTf+gBq0fGktW34WYG0r
         NVhybj4e6Lq8g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chengguang Xu <cgxu519@mykernel.net>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-doc@vger.kernel.org,
        linux-unionfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 17/37] ovl: skip checking lower file's i_writecount on truncate
Date:   Thu,  9 Sep 2021 20:21:22 -0400
Message-Id: <20210910002143.175731-17-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910002143.175731-1-sashal@kernel.org>
References: <20210910002143.175731-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chengguang Xu <cgxu519@mykernel.net>

[ Upstream commit b71759ef1e1730db81dab98e9dab9455e8c7f5a2 ]

It is possible that a directory tree is shared between multiple overlay
instances as a lower layer.  In this case when one instance executes a file
residing on the lower layer, the other instance denies a truncate(2) call
on this file.

This only happens for truncate(2) and not for open(2) with the O_TRUNC
flag.

Fix this interference and inconsistency by removing the preliminary
i_writecount check before copy-up.

This means that unlike on normal filesystems truncate(argv[0]) will now
succeed.  If this ever causes a regression in a real world use case this
needs to be revisited.

One way to fix this properly would be to keep a correct i_writecount in the
overlay inode, but that is difficult due to memory mapping code only
dealing with the real file/inode.

Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/filesystems/overlayfs.txt | 3 +++
 fs/overlayfs/inode.c                    | 6 ------
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/Documentation/filesystems/overlayfs.txt b/Documentation/filesystems/overlayfs.txt
index 845d689e0fd7..69ffd8ebf3a8 100644
--- a/Documentation/filesystems/overlayfs.txt
+++ b/Documentation/filesystems/overlayfs.txt
@@ -348,6 +348,9 @@ b) If a file residing on a lower layer is opened for read-only and then
 memory mapped with MAP_SHARED, then subsequent changes to the file are not
 reflected in the memory mapping.
 
+c) If a file residing on a lower layer is being executed, then opening that
+file for write or truncating the file will not be denied with ETXTBSY.
+
 The following options allow overlayfs to act more like a standards
 compliant filesystem:
 
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 56b55397a7a0..0486fc925002 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -29,12 +29,6 @@ int ovl_setattr(struct dentry *dentry, struct iattr *attr)
 		goto out;
 
 	if (attr->ia_valid & ATTR_SIZE) {
-		struct inode *realinode = d_inode(ovl_dentry_real(dentry));
-
-		err = -ETXTBSY;
-		if (atomic_read(&realinode->i_writecount) < 0)
-			goto out_drop_write;
-
 		/* Truncate should trigger data copy up as well */
 		full_copy_up = true;
 	}
-- 
2.30.2

