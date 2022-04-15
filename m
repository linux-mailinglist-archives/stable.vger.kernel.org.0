Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD8DE502056
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 04:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348604AbiDOCQW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 22:16:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344722AbiDOCQV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 22:16:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73C981FCE9;
        Thu, 14 Apr 2022 19:13:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36716B82B9C;
        Fri, 15 Apr 2022 02:13:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAC8DC385A5;
        Fri, 15 Apr 2022 02:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649988833;
        bh=tfzIATRIEssyLcoxMcSK4FK9aTSQ+1j3NcOkbDQ7poc=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=v/8PQkr+vBRUpzYoyAmDsMC+FNaZgdN/7JjM3DKfCiYwBLv6+jLoHNhyFO/WXr4nE
         qwYN7QphbtQ2twQUh41vVFFcq26ZFTNE2J2Pa1ZMeHscAi6Dmzf8UrkdvtS8E4gXaU
         8W4r2EC1yrQq12n3IP9HxmOuyhmN3FFe2PbB89YE=
Date:   Thu, 14 Apr 2022 19:13:52 -0700
To:     stable@vger.kernel.org, naoya.horiguchi@nec.com,
        mike.kravetz@oracle.com, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220414191240.9f86d15a3e3afd848a9839a6@linux-foundation.org>
Subject: [patch 10/14] hugetlb: do not demote poisoned hugetlb pages
Message-Id: <20220415021352.EAC8DC385A5@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
