Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 848A2278E43
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 18:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729596AbgIYQUd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 12:20:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728654AbgIYQUd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Sep 2020 12:20:33 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DB10C0613CE
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 09:20:33 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id a7so3073917ybq.22
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 09:20:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=E6og4z6nje4AEDDQkIz9MaQsLLZ5DTy6MWJlEHz1OY0=;
        b=ZmzdLm9BCv+rk6VhrYFFUMs+BZPFOuayMdqW+CvKxM1AgKXRIIpt4IYIUDI7wQU0Q7
         RcTHUB1im9x2OWJKP8FtwgsZNNBQDImbE7TxTjc9t/eai/j1MwLg5AxLuzDSwQ+97GHZ
         SXWJCivGypkpkrEMTB9l+cF/N6+0+06H/38se23P8d3FpswGjcYrH/YcmEjP53ne/YiL
         Rt+IoIu66wK9TA96D2O1W1/U+/Ff16qXig6L04gAMIbSqJO61YBgCWzb8W+pPQMICLB3
         YqlQJkLrL8ObE0YL/8ctW/o+42zlbxC863yF/5vE7umiAn342KOq1ihopmW1R4bYgfRp
         ukyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=E6og4z6nje4AEDDQkIz9MaQsLLZ5DTy6MWJlEHz1OY0=;
        b=ZNJcjy4BrkCPP25zkm4zza+0QeQl0+4DSYvvI37UVpeL/KZNK7W1TVRf+JGIgVXH7M
         CCC4Gh3GIY39s6QajKWOHKVbVZjCo1XISyg3NdAZH0GTTyknf8qznMc9F/9GXa/QimL4
         5Bc8Y+19QjUmTrnS6aWg6GxL5OsH6TDl6g4hYp0yocmL6z8X92F/i8khOf5bNxy8b51R
         wAtV/sHTamIHPohQSbTLD3DMeX6YQaKYMWvLDNz8LTyKGE0u8EpzLlhxm1od3buvWpxa
         b4I/Xxw6mwef0znkHy7bWz9QA/9Ud1CntG1pphwm44kK7gHhjCJ7l6xbDr1EdwESS80q
         86gg==
X-Gm-Message-State: AOAM532ueooJHjy0MRz4M4gRPFZsP5nhocG50rhmee+QFo3mygIeoSSf
        FL9gRc88vBl2AVFkG3zePzSwfOqimJTBAcs5iT9ZzPmv8lWWL2TETtD793ZuPuucxVxhVMdnZFa
        doA7yyq3wLkZh/7jalRsr2lGVifCwKijQ9/JRka/s2HvjoDsqUULYkvpHuufYOg==
X-Google-Smtp-Source: ABdhPJzUwsF5wVC931xZYF1l9F3BvihKAftpp14vAGgO3bqJR30lPc4E/6mCkNgjtN2Cr1Ne4uizjDCQxfw=
Sender: "pgonda via sendgmr" <pgonda@pgonda1.kir.corp.google.com>
X-Received: from pgonda1.kir.corp.google.com ([2620:0:1008:1101:f693:9fff:fef4:e3a2])
 (user=pgonda job=sendgmr) by 2002:a25:3403:: with SMTP id b3mr5959417yba.455.1601050832643;
 Fri, 25 Sep 2020 09:20:32 -0700 (PDT)
Date:   Fri, 25 Sep 2020 09:19:10 -0700
In-Reply-To: <20200925161916.204667-1-pgonda@google.com>
Message-Id: <20200925161916.204667-25-pgonda@google.com>
Mime-Version: 1.0
References: <20200925161916.204667-1-pgonda@google.com>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH 24/30 for 5.4] dma-direct: provide function to check physical
 memory area validity
From:   Peter Gonda <pgonda@google.com>
To:     stable@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>

upstream 567f6a6eba0c09e5f502e0290e57651befa8aacb commit.

dma_coherent_ok() checks if a physical memory area fits a device's DMA
constraints.

Signed-off-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Peter Gonda <pgonda@google.com>
---
 include/linux/dma-direct.h | 1 +
 kernel/dma/direct.c        | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/dma-direct.h b/include/linux/dma-direct.h
index fb5ec847ddf3..8ccddee1f78a 100644
--- a/include/linux/dma-direct.h
+++ b/include/linux/dma-direct.h
@@ -68,6 +68,7 @@ static inline phys_addr_t dma_to_phys(struct device *dev, dma_addr_t daddr)
 u64 dma_direct_get_required_mask(struct device *dev);
 gfp_t dma_direct_optimal_gfp_mask(struct device *dev, u64 dma_mask,
 				  u64 *phys_mask);
+bool dma_coherent_ok(struct device *dev, phys_addr_t phys, size_t size);
 void *dma_direct_alloc(struct device *dev, size_t size, dma_addr_t *dma_handle,
 		gfp_t gfp, unsigned long attrs);
 void dma_direct_free(struct device *dev, size_t size, void *cpu_addr,
diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index 6c677ffdbd53..54c1c3a20c09 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -84,7 +84,7 @@ gfp_t dma_direct_optimal_gfp_mask(struct device *dev, u64 dma_mask,
 	return 0;
 }
 
-static bool dma_coherent_ok(struct device *dev, phys_addr_t phys, size_t size)
+bool dma_coherent_ok(struct device *dev, phys_addr_t phys, size_t size)
 {
 	return phys_to_dma_direct(dev, phys) + size - 1 <=
 			min_not_zero(dev->coherent_dma_mask, dev->bus_dma_mask);
-- 
2.28.0.618.gf4bc123cb7-goog

