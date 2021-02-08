Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDFD83136A2
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:14:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232317AbhBHPM2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:12:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:55544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232460AbhBHPIs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:08:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE75164E7C;
        Mon,  8 Feb 2021 15:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612796795;
        bh=P7ETVWnObIK3YqlHFJh396rT5cS7w98vlNpsXS75r38=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EDNYAp1s6/t2/tdpwuogVxaturV/x7eNccP59LQvgxZw3a8sxADDOKPjMkr8kcHNm
         9ZS3JIsYns6vGaaADZgR+2cXe9yrbewHFRK35EHzMYreefI84UiywFLGd3ilgKQaBU
         NKlplyiUtcIBQ/jtrwypqMw63vIB2IRUSHZG0b4U=
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
Subject: [PATCH 4.14 22/30] mm: hugetlbfs: fix cannot migrate the fallocated HugeTLB page
Date:   Mon,  8 Feb 2021 16:01:08 +0100
Message-Id: <20210208145806.146484099@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145805.239714726@linuxfoundation.org>
References: <20210208145805.239714726@linuxfoundation.org>
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
 include/linux/hugetlb.h |    3 +++
 mm/hugetlb.c            |    2 +-
 3 files changed, 6 insertions(+), 2 deletions(-)

--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -649,8 +649,9 @@ static long hugetlbfs_fallocate(struct f
 
 		mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 
+		set_page_huge_active(page);
 		/*
-		 * page_put due to reference from alloc_huge_page()
+		 * put_page() due to reference from alloc_huge_page()
 		 * unlock_page because locked by add_to_page_cache()
 		 */
 		put_page(page);
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -531,6 +531,9 @@ static inline void set_huge_swap_pte_at(
 	set_huge_pte_at(mm, addr, ptep, pte);
 }
 #endif
+
+void set_page_huge_active(struct page *page);
+
 #else	/* CONFIG_HUGETLB_PAGE */
 struct hstate {};
 #define alloc_huge_page(v, a, r) NULL
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1238,7 +1238,7 @@ bool page_huge_active(struct page *page)
 }
 
 /* never called for tail page */
-static void set_page_huge_active(struct page *page)
+void set_page_huge_active(struct page *page)
 {
 	VM_BUG_ON_PAGE(!PageHeadHuge(page), page);
 	SetPagePrivate(&page[1]);


