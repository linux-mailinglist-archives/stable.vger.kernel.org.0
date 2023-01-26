Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5166867D8BE
	for <lists+stable@lfdr.de>; Thu, 26 Jan 2023 23:48:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232719AbjAZWsY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Jan 2023 17:48:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232988AbjAZWsW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Jan 2023 17:48:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 762833E098;
        Thu, 26 Jan 2023 14:48:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2B8C9B81F31;
        Thu, 26 Jan 2023 22:48:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5CF9C433EF;
        Thu, 26 Jan 2023 22:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674773296;
        bh=JHYtMO8JqsaXugOrfIgxQQU/dzx1jV4AWt2zAjd/JoU=;
        h=Date:To:From:Subject:From;
        b=gSCaz7txm7jAv+1RtbxL2A5/Cq5giVqtBKA/U/xaYJFs6jVGZt3gy1JkcQh6rq2VI
         7ADp4e16BfyqUPL4xLJ+n63apRzuBjzQ3HvqE8BYly+uPdC2IwMQ3o7emaqh+PzoTq
         UXcd+Wd113ZNiSCXsFRvdxiR+fkrdGwTSelTVc3E=
Date:   Thu, 26 Jan 2023 14:48:16 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vishal.moola@gmail.com, stable@vger.kernel.org,
        songmuchun@bytedance.com, shy828301@gmail.com, peterx@redhat.com,
        naoya.horiguchi@linux.dev, mhocko@suse.com, jthoughton@google.com,
        david@redhat.com, mike.kravetz@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + migrate-hugetlb-check-for-hugetlb-shared-pmd-in-node-migration.patch added to mm-hotfixes-unstable branch
Message-Id: <20230126224816.C5CF9C433EF@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: migrate: hugetlb: check for hugetlb shared PMD in node migration
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     migrate-hugetlb-check-for-hugetlb-shared-pmd-in-node-migration.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/migrate-hugetlb-check-for-hugetlb-shared-pmd-in-node-migration.patch

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
Cc: David Hildenbrand <david@redhat.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
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

mm-hugetlb-proc-check-for-hugetlb-shared-pmd-in-proc-pid-smaps.patch
migrate-hugetlb-check-for-hugetlb-shared-pmd-in-node-migration.patch

