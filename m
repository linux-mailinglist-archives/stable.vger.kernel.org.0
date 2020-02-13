Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68B9415C4F0
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:54:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728651AbgBMPwC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:52:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:43710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729158AbgBMP0J (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:26:09 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B86FD246AD;
        Thu, 13 Feb 2020 15:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607567;
        bh=AZf1ilQSuwZ93J1u0Y6EfUd8PFcxn0YgQPXREk2Kgb8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PtblcR2+OkVgi5koMebjGYhMjq9qDhjMtEH/Sf6OFwfZl3VXxqL86+V9BSrj4ump2
         NYFz9NntXZ68wtFGCglV5SkJuEtl9NGiCVwo4IXrJA/ly7e0Z1cJnIViikFfl47Ugn
         Xdtp/AW+anGzuu5OTtI4fXPesB1Pzj/WKp+vCCGE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>,
        Thiago Jung Bauermann <bauerman@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.14 159/173] powerpc/pseries: Allow not having ibm, hypertas-functions::hcall-multi-tce for DDW
Date:   Thu, 13 Feb 2020 07:21:02 -0800
Message-Id: <20200213152011.399240585@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151931.677980430@linuxfoundation.org>
References: <20200213151931.677980430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Kardashevskiy <aik@ozlabs.ru>

commit 7559d3d295f3365ea7ac0c0274c05e633fe4f594 upstream.

By default a pseries guest supports a H_PUT_TCE hypercall which maps
a single IOMMU page in a DMA window. Additionally the hypervisor may
support H_PUT_TCE_INDIRECT/H_STUFF_TCE which update multiple TCEs at once;
this is advertised via the device tree /rtas/ibm,hypertas-functions
property which Linux converts to FW_FEATURE_MULTITCE.

FW_FEATURE_MULTITCE is checked when dma_iommu_ops is used; however
the code managing the huge DMA window (DDW) ignores it and calls
H_PUT_TCE_INDIRECT even if it is explicitly disabled via
the "multitce=off" kernel command line parameter.

This adds FW_FEATURE_MULTITCE checking to the DDW code path.

This changes tce_build_pSeriesLP to take liobn and page size as
the huge window does not have iommu_table descriptor which usually
the place to store these numbers.

Fixes: 4e8b0cf46b25 ("powerpc/pseries: Add support for dynamic dma windows")
Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Reviewed-by: Thiago Jung Bauermann <bauerman@linux.ibm.com>
Tested-by: Thiago Jung Bauermann <bauerman@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20191216041924.42318-3-aik@ozlabs.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/platforms/pseries/iommu.c |   43 ++++++++++++++++++++++-----------
 1 file changed, 29 insertions(+), 14 deletions(-)

--- a/arch/powerpc/platforms/pseries/iommu.c
+++ b/arch/powerpc/platforms/pseries/iommu.c
@@ -168,10 +168,10 @@ static unsigned long tce_get_pseries(str
 	return be64_to_cpu(*tcep);
 }
 
-static void tce_free_pSeriesLP(struct iommu_table*, long, long);
+static void tce_free_pSeriesLP(unsigned long liobn, long, long);
 static void tce_freemulti_pSeriesLP(struct iommu_table*, long, long);
 
