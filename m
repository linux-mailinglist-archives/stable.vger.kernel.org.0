Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 677EA31EB3
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 15:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727278AbfFANid (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 09:38:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:48854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728516AbfFANV3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Jun 2019 09:21:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89D2A2730A;
        Sat,  1 Jun 2019 13:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559395288;
        bh=JSSfZj/akRgGV2osQ4QGkulYa61lv7tk4SA7Mrkrpog=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jCDg/26Py9gc5gJmHM/miv3ZgjnHuBpt9OP2FZ0/4xUQ5sTkG1TEcI7Tzjv+1YGsU
         kEkcyZqm2L5qKfsQqRJEsXMDwW5ifByVVdehTAVcbhowObg38BwMi40cQze+0HEBff
         6XH7t+0hT6Tt1aVZTitGjygIm/xiNW8RVWavGA6c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.0 051/173] f2fs: fix to retrieve inline xattr space
Date:   Sat,  1 Jun 2019 09:17:23 -0400
Message-Id: <20190601131934.25053-51-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190601131934.25053-1-sashal@kernel.org>
References: <20190601131934.25053-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

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
index aacbb864ec1ed..0c2251d595ec8 100644
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

