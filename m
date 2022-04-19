Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7BCB5060EE
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 02:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240516AbiDSA3G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 20:29:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240521AbiDSA3E (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 20:29:04 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A1E5237F7;
        Mon, 18 Apr 2022 17:26:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 851AACE0B26;
        Tue, 19 Apr 2022 00:26:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4936C385A9;
        Tue, 19 Apr 2022 00:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650327967;
        bh=skNu55G9fCAYKmUyUVwVAlr6+oOI8kBhIluTMIChEXA=;
        h=Date:To:From:Subject:From;
        b=vo7Ig6sxMiR3LvHpZuJyT3HIx9xWT2J3Yamtghj0HNNyzRuI2sSYQjH0vCJLYCaaM
         NBeN+zOIoHBVURiM964F/D0shdK9eBKnZPP/arWw5/m9ZlCKUJYK+p/6X7GrvpHJ2I
         i69+gMb3Hvsl1JbEdkLNe4ysN9JnHyymWvFnRaxg=
Date:   Mon, 18 Apr 2022 17:26:07 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        naoya.horiguchi@nec.com, mike.kravetz@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] hugetlb-do-not-demote-poisoned-hugetlb-pages.patch removed from -mm tree
Message-Id: <20220419002607.C4936C385A9@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: hugetlb: do not demote poisoned hugetlb pages
has been removed from the -mm tree.  Its filename was
     hugetlb-do-not-demote-poisoned-hugetlb-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb: do not demote poisoned hugetlb pages

It is possible for poisoned hugetlb pages to reside on the free lists. 
The huge page allocation routines which dequeue entries from the free
lists make a point of avoiding poisoned pages.  There is no such check and
avoidance in the demote code path.

If a hugetlb page on the is on a free list, poison will only be set in the
head page rather then the page with the actual error.  If such a page is
demoted, then the poison flag may follow the wrong page.  A page without
error could have poison set, and a page with poison could not have the
flag set.

Check for poison before attempting to demote a hugetlb page.  Also, return
-EBUSY to the caller if only poisoned pages are on the free list.

Link: https://lkml.kernel.org/r/20220307215707.50916-1-mike.kravetz@oracle.com
Fixes: 8531fc6f52f5 ("hugetlb: add hugetlb demote page support")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

--- a/mm/hugetlb.c~hugetlb-do-not-demote-poisoned-hugetlb-pages
+++ a/mm/hugetlb.c
@@ -3475,7 +3475,6 @@ static int demote_pool_huge_page(struct
 {
 	int nr_nodes, node;
 	struct page *page;
-	int rc = 0;
 
 	lockdep_assert_held(&hugetlb_lock);
 
@@ -3486,15 +3485,19 @@ static int demote_pool_huge_page(struct
 	}
 
 	for_each_node_mask_to_free(h, nr_nodes, node, nodes_allowed) {
-		if (!list_empty(&h->hugepage_freelists[node])) {
-			page = list_entry(h->hugepage_freelists[node].next,
-					struct page, lru);
-			rc = demote_free_huge_page(h, page);
-			break;
+		list_for_each_entry(page, &h->hugepage_freelists[node], lru) {
+			if (PageHWPoison(page))
+				continue;
+
+			return demote_free_huge_page(h, page);
 		}
 	}
 
-	return rc;
+	/*
+	 * Only way to get here is if all pages on free lists are poisoned.
+	 * Return -EBUSY so that caller will not retry.
+	 */
+	return -EBUSY;
 }
 
 #define HSTATE_ATTR_RO(_name) \
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are


