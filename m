Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F19463B61EE
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:38:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234217AbhF1OkZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:40:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:43938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234929AbhF1Oiu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:38:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C634061CC8;
        Mon, 28 Jun 2021 14:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890678;
        bh=YB6lpiG0lCSbnUZ2ll6QXaYugQpp1ukoTvc1goQrrBM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N/SxXEMsVXpac6Zxk7esUmgQ0NUbiSJopqINvknAQPNqe4fE4XIdVXj78WHWjjUvb
         uzY+r+JoORfjFmk3TBnmxEOtQ9JWeJBoLyzxIwqhwoG6BlVtoFcD5YoG4NRHBwtAev
         Z7jhLIisRpHgDb9A+gLt3iCZn4hhlLfI3uUyOaIWGUa72HsiUzl4L6QLCIlMllgmW2
         6vZk0j/8I8aF+raEEOGOuqaYqZafkBD7dVly2zB8kxG4THmAhMpWw8dOVYZuuDyIFr
         jHcFjmxPblvV0eQllwBmK48FtZf+qoM0LNfueWeZPO7O0K+FnvCpFuXYHnacPNTr6i
         sb8TnwuT4pc7g==
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
Subject: [PATCH 5.4 63/71] mm: page_vma_mapped_walk(): get vma_address_end() earlier
Date:   Mon, 28 Jun 2021 10:29:56 -0400
Message-Id: <20210628143004.32596-64-sashal@kernel.org>
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

page_vma_mapped_walk() cleanup: get THP's vma_address_end() at the
start, rather than later at next_pte.

It's a little unnecessary overhead on the first call, but makes for a
simpler loop in the following commit.

Link: https://lkml.kernel.org/r/4542b34d-862f-7cb4-bb22-e0df6ce830a2@google.com
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
 mm/page_vma_mapped.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
index fc68ab2d3ea1..93dd79ba9969 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -166,6 +166,15 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 		return true;
 	}
 
+	/*
+	 * Seek to next pte only makes sense for THP.
+	 * But more important than that optimization, is to filter out
+	 * any PageKsm page: whose page->index misleads vma_address()
+	 * and vma_address_end() to disaster.
+	 */
+	end = PageTransCompound(page) ?
+		vma_address_end(page, pvmw->vma) :
+		pvmw->address + PAGE_SIZE;
 	if (pvmw->pte)
 		goto next_pte;
 restart:
@@ -233,10 +242,6 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 		if (check_pte(pvmw))
 			return true;
 next_pte:
-		/* Seek to next pte only makes sense for THP */
-		if (!PageTransHuge(page))
-			return not_found(pvmw);
-		end = vma_address_end(page, pvmw->vma);
 		do {
 			pvmw->address += PAGE_SIZE;
 			if (pvmw->address >= end)
-- 
2.30.2

