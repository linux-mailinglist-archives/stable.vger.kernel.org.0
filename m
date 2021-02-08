Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 778D7313651
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:09:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232677AbhBHPJG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:09:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:52454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232783AbhBHPGa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:06:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA62B64EB7;
        Mon,  8 Feb 2021 15:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612796703;
        bh=fzqh2cU15B8Mzgi3D49ZwYmF10tjCwNHjdsPg4dqGxI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BF3T4hzpZqgKwkumscpmwPr07+plUUhB1i3w3yxDx33fCEHDLiClC7QWrvwx+Zoyv
         NmMYnWttB15MkEiHswDX8xdocOiaf4LzC4ckq9fpY7F+8LAQ3uInm1QYt9Tzp6Xsv1
         eYv2lcIUSf4LwqmKLSrce710oWfRZlSpragqrXWw=
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
Subject: [PATCH 4.9 35/43] mm: hugetlb: fix a race between isolating and freeing page
Date:   Mon,  8 Feb 2021 16:01:01 +0100
Message-Id: <20210208145807.733890017@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145806.281758651@linuxfoundation.org>
References: <20210208145806.281758651@linuxfoundation.org>
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
@@ -4657,9 +4657,9 @@ bool isolate_huge_page(struct page *page
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


