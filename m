Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 579426036A2
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 01:22:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbiJRXWm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Oct 2022 19:22:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbiJRXWm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Oct 2022 19:22:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41535844E2;
        Tue, 18 Oct 2022 16:22:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C902E61722;
        Tue, 18 Oct 2022 23:22:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24D00C433C1;
        Tue, 18 Oct 2022 23:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666135360;
        bh=53EgLV8THlQKFhucfc5gdASUZP2V34kTvC26+04/kFY=;
        h=Date:To:From:Subject:From;
        b=K7g2iyEaO4ApbtH4fCfZ3mL1xKF79smzVAZIh/+7CrlqLvgjbh/Ln+oror892oF05
         0XHLwQsppeE6Dyhi70p5t2DJNy61aHo3d1QVzE4gGgM1B9dndiO9X8GhLORBC+qtkf
         R3Ety31fJuvxlTsXsihyO73pDQNErDrv7CHKBZrc=
Date:   Tue, 18 Oct 2022 16:22:39 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        songmuchun@bytedance.com, n-horiguchi@ah.jp.nec.com,
        mike.kravetz@oracle.com, gkmccready@meta.com, riel@surriel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mmhugetlb-take-hugetlb_lock-before-decrementing-h-resv_huge_pages.patch added to mm-hotfixes-unstable branch
Message-Id: <20221018232240.24D00C433C1@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm,hugetlb: take hugetlb_lock before decrementing h->resv_huge_pages
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mmhugetlb-take-hugetlb_lock-before-decrementing-h-resv_huge_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmhugetlb-take-hugetlb_lock-before-decrementing-h-resv_huge_pages.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

mmhugetlb-take-hugetlb_lock-before-decrementing-h-resv_huge_pages.patch

