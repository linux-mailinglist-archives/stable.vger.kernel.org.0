Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B7C2141619
	for <lists+stable@lfdr.de>; Sat, 18 Jan 2020 06:26:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725793AbgARF0y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Jan 2020 00:26:54 -0500
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:44113 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725385AbgARF0y (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Jan 2020 00:26:54 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01f04455;MF=yang.shi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0To.bGaW_1579325203;
Received: from localhost(mailfrom:yang.shi@linux.alibaba.com fp:SMTPD_---0To.bGaW_1579325203)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 18 Jan 2020 13:26:51 +0800
From:   Yang Shi <yang.shi@linux.alibaba.com>
To:     mhocko@suse.com, richardw.yang@linux.intel.com,
        akpm@linux-foundation.org
Cc:     yang.shi@linux.alibaba.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] mm: move_pages: fix the return value if there are not-migrated pages
Date:   Sat, 18 Jan 2020 13:26:43 +0800
Message-Id: <1579325203-16405-1-git-send-email-yang.shi@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The do_move_pages_to_node() might return > 0 value, the number of pages
that are not migrated, then the value will be returned to userspace
directly.  But, move_pages() syscall would just return 0 or errno.  So,
we need reset the return value to 0 for such case as what pre-v4.17 did.

Fixes: a49bd4d71637 ("mm, numa: rework do_pages_move")
Cc: Michal Hocko <mhocko@suse.com>
Cc: Wei Yang <richardw.yang@linux.intel.com>
Cc: <stable@vger.kernel.org>    [4.17+]
Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
---
 mm/migrate.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 86873b6..3e75432 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1659,8 +1659,11 @@ static int do_pages_move(struct mm_struct *mm, nodemask_t task_nodes,
 			goto out_flush;
 
 		err = do_move_pages_to_node(mm, &pagelist, current_node);
-		if (err)
+		if (err) {
+			if (err > 0)
+				err = 0;
 			goto out;
+		}
 		if (i > start) {
 			err = store_status(status, start, current_node, i - start);
 			if (err)
-- 
1.8.3.1

