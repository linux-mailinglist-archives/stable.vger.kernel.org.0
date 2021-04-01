Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55F95351F97
	for <lists+stable@lfdr.de>; Thu,  1 Apr 2021 21:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234180AbhDATWv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Apr 2021 15:22:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234376AbhDATWo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Apr 2021 15:22:44 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B28EC049FC9
        for <stable@vger.kernel.org>; Thu,  1 Apr 2021 11:21:33 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id h21so4305771qkl.12
        for <stable@vger.kernel.org>; Thu, 01 Apr 2021 11:21:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=7FFTxJfhBub0ermj70tsntXQaF5NxHdv1LLLlAgh3Tg=;
        b=IvjDKg2QrBzk4nuwOJe7alSzTfjXQP4b7KooEke+eiaaPZYUwJz1yuqQH5tTDFEK98
         7Lk7/uotQuA8WyQRHVZilIOzw6ATk5kIoJ1FMiDxVUWxXOo3lA5bkZ4nsXxDQzVFsb6I
         wQhRBt2hS9Y68Z/VRvYd4JI0ecn1ecAgTx2aT51YYHfrUeGCT4o3Vdi3jgTB0NTGksYH
         Ag5biBiLOCYWQEf42Fjbyn8pmn5S1XUm0OEFDO56SyluU3/SAdNQKqcz6FZKg12/s5jO
         hzYsgH8HQUmWqtuOIg96pFQdNKziF+3zTtd959cnOlMDo9R7W+V7/eGk9S+ly3+hVUP8
         m61A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=7FFTxJfhBub0ermj70tsntXQaF5NxHdv1LLLlAgh3Tg=;
        b=X/6ORj2inK2MUhLMZrI3mOw/ChdDiByJLNHych3aGchF26B4gNpEdJicNNJcMGSaqN
         EnOnTSAOWy10NUnXGYTV/NK/9XLerj8ZDBIK5pySJn7ybXSYa2WmISsTz/Swgm8EgXm2
         soqv4ilGXHyyI9ipQY2W2XgeS9AU9WC6Okelzk/2V8vCRkcvsvUkAg6OrKUh/1MjkuCS
         jI1IJyw2e/U4MBY4xOnpH36a/RXUj5OFOu2kouzEFu8qGPYPUaA001QUY7MgsIXZZTi4
         TbpCdhU+D+3FHigdDdBVIoVTFRP3FTdP9MkCzZ+620RvhzeE3bNRORGJ3IWNwP1+W56O
         DCXw==
X-Gm-Message-State: AOAM531dUirUT0JYHCQjfjlAWkfJioXGhtsikzi3KeByqK6s/N4/MJQs
        PV3RI+M9zLjMfFPAfswk1fndzmA7ppJljsSi+L7ZEebrynwDzQMxh9EXHzwzkt2T8ZV668Fw/wb
        sQZXPtgSRA62i/BnU41kfPDxaILtU5r+9ytXDxhKFVD46SEvNxaYNqbIV3po8kw==
X-Google-Smtp-Source: ABdhPJxh3T2CByrPxU0x0VwYvdWMkwXm0bV1SkaFoboTivfYvAc2IT1vS+/1Q743N1AN5Z/g9DCa/yCPEVI=
X-Received: from surenb1.mtv.corp.google.com ([2620:15c:211:200:899:1066:21fc:b3c5])
 (user=surenb job=sendgmr) by 2002:a0c:fecd:: with SMTP id z13mr9375738qvs.43.1617301292340;
 Thu, 01 Apr 2021 11:21:32 -0700 (PDT)
Date:   Thu,  1 Apr 2021 11:21:22 -0700
In-Reply-To: <20210401182125.171484-1-surenb@google.com>
Message-Id: <20210401182125.171484-3-surenb@google.com>
Mime-Version: 1.0
References: <20210401182125.171484-1-surenb@google.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
Subject: [PATCH 2/5] mm: do_wp_page() simplification
From:   Suren Baghdasaryan <surenb@google.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, jannh@google.com, ktkhai@virtuozzo.com,
        torvalds@linux-foundation.org, shli@fb.com, namit@vmware.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kernel-team@android.com, surenb@google.com,
        Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

How about we just make sure we're the only possible valid user fo the
page before we bother to reuse it?

Simplify, simplify, simplify.

And get rid of the nasty serialization on the page lock at the same time.

[peterx: add subject prefix]

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 mm/memory.c | 58 ++++++++++++++++-------------------------------------
 1 file changed, 17 insertions(+), 41 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 3874acce1472..d95a4573a273 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2847,49 +2847,25 @@ static vm_fault_t do_wp_page(struct vm_fault *vmf)
 	 * not dirty accountable.
 	 */
 	if (PageAnon(vmf->page)) {
-		int total_map_swapcount;
-		if (PageKsm(vmf->page) && (PageSwapCache(vmf->page) ||
-					   page_count(vmf->page) != 1))
+		struct page *page = vmf->page;
+
+		/* PageKsm() doesn't necessarily raise the page refcount */
+		if (PageKsm(page) || page_count(page) != 1)
+			goto copy;
+		if (!trylock_page(page))
+			goto copy;
+		if (PageKsm(page) || page_mapcount(page) != 1 || page_count(page) != 1) {
+			unlock_page(page);
 			goto copy;
-		if (!trylock_page(vmf->page)) {
-			get_page(vmf->page);
-			pte_unmap_unlock(vmf->pte, vmf->ptl);
-			lock_page(vmf->page);
-			vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd,
-					vmf->address, &vmf->ptl);
-			if (!pte_same(*vmf->pte, vmf->orig_pte)) {
-				unlock_page(vmf->page);
-				pte_unmap_unlock(vmf->pte, vmf->ptl);
-				put_page(vmf->page);
-				return 0;
-			}
-			put_page(vmf->page);
-		}
-		if (PageKsm(vmf->page)) {
-			bool reused = reuse_ksm_page(vmf->page, vmf->vma,
-						     vmf->address);
-			unlock_page(vmf->page);
-			if (!reused)
-				goto copy;
-			wp_page_reuse(vmf);
-			return VM_FAULT_WRITE;
-		}
-		if (reuse_swap_page(vmf->page, &total_map_swapcount)) {
-			if (total_map_swapcount == 1) {
-				/*
-				 * The page is all ours. Move it to
-				 * our anon_vma so the rmap code will
-				 * not search our parent or siblings.
-				 * Protected against the rmap code by
-				 * the page lock.
-				 */
-				page_move_anon_rmap(vmf->page, vma);
-			}
-			unlock_page(vmf->page);
-			wp_page_reuse(vmf);
-			return VM_FAULT_WRITE;
 		}
-		unlock_page(vmf->page);
+		/*
+		 * Ok, we've got the only map reference, and the only
+		 * page count reference, and the page is locked,
+		 * it's dark out, and we're wearing sunglasses. Hit it.
+		 */
+		wp_page_reuse(vmf);
+		unlock_page(page);
+		return VM_FAULT_WRITE;
 	} else if (unlikely((vma->vm_flags & (VM_WRITE|VM_SHARED)) ==
 					(VM_WRITE|VM_SHARED))) {
 		return wp_page_shared(vmf);
-- 
2.31.0.291.g576ba9dcdaf-goog

