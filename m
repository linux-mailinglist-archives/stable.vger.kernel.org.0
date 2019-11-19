Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5B671017A9
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:03:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730491AbfKSFlN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:41:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:35596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729126AbfKSFlL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:41:11 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90395208C3;
        Tue, 19 Nov 2019 05:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142071;
        bh=YnD9x+eja6JGX98NJrMj97iJQaEMDMj5uSFc7nwljo0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sXf+E5rPGIMnus1xJv/CJH03h4BV9V6vsHDL0cXOq7yyiDWETkMkJF2tXlLQQM7TN
         oOXzzobZVwCZsBqecsPq374p3LjQeKYoh9TltTbJ/uPxVIDR/puHVBLhCkuiI2ANO7
         eGfUPP9B4wPQnUSmKbnUQPv/VoVq2jIGvx4EURh4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 378/422] f2fs: fix to recover inodes project id during POR
Date:   Tue, 19 Nov 2019 06:19:35 +0100
Message-Id: <20191119051423.537799061@linuxfoundation.org>
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

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit f4474aa6e5e901ee4af21f39f1b9115aaaaec503 ]

Testcase to reproduce this bug:
1. mkfs.f2fs -O extra_attr -O project_quota /dev/sdd
2. mount -t f2fs /dev/sdd /mnt/f2fs
3. touch /mnt/f2fs/file
4. sync
5. chattr -p 1 /mnt/f2fs/file
6. xfs_io -f /mnt/f2fs/file -c "fsync"
7. godown /mnt/f2fs
8. umount /mnt/f2fs
9. mount -t f2fs /dev/sdd /mnt/f2fs
10. lsattr -p /mnt/f2fs/file

    0 -----------------N- /mnt/f2fs/file

But actually, we expect the correct result is:

    1 -----------------N- /mnt/f2fs/file

The reason is we didn't recover inode.i_projid field during mount,
fix it.

Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/recovery.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index 2c5d2c25d37e3..01636d996ba41 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -218,6 +218,19 @@ static void recover_inode(struct inode *inode, struct page *page)
 	inode->i_mode = le16_to_cpu(raw->i_mode);
 	i_uid_write(inode, le32_to_cpu(raw->i_uid));
 	i_gid_write(inode, le32_to_cpu(raw->i_gid));
+
+	if (raw->i_inline & F2FS_EXTRA_ATTR) {
+		if (f2fs_sb_has_project_quota(F2FS_I_SB(inode)->sb) &&
+			F2FS_FITS_IN_INODE(raw, le16_to_cpu(raw->i_extra_isize),
+								i_projid)) {
+			projid_t i_projid;
+
+			i_projid = (projid_t)le32_to_cpu(raw->i_projid);
+			F2FS_I(inode)->i_projid =
+				make_kprojid(&init_user_ns, i_projid);
+		}
+	}
+
 	f2fs_i_size_write(inode, le64_to_cpu(raw->i_size));
 	inode->i_atime.tv_sec = le64_to_cpu(raw->i_atime);
 	inode->i_ctime.tv_sec = le64_to_cpu(raw->i_ctime);
-- 
2.20.1



