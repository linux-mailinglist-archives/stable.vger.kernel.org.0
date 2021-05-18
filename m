Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE70A3882AA
	for <lists+stable@lfdr.de>; Wed, 19 May 2021 00:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352716AbhERWUz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 May 2021 18:20:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352714AbhERWUz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 May 2021 18:20:55 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BACFBC061573
        for <stable@vger.kernel.org>; Tue, 18 May 2021 15:19:35 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id w3-20020a170902d103b02900f057b7e766so4560424plw.13
        for <stable@vger.kernel.org>; Tue, 18 May 2021 15:19:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=c2Ze3UcqldjUtVJBEeD6v68APB1JJNQvO75YMMSv/V4=;
        b=XIBBFtJCCmZPummNYWTQAUlZnCSavmhdNsbYRFVE2iN9G0RftCxVwQzNVkr/3NvK3s
         8oSSNLWXBiCtG/Usiw2mxCOYPe4FCPMyRVJUTf63D3reYGi1obSxr5KBPTXLx/Lmmokn
         O2yJ95zg/bbrmsWSRSjVjAIr1Ivd6UtQ9RPNiFT+oe5/pODh6b3a5jgvN+jvy8tKAeS6
         R/mRKwAziGkrSRmDsNQjrTHz2gm+qRsy43Yv8GEnhu2fCl9xIuRja79E/838979yrvlt
         f3u1Cy/ypYYq44tx1zsS1/IRSGbNkH+v9ythHZJdYSuWR9K68JMNqHQbMwQapWm2tH/u
         o4pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=c2Ze3UcqldjUtVJBEeD6v68APB1JJNQvO75YMMSv/V4=;
        b=tDz00Ra80ocUcnCj6ZjZInorMWqONC54FmedO8SCG7tlexWd37bl46N/SSOP5ZNBJ8
         GuGMmugBqBsKQ9fKaUi9AIfcLDn4L1gQ4FQuU++c+caBuxwtTKLUqVsFMIleLr/vMn/Z
         yUxzqKlK6IlomLEMR6BU0zJHn9kOzZkmQvxc5ZHex84SKfXFe3FT5hBflK16Nrbk6jSR
         Kj3ud3Yf92NXZ/eoYItNYrXRfEBVfcDpvQ1RgD8vKKfE4SjSBznaCES9oR4VO8eG+kHf
         gChnPIsoAwJaSXOfXZcp/HnWaBGbLG2AOHltWT9KONnja/TC1V34FmKPAWQQ1wV71DRo
         7VLw==
X-Gm-Message-State: AOAM533ria8CJhj69xwBnbkDwZXR1CzslZR/jS94+oqZM2OsAD8emjbu
        c8e7j9jAoD/Ae1sfUhXaaVqsXsCsn7saq+pf+r3VNgJzf/TvcPy9z28I2ufdnyiHkT/v1B9QYvo
        S+qnWJqSOzUap6o254ssnNVlX243xWu1CuguSYMzKAUNJ4R+LMLo9Hvr9Rjw=
X-Google-Smtp-Source: ABdhPJz88PVHAUyGJX1tr8TShCGXuUOfrqgN5OOdPJCYzheHIgMpE3CevLXbnW3kWmTzBFVzLm/TCFdZMQ==
X-Received: from jxgao-snp.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1373])
 (user=jxgao job=sendgmr) by 2002:a17:903:3046:b029:ee:f24a:7517 with SMTP id
 u6-20020a1709033046b02900eef24a7517mr7053164pla.17.1621376375169; Tue, 18 May
 2021 15:19:35 -0700 (PDT)
Date:   Tue, 18 May 2021 22:18:14 +0000
In-Reply-To: <20210518221818.2963918-1-jxgao@google.com>
Message-Id: <20210518221818.2963918-5-jxgao@google.com>
Mime-Version: 1.0
References: <20210518221818.2963918-1-jxgao@google.com>
X-Mailer: git-send-email 2.31.1.751.gd2f1c929bd-goog
Subject: [PATCH 5.4 v2 4/9] swiotlb: factor out a nr_slots helper
From:   Jianxiong Gao <jxgao@google.com>
To:     stable@vger.kernel.org, hch@lst.de, marcorr@google.com,
        sashal@kernel.org
Cc:     Jianxiong Gao <jxgao@google.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Factor out a helper to find the number of slots for a given size.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Jianxiong Gao <jxgao@google.com>
Tested-by: Jianxiong Gao <jxgao@google.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Upstream: c32a77fd18780a5192dfb6eec69f239faebf28fd
Signed-off-by: Jianxiong Gao <jxgao@google.com>
---
 kernel/dma/swiotlb.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index db265dc324b9..b57e0741ce2f 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -179,6 +179,11 @@ static inline unsigned long io_tlb_offset(unsigned long val)
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
@@ -481,20 +486,20 @@ phys_addr_t swiotlb_tbl_map_single(struct device *hwdev,
 
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
@@ -590,7 +595,7 @@ void swiotlb_tbl_unmap_single(struct device *hwdev, phys_addr_t tlb_addr,
 			      enum dma_data_direction dir, unsigned long attrs)
 {
 	unsigned long flags;
-	int i, count, nslots = ALIGN(alloc_size, IO_TLB_SIZE) >> IO_TLB_SHIFT;
+	int i, count, nslots = nr_slots(alloc_size);
 	int index = (tlb_addr - io_tlb_start) >> IO_TLB_SHIFT;
 	phys_addr_t orig_addr = io_tlb_orig_addr[index];
 
-- 
2.31.1.751.gd2f1c929bd-goog

