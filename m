Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4AD355D15
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 22:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245610AbhDFUoa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 16:44:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232859AbhDFUoa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Apr 2021 16:44:30 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85AE5C06174A
        for <stable@vger.kernel.org>; Tue,  6 Apr 2021 13:44:20 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id 7so11413160pfn.4
        for <stable@vger.kernel.org>; Tue, 06 Apr 2021 13:44:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=IyEiC9I8hW/pLSP82lpiKKcDMjbhuVg6sO7+Ng3Y1aE=;
        b=NWvRru4nk/sntVa/PCd2Lb2oET58YbtWDqO2F2iJ+RXfcQ6k+X+aT0FZbJW6kHT10E
         tq5cWtmJ6Nu64EMvZA/dQ/7xwUSyQvT3tBQoYjMoXXRKuQGXTQr9i09RKcxLbIz6iLg3
         UvUrt/uCvgnYfB+4W8PxvIiJXeDnHajzfvqaTuxEIWadhw39rFyf3Zy3k+F7Ncii4wnF
         TklorHXKNa9mtgAOFmRbZBVkz7lA06nE+G7yXVwg8vE9VCwBDymNpo7QoiKmqEa0K5HE
         +XnurYCDnC3xPFXLUZ+kE9wbdibDGPTSxH4U5Qgcw1ZB3KWdqWA/wQ0UTCMe6Mq+qJAM
         KW3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=IyEiC9I8hW/pLSP82lpiKKcDMjbhuVg6sO7+Ng3Y1aE=;
        b=OCgtzj8A2TFwDCAyFY4ZMfmAU69mAyU76uUcO0T2PFfoSwJ5yQMJkDB3b1LBOwnkxG
         E53gwytUz6+jGpjo3vyetboQqL6GLeCNwipCi/66OvsIijzST5QbOV/7kwWMgM/4sd84
         pSzH5GYlzx0AqYIJHhn3ncaW021bRYLNIUN1V9H9UYCpcP9lljLKLwpHZkwzmSMdicZS
         m/p5iJ17tyIzlHk+I06afqOPHoPcsZ/v60e8pQn/xACWqAqTAubc8Sp5jtJaeVKoQsSs
         vj44fiXFaObajG0gE4CNZw2DUyoIFLUSTtYWqGZUbmfQQtpNodsQKEICfAWDr9XumGQF
         56pw==
X-Gm-Message-State: AOAM530yx4ibNH7Su+5aC1Z2AlxvI1SsVioSQcU2UrRD9MYGaNkugBge
        3ELhFccNPgOX2kteBpc4uDNAyN87jnUYh5Z58r+FV8VUIAQDZtT+J49okfK83r70tE+Y2sss1FL
        UI9Ks9wnyyepGanqV35QBk/CZZB9pw7ls4Tc+/yIKnuZg6icoQdd4JWnI7fs=
X-Google-Smtp-Source: ABdhPJzMq7gw8BMukWehMEOeY9/VWahs2D9rd+klH+B0SsTSCedaTbkpp9v35JSGmT6x92MHFqcdzG432w==
X-Received: from jxgao-snp.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1373])
 (user=jxgao job=sendgmr) by 2002:a62:5ac4:0:b029:22e:e8de:eaba with SMTP id
 o187-20020a625ac40000b029022ee8deeabamr29498639pfb.4.1617741859901; Tue, 06
 Apr 2021 13:44:19 -0700 (PDT)
Date:   Tue,  6 Apr 2021 20:43:23 +0000
In-Reply-To: <20210406204326.1932888-1-jxgao@google.com>
Message-Id: <20210406204326.1932888-5-jxgao@google.com>
Mime-Version: 1.0
References: <20210406204326.1932888-1-jxgao@google.com>
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH V2 v5.4 4/8] swiotlb: clean up swiotlb_tbl_unmap_single
From:   Jianxiong Gao <jxgao@google.com>
To:     stable@vger.kernel.org
Cc:     Jianxiong Gao <jxgao@google.com>, Christoph Hellwig <hch@lst.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

'commit ca10d0f8e530 ("swiotlb: clean up swiotlb_tbl_unmap_single")'

Remove a layer of pointless indentation, replace a hard to follow
ternary expression with a plain if/else.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Jianxiong Gao <jxgao@google.com>
Tested-by: Jianxiong Gao <jxgao@google.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Jianxiong Gao <jxgao@google.com>
---
 kernel/dma/swiotlb.c | 42 +++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 70023393dd6b..10c20010710c 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -610,28 +610,28 @@ void swiotlb_tbl_unmap_single(struct device *hwdev, phys_addr_t tlb_addr,
 	 * with slots below and above the pool being returned.
 	 */
 	spin_lock_irqsave(&io_tlb_lock, flags);
-	{
-		count = ((index + nslots) < ALIGN(index + 1, IO_TLB_SEGSIZE) ?
-			 io_tlb_list[index + nslots] : 0);
-		/*
-		 * Step 1: return the slots to the free list, merging the
-		 * slots with superceeding slots
-		 */
-		for (i = index + nslots - 1; i >= index; i--) {
-			io_tlb_list[i] = ++count;
-			io_tlb_orig_addr[i] = INVALID_PHYS_ADDR;
-		}
-		/*
-		 * Step 2: merge the returned slots with the preceding slots,
-		 * if available (non zero)
-		 */
-		for (i = index - 1;
-		     io_tlb_offset(i) != IO_TLB_SEGSIZE - 1 &&
-		     io_tlb_list[i]; i--)
-			io_tlb_list[i] = ++count;
-
-		io_tlb_used -= nslots;
+	if (index + nslots < ALIGN(index + 1, IO_TLB_SEGSIZE))
+		count = io_tlb_list[index + nslots];
+	else
+		count = 0;
+	/*
+	 * Step 1: return the slots to the free list, merging the slots with
+	 * superceeding slots
+	 */
+	for (i = index + nslots - 1; i >= index; i--) {
+		io_tlb_list[i] = ++count;
+		io_tlb_orig_addr[i] = INVALID_PHYS_ADDR;
 	}
+
+	/*
+	 * Step 2: merge the returned slots with the preceding slots, if
+	 * available (non zero)
+	 */
+	for (i = index - 1;
+	     io_tlb_offset(i) != IO_TLB_SEGSIZE - 1 && io_tlb_list[i];
+	     i--)
+		io_tlb_list[i] = ++count;
+	io_tlb_used -= nslots;
 	spin_unlock_irqrestore(&io_tlb_lock, flags);
 }
 
-- 
2.27.0

