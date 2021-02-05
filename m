Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 246F13102D0
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 03:33:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230208AbhBECcv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Feb 2021 21:32:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:45444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230196AbhBECcp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Feb 2021 21:32:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C267764FB5;
        Fri,  5 Feb 2021 02:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612492324;
        bh=wO7JDv5iUq5UBRYLDqqgzS9Pn6nL3dsNlzx3vMC1jMQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=2ENTE3S+uALxsM14oC/u7e2la/Bcq5IhURbYlNzUHEi8EDb3OHM/EAiMv6G5TPLmN
         19Qg8mtf+Bk5TA/LGmZzHdiPd3BbxFGZxK/i5B7qtcxFF92jDhWikuxnVU73Nlm7hd
         urqlxYtAZqx7aknkH5t8aTw/U14JOq+egWwQBlHc=
Date:   Thu, 04 Feb 2021 18:32:03 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, linux-mm@kvack.org,
        mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, osalvador@suse.de, shy828301@gmail.com,
        songmuchun@bytedance.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 01/18] mm: hugetlbfs: fix cannot migrate the
 fallocated HugeTLB page
Message-ID: <20210205023203.MmSvWEbBn%akpm@linux-foundation.org>
In-Reply-To: <20210204183135.e123f0d6027529f2cf500cf2@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: hugetlbfs: fix cannot migrate the fallocated HugeTLB page

If a new hugetlb page is allocated during fallocate it will not be marked
as active (set_page_huge_active) which will result in a later
isolate_huge_page failure when the page migration code would like to move
that page.  Such a failure would be unexpected and wrong.

Only export set_page_huge_active, just leave clear_page_huge_active as
static.  Because there are no external users.

Link: https://lkml.kernel.org/r/20210115124942.46403-3-songmuchun@bytedance.com
Fixes: 70c3547e36f5 (hugetlbfs: add hugetlbfs_fallocate())
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c    |    3 ++-
 include/linux/hugetlb.h |    2 ++
 mm/hugetlb.c            |    2 +-
 3 files changed, 5 insertions(+), 2 deletions(-)

--- a/fs/hugetlbfs/inode.c~mm-hugetlbfs-fix-cannot-migrate-the-fallocated-hugetlb-page
+++ a/fs/hugetlbfs/inode.c
@@ -735,9 +735,10 @@ static long hugetlbfs_fallocate(struct f
 
 		mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 
+		set_page_huge_active(page);
 		/*
 		 * unlock_page because locked by add_to_page_cache()
-		 * page_put due to reference from alloc_huge_page()
+		 * put_page() due to reference from alloc_huge_page()
 		 */
 		unlock_page(page);
 		put_page(page);
--- a/include/linux/hugetlb.h~mm-hugetlbfs-fix-cannot-migrate-the-fallocated-hugetlb-page
+++ a/include/linux/hugetlb.h
@@ -770,6 +770,8 @@ static inline void huge_ptep_modify_prot
 }
 #endif
 
+void set_page_huge_active(struct page *page);
+
 #else	/* CONFIG_HUGETLB_PAGE */
 struct hstate {};
 
--- a/mm/hugetlb.c~mm-hugetlbfs-fix-cannot-migrate-the-fallocated-hugetlb-page
+++ a/mm/hugetlb.c
@@ -1349,7 +1349,7 @@ bool page_huge_active(struct page *page)
 }
 
 /* never called for tail page */
-static void set_page_huge_active(struct page *page)
+void set_page_huge_active(struct page *page)
 {
 	VM_BUG_ON_PAGE(!PageHeadHuge(page), page);
 	SetPagePrivate(&page[1]);
_
