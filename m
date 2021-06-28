Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 382C93B616E
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234105AbhF1Of7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:35:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:36914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234510AbhF1Oct (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:32:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9EF3D61C86;
        Mon, 28 Jun 2021 14:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890468;
        bh=XRC9HX24Sq8a6Dyo2UVJU6YBkEjNTR9BpAFlZxa7Baw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jVhUNnVByZbqf/KVZhhmMv4060sct9s5RrabqxMGzfl+d+HuEz0sz8JhnIbZcZYW1
         zdu6s+Jbu3efyKnzQj32Zq/PB+Ud5EgktIwRQa//vPvgTCmAQTuAz5n0FDpXdnvoPY
         RAI6LndbUtN3ThVjM8rAR29z6yF5HpGKiPfe7lelpnoYTtly9M0zW4FdTeWjmWwMOb
         HRoEoHPspFZ1V1K0WE9thLbzJyqRodJtdjy4hwae4MfiCkLc0OQphhT/2QwXisWWTP
         UAJpIF+VU8ku1+8IgjMqIlXtf3YY2fSn45UPe4xS1hNWVfoJDMj/HWAR8T9N+8nDB4
         Kw5UsX06aWlvw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bumyong Lee <bumyong.lee@samsung.com>,
        Chanho Park <chanho61.park@samsung.com>,
        Christoph Hellwig <hch@lst.de>,
        Dominique MARTINET <dominique.martinet@atmark-techno.com>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.10 094/101] swiotlb: manipulate orig_addr when tlb_addr has offset
Date:   Mon, 28 Jun 2021 10:26:00 -0400
Message-Id: <20210628142607.32218-95-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628142607.32218-1-sashal@kernel.org>
References: <20210628142607.32218-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.47-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.47-rc1
X-KernelTest-Deadline: 2021-06-30T14:25+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bumyong Lee <bumyong.lee@samsung.com>

commit 5f89468e2f060031cd89fd4287298e0eaf246bf6 upstream.

in case of driver wants to sync part of ranges with offset,
swiotlb_tbl_sync_single() copies from orig_addr base to tlb_addr with
offset and ends up with data mismatch.

It was removed from
"swiotlb: don't modify orig_addr in swiotlb_tbl_sync_single",
but said logic has to be added back in.

From Linus's email:
"That commit which the removed the offset calculation entirely, because the old

        (unsigned long)tlb_addr & (IO_TLB_SIZE - 1)

was wrong, but instead of removing it, I think it should have just
fixed it to be

        (tlb_addr - mem->start) & (IO_TLB_SIZE - 1);

instead. That way the slot offset always matches the slot index calculation."

(Unfortunatly that broke NVMe).

The use-case that drivers are hitting is as follow:

1. Get dma_addr_t from dma_map_single()

dma_addr_t tlb_addr = dma_map_single(dev, vaddr, vsize, DMA_TO_DEVICE);

    |<---------------vsize------------->|
    +-----------------------------------+
    |                                   | original buffer
    +-----------------------------------+
  vaddr

 swiotlb_align_offset
     |<----->|<---------------vsize------------->|
     +-------+-----------------------------------+
     |       |                                   | swiotlb buffer
     +-------+-----------------------------------+
          tlb_addr

2. Do something
3. Sync dma_addr_t through dma_sync_single_for_device(..)

dma_sync_single_for_device(dev, tlb_addr + offset, size, DMA_TO_DEVICE);

  Error case.
    Copy data to original buffer but it is from base addr (instead of
  base addr + offset) in original buffer:

 swiotlb_align_offset
     |<----->|<- offset ->|<- size ->|
     +-------+-----------------------------------+
     |       |            |##########|           | swiotlb buffer
     +-------+-----------------------------------+
          tlb_addr

    |<- size ->|
    +-----------------------------------+
    |##########|                        | original buffer
    +-----------------------------------+
  vaddr

The fix is to copy the data to the original buffer and take into
account the offset, like so:

 swiotlb_align_offset
     |<----->|<- offset ->|<- size ->|
     +-------+-----------------------------------+
     |       |            |##########|           | swiotlb buffer
     +-------+-----------------------------------+
          tlb_addr

    |<- offset ->|<- size ->|
    +-----------------------------------+
    |            |##########|           | original buffer
    +-----------------------------------+
  vaddr

[One fix which was Linus's that made more sense to as it created a
symmetry would break NVMe. The reason for that is the:
 unsigned int offset = (tlb_addr - mem->start) & (IO_TLB_SIZE - 1);

would come up with the proper offset, but it would lose the
alignment (which this patch contains).]

Fixes: 16fc3cef33a0 ("swiotlb: don't modify orig_addr in swiotlb_tbl_sync_single")
Signed-off-by: Bumyong Lee <bumyong.lee@samsung.com>
Signed-off-by: Chanho Park <chanho61.park@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reported-by: Dominique MARTINET <dominique.martinet@atmark-techno.com>
Reported-by: Horia Geantă <horia.geanta@nxp.com>
Tested-by: Horia Geantă <horia.geanta@nxp.com>
CC: stable@vger.kernel.org
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/dma/swiotlb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 0f61b14b0099..0ed0e1f215c7 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -667,6 +667,9 @@ void swiotlb_tbl_sync_single(struct device *hwdev, phys_addr_t tlb_addr,
 	if (orig_addr == INVALID_PHYS_ADDR)
 		return;
 
+	orig_addr += (tlb_addr & (IO_TLB_SIZE - 1)) -
+		swiotlb_align_offset(hwdev, orig_addr);
+
 	switch (target) {
 	case SYNC_FOR_CPU:
 		if (likely(dir == DMA_FROM_DEVICE || dir == DMA_BIDIRECTIONAL))
-- 
2.30.2

