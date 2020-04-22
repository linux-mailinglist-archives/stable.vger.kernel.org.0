Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 529D51B3E35
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728776AbgDVK0V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:26:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:35190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730696AbgDVK0U (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:26:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7E5E2075A;
        Wed, 22 Apr 2020 10:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587551180;
        bh=8qfY1PhpS8YCU7EkMHPLz0aR2nf5Kwu2pnxThzBrBOc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SMOfQojdQOwgcmIokc6ZxTwvxpDSObjDajfMJyG5rHtat/GAEXYsLuR44Q6wK1kaP
         IT9L9lDMZGugykgOy/mXFyIdznF5x8ZUiYz49wTtRNiWlTqwxACtMFP1rmGav2fC9L
         ooB/6FoCS56D1xWUYfpqZsxEkrUD1PA8g9sssaWY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 133/166] f2fs: skip GC when section is full
Date:   Wed, 22 Apr 2020 11:57:40 +0200
Message-Id: <20200422095102.895727071@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095047.669225321@linuxfoundation.org>
References: <20200422095047.669225321@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaegeuk Kim <jaegeuk@kernel.org>

[ Upstream commit 2bac07635ddf9ed59268e61e415d8de9c5eaded7 ]

This fixes skipping GC when segment is full in large section.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/gc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 2f645c591a000..3cced15efebc2 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -1018,8 +1018,8 @@ static int gc_data_segment(struct f2fs_sb_info *sbi, struct f2fs_summary *sum,
 		 * race condition along with SSR block allocation.
 		 */
 		if ((gc_type == BG_GC && has_not_enough_free_secs(sbi, 0, 0)) ||
-				get_valid_blocks(sbi, segno, false) ==
-							sbi->blocks_per_seg)
+				get_valid_blocks(sbi, segno, true) ==
+							BLKS_PER_SEC(sbi))
 			return submitted;
 
 		if (check_valid_map(sbi, segno, off) == 0)
-- 
2.20.1



