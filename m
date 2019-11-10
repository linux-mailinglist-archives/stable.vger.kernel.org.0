Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46992F65CB
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 04:10:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728557AbfKJCo2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:44:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:43794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727296AbfKJCo2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:44:28 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5BE521924;
        Sun, 10 Nov 2019 02:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353867;
        bh=YnD9x+eja6JGX98NJrMj97iJQaEMDMj5uSFc7nwljo0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wwlYO+DgP7TyRTyP30S8cd9CTuWDrDxHkANE3nigL1lu2bWhEF1hgWPAumOWxIh4W
         IR3K84zZk7wZ094rEU+Ac+/A/3iTmkpJw2cRE9nqgGu7PpeDBRRiNrVs2mdU9iggJw
         viBl7LkpASA7aKgaXJAzbB0ZEWuh55+HMHwX6qhk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.19 147/191] f2fs: fix to recover inode's project id during POR
Date:   Sat,  9 Nov 2019 21:39:29 -0500
Message-Id: <20191110024013.29782-147-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

