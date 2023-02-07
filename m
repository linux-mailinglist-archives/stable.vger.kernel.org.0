Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF0A68D257
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 10:16:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231395AbjBGJQL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 04:16:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231382AbjBGJQI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 04:16:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75E84298CB
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 01:16:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2CD60B8184C
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 09:16:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ED77C433EF;
        Tue,  7 Feb 2023 09:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675761364;
        bh=DA/17sOL6UUQteYvO4hrACQQ+xYBi1vaFBl/paiyksk=;
        h=Subject:To:Cc:From:Date:From;
        b=SNo9UMXOTvkBoGIGjSdXEcbZVr8FKocmdffbYPgVmThJ7yvk0V2ZI5nYPesMLawh4
         yxq0mApU4zpdQ2dNTArBSdXHGVuOx1tfSdqsrxnlASesgg51biIyTErorArOlMuMzo
         IYx/8ZtkOCDzt6J3pCoa2gEj+M61qXt6nT2usUcc=
Subject: FAILED: patch "[PATCH] migrate: hugetlb: check for hugetlb shared PMD in node" failed to apply to 5.15-stable tree
To:     mike.kravetz@oracle.com, akpm@linux-foundation.org,
        david@redhat.com, jthoughton@google.com, mhocko@suse.com,
        naoya.horiguchi@linux.dev, peterx@redhat.com, shy828301@gmail.com,
        songmuchun@bytedance.com, stable@vger.kernel.org,
        vishal.moola@gmail.com, willy@infradead.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 07 Feb 2023 10:16:01 +0100
Message-ID: <1675761361103248@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

73bdf65ea748 ("migrate: hugetlb: check for hugetlb shared PMD in node migration")
7ce82f4c3f3e ("mm/migration: return errno when isolate_huge_page failed")
1b7f7e58decc ("mm/gup: Convert check_and_migrate_movable_pages() to use a folio")
f9f38f78c5d5 ("mm: refactor check_and_migrate_movable_pages")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 73bdf65ea74857d7fb2ec3067a3cec0e261b1462 Mon Sep 17 00:00:00 2001
From: Mike Kravetz <mike.kravetz@oracle.com>
Date: Thu, 26 Jan 2023 14:27:21 -0800
Subject: [PATCH] migrate: hugetlb: check for hugetlb shared PMD in node
 migration

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

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 02c8a712282f..f940395667c8 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -600,7 +600,8 @@ static int queue_pages_hugetlb(pte_t *pte, unsigned long hmask,
 
 	/* With MPOL_MF_MOVE, we migrate only unshared hugepage. */
 	if (flags & (MPOL_MF_MOVE_ALL) ||
-	    (flags & MPOL_MF_MOVE && page_mapcount(page) == 1)) {
+	    (flags & MPOL_MF_MOVE && page_mapcount(page) == 1 &&
+	     !hugetlb_pmd_shared(pte))) {
 		if (isolate_hugetlb(page, qp->pagelist) &&
 			(flags & MPOL_MF_STRICT))
 			/*

