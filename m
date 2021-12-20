Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C35B347AC7B
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:44:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233013AbhLTOoL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:44:11 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50940 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234496AbhLTOmk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:42:40 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 87435B80EEB;
        Mon, 20 Dec 2021 14:42:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA4E4C36AE7;
        Mon, 20 Dec 2021 14:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011358;
        bh=hyMmjLViWBCbCFkd8HRkiwklNlZCF7TgC4tZRtSJWag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EfryOkwGew6UTPw5Oz5Mk5ZRnsKqArFV/fI7N3XSan3jqTgmy6/68JNZYPnjWf2PK
         dZnN8JkWV++x1BgJp1JJaRlP1WpZ/7btkiJBWa6vpmtW2rv2n+C01dQFVRbj8LTxJO
         F6+em6sm+GP5Xmg3lncYaFHwExLSmRiyCeZggwiA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        syzbot+75eab84fd0af9e8bf66b@syzkaller.appspotmail.com
Subject: [PATCH 4.19 50/56] ovl: fix warning in ovl_create_real()
Date:   Mon, 20 Dec 2021 15:34:43 +0100
Message-Id: <20211220143025.114793764@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143023.451982183@linuxfoundation.org>
References: <20211220143023.451982183@linuxfoundation.org>
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
@@ -116,8 +116,7 @@ kill_whiteout:
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
@@ -402,6 +402,7 @@ struct ovl_cattr {
 
 #define OVL_CATTR(m) (&(struct ovl_cattr) { .mode = (m) })
 
+int ovl_mkdir_real(struct inode *dir, struct dentry **newdentry, umode_t mode);
 struct dentry *ovl_create_real(struct inode *dir, struct dentry *newdentry,
 			       struct ovl_cattr *attr);
 int ovl_cleanup(struct inode *dir, struct dentry *dentry);
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -654,10 +654,14 @@ retry:
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


