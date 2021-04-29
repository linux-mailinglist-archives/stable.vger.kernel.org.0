Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAC1436EEF7
	for <lists+stable@lfdr.de>; Thu, 29 Apr 2021 19:34:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237244AbhD2Rfd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Apr 2021 13:35:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232991AbhD2Rfc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Apr 2021 13:35:32 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96633C06138B
        for <stable@vger.kernel.org>; Thu, 29 Apr 2021 10:34:45 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id n129-20020a2527870000b02904ed02e1aab5so34989839ybn.21
        for <stable@vger.kernel.org>; Thu, 29 Apr 2021 10:34:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ADgLt44c5UjxWVqp7l4awTjeHsx68ICN3sgpsWTgLCM=;
        b=fmFkVaaTEj9oqCMFYeK3hEkaOggf9AohCYtKb5BFA0nTXhopx9nsvN/tFtlWcCPfOU
         BRSkM5/EzVkCK9P7slYto0Kb85fjgOQ/ZgYZXo5dCViL3zUZp+kBjY8NR+y9G/OPiSWX
         DQpnPrWrOHp2OsSinTIEdKv+ON/8y+zvkiyE1lhqpou9ZiL4sLRbMoHyApR9KHrMsm2x
         Qv10gq1R1/sFkUrkMyfmg8M/DsuwEn51tiTDCxPfprrhFSUARF3PhRXRCjW7GCFovpSn
         JGaZflgKq2TO49mMuW2Yg7d56axyHHXjE5fdANVRL4sl27H6cmCD9CkYJRgM1gYVQ32+
         b9nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ADgLt44c5UjxWVqp7l4awTjeHsx68ICN3sgpsWTgLCM=;
        b=YwQxfDDecIsig3UD4f2GXDd+nrvzhGhZRNZjtd5NBDiCjsj0Q311kqwq1ICrwK06+A
         ltFGhumbR0XmUrGFo0JWZpFodZMWjc3AzuyL7egL+JZ/TkmDRa9eAPmo+M58jM6XehbR
         fFgI9qLqCNzwT/uZGDTW+qQoFguBXHaF9LoyGn5a40ZpDREsxna3cbnvZceEvriSV52D
         UDpyJ/P9TgkXzJY+w4Hn9a//KKS88FpztnN8xroktqRxvcmW9VLrftJo+BSWZ7EBGDNc
         gC7kbu/mnili/nKFYngLz4smCF7uRXNqd43R73+dBB9RL1SC6ntN3+Y2sn/OGkEXjQT8
         rj9w==
X-Gm-Message-State: AOAM532vfd7+q9kWiLln234FTZ+xuSBdX1APvWh7GYsVWarn6L3Nr03Q
        Ygs9x65WtkvRYHC7AtQ64zJEHEvYMT+D/g72FoJ8WHG9Rb8LJboFM5HHHz6wUYgTXWFx/NfojB1
        1X7ouM8KLHy/Q5a4J9jmdELaXCRLBLKfBYrZ5X/SFZ8FNSD00S08Vz1gynF0=
X-Google-Smtp-Source: ABdhPJxXvGOXvp1D1l4PNaSv33kPclxOBWr7ZpskG7x5zsgZVBAEmqzu18NMvDi3tvMXwQ4UCZVAeHFDwg==
X-Received: from jxgao-snp.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1373])
 (user=jxgao job=sendgmr) by 2002:a5b:191:: with SMTP id r17mr892679ybl.297.1619717684666;
 Thu, 29 Apr 2021 10:34:44 -0700 (PDT)
Date:   Thu, 29 Apr 2021 17:33:10 +0000
In-Reply-To: <20210429173315.1252465-1-jxgao@google.com>
Message-Id: <20210429173315.1252465-5-jxgao@google.com>
Mime-Version: 1.0
References: <20210429173315.1252465-1-jxgao@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH v2 5.10 4/9] swiotlb: factor out a nr_slots helper
From:   Jianxiong Gao <jxgao@google.com>
To:     stable@vger.kernel.org, hch@lst.de, marcorr@google.com,
        sashal@kernel.org
Cc:     Jianxiong Gao <jxgao@google.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit: c32a77fd18780a5192dfb6eec69f239faebf28fd

Factor out a helper to find the number of slots for a given size.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Jianxiong Gao <jxgao@google.com>
Tested-by: Jianxiong Gao <jxgao@google.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Jianxiong Gao <jxgao@google.com>
---
 kernel/dma/swiotlb.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index f55248f16366..f0be199da527 100644
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
 
-	offset_slots = ALIGN(tbl_dma_addr, IO_TLB_SIZE) >> IO_TLB_SHIFT;
+	offset_slots = nr_slots(tbl_dma_addr);
 
 	/*
 	 * Carefully handle integer overflow which can occur when mask == ~0UL.
 	 */
 	max_slots = mask + 1
-		    ? ALIGN(mask + 1, IO_TLB_SIZE) >> IO_TLB_SHIFT
+		    ? nr_slots(mask + 1)
 		    : 1UL << (BITS_PER_LONG - IO_TLB_SHIFT);
 
 	/*
 	 * For mappings greater than or equal to a page, we limit the stride
 	 * (and hence alignment) to a page size.
 	 */
-	nslots = ALIGN(alloc_size, IO_TLB_SIZE) >> IO_TLB_SHIFT;
+	nslots = nr_slots(alloc_size);
 	if (alloc_size >= PAGE_SIZE)
 		stride = (1 << (PAGE_SHIFT - IO_TLB_SHIFT));
 	else
@@ -586,7 +591,7 @@ void swiotlb_tbl_unmap_single(struct device *hwdev, phys_addr_t tlb_addr,
 			      enum dma_data_direction dir, unsigned long attrs)
 {
 	unsigned long flags;
-	int i, count, nslots = ALIGN(alloc_size, IO_TLB_SIZE) >> IO_TLB_SHIFT;
+	int i, count, nslots = nr_slots(alloc_size);
 	int index = (tlb_addr - io_tlb_start) >> IO_TLB_SHIFT;
 	phys_addr_t orig_addr = io_tlb_orig_addr[index];
 
-- 
2.31.1.498.g6c1eba8ee3d-goog

