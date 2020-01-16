Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A7A613F353
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:42:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387945AbgAPSmM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 13:42:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:52520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390286AbgAPRLf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:11:35 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2DDE24694;
        Thu, 16 Jan 2020 17:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194695;
        bh=DR32DR8d4K1wA9tfWglrMCeUfYTQwAn8k8OglQZW2Ew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XijFdajCpD7HRnwjvT3UCusY80rsZ7TRGe0+wqvy/bMG0cR9nS8AfX73ydvSnxVFG
         bm0ADqUpjF8sxuKLYiy/NCdF1qUAznAm3l0b1798aHDnuYd129QHfPjyHNs+4GlypK
         mCt4abNYy8JHn0Q0XYc0x0zyBn8CYJ2qI14ICtkU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.19 536/671] f2fs: fix wrong error injection path in inc_valid_block_count()
Date:   Thu, 16 Jan 2020 12:02:54 -0500
Message-Id: <20200116170509.12787-273-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit 9ea2f0be6ceaebae1518a5f897cff2645830dd95 ]

If FAULT_BLOCK type error injection is on, in inc_valid_block_count()
we may decrease sbi->alloc_valid_block_count percpu stat count
incorrectly, fix it.

Fixes: 36b877af7992 ("f2fs: Keep alloc_valid_block_count in sync")
Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/f2fs.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 72d154e71bb5..6b5b685af599 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1701,7 +1701,7 @@ static inline int inc_valid_block_count(struct f2fs_sb_info *sbi,
 	if (time_to_inject(sbi, FAULT_BLOCK)) {
 		f2fs_show_injection_info(FAULT_BLOCK);
 		release = *count;
-		goto enospc;
+		goto release_quota;
 	}
 
 	/*
@@ -1741,6 +1741,7 @@ static inline int inc_valid_block_count(struct f2fs_sb_info *sbi,
 
 enospc:
 	percpu_counter_sub(&sbi->alloc_valid_block_count, release);
+release_quota:
 	dquot_release_reservation_block(inode, release);
 	return -ENOSPC;
 }
-- 
2.20.1

