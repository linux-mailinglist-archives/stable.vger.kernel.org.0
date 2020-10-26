Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B09D299F1D
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:21:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410998AbgJZXzz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 19:55:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:33476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2410900AbgJZXzY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 19:55:24 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 242A820882;
        Mon, 26 Oct 2020 23:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756523;
        bh=kCVvXTqXOvgRirCXkMDjYuGatSpN3Y2PccTgYQlKDUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TySgtbZzv4X/CM8nwMhPNeSQHUjEYlJUgk1j/FDDIRKgAlx5M2jPyPDfKub2IhFgs
         /xJX4xrNMSL6pwm0bbaJeUUPDyXYwcbeSHr7RQHjw84/gpRMUASxnEs/G5WZgj1wfx
         77jFSzTKtCOs4zplmYtqDEqTrr1BTZIer9w2GmJc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhang Qilong <zhangqilong3@huawei.com>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.4 05/80] f2fs: add trace exit in exception path
Date:   Mon, 26 Oct 2020 19:54:01 -0400
Message-Id: <20201026235516.1025100-5-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026235516.1025100-1-sashal@kernel.org>
References: <20201026235516.1025100-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit 9b66482282888d02832b7d90239e1cdb18e4b431 ]

Missing the trace exit in f2fs_sync_dirty_inodes

Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/checkpoint.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index bbd07fe8a4921..3d7f9e20a54bd 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -1044,8 +1044,12 @@ int f2fs_sync_dirty_inodes(struct f2fs_sb_info *sbi, enum inode_type type)
 				get_pages(sbi, is_dir ?
 				F2FS_DIRTY_DENTS : F2FS_DIRTY_DATA));
 retry:
-	if (unlikely(f2fs_cp_error(sbi)))
+	if (unlikely(f2fs_cp_error(sbi))) {
+		trace_f2fs_sync_dirty_inodes_exit(sbi->sb, is_dir,
+				get_pages(sbi, is_dir ?
+				F2FS_DIRTY_DENTS : F2FS_DIRTY_DATA));
 		return -EIO;
+	}
 
 	spin_lock(&sbi->inode_lock[type]);
 
-- 
2.25.1

