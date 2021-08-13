Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23D203EB8D8
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 17:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241497AbhHMPR1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 11:17:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:57846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242501AbhHMPP1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 11:15:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C87DE610FE;
        Fri, 13 Aug 2021 15:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628867690;
        bh=MSJKibiECxprk3H5xW2S1Jc936IZjXLjPnQToKFO7iw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VLRpc5Z74+XjFKtDBlvOVIgZ0kRDGSFNcDQz6gK7xGcLUT0RnEq9B8jG4PBe8UlG6
         wZmluC6BYROcBIgnqwXSh47tMz1fM0tH/ko1MrK3ZMxkupm6O8JMN8Sltr1c0paMZl
         DUcRNlMzRXrgjybGllos0W4ww+USzRBLt5+ebN0U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 5.10 11/19] vboxsf: Honor excl flag to the dir-inode create op
Date:   Fri, 13 Aug 2021 17:07:28 +0200
Message-Id: <20210813150522.996113881@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210813150522.623322501@linuxfoundation.org>
References: <20210813150522.623322501@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit cc3ddee97cff034cea4d095de4a484c92a219bf5 upstream

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
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
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
@@ -291,13 +293,13 @@ static int vboxsf_dir_create(struct inod
 static int vboxsf_dir_mkfile(struct inode *parent, struct dentry *dentry,
 			     umode_t mode, bool excl)
 {
-	return vboxsf_dir_create(parent, dentry, mode, 0);
+	return vboxsf_dir_create(parent, dentry, mode, false, excl);
 }
 
 static int vboxsf_dir_mkdir(struct inode *parent, struct dentry *dentry,
 			    umode_t mode)
 {
-	return vboxsf_dir_create(parent, dentry, mode, 1);
+	return vboxsf_dir_create(parent, dentry, mode, true, true);
 }
 
 static int vboxsf_dir_unlink(struct inode *parent, struct dentry *dentry)


