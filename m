Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46C04CD60A
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:43:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731371AbfJFRmy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:42:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:42746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730705AbfJFRmw (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:42:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69B272087E;
        Sun,  6 Oct 2019 17:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383770;
        bh=hotPHqNA0Hauqn1+we+VM6z41hs1TrkZFPv6VGRGl50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OWvSNPpH1j8jYgq12vg1MkQlADdrebNmE7aHAbvZZz3fH0EGcz3EF1SLwYkb/fupX
         Ug1aP/QzCk16RKC/Nuuhla2+laPjtK5gEmBqBgMb7dyEgweFmQVAe6Gzb0NJNiGR1q
         17EdNyXgR+dpnoGvjOfsOKRKXwUMM9eQHWnsuGwU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anju T Sudhakar <anju@linux.vnet.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 045/166] powerpc/perf: fix imc allocation failure handling
Date:   Sun,  6 Oct 2019 19:20:11 +0200
Message-Id: <20191006171216.768222939@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171212.850660298@linuxfoundation.org>
References: <20191006171212.850660298@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit 10c4bd7cd28e77aeb8cfa65b23cb3c632ede2a49 ]

The alloc_pages_node return value should be tested for failure
before being passed to page_address.

Tested-by: Anju T Sudhakar <anju@linux.vnet.ibm.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20190724084638.24982-3-npiggin@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/perf/imc-pmu.c | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/arch/powerpc/perf/imc-pmu.c b/arch/powerpc/perf/imc-pmu.c
index dea243185ea4b..cb50a9e1fd2d7 100644
--- a/arch/powerpc/perf/imc-pmu.c
+++ b/arch/powerpc/perf/imc-pmu.c
@@ -577,6 +577,7 @@ static int core_imc_mem_init(int cpu, int size)
 {
 	int nid, rc = 0, core_id = (cpu / threads_per_core);
 	struct imc_mem_info *mem_info;
+	struct page *page;
 
 	/*
 	 * alloc_pages_node() will allocate memory for core in the
@@ -587,11 +588,12 @@ static int core_imc_mem_init(int cpu, int size)
 	mem_info->id = core_id;
 
 	/* We need only vbase for core counters */
-	mem_info->vbase = page_address(alloc_pages_node(nid,
-					  GFP_KERNEL | __GFP_ZERO | __GFP_THISNODE |
-					  __GFP_NOWARN, get_order(size)));
-	if (!mem_info->vbase)
+	page = alloc_pages_node(nid,
+				GFP_KERNEL | __GFP_ZERO | __GFP_THISNODE |
+				__GFP_NOWARN, get_order(size));
+	if (!page)
 		return -ENOMEM;
+	mem_info->vbase = page_address(page);
 
 	/* Init the mutex */
 	core_imc_refc[core_id].id = core_id;
@@ -849,15 +851,17 @@ static int thread_imc_mem_alloc(int cpu_id, int size)
 	int nid = cpu_to_node(cpu_id);
 
 	if (!local_mem) {
+		struct page *page;
 		/*
 		 * This case could happen only once at start, since we dont
 		 * free the memory in cpu offline path.
 		 */
-		local_mem = page_address(alloc_pages_node(nid,
+		page = alloc_pages_node(nid,
 				  GFP_KERNEL | __GFP_ZERO | __GFP_THISNODE |
-				  __GFP_NOWARN, get_order(size)));
-		if (!local_mem)
+				  __GFP_NOWARN, get_order(size));
+		if (!page)
 			return -ENOMEM;
+		local_mem = page_address(page);
 
 		per_cpu(thread_imc_mem, cpu_id) = local_mem;
 	}
@@ -1095,11 +1099,14 @@ static int trace_imc_mem_alloc(int cpu_id, int size)
 	int core_id = (cpu_id / threads_per_core);
 
 	if (!local_mem) {
-		local_mem = page_address(alloc_pages_node(phys_id,
-					GFP_KERNEL | __GFP_ZERO | __GFP_THISNODE |
-					__GFP_NOWARN, get_order(size)));
-		if (!local_mem)
+		struct page *page;
+
+		page = alloc_pages_node(phys_id,
+				GFP_KERNEL | __GFP_ZERO | __GFP_THISNODE |
+				__GFP_NOWARN, get_order(size));
+		if (!page)
 			return -ENOMEM;
+		local_mem = page_address(page);
 		per_cpu(trace_imc_mem, cpu_id) = local_mem;
 
 		/* Initialise the counters for trace mode */
-- 
2.20.1



