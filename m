Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C9053547D0
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 22:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237205AbhDEUwH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 16:52:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237144AbhDEUwH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Apr 2021 16:52:07 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 038C7C061756
        for <stable@vger.kernel.org>; Mon,  5 Apr 2021 13:51:59 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id o1so9691333pgl.0
        for <stable@vger.kernel.org>; Mon, 05 Apr 2021 13:51:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=RGqcKbdPQxzBm5lgM+hyc0G6eeSvIiffmXl+rvemOPU=;
        b=BClaqHAfXcEj3CuT5fY8bzE8e04hJ7Vg8fQkd+h1rVwNx3NZsykj44BbtJxd+hWOMz
         ea59Use9Eb2c5KYrz8yyLD+5qnNsO/A0mRBoaskL33NOWjS7y4UHtmLbDKKdc3tYTJkT
         YqrZZ34mNFsMXjIHY91YxGTusWLLnLlJ2HeU5uppX6KRr7skbArD2nivI9ADSiFiD4MV
         UdWj0Ep9hbX1m/4//6Ze41Qj9wy7Y434hMHDrinq8QgbtFaKe/53X5ITBHl28P4FeLu4
         znUvsQDcno7uZv+SQ/YCumiApONqAKHjAs6OegpOh9MnRZoi4CvTuVvT0jXu8BIxMoxi
         UKXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=RGqcKbdPQxzBm5lgM+hyc0G6eeSvIiffmXl+rvemOPU=;
        b=fK3ezsrnKAiqBNTMg1H7dDU56jncsuReqg8tUhexX86+QuTGkLPkldFKRbAhugiXRB
         L9zy6gbt4ml1rV9x/pi+LiHVmn/ebaMfqccejCgqPPyr2MCI7Q6l9Z4Gg34dN+ovy1Ey
         k0ADV2x0OHYob+MCATPZbud41IL/o6+fQRCtwBHadiGaZwYNqMR68zHxX/yR8+VgJxPD
         2YYNLcZqG9b61aD3SBx2rOuSH2FfEN8QN5zrBWYNr5esxKvLa2gHvJGr5b8QBofPBOpq
         aYM2P/0zdbZlH+8vOzDRON2iUdZr+Id8kG0DE5Cos3PuPkLO0N3fxEjkNwpt0VbSDMA+
         xauA==
X-Gm-Message-State: AOAM533qokmklIT19sc9NmdLnbPuQPxW2PwXHWMP+HcWbfDw2bZgK2ym
        mAaTj8BqFF0nCbIrJJgGTYaFM2TTZ8Ev7tyDdGEIENKj5ltstRxrP97E1BL74HD5I2a4igyoFTp
        760KeSjUrYvpKF08Q5EYzgAdvF/XKX/VY4jAZPOveOrVbLyoatqZ5opEttGc=
X-Google-Smtp-Source: ABdhPJyqIjnYaHUHXh3r+FKZXISIFJSHm9eBdx5yqzvZF+YtFGU1mV2FcOQp0VL887GA1edtv2ZA0nQaCQ==
X-Received: from jxgao-snp.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1373])
 (user=jxgao job=sendgmr) by 2002:a17:902:8693:b029:e8:fdd4:361c with SMTP id
 g19-20020a1709028693b02900e8fdd4361cmr7760737plo.32.1617655918462; Mon, 05
 Apr 2021 13:51:58 -0700 (PDT)
Date:   Mon,  5 Apr 2021 20:51:05 +0000
In-Reply-To: <20210405205109.1700468-1-jxgao@google.com>
Message-Id: <20210405205109.1700468-5-jxgao@google.com>
Mime-Version: 1.0
References: <20210405205109.1700468-1-jxgao@google.com>
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH 5.4 4/8] swiotlb: clean up swiotlb_tbl_unmap_single
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
index 200afa87d135..5484469fa5f3 100644
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

