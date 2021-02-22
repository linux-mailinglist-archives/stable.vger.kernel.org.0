Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20AF1321642
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:20:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230501AbhBVMUG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:20:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:44746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230497AbhBVMRO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:17:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 170AA64E05;
        Mon, 22 Feb 2021 12:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613996218;
        bh=YBqvqgp6PAHx6W9ojsyrbRpMv8DrvI2KfiN7xQINXmA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tn6USY6epx9gJCD6DmnTkGjMzV94B2AWU71R2YXbVgbOCHZHRfqppBFB43OPz5SwA
         GLPIGuSRUxKq8n6+TxNaV2Y94G/PtEPvevxAM+0fL0UVT55kZPtaEoHI9d2LYzdFPf
         GB+FymwVy7k/W0ktb3mJAkaxYr0V4GdqBo5TDDXg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 06/50] ovl: perform vfs_getxattr() with mounter creds
Date:   Mon, 22 Feb 2021 13:12:57 +0100
Message-Id: <20210222121021.596049067@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121019.925481519@linuxfoundation.org>
References: <20210222121019.925481519@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 8b3c284ce92ea..08e60a6df77c3 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -340,7 +340,9 @@ int ovl_xattr_set(struct dentry *dentry, struct inode *inode, const char *name,
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



