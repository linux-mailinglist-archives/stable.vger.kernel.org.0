Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A20D2502A9
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 18:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728208AbgHXQfX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 12:35:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:39210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728114AbgHXQfR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 12:35:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70D08207CD;
        Mon, 24 Aug 2020 16:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598286911;
        bh=dzdvycN+vMiUHofR3jvJMXhONIaGcrfVUdqphJBV+ck=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SdkG+sUDQCwz9jH9NB45+btThmJHi+0ec+QixnGB9HtQQsAB7winb8X0iShy62z/j
         qqeHzqgv2CdaeVURzOG3m1idjLkpIVB2OtB7wyP5qau81qw5gXbSIXvTWKMscGVvX3
         s7XwgKf/c4qyR+BtLdGp5cNaJ5bCO9pfqGxv2b00=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alex Zhuravlev <azhuravlev@whamcloud.com>,
        Andreas Dilger <adilger@whamcloud.com>,
        Artem Blagodarenko <artem.blagodarenko@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 05/63] ext4: skip non-loaded groups at cr=0/1 when scanning for good groups
Date:   Mon, 24 Aug 2020 12:34:05 -0400
Message-Id: <20200824163504.605538-5-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200824163504.605538-1-sashal@kernel.org>
References: <20200824163504.605538-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Zhuravlev <azhuravlev@whamcloud.com>

[ Upstream commit c1d2c7d47e15482bb23cda83a5021e60f624a09c ]

cr=0 is supposed to be an optimization to save CPU cycles, but if
buddy data (in memory) is not initialized then all this makes no sense
as we have to do sync IO taking a lot of cycles.  Also, at cr=0
mballoc doesn't choose any available chunk.  cr=1 also skips groups
using heuristic based on avg. fragment size.  It's more useful to skip
such groups and switch to cr=2 where groups will be scanned for
available chunks.  However, we always read the first block group in a
flex_bg so metadata blocks will get read into the first flex_bg if
possible.

Using sparse image and dm-slow virtual device of 120TB was
simulated, then the image was formatted and filled using debugfs to
mark ~85% of available space as busy.  mount process w/o the patch
couldn't complete in half an hour (according to vmstat it would take
~10-11 hours).  With the patch applied mount took ~20 seconds.

Lustre-bug-id: https://jira.whamcloud.com/browse/LU-12988
Signed-off-by: Alex Zhuravlev <azhuravlev@whamcloud.com>
Reviewed-by: Andreas Dilger <adilger@whamcloud.com>
Reviewed-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/mballoc.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index c0a331e2feb02..9ed108b5bd7fd 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2177,6 +2177,7 @@ static int ext4_mb_good_group_nolock(struct ext4_allocation_context *ac,
 {
 	struct ext4_group_info *grp = ext4_get_group_info(ac->ac_sb, group);
 	struct super_block *sb = ac->ac_sb;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	bool should_lock = ac->ac_flags & EXT4_MB_STRICT_CHECK;
 	ext4_grpblk_t free;
 	int ret = 0;
@@ -2195,7 +2196,25 @@ static int ext4_mb_good_group_nolock(struct ext4_allocation_context *ac,
 
 	/* We only do this if the grp has never been initialized */
 	if (unlikely(EXT4_MB_GRP_NEED_INIT(grp))) {
-		ret = ext4_mb_init_group(ac->ac_sb, group, GFP_NOFS);
+		struct ext4_group_desc *gdp =
+			ext4_get_group_desc(sb, group, NULL);
+		int ret;
+
+		/* cr=0/1 is a very optimistic search to find large
+		 * good chunks almost for free.  If buddy data is not
+		 * ready, then this optimization makes no sense.  But
+		 * we never skip the first block group in a flex_bg,
+		 * since this gets used for metadata block allocation,
+		 * and we want to make sure we locate metadata blocks
+		 * in the first block group in the flex_bg if possible.
+		 */
+		if (cr < 2 &&
+		    (!sbi->s_log_groups_per_flex ||
+		     ((group & ((1 << sbi->s_log_groups_per_flex) - 1)) != 0)) &&
+		    !(ext4_has_group_desc_csum(sb) &&
+		      (gdp->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT))))
+			return 0;
+		ret = ext4_mb_init_group(sb, group, GFP_NOFS);
 		if (ret)
 			return ret;
 	}
-- 
2.25.1

