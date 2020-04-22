Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 933E31B3EFE
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:35:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731179AbgDVKdS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:33:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:33256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729736AbgDVKYt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:24:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A41FE2071E;
        Wed, 22 Apr 2020 10:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587551089;
        bh=fa6sFC6ExgJLrtzdqYbGOIXx3ZLfMUmZOOEM2DJyOJ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=exhyVC7CPoTysCJE84517JputvHvV7SQu6JszM6LHhXbFgctUcFzNBRiLZ9z7/n7O
         beF5RS+NozFSpMZ7mJBPhmc0mLuNo+HdHlKqGmKUQ0hRYegE9WTbKWdceHgOTfoSRx
         qLNCoh0GUYp+wUEDI6rQ8ZGoBDlANWmkbiQt/tW4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kevin Grandemange <kevin.grandemange@allegrodvt.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 069/166] dma-coherent: fix integer overflow in the reserved-memory dma allocation
Date:   Wed, 22 Apr 2020 11:56:36 +0200
Message-Id: <20200422095056.319089776@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095047.669225321@linuxfoundation.org>
References: <20200422095047.669225321@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kevin Grandemange <kevin.grandemange@allegrodvt.com>

[ Upstream commit 286c21de32b904131f8cf6a36ce40b8b0c9c5da3 ]

pageno is an int and the PAGE_SHIFT shift is done on an int,
overflowing if the memory is bigger than 2G

This can be reproduced using for example a reserved-memory of 4G

reserved-memory {
		    #address-cells = <2>;
		    #size-cells = <2>;
		    ranges;

		    reserved_dma: buffer@0 {
		        compatible = "shared-dma-pool";
		        no-map;
		        reg = <0x5 0x00000000 0x1 0x0>;
        };
};

Signed-off-by: Kevin Grandemange <kevin.grandemange@allegrodvt.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/coherent.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/kernel/dma/coherent.c b/kernel/dma/coherent.c
index 551b0eb7028a3..2a0c4985f38e4 100644
--- a/kernel/dma/coherent.c
+++ b/kernel/dma/coherent.c
@@ -134,7 +134,7 @@ static void *__dma_alloc_from_coherent(struct device *dev,
 
 	spin_lock_irqsave(&mem->spinlock, flags);
 
-	if (unlikely(size > (mem->size << PAGE_SHIFT)))
+	if (unlikely(size > ((dma_addr_t)mem->size << PAGE_SHIFT)))
 		goto err;
 
 	pageno = bitmap_find_free_region(mem->bitmap, mem->size, order);
@@ -144,8 +144,9 @@ static void *__dma_alloc_from_coherent(struct device *dev,
 	/*
 	 * Memory was found in the coherent area.
 	 */
-	*dma_handle = dma_get_device_base(dev, mem) + (pageno << PAGE_SHIFT);
-	ret = mem->virt_base + (pageno << PAGE_SHIFT);
+	*dma_handle = dma_get_device_base(dev, mem) +
+			((dma_addr_t)pageno << PAGE_SHIFT);
+	ret = mem->virt_base + ((dma_addr_t)pageno << PAGE_SHIFT);
 	spin_unlock_irqrestore(&mem->spinlock, flags);
 	memset(ret, 0, size);
 	return ret;
@@ -194,7 +195,7 @@ static int __dma_release_from_coherent(struct dma_coherent_mem *mem,
 				       int order, void *vaddr)
 {
 	if (mem && vaddr >= mem->virt_base && vaddr <
-		   (mem->virt_base + (mem->size << PAGE_SHIFT))) {
+		   (mem->virt_base + ((dma_addr_t)mem->size << PAGE_SHIFT))) {
 		int page = (vaddr - mem->virt_base) >> PAGE_SHIFT;
 		unsigned long flags;
 
@@ -238,10 +239,10 @@ static int __dma_mmap_from_coherent(struct dma_coherent_mem *mem,
 		struct vm_area_struct *vma, void *vaddr, size_t size, int *ret)
 {
 	if (mem && vaddr >= mem->virt_base && vaddr + size <=
-		   (mem->virt_base + (mem->size << PAGE_SHIFT))) {
+		   (mem->virt_base + ((dma_addr_t)mem->size << PAGE_SHIFT))) {
 		unsigned long off = vma->vm_pgoff;
 		int start = (vaddr - mem->virt_base) >> PAGE_SHIFT;
-		int user_count = vma_pages(vma);
+		unsigned long user_count = vma_pages(vma);
 		int count = PAGE_ALIGN(size) >> PAGE_SHIFT;
 
 		*ret = -ENXIO;
-- 
2.20.1



