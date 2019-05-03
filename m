Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 542F312A01
	for <lists+stable@lfdr.de>; Fri,  3 May 2019 10:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbfECIpX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 May 2019 04:45:23 -0400
Received: from mga01.intel.com ([192.55.52.88]:5527 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726193AbfECIpW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 May 2019 04:45:22 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 May 2019 01:45:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,425,1549958400"; 
   d="scan'208";a="147811520"
Received: from black.fi.intel.com (HELO black.fi.intel.com.) ([10.237.72.28])
  by orsmga003.jf.intel.com with ESMTP; 03 May 2019 01:45:20 -0700
From:   Alexander Shishkin <alexander.shishkin@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        stable@vger.kernel.org
Subject: [GIT PULL 01/22] intel_th: msu: Fix single mode with IOMMU
Date:   Fri,  3 May 2019 11:44:34 +0300
Message-Id: <20190503084455.23436-2-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190503084455.23436-1-alexander.shishkin@linux.intel.com>
References: <20190503084455.23436-1-alexander.shishkin@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Currently, the pages that are allocated for the single mode of MSC are not
mapped into the device's dma space and the code is incorrectly using
*_to_phys() in place of a dma address. This fails with IOMMU enabled and
is otherwise bad practice.

Fix the single mode buffer allocation to map the pages into the device's
DMA space.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Fixes: ba82664c134e ("intel_th: Add Memory Storage Unit driver")
Cc: stable@vger.kernel.org # v4.4+
---
 drivers/hwtracing/intel_th/msu.c | 35 +++++++++++++++++++++++++++++---
 1 file changed, 32 insertions(+), 3 deletions(-)

diff --git a/drivers/hwtracing/intel_th/msu.c b/drivers/hwtracing/intel_th/msu.c
index ba7aaf421f36..8ff326c0c406 100644
--- a/drivers/hwtracing/intel_th/msu.c
+++ b/drivers/hwtracing/intel_th/msu.c
@@ -84,6 +84,7 @@ struct msc_iter {
  * @reg_base:		register window base address
  * @thdev:		intel_th_device pointer
  * @win_list:		list of windows in multiblock mode
+ * @single_sgt:		single mode buffer
  * @nr_pages:		total number of pages allocated for this buffer
  * @single_sz:		amount of data in single mode
  * @single_wrap:	single mode wrap occurred
@@ -104,6 +105,7 @@ struct msc {
 	struct intel_th_device	*thdev;
 
 	struct list_head	win_list;
+	struct sg_table		single_sgt;
 	unsigned long		nr_pages;
 	unsigned long		single_sz;
 	unsigned int		single_wrap : 1;
@@ -617,22 +619,45 @@ static void intel_th_msc_deactivate(struct intel_th_device *thdev)
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
@@ -643,6 +668,10 @@ static void msc_buffer_contig_free(struct msc *msc)
 {
 	unsigned long off;
 
+	dma_unmap_sg(msc_dev(msc)->parent->parent, msc->single_sgt.sgl,
+		     1, DMA_FROM_DEVICE);
+	sg_free_table(&msc->single_sgt);
+
 	for (off = 0; off < msc->nr_pages << PAGE_SHIFT; off += PAGE_SIZE) {
 		struct page *page = virt_to_page(msc->base + off);
 
-- 
2.20.1

