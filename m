Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2173882A9
	for <lists+stable@lfdr.de>; Wed, 19 May 2021 00:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352715AbhERWUs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 May 2021 18:20:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352714AbhERWUs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 May 2021 18:20:48 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E55A0C061573
        for <stable@vger.kernel.org>; Tue, 18 May 2021 15:19:29 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id g144-20020a6252960000b029023d959faca6so6881822pfb.9
        for <stable@vger.kernel.org>; Tue, 18 May 2021 15:19:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=1sHftSwjlQth3xQj6h8cgHS/by+aNvWcSV7kY4Wh5+o=;
        b=V5P0GUkO8WdeRK4L8aIYgXk1c2VYtcPVhqToSIou4tOWrGEHK7JaeXDBIDRhO6BqGx
         RZGM3C5rZZPA5CBUUr1KJObJSeXwp5gsOD8UzvEyw+8gm+ZxBse4qDaBhNWe9S7hSleq
         wV7zJayT+4ZNJLqwrAhiGvcScCn7YjEm4sKdAFAskRbYa/bOmBtrESvwjkyzLZ/mgeXJ
         MVeEGpFLyKDqTKAlb72POigmbqODPlAtmHnzuVwDmKJ7/IjPAM0LNnpH3UbOYDB/L+gu
         D2BCP5j7zaH2hGEDDfFK4vWAeyPVeEXgzPtqLwVVMaPgVPjepN8vmIsBUF71QkxitnzG
         QWLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=1sHftSwjlQth3xQj6h8cgHS/by+aNvWcSV7kY4Wh5+o=;
        b=tRKoPdnKzaQIsNP6cvW1FdsBYK/g+HOgO/ftkP1tC4/BjUF5AgVqWPdopboL4/0inX
         NDzoija3OSvQ2/7MzWh34mkh/+96pyLeDxBYnOtQ6Zntyg4HybYEu7ey0fU87kcNoUv5
         Fv3Y9FzciREwKMlZ32DolH27L+Ow/xITRbFdCBUCklgCECs49yJhDcmyhUyuMkltZx+O
         IG0gjuXtXOUTinzYruwiZrY4q6N7vLwrc1D4Rn4OecTWlazrutaGQ4ZWUjvqUtP3aEU5
         /MkZAOFduIe22ST4rrZxCx5yP1a3w364QLDQAg9QrWWCzdZkvB72MxCxiV/w4WGWuq0V
         HEcA==
X-Gm-Message-State: AOAM5326xCc0Cc3Jmjy+kTe7sbXB9FaNS5t2IqzibO+lRSz1FSxzys/I
        Bhlrkn2OrJUIuXnE720zTxMtjfQlWCT4PHBsrIkICi4gsf/9Xcwy81wgnC+krF/mlptbFO5Ua83
        yX0z7SP5ccBn1yP726UGiFMED0kxUvhXW3jsfQiFuxouzddDpxwDqHVF0yXM=
X-Google-Smtp-Source: ABdhPJzy3PujgKDvJFFxRORvVU1WeTtzNXVq1mUvQpQi3b0wMSHhsQZ9kfKf8uDWGssDskParYu3waJZ9w==
X-Received: from jxgao-snp.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1373])
 (user=jxgao job=sendgmr) by 2002:a17:902:e302:b029:ee:9596:8e7a with SMTP id
 q2-20020a170902e302b02900ee95968e7amr6925434plc.37.1621376369410; Tue, 18 May
 2021 15:19:29 -0700 (PDT)
Date:   Tue, 18 May 2021 22:18:13 +0000
In-Reply-To: <20210518221818.2963918-1-jxgao@google.com>
Message-Id: <20210518221818.2963918-4-jxgao@google.com>
Mime-Version: 1.0
References: <20210518221818.2963918-1-jxgao@google.com>
X-Mailer: git-send-email 2.31.1.751.gd2f1c929bd-goog
Subject: [PATCH 5.4 v2 3/9] swiotlb: factor out an io_tlb_offset helper
From:   Jianxiong Gao <jxgao@google.com>
To:     stable@vger.kernel.org, hch@lst.de, marcorr@google.com,
        sashal@kernel.org
Cc:     Jianxiong Gao <jxgao@google.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Replace the very genericly named OFFSET macro with a little inline
helper that hardcodes the alignment to the only value ever passed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Jianxiong Gao <jxgao@google.com>
Tested-by: Jianxiong Gao <jxgao@google.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Upstream: c7fbeca757fe74135d8b6a4c8ddaef76f5775d68
Signed-off-by: Jianxiong Gao <jxgao@google.com>
---
 kernel/dma/swiotlb.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index af4130059202..db265dc324b9 100644
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
@@ -360,7 +362,7 @@ swiotlb_late_init_with_tbl(char *tlb, unsigned long nslabs)
 		goto cleanup4;
 
 	for (i = 0; i < io_tlb_nslabs; i++) {
-		io_tlb_list[i] = IO_TLB_SEGSIZE - OFFSET(i, IO_TLB_SEGSIZE);
+		io_tlb_list[i] = IO_TLB_SEGSIZE - io_tlb_offset(i);
 		io_tlb_orig_addr[i] = INVALID_PHYS_ADDR;
 	}
 	io_tlb_index = 0;
@@ -534,7 +536,9 @@ phys_addr_t swiotlb_tbl_map_single(struct device *hwdev,
 
 			for (i = index; i < (int) (index + nslots); i++)
 				io_tlb_list[i] = 0;
-			for (i = index - 1; (OFFSET(i, IO_TLB_SEGSIZE) != IO_TLB_SEGSIZE - 1) && io_tlb_list[i]; i--)
+			for (i = index - 1;
+			     io_tlb_offset(i) != IO_TLB_SEGSIZE - 1 &&
+			     io_tlb_list[i]; i--)
 				io_tlb_list[i] = ++count;
 			tlb_addr = io_tlb_start + (index << IO_TLB_SHIFT);
 
@@ -620,7 +624,9 @@ void swiotlb_tbl_unmap_single(struct device *hwdev, phys_addr_t tlb_addr,
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
2.31.1.751.gd2f1c929bd-goog

