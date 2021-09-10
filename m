Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBD1E4062CF
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242052AbhIJAqN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:46:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:47940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233964AbhIJAWN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:22:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B385D610E9;
        Fri, 10 Sep 2021 00:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233263;
        bh=9hbZSs7CGi5rrgcREuH1wow82wBAcaBkn6tOl9HQ2co=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a6btt/U2YdV0Pine77e0ulcyVJySUGtFLm9Z/hcF1O45cPeJ/tDH4GSxY5MUQXHZ2
         g78t85f7+Ef2DP5lufdbRH3woFK2nMx7jl3lO3au3Nv7QIlTzm9vfLRJsSEOgdlkhC
         rdx2ibZwm+53K1dtNTt859ZAJPFqS0XY1bYc7FzuwXiUjpUdESWZhhYFCBPQ/zILOw
         e2brDfUcrTB9t0drp9QeCRN3mWW232x4FUpYBrzXPKVF2xYTRyh0ArcSjm8+NfOxAK
         dbfggC3YZo1nz973ivF2QgbR77iD3nxtuIp4xu1K4tKkz8FUo5Qg3dxb7URqIMTDtL
         PEnnH+UrP0WAA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chengguang Xu <cgxu519@mykernel.net>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-unionfs@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 25/53] ovl: skip checking lower file's i_writecount on truncate
Date:   Thu,  9 Sep 2021 20:20:00 -0400
Message-Id: <20210910002028.175174-25-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910002028.175174-1-sashal@kernel.org>
References: <20210910002028.175174-1-sashal@kernel.org>
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
 Documentation/filesystems/overlayfs.rst | 3 +++
 fs/overlayfs/inode.c                    | 6 ------
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
index 137afeb3f581..7c40a135a919 100644
--- a/Documentation/filesystems/overlayfs.rst
+++ b/Documentation/filesystems/overlayfs.rst
@@ -427,6 +427,9 @@ b) If a file residing on a lower layer is opened for read-only and then
 memory mapped with MAP_SHARED, then subsequent changes to the file are not
 reflected in the memory mapping.
 
+c) If a file residing on a lower layer is being executed, then opening that
+file for write or truncating the file will not be denied with ETXTBSY.
+
 The following options allow overlayfs to act more like a standards
 compliant filesystem:
 
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 4fadafd8bdc1..6ee183e523c5 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -30,12 +30,6 @@ int ovl_setattr(struct dentry *dentry, struct iattr *attr)
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

