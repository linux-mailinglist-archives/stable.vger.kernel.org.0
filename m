Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7419F323CD1
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:06:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233491AbhBXM4L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 07:56:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:50210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234112AbhBXMxa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 07:53:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0102464F12;
        Wed, 24 Feb 2021 12:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171082;
        bh=n5JcjEhi872PhCEaGoFNpYBHWSow5ZMF50i74ogSC3k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kk+D3FkGDE5SLU0fzzzOhpaeV2Tp7S3uwP/PLTGQly7MwVqBJ7RELLE8baJQvPoUN
         Ba5PWBvgaebl2nS0CuE76F4CZVo9dpYwzGvXWpuuTW2nGbLxXwAQ31i5FSaA0Hd9x1
         /vvF+GujrAzPACxVt3eDJl8M2HZmyU2CysiUs9P6FEZK/kk9pWJic3hfqKsbLKFi4P
         hzuS2LdU6A5zo0wYobvR8Jhs49SwlyaqA7jB3RoLzMjlUnPTvDYGMousY9TJOzzZf8
         A/lgaxtyVlKikqPBvhEEQBY7XBroQ8gLHWkt3GpIJgiWFH17JpzeCR/abC7POR3RZ/
         lRAk0ZoYnUONQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.11 41/67] f2fs: handle unallocated section and zone on pinned/atgc
Date:   Wed, 24 Feb 2021 07:49:59 -0500
Message-Id: <20210224125026.481804-41-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125026.481804-1-sashal@kernel.org>
References: <20210224125026.481804-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaegeuk Kim <jaegeuk@kernel.org>

[ Upstream commit 632faca72938f9f63049e48a8c438913828ac7a9 ]

If we have large section/zone, unallocated segment makes them corrupted.

E.g.,

  - Pinned file:       -1 119304647 119304647
  - ATGC   data:       -1 119304647 119304647

Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/segment.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index e81eb0748e2a9..229814b4f4a6c 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -101,11 +101,11 @@ static inline void sanity_check_seg_type(struct f2fs_sb_info *sbi,
 #define BLKS_PER_SEC(sbi)					\
 	((sbi)->segs_per_sec * (sbi)->blocks_per_seg)
 #define GET_SEC_FROM_SEG(sbi, segno)				\
-	((segno) / (sbi)->segs_per_sec)
+	(((segno) == -1) ? -1: (segno) / (sbi)->segs_per_sec)
 #define GET_SEG_FROM_SEC(sbi, secno)				\
 	((secno) * (sbi)->segs_per_sec)
 #define GET_ZONE_FROM_SEC(sbi, secno)				\
-	((secno) / (sbi)->secs_per_zone)
+	(((secno) == -1) ? -1: (secno) / (sbi)->secs_per_zone)
 #define GET_ZONE_FROM_SEG(sbi, segno)				\
 	GET_ZONE_FROM_SEC(sbi, GET_SEC_FROM_SEG(sbi, segno))
 
-- 
2.27.0

