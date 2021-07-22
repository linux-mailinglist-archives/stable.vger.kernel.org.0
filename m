Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB463D2A36
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231239AbhGVQKE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:10:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:44968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235083AbhGVQIc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:08:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F89461D61;
        Thu, 22 Jul 2021 16:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972502;
        bh=xCz0/cHXYUArxrVUvzli1T+G48EHaT321NwxNoTKvNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HWeruC1XaQ68LkvK6QLzGha1PNlieMXo5cSQ1TKQpbKx9QlbujqeAGwGp1vhIXt5y
         XQiJDCj43ux8zduOIDknmkcd53tbo+QDSBoGU64/cylYTud0XgCZvF61VuizHhF3yw
         GThv9m85BfOpaszKXW06CMfDm1+bs7i2olNNFXvk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5.13 137/156] vboxsf: Make vboxsf_dir_create() return the handle for the created file
Date:   Thu, 22 Jul 2021 18:31:52 +0200
Message-Id: <20210722155632.783345096@linuxfoundation.org>
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

commit ab0c29687bc7a890d1a86ac376b0b0fd78b2d9b6 upstream.

Make vboxsf_dir_create() optionally return the vboxsf-handle for
the created file. This is a preparation patch for adding atomic_open
support.

Fixes: 0fd169576648 ("fs: Add VirtualBox guest shared folder (vboxsf) support")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/vboxsf/dir.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

--- a/fs/vboxsf/dir.c
+++ b/fs/vboxsf/dir.c
@@ -253,7 +253,7 @@ static int vboxsf_dir_instantiate(struct
 }
 
 static int vboxsf_dir_create(struct inode *parent, struct dentry *dentry,
-			     umode_t mode, bool is_dir, bool excl)
+			     umode_t mode, bool is_dir, bool excl, u64 *handle_ret)
 {
 	struct vboxsf_inode *sf_parent_i = VBOXSF_I(parent);
 	struct vboxsf_sbi *sbi = VBOXSF_SBI(parent->i_sb);
@@ -278,30 +278,34 @@ static int vboxsf_dir_create(struct inod
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


