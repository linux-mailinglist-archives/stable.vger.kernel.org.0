Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0885E406295
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232010AbhIJAqB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:46:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:47680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233860AbhIJAVz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:21:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CDAC5611AF;
        Fri, 10 Sep 2021 00:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233245;
        bh=MnGVpVdK97dQEsvJqPe76SatuOM9qfsxF4TwlOnen3U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R8gfg9tR5YqMmT1E5z7mVzxbyAKUDZVoaLY0QmRZB56jO1kBp3S+mEhyxOfeGB8K4
         /SS/b/HTnGSFq9YP4D/DyVRfFYL4a+u3864qYbCAp3S9NoU8AXBiQPlZI4tMSdd5Fg
         JRt5nNs7KJfP4adA9N2uL85D3zuJN14IKZdwwYuiLUnMFoacVzvUoO9iknP3aCL9OZ
         nz/TykG2aauGrQiPT7IvbZTxlW66wxUlDrYlNzqs6qjl2j2bSDKRVBo1I5mstlGGWN
         WBP85ooeZmWbz7nzFD6jYRWzra2a4bSM9SOk3TvDJ4IKpg8+Cm4GOBiYmvftTDwofN
         frTQRlH8vyHFw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Laibin Qiu <qiulaibin@huawei.com>, Chao Yu <chao@kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.10 12/53] f2fs: fix min_seq_blocks can not make sense in some scenes.
Date:   Thu,  9 Sep 2021 20:19:47 -0400
Message-Id: <20210910002028.175174-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910002028.175174-1-sashal@kernel.org>
References: <20210910002028.175174-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laibin Qiu <qiulaibin@huawei.com>

[ Upstream commit dc675a97129c4d9d5af55a3d7f23d7e092b8e032 ]

F2FS have dirty page count control for batched sequential
write in writepages, and get the value of min_seq_blocks by
blocks_per_seg * segs_per_sec(segs_per_sec defaults to 1).
But in some scenes we set a lager section size, Min_seq_blocks
will become too large to achieve the expected effect(eg. 4thread
sequential write, the number of merge requests will be reduced).

Signed-off-by: Laibin Qiu <qiulaibin@huawei.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/segment.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index d04b449978aa..730f028e8f49 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -5109,7 +5109,7 @@ int f2fs_build_segment_manager(struct f2fs_sb_info *sbi)
 		sm_info->ipu_policy = 1 << F2FS_IPU_FSYNC;
 	sm_info->min_ipu_util = DEF_MIN_IPU_UTIL;
 	sm_info->min_fsync_blocks = DEF_MIN_FSYNC_BLOCKS;
-	sm_info->min_seq_blocks = sbi->blocks_per_seg * sbi->segs_per_sec;
+	sm_info->min_seq_blocks = sbi->blocks_per_seg;
 	sm_info->min_hot_blocks = DEF_MIN_HOT_BLOCKS;
 	sm_info->min_ssr_sections = reserved_sections(sbi);
 
-- 
2.30.2