-static int tce_build_pSeriesLP(struct iommu_table *tbl, long tcenum,
+static int tce_build_pSeriesLP(unsigned long liobn, long tcenum, long tceshift,
 				long npages, unsigned long uaddr,
 				enum dma_data_direction direction,
 				unsigned long attrs)
@@ -182,25 +182,25 @@ static int tce_build_pSeriesLP(struct io
 	int ret = 0;
 	long tcenum_start = tcenum, npages_start = npages;
 
-	rpn = __pa(uaddr) >> TCE_SHIFT;
+	rpn = __pa(uaddr) >> tceshift;
 	proto_tce = TCE_PCI_READ;
 	if (direction != DMA_TO_DEVICE)
 		proto_tce |= TCE_PCI_WRITE;
 
 	while (npages--) {
-		tce = proto_tce | (rpn & TCE_RPN_MASK) << TCE_RPN_SHIFT;
-		rc = plpar_tce_put((u64)tbl->it_index, (u64)tcenum << 12, tce);
+		tce = proto_tce | (rpn & TCE_RPN_MASK) << tceshift;
+		rc = plpar_tce_put((u64)liobn, (u64)tcenum << tceshift, tce);
 
 		if (unlikely(rc == H_NOT_ENOUGH_RESOURCES)) {
 			ret = (int)rc;
-			tce_free_pSeriesLP(tbl, tcenum_start,
+			tce_free_pSeriesLP(liobn, tcenum_start,
 			                   (npages_start - (npages + 1)));
 			break;
 		}
 
 		if (rc && printk_ratelimit()) {
 			printk("tce_build_pSeriesLP: plpar_tce_put failed. rc=%lld\n", rc);
-			printk("\tindex   = 0x%llx\n", (u64)tbl->it_index);
+			printk("\tindex   = 0x%llx\n", (u64)liobn);
 			printk("\ttcenum  = 0x%llx\n", (u64)tcenum);
 			printk("\ttce val = 0x%llx\n", tce );
 			dump_stack();
@@ -229,7 +229,8 @@ static int tce_buildmulti_pSeriesLP(stru
 	unsigned long flags;
 
 	if ((npages == 1) || !firmware_has_feature(FW_FEATURE_MULTITCE)) {
-		return tce_build_pSeriesLP(tbl, tcenum, npages, uaddr,
+		return tce_build_pSeriesLP(tbl->it_index, tcenum,
+					   tbl->it_page_shift, npages, uaddr,
 		                           direction, attrs);
 	}
 
@@ -245,8 +246,9 @@ static int tce_buildmulti_pSeriesLP(stru
 		/* If allocation fails, fall back to the loop implementation */
 		if (!tcep) {
 			local_irq_restore(flags);
-			return tce_build_pSeriesLP(tbl, tcenum, npages, uaddr,
-					    direction, attrs);
+			return tce_build_pSeriesLP(tbl->it_index, tcenum,
+					tbl->it_page_shift,
+					npages, uaddr, direction, attrs);
 		}
 		__this_cpu_write(tce_page, tcep);
 	}
@@ -297,16 +299,16 @@ static int tce_buildmulti_pSeriesLP(stru
 	return ret;
 }
 
-static void tce_free_pSeriesLP(struct iommu_table *tbl, long tcenum, long npages)
+static void tce_free_pSeriesLP(unsigned long liobn, long tcenum, long npages)
 {
 	u64 rc;
 
 	while (npages--) {
-		rc = plpar_tce_put((u64)tbl->it_index, (u64)tcenum << 12, 0);
+		rc = plpar_tce_put((u64)liobn, (u64)tcenum << 12, 0);
 
 		if (rc && printk_ratelimit()) {
 			printk("tce_free_pSeriesLP: plpar_tce_put failed. rc=%lld\n", rc);
-			printk("\tindex   = 0x%llx\n", (u64)tbl->it_index);
+			printk("\tindex   = 0x%llx\n", (u64)liobn);
 			printk("\ttcenum  = 0x%llx\n", (u64)tcenum);
 			dump_stack();
 		}
@@ -321,7 +323,7 @@ static void tce_freemulti_pSeriesLP(stru
 	u64 rc;
 
 	if (!firmware_has_feature(FW_FEATURE_MULTITCE))
-		return tce_free_pSeriesLP(tbl, tcenum, npages);
+		return tce_free_pSeriesLP(tbl->it_index, tcenum, npages);
 
 	rc = plpar_tce_stuff((u64)tbl->it_index, (u64)tcenum << 12, 0, npages);
 
@@ -436,6 +438,19 @@ static int tce_setrange_multi_pSeriesLP(
 	u64 rc = 0;
 	long l, limit;
 
+	if (!firmware_has_feature(FW_FEATURE_MULTITCE)) {
+		unsigned long tceshift = be32_to_cpu(maprange->tce_shift);
+		unsigned long dmastart = (start_pfn << PAGE_SHIFT) +
+				be64_to_cpu(maprange->dma_base);
+		unsigned long tcenum = dmastart >> tceshift;
+		unsigned long npages = num_pfn << PAGE_SHIFT >> tceshift;
+		void *uaddr = __va(start_pfn << PAGE_SHIFT);
+
+		return tce_build_pSeriesLP(be32_to_cpu(maprange->liobn),
+				tcenum, tceshift, npages, (unsigned long) uaddr,
+				DMA_BIDIRECTIONAL, 0);
+	}
+
 	local_irq_disable();	/* to protect tcep and the page behind it */
 	tcep = __this_cpu_read(tce_page);
 


