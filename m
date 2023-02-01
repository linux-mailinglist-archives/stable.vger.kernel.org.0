Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0A0B685C59
	for <lists+stable@lfdr.de>; Wed,  1 Feb 2023 01:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231881AbjBAApl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 19:45:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231825AbjBAApV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Jan 2023 19:45:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57FB5518F3;
        Tue, 31 Jan 2023 16:45:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 11B43B81FCC;
        Wed,  1 Feb 2023 00:45:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A39EBC433EF;
        Wed,  1 Feb 2023 00:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675212315;
        bh=EWTgTEOIMxG1EfqFDsYGH1ozZkMpoOJN84Jo4ZGShQ0=;
        h=Date:To:From:Subject:From;
        b=KQwV2KLq0oc6Y4OTcC4Je6LWKS2Ih2MhOwbR4XxggOvFx1voGCOBWbnc10OHkE6qs
         fnKN4ai1YgIW0ZwOkmoivYhOJMHyonlEY1O/MCfTcBUgnrHOu2PjFx7in8deVh6fT5
         Ws8OazmshLg4QEYQWnx+aRvMD5hjTOoGp7FJ2t/0=
Date:   Tue, 31 Jan 2023 16:45:15 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vishal.moola@gmail.com, stable@vger.kernel.org,
        songmuchun@bytedance.com, shy828301@gmail.com, peterx@redhat.com,
        naoya.horiguchi@linux.dev, mhocko@suse.com, jthoughton@google.com,
        david@redhat.com, mike.kravetz@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] migrate-hugetlb-check-for-hugetlb-shared-pmd-in-node-migration.patch removed from -mm tree
Message-Id: <20230201004515.A39EBC433EF@smtp.kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: migrate: hugetlb: check for hugetlb shared PMD in node migration
has been removed from the -mm tree.  Its filename was
     migrate-hugetlb-check-for-hugetlb-shared-pmd-in-node-migration.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: migrate: hugetlb: check for hugetlb shared PMD in node migration
Date: Thu, 26 Jan 2023 14:27:21 -0800

migrate_pages/mempolicy semantics state that CAP_SYS_NICE is required to
move pages shared with another process to a different node.  page_mapcount
> 1 is being used to determine if a hugetlb page is shared.  However, a
hugetlb page will have a mapcount of 1 if mapped by multiple processes via
a shared PMD.  As a result, hugetlb pages shared by multiple processes and
mapped with a shared PMD can be moved by a process without CAP_SYS_NICE.

To fix, check for a shared PMD if mapcount is 1.  If a shared PMD is found
consider the page shared.

Link: https://lkml.kernel.org/r/20230126222721.222195-3-mike.kravetz@oracle.com
Fixes: e2d8cf405525 ("migrate: add hugepage migration code to migrate_pages()")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Peter Xu <peterx@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/mempolicy.c~migrate-hugetlb-check-for-hugetlb-shared-pmd-in-node-migration
+++ a/mm/mempolicy.c
@@ -600,7 +600,8 @@ static int queue_pages_hugetlb(pte_t *pt
 
 	/* With MPOL_MF_MOVE, we migrate only unshared hugepage. */
 	if (flags & (MPOL_MF_MOVE_ALL) ||
-	    (flags & MPOL_MF_MOVE && page_mapcount(page) == 1)) {
+	    (flags & MPOL_MF_MOVE && page_mapcount(page) == 1 &&
+	     !hugetlb_pmd_shared(pte))) {
 		if (isolate_hugetlb(page, qp->pagelist) &&
 			(flags & MPOL_MF_STRICT))
 			/*
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are


