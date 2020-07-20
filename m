Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF059226817
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387505AbgGTQQl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:16:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:57968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387747AbgGTQQk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:16:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 237732064B;
        Mon, 20 Jul 2020 16:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261799;
        bh=Bh+YGyjEvR5W7dYf621jENKF5FKOShULPxX+zzJwdI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oj0v3vder2JnK2srRLtHnz8J94ZHlzMGPl/My1w5Gf5UxeUg9zmLyszrqAoY/ysZK
         6dn2tINyr8bd0HKjtcmxCgK2UJmMUyzLPAPJeJqjS8z/0rkAqrHzFAOU0O0RGSqpf/
         UwD2j50PU26GH+7+uhyynYJdL354PPTX0pIb8fmg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arjun Roy <arjunroy@google.com>,
        David Rientjes <rientjes@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Hugh Dickins <hughd@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.7 239/244] mm/memory.c: properly pte_offset_map_lock/unlock in vm_insert_pages()
Date:   Mon, 20 Jul 2020 17:38:30 +0200
Message-Id: <20200720152837.204782629@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arjun Roy <arjunroy@google.com>

commit 7f70c2a68a51496289df163f6969d4db7c383f30 upstream.

Calls to pte_offset_map() in vm_insert_pages() are erroneously not
matched with a call to pte_unmap().  This would cause problems on
architectures where that is not a no-op.

This patch does away with the non-traditional locking in the existing
code, and instead uses pte_offset_map_lock/unlock() as usual,
incrementing PTE as necessary.  The PTE pointer is kept within bounds
since we clamp it with PTRS_PER_PTE.

Link: http://lkml.kernel.org/r/20200618220446.20284-1-arjunroy.kdev@gmail.com
Fixes: 8cd3984d81d5 ("mm/memory.c: add vm_insert_pages()")
Signed-off-by: Arjun Roy <arjunroy@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Soheil Hassas Yeganeh <soheil@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/memory.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1501,7 +1501,7 @@ out:
 }
 
 #ifdef pte_index
-static int insert_page_in_batch_locked(struct mm_struct *mm, pmd_t *pmd,
+static int insert_page_in_batch_locked(struct mm_struct *mm, pte_t *pte,
 			unsigned long addr, struct page *page, pgprot_t prot)
 {
 	int err;
@@ -1509,8 +1509,9 @@ static int insert_page_in_batch_locked(s
 	if (!page_count(page))
 		return -EINVAL;
 	err = validate_page_before_insert(page);
-	return err ? err : insert_page_into_pte_locked(
-		mm, pte_offset_map(pmd, addr), addr, page, prot);
+	if (err)
+		return err;
+	return insert_page_into_pte_locked(mm, pte, addr, page, prot);
 }
 
 /* insert_pages() amortizes the cost of spinlock operations
@@ -1520,7 +1521,8 @@ static int insert_pages(struct vm_area_s
 			struct page **pages, unsigned long *num, pgprot_t prot)
 {
 	pmd_t *pmd = NULL;
-	spinlock_t *pte_lock = NULL;
+	pte_t *start_pte, *pte;
+	spinlock_t *pte_lock;
 	struct mm_struct *const mm = vma->vm_mm;
 	unsigned long curr_page_idx = 0;
 	unsigned long remaining_pages_total = *num;
@@ -1539,18 +1541,17 @@ more:
 	ret = -ENOMEM;
 	if (pte_alloc(mm, pmd))
 		goto out;
-	pte_lock = pte_lockptr(mm, pmd);
 
 	while (pages_to_write_in_pmd) {
 		int pte_idx = 0;
 		const int batch_size = min_t(int, pages_to_write_in_pmd, 8);
 
-		spin_lock(pte_lock);
-		for (; pte_idx < batch_size; ++pte_idx) {
-			int err = insert_page_in_batch_locked(mm, pmd,
+		start_pte = pte_offset_map_lock(mm, pmd, addr, &pte_lock);
+		for (pte = start_pte; pte_idx < batch_size; ++pte, ++pte_idx) {
+			int err = insert_page_in_batch_locked(mm, pte,
 				addr, pages[curr_page_idx], prot);
 			if (unlikely(err)) {
-				spin_unlock(pte_lock);
+				pte_unmap_unlock(start_pte, pte_lock);
 				ret = err;
 				remaining_pages_total -= pte_idx;
 				goto out;
@@ -1558,7 +1559,7 @@ more:
 			addr += PAGE_SIZE;
 			++curr_page_idx;
 		}
-		spin_unlock(pte_lock);
+		pte_unmap_unlock(start_pte, pte_lock);
 		pages_to_write_in_pmd -= batch_size;
 		remaining_pages_total -= batch_size;
 	}


