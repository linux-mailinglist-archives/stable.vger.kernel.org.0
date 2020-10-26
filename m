Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03BD629A0F6
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:47:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409764AbgJ0AbB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 20:31:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:54608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409553AbgJZXwV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 19:52:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1DF8A21D7B;
        Mon, 26 Oct 2020 23:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756340;
        bh=9kk0a7HyUydSRWlqF76ldu7TV33KYy8Chili1/Lt0RM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PjYsvaPneNMSsE9g/0gx6l8aPJDMLFARm4sOKqeCgh1aEIdaYC3lVibY7Z/OX4ZYf
         HFlOFnL2ggpgCHN1j6G5UJpSin9HZuXbDJK53plwLBsqJPUMweUhD0PAtKf+08SnUI
         G1tkiMXAOFtXmtD1X0lAXeRgp6biG1WX4xIUvwks=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.8 013/132] f2fs: compress: fix to disallow enabling compress on non-empty file
Date:   Mon, 26 Oct 2020 19:50:05 -0400
Message-Id: <20201026235205.1023962-13-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026235205.1023962-1-sashal@kernel.org>
References: <20201026235205.1023962-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit 519a5a2f37b850f4eb86674a10d143088670a390 ]

Compressed inode and normal inode has different layout, so we should
disallow enabling compress on non-empty file to avoid race condition
during inode .i_addr array parsing and updating.

Signed-off-by: Chao Yu <yuchao0@huawei.com>
[Jaegeuk Kim: Fix missing condition]
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 3268f8dd59bba..408a99fdaaea2 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1837,6 +1837,8 @@ static int f2fs_setflags_common(struct inode *inode, u32 iflags, u32 mask)
 		if (iflags & F2FS_COMPR_FL) {
 			if (!f2fs_may_compress(inode))
 				return -EINVAL;
+			if (S_ISREG(inode->i_mode) && inode->i_size)
+				return -EINVAL;
 
 			set_compress_context(inode);
 		}
-- 
2.25.1

