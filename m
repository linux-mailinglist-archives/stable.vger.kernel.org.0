Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C34D3D29EA
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235188AbhGVQHH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:07:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:43114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234458AbhGVQGR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:06:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C2C561D30;
        Thu, 22 Jul 2021 16:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972412;
        bh=sgwryQndVl1q+4bMEIwj9updmNdWQCwrnFia9KY0WUo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cTtSoJ/aC7Oo8bC7JHIwDc7YpobYrkonSrthnzPH3MhEex87hGLE/qtaZQMzZUsjE
         f8jUcEwc2Y3UZPqNnuOg4CDee+rLVKamtlRCE2SOPuI8uKkuT2hl4XhneM6NkWmA8p
         F5SpoyzXRLZ6VgZLDFftxoqfXkugF/aYoZsyePKo=
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
Subject: [PATCH 5.13 103/156] Revert "swap: fix do_swap_page() race with swapoff"
Date:   Thu, 22 Jul 2021 18:31:18 +0200
Message-Id: <20210722155631.702962561@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155628.371356843@linuxfoundation.org>
References: <20210722155628.371356843@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit c3b39134bbd088b7dce5e5f342ccd6bb9142fd18 which is
commit 2799e77529c2a25492a4395db93996e3dacd762d upstream.

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
 include/linux/swap.h |    9 ---------
 mm/memory.c          |   11 ++---------
 2 files changed, 2 insertions(+), 18 deletions(-)

--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -526,15 +526,6 @@ static inline struct swap_info_struct *s
 	return NULL;
 }
 
-static inline struct swap_info_struct *get_swap_device(swp_entry_t entry)
-{
-	return NULL;
-}
-
-static inline void put_swap_device(struct swap_info_struct *si)
-{
-}
-
 #define swap_address_space(entry)		(NULL)
 #define get_nr_swap_pages()			0L
 #define total_swap_pages			0L
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3353,7 +3353,6 @@ vm_fault_t do_swap_page(struct vm_fault
 {
 	struct vm_area_struct *vma = vmf->vma;
 	struct page *page = NULL, *swapcache;
-	struct swap_info_struct *si = NULL;
 	swp_entry_t entry;
 	pte_t pte;
 	int locked;
@@ -3381,16 +3380,14 @@ vm_fault_t do_swap_page(struct vm_fault
 		goto out;
 	}
 
-	/* Prevent swapoff from happening to us. */
-	si = get_swap_device(entry);
-	if (unlikely(!si))
-		goto out;
 
 	delayacct_set_flag(current, DELAYACCT_PF_SWAPIN);
 	page = lookup_swap_cache(entry, vma, vmf->address);
 	swapcache = page;
 
 	if (!page) {
+		struct swap_info_struct *si = swp_swap_info(entry);
+
 		if (data_race(si->flags & SWP_SYNCHRONOUS_IO) &&
 		    __swap_count(entry) == 1) {
 			/* skip swapcache */
@@ -3559,8 +3556,6 @@ vm_fault_t do_swap_page(struct vm_fault
 unlock:
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
 out:
-	if (si)
-		put_swap_device(si);
 	return ret;
 out_nomap:
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
@@ -3572,8 +3567,6 @@ out_release:
 		unlock_page(swapcache);
 		put_page(swapcache);
 	}
-	if (si)
-		put_swap_device(si);
 	return ret;
 }
 


