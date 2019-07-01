Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79F6E28A3D
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388156AbfEWTLZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:11:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:44796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388149AbfEWTLW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:11:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A7042133D;
        Thu, 23 May 2019 19:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558638680;
        bh=vzhfTJ97BGxVjMM+ATRbKdyXND1DRBOzdjpRgC+cRmc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GBDnZRpZjOOYCaFLCfbWD3Sux+COdaTUe+X28IrMZo8GwEfyAkKeSzOa6sWyX1MEj
         ldHLuZkP+RXcxKuyUezT1d8/DeEMHkfaRrLLy1jReoiR1L084nJHna5VfaQoWttEMU
         ZkBVqd7qVYDmsBL0VIx08VZFqKhsyHOgUom/Yp44=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [PATCH 4.14 17/77] intel_th: msu: Fix single mode with IOMMU
Date:   Thu, 23 May 2019 21:05:35 +0200
Message-Id: <20190523181722.621903839@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181719.982121681@linuxfoundation.org>
References: <20190523181719.982121681@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Shishkin <alexander.shishkin@linux.intel.com>

commit 4e0eaf239fb33ebc671303e2b736fa043462e2f4 upstream.

Currently, the pages that are allocated for the single mode of MSC are not
mapped into the device's dma space and the code is incorrectly using
*_to_phys() in place of a dma address. This fails with IOMMU enabled and
is otherwise bad practice.

Fix the single mode buffer allocation to map the pages into the device's
DMA space.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Fixes: ba82664c134e ("intel_th: Add Memory Storage Unit driver")
Cc: stable@vger.kernel.org # v4.4+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwtracing/intel_th/msu.c |   35 ++++++++++++++++++++++++++++++++---
 1 file changed, 32 insertions(+), 3 deletions(-)

--- a/drivers/hwtracing/intel_th/msu.c
+++ b/drivers/hwtracing/intel_th/msu.c
@@ -92,6 +92,7 @@ struct msc_iter {
  * @reg_base:		register window base address
  * @thdev:		intel_th_device pointer
  * @win_list:		list of windows in multiblock mode
+ * @single_sgt:		single mode buffer
  * @nr_pages:		total number of pages allocated for this buffer
  * @single_sz:		amount of data in single mode
  * @single_wrap:	single mode wrap occurred
@@ -112,6 +113,7 @@ struct msc {
 	struct intel_th_device	*thdev;
 
 	struct list_head	win_list;
+	struct sg_table		single_sgt;
 	unsigned long		nr_pages;
 	unsigned long		single_sz;
 	unsigned int		single_wrap : 1;
@@ -625,22 +627,45 @@ static void intel_th_msc_deactivate(stru
  */
 static int msc_buffer_contig_alloc(struct msc *msc, unsigned long size)
 {
+	unsigned long nr_pages = size >> PAGE_SHIFT;
 	unsigned int order = get_order(size);
 	struct page *page;
+	int ret;
 
 	if (!size)
 		return 0;
 
+	ret = sg_alloc_table(&msc->single_sgt, 1, GFP_KERNEL);
+	if (ret)
+		goto err_out;
+
+	ret = -ENOMEM;
 	page = alloc_pages(GFP_KERNEL | __GFP_ZERO, order);
 	if (!page)
-		return -ENOMEM;
+		goto err_free_sgt;
 
 	split_page(page, order);
-	msc->nr_pages = size >> PAGE_SHIFT;
+	sg_set_buf(msc->single_sgt.sgl, page_address(page), size);
+
+	ret = dma_map_sg(msc_dev(msc)->parent->parent, msc->single_sgt.sgl, 1,
+			 DMA_FROM_DEVICE);
+	if (ret < 0)
+		goto err_free_pages;
+
+	msc->nr_pages = nr_pages;
 	msc->base = page_address(page);
-	msc->base_addr = page_to_phys(page);
+	msc->base_addr = sg_dma_address(msc->single_sgt.sgl);
 
 	return 0;
+
+err_free_pages:
+	__free_pages(page, order);
+
+err_free_sgt:
+	sg_free_table(&msc->single_sgt);
+
+err_out:
+	return ret;
 }
 
 /**
@@ -651,6 +676,10 @@ static void msc_buffer_contig_free(struc
 {
 	unsigned long off;
 
+	dma_unmap_sg(msc_dev(msc)->parent->parent, msc->single_sgt.sgl,
+		     1, DMA_FROM_DEVICE);
+	sg_free_table(&msc->single_sgt);
+
 	for (off = 0; off < msc->nr_pages << PAGE_SHIFT; off += PAGE_SIZE) {
 		struct page *page = virt_to_page(msc->base + off);
 


