Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68B64157863
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:07:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729582AbgBJNH2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:07:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:37728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729487AbgBJMjl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:39:41 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06FB72465D;
        Mon, 10 Feb 2020 12:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338381;
        bh=Ew29Lcr5t4uxLKFeZ7aqjFO7NYFvymdkq1Q/5unER/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xbi6irP79wF58stEnn7mbGJwtn6uQXDmzB9BReqvLWXB03F1M90v5qfHXHMrZYuoZ
         YANkig0n5uV/XRU6u++dByCUC3g26yNeIzZ99tOf6XOfjTiD13llafQvNbVc760aB8
         zVttjWWevFGyQJ09gRHYiXt/fH1t7JR0KT2pwC/Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Shi <yang.shi@linux.alibaba.com>,
        Michal Hocko <mhocko@suse.com>,
        Wei Yang <richardw.yang@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.5 060/367] mm: move_pages: report the number of non-attempted pages
Date:   Mon, 10 Feb 2020 04:29:33 -0800
Message-Id: <20200210122429.622029875@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Shi <yang.shi@linux.alibaba.com>

commit 5984fabb6e82d9ab4e6305cb99694c85d46de8ae upstream.

Since commit a49bd4d71637 ("mm, numa: rework do_pages_move"), the
semantic of move_pages() has changed to return the number of
non-migrated pages if they were result of a non-fatal reasons (usually a
busy page).

This was an unintentional change that hasn't been noticed except for LTP
tests which checked for the documented behavior.

There are two ways to go around this change.  We can even get back to
the original behavior and return -EAGAIN whenever migrate_pages is not
able to migrate pages due to non-fatal reasons.  Another option would be
to simply continue with the changed semantic and extend move_pages
documentation to clarify that -errno is returned on an invalid input or
when migration simply cannot succeed (e.g.  -ENOMEM, -EBUSY) or the
number of pages that couldn't have been migrated due to ephemeral
reasons (e.g.  page is pinned or locked for other reasons).

This patch implements the second option because this behavior is in
place for some time without anybody complaining and possibly new users
depending on it.  Also it allows to have a slightly easier error
handling as the caller knows that it is worth to retry when err > 0.

But since the new semantic would be aborted immediately if migration is
failed due to ephemeral reasons, need include the number of
non-attempted pages in the return value too.

Link: http://lkml.kernel.org/r/1580160527-109104-1-git-send-email-yang.shi@linux.alibaba.com
Fixes: a49bd4d71637 ("mm, numa: rework do_pages_move")
Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
Suggested-by: Michal Hocko <mhocko@suse.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Wei Yang <richardw.yang@linux.intel.com>
Cc: <stable@vger.kernel.org>    [4.17+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/migrate.c |   25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

--- a/mm/migrate.c
+++ b/mm/migrate.c
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


