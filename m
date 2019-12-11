Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73F4D11B1BB
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:32:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387750AbfLKP2z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:28:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:35274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387739AbfLKP2y (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:28:54 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3124E222C4;
        Wed, 11 Dec 2019 15:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576078132;
        bh=4y9xGbhnrjK2hjcSMbEbcwqhZJeI4tF5cKVYU0MuI1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f/X2jir1knQ9bv45wXF7kFjnLsCKK2egs71nxb+bQ6/KC3oFNCQBEzGIn04kwhVD2
         GaMMJlZnZh2XT2Fvq15ANlTSoIsHrP7WY7ma9UJG/Brn3xJq/tJJLTGfHUOWWHs2er
         L3beCITZes4WDuwqdEleWN3qi0vjz/R3UHh2Ug6g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chao Yu <yuchao0@huawei.com>, Eric Biggers <ebiggers@kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.14 20/58] f2fs: fix to update dir's i_pino during cross_rename
Date:   Wed, 11 Dec 2019 10:27:53 -0500
Message-Id: <20191211152831.23507-20-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211152831.23507-1-sashal@kernel.org>
References: <20191211152831.23507-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index b80e7db3b55b5..b13383948fca3 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -862,7 +862,8 @@ static int f2fs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	if (!old_dir_entry || whiteout)
 		file_lost_pino(old_inode);
 	else
-		F2FS_I(old_inode)->i_pino = new_dir->i_ino;
+		/* adjust dir's i_pino to pass fsck check */
+		f2fs_i_pino_write(old_inode, new_dir->i_ino);
 	up_write(&F2FS_I(old_inode)->i_sem);
 
 	old_inode->i_ctime = current_time(old_inode);
@@ -1027,7 +1028,11 @@ static int f2fs_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
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
@@ -1042,7 +1047,11 @@ static int f2fs_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
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

