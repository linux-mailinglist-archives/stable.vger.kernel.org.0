Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 093D1351F9A
	for <lists+stable@lfdr.de>; Thu,  1 Apr 2021 21:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235000AbhDATWw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Apr 2021 15:22:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234477AbhDATWp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Apr 2021 15:22:45 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AEFFC049FC6
        for <stable@vger.kernel.org>; Thu,  1 Apr 2021 11:21:31 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id l11so3608468qtk.2
        for <stable@vger.kernel.org>; Thu, 01 Apr 2021 11:21:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=5HT0qAWVFEwmOUtF6La54IUlPIkCZq6cCaZb+QDq3o0=;
        b=FCS4HYb6J3nfpKWojigWdeLm322x4N3yal1ui3yFWmzroHvdmhbKuSF3DpbqsIBKqU
         3C1CdQ+JY3kcg+YFAsmQ5yLfUbgENDF0IPDrSY+6PjWU94p8tWRFMKPwcAiU0sniPxDq
         1TF2+8+Ip8kSSHIhLIvSRZcY7gCVna0ZgXGr5eYamiInLGVJQh+k680kXCav7A/idNVP
         8SfPeqsoxzgrtq++O0zdmEqmBXYA68o6+WEbD7dN4ckj4+wBapc6cclze2NFWqKPe5am
         FpGwFjYcZzq2q5aJNUuKnYZmVnteJrzOrphPlZE2ju6i7MwUENmkr/13kR4/M7hOfJdu
         j0WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=5HT0qAWVFEwmOUtF6La54IUlPIkCZq6cCaZb+QDq3o0=;
        b=a5Bm/zUm8SRpnY2B/AqlovxTStIagqKMpbuTt240k12A1BpbYG5yelh33aXnd3E1f3
         GhPQwlJK5ZNix89R1+rEufAyz/RuLfykb5zEriToGlUA9AQkECLM98U8iyHGUE9lOyL7
         J8b4hW5ngpeYfQkT41XET3LJpwFkJWyeH5w6U1iInYqIWhYOnz3diOq0Wm7WbCFu6W6d
         NHO5RQwkhqjWN4JARLzuytVbwTJSbJOchaY8BKRwabel8rO4bC1Z3AH7jo9F9zsmitaR
         A+7NoXv/5BwDYlCkU/4yLQGkr4G90Q7idIJzSHOogPGNG8KAXd3+v4iSM6AYyt7K0ny0
         FnZw==
X-Gm-Message-State: AOAM533WmRDymooMUvA0Ta5hueWWNQTfxGTftF6TWGMw0nZXJ1LK10eb
        UAMIZ5OyFYzj48feAWjbjtzGJFOyvGNm2Tg7EbYpv2jmsvOOf5N/8POps0BxOg69m8+Yhx/0rqi
        56ra9cuXd8yVxyKpRwbpLhCxtppGW+es4W7WLLbPtR02pRaJvq7fw8seq29Jufg==
X-Google-Smtp-Source: ABdhPJx3CSbez+mHmIMP16uoTLOqGzUQCpgEy4t7meclV6GV32vzVuEQJjrjKkgnWp0r1JVEINQ+id1CxYw=
X-Received: from surenb1.mtv.corp.google.com ([2620:15c:211:200:899:1066:21fc:b3c5])
 (user=surenb job=sendgmr) by 2002:ad4:58cf:: with SMTP id dh15mr9296862qvb.26.1617301290422;
 Thu, 01 Apr 2021 11:21:30 -0700 (PDT)
Date:   Thu,  1 Apr 2021 11:21:21 -0700
In-Reply-To: <20210401182125.171484-1-surenb@google.com>
Message-Id: <20210401182125.171484-2-surenb@google.com>
Mime-Version: 1.0
References: <20210401182125.171484-1-surenb@google.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
Subject: [PATCH 1/5] mm: reuse only-pte-mapped KSM page in do_wp_page()
From:   Suren Baghdasaryan <surenb@google.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, jannh@google.com, ktkhai@virtuozzo.com,
        torvalds@linux-foundation.org, shli@fb.com, namit@vmware.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kernel-team@android.com, surenb@google.com,
        Yang Shi <yang.shi@linux.alibaba.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hugh Dickins <hughd@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Christian Koenig <christian.koenig@amd.com>,
        Claudio Imbrenda <imbrenda@linux.vnet.ibm.com>,
        Rik van Riel <riel@surriel.com>,
        Huang Ying <ying.huang@intel.com>,
        Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kirill Tkhai <ktkhai@virtuozzo.com>

Add an optimization for KSM pages almost in the same way that we have
for ordinary anonymous pages.  If there is a write fault in a page,
which is mapped to an only pte, and it is not related to swap cache; the
page may be reused without copying its content.

[ Note that we do not consider PageSwapCache() pages at least for now,
  since we don't want to complicate __get_ksm_page(), which has nice
  optimization based on this (for the migration case). Currenly it is
  spinning on PageSwapCache() pages, waiting for when they have
  unfreezed counters (i.e., for the migration finish). But we don't want
  to make it also spinning on swap cache pages, which we try to reuse,
  since there is not a very high probability to reuse them. So, for now
  we do not consider PageSwapCache() pages at all. ]

So in reuse_ksm_page() we check for 1) PageSwapCache() and 2)
page_stable_node(), to skip a page, which KSM is currently trying to
link to stable tree.  Then we do page_ref_freeze() to prohibit KSM to
merge one more page into the page, we are reusing.  After that, nobody
can refer to the reusing page: KSM skips !PageSwapCache() pages with
zero refcount; and the protection against of all other participants is
the same as for reused ordinary anon pages pte lock, page lock and
mmap_sem.

