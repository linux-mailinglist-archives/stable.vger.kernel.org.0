Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB42313C61
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 19:07:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235427AbhBHSGF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 13:06:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:46560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235196AbhBHSCk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 13:02:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C208F64E8A;
        Mon,  8 Feb 2021 17:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612807147;
        bh=/WPAYCPcBpyTcmkwy/aSFnnUajeeQC5eHR35ZVtn90Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=frlLhK41E6dFtjWSw8hfspmBUK0Y0HisX4vOh721rwdWu8LO7oZ2+X/x7My3dU8Aa
         4NhfHROfad46gNhbQrFBFAKw5FA7/R6FFD0h3O4jVBV8lY4vRw4ziw4YlESMnS6kV9
         G9jFswNCTaETtbic7BquXqgNAIM/WEPKQCz5UyPIfgyzl+8AxOp5LIPUDIUFbRHvON
         GbrSsIRpnedtmYcxO9K9CgzJTiKs+h7a09MsKHy/o8CjeeRMe96kt8ChjiL6yF/Ne0
         veApCPCFhgfwpbe+8iqUwrRVPHGvUODvev2teJk7Lk3vD2Qf4Q+bQLMge3mW8HhYux
         RX+09IgZ22dVw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miklos Szeredi <mszeredi@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sasha Levin <sashal@kernel.org>, linux-unionfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 06/19] ovl: perform vfs_getxattr() with mounter creds
Date:   Mon,  8 Feb 2021 12:58:45 -0500
Message-Id: <20210208175858.2092008-6-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210208175858.2092008-1-sashal@kernel.org>
References: <20210208175858.2092008-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

[ Upstream commit 554677b97257b0b69378bd74e521edb7e94769ff ]

The vfs_getxattr() in ovl_xattr_set() is used to check whether an xattr
exist on a lower layer file that is to be removed.  If the xattr does not
exist, then no need to copy up the file.

This call of vfs_getxattr() wasn't wrapped in credential override, and this
is probably okay.  But for consitency wrap this instance as well.

Reported-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index bb980721502dd..56b55397a7a00 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -337,7 +337,9 @@ int ovl_xattr_set(struct dentry *dentry, struct inode *inode, const char *name,
 		goto out;
 
 	if (!value && !upperdentry) {
+		old_cred = ovl_override_creds(dentry->d_sb);
 		err = vfs_getxattr(realdentry, name, NULL, 0);
+		revert_creds(old_cred);
 		if (err < 0)
 			goto out_drop_write;
 	}
-- 
2.27.0

