Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05C443C5385
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239124AbhGLHzA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:55:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:36488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350436AbhGLHvA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:51:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1932761979;
        Mon, 12 Jul 2021 07:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075936;
        bh=jG0iEGsyG09S0zAthsL9zhvBMLl6Ic0hmIOBFl1zA4k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zcJfWCR5iucWwyE4CH9roq0vtEEmeTizdFdc3yGZKqy6m1cz048ZU4afbrN0NcjGS
         h0naCpCt65ZHseBgEoHIS/9hyfymqJNIE9LAsjz9IrbeA4i0+Qr3zb+pvyHT0VMrDO
         l2doU4OP0ge0VsZE+iJa1BXm1tLTgNhCAVSXqJ8U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        Dennis Zhou <dennis@kernel.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Hugh Dickins <hughd@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Alex Shi <alexs@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Minchan Kim <minchan@kernel.org>,
        Wei Yang <richard.weiyang@gmail.com>,
        Yang Shi <shy828301@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Yu Zhao <yuzhao@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 385/800] mm/shmem: fix shmem_swapin() race with swapoff
Date:   Mon, 12 Jul 2021 08:06:48 +0200
Message-Id: <20210712061008.175101537@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

[ Upstream commit 2efa33fc7f6ec94a3a538c1a264273c889be2b36 ]

When I was investigating the swap code, I found the below possible race
window:

CPU 1                                         CPU 2
-----                                         -----
shmem_swapin
  swap_cluster_readahead
    if (likely(si->flags & (SWP_BLKDEV | SWP_FS_OPS))) {
                                              swapoff
                                                ..
                                                si->swap_file = NULL;
                                                ..
    struct inode *inode = si->swap_file->f_mapping->host;[oops!]

Close this race window by using get/put_swap_device() to guard against
concurrent swapoff.

Link: https://lkml.kernel.org/r/20210426123316.806267-5-linmiaohe@huawei.com
Fixes: 8fd2e0b505d1 ("mm: swap: check if swap backing device is congested or not")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Alex Shi <alexs@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/shmem.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 5d46611cba8d..53f21016608e 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1696,7 +1696,8 @@ static int shmem_swapin_page(struct inode *inode, pgoff_t index,
 	struct address_space *mapping = inode->i_mapping;
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	struct mm_struct *charge_mm = vma ? vma->vm_mm : current->mm;
-	struct page *page;
+	struct swap_info_struct *si;
+	struct page *page = NULL;
 	swp_entry_t swap;
 	int error;
 
@@ -1704,6 +1705,12 @@ static int shmem_swapin_page(struct inode *inode, pgoff_t index,
 	swap = radix_to_swp_entry(*pagep);
 	*pagep = NULL;
 
+	/* Prevent swapoff from happening to us. */
+	si = get_swap_device(swap);
+	if (!si) {
+		error = EINVAL;
+		goto failed;
+	}
 	/* Look it up and read it in.. */
 	page = lookup_swap_cache(swap, NULL, 0);
 	if (!page) {
@@ -1765,6 +1772,8 @@ static int shmem_swapin_page(struct inode *inode, pgoff_t index,
 	swap_free(swap);
 
 	*pagep = page;
+	if (si)
+		put_swap_device(si);
 	return 0;
 failed:
 	if (!shmem_confirm_swap(mapping, index, swap))
@@ -1775,6 +1784,9 @@ unlock:
 		put_page(page);
 	}
 
+	if (si)
+		put_swap_device(si);
+
 	return error;
 }
 
-- 
2.30.2



