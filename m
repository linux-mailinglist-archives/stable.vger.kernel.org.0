Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FEFD3D28F4
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233085AbhGVQAF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:00:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:35290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233686AbhGVP70 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:59:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7933060E0C;
        Thu, 22 Jul 2021 16:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972001;
        bh=/gVeHfhRcbOljhuLQDLnBS0Z+BWxze5RyGoNvdYRXk0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QAfuZfJ66Kggp9P8W2UnUWZvy+jYaWt3nyrKBvPeqpJqtZFfY5Q4u3q5AQzN6aguG
         9wTB1vYwPaR3/QhTH8ZlvLKcKAQ9FZr7yPpLGPoLjc6qTd9Ql6tgaL8AYvuYbsUEeh
         gCDUmFGSTXWfewzvGFM9U6Wj1c/3xlvcYEJyXh7I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "From: Matthew Wilcox" <willy@infradead.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Ying Huang <ying.huang@intel.com>, Alex Shi <alexs@kernel.org>,
        David Hildenbrand <david@redhat.com>,
        Dennis Zhou <dennis@kernel.org>,
        Hugh Dickins <hughd@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Michal Hocko <mhocko@suse.com>,
        Minchan Kim <minchan@kernel.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Wei Yang <richard.weiyang@gmail.com>,
        Yang Shi <shy828301@gmail.com>, Yu Zhao <yuzhao@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 108/125] Revert "mm/shmem: fix shmem_swapin() race with swapoff"
Date:   Thu, 22 Jul 2021 18:31:39 +0200
Message-Id: <20210722155628.289695046@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155624.672583740@linuxfoundation.org>
References: <20210722155624.672583740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit a533a21b692fc15a6aadfa827b29c7d9989109ca which is
commit 2efa33fc7f6ec94a3a538c1a264273c889be2b36 upstream.

It should not have been added to the stable trees, sorry about that.

Link: https://lore.kernel.org/r/YPVgaY6uw59Fqg5x@casper.infradead.org
Reported-by: From: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Ying Huang <ying.huang@intel.com>
Cc: Alex Shi <alexs@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/shmem.c |   14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1698,8 +1698,7 @@ static int shmem_swapin_page(struct inod
 	struct address_space *mapping = inode->i_mapping;
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	struct mm_struct *charge_mm = vma ? vma->vm_mm : current->mm;
-	struct swap_info_struct *si;
-	struct page *page = NULL;
+	struct page *page;
 	swp_entry_t swap;
 	int error;
 
@@ -1707,12 +1706,6 @@ static int shmem_swapin_page(struct inod
 	swap = radix_to_swp_entry(*pagep);
 	*pagep = NULL;
 
-	/* Prevent swapoff from happening to us. */
-	si = get_swap_device(swap);
-	if (!si) {
-		error = EINVAL;
-		goto failed;
-	}
 	/* Look it up and read it in.. */
 	page = lookup_swap_cache(swap, NULL, 0);
 	if (!page) {
@@ -1774,8 +1767,6 @@ static int shmem_swapin_page(struct inod
 	swap_free(swap);
 
 	*pagep = page;
-	if (si)
-		put_swap_device(si);
 	return 0;
 failed:
 	if (!shmem_confirm_swap(mapping, index, swap))
@@ -1786,9 +1777,6 @@ unlock:
 		put_page(page);
 	}
 
-	if (si)
-		put_swap_device(si);
-
 	return error;
 }
 


