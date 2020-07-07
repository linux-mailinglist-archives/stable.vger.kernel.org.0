Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78FAB2171EE
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729719AbgGGP04 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:26:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:41282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730320AbgGGP04 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:26:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE4FD2083B;
        Tue,  7 Jul 2020 15:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135615;
        bh=Q++ieKZs+FggROOSYsXHB3svrim3c2FEmtSU7gHAQUI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mZEo3jv3vhPGpPNAJgJjs56X9JWVNUYwDYJYjb1HZw8RZ8oB+izoZGTj1iwMrhtOh
         wue+HuWLk2Y30Moky6KkfSoK52fimhzw/wwlom3iRkD3rieljoed5nlgLBONignULU
         9YY/5Z1OKnePcnN8dEdD4BWjzXwtj5vMcKqqGH0U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Barry Song <song.bao.hua@hisilicon.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roman Gushchin <guro@fb.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Aslan Bakirov <aslan@fb.com>, Michal Hocko <mhocko@kernel.org>,
        Andreas Schaufler <andreas.schaufler@gmx.de>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Rik van Riel <riel@surriel.com>,
        Joonsoo Kim <js1304@gmail.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.7 110/112] mm/cma.c: use exact_nid true to fix possible per-numa cma leak
Date:   Tue,  7 Jul 2020 17:17:55 +0200
Message-Id: <20200707145806.202446239@linuxfoundation.org>
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

From: Barry Song <song.bao.hua@hisilicon.com>

commit 40366bd70bbbbf822ca224dfc227a8c8e868c44f upstream.

Calling cma_declare_contiguous_nid() with false exact_nid for per-numa
reservation can easily cause cma leak and various confusion.  For example,
mm/hugetlb.c is trying to reserve per-numa cma for gigantic pages.  But it
can easily leak cma and make users confused when system has memoryless
nodes.

In case the system has 4 numa nodes, and only numa node0 has memory.  if
we set hugetlb_cma=4G in bootargs, mm/hugetlb.c will get 4 cma areas for 4
different numa nodes.  since exact_nid=false in current code, all 4 numa
nodes will get cma successfully from node0, but hugetlb_cma[1 to 3] will
never be available to hugepage will only allocate memory from
hugetlb_cma[0].

In case the system has 4 numa nodes, both numa node0&2 has memory, other
nodes have no memory.  if we set hugetlb_cma=4G in bootargs, mm/hugetlb.c
will get 4 cma areas for 4 different numa nodes.  since exact_nid=false in
current code, all 4 numa nodes will get cma successfully from node0 or 2,
but hugetlb_cma[1] and [3] will never be available to hugepage as
mm/hugetlb.c will only allocate memory from hugetlb_cma[0] and
hugetlb_cma[2].  This causes permanent leak of the cma areas which are
supposed to be used by memoryless node.

Of cource we can workaround the issue by letting mm/hugetlb.c scan all cma
areas in alloc_gigantic_page() even node_mask includes node0 only.  that
means when node_mask includes node0 only, we can get page from
hugetlb_cma[1] to hugetlb_cma[3].  But this will cause kernel crash in
free_gigantic_page() while it wants to free page by:
cma_release(hugetlb_cma[page_to_nid(page)], page, 1 << order)

On the other hand, exact_nid=false won't consider numa distance, it might
be not that useful to leverage cma areas on remote nodes.  I feel it is
much simpler to make exact_nid true to make everything clear.  After that,
memoryless nodes won't be able to reserve per-numa CMA from other nodes
which have memory.

Fixes: cf11e85fc08c ("mm: hugetlb: optionally allocate gigantic hugepages using cma")
Signed-off-by: Barry Song <song.bao.hua@hisilicon.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Roman Gushchin <guro@fb.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Aslan Bakirov <aslan@fb.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Andreas Schaufler <andreas.schaufler@gmx.de>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: <stable@vger.kernel.org>
Link: http://lkml.kernel.org/r/20200628074345.27228-1-song.bao.hua@hisilicon.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/cma.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/cma.c
+++ b/mm/cma.c
@@ -339,13 +339,13 @@ int __init cma_declare_contiguous_nid(ph
 		 */
 		if (base < highmem_start && limit > highmem_start) {
 			addr = memblock_alloc_range_nid(size, alignment,
-					highmem_start, limit, nid, false);
+					highmem_start, limit, nid, true);
 			limit = highmem_start;
 		}
 
 		if (!addr) {
 			addr = memblock_alloc_range_nid(size, alignment, base,
-					limit, nid, false);
+					limit, nid, true);
 			if (!addr) {
 				ret = -ENOMEM;
 				goto err;


