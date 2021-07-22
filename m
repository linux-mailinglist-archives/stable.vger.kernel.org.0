Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 005A93D26AD
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 17:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232629AbhGVOvV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 10:51:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:37058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232619AbhGVOvV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 10:51:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 641E260BD3;
        Thu, 22 Jul 2021 15:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626967916;
        bh=2fqu4C8T1ENocKD97yOn4MHfEgNzSmm1nGxnxNCuETY=;
        h=Subject:To:Cc:From:Date:From;
        b=EQ8pVYJkpfMHi1PVWRRnPs9Aj8+rf43fk9JkcE8Zc2gH4BOR30+rcWoTqY+c4Y5Mo
         WlH7WDz/X0P3JZ+bJOUCDBdpPGeZSBqdScR/7o18j4srCktjeOST/e56s41b4T0+rz
         gUHYEd4UfJEEW790ZbOrF4bba68d+TyDEbCx2/5c=
Subject: FAILED: patch "[PATCH] vboxsf: Make vboxsf_dir_create() return the handle for the" failed to apply to 5.10-stable tree
To:     hdegoede@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 22 Jul 2021 17:31:53 +0200
Message-ID: <1626967913218159@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ab0c29687bc7a890d1a86ac376b0b0fd78b2d9b6 Mon Sep 17 00:00:00 2001
From: Hans de Goede <hdegoede@redhat.com>
Date: Thu, 21 Jan 2021 10:22:27 +0100
Subject: [PATCH] vboxsf: Make vboxsf_dir_create() return the handle for the
 created file

Make vboxsf_dir_create() optionally return the vboxsf-handle for
the created file. This is a preparation patch for adding atomic_open
support.

Fixes: 0fd169576648 ("fs: Add VirtualBox guest shared folder (vboxsf) support")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>

diff --git a/fs/vboxsf/dir.c b/fs/vboxsf/dir.c
index 6ff84343edca..87d5b2fef592 100644
--- a/fs/vboxsf/dir.c
+++ b/fs/vboxsf/dir.c
@@ -253,7 +253,7 @@ static int vboxsf_dir_instantiate(struct inode *parent, struct dentry *dentry,
 }
 
 static int vboxsf_dir_create(struct inode *parent, struct dentry *dentry,
-			     umode_t mode, bool is_dir, bool excl)
+			     umode_t mode, bool is_dir, bool excl, u64 *handle_ret)
 {
 	struct vboxsf_inode *sf_parent_i = VBOXSF_I(parent);
 	struct vboxsf_sbi *sbi = VBOXSF_SBI(parent->i_sb);
@@ -278,30 +278,34 @@ static int vboxsf_dir_create(struct inode *parent, struct dentry *dentry,
 	if (params.result != SHFL_FILE_CREATED)
 		return -EPERM;
 
-	vboxsf_close(sbi->root, params.handle);
-
 	err = vboxsf_dir_instantiate(parent, dentry, &params.info);
 	if (err)
-		return err;
+		goto out;
 
 	/* parent directory access/change time changed */
 	sf_parent_i->force_restat = 1;
 
-	return 0;
+out:
+	if (err == 0 && handle_ret)
+		*handle_ret = params.handle;
+	else
+		vboxsf_close(sbi->root, params.handle);
+
+	return err;
 }
 
 static int vboxsf_dir_mkfile(struct user_namespace *mnt_userns,
 			     struct inode *parent, struct dentry *dentry,
 			     umode_t mode, bool excl)
 {
-	return vboxsf_dir_create(parent, dentry, mode, false, excl);
+	return vboxsf_dir_create(parent, dentry, mode, false, excl, NULL);
 }
 
 static int vboxsf_dir_mkdir(struct user_namespace *mnt_userns,
 			    struct inode *parent, struct dentry *dentry,
 			    umode_t mode)
 {
-	return vboxsf_dir_create(parent, dentry, mode, true, true);
+	return vboxsf_dir_create(parent, dentry, mode, true, true, NULL);
 }
 
 static int vboxsf_dir_unlink(struct inode *parent, struct dentry *dentry)

