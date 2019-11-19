Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84BBF101637
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:51:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731426AbfKSFvO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:51:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:48592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731151AbfKSFvO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:51:14 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C3AA20862;
        Tue, 19 Nov 2019 05:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142673;
        bh=FpaPB9iIq88I6PI7mIlH8uxwmRVVBTJQKj37SXeRS/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sHOZSXamq9eQd2b6moF4t3nyA+QKUsIuuZ9bTEF5Nl8AXK/q3Lemo1BqUCfWyV2/5
         OSiKtJLxNeQ+YK2KtWNNuYIBWJEyGxHZM2hlgW+RPO13nfCt2RwAsrDu/AHFsUPAhu
         EmDZJshW5bRtnIwyto07SLpkJ1wrDRVWxEam/nlM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 160/239] f2fs: fix to recover inodes uid/gid during POR
Date:   Tue, 19 Nov 2019 06:19:20 +0100
Message-Id: <20191119051333.327196149@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051255.850204959@linuxfoundation.org>
References: <20191119051255.850204959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



