Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1BC14ABB0
	for <lists+stable@lfdr.de>; Mon, 27 Jan 2020 22:33:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725955AbgA0Vdw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jan 2020 16:33:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:50770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725946AbgA0Vdw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jan 2020 16:33:52 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8B4E2465B;
        Mon, 27 Jan 2020 21:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580160831;
        bh=dqyyLd+f6lrZa2+Ga+9KqLmmcz7yKP7WQo/qZzkgmp0=;
        h=Date:From:To:Subject:From;
        b=EcmSrgKSjtP6xbvyN7oKE1W5hvZytFWJWDVd2aVZxPtM1o++mnDsPstvKN8MWIT0I
         z9VxdFYR0Zitx1toKnpNZ/Q6eys3z18E2TnUksOR/DK0o73lYoqj9Q+0oKkdULEGOt
         kGt3KFaZ7cET0G70Er5cEE+AollJGClM8jZRsAuk=
Date:   Mon, 27 Jan 2020 13:33:50 -0800
From:   akpm@linux-foundation.org
To:     mhocko@suse.com, mm-commits@vger.kernel.org,
        richardw.yang@linux.intel.com, stable@vger.kernel.org,
        yang.shi@linux.alibaba.com
Subject:  +
 mm-move_pages-report-the-number-of-non-attempted-pages.patch added to -mm
 tree
Message-ID: <20200127213350.vCt6QvmJu%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: move_pages: report the number of non-attempted pages
has been added to the -mm tree.  Its filename is
     mm-move_pages-report-the-number-of-non-attempted-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-move_pages-report-the-number-of-non-attempted-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-move_pages-report-the-number-of-non-attempted-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yang Shi <yang.shi@linux.alibaba.com>
Subject: mm: move_pages: report the number of non-attempted pages

Since commit a49bd4d71637 ("mm, numa: rework do_pages_move"), the semantic
of move_pages() has changed to return the number of non-migrated pages if
they were result of a non-fatal reasons (usually a busy page).  This was
an unintentional change that hasn't been noticed except for LTP tests
which checked for the documented behavior.

There are two ways to go around this change.  We can even get back to the
original behavior and return -EAGAIN whenever migrate_pages is not able to
migrate pages due to non-fatal reasons.  Another option would be to simply
continue with the changed semantic and extend move_pages documentation to
clarify that -errno is returned on an invalid input or when migration
simply cannot succeed (e.g.  -ENOMEM, -EBUSY) or the number of pages that
couldn't have been migrated due to ephemeral reasons (e.g.  page is pinned
or locked for other reasons).

This patch implements the second option because this behavior is in place
for some time without anybody complaining and possibly new users depending
on it.  Also it allows to have a slightly easier error handling as the
caller knows that it is worth to retry when err > 0.

But since the new semantic would be aborted immediately if migration is
failed due to ephemeral reasons, need include the number of non-attempted
pages in the return value too.

Link: http://lkml.kernel.org/r/1580160527-109104-1-git-send-email-yang.shi@linux.alibaba.com
Fixes: a49bd4d71637 ("mm, numa: rework do_pages_move")
Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
Suggested-by: Michal Hocko <mhocko@suse.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Wei Yang <richardw.yang@linux.intel.com>
Cc: <stable@vger.kernel.org>    [4.17+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

--- a/mm/migrate.c~mm-move_pages-report-the-number-of-non-attempted-pages
+++ a/mm/migrate.c
@@ -1627,8 +1627,19 @@ static int do_pages_move(struct mm_struc
 			start = i;
 		} else if (node != current_node) {
 			err = do_move_pages_to_node(mm, &pagelist, current_node);
-			if (err)
+			if (err) {
+				/*
+				 * Positive err means the number of failed
+				 * pages to migrate.  Since we are going to
+				 * abort and return the number of non-migrated
+				 * pages, so need to incude the rest of the
+				 * nr_pages that have not been attempted as
+				 * well.
+				 */
+				if (err > 0)
+					err += nr_pages - i - 1;
 				goto out;
+			}
 			err = store_status(status, start, current_node, i - start);
 			if (err)
 				goto out;
@@ -1659,8 +1670,11 @@ static int do_pages_move(struct mm_struc
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
@@ -1674,6 +1688,13 @@ out_flush:
 
 	/* Make sure we do not overwrite the existing error */
 	err1 = do_move_pages_to_node(mm, &pagelist, current_node);
+	/*
+	 * Don't have to report non-attempted pages here since:
+	 *     - If the above loop is done gracefully all pages have been
+	 *       attempted.
+	 *     - If the above loop is aborted it means a fatal error
+	 *       happened, should return ret.
+	 */
 	if (!err1)
 		err1 = store_status(status, start, current_node, i - start);
 	if (err >= 0)
_

Patches currently in -mm which might be from yang.shi@linux.alibaba.com are

mm-move_pages-report-the-number-of-non-attempted-pages.patch

