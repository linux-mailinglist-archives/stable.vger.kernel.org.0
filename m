Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15D18145C8C
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 20:40:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725884AbgAVTkC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 14:40:02 -0500
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:47982 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725827AbgAVTkC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jan 2020 14:40:02 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07484;MF=yang.shi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0ToMZIoB_1579721990;
Received: from localhost(mailfrom:yang.shi@linux.alibaba.com fp:SMTPD_---0ToMZIoB_1579721990)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 23 Jan 2020 03:39:58 +0800
From:   Yang Shi <yang.shi@linux.alibaba.com>
To:     mhocko@suse.com, richardw.yang@linux.intel.com,
        akpm@linux-foundation.org
Cc:     yang.shi@linux.alibaba.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] mm: move_pages: report the number of non-attempted pages
Date:   Thu, 23 Jan 2020 03:39:50 +0800
Message-Id: <1579721990-18672-1-git-send-email-yang.shi@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since commit a49bd4d71637 ("mm, numa: rework do_pages_move"),
the semantic of move_pages() was changed to return the number of
non-migrated pages (failed to migration) and the call would be aborted
immediately if migrate_pages() returns positive value.  But it didn't
report the number of pages that we even haven't attempted to migrate.
So, fix it by including non-attempted pages in the return value.

Fixes: a49bd4d71637 ("mm, numa: rework do_pages_move")
Suggested-by: Michal Hocko <mhocko@suse.com>
Cc: Wei Yang <richardw.yang@linux.intel.com>
Cc: <stable@vger.kernel.org>    [4.17+]
Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
---
The patch is based off Wei Yang's cleanup patchset:
https://lore.kernel.org/linux-mm/20200122011647.13636-1-richardw.yang@linux.intel.com/T/#t

 mm/migrate.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 591f2e5..51b1b76 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1582,7 +1582,7 @@ static int add_page_for_migration(struct mm_struct *mm, unsigned long addr,
 
 static int move_pages_and_store_status(struct mm_struct *mm, int node,
 		struct list_head *pagelist, int __user *status,
-		int start, int nr)
+		int start, int nr, unsigned long total)
 {
 	int err;
 
@@ -1590,8 +1590,17 @@ static int move_pages_and_store_status(struct mm_struct *mm, int node,
 		return 0;
 
 	err = do_move_pages_to_node(mm, pagelist, node);
-	if (err)
+	if (err) {
+		/*
+		 * Possitive err means the number of failed pages to
+		 * migrate.  Since we are going to abort and return the
+		 * number of non-migrated pages, so need incude the rest
+		 * of the nr_pages that are not attempted as well.
+		 */
+		if (err > 0)
+			err += total - start - nr - 1;
 		return err;
+	}
 	err = store_status(status, start, node, nr);
 	return err;
 }
@@ -1640,7 +1649,8 @@ static int do_pages_move(struct mm_struct *mm, nodemask_t task_nodes,
 			start = i;
 		} else if (node != current_node) {
 			err = move_pages_and_store_status(mm, current_node,
-					&pagelist, status, start, i - start);
+					&pagelist, status, start, i - start,
+					nr_pages);
 			if (err)
 				goto out;
 			start = i;
@@ -1670,7 +1680,7 @@ static int do_pages_move(struct mm_struct *mm, nodemask_t task_nodes,
 			goto out_flush;
 
 		err = move_pages_and_store_status(mm, current_node, &pagelist,
-				status, start, i - start);
+				status, start, i - start, nr_pages);
 		if (err)
 			goto out;
 		current_node = NUMA_NO_NODE;
@@ -1678,7 +1688,7 @@ static int do_pages_move(struct mm_struct *mm, nodemask_t task_nodes,
 out_flush:
 	/* Make sure we do not overwrite the existing error */
 	err1 = move_pages_and_store_status(mm, current_node, &pagelist,
-				status, start, i - start);
+				status, start, i - start, nr_pages);
 	if (err >= 0)
 		err = err1;
 out:
-- 
1.8.3.1

