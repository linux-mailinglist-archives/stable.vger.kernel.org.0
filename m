Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8E446DEFDE
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbjDLIy7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:54:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231447AbjDLIy5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:54:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BD7D9023
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:54:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 706DF631B8
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:53:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57015C433D2;
        Wed, 12 Apr 2023 08:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289634;
        bh=3IoHkviqn8PN/EAomH2O4prchYv3fWvEZxdmkGA0mwY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ggkfryLmgLNkumvSUVW7yoj6jFUAU1Z7NTZ4L5t3zLmWAAd5RDqnvEP9m5VzmtqHo
         AGMOMFxBhxEag5MlUOYuPdfxEKQsHDDoD6F7y4VshrczPrlQ2y271t8OwVu5UL/7w9
         5+6HkSjERaDAR0pH+LVrxzSHvOOLmsJO3tZ9Q8K0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Peter Xu <peterx@redhat.com>,
        Muhammad Usama Anjum <usama.anjum@collabora.com>,
        David Hildenbrand <david@redhat.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.2 153/173] mm/hugetlb: fix uffd wr-protection for CoW optimization path
Date:   Wed, 12 Apr 2023 10:34:39 +0200
Message-Id: <20230412082844.291748407@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Xu <peterx@redhat.com>

commit 60d5b473d61be61ac315e544fcd6a8234a79500e upstream.

This patch fixes an issue that a hugetlb uffd-wr-protected mapping can be
writable even with uffd-wp bit set.  It only happens with hugetlb private
mappings, when someone firstly wr-protects a missing pte (which will
install a pte marker), then a write to the same page without any prior
access to the page.

Userfaultfd-wp trap for hugetlb was implemented in hugetlb_fault() before
reaching hugetlb_wp() to avoid taking more locks that userfault won't
need.  However there's one CoW optimization path that can trigger
hugetlb_wp() inside hugetlb_no_page(), which will bypass the trap.

This patch skips hugetlb_wp() for CoW and retries the fault if uffd-wp bit
is detected.  The new path will only trigger in the CoW optimization path
because generic hugetlb_fault() (e.g.  when a present pte was
wr-protected) will resolve the uffd-wp bit already.  Also make sure
anonymous UNSHARE won't be affected and can still be resolved, IOW only
skip CoW not CoR.

This patch will be needed for v5.19+ hence copy stable.

[peterx@redhat.com: v2]
  Link: https://lkml.kernel.org/r/ZBzOqwF2wrHgBVZb@x1n
[peterx@redhat.com: v3]
  Link: https://lkml.kernel.org/r/20230324142620.2344140-1-peterx@redhat.com
Link: https://lkml.kernel.org/r/20230321191840.1897940-1-peterx@redhat.com
Fixes: 166f3ecc0daf ("mm/hugetlb: hook page faults for uffd write protection")
Signed-off-by: Peter Xu <peterx@redhat.com>
Reported-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Tested-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5476,7 +5476,7 @@ static vm_fault_t hugetlb_wp(struct mm_s
 		       struct page *pagecache_page, spinlock_t *ptl)
 {
 	const bool unshare = flags & FAULT_FLAG_UNSHARE;
-	pte_t pte;
+	pte_t pte = huge_ptep_get(ptep);
 	struct hstate *h = hstate_vma(vma);
 	struct page *old_page, *new_page;
 	int outside_reserve = 0;
@@ -5485,6 +5485,17 @@ static vm_fault_t hugetlb_wp(struct mm_s
 	struct mmu_notifier_range range;
 
 	/*
+	 * Never handle CoW for uffd-wp protected pages.  It should be only
+	 * handled when the uffd-wp protection is removed.
+	 *
+	 * Note that only the CoW optimization path (in hugetlb_no_page())
+	 * can trigger this, because hugetlb_fault() will always resolve
+	 * uffd-wp bit first.
+	 */
+	if (!unshare && huge_pte_uffd_wp(pte))
+		return 0;
+
+	/*
 	 * hugetlb does not support FOLL_FORCE-style write faults that keep the
 	 * PTE mapped R/O such as maybe_mkwrite() would do.
 	 */
@@ -5497,7 +5508,6 @@ static vm_fault_t hugetlb_wp(struct mm_s
 		return 0;
 	}
 
-	pte = huge_ptep_get(ptep);
 	old_page = pte_page(pte);
 
 	delayacct_wpcopy_start();


