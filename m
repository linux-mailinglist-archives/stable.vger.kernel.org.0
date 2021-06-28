Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD8E63B61E5
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233951AbhF1OkS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:40:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:44304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234338AbhF1Ohc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:37:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7BA4361CB9;
        Mon, 28 Jun 2021 14:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890660;
        bh=gWGRg5Ao/mfeYsnMF/ETbtRp7Iolg6SXyZ55ZoTuR3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ckNsQoFJUW1jEsk5wKK0TAQ8CytczSjD7j3izT8f8ZnlQirw6M0r+ue7BOeMZXbfu
         Q5CI/Bsw7ZWf5Jx0bJ5QZlyOjSnGAGj1TzDpl3C4T2cyCbnpd6gNx3aA80/6lY31dI
         uIkFZqAoUwNJj7i/246mFiQpiAY99X0rk/gRtwkGmBAgqYV0UJdhh+cOQN8wz8iPY5
         xN0uPrJNJUZ2PZh5YgfpkrXJB4+//esqtXYP0G3EUify5KZTqu4YGhN9zIDZFJ5Mck
         aL/xdJOVboia9mrMLB/lXftK4n1kSesiBKo1hTElJ+W3F3p3ZrO88G+M8NisX1iUpn
         JRXf7QPcAeIFA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jue Wang <juew@google.com>, Hugh Dickins <hughd@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Yang Shi <shy828301@gmail.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
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
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.4 53/71] mm/thp: fix page_address_in_vma() on file THP tails
Date:   Mon, 28 Jun 2021 10:29:46 -0400
Message-Id: <20210628143004.32596-54-sashal@kernel.org>
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

From: Jue Wang <juew@google.com>

commit 31657170deaf1d8d2f6a1955fbc6fa9d228be036 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/rmap.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index dfadc8364aa9..45f2106852e8 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -696,11 +696,11 @@ unsigned long page_address_in_vma(struct page *page, struct vm_area_struct *vma)
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

