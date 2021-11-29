Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ACED461F59
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:43:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354448AbhK2SqU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:46:20 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:49634 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379150AbhK2SoT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:44:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5DDB2B815DB;
        Mon, 29 Nov 2021 18:41:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9298FC53FAD;
        Mon, 29 Nov 2021 18:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211259;
        bh=V73cLJ+zzysoUf/aYo6l1AtV0Q+OdtXJ5QElqBgZQIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eN4NzPl3FDl6ABfZt0SM30flr6ZrV071d4MVW1o+sZ+YEXLYObHYXRLbzKjv0faAM
         XYHWeqNthWZZSizrdWbZGAGHcN87KB9gcDqKSvCSPuN7i+CjMOBfDl/vQcda+K6sdG
         HI6dih8b5I61H3P2wpvT/ijjJN/2wEiYUrV52r4k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <chao@kernel.org>,
        Gao Xiang <hsiangkao@linux.alibaba.com>,
        Huang Jianan <huangjianan@oppo.com>,
        Jianhua Hao <haojianhua1@xiaomi.com>,
        Gao Xiang <xiang@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 117/179] erofs: fix deadlock when shrink erofs slab
Date:   Mon, 29 Nov 2021 19:18:31 +0100
Message-Id: <20211129181722.810555788@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
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
index bd86067a63f7f..3ca703cd5b24a 100644
--- a/fs/erofs/utils.c
+++ b/fs/erofs/utils.c
@@ -141,7 +141,7 @@ static bool erofs_try_to_release_workgroup(struct erofs_sb_info *sbi,
 	 * however in order to avoid some race conditions, add a
 	 * DBG_BUGON to observe this in advance.
 	 */
-	DBG_BUGON(xa_erase(&sbi->managed_pslots, grp->index) != grp);
+	DBG_BUGON(__xa_erase(&sbi->managed_pslots, grp->index) != grp);
 
 	/* last refcount should be connected with its managed pslot.  */
 	erofs_workgroup_unfreeze(grp, 0);
@@ -156,15 +156,19 @@ static unsigned long erofs_shrink_workstation(struct erofs_sb_info *sbi,
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



