Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4695414AD3C
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 01:34:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726080AbgA1Aeb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jan 2020 19:34:31 -0500
Received: from mga11.intel.com ([192.55.52.93]:59246 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725955AbgA1Aeb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jan 2020 19:34:31 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Jan 2020 16:34:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,371,1574150400"; 
   d="scan'208";a="261263777"
Received: from richard.sh.intel.com (HELO localhost) ([10.239.159.54])
  by fmsmga002.fm.intel.com with ESMTP; 27 Jan 2020 16:34:27 -0800
Date:   Tue, 28 Jan 2020 08:34:40 +0800
From:   Wei Yang <richardw.yang@linux.intel.com>
To:     Yang Shi <yang.shi@linux.alibaba.com>
Cc:     mhocko@suse.com, richardw.yang@linux.intel.com,
        willy@infradead.org, akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [v4 PATCH] mm: move_pages: report the number of non-attempted
 pages
Message-ID: <20200128003440.GB20624@richard>
Reply-To: Wei Yang <richardw.yang@linux.intel.com>
References: <1580160527-109104-1-git-send-email-yang.shi@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1580160527-109104-1-git-send-email-yang.shi@linux.alibaba.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 28, 2020 at 05:28:47AM +0800, Yang Shi wrote:
>Since commit a49bd4d71637 ("mm, numa: rework do_pages_move"),
>the semantic of move_pages() has changed to return the number of
>non-migrated pages if they were result of a non-fatal reasons (usually a
>busy page).  This was an unintentional change that hasn't been noticed
>except for LTP tests which checked for the documented behavior.
>
>There are two ways to go around this change.  We can even get back to the
>original behavior and return -EAGAIN whenever migrate_pages is not able
>to migrate pages due to non-fatal reasons.  Another option would be to
>simply continue with the changed semantic and extend move_pages
>documentation to clarify that -errno is returned on an invalid input or
>when migration simply cannot succeed (e.g. -ENOMEM, -EBUSY) or the
>number of pages that couldn't have been migrated due to ephemeral
>reasons (e.g. page is pinned or locked for other reasons).
>
>This patch implements the second option because this behavior is in
>place for some time without anybody complaining and possibly new users
>depending on it.  Also it allows to have a slightly easier error handling
>as the caller knows that it is worth to retry when err > 0.
>
>But since the new semantic would be aborted immediately if migration is
>failed due to ephemeral reasons, need include the number of non-attempted
>pages in the return value too.
>
>Fixes: a49bd4d71637 ("mm, numa: rework do_pages_move")
>Suggested-by: Michal Hocko <mhocko@suse.com>
>Acked-by: Michal Hocko <mhocko@suse.com>
>Cc: Wei Yang <richardw.yang@linux.intel.com>
>Cc: <stable@vger.kernel.org>    [4.17+]
>Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>

Reviewed-by: Wei Yang <richardw.yang@linux.intel.com>

>---
>v4: Fixed some typo and grammar errors caught by Willy
>v3: Rephrased the commit log per Michal and added Michal's Acked-by
>v2: Rebased on top of the latest mainline kernel per Andrew
>
> mm/migrate.c | 25 +++++++++++++++++++++++--
> 1 file changed, 23 insertions(+), 2 deletions(-)
>
>diff --git a/mm/migrate.c b/mm/migrate.c
>index 86873b6..2530860 100644
>--- a/mm/migrate.c
>+++ b/mm/migrate.c
>@@ -1627,8 +1627,19 @@ static int do_pages_move(struct mm_struct *mm, nodemask_t task_nodes,
> 			start = i;
> 		} else if (node != current_node) {
> 			err = do_move_pages_to_node(mm, &pagelist, current_node);
>-			if (err)
>+			if (err) {
>+				/*
>+				 * Positive err means the number of failed
>+				 * pages to migrate.  Since we are going to
>+				 * abort and return the number of non-migrated
>+				 * pages, so need to incude the rest of the
>+				 * nr_pages that have not been attempted as
>+				 * well.
>+				 */
>+				if (err > 0)
>+					err += nr_pages - i - 1;
> 				goto out;
>+			}
> 			err = store_status(status, start, current_node, i - start);
> 			if (err)
> 				goto out;
>@@ -1659,8 +1670,11 @@ static int do_pages_move(struct mm_struct *mm, nodemask_t task_nodes,
> 			goto out_flush;
> 
> 		err = do_move_pages_to_node(mm, &pagelist, current_node);
>-		if (err)
>+		if (err) {
>+			if (err > 0)
>+				err += nr_pages - i - 1;
> 			goto out;
>+		}
> 		if (i > start) {
> 			err = store_status(status, start, current_node, i - start);
> 			if (err)
>@@ -1674,6 +1688,13 @@ static int do_pages_move(struct mm_struct *mm, nodemask_t task_nodes,
> 
> 	/* Make sure we do not overwrite the existing error */
> 	err1 = do_move_pages_to_node(mm, &pagelist, current_node);
>+	/*
>+	 * Don't have to report non-attempted pages here since:
>+	 *     - If the above loop is done gracefully all pages have been
>+	 *       attempted.
>+	 *     - If the above loop is aborted it means a fatal error
>+	 *       happened, should return ret.
>+	 */
> 	if (!err1)
> 		err1 = store_status(status, start, current_node, i - start);
> 	if (!err)
>-- 
>1.8.3.1

-- 
Wei Yang
Help you, Help me
