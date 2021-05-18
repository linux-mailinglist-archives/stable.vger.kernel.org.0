Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C511C3882A8
	for <lists+stable@lfdr.de>; Wed, 19 May 2021 00:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236372AbhERWUm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 May 2021 18:20:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352714AbhERWUl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 May 2021 18:20:41 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B357C06175F
        for <stable@vger.kernel.org>; Tue, 18 May 2021 15:19:22 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id w195-20020a627bcc0000b029028e75db9c52so6861966pfc.5
        for <stable@vger.kernel.org>; Tue, 18 May 2021 15:19:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=bTwwGzfhYSt6vGcicTKXE7GYTCRotYqWPmLal+6u/a0=;
        b=eI6+EidL1fJmTlLNc/MjCFr6dRMVC4xvviX1cWYgOkHc4oCihJ9ZNhKiYnsIgsHhMu
         ya4cY9zd5XRnSSKUqqDEPnXe6sGauecK92jcsPfGxi+CntnbPEFZorFqcoHi3nvWxD41
         sThVk2Q7w/btms2HYm01FnczWQky/xBILHwxrkRiVkqI2dFLIlkMa7MbLNC5G1NtzsoP
         Qn6dA/ca9IOW+Hd2fRbZfy5PgE2ZNBhvcUaUK93aNRheq/uVo/QWkeutdB0Nae4DbDvR
         mSKp4geVWQYGRAw/KyNPJ1+RcLm9V9AnmQBSUPC1fQS9oM9QRqx/38cJbqzRepGST/Rb
         IySw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=bTwwGzfhYSt6vGcicTKXE7GYTCRotYqWPmLal+6u/a0=;
        b=J97WkmtzSFWCyjL/Ap85bZIZ7oN8DRdTg1mRhcVCX7obpGkBj/nXHr6D7g99ONjv9R
         cZqphmQvgVzQp1HjnAba3B9ymXrct5kCoYG9Cc9Zj2u1ZV7NMzolmkTnM1uoDEDzfpR5
         FJXiXaqE6Jvp4ZKWrrNUkomiJVgsZkkIiE7HN1n8s2Mb5e1kzQ0yrFwkHFu9PTwTuREp
         FZtGUmblSTGYxz9uFD4/lMJEKyNMMCj3gQki3Dg0OsQlaZz/ZyzBV5ZQycyZmOfKZ/fY
         t+eGjqrRlY1p2m2pytyraR6tTr8qMyKD9JbUETlstFXa/SP6AkfqhNKvZCsiX3Vh8qx0
         rxHw==
X-Gm-Message-State: AOAM531/Bvt6/nBBy1klIBnFQAG39j47oTwKsz4zyCaUvAG+tDcDv7aJ
        SqpfgorA4b7MvVpqfb+80CbhZUo7yY43xbstcImKOmq5udhCcx0ESDZeU9GldQn+NBSikEfolqt
        emXHZ0kW149OyXbnxI7mfaBKwxQsYcVP87TKC0W7wG/YiU0HmJJ2UFYiuDS8=
X-Google-Smtp-Source: ABdhPJyjZmmey4d69gx+QsK1VGUoY8xPY88JbbU2CXNK7ruEQwznDCrvxVxruMhS57++PNK/YYKJdRu0NQ==
X-Received: from jxgao-snp.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1373])
 (user=jxgao job=sendgmr) by 2002:a17:902:9001:b029:ee:f24a:7e7d with SMTP id
 a1-20020a1709029001b02900eef24a7e7dmr7018452plp.42.1621376361477; Tue, 18 May
 2021 15:19:21 -0700 (PDT)
Date:   Tue, 18 May 2021 22:18:12 +0000
In-Reply-To: <20210518221818.2963918-1-jxgao@google.com>
Message-Id: <20210518221818.2963918-3-jxgao@google.com>
Mime-Version: 1.0
References: <20210518221818.2963918-1-jxgao@google.com>
X-Mailer: git-send-email 2.31.1.751.gd2f1c929bd-goog
Subject: [PATCH 5.4 v2 2/9] swiotlb: add a IO_TLB_SIZE define
From:   Jianxiong Gao <jxgao@google.com>
To:     stable@vger.kernel.org, hch@lst.de, marcorr@google.com,
        sashal@kernel.org
