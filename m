Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 956723290D3
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:16:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238136AbhCAUQM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:16:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:37644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236108AbhCAUFS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:05:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 255966518E;
        Mon,  1 Mar 2021 17:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621523;
        bh=BUL5uoNcCWdwokjMni+Ek+0yE3koJPM/U+6otJIt2vQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vH135KtS5mrDtumCs182W78A3GoB1LrIGoswbGw4Xz7w9uLKTlPx9iiVTYpxiTOXK
         Ze8UhSECCoAsFoQHSqVa8p2LCEaYejvSboNnM27Q9R/8PPoXcugseIXy+xwEhOL730
         4SxJXZj7gVSOobmJow7zvKM1jgufIogGfL23G/wU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
        Shakeel Butt <shakeelb@google.com>,
        Roman Gushchin <guro@fb.com>,
        =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 547/775] mm: memcontrol: fix slub memory accounting
Date:   Mon,  1 Mar 2021 17:11:55 +0100
Message-Id: <20210301161228.517586435@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>

[ Upstream commit 96403bfe50c344b587ea53894954a9d152af1c9d ]

SLUB currently account kmalloc() and kmalloc_node() allocations larger
than order-1 page per-node.  But it forget to update the per-memcg
vmstats.  So it can lead to inaccurate statistics of "slab_unreclaimable"
which is from memory.stat.  Fix it by using mod_lruvec_page_state instead
of mod_node_page_state.

Link: https://lkml.kernel.org/r/20210223092423.42420-1-songmuchun@bytedance.com
Fixes: 6a486c0ad4dc ("mm, sl[ou]b: improve memory accounting")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Michal Koutný <mkoutny@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/slab_common.c | 4 ++--
 mm/slub.c        | 8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index e981c80d216c2..0b775cb5c1089 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -837,8 +837,8 @@ void *kmalloc_order(size_t size, gfp_t flags, unsigned int order)
 	page = alloc_pages(flags, order);
 	if (likely(page)) {
 		ret = page_address(page);
-		mod_node_page_state(page_pgdat(page), NR_SLAB_UNRECLAIMABLE_B,
-				    PAGE_SIZE << order);
+		mod_lruvec_page_state(page, NR_SLAB_UNRECLAIMABLE_B,
+				      PAGE_SIZE << order);
 	}
 	ret = kasan_kmalloc_large(ret, size, flags);
 	/* As ret might get tagged, call kmemleak hook after KASAN. */
diff --git a/mm/slub.c b/mm/slub.c
index b22a4b101c846..69dacc61b8435 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3999,8 +3999,8 @@ static void *kmalloc_large_node(size_t size, gfp_t flags, int node)
 	page = alloc_pages_node(node, flags, order);
 	if (page) {
 		ptr = page_address(page);
-		mod_node_page_state(page_pgdat(page), NR_SLAB_UNRECLAIMABLE_B,
-				    PAGE_SIZE << order);
+		mod_lruvec_page_state(page, NR_SLAB_UNRECLAIMABLE_B,
+				      PAGE_SIZE << order);
 	}
 
 	return kmalloc_large_node_hook(ptr, size, flags);
@@ -4131,8 +4131,8 @@ void kfree(const void *x)
 
 		BUG_ON(!PageCompound(page));
 		kfree_hook(object);
-		mod_node_page_state(page_pgdat(page), NR_SLAB_UNRECLAIMABLE_B,
-				    -(PAGE_SIZE << order));
+		mod_lruvec_page_state(page, NR_SLAB_UNRECLAIMABLE_B,
+				      -(PAGE_SIZE << order));
 		__free_pages(page, order);
 		return;
 	}
-- 
2.27.0



