Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27F0947AD8E
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:54:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237850AbhLTOw5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:52:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236138AbhLTOu7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:50:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACBA0C08EAEA;
        Mon, 20 Dec 2021 06:46:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4CE4261185;
        Mon, 20 Dec 2021 14:46:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33975C36AE7;
        Mon, 20 Dec 2021 14:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011602;
        bh=PqZDWNYbxKDT1UN2AEx9VwMbmZOHsuoKUXiwpYNLLtg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TTkao0kd4cYB4KexSs2n3hyZnP3oBzYp5SsOb3wVlYLDbo4qKAXjExXxwBC7eM5j9
         /hvcLJ2WxflMPFgYIxcvYS3Mh8PSJyfjYK+so0E5NAXmb0nvNDsnPxYmVUOh3al/3N
         l9dt2Mw9ADXLTwuolU+pPGX8l/ie+rRdZ0Yxp410=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        syzbot+75eab84fd0af9e8bf66b@syzkaller.appspotmail.com
Subject: [PATCH 5.4 61/71] ovl: fix warning in ovl_create_real()
Date:   Mon, 20 Dec 2021 15:34:50 +0100
Message-Id: <20211220143027.743186091@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143025.683747691@linuxfoundation.org>
References: <20211220143025.683747691@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

commit 1f5573cfe7a7056e80a92c7a037a3e69f3a13d1c upstream.

Syzbot triggered the following warning in ovl_workdir_create() ->
ovl_create_real():

	if (!err && WARN_ON(!newdentry->d_inode)) {

The reason is that the cgroup2 filesystem returns from mkdir without
instantiating the new dentry.

Weird filesystems such as this will be rejected by overlayfs at a later
stage during setup, but to prevent such a warning, call ovl_mkdir_real()
directly from ovl_workdir_create() and reject this case early.

Reported-and-tested-by: syzbot+75eab84fd0af9e8bf66b@syzkaller.appspotmail.com
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/dir.c       |    3 +--
 fs/overlayfs/overlayfs.h |    1 +
 fs/overlayfs/super.c     |   12 ++++++++----
 3 files changed, 10 insertions(+), 6 deletions(-)

--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -113,8 +113,7 @@ kill_whiteout:
 	goto out;
 }
 
-static int ovl_mkdir_real(struct inode *dir, struct dentry **newdentry,
-			  umode_t mode)
+int ovl_mkdir_real(struct inode *dir, struct dentry **newdentry, umode_t mode)
 {
 	int err;
 	struct dentry *d, *dentry = *newdentry;
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -409,6 +409,7 @@ struct ovl_cattr {
 
 #define OVL_CATTR(m) (&(struct ovl_cattr) { .mode = (m) })
 
+int ovl_mkdir_real(struct inode *dir, struct dentry **newdentry, umode_t mode);
 struct dentry *ovl_create_real(struct inode *dir, struct dentry *newdentry,
 			       struct ovl_cattr *attr);
 int ovl_cleanup(struct inode *dir, struct dentry *dentry);
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -650,10 +650,14 @@ retry:
 			goto retry;
 		}
 
-		work = ovl_create_real(dir, work, OVL_CATTR(attr.ia_mode));
-		err = PTR_ERR(work);
-		if (IS_ERR(work))
-			goto out_err;
+		err = ovl_mkdir_real(dir, &work, attr.ia_mode);
+		if (err)
+			goto out_dput;
+
+		/* Weird filesystem returning with hashed negative (kernfs)? */
+		err = -EINVAL;
+		if (d_really_is_negative(work))
+			goto out_dput;
 
 		/*
 		 * Try to remove POSIX ACL xattrs from workdir.  We are good if:


