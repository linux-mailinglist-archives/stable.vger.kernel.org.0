Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF83A329232
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:42:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243054AbhCAUlH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:41:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:50670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240296AbhCAUdx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:33:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA49860240;
        Mon,  1 Mar 2021 18:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614624321;
        bh=0EByw8XFbx99sPrjyyssPQod9xfPKCY02JICQmsyRxg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U5RRxyUEJf8SDzmBaUz95UcpV49VHGTO1iQBnGix9nzgqwlTkMaM35w0I3q/kmlAd
         0RGF0TRwoAqz7GA8ebIkzh9dkCKGjsOgfQ6b1VE4TkSbpiOCCmmor+vyVibClvypEE
         Cx8KsRbYGpvZFvI5l69nPZCVkVtOidBjP01xADL0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Michael Labriola <michael.d.labriola@gmail.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.10 524/663] selinux: fix inconsistency between inode_getxattr and inode_listsecurity
Date:   Mon,  1 Mar 2021 17:12:52 +0100
Message-Id: <20210301161207.767857253@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

commit a9ffe682c58aaff643764547f5420e978b6e0830 upstream.

When inode has no listxattr op of its own (e.g. squashfs) vfs_listxattr
calls the LSM inode_listsecurity hooks to list the xattrs that LSMs will
intercept in inode_getxattr hooks.

When selinux LSM is installed but not initialized, it will list the
security.selinux xattr in inode_listsecurity, but will not intercept it
in inode_getxattr.  This results in -ENODATA for a getxattr call for an
xattr returned by listxattr.

This situation was manifested as overlayfs failure to copy up lower
files from squashfs when selinux is built-in but not initialized,
because ovl_copy_xattr() iterates the lower inode xattrs by
vfs_listxattr() and vfs_getxattr().

Match the logic of inode_listsecurity to that of inode_getxattr and
do not list the security.selinux xattr if selinux is not initialized.

Reported-by: Michael Labriola <michael.d.labriola@gmail.com>
Tested-by: Michael Labriola <michael.d.labriola@gmail.com>
Link: https://lore.kernel.org/linux-unionfs/2nv9d47zt7.fsf@aldarion.sourceruckus.org/
Fixes: c8e222616c7e ("selinux: allow reading labels before policy is loaded")
Cc: stable@vger.kernel.org#v5.9+
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/selinux/hooks.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3414,6 +3414,10 @@ static int selinux_inode_setsecurity(str
 static int selinux_inode_listsecurity(struct inode *inode, char *buffer, size_t buffer_size)
 {
 	const int len = sizeof(XATTR_NAME_SELINUX);
+
+	if (!selinux_initialized(&selinux_state))
+		return 0;
+
 	if (buffer && len <= buffer_size)
 		memcpy(buffer, XATTR_NAME_SELINUX, len);
 	return len;


