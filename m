Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A248355D13
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 22:44:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347217AbhDFUo1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 16:44:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245597AbhDFUo0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Apr 2021 16:44:26 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47B8AC06174A
        for <stable@vger.kernel.org>; Tue,  6 Apr 2021 13:44:17 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id t18so8244198plr.15
        for <stable@vger.kernel.org>; Tue, 06 Apr 2021 13:44:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=qxdeuOO53xNn5L+iWd5nrehog6YB9+Phe9T1PVLNLRY=;
        b=QH8zjaA5zJLcI3qtCPDYdXPI/i73hh5zaAU9z5G7hbm/tJbgCIzLBvt9mqVbM7TcP0
         B/8HrNtVAM8r1sqXyF1kJB/eqIQdRw9ORNnCbLmuBts80X5Lxuseg45HBxp7G45rV75c
         9T8UE4naiqHwOCgo8GRRWXctB/lXuTMLZrES2RUbPqcxo3AgZ37KXX9pjwgFOjD6NJ9y
         xy8qXr+mx2SPSZqPsDE0t0xRfRpBqP+4UGHpxiZ07Sd4igkelDAHIOAK/WwnQo+TeKe5
         aHgZG0EhvH0FYXwSBQGMxLX19Z6jN6/EQ+3zpfSzmEUXcKYmCW8+pNfqR56uBi4cjkUn
         bDIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=qxdeuOO53xNn5L+iWd5nrehog6YB9+Phe9T1PVLNLRY=;
        b=SwHnWJ/acLbgkMI6mzl3IrGJP96/VZ4XaeQG+Y1/1CHxH4IsPgNPQrUguCD9MaWIJj
         VQQZ7ySz5gOKbxmkcnvVlfUlppOq9pSiZiYjLX5RXnc3pcxXV7mSOUgF4UQTKvcRdyop
         Px8IL/uCvnvY4/zYx1u2isv4dLv+rithmpst5b22yhtHkcmslJjpTrE+hwQBvXcEwrvB
         JSGWvdqfnHkmpLQ9Dv/FxvRvxaJ2aqJiDiwCIP3Q2Pu6wjumWL1uLLSttcwGoMxCQq2x
         uevRmvejGWvRzgigKwC0vyiVuvc9xrK+8eywYhbONcUcxItkDv3zSYINJXqvb/pNZrck
         ELbA==
X-Gm-Message-State: AOAM533BobKP7PvTDGtBW9YEC6NA3rRh3t4GBFWyYvzfuiVtPNVkKsuO
        ZAS2bL0XKaPFdgpcFhqfu4kZJUjfScwOa8b0m7pd6RnHcWuEFCPrqNLc8PGuhKw7XPH9QIxTa7M
        blHn4OWMwJeUC+ITqIa0u9cSN+rvXzjiSZsR3f8IR3lXqRDHf+lJKI2qsE2c=
X-Google-Smtp-Source: ABdhPJyOL5QKOx5uFE2tjtynfL7pUg8hwbuESdDlEpEFUzX7UkZqvwdCqRddiZkSwsY6oMFmptuRJpjnMA==
X-Received: from jxgao-snp.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1373])
 (user=jxgao job=sendgmr) by 2002:a17:90a:df01:: with SMTP id
 gp1mr617532pjb.1.1617741856322; Tue, 06 Apr 2021 13:44:16 -0700 (PDT)
Date:   Tue,  6 Apr 2021 20:43:21 +0000
In-Reply-To: <20210406204326.1932888-1-jxgao@google.com>
Message-Id: <20210406204326.1932888-3-jxgao@google.com>
Mime-Version: 1.0
References: <20210406204326.1932888-1-jxgao@google.com>
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH V2 v5.4 2/8] swiotlb: factor out an io_tlb_offset helper
From:   Jianxiong Gao <jxgao@google.com>
To:     stable@vger.kernel.org
Cc:     Jianxiong Gao <jxgao@google.com>, Christoph Hellwig <hch@lst.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
'commit c7fbeca757fe ("swiotlb: factor out an io_tlb_offset helper")'

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

