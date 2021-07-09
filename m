Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D2F53C2450
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 15:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232059AbhGINWJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 09:22:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:52396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232105AbhGINWJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 09:22:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7853613B6;
        Fri,  9 Jul 2021 13:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625836761;
        bh=FRXk0/dm+qtUFBK4/Y8rPXbnnd8S/gPnPr9JJwUCFjI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NFb5eKW74xs4x3pQ7gbEpA8vpPgY7n1rJwKSAHO10Bcf0grDu4AMfpl9vAzidSgOZ
         QJrSh/5le2om8LHHmSMzXUfelXJqgeGZ5uUZX6UFR3ivEWFw0Guw9M2ivT4HLVeD0C
         mxcivvwyYn+gwTlv72aOdM+BZr1aR6yWAQPCS03k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jue Wang <juew@google.com>,
        Hugh Dickins <hughd@google.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Yang Shi <shy828301@gmail.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Alistair Popple <apopple@nvidia.com>, Jan Kara <jack@suse.cz>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Minchan Kim <minchan@kernel.org>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Oscar Salvador <osalvador@suse.de>,
        Peter Xu <peterx@redhat.com>,
        Ralph Campbell <rcampbell@nvidia.com>,
        Shakeel Butt <shakeelb@google.com>,
        Wang Yugui <wangyugui@e16-tech.com>, Zi Yan <ziy@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 07/25] mm/thp: fix page_address_in_vma() on file THP tails
Date:   Fri,  9 Jul 2021 15:18:38 +0200
Message-Id: <20210709131632.341145716@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210709131627.928131764@linuxfoundation.org>
References: <20210709131627.928131764@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jue Wang <juew@google.com>

[ Upstream commit 31657170deaf1d8d2f6a1955fbc6fa9d228be036 ]

Anon THP tails were already supported, but memory-failure may need to
use page_address_in_vma() on file THP tails, which its page->mapping
check did not permit: fix it.

hughd adds: no current usage is known to hit the issue, but this does
fix a subtle trap in a general helper: best fixed in stable sooner than
later.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/rmap.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index bebe29a2c5f2..8ed8ec113d5a 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -695,11 +695,11 @@ unsigned long page_address_in_vma(struct page *page, struct vm_area_struct *vma)
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
-- 
2.30.2



