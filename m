Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6C0323D9B
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:18:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234833AbhBXNNs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:13:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:58106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235744AbhBXNGH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 08:06:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F157364F84;
        Wed, 24 Feb 2021 12:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171252;
        bh=ehgJ3IMWWrx00CYOP8miAjtNa1ImwWvNCz/P8PnmuXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tmcEQW+w/RQ6gNd3lGVFghYBEBL1SV3rhb9Ha1PgBZAdTaa6QyvzOd8uB0jb0q9ZV
         v0vvqnMhGxuH2YLvghbmzjt7D2ZLob/aycZ3XJtHzdNux2flr01dxm/RmHG8YxEaem
         P0bR+HcC8jR0KdR6auCCUt98l7EiUPyUzU2/4KonGoIOxGABY5lZK2/YtvK21eVKB1
         gBflfIJc1SSKjWyBfrr2ZQDV4mBaTOieXP3dNkvbl2rIG6YZze0IAoEI4UwyMdJMGr
         Xq4RizFcqh18SknnodToTmCQK9T9Cd91bLsAwJxLWRob12K0shJaZXa3aDApIBLjg5
         3y80EM8mEvXHw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.4 23/40] f2fs: handle unallocated section and zone on pinned/atgc
Date:   Wed, 24 Feb 2021 07:53:23 -0500
Message-Id: <20210224125340.483162-23-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125340.483162-1-sashal@kernel.org>
References: <20210224125340.483162-1-sashal@kernel.org>
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
index 325781a1ae4d6..2034b9a07d632 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -88,11 +88,11 @@
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

