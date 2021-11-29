Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04C0B461E79
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:34:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379584AbhK2Sg0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:36:26 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:52318 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379589AbhK2Se0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:34:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 59F07CE157F;
        Mon, 29 Nov 2021 18:31:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96F24C53FCF;
        Mon, 29 Nov 2021 18:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210663;
        bh=4r6Jct0rKKk+7X8RnZ3WUarmw0UVQL1OFoRvrx3uF+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AUXB9Bj5mNJI7Z+UdOz34cW6Bfdbx51SFhYU7wb1qafWZnNWnksw6t8JuN/AWhtuO
         Frq9hwAqWLFA4EPr4C4vWAWU2+6lcmzCCaCfD5X0bgqhNiiSXLcbBswiqSQNicNtSS
         vduBXgo6xNBdM8FqGEOHwFXLICNv/hmH6ZpxLWQ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <chao@kernel.org>,
        Gao Xiang <hsiangkao@linux.alibaba.com>,
        Huang Jianan <huangjianan@oppo.com>,
        Jianhua Hao <haojianhua1@xiaomi.com>,
        Gao Xiang <xiang@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 074/121] erofs: fix deadlock when shrink erofs slab
Date:   Mon, 29 Nov 2021 19:18:25 +0100
Message-Id: <20211129181714.140186215@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181711.642046348@linuxfoundation.org>
References: <20211129181711.642046348@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huang Jianan <huangjianan@oppo.com>

[ Upstream commit 57bbeacdbee72a54eb97d56b876cf9c94059fc34 ]

We observed the following deadlock in the stress test under low
memory scenario:

Thread A                               Thread B
- erofs_shrink_scan
 - erofs_try_to_release_workgroup
  - erofs_workgroup_try_to_freeze -- A
                                       - z_erofs_do_read_page
                                        - z_erofs_collection_begin
                                         - z_erofs_register_collection
                                          - erofs_insert_workgroup
                                           - xa_lock(&sbi->managed_pslots) -- B
                                           - erofs_workgroup_get
                                            - erofs_wait_on_workgroup_freezed -- A
  - xa_erase
   - xa_lock(&sbi->managed_pslots) -- B

To fix this, it needs to hold xa_lock before freezing the workgroup
since xarray will be touched then. So let's hold the lock before
accessing each workgroup, just like what we did with the radix tree
before.

[ Gao Xiang: Jianhua Hao also reports this issue at
  https://lore.kernel.org/r/b10b85df30694bac8aadfe43537c897a@xiaomi.com ]

Link: https://lore.kernel.org/r/20211118135844.3559-1-huangjianan@oppo.com
Fixes: 64094a04414f ("erofs: convert workstn to XArray")
Reviewed-by: Chao Yu <chao@kernel.org>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Huang Jianan <huangjianan@oppo.com>
Reported-by: Jianhua Hao <haojianhua1@xiaomi.com>
Signed-off-by: Gao Xiang <xiang@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/utils.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/erofs/utils.c b/fs/erofs/utils.c
index de9986d2f82fd..5c11199d753a6 100644
--- a/fs/erofs/utils.c
+++ b/fs/erofs/utils.c
@@ -154,7 +154,7 @@ static bool erofs_try_to_release_workgroup(struct erofs_sb_info *sbi,
 	 * however in order to avoid some race conditions, add a
 	 * DBG_BUGON to observe this in advance.
 	 */
-	DBG_BUGON(xa_erase(&sbi->managed_pslots, grp->index) != grp);
+	DBG_BUGON(__xa_erase(&sbi->managed_pslots, grp->index) != grp);
 
 	/* last refcount should be connected with its managed pslot.  */
 	erofs_workgroup_unfreeze(grp, 0);
@@ -169,15 +169,19 @@ static unsigned long erofs_shrink_workstation(struct erofs_sb_info *sbi,
 	unsigned int freed = 0;
 	unsigned long index;
 
+	xa_lock(&sbi->managed_pslots);
 	xa_for_each(&sbi->managed_pslots, index, grp) {
 		/* try to shrink each valid workgroup */
 		if (!erofs_try_to_release_workgroup(sbi, grp))
 			continue;
+		xa_unlock(&sbi->managed_pslots);
 
 		++freed;
 		if (!--nr_shrink)
-			break;
+			return freed;
+		xa_lock(&sbi->managed_pslots);
 	}
+	xa_unlock(&sbi->managed_pslots);
 	return freed;
 }
 
-- 
2.33.0



