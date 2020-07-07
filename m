Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE9121710A
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728775AbgGGPXc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:23:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:36552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728970AbgGGPX1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:23:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1812F20771;
        Tue,  7 Jul 2020 15:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135406;
        bh=JPzRGWn7cmoO61coy8AdI/bFEF2GMG+WlPquS4fq+Ls=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VLtHNeOJMQqsvO5bIWI+nlGH1cMPv93BMRgJfpQd/xzz/HFNqRMgb0tE7arv6CyS/
         c2xccgvCgX6MJXGe7Wn5g7Z3yrhJRYdc2qsiaAh0/CDYWdTUgCbbRnwfwusebj0PZC
         ScvIQ8yXNmSFDQc/U2Aw2wSuH5i1Vewk+NBpVNv4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Chris Murphy <lists@colorremedies.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 008/112] mm: fix swap cache node allocation mask
Date:   Tue,  7 Jul 2020 17:16:13 +0200
Message-Id: <20200707145801.338495007@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145800.925304888@linuxfoundation.org>
References: <20200707145800.925304888@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hugh Dickins <hughd@google.com>

[ Upstream commit 243bce09c91b0145aeaedd5afba799d81841c030 ]

Chris Murphy reports that a slightly overcommitted load, testing swap
and zram along with i915, splats and keeps on splatting, when it had
better fail less noisily:

  gnome-shell: page allocation failure: order:0,
  mode:0x400d0(__GFP_IO|__GFP_FS|__GFP_COMP|__GFP_RECLAIMABLE),
  nodemask=(null),cpuset=/,mems_allowed=0
  CPU: 2 PID: 1155 Comm: gnome-shell Not tainted 5.7.0-1.fc33.x86_64 #1
  Call Trace:
    dump_stack+0x64/0x88
    warn_alloc.cold+0x75/0xd9
    __alloc_pages_slowpath.constprop.0+0xcfa/0xd30
    __alloc_pages_nodemask+0x2df/0x320
    alloc_slab_page+0x195/0x310
    allocate_slab+0x3c5/0x440
    ___slab_alloc+0x40c/0x5f0
    __slab_alloc+0x1c/0x30
    kmem_cache_alloc+0x20e/0x220
    xas_nomem+0x28/0x70
    add_to_swap_cache+0x321/0x400
    __read_swap_cache_async+0x105/0x240
    swap_cluster_readahead+0x22c/0x2e0
    shmem_swapin+0x8e/0xc0
    shmem_swapin_page+0x196/0x740
    shmem_getpage_gfp+0x3a2/0xa60
    shmem_read_mapping_page_gfp+0x32/0x60
    shmem_get_pages+0x155/0x5e0 [i915]
    __i915_gem_object_get_pages+0x68/0xa0 [i915]
    i915_vma_pin+0x3fe/0x6c0 [i915]
    eb_add_vma+0x10b/0x2c0 [i915]
    i915_gem_do_execbuffer+0x704/0x3430 [i915]
    i915_gem_execbuffer2_ioctl+0x1ea/0x3e0 [i915]
    drm_ioctl_kernel+0x86/0xd0 [drm]
    drm_ioctl+0x206/0x390 [drm]
    ksys_ioctl+0x82/0xc0
    __x64_sys_ioctl+0x16/0x20
    do_syscall_64+0x5b/0xf0
    entry_SYSCALL_64_after_hwframe+0x44/0xa9

Reported on 5.7, but it goes back really to 3.1: when
shmem_read_mapping_page_gfp() was implemented for use by i915, and
allowed for __GFP_NORETRY and __GFP_NOWARN flags in most places, but
missed swapin's "& GFP_KERNEL" mask for page tree node allocation in
__read_swap_cache_async() - that was to mask off HIGHUSER_MOVABLE bits
from what page cache uses, but GFP_RECLAIM_MASK is now what's needed.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=208085
Link: http://lkml.kernel.org/r/alpine.LSU.2.11.2006151330070.11064@eggly.anvils
Fixes: 68da9f055755 ("tmpfs: pass gfp to shmem_getpage_gfp")
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reported-by: Chris Murphy <lists@colorremedies.com>
Analyzed-by: Vlastimil Babka <vbabka@suse.cz>
Analyzed-by: Matthew Wilcox <willy@infradead.org>
Tested-by: Chris Murphy <lists@colorremedies.com>
Cc: <stable@vger.kernel.org>	[3.1+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/swap_state.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/swap_state.c b/mm/swap_state.c
index ebed37bbf7a39..e3d36776c08bf 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -23,6 +23,7 @@
 #include <linux/huge_mm.h>
 
 #include <asm/pgtable.h>
+#include "internal.h"
 
 /*
  * swapper_space is a fiction, retained to simplify the path through
@@ -418,7 +419,8 @@ struct page *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 		/* May fail (-ENOMEM) if XArray node allocation failed. */
 		__SetPageLocked(new_page);
 		__SetPageSwapBacked(new_page);
-		err = add_to_swap_cache(new_page, entry, gfp_mask & GFP_KERNEL);
+		err = add_to_swap_cache(new_page, entry,
+					gfp_mask & GFP_RECLAIM_MASK);
 		if (likely(!err)) {
 			/* Initiate read into locked page */
 			SetPageWorkingset(new_page);
-- 
2.25.1



