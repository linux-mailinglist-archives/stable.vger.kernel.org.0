Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1AF015EC23
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:25:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391059AbgBNQIr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:08:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:60962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391050AbgBNQIr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:08:47 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D64E24682;
        Fri, 14 Feb 2020 16:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696525;
        bh=XVTS8iskw9/jLuaj5w3Q2gsSEKn4f5Cc5TOrqbKxMuk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jc6jUGgdlS0TFNRVqKQJDLPmURkFBjmoqkb6FRsOgvvUFz/rJL+1dAzs3mBT5P6XO
         TlmcX0UHVMK6WfuRUC1zhH0AUB5FCBMSMK4bbBo2P3Go4FKUbFVZfK0tDyht61N/46
         cPo23byN4j0Kh63tyWBVZfm6h7Td6ELIVjGehZH4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.4 325/459] f2fs: set I_LINKABLE early to avoid wrong access by vfs
Date:   Fri, 14 Feb 2020 10:59:35 -0500
Message-Id: <20200214160149.11681-325-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaegeuk Kim <jaegeuk@kernel.org>

[ Upstream commit 5b1dbb082f196278f82b6a15a13848efacb9ff11 ]

This patch moves setting I_LINKABLE early in rename2(whiteout) to avoid the
below warning.

[ 3189.163385] WARNING: CPU: 3 PID: 59523 at fs/inode.c:358 inc_nlink+0x32/0x40
[ 3189.246979] Call Trace:
[ 3189.248707]  f2fs_init_inode_metadata+0x2d6/0x440 [f2fs]
[ 3189.251399]  f2fs_add_inline_entry+0x162/0x8c0 [f2fs]
[ 3189.254010]  f2fs_add_dentry+0x69/0xe0 [f2fs]
[ 3189.256353]  f2fs_do_add_link+0xc5/0x100 [f2fs]
[ 3189.258774]  f2fs_rename2+0xabf/0x1010 [f2fs]
[ 3189.261079]  vfs_rename+0x3f8/0xaa0
[ 3189.263056]  ? tomoyo_path_rename+0x44/0x60
[ 3189.265283]  ? do_renameat2+0x49b/0x550
[ 3189.267324]  do_renameat2+0x49b/0x550
[ 3189.269316]  __x64_sys_renameat2+0x20/0x30
[ 3189.271441]  do_syscall_64+0x5a/0x230
[ 3189.273410]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[ 3189.275848] RIP: 0033:0x7f270b4d9a49

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/namei.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index a1c507b0b4ac4..5d9584281935f 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -797,6 +797,7 @@ static int __f2fs_tmpfile(struct inode *dir, struct dentry *dentry,
 
 	if (whiteout) {
 		f2fs_i_links_write(inode, false);
+		inode->i_state |= I_LINKABLE;
 		*whiteout = inode;
 	} else {
 		d_tmpfile(dentry, inode);
@@ -867,6 +868,12 @@ static int f2fs_rename(struct inode *old_dir, struct dentry *old_dentry,
 			F2FS_I(old_dentry->d_inode)->i_projid)))
 		return -EXDEV;
 
+	if (flags & RENAME_WHITEOUT) {
+		err = f2fs_create_whiteout(old_dir, &whiteout);
+		if (err)
+			return err;
+	}
+
 	err = dquot_initialize(old_dir);
 	if (err)
 		goto out;
@@ -898,17 +905,11 @@ static int f2fs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		}
 	}
 
-	if (flags & RENAME_WHITEOUT) {
-		err = f2fs_create_whiteout(old_dir, &whiteout);
-		if (err)
-			goto out_dir;
-	}
-
 	if (new_inode) {
 
 		err = -ENOTEMPTY;
 		if (old_dir_entry && !f2fs_empty_dir(new_inode))
-			goto out_whiteout;
+			goto out_dir;
 
 		err = -ENOENT;
 		new_entry = f2fs_find_entry(new_dir, &new_dentry->d_name,
@@ -916,7 +917,7 @@ static int f2fs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		if (!new_entry) {
 			if (IS_ERR(new_page))
 				err = PTR_ERR(new_page);
-			goto out_whiteout;
+			goto out_dir;
 		}
 
 		f2fs_balance_fs(sbi, true);
@@ -948,7 +949,7 @@ static int f2fs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		err = f2fs_add_link(new_dentry, old_inode);
 		if (err) {
 			f2fs_unlock_op(sbi);
-			goto out_whiteout;
+			goto out_dir;
 		}
 
 		if (old_dir_entry)
@@ -972,7 +973,7 @@ static int f2fs_rename(struct inode *old_dir, struct dentry *old_dentry,
 				if (IS_ERR(old_page))
 					err = PTR_ERR(old_page);
 				f2fs_unlock_op(sbi);
-				goto out_whiteout;
+				goto out_dir;
 			}
 		}
 	}
@@ -991,7 +992,6 @@ static int f2fs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	f2fs_delete_entry(old_entry, old_page, old_dir, NULL);
 
 	if (whiteout) {
-		whiteout->i_state |= I_LINKABLE;
 		set_inode_flag(whiteout, FI_INC_LINK);
 		err = f2fs_add_link(old_dentry, whiteout);
 		if (err)
@@ -1027,15 +1027,14 @@ static int f2fs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	f2fs_unlock_op(sbi);
 	if (new_page)
 		f2fs_put_page(new_page, 0);
-out_whiteout:
-	if (whiteout)
-		iput(whiteout);
 out_dir:
 	if (old_dir_entry)
 		f2fs_put_page(old_dir_page, 0);
 out_old:
 	f2fs_put_page(old_page, 0);
 out:
+	if (whiteout)
+		iput(whiteout);
 	return err;
 }
 
-- 
2.20.1

