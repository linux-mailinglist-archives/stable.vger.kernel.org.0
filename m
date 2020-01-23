Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E016014743A
	for <lists+stable@lfdr.de>; Thu, 23 Jan 2020 23:59:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728803AbgAWW77 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 17:59:59 -0500
Received: from mga03.intel.com ([134.134.136.65]:60764 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727061AbgAWW76 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Jan 2020 17:59:58 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Jan 2020 14:59:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,355,1574150400"; 
   d="scan'208";a="290005495"
Received: from richard.sh.intel.com (HELO localhost) ([10.239.159.54])
  by fmsmga001.fm.intel.com with ESMTP; 23 Jan 2020 14:59:28 -0800
Date:   Fri, 24 Jan 2020 06:59:40 +0800
From:   Wei Yang <richardw.yang@linux.intel.com>
To:     Yang Shi <yang.shi@linux.alibaba.com>
Cc:     mhocko@suse.com, richardw.yang@linux.intel.com,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [v2 PATCH] mm: move_pages: report the number of non-attempted
 pages
Message-ID: <20200123225940.GC29851@richard>
Reply-To: Wei Yang <richardw.yang@linux.intel.com>
References: <1579736331-85494-1-git-send-email-yang.shi@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1579736331-85494-1-git-send-email-yang.shi@linux.alibaba.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 23, 2020 at 07:38:51AM +0800, Yang Shi wrote:
>Since commit a49bd4d71637 ("mm, numa: rework do_pages_move"),
>the semantic of move_pages() was changed to return the number of
>non-migrated pages (failed to migration) and the call would be aborted
>immediately if migrate_pages() returns positive value.  But it didn't
>report the number of pages that we even haven't attempted to migrate.
>So, fix it by including non-attempted pages in the return value.
>
>Fixes: a49bd4d71637 ("mm, numa: rework do_pages_move")
>Suggested-by: Michal Hocko <mhocko@suse.com>
>Cc: Wei Yang <richardw.yang@linux.intel.com>
>Cc: <stable@vger.kernel.org>    [4.17+]
>Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
>---
>v2: Rebased on top of the latest mainline kernel per Andrew
>
> mm/migrate.c | 24 ++++++++++++++++++++++--
> 1 file changed, 22 insertions(+), 2 deletions(-)
>
>diff --git a/mm/migrate.c b/mm/migrate.c
>index 86873b6..9b8eb5d 100644
>--- a/mm/migrate.c
>+++ b/mm/migrate.c
>@@ -1627,8 +1627,18 @@ static int do_pages_move(struct mm_struct *mm, nodemask_t task_nodes,
> 			start = i;
> 		} else if (node != current_node) {
> 			err = do_move_pages_to_node(mm, &pagelist, current_node);
>-			if (err)
>+			if (err) {
>+				/*
>+				 * Positive err means the number of failed
>+				 * pages to migrate.  Since we are going to
>+				 * abort and return the number of non-migrated
>+				 * pages, so need incude the rest of the
>+				 * nr_pages that have not attempted as well.
>+				 */
>+				if (err > 0)
>+					err += nr_pages - i - 1;
> 				goto out;
>+			}
> 			err = store_status(status, start, current_node, i - start);
> 			if (err)
> 				goto out;
>@@ -1659,8 +1669,11 @@ static int do_pages_move(struct mm_struct *mm, nodemask_t task_nodes,
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
>@@ -1674,6 +1687,13 @@ static int do_pages_move(struct mm_struct *mm, nodemask_t task_nodes,
> 
> 	/* Make sure we do not overwrite the existing error */
> 	err1 = do_move_pages_to_node(mm, &pagelist, current_node);
>+	/*
>+	 * Don't have to report non-attempted pages here since:

In previous comment, you use "non-migrated". Here is "non-attempted". What's
the difference?

>+	 *     - If the above loop is done gracefully there is not non-attempted
>+	 *       page.
>+	 *     - If the above loop is aborted to it means more fatal error
>+	 *       happened, should return err.
>+	 */
> 	if (!err1)
> 		err1 = store_status(status, start, current_node, i - start);
> 	if (!err)
>-- 
>1.8.3.1

-- 
Wei Yang
Help you, Help me
