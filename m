Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACD1F3547CF
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 22:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232860AbhDEUwD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 16:52:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237144AbhDEUwD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Apr 2021 16:52:03 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BCDCC061756
        for <stable@vger.kernel.org>; Mon,  5 Apr 2021 13:51:56 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id p18so306390pjo.8
        for <stable@vger.kernel.org>; Mon, 05 Apr 2021 13:51:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=NzrUnXlBSCh0t2ah6YAXus3AucO/5PlMGcNxQfskBrY=;
        b=DYtS9aiJ4I2cMANxUgDM8FHun9M37KOpLqancPC7T70RMQQuLqcrEIb/itnOV7C067
         5GscDFc6yG+59NX9TD6n4IEn3VmFb71ebag/22DVZXO+BCKo1alslOLubwygIp984i5X
         LkQESpF5W2VHIoRO8T9TtP6D496jRMazf4obiJnT7SbLLBxdVMXHLduS3qmQ3ZgGNDKI
         N3+J9TWC7vd6OeRZQcS7JuR2l9x3gWzk0yTCuQeyweD3pYzrDKMhcxDehtBoS2bYKsVt
         wNR0Q8sYfC6fdhZbZNY0kt30UUg1SZbjVcyM0wgAvXnrUtgJ8IC+Ys0ordE29IOSprQJ
         k2xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=NzrUnXlBSCh0t2ah6YAXus3AucO/5PlMGcNxQfskBrY=;
        b=ZTPDMyQsmSzuSTNYyY0TGdZ6fYD2ztckZLUN2bDgxNtjh4mjvmYUbcovaPtnmXu2wm
         iYh0QJokV5bq1QejAvj6/cdXy6sXAYhTYBAd9kIrCWHaiFeKfQl2b2EjqdbnT5zkZUFM
         S3/25k9uXRzigi/+bP6BWIMkSr5nY6pJ1xydVqbLzd9d6v5TNCvJhiBC+USv85hr1InU
         PN9TySb+3hXiXnliJrvocUHmvPD73932BWQwuE4XWvLgZX7jNFB7rP8A7270+w/DVh6z
         krtM1tTlBCoVii8AIJOJaWBHlzxjSyGbdSs8HzKIH3f7p5B1PtYEgjXebLQBrlfzRumz
         IY8w==
X-Gm-Message-State: AOAM5322k7HCITU6H6Hdcu3b6m6Dko5Kaa6OIOHKyiRxCoBxM/2ScjIj
        UitjvCaNZa7ZFqWVFLz23CSTRHt2Jy6IV+3MkKGiKQc0vxvIofLZXD61Jm27GfdPbuyKOHRfvti
        jzsdNnsSfyrRSsyswxlajAuQtgYGwdqEFdJSTDTeaLO+0NjFe2rd0/STDFsM=
X-Google-Smtp-Source: ABdhPJzI98YvplNFte4beAgpzIloMvuna/s1jg7mTh6KcjyCMausSi3ObTcpeFcasuCuwn0NL+RQNtKuyQ==
X-Received: from jxgao-snp.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1373])
 (user=jxgao job=sendgmr) by 2002:a62:7815:0:b029:22d:f8dd:7701 with SMTP id
 t21-20020a6278150000b029022df8dd7701mr24460628pfc.53.1617655916015; Mon, 05
 Apr 2021 13:51:56 -0700 (PDT)
Date:   Mon,  5 Apr 2021 20:51:04 +0000
In-Reply-To: <20210405205109.1700468-1-jxgao@google.com>
Message-Id: <20210405205109.1700468-4-jxgao@google.com>
Mime-Version: 1.0
References: <20210405205109.1700468-1-jxgao@google.com>
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH 5.4 3/8] swiotlb: factor out a nr_slots helper
From:   Jianxiong Gao <jxgao@google.com>
To:     stable@vger.kernel.org
Cc:     Jianxiong Gao <jxgao@google.com>, Christoph Hellwig <hch@lst.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

'commit c32a77fd1878 ("swiotlb: factor out a nr_slots helper")'

Factor out a helper to find the number of slots for a given size.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Jianxiong Gao <jxgao@google.com>
Tested-by: Jianxiong Gao <jxgao@google.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Jianxiong Gao <jxgao@google.com>
---
 include/linux/swiotlb.h |  1 +
 kernel/dma/swiotlb.c    | 13 +++++++++----
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index cde3dc18e21a..ea8e2e28459d 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -28,6 +28,7 @@ enum swiotlb_force {
  * controllable.
  */
 #define IO_TLB_SHIFT 11
+#define IO_TLB_SIZE (1 << IO_TLB_SHIFT)
 
 extern void swiotlb_init(int verbose);
 int swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int verbose);
diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 9fa71a91c235..200afa87d135 100644
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
@@ -477,20 +482,20 @@ phys_addr_t swiotlb_tbl_map_single(struct device *hwdev,
 
 	tbl_dma_addr &= mask;
 
-	offset_slots = ALIGN(tbl_dma_addr, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT;
+	offset_slots = nr_slots(tbl_dma_addr);

 	/*
 	 * Carefully handle integer overflow which can occur when mask == ~0UL.
 	 */
 	max_slots = mask + 1
-		    ? ALIGN(mask + 1, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT
+		    ? nr_slots(mask + 1)
 		    : 1UL << (BITS_PER_LONG - IO_TLB_SHIFT);
 
 	/*
 	 * For mappings greater than or equal to a page, we limit the stride
 	 * (and hence alignment) to a page size.
 	 */
-	nslots = ALIGN(alloc_size, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT;
+	nslots = nr_slots(alloc_size);
 	if (alloc_size >= PAGE_SIZE)
 		stride = (1 << (PAGE_SHIFT - IO_TLB_SHIFT));
 	else
@@ -586,7 +591,7 @@ void swiotlb_tbl_unmap_single(struct device *hwdev, phys_addr_t tlb_addr,
 			      enum dma_data_direction dir, unsigned long attrs)
 {
 	unsigned long flags;
-	int i, count, nslots = ALIGN(alloc_size, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT;
+	int i, count, nslots = nr_slots(alloc_size);
 	int index = (tlb_addr - io_tlb_start) >> IO_TLB_SHIFT;
 	phys_addr_t orig_addr = io_tlb_orig_addr[index];
 
-- 
2.27.0

