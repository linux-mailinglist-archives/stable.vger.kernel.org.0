Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2519A6DF02
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730696AbfGSEDu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:03:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:35898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730663AbfGSEDt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:03:49 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA24A21873;
        Fri, 19 Jul 2019 04:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563509028;
        bh=6t3CAgcV6XpPNrDoO83vKqpOcFu/CSfxU4by1Tzh9ak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C67vdf5t9Z+5JwrG1y3twhkSetpI6EVw3xCtdQmcE7Trf5CVxTneLRZoB6rkxkBQb
         HbtdGkEetDPQavYNjmcM6kj+tABVi6YLfjBrIGUVKoKxPLXRVb+9bk/m+VrsWiWZxT
         k0zOabNveYOB2fr8BZ66m8dgPHd+oveUrvAOrLWc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Rosenberg <drosen@google.com>, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.1 028/141] f2fs: Fix accounting for unusable blocks
Date:   Fri, 19 Jul 2019 00:00:53 -0400
Message-Id: <20190719040246.15945-28-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719040246.15945-1-sashal@kernel.org>
References: <20190719040246.15945-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Rosenberg <drosen@google.com>

[ Upstream commit a4c3ecaaadac5693f555cfef1c9eecf4c39df818 ]

Fixes possible underflows when dealing with unusable blocks.

Signed-off-by: Daniel Rosenberg <drosen@google.com>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/f2fs.h | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 2ba2478d0663..f1157d5c62bb 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1761,8 +1761,12 @@ static inline int inc_valid_block_count(struct f2fs_sb_info *sbi,
 
 	if (!__allow_reserved_blocks(sbi, inode, true))
 		avail_user_block_count -= F2FS_OPTION(sbi).root_reserved_blocks;
-	if (unlikely(is_sbi_flag_set(sbi, SBI_CP_DISABLED)))
-		avail_user_block_count -= sbi->unusable_block_count;
+	if (unlikely(is_sbi_flag_set(sbi, SBI_CP_DISABLED))) {
+		if (avail_user_block_count > sbi->unusable_block_count)
+			avail_user_block_count -= sbi->unusable_block_count;
+		else
+			avail_user_block_count = 0;
+	}
 	if (unlikely(sbi->total_valid_block_count > avail_user_block_count)) {
 		diff = sbi->total_valid_block_count - avail_user_block_count;
 		if (diff > *count)
@@ -1958,7 +1962,7 @@ static inline int inc_valid_node_count(struct f2fs_sb_info *sbi,
 					struct inode *inode, bool is_inode)
 {
 	block_t	valid_block_count;
-	unsigned int valid_node_count;
+	unsigned int valid_node_count, user_block_count;
 	int err;
 
 	if (is_inode) {
@@ -1985,10 +1989,11 @@ static inline int inc_valid_node_count(struct f2fs_sb_info *sbi,
 
 	if (!__allow_reserved_blocks(sbi, inode, false))
 		valid_block_count += F2FS_OPTION(sbi).root_reserved_blocks;
+	user_block_count = sbi->user_block_count;
 	if (unlikely(is_sbi_flag_set(sbi, SBI_CP_DISABLED)))
-		valid_block_count += sbi->unusable_block_count;
+		user_block_count -= sbi->unusable_block_count;
 
-	if (unlikely(valid_block_count > sbi->user_block_count)) {
+	if (unlikely(valid_block_count > user_block_count)) {
 		spin_unlock(&sbi->stat_lock);
 		goto enospc;
 	}
-- 
2.20.1

