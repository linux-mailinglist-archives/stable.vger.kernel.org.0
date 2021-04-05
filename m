Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF76C3547CE
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 22:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235873AbhDEUwB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 16:52:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232860AbhDEUwB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Apr 2021 16:52:01 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6391EC061756
        for <stable@vger.kernel.org>; Mon,  5 Apr 2021 13:51:52 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id n23so3619713pgl.2
        for <stable@vger.kernel.org>; Mon, 05 Apr 2021 13:51:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=kXSoBS4HEON9UnWAMRtgPLba1XO2mEENMySZevqoKOw=;
        b=n0VBDfxrbbeF62K0CXNvQt26TveE0LJlKyGqHLyzi0uuvEGOCLQ9S77lGgs56j/0YX
         fDbfWRCV1UZtkmb/R4iDP3wCKh78Q2nXLcySHsZKvTC8gGYTio3ltqpuxDn1rbPSUWaQ
         CfDQtqxkPErHrr4WLaBBH5lyOE6bed94j5CVch56IGI8jov2Xn3Jm5s24wmxSKJdDwso
         fkleHfwDqv+dzut9SyV8+oSZxJhRakUEMfMbhMw2g5wNTg5B1vD4TBZyrTAF1bzYoiOd
         Dnby29pxCOGEl1v/7R7MJkvcaAcj9HFFF7DRi4NesrveElBEm953qq3riGaRVl7FWEnU
         gnYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=kXSoBS4HEON9UnWAMRtgPLba1XO2mEENMySZevqoKOw=;
        b=ehZ6hJFm6d6xGNluoqgywm3ZjJv6nE0nI5uDSv2lI6FaGCeK737HqChOx/BmEkYHRz
         w+rOzoxFf7i6u5C8sX2CQaDl9QJK0Ya/ivJRmBGWUqJ3krQ/kBf1bGWrSVSWcIq3tBRU
         nsFSh9xcTMpLbA147tbm044v4mHXoxPV6cOKdsRSw+BCcb7L2899HcrXHcbdCpiyNeZz
         jGjlaBTELBodqoUpC7FquTdpkbrs0NzDGqfh2YSXbIMOH4Bh5T7G+dztC6Ma0hZIJmSe
         xs4yP4a16dG79TI349duM0zOLBWf7OveW/2gcLYiZz3hLQPj7Z93dswBwQB1RrhyPFuT
         vYmA==
X-Gm-Message-State: AOAM5304jVlOMEfemhjyAwMgwXq18IkzxKpmuJK6WPFI2FU0ePzLs/r3
        b80iH0F6N8OkOZZZMU1UegzHsSRohGEQZ1LbBSdf4KWuZqQA9jIV/yQg4AdjkcbkcS4Irjfi5vB
        1+xT75rrn6IuIP9rQFAZNsr11OxIyC2+gTjDSkaCnu0J4WUrvs2yQymfhIqg=
X-Google-Smtp-Source: ABdhPJxkUH3RPiVJkT2Lhh2gz5QKJC8MLeeHhofmZ+rGEv6AAcnZXJoABV/49SSf7DhwFh/9bW3VW25XqQ==
X-Received: from jxgao-snp.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1373])
 (user=jxgao job=sendgmr) by 2002:a17:902:b68c:b029:e6:bb9f:7577 with SMTP id
 c12-20020a170902b68cb02900e6bb9f7577mr25301466pls.0.1617655911787; Mon, 05
 Apr 2021 13:51:51 -0700 (PDT)
Date:   Mon,  5 Apr 2021 20:51:03 +0000
In-Reply-To: <20210405205109.1700468-1-jxgao@google.com>
Message-Id: <20210405205109.1700468-3-jxgao@google.com>
Mime-Version: 1.0
References: <20210405205109.1700468-1-jxgao@google.com>
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH 5.4 2/8] swiotlb: factor out an io_tlb_offset helper
From:   Jianxiong Gao <jxgao@google.com>
To:     stable@vger.kernel.org
Cc:     Jianxiong Gao <jxgao@google.com>, Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
'commit c7fbeca757fe ("swiotlb: factor out an io_tlb_offset helper")'

Replace the very genericly named OFFSET macro with a little inline
helper that hardcodes the alignment to the only value ever passed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jianxiong Gao <jxgao@google.com>
---
 kernel/dma/swiotlb.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 673a2cdb2656..9fa71a91c235 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -49,9 +49,6 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/swiotlb.h>
 
-#define OFFSET(val,align) ((unsigned long)	\
-	                   ( (val) & ( (align) - 1)))
-
 #define SLABS_PER_PAGE (1 << (PAGE_SHIFT - IO_TLB_SHIFT))
 
 /*
@@ -177,6 +174,11 @@ void swiotlb_print_info(void)
 	       bytes >> 20);
 }
 
+static inline unsigned long io_tlb_offset(unsigned long val)
+{
+	return val & (IO_TLB_SEGSIZE - 1);
+}
+
 /*
  * Early SWIOTLB allocation may be too early to allow an architecture to
  * perform the desired operations.  This function allows the architecture to
@@ -226,7 +228,7 @@ int __init swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int verbose)
 		      __func__, alloc_size, PAGE_SIZE);
 
 	for (i = 0; i < io_tlb_nslabs; i++) {
-		io_tlb_list[i] = IO_TLB_SEGSIZE - OFFSET(i, IO_TLB_SEGSIZE);
+		io_tlb_list[i] = IO_TLB_SEGSIZE - io_tlb_offset(i);
 		io_tlb_orig_addr[i] = INVALID_PHYS_ADDR;
 	}
 	io_tlb_index = 0;
@@ -357,7 +359,7 @@ swiotlb_late_init_with_tbl(char *tlb, unsigned long nslabs)
 		goto cleanup4;
 
 	for (i = 0; i < io_tlb_nslabs; i++) {
-		io_tlb_list[i] = IO_TLB_SEGSIZE - OFFSET(i, IO_TLB_SEGSIZE);
+		io_tlb_list[i] = IO_TLB_SEGSIZE - io_tlb_offset(i);
 		io_tlb_orig_addr[i] = INVALID_PHYS_ADDR;
 	}
 	io_tlb_index = 0;
@@ -530,7 +532,9 @@ phys_addr_t swiotlb_tbl_map_single(struct device *hwdev,
 
 			for (i = index; i < (int) (index + nslots); i++)
 				io_tlb_list[i] = 0;
-			for (i = index - 1; (OFFSET(i, IO_TLB_SEGSIZE) != IO_TLB_SEGSIZE - 1) && io_tlb_list[i]; i--)
+			for (i = index - 1;
+			     io_tlb_offset(i) != IO_TLB_SEGSIZE - 1 &&
+			     io_tlb_list[i]; i--)
 				io_tlb_list[i] = ++count;
 			tlb_addr = io_tlb_start + (index << IO_TLB_SHIFT);
 
@@ -616,7 +620,9 @@ void swiotlb_tbl_unmap_single(struct device *hwdev, phys_addr_t tlb_addr,
 		 * Step 2: merge the returned slots with the preceding slots,
 		 * if available (non zero)
 		 */
-		for (i = index - 1; (OFFSET(i, IO_TLB_SEGSIZE) != IO_TLB_SEGSIZE -1) && io_tlb_list[i]; i--)
+		for (i = index - 1;
+		     io_tlb_offset(i) != IO_TLB_SEGSIZE - 1 &&
+		     io_tlb_list[i]; i--)
 			io_tlb_list[i] = ++count;
 
 		io_tlb_used -= nslots;
-- 
2.27.0