Cc:     Jianxiong Gao <jxgao@google.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Add a new IO_TLB_SIZE define instead open coding it using
IO_TLB_SHIFT all over.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Jianxiong Gao <jxgao@google.com>
Tested-by: Jianxiong Gao <jxgao@google.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Upstream: b5d7ccb7aac3895c2138fe0980a109116ce15eff
Signed-off-by: Jianxiong Gao <jxgao@google.com>
---
 include/linux/swiotlb.h |  1 +
 kernel/dma/swiotlb.c    | 12 ++++++------
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index 0a8fced6aaec..f7aadd297aa9 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -29,6 +29,7 @@ enum swiotlb_force {
  * controllable.
  */
 #define IO_TLB_SHIFT 11
+#define IO_TLB_SIZE (1 << IO_TLB_SHIFT)
 
 extern void swiotlb_init(int verbose);
 int swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int verbose);
diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index f99b79d7e123..af4130059202 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -479,20 +479,20 @@ phys_addr_t swiotlb_tbl_map_single(struct device *hwdev,
 
 	tbl_dma_addr &= mask;
 
-	offset_slots = ALIGN(tbl_dma_addr, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT;
+	offset_slots = ALIGN(tbl_dma_addr, IO_TLB_SIZE) >> IO_TLB_SHIFT;
 
 	/*
 	 * Carefully handle integer overflow which can occur when mask == ~0UL.
 	 */
 	max_slots = mask + 1
-		    ? ALIGN(mask + 1, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT
+		    ? ALIGN(mask + 1, IO_TLB_SIZE) >> IO_TLB_SHIFT
 		    : 1UL << (BITS_PER_LONG - IO_TLB_SHIFT);
 
 	/*
 	 * For mappings greater than or equal to a page, we limit the stride
 	 * (and hence alignment) to a page size.
 	 */
-	nslots = ALIGN(alloc_size, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT;
+	nslots = ALIGN(alloc_size, IO_TLB_SIZE) >> IO_TLB_SHIFT;
 	if (alloc_size >= PAGE_SIZE)
 		stride = (1 << (PAGE_SHIFT - IO_TLB_SHIFT));
 	else
@@ -586,7 +586,7 @@ void swiotlb_tbl_unmap_single(struct device *hwdev, phys_addr_t tlb_addr,
 			      enum dma_data_direction dir, unsigned long attrs)
 {
 	unsigned long flags;
-	int i, count, nslots = ALIGN(alloc_size, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT;
+	int i, count, nslots = ALIGN(alloc_size, IO_TLB_SIZE) >> IO_TLB_SHIFT;
 	int index = (tlb_addr - io_tlb_start) >> IO_TLB_SHIFT;
 	phys_addr_t orig_addr = io_tlb_orig_addr[index];
 
@@ -637,7 +637,7 @@ void swiotlb_tbl_sync_single(struct device *hwdev, phys_addr_t tlb_addr,
 
 	if (orig_addr == INVALID_PHYS_ADDR)
 		return;
-	orig_addr += (unsigned long)tlb_addr & ((1 << IO_TLB_SHIFT) - 1);
+	orig_addr += (unsigned long)tlb_addr & (IO_TLB_SIZE - 1);
 
 	switch (target) {
 	case SYNC_FOR_CPU:
@@ -693,7 +693,7 @@ bool swiotlb_map(struct device *dev, phys_addr_t *phys, dma_addr_t *dma_addr,
 
 size_t swiotlb_max_mapping_size(struct device *dev)
 {
-	return ((size_t)1 << IO_TLB_SHIFT) * IO_TLB_SEGSIZE;
+	return ((size_t)IO_TLB_SIZE) * IO_TLB_SEGSIZE;
 }
 
 bool is_swiotlb_active(void)
-- 
2.31.1.751.gd2f1c929bd-goog

