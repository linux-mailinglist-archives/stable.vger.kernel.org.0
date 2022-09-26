Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F2C95EB11A
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 21:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbiIZTP4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 15:15:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbiIZTPw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 15:15:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19D19985AA;
        Mon, 26 Sep 2022 12:15:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3701B80D89;
        Mon, 26 Sep 2022 19:15:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E3FEC433C1;
        Mon, 26 Sep 2022 19:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664219740;
        bh=oqeMyrWtVqC8JgFEURs6io8mlue9THUhIJEP4GN2cAY=;
        h=Date:To:From:Subject:From;
        b=jpxXUF4PkjgIabqC+bud1/w83GfxHqdDwgU+jKSZ4KAGusVb3CZNY7dQuKel9rfMh
         RAKkBdngzsr/LHktk1XVrNZmDLEZ0VdVUhQzZmeL0QzWHBtMMkEhBCu0Kcxbf7v8E9
         gHakP6p2WzYH1NoS+EkDa8b2j5sg+yLoXPZY46eg=
Date:   Mon, 26 Sep 2022 12:15:39 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        songmuchun@bytedance.com, osalvador@suse.de,
        mike.kravetz@oracle.com, anshuman.khandual@arm.com,
        opendmb@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-hugetlb-correct-demote-page-offset-logic.patch removed from -mm tree
Message-Id: <20220926191540.5E3FEC433C1@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb: correct demote page offset logic
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-correct-demote-page-offset-logic.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Doug Berger <opendmb@gmail.com>
Subject: mm/hugetlb: correct demote page offset logic
Date: Wed, 14 Sep 2022 12:09:17 -0700

With gigantic pages it may not be true that struct page structures are
contiguous across the entire gigantic page.  The nth_page macro is used
here in place of direct pointer arithmetic to correct for this.

Mike said:

: This error could cause addressing exceptions.  However, this is only
: possible in configurations where CONFIG_SPARSEMEM &&
: !CONFIG_SPARSEMEM_VMEMMAP.  Such a configuration option is rare and
: unknown to be the default anywhere.

Link: https://lkml.kernel.org/r/20220914190917.3517663-1-opendmb@gmail.com
Fixes: 8531fc6f52f5 ("hugetlb: add hugetlb demote page support")
Signed-off-by: Doug Berger <opendmb@gmail.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Muchun Song <songmuchun@bytedance.com>
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


