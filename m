Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2326447AE85
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:01:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239301AbhLTPBT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:01:19 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:49018 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239379AbhLTO6u (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:58:50 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD0F4611A1;
        Mon, 20 Dec 2021 14:58:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2F83C36AE8;
        Mon, 20 Dec 2021 14:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012329;
        bh=GPG9p5Ngkqmy8/DPUQ4KZQ+jQ52srTqrTtosZZ7etCg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jN1+H2YF0gsY/NOovZYRJscgNCAQfHOKxUYhC6xTXUD73owH1leuL9WgmfCSVIZkA
         1qGufAAvjXx/koxk/25oBuVF2JTtbyse/XlF5rXesdKsq54kQC/OLG2uvhqVUzfS0m
         jltxRiYYIBabsNtDiOL5ADbv0RBJ5FRTgNhBEsWM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        syzbot+75eab84fd0af9e8bf66b@syzkaller.appspotmail.com
Subject: [PATCH 5.15 162/177] ovl: fix warning in ovl_create_real()
Date:   Mon, 20 Dec 2021 15:35:12 +0100
Message-Id: <20211220143045.531697182@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
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
@@ -137,8 +137,7 @@ kill_whiteout:
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
@@ -570,6 +570,7 @@ struct ovl_cattr {
 
 #define OVL_CATTR(m) (&(struct ovl_cattr) { .mode = (m) })
 
+int ovl_mkdir_real(struct inode *dir, struct dentry **newdentry, umode_t mode);
 struct dentry *ovl_create_real(struct inode *dir, struct dentry *newdentry,
 			       struct ovl_cattr *attr);
 int ovl_cleanup(struct inode *dir, struct dentry *dentry);
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -787,10 +787,14 @@ retry:
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


