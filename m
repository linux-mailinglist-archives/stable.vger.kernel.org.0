Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB87F323DF1
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:24:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236458AbhBXNUu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:20:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:59886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235318AbhBXNLR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 08:11:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9AAE864FAB;
        Wed, 24 Feb 2021 12:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171330;
        bh=tTT3vaaLWFWUGeDSfPi7gBR6gJfFg8YTldsjtcflZV4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xv/tzTloNmYxn0nmmMcyrL6Vp0udMenG866gLt7jaR9SA+AIudcpk20g9RJOZFIOD
         sXA+khe3qigtADTbltXAMpPErSvXygy/BFIRAj+rVSt5En/QrUgxfN0uqHdyA/LiBI
         x58GHPVX65Uzpsz5jYtljk4nCqnPOV5tzmMFbtM5Go1JgF/gYTXdH0dJGY7IgJpvyw
         ZlT2ccdrQUna7rt5QgqZepBrSP06BTuZBJO7pD7ZLWckCr9IgVJljMYJ4q982bbZY7
         rrmrrmO/6ROvOVB7M9BU6Njb9xAAXJPzfJOFIytdhTwsTzhYb/AEeHozgy17+RuuKk
         3CnOxInF5LmBw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.14 12/16] f2fs: handle unallocated section and zone on pinned/atgc
Date:   Wed, 24 Feb 2021 07:55:09 -0500
Message-Id: <20210224125514.483935-12-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125514.483935-1-sashal@kernel.org>
References: <20210224125514.483935-1-sashal@kernel.org>
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
index 0d46e936d54ed..00c415131b069 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -91,11 +91,11 @@
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

