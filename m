Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE821606EF4
	for <lists+stable@lfdr.de>; Fri, 21 Oct 2022 06:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229449AbiJUEf7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Oct 2022 00:35:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbiJUEfK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Oct 2022 00:35:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E22EC24F11;
        Thu, 20 Oct 2022 21:34:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42D70B82989;
        Fri, 21 Oct 2022 04:34:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBD71C433D6;
        Fri, 21 Oct 2022 04:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666326893;
        bh=TUl/gJDCfAae1deRvSSY2yuu0Bmz0WExYdDqNgx7S+E=;
        h=Date:To:From:Subject:From;
        b=oz2VtFzg5UiHl9r+LaKHyBH/N2mpdZjKoF8+efm+zaxuuyrubouigHNpo5e1UHCBV
         buK3p7LDSF7L1ThSDbl1zjGTXgi7/jGEfXUCVQJUvaH6QsjlY9PjzdL4nQbtKiWEKa
         /Q8ydS1SmAaNq8VMyftWZ6rcnMi/QjNXEz/2wyys=
Date:   Thu, 20 Oct 2022 21:34:52 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        songmuchun@bytedance.com, n-horiguchi@ah.jp.nec.com,
        mike.kravetz@oracle.com, gkmccready@meta.com, riel@surriel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mmhugetlb-take-hugetlb_lock-before-decrementing-h-resv_huge_pages.patch removed from -mm tree
Message-Id: <20221021043452.DBD71C433D6@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm,hugetlb: take hugetlb_lock before decrementing h->resv_huge_pages
has been removed from the -mm tree.  Its filename was
     mmhugetlb-take-hugetlb_lock-before-decrementing-h-resv_huge_pages.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Rik van Riel <riel@surriel.com>
Subject: mm,hugetlb: take hugetlb_lock before decrementing h->resv_huge_pages
Date: Mon, 17 Oct 2022 20:25:05 -0400

The h->*_huge_pages counters are protected by the hugetlb_lock, but
alloc_huge_page has a corner case where it can decrement the counter
outside of the lock.

This could lead to a corrupted value of h->resv_huge_pages, which we have
observed on our systems.

Take the hugetlb_lock before decrementing h->resv_huge_pages to avoid a
potential race.

Link: https://lkml.kernel.org/r/20221017202505.0e6a4fcd@imladris.surriel.com
Fixes: a88c76954804 ("mm: hugetlb: fix hugepage memory leak caused by wrong reserve count")
Signed-off-by: Rik van Riel <riel@surriel.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Glen McCready <gkmccready@meta.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~mmhugetlb-take-hugetlb_lock-before-decrementing-h-resv_huge_pages
+++ a/mm/hugetlb.c
@@ -2924,11 +2924,11 @@ struct page *alloc_huge_page(struct vm_a
 		page = alloc_buddy_huge_page_with_mpol(h, vma, addr);
 		if (!page)
 			goto out_uncharge_cgroup;
+		spin_lock_irq(&hugetlb_lock);
 		if (!avoid_reserve && vma_has_reserves(vma, gbl_chg)) {
 			SetHPageRestoreReserve(page);
 			h->resv_huge_pages--;
 		}
-		spin_lock_irq(&hugetlb_lock);
 		list_add(&page->lru, &h->hugepage_activelist);
 		set_page_refcounted(page);
 		/* Fall through */
_

Patches currently in -mm which might be from riel@surriel.com are


