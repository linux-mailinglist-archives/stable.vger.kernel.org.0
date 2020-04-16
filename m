Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37F111AC343
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2898112AbgDPNk1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:40:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:53018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2898109AbgDPNk0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:40:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BC452076D;
        Thu, 16 Apr 2020 13:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044425;
        bh=UG+omDNmUoAj/lnia2Lo9HKh1rXW0017TCXQfL7YMLM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v/bqFV16iXxynvsnwNFeP2EKmTuOCS5Yn5iLXHMa3hkIWjoGR+zO1QLE/y+cGFDVX
         QZkPUYgcrq4Kb03saCui7Tc2SOQbwA/oxs5iElLrCzz1rc+o42shHp6tc0vNrGZ43X
         Kbs5TdmStocOY0f6Gel25CvPRTnK/j/3rK9FS3Lo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.5 213/257] drm/prime: fix extracting of the DMA addresses from a scatterlist
Date:   Thu, 16 Apr 2020 15:24:24 +0200
Message-Id: <20200416131352.669962384@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.891903893@linuxfoundation.org>
References: <20200416131325.891903893@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Szyprowski <m.szyprowski@samsung.com>

commit c0f83d164fb8f3a2b7bc379a6c1e27d1123a9eab upstream.

Scatterlist elements contains both pages and DMA addresses, but one
should not assume 1:1 relation between them. The sg->length is the size
of the physical memory chunk described by the sg->page, while
sg_dma_len(sg) is the size of the DMA (IO virtual) chunk described by
the sg_dma_address(sg).

The proper way of extracting both: pages and DMA addresses of the whole
buffer described by a scatterlist it to iterate independently over the
sg->pages/sg->length and sg_dma_address(sg)/sg_dma_len(sg) entries.

Fixes: 42e67b479eab ("drm/prime: use dma length macro when mapping sg")
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200327162126.29705-1-m.szyprowski@samsung.com
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/drm_prime.c |   37 +++++++++++++++++++++++++------------
 1 file changed, 25 insertions(+), 12 deletions(-)

--- a/drivers/gpu/drm/drm_prime.c
+++ b/drivers/gpu/drm/drm_prime.c
@@ -959,27 +959,40 @@ int drm_prime_sg_to_page_addr_arrays(str
 	unsigned count;
 	struct scatterlist *sg;
 	struct page *page;
-	u32 len, index;
+	u32 page_len, page_index;
 	dma_addr_t addr;
+	u32 dma_len, dma_index;
 
-	index = 0;
+	/*
+	 * Scatterlist elements contains both pages and DMA addresses, but
+	 * one shoud not assume 1:1 relation between them. The sg->length is
+	 * the size of the physical memory chunk described by the sg->page,
+	 * while sg_dma_len(sg) is the size of the DMA (IO virtual) chunk
+	 * described by the sg_dma_address(sg).
+	 */
+	page_index = 0;
+	dma_index = 0;
 	for_each_sg(sgt->sgl, sg, sgt->nents, count) {
-		len = sg_dma_len(sg);
+		page_len = sg->length;
 		page = sg_page(sg);
+		dma_len = sg_dma_len(sg);
 		addr = sg_dma_address(sg);
 
-		while (len > 0) {
-			if (WARN_ON(index >= max_entries))
+		while (pages && page_len > 0) {
+			if (WARN_ON(page_index >= max_entries))
 				return -1;
-			if (pages)
-				pages[index] = page;
-			if (addrs)
-				addrs[index] = addr;
-
+			pages[page_index] = page;
 			page++;
+			page_len -= PAGE_SIZE;
+			page_index++;
+		}
+		while (addrs && dma_len > 0) {
+			if (WARN_ON(dma_index >= max_entries))
+				return -1;
+			addrs[dma_index] = addr;
 			addr += PAGE_SIZE;
-			len -= PAGE_SIZE;
-			index++;
+			dma_len -= PAGE_SIZE;
+			dma_index++;
 		}
 	}
 	return 0;


