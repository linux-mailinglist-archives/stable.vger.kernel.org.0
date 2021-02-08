Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E921313AD4
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 18:25:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234886AbhBHRYd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 12:24:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:35240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234895AbhBHRXU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 12:23:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6E9564EC8;
        Mon,  8 Feb 2021 17:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612804875;
        bh=r4k4aNNbQQPvmqWODdj8iy8w7SE3it+KGhs0QKLspAw=;
        h=Date:From:To:Subject:From;
        b=EoEt4hPbGbp2i8ib1fRx7/BvjvcfcrI+uupM55xyaN8OfKXqXFx6aoAU8/rGuENz4
         wS25D8h6i+YJ6JvgD7IhnF9zwVYG9YPOKa6cM9o5K/UVdFCqhkq9UabaKDddaURlx1
         D47dERbF13XV0Pp0RLk9iAd9erwTAxjqmlEOktoU=
Date:   Mon, 08 Feb 2021 09:21:15 -0800
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        stable@vger.kernel.org
Subject:  [merged]
 mm-hugetlb-fix-missing-put_page-in-gather_surplus_pages.patch removed from
 -mm tree
Message-ID: <20210208172115.0a5gX6R45%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: hugetlb: fix missing put_page in gather_surplus_pages()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-missing-put_page-in-gather_surplus_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: hugetlb: fix missing put_page in gather_surplus_pages()

The VM_BUG_ON_PAGE avoids the generation of any code, even if that
expression has side-effects when !CONFIG_DEBUG_VM.

Link: https://lkml.kernel.org/r/20210126031009.96266-1-songmuchun@bytedance.com
Fixes: e5dfacebe4a4 ("mm/hugetlb.c: just use put_page_testzero() instead of page_count()")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-missing-put_page-in-gather_surplus_pages
+++ a/mm/hugetlb.c
@@ -2047,13 +2047,16 @@ retry:
 
 	/* Free the needed pages to the hugetlb pool */
 	list_for_each_entry_safe(page, tmp, &surplus_list, lru) {
+		int zeroed;
+
 		if ((--needed) < 0)
 			break;
 		/*
 		 * This page is now managed by the hugetlb allocator and has
 		 * no users -- drop the buddy allocator's reference.
 		 */
-		VM_BUG_ON_PAGE(!put_page_testzero(page), page);
+		zeroed = put_page_testzero(page);
+		VM_BUG_ON_PAGE(!zeroed, page);
 		enqueue_huge_page(h, page);
 	}
 free:
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-memcontrol-optimize-per-lruvec-stats-counter-memory-usage.patch
mm-memcontrol-fix-nr_anon_thps-accounting-in-charge-moving.patch
mm-memcontrol-convert-nr_anon_thps-account-to-pages.patch
mm-memcontrol-convert-nr_file_thps-account-to-pages.patch
mm-memcontrol-convert-nr_shmem_thps-account-to-pages.patch
mm-memcontrol-convert-nr_shmem_pmdmapped-account-to-pages.patch
mm-memcontrol-convert-nr_file_pmdmapped-account-to-pages.patch
mm-memcontrol-make-the-slab-calculation-consistent.patch
mm-memcontrol-replace-the-loop-with-a-list_for_each_entry.patch
hugetlb-convert-page_huge_active-hpagemigratable-flag-fix.patch

