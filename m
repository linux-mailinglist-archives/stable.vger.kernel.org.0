Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1D8110186B
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:08:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727261AbfKSFa6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:30:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:49836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727906AbfKSFa6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:30:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7287222DF;
        Tue, 19 Nov 2019 05:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141457;
        bh=KBCPrtaK8CUF7LqGnIIJRU4tEy3EaC6ukV+sjBbT34A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XPCIR/DTYsi/bWiuTarnQmuJXSCGbprsImy11fNq8v7ilJNjmeBtCfQ0+5ELDso+p
         PclJSfSbX/SecQDJwUZBZMX4jLeVVHh03hrWIYNiTIOtHy5E4jBRp9sQAFerXygzDQ
         QFa1Cy+T53WR/db2hUHuyfZ5ItRxkTnsB78CXAgc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wang Shilong <wshilong@ddn.com>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 167/422] f2fs: fix setattr project check upon fssetxattr ioctl
Date:   Tue, 19 Nov 2019 06:16:04 +0100
Message-Id: <20191119051409.248417021@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Shilong <wangshilong1991@gmail.com>

[ Upstream commit c8e927579e00a182eda07e4c45df9c8c699c8ded ]

Currently, project quota could be changed by fssetxattr
ioctl, and existed permission check inode_owner_or_capable()
is obviously not enough, just think that common users could
change project id of file, that could make users to
break project quota easily.

This patch try to follow same regular of xfs project
quota:

"Project Quota ID state is only allowed to change from
within the init namespace. Enforce that restriction only
if we are trying to change the quota ID state.
Everything else is allowed in user namespaces."

Besides that, check and set project id'state should
be an atomic operation, protect whole operation with
inode lock.

Signed-off-by: Wang Shilong <wshilong@ddn.com>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 60 +++++++++++++++++++++++++++++++-------------------
 1 file changed, 37 insertions(+), 23 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 6972c6d7c3893..c7ea122997695 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -2618,34 +2618,26 @@ static int f2fs_ioc_setproject(struct file *filp, __u32 projid)
 	if (projid_eq(kprojid, F2FS_I(inode)->i_projid))
 		return 0;
 
-	err = mnt_want_write_file(filp);
-	if (err)
-		return err;
-
 	err = -EPERM;
-	inode_lock(inode);
-
 	/* Is it quota file? Do not allow user to mess with it */
 	if (IS_NOQUOTA(inode))
-		goto out_unlock;
+		return err;
 
 	ipage = f2fs_get_node_page(sbi, inode->i_ino);
-	if (IS_ERR(ipage)) {
-		err = PTR_ERR(ipage);
-		goto out_unlock;
-	}
+	if (IS_ERR(ipage))
+		return PTR_ERR(ipage);
 
 	if (!F2FS_FITS_IN_INODE(F2FS_INODE(ipage), fi->i_extra_isize,
 								i_projid)) {
 		err = -EOVERFLOW;
 		f2fs_put_page(ipage, 1);
-		goto out_unlock;
+		return err;
 	}
 	f2fs_put_page(ipage, 1);
 
 	err = dquot_initialize(inode);
 	if (err)
-		goto out_unlock;
+		return err;
 
 	transfer_to[PRJQUOTA] = dqget(sb, make_kqid_projid(kprojid));
 	if (!IS_ERR(transfer_to[PRJQUOTA])) {
@@ -2659,9 +2651,6 @@ static int f2fs_ioc_setproject(struct file *filp, __u32 projid)
 	inode->i_ctime = current_time(inode);
 out_dirty:
 	f2fs_mark_inode_dirty_sync(inode, true);
-out_unlock:
-	inode_unlock(inode);
-	mnt_drop_write_file(filp);
 	return err;
 }
 #else
@@ -2737,6 +2726,30 @@ static int f2fs_ioc_fsgetxattr(struct file *filp, unsigned long arg)
 	return 0;
 }
 
+static int f2fs_ioctl_check_project(struct inode *inode, struct fsxattr *fa)
+{
+	/*
+	 * Project Quota ID state is only allowed to change from within the init
+	 * namespace. Enforce that restriction only if we are trying to change
+	 * the quota ID state. Everything else is allowed in user namespaces.
+	 */
+	if (current_user_ns() == &init_user_ns)
+		return 0;
+
+	if (__kprojid_val(F2FS_I(inode)->i_projid) != fa->fsx_projid)
+		return -EINVAL;
+
+	if (F2FS_I(inode)->i_flags & F2FS_PROJINHERIT_FL) {
+		if (!(fa->fsx_xflags & FS_XFLAG_PROJINHERIT))
+			return -EINVAL;
+	} else {
+		if (fa->fsx_xflags & FS_XFLAG_PROJINHERIT)
+			return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int f2fs_ioc_fssetxattr(struct file *filp, unsigned long arg)
 {
 	struct inode *inode = file_inode(filp);
@@ -2764,19 +2777,20 @@ static int f2fs_ioc_fssetxattr(struct file *filp, unsigned long arg)
 		return err;
 
 	inode_lock(inode);
+	err = f2fs_ioctl_check_project(inode, &fa);
+	if (err)
+		goto out;
 	flags = (fi->i_flags & ~F2FS_FL_XFLAG_VISIBLE) |
 				(flags & F2FS_FL_XFLAG_VISIBLE);
 	err = __f2fs_ioc_setflags(inode, flags);
-	inode_unlock(inode);
-	mnt_drop_write_file(filp);
 	if (err)
-		return err;
+		goto out;
 
 	err = f2fs_ioc_setproject(filp, fa.fsx_projid);
-	if (err)
-		return err;
-
-	return 0;
+out:
+	inode_unlock(inode);
+	mnt_drop_write_file(filp);
+	return err;
 }
 
 int f2fs_pin_file_control(struct inode *inode, bool inc)
-- 
2.20.1



