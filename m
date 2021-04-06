Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4C77355D14
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 22:44:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245597AbhDFUo1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 16:44:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245587AbhDFUo0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Apr 2021 16:44:26 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3538C061756
        for <stable@vger.kernel.org>; Tue,  6 Apr 2021 13:44:18 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id k9so8283233pls.13
        for <stable@vger.kernel.org>; Tue, 06 Apr 2021 13:44:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ph8QNVbJQpFHoFHcw/UjJ2x7qwIiEdCHHUYp/82KbYo=;
        b=Qq1M2ouVCDNR0r1/1tbZIrUOimL/Mp5BppXybNmXHhUWtbrIXo4DFa6qrhpVw6keuS
         tt8b4vTLglmih0vMPwQF66NkBiRGg+3Xv6w04P25eVcOzfqwnFLGjp9W0kCJGjdHNi8X
         2nTGHJWQbjiQsv46b0ab0Y1MQXi4KLFM8RZSBAhoiWpV+x6/0kyilSdzvLHnNLawuKkM
         WXMmiZfbObbNPetgudaj5x/ori2ohfIN0dr/2an8x1PdoJWkORkGNuhIN/VyB806xCoz
         ZZweOpHYMsqubZTTfYQUq1sFvSmxEECaLSaavoJzkY+OzD4vOI/Yv1t3vd52xW0CPlW+
         z5pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ph8QNVbJQpFHoFHcw/UjJ2x7qwIiEdCHHUYp/82KbYo=;
        b=rllyrq660iBP/evy7tidIL0RHsC04YMFfXykuotr3kfGknSAngfWeXKx6VMdYPkIHG
         E22eW85wP//Hr3e+wiGRaas0FJyIfqohVlgjhcJyZqrI6iUZ4vHgCRhovVPhyu/eI36A
         5U/9NkQC1PUXwTzrBUQAeDBAMlypPJpsL5FUzDMIbLl3iycXroKjsaIfDt85gNGDCBw8
         ioGASGgxBcl7QvI0YSqsLP2CiM6W/iKG8K90+8aSorZgptLGFggKBTfYqi7ImqIFB1BZ
         rEG7c6ZkY5kf27wKeE7O2A//asW1jt8wfOQ9h7ciny/VTfx570RYwOsLGQ6SCOGLMF31
         GfDQ==
X-Gm-Message-State: AOAM531oH2QrOWAQVLqj2aomatoqo2l3zjzYa5dUDHG4C/eC3S+MT//P
        m/n3OvzdtCYmYj/De53S5yFhs1UQ0gsoHj7rgwlJMVBRMGMxsRusRqVgkPJYskZOzfYWiijstuf
        t8zpeqQ67ePVra3ZmIyv5i7rT9PE0lFGIX+nKb7dFdWAX8+JLUeaOtviHCmg=
X-Google-Smtp-Source: ABdhPJzssHx9HQQZPRTDIRWWFq0TEzstH0V23AFCgVqOkTrlvlXWvRJOH69gfysAwLc3tsWbcXxITwT10g==
X-Received: from jxgao-snp.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1373])
 (user=jxgao job=sendgmr) by 2002:a17:902:f687:b029:e8:da63:6195 with SMTP id
 l7-20020a170902f687b02900e8da636195mr62732plg.75.1617741858271; Tue, 06 Apr
 2021 13:44:18 -0700 (PDT)
Date:   Tue,  6 Apr 2021 20:43:22 +0000
In-Reply-To: <20210406204326.1932888-1-jxgao@google.com>
Message-Id: <20210406204326.1932888-4-jxgao@google.com>
Mime-Version: 1.0
References: <20210406204326.1932888-1-jxgao@google.com>
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH V2 v5.4 3/8] swiotlb: factor out a nr_slots helper
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
index 9fa71a91c235..70023393dd6b 100644
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

