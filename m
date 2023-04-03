Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB346D4974
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:38:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233733AbjDCOiF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:38:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233705AbjDCOiD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:38:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FC2B10DA
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:37:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91DCE6146A
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:37:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A411CC433D2;
        Mon,  3 Apr 2023 14:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532678;
        bh=08OWbfiWPJSbxDnAwXss/74HZV+xVfgvzDUcsYqfuCA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VmFOkz6SqoO3S7Ka+CR0GEtITBc9y7P6YjtckuNQazUT51O4Fs9e9TXKv5McH8CPG
         ez066i1vu/+SXzDCg5Yw7kvSiAb3ZonC61O8pKEBh1Sw6ztydWN2R8tQuAVZMmj4GA
         OEUEwODrKVOfC6ulurswZdB+l7YkYTe9p4O2CdHY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Petr Tesarik <petr.tesarik.ext@huawei.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 074/181] swiotlb: fix slot alignment checks
Date:   Mon,  3 Apr 2023 16:08:29 +0200
Message-Id: <20230403140417.540659835@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
References: <20230403140415.090615502@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petr Tesarik <petr.tesarik.ext@huawei.com>

[ Upstream commit 0eee5ae1025699ea93d44fdb6ef2365505082103 ]

Explicit alignment and page alignment are used only to calculate
the stride, not when checking actual slot physical address.

Originally, only page alignment was implemented, and that worked,
because the whole SWIOTLB is allocated on a page boundary, so
aligning the start index was sufficient to ensure a page-aligned
slot.

When commit 1f221a0d0dbf ("swiotlb: respect min_align_mask") added
support for min_align_mask, the index could be incremented in the
search loop, potentially finding an unaligned slot if minimum device
alignment is between IO_TLB_SIZE and PAGE_SIZE.  The bug could go
unnoticed, because the slot size is 2 KiB, and the most common page
size is 4 KiB, so there is no alignment value in between.

IIUC the intention has been to find a slot that conforms to all
alignment constraints: device minimum alignment, an explicit
alignment (given as function parameter) and optionally page
alignment (if allocation size is >= PAGE_SIZE). The most
restrictive mask can be trivially computed with logical AND. The
rest can stay.

Fixes: 1f221a0d0dbf ("swiotlb: respect min_align_mask")
Fixes: e81e99bacc9f ("swiotlb: Support aligned swiotlb buffers")
Signed-off-by: Petr Tesarik <petr.tesarik.ext@huawei.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/swiotlb.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 1ecd0d1f7231a..eeb5695c3f286 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -626,22 +626,26 @@ static int swiotlb_do_find_slots(struct device *dev, int area_index,
 	BUG_ON(!nslots);
 	BUG_ON(area_index >= mem->nareas);
 
+	/*
+	 * For allocations of PAGE_SIZE or larger only look for page aligned
+	 * allocations.
+	 */
+	if (alloc_size >= PAGE_SIZE)
+		iotlb_align_mask &= PAGE_MASK;
+	iotlb_align_mask &= alloc_align_mask;
+
 	/*
 	 * For mappings with an alignment requirement don't bother looping to
-	 * unaligned slots once we found an aligned one.  For allocations of
-	 * PAGE_SIZE or larger only look for page aligned allocations.
+	 * unaligned slots once we found an aligned one.
 	 */
 	stride = (iotlb_align_mask >> IO_TLB_SHIFT) + 1;
-	if (alloc_size >= PAGE_SIZE)
-		stride = max(stride, stride << (PAGE_SHIFT - IO_TLB_SHIFT));
-	stride = max(stride, (alloc_align_mask >> IO_TLB_SHIFT) + 1);
 
 	spin_lock_irqsave(&area->lock, flags);
 	if (unlikely(nslots > mem->area_nslabs - area->used))
 		goto not_found;
 
 	slot_base = area_index * mem->area_nslabs;
-	index = wrap_area_index(mem, ALIGN(area->index, stride));
+	index = area->index;
 
 	for (slots_checked = 0; slots_checked < mem->area_nslabs; ) {
 		slot_index = slot_base + index;
-- 
2.39.2



