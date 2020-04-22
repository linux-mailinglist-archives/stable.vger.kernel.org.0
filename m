Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4E821B3DF6
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730267AbgDVKXB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:23:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:59378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730265AbgDVKXA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:23:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4CCE2076E;
        Wed, 22 Apr 2020 10:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550980;
        bh=BcOsfOkxn0Z2bJhhSJhfv3P9uJjbhL86MgsL5pVv5F8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DF15GOFeLvn1RBwafzX2hdwmsajO1rksd4JgJs7wDJdFdGmEDu9RCL7HxmD+u/oKz
         pSKExqAJhIUsu40fmGVbiLapwZk6HeE/LV8rhpS32dZsUJRMI9/JQMdDYcynT6mocS
         Tesb4DO95g5PzTcGxRDq+aNemqdGz1QM7ZUO13Nw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Rosenberg <drosen@google.com>,
        kernel-team@android.com, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 051/166] f2fs: fix wrong check on F2FS_IOC_FSSETXATTR
Date:   Wed, 22 Apr 2020 11:56:18 +0200
Message-Id: <20200422095054.513730507@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095047.669225321@linuxfoundation.org>
References: <20200422095047.669225321@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaegeuk Kim <jaegeuk@kernel.org>

[ Upstream commit 99eabb914e0f870445d065e83e857507f9728a33 ]

This fixes the incorrect failure when enabling project quota on casefold-enabled
file.

Cc: Daniel Rosenberg <drosen@google.com>
Cc: kernel-team@android.com
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 0d4da644df3bc..a41c633ac6cfe 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1787,12 +1787,15 @@ static int f2fs_file_flush(struct file *file, fl_owner_t id)
 static int f2fs_setflags_common(struct inode *inode, u32 iflags, u32 mask)
 {
 	struct f2fs_inode_info *fi = F2FS_I(inode);
+	u32 masked_flags = fi->i_flags & mask;
+
+	f2fs_bug_on(F2FS_I_SB(inode), (iflags & ~mask));
 
 	/* Is it quota file? Do not allow user to mess with it */
 	if (IS_NOQUOTA(inode))
 		return -EPERM;
 
-	if ((iflags ^ fi->i_flags) & F2FS_CASEFOLD_FL) {
+	if ((iflags ^ masked_flags) & F2FS_CASEFOLD_FL) {
 		if (!f2fs_sb_has_casefold(F2FS_I_SB(inode)))
 			return -EOPNOTSUPP;
 		if (!f2fs_empty_dir(inode))
@@ -1806,9 +1809,9 @@ static int f2fs_setflags_common(struct inode *inode, u32 iflags, u32 mask)
 			return -EINVAL;
 	}
 
-	if ((iflags ^ fi->i_flags) & F2FS_COMPR_FL) {
+	if ((iflags ^ masked_flags) & F2FS_COMPR_FL) {
 		if (S_ISREG(inode->i_mode) &&
-			(fi->i_flags & F2FS_COMPR_FL || i_size_read(inode) ||
+			(masked_flags & F2FS_COMPR_FL || i_size_read(inode) ||
 						F2FS_HAS_BLOCKS(inode)))
 			return -EINVAL;
 		if (iflags & F2FS_NOCOMP_FL)
@@ -1825,8 +1828,8 @@ static int f2fs_setflags_common(struct inode *inode, u32 iflags, u32 mask)
 			set_compress_context(inode);
 		}
 	}
-	if ((iflags ^ fi->i_flags) & F2FS_NOCOMP_FL) {
-		if (fi->i_flags & F2FS_COMPR_FL)
+	if ((iflags ^ masked_flags) & F2FS_NOCOMP_FL) {
+		if (masked_flags & F2FS_COMPR_FL)
 			return -EINVAL;
 	}
 
-- 
2.20.1



