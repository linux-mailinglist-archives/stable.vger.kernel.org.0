Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5352E313831
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:39:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234049AbhBHPhs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:37:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:37070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233768AbhBHPcQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:32:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93F3664F42;
        Mon,  8 Feb 2021 15:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797476;
        bh=Fjkmu67Q7FLaldn2F3+yo7jQuHb/a6aXn743zCIRBGw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AxFFSbrkxjulEcxD5dhsk+IEjvamtkNsbqxPoQg5WEw/fdekfhvRKeBvFyo3E9Ye8
         gybsBd2oQKyoHKX2L4Jb1OzN77YyLzWCmi3h4/PFGbTSoEQ6t6rbLV58ztGa3pC8FW
         SeNhMdXhUvFI530KM5bsE4s53l2vpbV+dhR1iwhU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Michal Hocko <mhocko@suse.com>,
        Oscar Salvador <osalvador@suse.de>,
        David Hildenbrand <david@redhat.com>,
        Yang Shi <shy828301@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 100/120] mm: hugetlb: fix a race between isolating and freeing page
Date:   Mon,  8 Feb 2021 16:01:27 +0100
Message-Id: <20210208145822.361857278@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
References: <20210208145818.395353822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>

commit 0eb2df2b5629794020f75e94655e1994af63f0d4 upstream.

There is a race between isolate_huge_page() and __free_huge_page().

  CPU0:                                     CPU1:

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

When we isolate a HugeTLB page on CPU0.  Meanwhile, we free it to the
buddy allocator on CPU1.  Then, we can trigger a BUG_ON on CPU0, because
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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5595,9 +5595,9 @@ bool isolate_huge_page(struct page *page
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


