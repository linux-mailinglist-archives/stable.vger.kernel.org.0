Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77D324061CD
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:42:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241243AbhIJAnw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:43:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:45838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232488AbhIJATe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:19:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93A88610A3;
        Fri, 10 Sep 2021 00:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233104;
        bh=ZNXd/V5oNf4rXgz79oD/2VxGRTsmiQ+9lAGE/6Vbktg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NJX1cNPZsqSn3Z7iA5e7NRwtsCrTjXFNVpU0M0/QYgdACdFlsTW2G60p1bPTM4zkX
         mog/OA9UPnlYCIdc0QZnGlsIyFEyBTtPeQQqTHRX6Xqcvq3ZX7gQMfnwf2D9SMeWcL
         QmNpAnKqfj3LB2DQnnjPLMLrqPqdUPHu/dWBUnawZt0B/4Qc16uzXik72ACb8Oh6KF
         Tt9ChuuDWhbflJFImLYNUK5hcdKBU5hRjKrAyuvc02Tq4nRZY9usqkrU+7fJwQIdn/
         W1GvoGkR8lDIha+s8zoCj4KzfBhMKmOH5j6AYf5dtof1faUM92BuSM3Jzs5JxZLiIS
         OdDGzVFjAzttQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dominique Martinet <dominique.martinet@atmark-techno.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Chanho Park <chanho61.park@samsung.com>,
        Christoph Hellwig <hch@lst.de>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.13 02/88] swiotlb: add overflow checks to swiotlb_bounce
Date:   Thu,  9 Sep 2021 20:16:54 -0400
Message-Id: <20210910001820.174272-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001820.174272-1-sashal@kernel.org>
References: <20210910001820.174272-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dominique Martinet <dominique.martinet@atmark-techno.com>

[ Upstream commit 868c9ddc182bc6728bb380cbfb3170734f72c599 ]

This is a follow-up on 5f89468e2f06 ("swiotlb: manipulate orig_addr
when tlb_addr has offset") which fixed unaligned dma mappings,
making sure the following overflows are caught:

- offset of the start of the slot within the device bigger than
requested address' offset, in other words if the base address
given in swiotlb_tbl_map_single to create the mapping (orig_addr)
was after the requested address for the sync (tlb_offset) in the
same block:

 |------------------------------------------| block
              <----------------------------> mapped part of the block
              ^
              orig_addr
       ^
       invalid tlb_addr for sync

- if the resulting offset was bigger than the allocation size
this one could happen if the mapping was not until the end. e.g.

 |------------------------------------------| block
      <---------------------> mapped part of the block
      ^                               ^
      orig_addr                       invalid tlb_addr

Both should never happen so print a warning and bail out without trying
to adjust the sizes/offsets: the first one could try to sync from
orig_addr to whatever is left of the requested size, but the later
really has nothing to sync there...

Signed-off-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Reviewed-by: Bumyong Lee <bumyong.lee@samsung.com
Cc: Chanho Park <chanho61.park@samsung.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Konrad Rzeszutek Wilk <konrad@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/swiotlb.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index e50df8d8f87e..23f8d0b168c5 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -354,13 +354,27 @@ static void swiotlb_bounce(struct device *dev, phys_addr_t tlb_addr, size_t size
 	size_t alloc_size = mem->slots[index].alloc_size;
 	unsigned long pfn = PFN_DOWN(orig_addr);
 	unsigned char *vaddr = phys_to_virt(tlb_addr);
-	unsigned int tlb_offset;
+	unsigned int tlb_offset, orig_addr_offset;
 
 	if (orig_addr == INVALID_PHYS_ADDR)
 		return;
 
-	tlb_offset = (tlb_addr & (IO_TLB_SIZE - 1)) -
-		     swiotlb_align_offset(dev, orig_addr);
+	tlb_offset = tlb_addr & (IO_TLB_SIZE - 1);
+	orig_addr_offset = swiotlb_align_offset(dev, orig_addr);
+	if (tlb_offset < orig_addr_offset) {
+		dev_WARN_ONCE(dev, 1,
+			"Access before mapping start detected. orig offset %u, requested offset %u.\n",
+			orig_addr_offset, tlb_offset);
+		return;
+	}
+
+	tlb_offset -= orig_addr_offset;
+	if (tlb_offset > alloc_size) {
+		dev_WARN_ONCE(dev, 1,
+			"Buffer overflow detected. Allocation size: %zu. Mapping size: %zu+%u.\n",
+			alloc_size, size, tlb_offset);
+		return;
+	}
 
 	orig_addr += tlb_offset;
 	alloc_size -= tlb_offset;
-- 
2.30.2

