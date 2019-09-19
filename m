Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C43AB8502
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406334AbfISWQg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:16:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:57230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406331AbfISWQg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:16:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36E3321A49;
        Thu, 19 Sep 2019 22:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568931395;
        bh=YC0WJzuqTRA7+YNRCGTQLnco4VMdrdFFmvdF3+/Ysw4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=humT7wFZHdJ+VLp8DB8KDPFyUmbhaBVSifvuG3VUvQKMI3qSKejnlPZpe1xyCZJ7L
         sjtJJa6ktzdiw0Uh0ZAvgcvwbDcu9BjKkVqDq9KiEd9R2Q8B/Sx5X+decqRzBrDPUG
         SyjrDzAMJMUXFHJJ2LQBofq4LJ7t+n+TRTu7Bs+U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.14 03/59] powerpc/mm/radix: Use the right page size for vmemmap mapping
Date:   Fri, 20 Sep 2019 00:03:18 +0200
Message-Id: <20190919214756.748600031@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214755.852282682@linuxfoundation.org>
References: <20190919214755.852282682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>

commit 89a3496e0664577043666791ec07fb731d57c950 upstream.

We use mmu_vmemmap_psize to find the page size for mapping the vmmemap area.
With radix translation, we are suboptimally setting this value to PAGE_SIZE.

We do check for 2M page size support and update mmu_vmemap_psize to use
hugepage size but we suboptimally reset the value to PAGE_SIZE in
radix__early_init_mmu(). This resulted in always mapping vmemmap area with
64K page size.

Fixes: 2bfd65e45e87 ("powerpc/mm/radix: Add radix callbacks for early init routines")
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/mm/pgtable-radix.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

--- a/arch/powerpc/mm/pgtable-radix.c
+++ b/arch/powerpc/mm/pgtable-radix.c
@@ -442,14 +442,6 @@ void __init radix__early_init_devtree(vo
 	mmu_psize_defs[MMU_PAGE_64K].shift = 16;
 	mmu_psize_defs[MMU_PAGE_64K].ap = 0x5;
 found:
-#ifdef CONFIG_SPARSEMEM_VMEMMAP
-	if (mmu_psize_defs[MMU_PAGE_2M].shift) {
-		/*
-		 * map vmemmap using 2M if available
-		 */
-		mmu_vmemmap_psize = MMU_PAGE_2M;
-	}
-#endif /* CONFIG_SPARSEMEM_VMEMMAP */
 	return;
 }
 
@@ -527,7 +519,13 @@ void __init radix__early_init_mmu(void)
 
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
 	/* vmemmap mapping */
-	mmu_vmemmap_psize = mmu_virtual_psize;
+	if (mmu_psize_defs[MMU_PAGE_2M].shift) {
+		/*
+		 * map vmemmap using 2M if available
+		 */
+		mmu_vmemmap_psize = MMU_PAGE_2M;
+	} else
+		mmu_vmemmap_psize = mmu_virtual_psize;
 #endif
 	/*
 	 * initialize page table size


