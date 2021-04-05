Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 497973547F9
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 23:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241221AbhDEVDK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 17:03:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241212AbhDEVDJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Apr 2021 17:03:09 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B8F4C061756
        for <stable@vger.kernel.org>; Mon,  5 Apr 2021 14:03:02 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id c22so331165pjr.1
        for <stable@vger.kernel.org>; Mon, 05 Apr 2021 14:03:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=3/VrZKSoEtRqs32BVLxGVqeAOFDw54sE+azAS1DYqE8=;
        b=sWlpfL9QVXJlsuIkthh7jJLdqvBLYcOGLeO+KsvXFnHkfeMZztbA8P5nvoAGkHZqvq
         zQOILSELgGVYpbByCAIt40rwsPRCy979y8BqCqEF2a7SZqS2kQrALYvS595wX8LWsMm7
         lRF501PeFs/lVHoVF8yovHvGiT4NIT4F7AZNljPbtoqo/+etU18UU2/wkU8+PjzXald0
         HKjFPraZ1v3O3K99AREMMsIfxFNOot+1N3WpF1j15W23pGZofmgB1ugW9i5zZVBuBbjZ
         7msx0MKmAhocK6szVER3WNwHjjnNe5pvoMe5R88FXcN2wKNQlWAAYNwwn3t/6fowsPUm
         /3/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=3/VrZKSoEtRqs32BVLxGVqeAOFDw54sE+azAS1DYqE8=;
        b=GWqn6hwvuFCg39xXGaSTCuRz7aW7ST8oTcR531zkAT9dG4/Jq11IgKVsdzSjNXesg4
         nRbfiVVXCc6yZDOgiOqrKUNfq3JmrF3Ok3cjrabne+CnLcl664FFz6H4T4Hex/oAQ65+
         s/WJS8KA/dmwUmDfU58YcMar9FV6n6j8aN2zsGgVIxbS2fA0kk2lLRiTDXrVirFwpKvY
         xr3U/Bs9DPctqM3TaWq8xiCAplsFEcNckRJCh+OOAmZkozxbCFr0/PyG4jvJIpwTvQ/W
         8eBPzIADEFxkHX4OObaDwPFnkOg5ab3kB2fT9UqO8vNaoDGov5jZDvwbr+zw5rxzEN/6
         rBvQ==
X-Gm-Message-State: AOAM531pdCHHST3D/9v+s73pLGsDcWWm3fEbyCLYJFt6ceQFsyGqeKxq
        gPHpXO7MztMomNXe+eE1/FIYoSyoZblZrey68nqUmkOAy+PmgHAx7aLxXQCukdF+zUKqmApvoen
        7DhtsTQggglVii2c3pWLIUlRk5ip6sJfhrXAvJT3MheQykhTrHMLsHS0nBlk=
X-Google-Smtp-Source: ABdhPJx7j0xZus9u4/rISxAJZcj9s3ZmGEMK+iuQuu8dOPy9ZramJpoOusPghqjz5TwUdz+lLakp0KT/Uw==
X-Received: from jxgao-snp.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1373])
 (user=jxgao job=sendgmr) by 2002:a17:902:348:b029:e8:dea9:f026 with SMTP id
 66-20020a1709020348b02900e8dea9f026mr10975475pld.19.1617656581473; Mon, 05
 Apr 2021 14:03:01 -0700 (PDT)
Date:   Mon,  5 Apr 2021 21:02:25 +0000
In-Reply-To: <20210405210230.1707074-1-jxgao@google.com>
Message-Id: <20210405210230.1707074-4-jxgao@google.com>
Mime-Version: 1.0
References: <20210405210230.1707074-1-jxgao@google.com>
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH v5.10 3/8] swiotlb: factor out a nr_slots helper
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
index 6d6ff626c937..1ba8e1095dfc 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -178,6 +178,11 @@ static inline unsigned long io_tlb_offset(unsigned long val)
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
@@ -477,20 +482,20 @@ phys_addr_t swiotlb_tbl_map_single(struct device *hwdev, phys_addr_t orig_addr,
 
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

