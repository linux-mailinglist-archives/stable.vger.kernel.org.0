Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B863E3547F6
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 23:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241213AbhDEVDJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 17:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235284AbhDEVDG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Apr 2021 17:03:06 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E42CC061756
        for <stable@vger.kernel.org>; Mon,  5 Apr 2021 14:02:59 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id s23so1712982plp.1
        for <stable@vger.kernel.org>; Mon, 05 Apr 2021 14:02:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=PmrHGer98y5GPth22DEOJMU23+DTwZMIhPbqhMPinKg=;
        b=JV9u/4blSyno23H7hLGTcfF+ixk3hmvvdA0SlzoSjs65mWQPkJps7ctX/bsSAUsqzH
         sOplfi3KyEyX5+sfdSXVjwJlb0OANxAREZI7g9RtlcDlEX9vEuGafR5SvDjlw+U//U5J
         lqNF4SU0OAEjM1DWj3OxW/suryxoxR/JpetCAh8asj1YVA2iamRT8o4CotYcQEDige3P
         arzClj/gz3kC3/Wf+IiVjhGuY6cQe/Tg8V4sD/DeRGfY05WReTZ8f+VsFR7QisqkEYia
         EdAEzaQdhJ79ZvD/n/The4gMRiSGi6HvO86qGZac1ryHSZyydS0+j0xWpILhuOSNt8YG
         3/fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=PmrHGer98y5GPth22DEOJMU23+DTwZMIhPbqhMPinKg=;
        b=moLP5kuaBNf35gTxnudjRj1w1vOX7M9/UNjOMVkDqYug2EBkiR6tPYXzP8XqSn6SMV
         sHHsoVYKV2KaUYFAgplYICMcRZ1bgVSVydHQfs1SbKXvsU7mjuX8W4q/GOASwbkV1r1V
         K9JdAn4SjQq4heih4QwA06aZWpSMcnM/Pw0whE1QCi77l0mdxa5Rf73BfJYXN3j8+gai
         OjFDOF14zfylSFKZGDJz1gUXDv8jKarBhrEZRI9LhFGO8h2NmOkSwbFoC0FXotODISFo
         CVxUy5XcEpxbrOk8LWR9H+oSXzzoxwneiwmGklpf9YrPr2P1arWdkewmRUbr/JXQq64l
         sBRA==
X-Gm-Message-State: AOAM532As49dq/Cp93qE7HEXKZ+VOKd3mMlzaybNv7FMx/q2nHNetA1W
        OAUpZtpc0PhLdQ+PrW5L7BaJIFvO3VxbODWknyp+dCfG1I5/NXoq1E52OC4kLJwvdVmkNiUgpHq
        d0Cj85q0gxFc39xkR9ATYxLCQL41rsRyz58ZY/805AkjOZvoCrmQe9K9gN+0=
X-Google-Smtp-Source: ABdhPJxkRtR8ycjcJ9yB6QK0/WKHgNLbbJs9pVG/KHAgo1bA6rD2YKO703fUk70Wf3Zo/8r+PdnUPjtDgQ==
X-Received: from jxgao-snp.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1373])
 (user=jxgao job=sendgmr) by 2002:aa7:8498:0:b029:1f6:8a25:7ade with SMTP id
 u24-20020aa784980000b02901f68a257ademr24789415pfn.76.1617656579044; Mon, 05
 Apr 2021 14:02:59 -0700 (PDT)
Date:   Mon,  5 Apr 2021 21:02:24 +0000
In-Reply-To: <20210405210230.1707074-1-jxgao@google.com>
Message-Id: <20210405210230.1707074-3-jxgao@google.com>
Mime-Version: 1.0
References: <20210405210230.1707074-1-jxgao@google.com>
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH v5.10 2/8] swiotlb: factor out an io_tlb_offset helper
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
index 781b9dca197c..6d6ff626c937 100644
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
2.27.0

