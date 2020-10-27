Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D03A4299D38
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:06:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437636AbgJ0AEW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 20:04:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:52652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731273AbgJ0AEV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 20:04:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0F39217A0;
        Tue, 27 Oct 2020 00:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603757061;
        bh=beV8sAU5Ov74FqyPYNrNsD5pnjpiG1kjn8L08rk+BbQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2up2gTIn7ZomhyED4AVqVLuJQR7o5E38qT/ATqVAAxJAkABRmh0tcvIdUuoP8iwyU
         Zl1kYrf5DdSVvEdhjpJcDw8kr9y8i7d081hsqBKCIFUtQdc8w9qAzEKSBcmIxz+riK
         4CyS6Z+SKOEQbMHRtTYdMtw4Vz/ZnrN425Yh/ft8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhang Qilong <zhangqilong3@huawei.com>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.19 04/60] f2fs: add trace exit in exception path
Date:   Mon, 26 Oct 2020 20:03:19 -0400
Message-Id: <20201027000415.1026364-4-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201027000415.1026364-1-sashal@kernel.org>
References: <20201027000415.1026364-1-sashal@kernel.org>
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
index 388500eec7291..d412fc150988c 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -1003,8 +1003,12 @@ int f2fs_sync_dirty_inodes(struct f2fs_sb_info *sbi, enum inode_type type)
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

