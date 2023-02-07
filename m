Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0240468D83B
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:07:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232216AbjBGNHy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:07:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232242AbjBGNHx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:07:53 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1CF73A588
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:07:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 090AFCE1CA5
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:07:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC040C4339C;
        Tue,  7 Feb 2023 13:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675775240;
        bh=uFhBu2r1ZCzedcPp/oxQ4KaA3xtZi3rMQAACOP/fiuc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eFe10IROP6XqSErNNdBu7BVCwlETjAme2ek/d1t4tO4Z36gAdGvPOUo3FAois27Ha
         N2ElP3K/F1P9zY3h9T3P+3OT8TIxTBkNUuHDPZwPEmZ/t7SidYKlKz7fJJ39QQlXHn
         4W9th6QBpMvETKi8zpK7cuHHotWw5c769f7lWeZI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mike Kravetz <mike.kravetz@oracle.com>,
        Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        James Houghton <jthoughton@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Michal Hocko <mhocko@suse.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Naoya Horiguchi <naoya.horiguchi@linux.dev>,
        "Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
        Yang Shi <shy828301@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 176/208] migrate: hugetlb: check for hugetlb shared PMD in node migration
Date:   Tue,  7 Feb 2023 13:57:10 +0100
Message-Id: <20230207125642.419653931@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Kravetz <mike.kravetz@oracle.com>

commit 73bdf65ea74857d7fb2ec3067a3cec0e261b1462 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mempolicy.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -600,7 +600,8 @@ static int queue_pages_hugetlb(pte_t *pt
 
 	/* With MPOL_MF_MOVE, we migrate only unshared hugepage. */
 	if (flags & (MPOL_MF_MOVE_ALL) ||
-	    (flags & MPOL_MF_MOVE && page_mapcount(page) == 1)) {
+	    (flags & MPOL_MF_MOVE && page_mapcount(page) == 1 &&
+	     !hugetlb_pmd_shared(pte))) {
 		if (isolate_hugetlb(page, qp->pagelist) &&
 			(flags & MPOL_MF_STRICT))
 			/*


