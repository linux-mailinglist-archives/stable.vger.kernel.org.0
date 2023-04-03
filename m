Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1F5D6D496D
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233697AbjDCOh7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:37:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233705AbjDCOhz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:37:55 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30C0616F10
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:37:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5D4C7CE12E8
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:37:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F286C4339B;
        Mon,  3 Apr 2023 14:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532659;
        bh=RYbs1lK+ysXQVc8k6NC5HxTjm1Ym+WcU2s8GTb30yzk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W8fPPm5vUWceEYkgWe/zLA39q5uKNDix1uY7Am2kXl003+tQ5G3ERQvltQCmurylp
         G7ZfieRqHwX+/d3iv0tBjO6uUpReDUr6MuxEKwQEiVqZJUtujXnV10tS5XbraZq7tY
         sa9HcwBp5DPzp4D9iECS6v1wdVAeUNERxGSAsc8o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "GuoRui.Yu" <GuoRui.Yu@linux.alibaba.com>,
        Xiaokang Hu <xiaokang.hxk@alibaba-inc.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 068/181] swiotlb: fix the deadlock in swiotlb_do_find_slots
Date:   Mon,  3 Apr 2023 16:08:23 +0200
Message-Id: <20230403140417.343525586@linuxfoundation.org>
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

From: GuoRui.Yu <GuoRui.Yu@linux.alibaba.com>

[ Upstream commit 7c3940bf81e5664cdb50c3fedfec8f0a756a34fb ]

In general, if swiotlb is sufficient, the logic of index =
wrap_area_index(mem, index + 1) is fine, it will quickly take a slot and
release the area->lock; But if swiotlb is insufficient and the device
has min_align_mask requirements, such as NVME, we may not be able to
satisfy index == wrap and exit the loop properly. In this case, other
kernel threads will not be able to acquire the area->lock and release
the slot, resulting in a deadlock.

The current implementation of wrap_area_index does not involve a modulo
operation, so adjusting the wrap to ensure the loop ends is not trivial.
Introduce a new variable to record the number of loops and exit the loop
after completing the traversal.

Backtraces:
Other CPUs are waiting this core to exit the swiotlb_do_find_slots
loop.
[10199.924391] RIP: 0010:swiotlb_do_find_slots+0x1fe/0x3e0
[10199.924403] Call Trace:
[10199.924404]  <TASK>
[10199.924405]  swiotlb_tbl_map_single+0xec/0x1f0
[10199.924407]  swiotlb_map+0x5c/0x260
[10199.924409]  ? nvme_pci_setup_prps+0x1ed/0x340
[10199.924411]  dma_direct_map_page+0x12e/0x1c0
[10199.924413]  nvme_map_data+0x304/0x370
[10199.924415]  nvme_prep_rq.part.0+0x31/0x120
[10199.924417]  nvme_queue_rq+0x77/0x1f0

...
[ 9639.596311] NMI backtrace for cpu 48
[ 9639.596336] Call Trace:
[ 9639.596337]
[ 9639.596338] _raw_spin_lock_irqsave+0x37/0x40
[ 9639.596341] swiotlb_do_find_slots+0xef/0x3e0
[ 9639.596344] swiotlb_tbl_map_single+0xec/0x1f0
[ 9639.596347] swiotlb_map+0x5c/0x260
[ 9639.596349] dma_direct_map_sg+0x7a/0x280
[ 9639.596352] __dma_map_sg_attrs+0x30/0x70
[ 9639.596355] dma_map_sgtable+0x1d/0x30
[ 9639.596356] nvme_map_data+0xce/0x370

...
[ 9639.595665] NMI backtrace for cpu 50
[ 9639.595682] Call Trace:
[ 9639.595682]
[ 9639.595683] _raw_spin_lock_irqsave+0x37/0x40
[ 9639.595686] swiotlb_release_slots.isra.0+0x86/0x180
[ 9639.595688] dma_direct_unmap_sg+0xcf/0x1a0
[ 9639.595690] nvme_unmap_data.part.0+0x43/0xc0

Fixes: 1f221a0d0dbf ("swiotlb: respect min_align_mask")
Signed-off-by: GuoRui.Yu <GuoRui.Yu@linux.alibaba.com>
Signed-off-by: Xiaokang Hu <xiaokang.hxk@alibaba-inc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/swiotlb.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 339a990554e7f..1ecd0d1f7231a 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -617,8 +617,8 @@ static int swiotlb_do_find_slots(struct device *dev, int area_index,
 	unsigned int iotlb_align_mask =
 		dma_get_min_align_mask(dev) & ~(IO_TLB_SIZE - 1);
 	unsigned int nslots = nr_slots(alloc_size), stride;
-	unsigned int index, wrap, count = 0, i;
 	unsigned int offset = swiotlb_align_offset(dev, orig_addr);
+	unsigned int index, slots_checked, count = 0, i;
 	unsigned long flags;
 	unsigned int slot_base;
 	unsigned int slot_index;
@@ -641,15 +641,16 @@ static int swiotlb_do_find_slots(struct device *dev, int area_index,
 		goto not_found;
 
 	slot_base = area_index * mem->area_nslabs;
-	index = wrap = wrap_area_index(mem, ALIGN(area->index, stride));
+	index = wrap_area_index(mem, ALIGN(area->index, stride));
 
-	do {
+	for (slots_checked = 0; slots_checked < mem->area_nslabs; ) {
 		slot_index = slot_base + index;
 
 		if (orig_addr &&
 		    (slot_addr(tbl_dma_addr, slot_index) &
 		     iotlb_align_mask) != (orig_addr & iotlb_align_mask)) {
 			index = wrap_area_index(mem, index + 1);
+			slots_checked++;
 			continue;
 		}
 
@@ -665,7 +666,8 @@ static int swiotlb_do_find_slots(struct device *dev, int area_index,
 				goto found;
 		}
 		index = wrap_area_index(mem, index + stride);
-	} while (index != wrap);
+		slots_checked += stride;
+	}
 
 not_found:
 	spin_unlock_irqrestore(&area->lock, flags);
-- 
2.39.2



