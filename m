Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C724036EEF5
	for <lists+stable@lfdr.de>; Thu, 29 Apr 2021 19:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233706AbhD2Rfa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Apr 2021 13:35:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232991AbhD2Rfa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Apr 2021 13:35:30 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E43EC06138B
        for <stable@vger.kernel.org>; Thu, 29 Apr 2021 10:34:42 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id w9-20020a17090a4609b0290150d07df879so15334431pjg.9
        for <stable@vger.kernel.org>; Thu, 29 Apr 2021 10:34:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=gUujUgkguLuTeeJSnMWCbPSuzJnLLvExvqc94TrwfjA=;
        b=ZxHHriHCwdMbqE0BtqCzyqooUbIpuy88X3ppS3mPgzpZ7i2tdo/VQIrnB/HgkT8XS/
         xwjjZK5c12AwvWysw1AAVXZIYTk4fqUy+xPdAVF60tI4DkvChnvM9FukBONHVQ0yX/sN
         2lFT4CTeGvirWJoLfrh7WBfGitmHBuIBVGu4qj4XruxTibsd5hXbBMCwgYKwo1vcMLuZ
         Z6U+KwfoQ6ToZpWHLVrhX17Ie9daXA7KQfjgQ6CH06qdTWaFAepjbEZW5B8TVDgChlrK
         JxzZcher/cehQnjvldxwg62TQQU0PjkJ8TPVSdb9QuD1CKHBth+ZPwI7Ll5EeHw+cmpv
         ukxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=gUujUgkguLuTeeJSnMWCbPSuzJnLLvExvqc94TrwfjA=;
        b=pbZ0OEceRitA/ejZLRGnLmoPsFuY7U4vBtmg8GMABataW91wU1MU9831zBeJSOICHr
         qhB7GEJc1y+fQQW5lcvWJWUmZn5P9f2RbQYEOPlh2a5uS+qj5SsXMpdIVJGPz2Fx9IF9
         R31gNqmgQKqu3HZWzDPTV0PnCisZcrlB2yq9r8yHanBsPfXIN1+vUEECGHAxTkWjliJC
         Y9yFOeQPf/0QaWC3JFDWJb/TsOIyvxxvwC+FpgoxcqungFg+QZo96cFHsRGPzKVzW6Qs
         tzI3q7zY0qG1+Mv9eVCJYUMZFjf6nxGzeMrBh0COkcHdJFckOjxV4sIanoXAiqyWuf/O
         MtFA==
X-Gm-Message-State: AOAM531M4fck62t5Yy7zkJOYq2MA5PWLUBoQwt7kT02RAXMQ2WabacXw
        lt88i7+7js4pAD4HKPWMijJjPbXSTXylGOipmMX+gjGpK7fsy+5fA6FV4+Vx/6yL6GTHWohqp7z
        vGnKWcSKvB60eEd6gr6RY4cBzrCLFcFhtfnntfk4oTuOxoinxZmyEK+q1MlA=
X-Google-Smtp-Source: ABdhPJzZ+Pf1fRJJ0k7/6FxkwEAju+10bQgVyTr6eOAQxX4Vc6G8Ybb/N3DMX7V0UMzwNpVrvdtpIheR9Q==
X-Received: from jxgao-snp.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1373])
 (user=jxgao job=sendgmr) by 2002:a17:90a:174c:: with SMTP id
 12mr812800pjm.1.1619717681057; Thu, 29 Apr 2021 10:34:41 -0700 (PDT)
Date:   Thu, 29 Apr 2021 17:33:08 +0000
In-Reply-To: <20210429173315.1252465-1-jxgao@google.com>
Message-Id: <20210429173315.1252465-3-jxgao@google.com>
Mime-Version: 1.0
References: <20210429173315.1252465-1-jxgao@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH v2 5.10 2/9] swiotlb: add a IO_TLB_SIZE define
From:   Jianxiong Gao <jxgao@google.com>
To:     stable@vger.kernel.org, hch@lst.de, marcorr@google.com,
        sashal@kernel.org
