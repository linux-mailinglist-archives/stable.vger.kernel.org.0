Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEFAEF6524
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 04:05:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727364AbfKJDEw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 22:04:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:50918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728501AbfKJCqp (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:46:45 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 43A62222BE;
        Sun, 10 Nov 2019 02:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573354004;
        bh=FpaPB9iIq88I6PI7mIlH8uxwmRVVBTJQKj37SXeRS/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=woxhAv0xIkrbYgbPa5WbdfGlQNnsMNElv68hkiyHTiIBDLcLdhf4XDYQ98fVcrOrF
         brWbL7fNgT6ZQMYkZtydWWSOqX+vMwiBPO+BuZa7AzuuJI+q/ryL+uKLnZgUIPKprI
         xoGny+XZK+WhMyYQxwrEohNJ+dRbjaLiXsHoFxNA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.14 031/109] f2fs: fix to recover inode's uid/gid during POR
Date:   Sat,  9 Nov 2019 21:44:23 -0500
Message-Id: <20191110024541.31567-31-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024541.31567-1-sashal@kernel.org>
References: <20191110024541.31567-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit dc4cd1257c86451cec3e8e352cc376348e4f4af4 ]

Step to reproduce this bug:
1. logon as root
2. mount -t f2fs /dev/sdd /mnt;
3. touch /mnt/file;
4. chown system /mnt/file; chgrp system /mnt/file;
5. xfs_io -f /mnt/file -c "fsync";
6. godown /mnt;
7. umount /mnt;
8. mount -t f2fs /dev/sdd /mnt;

After step 8) we will expect file's uid/gid are all system, but during
recovery, these two fields were not been recovered, fix it.

Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/recovery.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index db357e9ad5990..adbf2600c0908 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -201,6 +201,8 @@ static void recover_inode(struct inode *inode, struct page *page)
 	char *name;
 
 	inode->i_mode = le16_to_cpu(raw->i_mode);
+	i_uid_write(inode, le32_to_cpu(raw->i_uid));
+	i_gid_write(inode, le32_to_cpu(raw->i_gid));
 	f2fs_i_size_write(inode, le64_to_cpu(raw->i_size));
 	inode->i_atime.tv_sec = le64_to_cpu(raw->i_atime);
 	inode->i_ctime.tv_sec = le64_to_cpu(raw->i_ctime);
-- 
2.20.1

