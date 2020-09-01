Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30D1C2596D3
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726078AbgIAQHC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:07:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:52004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727822AbgIAPkm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:40:42 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85FD6206EB;
        Tue,  1 Sep 2020 15:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974839;
        bh=FGEpyt6GCQ/OKko2vrktbyKSjARDqjIfUWy9AUyVQI0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ROV10gFoR+dYD0Bj19XMmf00/Vj3kyyAGwfo8LETGjwgS4jEShVaGzyXQZopM79EV
         LGexedE5uNjgPqvfNxscIzP1kXWl8NAcnMAh2mmuCCEkQwjlJJE9GeIWjgfTJIKssE
         CwdRM+99gaIOR7psfPW7lukaV1E6EbjdH9W5Ahgk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Zhuravlev <azhuravlev@whamcloud.com>,
        Andreas Dilger <adilger@whamcloud.com>,
        Artem Blagodarenko <artem.blagodarenko@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 110/255] ext4: skip non-loaded groups at cr=0/1 when scanning for good groups
Date:   Tue,  1 Sep 2020 17:09:26 +0200
Message-Id: <20200901151005.988860380@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 38719c156573c..ba5371b35b09e 100644
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