Cc:     Jianxiong Gao <jxgao@google.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit: b5d7ccb7aac3895c2138fe0980a109116ce15eff

Add a new IO_TLB_SIZE define instead open coding it using
IO_TLB_SHIFT all over.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Jianxiong Gao <jxgao@google.com>
Tested-by: Jianxiong Gao <jxgao@google.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Jianxiong Gao <jxgao@google.com>
---
 include/linux/swiotlb.h |  1 +
 kernel/dma/swiotlb.c    | 12 ++++++------
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index fbdc65782195..5d2dbe7e04c3 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -29,6 +29,7 @@ enum swiotlb_force {
  * controllable.
  */
 #define IO_TLB_SHIFT 11
+#define IO_TLB_SIZE (1 << IO_TLB_SHIFT)
 
 extern void swiotlb_init(int verbose);
 int swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int verbose);
diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 781b9dca197c..fb88c2982645 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -475,20 +475,20 @@ phys_addr_t swiotlb_tbl_map_single(struct device *hwdev, phys_addr_t orig_addr,
 
 	tbl_dma_addr &= mask;
 
-	offset_slots = ALIGN(tbl_dma_addr, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT;
+	offset_slots = ALIGN(tbl_dma_addr, IO_TLB_SIZE) >> IO_TLB_SHIFT;
 
 	/*
 	 * Carefully handle integer overflow which can occur when mask == ~0UL.
 	 */
 	max_slots = mask + 1
-		    ? ALIGN(mask + 1, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT
+		    ? ALIGN(mask + 1, IO_TLB_SIZE) >> IO_TLB_SHIFT
 		    : 1UL << (BITS_PER_LONG - IO_TLB_SHIFT);
 
 	/*
 	 * For mappings greater than or equal to a page, we limit the stride
 	 * (and hence alignment) to a page size.
 	 */
-	nslots = ALIGN(alloc_size, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT;
+	nslots = ALIGN(alloc_size, IO_TLB_SIZE) >> IO_TLB_SHIFT;
 	if (alloc_size >= PAGE_SIZE)
 		stride = (1 << (PAGE_SHIFT - IO_TLB_SHIFT));
 	else
@@ -582,7 +582,7 @@ void swiotlb_tbl_unmap_single(struct device *hwdev, phys_addr_t tlb_addr,
 			      enum dma_data_direction dir, unsigned long attrs)
 {
 	unsigned long flags;
-	int i, count, nslots = ALIGN(alloc_size, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT;
+	int i, count, nslots = ALIGN(alloc_size, IO_TLB_SIZE) >> IO_TLB_SHIFT;
 	int index = (tlb_addr - io_tlb_start) >> IO_TLB_SHIFT;
 	phys_addr_t orig_addr = io_tlb_orig_addr[index];
 
@@ -633,7 +633,7 @@ void swiotlb_tbl_sync_single(struct device *hwdev, phys_addr_t tlb_addr,
 
 	if (orig_addr == INVALID_PHYS_ADDR)
 		return;
-	orig_addr += (unsigned long)tlb_addr & ((1 << IO_TLB_SHIFT) - 1);
+	orig_addr += (unsigned long)tlb_addr & (IO_TLB_SIZE - 1);
 
 	switch (target) {
 	case SYNC_FOR_CPU:
@@ -691,7 +691,7 @@ dma_addr_t swiotlb_map(struct device *dev, phys_addr_t paddr, size_t size,
 
 size_t swiotlb_max_mapping_size(struct device *dev)
 {
-	return ((size_t)1 << IO_TLB_SHIFT) * IO_TLB_SEGSIZE;
+	return ((size_t)IO_TLB_SIZE) * IO_TLB_SEGSIZE;
 }
 
 bool is_swiotlb_active(void)
-- 
2.31.1.498.g6c1eba8ee3d-goog

