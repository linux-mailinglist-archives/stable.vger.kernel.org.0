Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6C4F3102D1
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 03:33:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbhBECcy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Feb 2021 21:32:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:45558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230205AbhBECcw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Feb 2021 21:32:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0572564FB6;
        Fri,  5 Feb 2021 02:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612492331;
        bh=kbll5D4ZbhMog5kqLpZHwTVIcRhyuoEWzqh9o47MoW4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=M04fxGupr5nVaKNJi2DFBpl0WXYUL+zd77rkTBYVVu7uAr8SiKiAHzcWZdwtm3WIg
         dkU2PKDn3vBVGITDBvzs+kRbLs75rqTeyWTpXUHp84AlTsSWltz4Imt4M6inX/a9Vn
         WyDNOutGzdqsd1JSV8J7mlef36eFohhmtLIgeVaM=
Date:   Thu, 04 Feb 2021 18:32:10 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, linux-mm@kvack.org,
        mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, osalvador@suse.de, shy828301@gmail.com,
        songmuchun@bytedance.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 03/18] mm: hugetlb: fix a race between isolating
 and freeing page
Message-ID: <20210205023210.CbSNsXPxg%akpm@linux-foundation.org>
In-Reply-To: <20210204183135.e123f0d6027529f2cf500cf2@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: hugetlb: fix a race between isolating and freeing page

There is a race between isolate_huge_page() and __free_huge_page().

CPU0:                                       CPU1:

if (PageHuge(page))
                                            put_page(page)
                                              __free_huge_page(page)
                                                  spin_lock(&hugetlb_lock)
                                                  update_and_free_page(page)
                                                    set_compound_page_dtor(page,
                                                      NULL_COMPOUND_DTOR)
                                                  spin_unlock(&hugetlb_lock)
  isolate_huge_page(page)
    // trigger BUG_ON
    VM_BUG_ON_PAGE(!PageHead(page), page)
    spin_lock(&hugetlb_lock)
    page_huge_active(page)
      // trigger BUG_ON
      VM_BUG_ON_PAGE(!PageHuge(page), page)
    spin_unlock(&hugetlb_lock)

When we isolate a HugeTLB page on CPU0. Meanwhile, we free it to the
buddy allocator on CPU1. Then, we can trigger a BUG_ON on CPU0. Because
it is already freed to the buddy allocator.

Link: https://lkml.kernel.org/r/20210115124942.46403-5-songmuchun@bytedance.com
Fixes: c8721bbbdd36 ("mm: memory-hotplug: enable memory hotplug to handle hugepage")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-a-race-between-isolating-and-freeing-page
+++ a/mm/hugetlb.c
@@ -5594,9 +5594,9 @@ bool isolate_huge_page(struct page *page
 {
 	bool ret = true;
 
-	VM_BUG_ON_PAGE(!PageHead(page), page);
 	spin_lock(&hugetlb_lock);
-	if (!page_huge_active(page) || !get_page_unless_zero(page)) {
+	if (!PageHeadHuge(page) || !page_huge_active(page) ||
+	    !get_page_unless_zero(page)) {
 		ret = false;
 		goto unlock;
 	}
_
