Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59433DD42D
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729994AbfJRWWw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:22:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:37524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729890AbfJRWFg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:05:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95D2B2245D;
        Fri, 18 Oct 2019 22:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436336;
        bh=iSuchusAehub8/OSSTazSzsq4ZRiyFsHmrWUsdoSclw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=laPB7R6wUcwUOPXyfRB/T8Q5RNFXyYsfYoQYs0gPEVsSQziQtKOmUnfRtBhlMoVUR
         i3DXhlM6AJ9pXfuCOyQM/c+Yps1waat+LlttuVysz1KsMnK4mbDazPHIMciLzzBw31
         nP5wr7JdkI11NaCxSyVUg5gdGnycStS+XgDO7Pdg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.19 007/100] f2fs: fix to recover inode->i_flags of inode block during POR
Date:   Fri, 18 Oct 2019 18:03:52 -0400
Message-Id: <20191018220525.9042-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220525.9042-1-sashal@kernel.org>
References: <20191018220525.9042-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit 0c093b590efb5c1ccdc835868dc2ae94bd2e14dc ]

Testcase to reproduce this bug:
1. mkfs.f2fs /dev/sdd
2. mount -t f2fs /dev/sdd /mnt/f2fs
3. touch /mnt/f2fs/file
4. sync
5. chattr +a /mnt/f2fs/file
6. xfs_io -a /mnt/f2fs/file -c "fsync"
7. godown /mnt/f2fs
8. umount /mnt/f2fs
9. mount -t f2fs /dev/sdd /mnt/f2fs
10. xfs_io /mnt/f2fs/file

There is no error when opening this file w/o O_APPEND, but actually,
we expect the correct result should be:

/mnt/f2fs/file: Operation not permitted

The root cause is, in recover_inode(), we recover inode->i_flags more
than F2FS_I(inode)->i_flags, so fix it.

Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/recovery.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index 281ba46b5b359..2c3be4c3c626f 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -226,6 +226,7 @@ static void recover_inode(struct inode *inode, struct page *page)
 
 	F2FS_I(inode)->i_advise = raw->i_advise;
 	F2FS_I(inode)->i_flags = le32_to_cpu(raw->i_flags);
+	f2fs_set_inode_flags(inode);
 	F2FS_I(inode)->i_gc_failures[GC_FAILURE_PIN] =
 				le16_to_cpu(raw->i_gc_failures);
 
-- 
2.20.1

