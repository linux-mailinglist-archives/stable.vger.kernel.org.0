Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B467E3D2A35
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:07:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233158AbhGVQKD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:10:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:42796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234938AbhGVQIH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:08:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B9C161D25;
        Thu, 22 Jul 2021 16:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972498;
        bh=CZHBOBlM0zhVpnAQqrtkTIAtY48zTE2Z3A5VtAlzCiM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=trYm0tTLVqlHfK3hIYuRIRz/dUSEjZ6jsLhMwNFB5jbKweXPXZWCGb4bI+uSZ10Jo
         vpgp2+y6M9lUt1fTw6gVIqN/ymP3X0NN1Ys9YzvGiFnKStALCiAJhlZlsSEKT5ivt7
         OaCg5l70yE7m60BKo9gc5KPg7sd08zkDjYe7PP+A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5.13 136/156] vboxsf: Honor excl flag to the dir-inode create op
Date:   Thu, 22 Jul 2021 18:31:51 +0200
Message-Id: <20210722155632.751108561@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155628.371356843@linuxfoundation.org>
References: <20210722155628.371356843@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit cc3ddee97cff034cea4d095de4a484c92a219bf5 upstream.

Honor the excl flag to the dir-inode create op, instead of behaving
as if it is always set.

Note the old behavior still worked most of the time since a non-exclusive
open only calls the create op, if there is a race and the file is created
between the dentry lookup and the calling of the create call.

While at it change the type of the is_dir parameter to the
vboxsf_dir_create() helper from an int to a bool, to be consistent with
the use of bool for the excl parameter.

Fixes: 0fd169576648 ("fs: Add VirtualBox guest shared folder (vboxsf) support")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/vboxsf/dir.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/fs/vboxsf/dir.c
+++ b/fs/vboxsf/dir.c
@@ -253,7 +253,7 @@ static int vboxsf_dir_instantiate(struct
 }
 
 static int vboxsf_dir_create(struct inode *parent, struct dentry *dentry,
-			     umode_t mode, int is_dir)
+			     umode_t mode, bool is_dir, bool excl)
 {
 	struct vboxsf_inode *sf_parent_i = VBOXSF_I(parent);
 	struct vboxsf_sbi *sbi = VBOXSF_SBI(parent->i_sb);
@@ -261,10 +261,12 @@ static int vboxsf_dir_create(struct inod
 	int err;
 
 	params.handle = SHFL_HANDLE_NIL;
-	params.create_flags = SHFL_CF_ACT_CREATE_IF_NEW |
-			      SHFL_CF_ACT_FAIL_IF_EXISTS |
-			      SHFL_CF_ACCESS_READWRITE |
-			      (is_dir ? SHFL_CF_DIRECTORY : 0);
+	params.create_flags = SHFL_CF_ACT_CREATE_IF_NEW | SHFL_CF_ACCESS_READWRITE;
+	if (is_dir)
+		params.create_flags |= SHFL_CF_DIRECTORY;
+	if (excl)
+		params.create_flags |= SHFL_CF_ACT_FAIL_IF_EXISTS;
+
 	params.info.attr.mode = (mode & 0777) |
 				(is_dir ? SHFL_TYPE_DIRECTORY : SHFL_TYPE_FILE);
 	params.info.attr.additional = SHFLFSOBJATTRADD_NOTHING;
@@ -292,14 +294,14 @@ static int vboxsf_dir_mkfile(struct user
 			     struct inode *parent, struct dentry *dentry,
 			     umode_t mode, bool excl)
 {
-	return vboxsf_dir_create(parent, dentry, mode, 0);
+	return vboxsf_dir_create(parent, dentry, mode, false, excl);
 }
 
 static int vboxsf_dir_mkdir(struct user_namespace *mnt_userns,
 			    struct inode *parent, struct dentry *dentry,
 			    umode_t mode)
 {
-	return vboxsf_dir_create(parent, dentry, mode, 1);
+	return vboxsf_dir_create(parent, dentry, mode, true, true);
 }
 
 static int vboxsf_dir_unlink(struct inode *parent, struct dentry *dentry)


