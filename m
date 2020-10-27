Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A2B9299F07
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437313AbgJ0ATj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 20:19:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:58368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2411492AbgJ0AJw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 20:09:52 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 470B220882;
        Tue, 27 Oct 2020 00:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603757392;
        bh=5S1rs6NOrOWMe2uOzaXWV/lIDXcLcthwTI1R72Whxt4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mJl97OoKMI1XKXRJhYsmaZUrlBxEFgzh19DkgFp8050gTUuT1e4gAAt8XCiSSoqLB
         O+rcLNHyrIsUShx9i3ae3akAgGuMjsyK8lTGwR3ly8tRed25ZBm/42zA3Wd6ypGqtu
         nSU8gqFG6ltYPjfhDBQF2XqNFmRsfN1TRnQSBJJc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhang Qilong <zhangqilong3@huawei.com>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.14 04/46] f2fs: add trace exit in exception path
Date:   Mon, 26 Oct 2020 20:09:03 -0400
Message-Id: <20201027000946.1026923-4-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201027000946.1026923-1-sashal@kernel.org>
References: <20201027000946.1026923-1-sashal@kernel.org>
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
index 170423ff27210..eab37a7dca5f5 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -942,8 +942,12 @@ int sync_dirty_inodes(struct f2fs_sb_info *sbi, enum inode_type type)
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

