Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8EA373A24
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 14:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233312AbhEEMHn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 08:07:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:47794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233376AbhEEMHY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 08:07:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6BD77613B3;
        Wed,  5 May 2021 12:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620216387;
        bh=nKScMyZidbAGPHP51zjT3G2yJtXb4ABU9jEX63KpUDI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zt3lnw4iLhkj/J3dWkfmGALsqOn4m1PiWM3eoGiRMLFdE/4A+kej0Zrblycez2Unu
         WDgt5CbJcFJpTf2w8yEfEb3/TErDK+20A9Ypmk6EOVCJJ6g7AUVj46HhIm7jkPs/b9
         zuFXkzUW4+BhoG9jPpqX0KLO1yvyXDz42kHWgo5E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Jianxiong Gao <jxgao@google.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 5.10 15/29] swiotlb: factor out a nr_slots helper
Date:   Wed,  5 May 2021 14:05:18 +0200
Message-Id: <20210505112326.704407973@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210505112326.195493232@linuxfoundation.org>
References: <20210505112326.195493232@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jianxiong Gao <jxgao@google.com>

commit: c32a77fd18780a5192dfb6eec69f239faebf28fd

Factor out a helper to find the number of slots for a given size.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Jianxiong Gao <jxgao@google.com>
Tested-by: Jianxiong Gao <jxgao@google.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Jianxiong Gao <jxgao@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/dma/swiotlb.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -178,6 +178,11 @@ static inline unsigned long io_tlb_offse
 	return val & (IO_TLB_SEGSIZE - 1);
 }
 
+static inline unsigned long nr_slots(u64 val)
+{
+	return DIV_ROUND_UP(val, IO_TLB_SIZE);
+}
+
 /*
  * Early SWIOTLB allocation may be too early to allow an architecture to
  * perform the desired operations.  This function allows the architecture to
@@ -477,20 +482,20 @@ phys_addr_t swiotlb_tbl_map_single(struc
 
 	tbl_dma_addr &= mask;
 
-	offset_slots = ALIGN(tbl_dma_addr, IO_TLB_SIZE) >> IO_TLB_SHIFT;
+	offset_slots = nr_slots(tbl_dma_addr);
 
 	/*
 	 * Carefully handle integer overflow which can occur when mask == ~0UL.
 	 */
 	max_slots = mask + 1
-		    ? ALIGN(mask + 1, IO_TLB_SIZE) >> IO_TLB_SHIFT
+		    ? nr_slots(mask + 1)
 		    : 1UL << (BITS_PER_LONG - IO_TLB_SHIFT);
 
 	/*
 	 * For mappings greater than or equal to a page, we limit the stride
 	 * (and hence alignment) to a page size.
 	 */
-	nslots = ALIGN(alloc_size, IO_TLB_SIZE) >> IO_TLB_SHIFT;
+	nslots = nr_slots(alloc_size);
 	if (alloc_size >= PAGE_SIZE)
 		stride = (1 << (PAGE_SHIFT - IO_TLB_SHIFT));
 	else
@@ -586,7 +591,7 @@ void swiotlb_tbl_unmap_single(struct dev
 			      enum dma_data_direction dir, unsigned long attrs)
 {
 	unsigned long flags;
-	int i, count, nslots = ALIGN(alloc_size, IO_TLB_SIZE) >> IO_TLB_SHIFT;
+	int i, count, nslots = nr_slots(alloc_size);
 	int index = (tlb_addr - io_tlb_start) >> IO_TLB_SHIFT;
 	phys_addr_t orig_addr = io_tlb_orig_addr[index];
 


