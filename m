Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52C3E14A87D
	for <lists+stable@lfdr.de>; Mon, 27 Jan 2020 17:58:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726004AbgA0Q6B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jan 2020 11:58:01 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:59686 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725930AbgA0Q6B (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jan 2020 11:58:01 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=yang.shi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0TocxOzG_1580144268;
Received: from localhost(mailfrom:yang.shi@linux.alibaba.com fp:SMTPD_---0TocxOzG_1580144268)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 28 Jan 2020 00:57:56 +0800
From:   Yang Shi <yang.shi@linux.alibaba.com>
To:     mhocko@suse.com, richardw.yang@linux.intel.com,
        akpm@linux-foundation.org
Cc:     yang.shi@linux.alibaba.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [v3 PATCH] mm: move_pages: report the number of non-attempted pages
Date:   Tue, 28 Jan 2020 00:57:48 +0800
Message-Id: <1580144268-79620-1-git-send-email-yang.shi@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since commit 49bd4d71637 ("mm, numa: rework do_pages_move"),
the semantic of move_pages() has changed to return the number of
non-migrated pages if they were result of a non-fatal reasons (usually a
busy page).  This was an unintentional change that hasn't been noticed
except for LTP tests which checked for the documented behavior.

There are two ways to go around this change.  We can even get back to the
original behavior and return -EAGAIN whenever migrate_pages is not able
to migrate pages due to non-fatal reasons.  Another option would be to
simply continue with the changed semantic and extend move_pages
documentation to clarify that -errno is returned on an invalid input or
when migration simply cannot succeed (e.g. -ENOMEM, -EBUSY) or the
number of pages that couldn't have been migrated due to ephemeral
reasons (e.g. page is pinned or locked for other reasons).

This patch implements the second option because this behavior is in
place for some time without anybody complaining and possibly new users
depending on it.  Also it allows to have a slightly easier error handling
as the caller knows that it is worth to retry when err > 0.

But since the new semantic would be aborted immediately if migration is
failed due to ephemeral reasons, need include the number of non-attempted
pages in the return value too.

Fixes: a49bd4d71637 ("mm, numa: rework do_pages_move")
Suggested-by: Michal Hocko <mhocko@suse.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Wei Yang <richardw.yang@linux.intel.com>
Cc: <stable@vger.kernel.org>    [4.17+]
Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
---
v3: Rephrased the commit log per Michal and added Michal's Acked-by
v2: Rebased on top of the latest mainline kernel per Andrew

 mm/migrate.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 86873b6..9b8eb5d 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1627,8 +1627,18 @@ static int do_pages_move(struct mm_struct *mm, nodemask_t task_nodes,
 			start = i;
 		} else if (node != current_node) {
 			err = do_move_pages_to_node(mm, &pagelist, current_node);
-			if (err)
+			if (err) {
+				/*
+				 * Possitive err means the number of failed
+				 * pages to migrate.  Since we are going to
+				 * abort and return the number of non-migrated
+				 * pages, so need incude the rest of the
+				 * nr_pages that have not attempted as well.
+				 */
+				if (err > 0)
+					err += nr_pages - i - 1;
 				goto out;
+			}
 			err = store_status(status, start, current_node, i - start);
 			if (err)
 				goto out;
@@ -1659,8 +1669,11 @@ static int do_pages_move(struct mm_struct *mm, nodemask_t task_nodes,
 			goto out_flush;
 
 		err = do_move_pages_to_node(mm, &pagelist, current_node);
-		if (err)
+		if (err) {
+			if (err > 0)
+				err += nr_pages - i - 1;
 			goto out;
+		}
 		if (i > start) {
 			err = store_status(status, start, current_node, i - start);
 			if (err)
@@ -1674,6 +1687,13 @@ static int do_pages_move(struct mm_struct *mm, nodemask_t task_nodes,
 
 	/* Make sure we do not overwrite the existing error */
 	err1 = do_move_pages_to_node(mm, &pagelist, current_node);
+	/*
+	 * Don't have to report non-attempted pages here since:
+	 *     - If the above loop is done gracefully there is not non-attempted
+	 *       page.
+	 *     - If the above loop is aborted to it means more fatal error
+	 *       happened, should return err.
+	 */   
 	if (!err1)
 		err1 = store_status(status, start, current_node, i - start);
 	if (!err)
-- 
1.8.3.1

