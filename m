Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59C724405A
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732140AbfFMQFf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:05:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:34916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731333AbfFMIqW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:46:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 822262147A;
        Thu, 13 Jun 2019 08:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415581;
        bh=JHD8uJsrs9qSSu80/LOyMdWaKoSA5Gpaojx5hYUmXng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RnjuxKMZxlTg4w7q1DFrqXjOqqRxymMCtQmW4KTm0QS5KBIFYvY6OJpqiYa74qTz6
         cvWJpskLHqK83HRLaF2ISs806+MFkloJy8ThFumoWhPw3XdXq5+reDjK2l1JpR/88+
         D1hY5UhsSOe44aZDZ9pOD5c7v1klipk4LhI748fU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 053/155] f2fs: fix to retrieve inline xattr space
Date:   Thu, 13 Jun 2019 10:32:45 +0200
Message-Id: <20190613075656.096163738@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075652.691765927@linuxfoundation.org>
References: <20190613075652.691765927@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 45a746881576977f85504c21a75547f10c5c0a8e ]

With below mkfs and mount option, generic/339 of fstest will report that
scratch image becomes corrupted.

MKFS_OPTIONS  -- -O extra_attr -O project_quota -O inode_checksum -O flexible_inline_xattr -O inode_crtime -f /dev/zram1
MOUNT_OPTIONS -- -o acl,user_xattr -o discard,noinline_xattr /dev/zram1 /mnt/scratch_f2fs

[ASSERT] (f2fs_check_dirent_position:1315)  --> Wrong position of dirent pino:1970, name: (...)
level:8, dir_level:0, pgofs:951, correct range:[900, 901]

In old kernel, inline data and directory always reserved 200 bytes in
inode layout, even if inline_xattr is disabled, then new kernel tries
to retrieve that space for non-inline xattr inode, but for inline dentry,
its layout size should be fixed, so we just keep that reserved space.

But the problem here is that, after inline dentry conversion, inline
dentry layout no longer exists, if we still reserve inline xattr space,
after dents updates, there will be a hole in inline xattr space, which
can break hierarchy hash directory structure.

This patch fixes this issue by retrieving inline xattr space after
inline dentry conversion.

Fixes: 6afc662e68b5 ("f2fs: support flexible inline xattr size")
Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/inline.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index bb6a152310ef..404d2462a0fe 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -420,6 +420,14 @@ static int f2fs_move_inline_dirents(struct inode *dir, struct page *ipage,
 	stat_dec_inline_dir(dir);
 	clear_inode_flag(dir, FI_INLINE_DENTRY);
 
+	/*
+	 * should retrieve reserved space which was used to keep
+	 * inline_dentry's structure for backward compatibility.
+	 */
+	if (!f2fs_sb_has_flexible_inline_xattr(F2FS_I_SB(dir)) &&
+			!f2fs_has_inline_xattr(dir))
+		F2FS_I(dir)->i_inline_xattr_size = 0;
+
 	f2fs_i_depth_write(dir, 1);
 	if (i_size_read(dir) < PAGE_SIZE)
 		f2fs_i_size_write(dir, PAGE_SIZE);
@@ -501,6 +509,15 @@ static int f2fs_move_rehashed_dirents(struct inode *dir, struct page *ipage,
 
 	stat_dec_inline_dir(dir);
 	clear_inode_flag(dir, FI_INLINE_DENTRY);
+
+	/*
+	 * should retrieve reserved space which was used to keep
+	 * inline_dentry's structure for backward compatibility.
+	 */
+	if (!f2fs_sb_has_flexible_inline_xattr(F2FS_I_SB(dir)) &&
+			!f2fs_has_inline_xattr(dir))
+		F2FS_I(dir)->i_inline_xattr_size = 0;
+
 	kvfree(backup_dentry);
 	return 0;
 recover:
-- 
2.20.1



