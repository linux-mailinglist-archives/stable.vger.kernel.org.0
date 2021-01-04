Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D54F92E99D8
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:07:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728560AbhADQDw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 11:03:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:41406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728024AbhADQDw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 11:03:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7B7E207AE;
        Mon,  4 Jan 2021 16:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609776191;
        bh=JQtq7FxcglCU79ILboju5l5AL9giFdw3TA6cxNOZBlU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WTQxaeVZneErTrlFNv0VpJltv6B6rfvC1B5xymxXcoaM/OBKQMeGnr5FVJMXNjkhf
         7oOEJyNNH0iU72p5G4LiNDVFW5i+ct+hbn/AAkVd3z8bbZ8pmRs1RVcApyzPp+/iol
         cyxtu925y/crOmewliE+aYSF2jX7He8DF5P9RNmw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tosk Robot <tencent_os_robot@tencent.com>,
        Chunguang Xu <brookxu@tencent.com>,
        Samuel Liao <samuelliao@tencent.com>,
        Andreas Dilger <adilger@dilger.ca>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 62/63] ext4: avoid s_mb_prefetch to be zero in individual scenarios
Date:   Mon,  4 Jan 2021 16:57:55 +0100
Message-Id: <20210104155711.810538946@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210104155708.800470590@linuxfoundation.org>
References: <20210104155708.800470590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chunguang Xu <brookxu@tencent.com>

[ Upstream commit 82ef1370b0c1757ab4ce29f34c52b4e93839b0aa ]

Commit cfd732377221 ("ext4: add prefetching for block allocation
bitmaps") introduced block bitmap prefetch, and expects to read block
bitmaps of flex_bg through an IO.  However, it seems to ignore the
value range of s_log_groups_per_flex.  In the scenario where the value
of s_log_groups_per_flex is greater than 27, s_mb_prefetch or
s_mb_prefetch_limit will overflow, cause a divide zero exception.

In addition, the logic of calculating nr is also flawed, because the
size of flexbg is fixed during a single mount, but s_mb_prefetch can
be modified, which causes nr to fail to meet the value condition of
[1, flexbg_size].

To solve this problem, we need to set the upper limit of
s_mb_prefetch.  Since we expect to load block bitmaps of a flex_bg
through an IO, we can consider determining a reasonable upper limit
among the IO limit parameters.  After consideration, we chose
BLK_MAX_SEGMENT_SIZE.  This is a good choice to solve divide zero
problem and avoiding performance degradation.

[ Some minor code simplifications to make the changes easy to follow -- TYT ]

Reported-by: Tosk Robot <tencent_os_robot@tencent.com>
Signed-off-by: Chunguang Xu <brookxu@tencent.com>
Reviewed-by: Samuel Liao <samuelliao@tencent.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Link: https://lore.kernel.org/r/1607051143-24508-1-git-send-email-brookxu@tencent.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/mballoc.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 37a619bf1ac7c..e67d5de6f28ca 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2395,9 +2395,9 @@ ext4_mb_regular_allocator(struct ext4_allocation_context *ac)
 
 				nr = sbi->s_mb_prefetch;
 				if (ext4_has_feature_flex_bg(sb)) {
-					nr = (group / sbi->s_mb_prefetch) *
-						sbi->s_mb_prefetch;
-					nr = nr + sbi->s_mb_prefetch - group;
+					nr = 1 << sbi->s_log_groups_per_flex;
+					nr -= group & (nr - 1);
+					nr = min(nr, sbi->s_mb_prefetch);
 				}
 				prefetch_grp = ext4_mb_prefetch(sb, group,
 							nr, &prefetch_ios);
@@ -2733,7 +2733,8 @@ static int ext4_mb_init_backend(struct super_block *sb)
 
 	if (ext4_has_feature_flex_bg(sb)) {
 		/* a single flex group is supposed to be read by a single IO */
-		sbi->s_mb_prefetch = 1 << sbi->s_es->s_log_groups_per_flex;
+		sbi->s_mb_prefetch = min(1 << sbi->s_es->s_log_groups_per_flex,
+			BLK_MAX_SEGMENT_SIZE >> (sb->s_blocksize_bits - 9));
 		sbi->s_mb_prefetch *= 8; /* 8 prefetch IOs in flight at most */
 	} else {
 		sbi->s_mb_prefetch = 32;
-- 
2.27.0



