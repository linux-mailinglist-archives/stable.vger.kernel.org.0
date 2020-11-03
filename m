Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A52A2A5141
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:40:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729526AbgKCUit (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:38:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:49262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729403AbgKCUis (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:38:48 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5AB0122277;
        Tue,  3 Nov 2020 20:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604435927;
        bh=kgeIlsTT05XlXvQJ8pWD+5Y2tPCb2uZZkCHsNJwG7fI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V8RkMYhcfosBxc+D47hV9DMLfF9K7EUUYJknDZQnD9sO0LNtgNxMSgr2FxZa9tDxH
         1pxxvU2ZkyGE1QNngQCDiR5DnOoqSO5igkZWvu7xn47FAJNGTQCC7vQPcbt8z0BiLs
         lq4uDv3m8tAOvmMgVPLVXx+WEpvqclmAktyIcH54=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 043/391] powerpc/vmemmap: Fix memory leak with vmemmap list allocation failures.
Date:   Tue,  3 Nov 2020 21:31:34 +0100
Message-Id: <20201103203350.517420128@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>

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
2.27.0



