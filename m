Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 382B926192F
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 20:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731653AbgIHSIZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 14:08:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:55394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731474AbgIHQLt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:11:49 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A967824755;
        Tue,  8 Sep 2020 15:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579690;
        bh=1Z+DMCVOmFTDk1xzzyxtRiA/TPGGjSkbdbu8sDF+7eM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F+Qh0K40i1tU57aQKEbxd2nm3q9/3lJtsTWLSgwcTI4Dp+BbbvkDMaKZsNF6JxLqc
         sBOFnUOgvAXdRaJ7m+FWbFZbxcBe30tcfsJBNR8BPz0vgjSBrcjVNUTC8EMfetsxRG
         bdyc2o7SuCkh3LDPlxZpCi9oN67GL8990DrLvtuE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li Xinhai <lixinhai.lxh@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Michal Hocko <mhocko@suse.com>, Roman Gushchin <guro@fb.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.8 182/186] mm/hugetlb: try preferred node first when alloc gigantic page from cma
Date:   Tue,  8 Sep 2020 17:25:24 +0200
Message-Id: <20200908152250.494645111@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Xinhai <lixinhai.lxh@gmail.com>

commit 953f064aa6b29debcc211869b60bd59f26d19c34 upstream.

Since commit cf11e85fc08c ("mm: hugetlb: optionally allocate gigantic
hugepages using cma"), the gigantic page would be allocated from node
which is not the preferred node, although there are pages available from
that node.  The reason is that the nid parameter has been ignored in
alloc_gigantic_page().

Besides, the __GFP_THISNODE also need be checked if user required to
alloc only from the preferred node.

After this patch, the preferred node is tried first before other allowed
nodes, and don't try to allocate from other nodes if __GFP_THISNODE is
specified.  If user don't specify the preferred node, the current node
will be used as preferred node, which makes sure consistent behavior of
allocating gigantic and non-gigantic hugetlb page.

Fixes: cf11e85fc08c ("mm: hugetlb: optionally allocate gigantic hugepages using cma")
Signed-off-by: Li Xinhai <lixinhai.lxh@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <guro@fb.com>
Link: https://lkml.kernel.org/r/20200902025016.697260-1-lixinhai.lxh@gmail.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/hugetlb.c |   23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1251,21 +1251,32 @@ static struct page *alloc_gigantic_page(
 		int nid, nodemask_t *nodemask)
 {
 	unsigned long nr_pages = 1UL << huge_page_order(h);
+	if (nid == NUMA_NO_NODE)
+		nid = numa_mem_id();
 
 #ifdef CONFIG_CMA
 	{
 		struct page *page;
 		int node;
 
-		for_each_node_mask(node, *nodemask) {
-			if (!hugetlb_cma[node])
-				continue;
-
-			page = cma_alloc(hugetlb_cma[node], nr_pages,
-					 huge_page_order(h), true);
+		if (hugetlb_cma[nid]) {
+			page = cma_alloc(hugetlb_cma[nid], nr_pages,
+					huge_page_order(h), true);
 			if (page)
 				return page;
 		}
+
+		if (!(gfp_mask & __GFP_THISNODE)) {
+			for_each_node_mask(node, *nodemask) {
+				if (node == nid || !hugetlb_cma[node])
+					continue;
+
+				page = cma_alloc(hugetlb_cma[node], nr_pages,
+						huge_page_order(h), true);
+				if (page)
+					return page;
+			}
+		}
 	}
 #endif
 


