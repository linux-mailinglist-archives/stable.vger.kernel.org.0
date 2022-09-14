Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A55BB5B8FC5
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 22:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbiINUuf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 16:50:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiINUu1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 16:50:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F43E248C0;
        Wed, 14 Sep 2022 13:50:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 07E6961D3A;
        Wed, 14 Sep 2022 20:50:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57DC8C433D7;
        Wed, 14 Sep 2022 20:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663188625;
        bh=IjmOawu6CY2fACHUkMgsf9urJDo1w9YeQ/6B2GWxhWM=;
        h=Date:To:From:Subject:From;
        b=XqFQ/PHGw6tVWdwruUEyugFXaWoln7adNQbmhqGaK+QcbZQbml0S+SMYOyMCFAO8J
         9zXnzJR2H7yh0eV/JN6jDeD8LtuCjH0WDZmIq5qw/sKb/MxZxiao+Dgz+XPsn9L33r
         9bpD0MPKMaLho4/66uAwm2td3Cqi+6hKfNy8ePqE=
Date:   Wed, 14 Sep 2022 13:50:24 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        songmuchun@bytedance.com, osalvador@suse.de,
        mike.kravetz@oracle.com, opendmb@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-correct-demote-page-offset-logic.patch added to mm-hotfixes-unstable branch
Message-Id: <20220914205025.57DC8C433D7@smtp.kernel.org>
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
     Subject: mm/hugetlb: correct demote page offset logic
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hugetlb-correct-demote-page-offset-logic.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-correct-demote-page-offset-logic.patch

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
From: Doug Berger <opendmb@gmail.com>
Subject: mm/hugetlb: correct demote page offset logic
Date: Wed, 14 Sep 2022 12:09:17 -0700

With gigantic pages it may not be true that struct page structures are
contiguous across the entire gigantic page.  The nth_page macro is used
here in place of direct pointer arithmetic to correct for this.

Link: https://lkml.kernel.org/r/20220914190917.3517663-1-opendmb@gmail.com
Fixes: 8531fc6f52f5 ("hugetlb: add hugetlb demote page support")
Signed-off-by: Doug Berger <opendmb@gmail.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-correct-demote-page-offset-logic
+++ a/mm/hugetlb.c
@@ -3420,6 +3420,7 @@ static int demote_free_huge_page(struct
 {
 	int i, nid = page_to_nid(page);
 	struct hstate *target_hstate;
+	struct page *subpage;
 	int rc = 0;
 
 	target_hstate = size_to_hstate(PAGE_SIZE << h->demote_order);
@@ -3453,15 +3454,16 @@ static int demote_free_huge_page(struct
 	mutex_lock(&target_hstate->resize_lock);
 	for (i = 0; i < pages_per_huge_page(h);
 				i += pages_per_huge_page(target_hstate)) {
+		subpage = nth_page(page, i);
 		if (hstate_is_gigantic(target_hstate))
-			prep_compound_gigantic_page_for_demote(page + i,
+			prep_compound_gigantic_page_for_demote(subpage,
 							target_hstate->order);
 		else
-			prep_compound_page(page + i, target_hstate->order);
-		set_page_private(page + i, 0);
-		set_page_refcounted(page + i);
-		prep_new_huge_page(target_hstate, page + i, nid);
-		put_page(page + i);
+			prep_compound_page(subpage, target_hstate->order);
+		set_page_private(subpage, 0);
+		set_page_refcounted(subpage);
+		prep_new_huge_page(target_hstate, subpage, nid);
+		put_page(subpage);
 	}
 	mutex_unlock(&target_hstate->resize_lock);
 
_

Patches currently in -mm which might be from opendmb@gmail.com are

mm-hugetlb-correct-demote-page-offset-logic.patch

