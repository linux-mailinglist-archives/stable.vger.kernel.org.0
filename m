Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF20313804
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:36:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233431AbhBHPfb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:35:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:32772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232353AbhBHPSV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:18:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 783FA64EC3;
        Mon,  8 Feb 2021 15:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797144;
        bh=7x1RtK3j6ej2txRsFyn5vOqqlVJ+xupbVIGHvKDOdVo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EK2R5cPoVZUDuXMJudPF+OTkX5LwqqUpdpOzYgW6n/B3w7aybZRonkUHm0GYD4fSB
         xI1QwgCgmbaiUS4OCBZ0eMUDmiEmxRrvJaSV8Wuc56z0Me6UENall6gCrgyN3b0ROe
         250ixFh793em9E7iFp73GTgJ09BqqIN0RYdc0v0I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
        Michal Hocko <mhocko@suse.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Oscar Salvador <osalvador@suse.de>,
        David Hildenbrand <david@redhat.com>,
        Yang Shi <shy828301@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 48/65] mm: hugetlbfs: fix cannot migrate the fallocated HugeTLB page
Date:   Mon,  8 Feb 2021 16:01:20 +0100
Message-Id: <20210208145812.074719342@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145810.230485165@linuxfoundation.org>
References: <20210208145810.230485165@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>

commit 585fc0d2871c9318c949fbf45b1f081edd489e96 upstream.

If a new hugetlb page is allocated during fallocate it will not be
marked as active (set_page_huge_active) which will result in a later
isolate_huge_page failure when the page migration code would like to
move that page.  Such a failure would be unexpected and wrong.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/hugetlbfs/inode.c    |    3 ++-
 include/linux/hugetlb.h |    2 ++
 mm/hugetlb.c            |    2 +-
 3 files changed, 5 insertions(+), 2 deletions(-)

--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -675,9 +675,10 @@ static long hugetlbfs_fallocate(struct f
 
 		mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 
+		set_page_huge_active(page);
 		/*
 		 * unlock_page because locked by add_to_page_cache()
-		 * page_put due to reference from alloc_huge_page()
+		 * put_page() due to reference from alloc_huge_page()
 		 */
 		unlock_page(page);
 		put_page(page);
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -590,6 +590,8 @@ static inline void huge_ptep_modify_prot
 }
 #endif
 
+void set_page_huge_active(struct page *page);
+
 #else	/* CONFIG_HUGETLB_PAGE */
 struct hstate {};
 
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1222,7 +1222,7 @@ bool page_huge_active(struct page *page)
 }
 
 /* never called for tail page */
-static void set_page_huge_active(struct page *page)
+void set_page_huge_active(struct page *page)
 {
 	VM_BUG_ON_PAGE(!PageHeadHuge(page), page);
 	SetPagePrivate(&page[1]);


