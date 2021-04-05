Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 032053547FA
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 23:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241249AbhDEVDU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 17:03:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241227AbhDEVDN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Apr 2021 17:03:13 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CE45C061756
        for <stable@vger.kernel.org>; Mon,  5 Apr 2021 14:03:04 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id jp20so368177pjb.2
        for <stable@vger.kernel.org>; Mon, 05 Apr 2021 14:03:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=lvFPlljBb/WLm4WDC8t29VUZNx2UmX4AEMkM0T/oFwg=;
        b=u9Z4PAsHootLFVqdvJnzPekLU60WxhWrYmkkF9FnCZHi6VjxlP7aUiTTe4adGREi4a
         UJfr6ThwgOtnQCiReyZWtBB5Q7QdX/nZMXGDBQbE98ToK4lbtzb3rQjIKLTXiSB0TRYV
         Nc0DTAIP4UjdgrUYDmJITM0SFeQNNaEp83rlHBB2UA4gSR4DESFy2tf3UQHNbvhpEe/r
         ojfBqejBTyPlWFyqDP0QMgROqkqD+sTDDNdBP/mW5T+SULw8HmAtLmsK6RsegxUtylzm
         wO1v35kn1xAnkNI3wUjnq1FpsbmIp8TITrmlD81QsWd6pAemXgWZGkdKghh1dpzKBtG3
         4RDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=lvFPlljBb/WLm4WDC8t29VUZNx2UmX4AEMkM0T/oFwg=;
        b=GmJY0HlQuny29OOdLag/JEA3A8xAqc+kbzkzlmKrnpFi+ufaI8FcgMhYR96kjT9kxe
         /8yIx30x3W9fhxE1LEnTb+GgOIlLu21VYg10bYx98CBvYf9NF2dXpNgdJaUyXcPZXieC
         C0NBEj++rgfBTBL2o13BKT6+k/tR1xJ2ZAi6tbU/rOQEZAzX4RcnsX1IPm3BJcNQTO+P
         OFD/AeSidoCBPfSZIQSLPO0SnTN6DfYY+ggT2SS7jXpe5swUnVG19PngaWKz9P0Ufj4p
         m7awNKyhzu2zHO1rod3UHgAqsFEeBdOG0VSqIhmqek232WNpV/4Qj5oFcE1t8+zFCGjF
         yAgA==
X-Gm-Message-State: AOAM532dcELYpbKaYujAksEBVS+bWgu1n/iXD7WdPkPAaNzcwcESeNat
        0f5UfE9tIUOApzfvLCfC1gmyb1ivweeP3tOOJrU5yuUgRHENd7KmNJiq6nhfkYcNFwuEigwHxli
        WVwPUgrZ7E/mg/GCdBYZ4nUqkSfKW6CFYBIdkR4glbw5ztFTjs//qBKWnCAI=
X-Google-Smtp-Source: ABdhPJyJU2kvhPuczYO+cGyTpBAqQY7EkL+Rxf8TnXUYJaVerjN/w0mOgqRPk7I37XA6gmtJfbd1WckBIw==
X-Received: from jxgao-snp.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1373])
 (user=jxgao job=sendgmr) by 2002:a17:902:dc84:b029:e9:3601:607b with SMTP id
 n4-20020a170902dc84b02900e93601607bmr1616146pld.38.1617656583983; Mon, 05 Apr
 2021 14:03:03 -0700 (PDT)
Date:   Mon,  5 Apr 2021 21:02:26 +0000
In-Reply-To: <20210405210230.1707074-1-jxgao@google.com>
Message-Id: <20210405210230.1707074-5-jxgao@google.com>
Mime-Version: 1.0
References: <20210405210230.1707074-1-jxgao@google.com>
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH v5.10 4/8] swiotlb: clean up swiotlb_tbl_unmap_single
From:   Jianxiong Gao <jxgao@google.com>
To:     stable@vger.kernel.org
Cc:     Jianxiong Gao <jxgao@google.com>, Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

'commit ca10d0f8e530 ("swiotlb: clean up swiotlb_tbl_unmap_single")'

Remove a layer of pointless indentation, replace a hard to follow
ternary expression with a plain if/else.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jianxiong Gao <jxgao@google.com>
---
 kernel/dma/swiotlb.c | 42 +++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 1ba8e1095dfc..47d5dfeffd0a 100644
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

