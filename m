Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 672C93B6064
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233517AbhF1OY1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:24:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:55472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233378AbhF1OXI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:23:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B411A61C8B;
        Mon, 28 Jun 2021 14:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890010;
        bh=8HehTFjVECkzlfarTq7I0tT5ptETZix/7zuUKjTyKyc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i9MawH9pTc+m4JWJaP4aFKhClrtywG3YfDIV8HhmQ9oKaMukxqfmJSGRFy/DKDNBi
         65BEFq/kgdUOs3DIBW5H/8uANwKjwwIqsFIYTGDaT3D1fQg8i0pQ/jLKK+mmqq3oVe
         g7RXyYdUSZ0IoXhOeIltTlagJNdoIHZYR74sD761Eu4qQO3nXSVVf5oggtcRQ3c/Sf
         sKK4XmMflHFisFIwsRRZowSTqwZ1YTtvB/DXyxd+9J860/rpBXxbQMrzO/+0s0VLz0
         sWp5qyRipXAs99tXGsBC5ksZHW6D3b8f1zPzpXQzJ8XogDbufM0Ut1kUCuTqfuwOfM
         Ks464RfboMrqw==
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
Subject: [PATCH 5.12 097/110] mm: page_vma_mapped_walk(): get vma_address_end() earlier
Date:   Mon, 28 Jun 2021 10:18:15 -0400
Message-Id: <20210628141828.31757-98-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628141828.31757-1-sashal@kernel.org>
References: <20210628141828.31757-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.14-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.12.14-rc1
X-KernelTest-Deadline: 2021-06-30T14:18+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hugh Dickins <hughd@google.com>

commit a765c417d876cc635f628365ec9aa6f09470069a upstream.

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
index 8803dd93c049..b4c731ca2752 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -171,6 +171,15 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
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
@@ -238,10 +247,6 @@ this_pte:
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