[akpm@linux-foundation.org: replace BUG_ON()s with WARN_ON()s]
Link: http://lkml.kernel.org/r/154471491016.31352.1168978849911555609.stgit@localhost.localdomain
Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>
Reviewed-by: Yang Shi <yang.shi@linux.alibaba.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Christian Koenig <christian.koenig@amd.com>
Cc: Claudio Imbrenda <imbrenda@linux.vnet.ibm.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Kirill Tkhai <ktkhai@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 include/linux/ksm.h |  7 +++++++
 mm/ksm.c            | 30 ++++++++++++++++++++++++++++--
 mm/memory.c         | 16 ++++++++++++++--
 3 files changed, 49 insertions(+), 4 deletions(-)

diff --git a/include/linux/ksm.h b/include/linux/ksm.h
index 161e8164abcf..e48b1e453ff5 100644
--- a/include/linux/ksm.h
+++ b/include/linux/ksm.h
@@ -53,6 +53,8 @@ struct page *ksm_might_need_to_copy(struct page *page,
 
 void rmap_walk_ksm(struct page *page, struct rmap_walk_control *rwc);
 void ksm_migrate_page(struct page *newpage, struct page *oldpage);
+bool reuse_ksm_page(struct page *page,
+			struct vm_area_struct *vma, unsigned long address);
 
 #else  /* !CONFIG_KSM */
 
@@ -86,6 +88,11 @@ static inline void rmap_walk_ksm(struct page *page,
 static inline void ksm_migrate_page(struct page *newpage, struct page *oldpage)
 {
 }
+static inline bool reuse_ksm_page(struct page *page,
+			struct vm_area_struct *vma, unsigned long address)
+{
+	return false;
+}
 #endif /* CONFIG_MMU */
 #endif /* !CONFIG_KSM */
 
diff --git a/mm/ksm.c b/mm/ksm.c
index d021bcf94c41..c4e95ca65d62 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -705,8 +705,9 @@ static struct page *get_ksm_page(struct stable_node *stable_node, bool lock_it)
 	 * case this node is no longer referenced, and should be freed;
 	 * however, it might mean that the page is under page_ref_freeze().
 	 * The __remove_mapping() case is easy, again the node is now stale;
-	 * but if page is swapcache in migrate_page_move_mapping(), it might
-	 * still be our page, in which case it's essential to keep the node.
+	 * the same is in reuse_ksm_page() case; but if page is swapcache
+	 * in migrate_page_move_mapping(), it might still be our page,
+	 * in which case it's essential to keep the node.
 	 */
 	while (!get_page_unless_zero(page)) {
 		/*
@@ -2648,6 +2649,31 @@ void rmap_walk_ksm(struct page *page, struct rmap_walk_control *rwc)
 		goto again;
 }
 
+bool reuse_ksm_page(struct page *page,
+		    struct vm_area_struct *vma,
+		    unsigned long address)
+{
+#ifdef CONFIG_DEBUG_VM
+	if (WARN_ON(is_zero_pfn(page_to_pfn(page))) ||
+			WARN_ON(!page_mapped(page)) ||
+			WARN_ON(!PageLocked(page))) {
+		dump_page(page, "reuse_ksm_page");
+		return false;
+	}
+#endif
+
+	if (PageSwapCache(page) || !page_stable_node(page))
+		return false;
+	/* Prohibit parallel get_ksm_page() */
+	if (!page_ref_freeze(page, 1))
+		return false;
+
+	page_move_anon_rmap(page, vma);
+	page->index = linear_page_index(vma, address);
+	page_ref_unfreeze(page, 1);
+
+	return true;
+}
 #ifdef CONFIG_MIGRATION
 void ksm_migrate_page(struct page *newpage, struct page *oldpage)
 {
diff --git a/mm/memory.c b/mm/memory.c
index c1a05c2484b0..3874acce1472 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2846,8 +2846,11 @@ static vm_fault_t do_wp_page(struct vm_fault *vmf)
 	 * Take out anonymous pages first, anonymous shared vmas are
 	 * not dirty accountable.
 	 */
-	if (PageAnon(vmf->page) && !PageKsm(vmf->page)) {
+	if (PageAnon(vmf->page)) {
 		int total_map_swapcount;
+		if (PageKsm(vmf->page) && (PageSwapCache(vmf->page) ||
+					   page_count(vmf->page) != 1))
+			goto copy;
 		if (!trylock_page(vmf->page)) {
 			get_page(vmf->page);
 			pte_unmap_unlock(vmf->pte, vmf->ptl);
@@ -2862,6 +2865,15 @@ static vm_fault_t do_wp_page(struct vm_fault *vmf)
 			}
 			put_page(vmf->page);
 		}
+		if (PageKsm(vmf->page)) {
+			bool reused = reuse_ksm_page(vmf->page, vmf->vma,
+						     vmf->address);
+			unlock_page(vmf->page);
+			if (!reused)
+				goto copy;
+			wp_page_reuse(vmf);
+			return VM_FAULT_WRITE;
+		}
 		if (reuse_swap_page(vmf->page, &total_map_swapcount)) {
 			if (total_map_swapcount == 1) {
 				/*
@@ -2882,7 +2894,7 @@ static vm_fault_t do_wp_page(struct vm_fault *vmf)
 					(VM_WRITE|VM_SHARED))) {
 		return wp_page_shared(vmf);
 	}
-
+copy:
 	/*
 	 * Ok, we need to copy. Oh, well..
 	 */
-- 
2.31.0.291.g576ba9dcdaf-goog

