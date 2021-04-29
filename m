Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2765636EEF6
	for <lists+stable@lfdr.de>; Thu, 29 Apr 2021 19:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235685AbhD2Rfb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Apr 2021 13:35:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232991AbhD2Rfa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Apr 2021 13:35:30 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 286F5C06138B
        for <stable@vger.kernel.org>; Thu, 29 Apr 2021 10:34:44 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id l25-20020a6357190000b02901f6df0d646eso23531896pgb.23
        for <stable@vger.kernel.org>; Thu, 29 Apr 2021 10:34:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=JV76XCsz4e0gc+MazEk+b5X8PU6g1+7xiAXJkY2kbxE=;
        b=YpiCUg9sKs+kadrjpiWkTcct/WTkU9xy8UNgpG3gJeI2PXNXoRDuETv7P4S1mghljp
         AZ48Yeg6UpUkh4NMsI0D7hfeBjM3y7XTgx92tf4Y6/ugFA9sBCURdqvkN4XK3TlBusK4
         k0dLrENVDuBVV6+zz5ywVj1PgMa3FIHzNJdHFjbuOahQpLphnKFhqFpSka7Q+FRbaEjt
         FcAIDAHKcuwLRafjrX2g47Ci2PjrW3O2vvCxQl+lzohfHQnW8jwKt4gpw5vqB5bpDTcY
         n4TnWLdiU6xCAzotmDZgCpuVEABKY4qI9KR7VOoyTokRuD1O+PHTWSJIVStRnxCIOX+O
         QxYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=JV76XCsz4e0gc+MazEk+b5X8PU6g1+7xiAXJkY2kbxE=;
        b=LJ548THD5HtRZQF6NxfCUaVSRzA/s6HUU5tTkO+LV3EivbxV0mJdOd3XZfT2dtdmmo
         AojAJ0EsHZJ+CuINXw8+9PdXV414V4yH0ljQvsAzjDv8RR8uVIDNhgTHeg4VapTr6c92
         IfhRkZ3tU+9Ug/yRXbjZk5xJ4nsqNQ5jrjWu5QxqFIFtJiXgZcAlLiWCkPblBrD5mEAQ
         +Ad2AcCOZ9f5xRMf2cMi7jOWj8grhkSHWKNxM+TjavwL0k7Ew5bOcyzDHutaFrYNbb/C
         9N2MseMndLkwurG9aBVE278B0d6fin6ni/k1kfGb5jfGvCX9oE22hEU9T/d3xv+J1ium
         4vjQ==
X-Gm-Message-State: AOAM533eKGIhD2wLvullCO8exvcd3fGB8EZxVrsSOM0ShJsv9tZO5j8B
        N1naQEc+xVo6hNs3foLYga+1BPkxs+xC1cnE7q0h5qFC3e+4juQssFju5VAcbXVGyqVWkWxbusr
        7ZxtmtNKWHsy7LJPrwTlEt/oYFIzp8STOn3sTd2F8EbPEmVC0kTHYSIhahxs=
X-Google-Smtp-Source: ABdhPJxZOg8mOWjsJyDC63w6Bj74tdWGj8xQ+hNclAyDbb4fhRxKQDWkspkZIVI3IXQYUzlMThSsQCkcVw==
X-Received: from jxgao-snp.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1373])
 (user=jxgao job=sendgmr) by 2002:a17:90a:390d:: with SMTP id
 y13mr813480pjb.0.1619717682916; Thu, 29 Apr 2021 10:34:42 -0700 (PDT)
Date:   Thu, 29 Apr 2021 17:33:09 +0000
In-Reply-To: <20210429173315.1252465-1-jxgao@google.com>
Message-Id: <20210429173315.1252465-4-jxgao@google.com>
Mime-Version: 1.0
References: <20210429173315.1252465-1-jxgao@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH v2 5.10 3/9] swiotlb: factor out an io_tlb_offset helper
From:   Jianxiong Gao <jxgao@google.com>
To:     stable@vger.kernel.org, hch@lst.de, marcorr@google.com,
        sashal@kernel.org
Cc:     Jianxiong Gao <jxgao@google.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit: c7fbeca757fe74135d8b6a4c8ddaef76f5775d68

Replace the very genericly named OFFSET macro with a little inline
helper that hardcodes the alignment to the only value ever passed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Jianxiong Gao <jxgao@google.com>
Tested-by: Jianxiong Gao <jxgao@google.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Jianxiong Gao <jxgao@google.com>
---
 kernel/dma/swiotlb.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index fb88c2982645..f55248f16366 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -50,9 +50,6 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/swiotlb.h>
 
-#define OFFSET(val,align) ((unsigned long)	\
-	                   ( (val) & ( (align) - 1)))
-
 #define SLABS_PER_PAGE (1 << (PAGE_SHIFT - IO_TLB_SHIFT))
 
 /*
@@ -176,6 +173,11 @@ void swiotlb_print_info(void)
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
@@ -225,7 +227,7 @@ int __init swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int verbose)
 		      __func__, alloc_size, PAGE_SIZE);
 
 	for (i = 0; i < io_tlb_nslabs; i++) {
-		io_tlb_list[i] = IO_TLB_SEGSIZE - OFFSET(i, IO_TLB_SEGSIZE);
+		io_tlb_list[i] = IO_TLB_SEGSIZE - io_tlb_offset(i);
 		io_tlb_orig_addr[i] = INVALID_PHYS_ADDR;
 	}
 	io_tlb_index = 0;
@@ -359,7 +361,7 @@ swiotlb_late_init_with_tbl(char *tlb, unsigned long nslabs)
 		goto cleanup4;
 
 	for (i = 0; i < io_tlb_nslabs; i++) {
-		io_tlb_list[i] = IO_TLB_SEGSIZE - OFFSET(i, IO_TLB_SEGSIZE);
+		io_tlb_list[i] = IO_TLB_SEGSIZE - io_tlb_offset(i);
 		io_tlb_orig_addr[i] = INVALID_PHYS_ADDR;
 	}
 	io_tlb_index = 0;
@@ -530,7 +532,9 @@ phys_addr_t swiotlb_tbl_map_single(struct device *hwdev, phys_addr_t orig_addr,
 
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
2.31.1.498.g6c1eba8ee3d-goog

