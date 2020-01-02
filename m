Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0549712F0BA
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:55:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728629AbgABWTk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:19:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:36004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728144AbgABWTh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:19:37 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D04321582;
        Thu,  2 Jan 2020 22:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003577;
        bh=FjeBkZ61tze9AralcRZgis9AfdDnqF0kdtbdJ+5ayR4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rUXiZwrRhgELIl7ssHHCLNrmoqa5+iHd5/Oq/nrb9TARP9iaZhv/grDbxAnTa6l0a
         IsH463GVpm/QGe2WfQAnfvpTBZxK/OReKj9ix1/+l8k14BArieoNJotG7tPL0pxb53
         UL//7KI8F+2bVo+OrAzU7LuQOkmFeLVTCVHBpw7U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 027/114] f2fs: fix to update dirs i_pino during cross_rename
Date:   Thu,  2 Jan 2020 23:06:39 +0100
Message-Id: <20200102220031.850609799@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220029.183913184@linuxfoundation.org>
References: <20200102220029.183913184@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit 2a60637f06ac94869b2e630eaf837110d39bf291 ]

As Eric reported:

RENAME_EXCHANGE support was just added to fsstress in xfstests:

	commit 65dfd40a97b6bbbd2a22538977bab355c5bc0f06
	Author: kaixuxia <xiakaixu1987@gmail.com>
	Date:   Thu Oct 31 14:41:48 2019 +0800

	    fsstress: add EXCHANGE renameat2 support

This is causing xfstest generic/579 to fail due to fsck.f2fs reporting errors.
I'm not sure what the problem is, but it still happens even with all the
fs-verity stuff in the test commented out, so that the test just runs fsstress.

generic/579 23s ... 	[10:02:25]
[    7.745370] run fstests generic/579 at 2019-11-04 10:02:25
_check_generic_filesystem: filesystem on /dev/vdc is inconsistent
(see /results/f2fs/results-default/generic/579.full for details)
 [10:02:47]
Ran: generic/579
Failures: generic/579
Failed 1 of 1 tests
Xunit report: /results/f2fs/results-default/result.xml

Here's the contents of 579.full:

_check_generic_filesystem: filesystem on /dev/vdc is inconsistent
*** fsck.f2fs output ***
[ASSERT] (__chk_dots_dentries:1378)  --> Bad inode number[0x24] for '..', parent parent ino is [0xd10]

The root cause is that we forgot to update directory's i_pino during
cross_rename, fix it.

Fixes: 32f9bc25cbda0 ("f2fs: support ->rename2()")
Signed-off-by: Chao Yu <yuchao0@huawei.com>
Tested-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/namei.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index 6b23dcbf52f4..0ace2c2e3de9 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -948,7 +948,8 @@ static int f2fs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	if (!old_dir_entry || whiteout)
 		file_lost_pino(old_inode);
 	else
-		F2FS_I(old_inode)->i_pino = new_dir->i_ino;
+		/* adjust dir's i_pino to pass fsck check */
+		f2fs_i_pino_write(old_inode, new_dir->i_ino);
 	up_write(&F2FS_I(old_inode)->i_sem);
 
 	old_inode->i_ctime = current_time(old_inode);
@@ -1103,7 +1104,11 @@ static int f2fs_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
 	f2fs_set_link(old_dir, old_entry, old_page, new_inode);
 
 	down_write(&F2FS_I(old_inode)->i_sem);
-	file_lost_pino(old_inode);
+	if (!old_dir_entry)
+		file_lost_pino(old_inode);
+	else
+		/* adjust dir's i_pino to pass fsck check */
+		f2fs_i_pino_write(old_inode, new_dir->i_ino);
 	up_write(&F2FS_I(old_inode)->i_sem);
 
 	old_dir->i_ctime = current_time(old_dir);
@@ -1118,7 +1123,11 @@ static int f2fs_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
 	f2fs_set_link(new_dir, new_entry, new_page, old_inode);
 
 	down_write(&F2FS_I(new_inode)->i_sem);
-	file_lost_pino(new_inode);
+	if (!new_dir_entry)
+		file_lost_pino(new_inode);
+	else
+		/* adjust dir's i_pino to pass fsck check */
+		f2fs_i_pino_write(new_inode, old_dir->i_ino);
 	up_write(&F2FS_I(new_inode)->i_sem);
 
 	new_dir->i_ctime = current_time(new_dir);
-- 
2.20.1



