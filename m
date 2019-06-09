Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94E8D3A9E7
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732082AbfFIQ5X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:57:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:60250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733150AbfFIQ5U (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:57:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB597205ED;
        Sun,  9 Jun 2019 16:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099439;
        bh=gmt2Me0qsVJVcqWTKQY3pdGrABLDfhZqlgMA/l/Duuk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mdlyag/NmkHfydLLa8wLvkxZgYhRengUZzfc+J0f1iTkKzvnChVC0MZ7K2IFB9gst
         iPfJsKjFzilVkd+NPkscggcg2Xd/3KlLW1//UhzhYHyuYPGnCG8jG7HbzaF5xe6W0v
         5Srue6frD91odfEvgvDBjIY6XTl9tzze29FbcfXU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [PATCH 4.4 039/241] intel_th: msu: Fix single mode with IOMMU
Date:   Sun,  9 Jun 2019 18:39:41 +0200
Message-Id: <20190609164148.901223995@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
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
@@ -90,6 +90,7 @@ struct msc_iter {
  * @reg_base:		register window base address
  * @thdev:		intel_th_device pointer
  * @win_list:		list of windows in multiblock mode
+ * @single_sgt:		single mode buffer
  * @nr_pages:		total number of pages allocated for this buffer
  * @single_sz:		amount of data in single mode
  * @single_wrap:	single mode wrap occurred
@@ -110,6 +111,7 @@ struct msc {
 	struct intel_th_device	*thdev;
 
 	struct list_head	win_list;
+	struct sg_table		single_sgt;
 	unsigned long		nr_pages;
 	unsigned long		single_sz;
 	unsigned int		single_wrap : 1;
@@ -610,22 +612,45 @@ static void intel_th_msc_deactivate(stru
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
@@ -636,6 +661,10 @@ static void msc_buffer_contig_free(struc
 {
 	unsigned long off;
 
+	dma_unmap_sg(msc_dev(msc)->parent->parent, msc->single_sgt.sgl,
+		     1, DMA_FROM_DEVICE);
+	sg_free_table(&msc->single_sgt);
+
 	for (off = 0; off < msc->nr_pages << PAGE_SHIFT; off += PAGE_SIZE) {
 		struct page *page = virt_to_page(msc->base + off);
 


