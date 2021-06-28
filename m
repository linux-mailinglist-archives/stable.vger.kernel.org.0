Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF6A3B61F1
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233690AbhF1Ok2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:40:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:43926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234927AbhF1Oiu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:38:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A5F961CBF;
        Mon, 28 Jun 2021 14:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890676;
        bh=tD5U0q0grfXeU1hh5UBxu28prxSul0mtyHEP19EP680=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rTDo/lUsFQgJlp0rsai1wXPJExP9k48mN4B2I0pt+FADBPDzwSjpdlMigpiShEZyW
         zvdWPIZjqBG2wBY/mN+DWj/xZ19R4dLe+/G5+7JzuQocfkHXACK4TU3E9B8kJalb4X
         I0vrhSdRtlTxV8IvqYmkZTRHurm/pePu81MnV29h3jsOSeQ/4zGKu3FzTxu5nOk2XW
         5UlE3NQKunruqVi7Dc3ofA/frXCC1IX0JxmpwaEWrXQ1KPSCp8/jylKJmxPR27MVoG
         STy8peaJSbMC7NziaFWHors/XD8j1GZVXp0zm3JIiG9KSqnXDk5dRoFezk5zqoOQMQ
         DbeTzG6o/Enug==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hugh Dickins <hughd@google.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Alistair Popple <apopple@nvidia.com>,
        Matthew Wilcox <willy@infradead.org>,
        Peter Xu <peterx@redhat.com>,
        Ralph Campbell <rcampbell@nvidia.com>,
        Wang Yugui <wangyugui@e16-tech.com>,
        Will Deacon <will@kernel.org>, Yang Shi <shy828301@gmail.com>,
        Zi Yan <ziy@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.4 62/71] mm: page_vma_mapped_walk(): use goto instead of while (1)
Date:   Mon, 28 Jun 2021 10:29:55 -0400
Message-Id: <20210628143004.32596-63-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143004.32596-1-sashal@kernel.org>
References: <20210628143004.32596-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.129-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.129-rc1
X-KernelTest-Deadline: 2021-06-30T14:29+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hugh Dickins <hughd@google.com>

page_vma_mapped_walk() cleanup: add a label this_pte, matching next_pte,
and use "goto this_pte", in place of the "while (1)" loop at the end.

Link: https://lkml.kernel.org/r/a52b234a-851-3616-2525-f42736e8934@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Wang Yugui <wangyugui@e16-tech.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page_vma_mapped.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
index b71058fcfde9..fc68ab2d3ea1 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -139,6 +139,7 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 {
 	struct mm_struct *mm = pvmw->vma->vm_mm;
 	struct page *page = pvmw->page;
+	unsigned long end;
 	pgd_t *pgd;
 	p4d_t *p4d;
 	pud_t *pud;
@@ -228,10 +229,7 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 		}
 		if (!map_pte(pvmw))
 			goto next_pte;
-	}
-	while (1) {
-		unsigned long end;
-
+this_pte:
 		if (check_pte(pvmw))
 			return true;
 next_pte:
@@ -260,6 +258,7 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 			pvmw->ptl = pte_lockptr(mm, pvmw->pmd);
 			spin_lock(pvmw->ptl);
 		}
+		goto this_pte;
 	}
 }
 
-- 
2.30.2

