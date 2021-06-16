Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ED5E3A8E4E
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 03:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231873AbhFPB0H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 21:26:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:40490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231360AbhFPB0H (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 21:26:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B131D613B3;
        Wed, 16 Jun 2021 01:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623806641;
        bh=3ag9FLiucw9yUHFFkFtBxEN63h2XIndBvgN6f1UPkO4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=iiTD6G02u7SoSR6+ZaamPoCU1nyKXJFG795ca8w1Zzk73lv8s0zu0fnoG7U+SfquU
         ki5KgsmXlBIRvNer13Jcyndn1F7138JDzkgE85vkai0d9uXqRfh1d6aJ0TDLhpT1Rr
         A5WJ4Qfy4e/PUR3tflZIl11eqdz3hQE9RspmsTlY=
Date:   Tue, 15 Jun 2021 18:24:00 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, apopple@nvidia.com, hughd@google.com,
        jack@suse.cz, juew@google.com, kirill.shutemov@linux.intel.com,
        linmiaohe@huawei.com, linux-mm@kvack.org, minchan@kernel.org,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de, peterx@redhat.com, rcampbell@nvidia.com,
        shakeelb@google.com, shy828301@gmail.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org, wangyugui@e16-tech.com,
        willy@infradead.org, ziy@nvidia.com
Subject:  [patch 15/18] mm/thp: fix page_address_in_vma() on file
 THP tails
Message-ID: <20210616012400.bqtmTMCeq%akpm@linux-foundation.org>
In-Reply-To: <20210615182248.9a0ba90e8e66b9f4a53c0d23@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jue Wang <juew@google.com>
Subject: mm/thp: fix page_address_in_vma() on file THP tails

Anon THP tails were already supported, but memory-failure may need to use
page_address_in_vma() on file THP tails, which its page->mapping check did
not permit: fix it.

hughd adds: no current usage is known to hit the issue, but this does fix
a subtle trap in a general helper: best fixed in stable sooner than later.

Link: https://lkml.kernel.org/r/a0d9b53-bf5d-8bab-ac5-759dc61819c1@google.com
Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
Signed-off-by: Jue Wang <juew@google.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Wang Yugui <wangyugui@e16-tech.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/rmap.c~mm-thp-fix-page_address_in_vma-on-file-thp-tails
+++ a/mm/rmap.c
@@ -716,11 +716,11 @@ unsigned long page_address_in_vma(struct
 		if (!vma->anon_vma || !page__anon_vma ||
 		    vma->anon_vma->root != page__anon_vma->root)
 			return -EFAULT;
-	} else if (page->mapping) {
-		if (!vma->vm_file || vma->vm_file->f_mapping != page->mapping)
-			return -EFAULT;
-	} else
+	} else if (!vma->vm_file) {
+		return -EFAULT;
+	} else if (vma->vm_file->f_mapping != compound_head(page)->mapping) {
 		return -EFAULT;
+	}
 
 	return vma_address(page, vma);
 }
_
