Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5F4C492A5A
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 17:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346504AbiARQJU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 11:09:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346507AbiARQIe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 11:08:34 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC4EEC061774;
        Tue, 18 Jan 2022 08:08:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 258E0CE1A3C;
        Tue, 18 Jan 2022 16:08:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC3F3C36AEB;
        Tue, 18 Jan 2022 16:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642522105;
        bh=gvUxZARKEA7blLGcXUCH0UzgL0xjrlfD3qlywtFqa+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g5uqvC1wowmUlK9JL/XBMYwn3RVk8UiybRdg/PFYacAi9xEri1DKdX5Q7qCWRdW0a
         XuvW3S+/4+HgTQQHGqHMO53pIn8q/2iMUMLyRGMNFlLt91iXCF7jehCaZQAoEc+qyP
         Z6b4MqtKNr9BHL9j4657oLkcC8Zi0sCSCrJXrr+U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Dominique Martinet <asmadeus@codewreck.org>, stable@kernel.org,
        v9fs-developer@lists.sourceforge.net,
        syzbot+dfac92a50024b54acaa4@syzkaller.appspotmail.com,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH 5.10 09/23] 9p: only copy valid iattrs in 9P2000.L setattr implementation
Date:   Tue, 18 Jan 2022 17:05:49 +0100
Message-Id: <20220118160451.552456292@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118160451.233828401@linuxfoundation.org>
References: <20220118160451.233828401@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Brauner <christian.brauner@ubuntu.com>

commit 3cb6ee991496b67ee284c6895a0ba007e2d7bac3 upstream.

The 9P2000.L setattr method v9fs_vfs_setattr_dotl() copies struct iattr
values without checking whether they are valid causing unitialized
values to be copied. The 9P2000 setattr method v9fs_vfs_setattr() method
gets this right. Check whether struct iattr fields are valid first
before copying in v9fs_vfs_setattr_dotl() too and make sure that all
other fields are set to 0 apart from {g,u}id which should be set to
INVALID_{G,U}ID. This ensure that they can be safely sent over the wire
or printed for debugging later on.

Link: https://lkml.kernel.org/r/20211129114434.3637938-1-brauner@kernel.org
Link: https://lkml.kernel.org/r/000000000000a0d53f05d1c72a4c%40google.com
Cc: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Latchesar Ionkov <lucho@ionkov.net>
Cc: Dominique Martinet <asmadeus@codewreck.org>
Cc: stable@kernel.org
Cc: v9fs-developer@lists.sourceforge.net
Reported-by: syzbot+dfac92a50024b54acaa4@syzkaller.appspotmail.com
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
[Dominique: do not set a/mtime with just ATTR_A/MTIME as discussed]
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/9p/vfs_inode_dotl.c |   29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -541,7 +541,10 @@ int v9fs_vfs_setattr_dotl(struct dentry
 {
 	int retval;
 	struct p9_fid *fid = NULL;
-	struct p9_iattr_dotl p9attr;
+	struct p9_iattr_dotl p9attr = {
+		.uid = INVALID_UID,
+		.gid = INVALID_GID,
+	};
 	struct inode *inode = d_inode(dentry);
 
 	p9_debug(P9_DEBUG_VFS, "\n");
@@ -551,14 +554,22 @@ int v9fs_vfs_setattr_dotl(struct dentry
 		return retval;
 
 	p9attr.valid = v9fs_mapped_iattr_valid(iattr->ia_valid);
-	p9attr.mode = iattr->ia_mode;
-	p9attr.uid = iattr->ia_uid;
-	p9attr.gid = iattr->ia_gid;
-	p9attr.size = iattr->ia_size;
-	p9attr.atime_sec = iattr->ia_atime.tv_sec;
-	p9attr.atime_nsec = iattr->ia_atime.tv_nsec;
-	p9attr.mtime_sec = iattr->ia_mtime.tv_sec;
-	p9attr.mtime_nsec = iattr->ia_mtime.tv_nsec;
+	if (iattr->ia_valid & ATTR_MODE)
+		p9attr.mode = iattr->ia_mode;
+	if (iattr->ia_valid & ATTR_UID)
+		p9attr.uid = iattr->ia_uid;
+	if (iattr->ia_valid & ATTR_GID)
+		p9attr.gid = iattr->ia_gid;
+	if (iattr->ia_valid & ATTR_SIZE)
+		p9attr.size = iattr->ia_size;
+	if (iattr->ia_valid & ATTR_ATIME_SET) {
+		p9attr.atime_sec = iattr->ia_atime.tv_sec;
+		p9attr.atime_nsec = iattr->ia_atime.tv_nsec;
+	}
+	if (iattr->ia_valid & ATTR_MTIME_SET) {
+		p9attr.mtime_sec = iattr->ia_mtime.tv_sec;
+		p9attr.mtime_nsec = iattr->ia_mtime.tv_nsec;
+	}
 
 	if (iattr->ia_valid & ATTR_FILE) {
 		fid = iattr->ia_file->private_data;


