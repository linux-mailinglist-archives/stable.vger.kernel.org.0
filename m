Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77341299B16
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 00:49:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408588AbgJZXtJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 19:49:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:46674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408582AbgJZXtH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 19:49:07 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB34C20773;
        Mon, 26 Oct 2020 23:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756147;
        bh=727kUY/DmPJJ0W0lhr5vNjKxpO8k3WyXL/OwS/sssYI=;
        h=From:To:Cc:Subject:Date:From;
        b=epkS9ljxefbN50b3pi/M2klF5ZB959Y2ge0gvHyTWT0JdFlrsNmLmbtzOTdKpSujW
         H3quDq8JxvbG0aB82Zb2THHebPNR9eZidWo2cQMw15SEMz9LTYxEVZH6vUYQt6nPiO
         s91ILaFbvKtYo1/k4+UV/HX+cssRozEc/urth1Dw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.9 001/147] powerpc/vmemmap: Fix memory leak with vmemmap list allocation failures.
Date:   Mon, 26 Oct 2020 19:46:39 -0400
Message-Id: <20201026234905.1022767-1-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>

[ Upstream commit ccaea15296f9773abd43aaa17ee4b88848e4a505 ]

If we fail to allocate vmemmap list, we don't keep track of allocated
vmemmap block buf. Hence on section deactivate we skip vmemmap block
buf free. This results in memory leak.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200731113500.248306-1-aneesh.kumar@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/mm/init_64.c | 35 ++++++++++++++++++++++++++++-------
 1 file changed, 28 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/mm/init_64.c b/arch/powerpc/mm/init_64.c
index 8459056cce671..2ae42c2a5cf04 100644
--- a/arch/powerpc/mm/init_64.c
+++ b/arch/powerpc/mm/init_64.c
@@ -162,16 +162,16 @@ static __meminit struct vmemmap_backing * vmemmap_list_alloc(int node)
 	return next++;
 }
 
-static __meminit void vmemmap_list_populate(unsigned long phys,
-					    unsigned long start,
-					    int node)
+static __meminit int vmemmap_list_populate(unsigned long phys,
+					   unsigned long start,
+					   int node)
 {
 	struct vmemmap_backing *vmem_back;
 
 	vmem_back = vmemmap_list_alloc(node);
 	if (unlikely(!vmem_back)) {
-		WARN_ON(1);
-		return;
+		pr_debug("vmemap list allocation failed\n");
+		return -ENOMEM;
 	}
 
 	vmem_back->phys = phys;
@@ -179,6 +179,7 @@ static __meminit void vmemmap_list_populate(unsigned long phys,
 	vmem_back->list = vmemmap_list;
 
 	vmemmap_list = vmem_back;
+	return 0;
 }
 
 static bool altmap_cross_boundary(struct vmem_altmap *altmap, unsigned long start,
@@ -199,6 +200,7 @@ static bool altmap_cross_boundary(struct vmem_altmap *altmap, unsigned long star
 int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
 		struct vmem_altmap *altmap)
 {
+	bool altmap_alloc;
 	unsigned long page_size = 1 << mmu_psize_defs[mmu_vmemmap_psize].shift;
 
 	/* Align to the page size of the linear mapping. */
@@ -228,13 +230,32 @@ int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
 			p = vmemmap_alloc_block_buf(page_size, node, altmap);
 			if (!p)
 				pr_debug("altmap block allocation failed, falling back to system memory");
+			else
+				altmap_alloc = true;
 		}
-		if (!p)
+		if (!p) {
 			p = vmemmap_alloc_block_buf(page_size, node, NULL);
+			altmap_alloc = false;
+		}
 		if (!p)
 			return -ENOMEM;
 
-		vmemmap_list_populate(__pa(p), start, node);
+		if (vmemmap_list_populate(__pa(p), start, node)) {
+			/*
+			 * If we don't populate vmemap list, we don't have
+			 * the ability to free the allocated vmemmap
+			 * pages in section_deactivate. Hence free them
+			 * here.
+			 */
+			int nr_pfns = page_size >> PAGE_SHIFT;
+			unsigned long page_order = get_order(page_size);
+
+			if (altmap_alloc)
+				vmem_altmap_free(altmap, nr_pfns);
+			else
+				free_pages((unsigned long)p, page_order);
+			return -ENOMEM;
+		}
 
 		pr_debug("      * %016lx..%016lx allocated at %p\n",
 			 start, start + page_size, p);
-- 
2.25.1

