Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6775D3B5AC1
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 10:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232430AbhF1JA3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 05:00:29 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:53903 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231698AbhF1JA3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Jun 2021 05:00:29 -0400
Received: from epcas3p4.samsung.com (unknown [182.195.41.22])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210628085802epoutp01b43d4ba0997e6ba436a58a265222c084~Ms0bH0-TU2500225002epoutp01L
        for <stable@vger.kernel.org>; Mon, 28 Jun 2021 08:58:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210628085802epoutp01b43d4ba0997e6ba436a58a265222c084~Ms0bH0-TU2500225002epoutp01L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1624870682;
        bh=VOchkg2yG85CPhvrJ5fQhVbHcHqNAu1/CG5ku1NXmB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A2p9jyw12ZJmyD0MKdfEwGA0gF3BOsnh7AKx/v698QqFWTu0Mlwp+/wat0SEDG9ZG
         a+WANi9gtmqOKlaCiOHJeKIapZW6CBamQUZZVkxtheS8VNkOffQyoin8aRBEQr4rSb
         yVRa55MR/AztAS3E/lBrP4QVGbDefarbgkAKS9p0=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas3p4.samsung.com (KnoxPortal) with ESMTP id
        20210628085801epcas3p40ffc187f5f0bbb319eef06523d35d853~Ms0a3W2ow2614926149epcas3p4O;
        Mon, 28 Jun 2021 08:58:01 +0000 (GMT)
Received: from epcpadp4 (unknown [182.195.40.18]) by epsnrtp2.localdomain
        (Postfix) with ESMTP id 4GD1j55vQ1z4x9Pv; Mon, 28 Jun 2021 08:58:01 +0000
        (GMT)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20210628065652epcas2p28f39187d9c1519cea42bd99a7e9dd75d~MrKomotF70030800308epcas2p2L;
        Mon, 28 Jun 2021 06:56:52 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210628065652epsmtrp2acec661caa0957efe3aa4858013edd3c~MrKolxRAy2610926109epsmtrp2C;
        Mon, 28 Jun 2021 06:56:52 +0000 (GMT)
X-AuditID: b6c32a29-5f1ff700000020ca-c0-60d972b4ee7e
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        BB.26.08394.4B279D06; Mon, 28 Jun 2021 15:56:52 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210628065651epsmtip25fb65a546e9d0aed668fd258af066d8c~MrKoQm6vV2734227342epsmtip2B;
        Mon, 28 Jun 2021 06:56:51 +0000 (GMT)
From:   Chanho Park <chanho61.park@samsung.com>
To:     gregkh@linuxfoundation.org
Cc:     Bumyong Lee <bumyong.lee@samsung.com>,
        Chanho Park <chanho61.park@samsung.com>,
        Christoph Hellwig <hch@lst.de>,
        Dominique MARTINET <dominique.martinet@atmark-techno.com>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        stable@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH] swiotlb: manipulate orig_addr when tlb_addr has offset
Date:   Mon, 28 Jun 2021 15:57:36 +0900
Message-Id: <1891546521.01624870681805.JavaMail.epsvc@epcpadp4>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <162461316120108@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHLMWRmVeSWpSXmKPExsWy7bCSvO6WopsJBt0T+Cz2nrawuLxf2+Ll
        IU2L1QecLJoXr2ezWLn6KJPFh/OHmSyWLX7KaLFg4yNGB06PzubFTB77565h99h9s4HNY+O7
        HUweH5/eYvHo27KK0ePzJrkA9igum5TUnMyy1CJ9uwSujOkrz7MVLFOsWPvmCFsD42/JLkZO
        DgkBE4n5P1azdTFycQgJ7GaU+DVvMRtEQlbi2bsd7BC2sMT9liOsEEXvGSWuHl7BBJJgE9CV
        2PL8FSOILSIgJ/Hk9h9mkCJmgZ1MEv9b77CCJIQF3CXO3v0EVsQioCrRtvYqmM0rYCcxuX0W
        M8QGeYlTyw6CDeUU0JC423OLBcQWElCX6Pvzgg2iXlDi5MwnQHEOoAXqEuvnCYGEmYFam7fO
        Zp7AKDgLSdUshKpZSKoWMDKvYpRMLSjOTc8tNiwwzEst1ytOzC0uzUvXS87P3cQIjhItzR2M
        21d90DvEyMTBeIhRgoNZSYRXrOpaghBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHeC10n44UE0hNL
        UrNTUwtSi2CyTBycUg1MFQs6lQ+7d8pMZYyrMJ+d//2j499jYkekzvDL1+jNKtov+Z43zGZK
        +dzpLpPW3ry6md8t3Pb1EjfrXXP5wycmzMpzqrl0Q7D7V+68FQ2/+55m5b053qiduaVXnPV6
        s43nuQtphv0cXxf7yp12W2+2/LpXncvMya15/ncc78948a90fYJ91+K7V9K1tVeXeNsoVSXG
        /zbeb7Byn66zecbKCfZ7srb2nHqsfur8i9U3Y4t0T8cF7BbyC50U/Z2N0VVPQX/zI0HjM+Yn
        Zy87tutZmNj6neW8orFFftfaW8Lrq1ONPm6fcerhWaWQEy3CK7LE/iiwODcXn5h4uHOi5myO
        1cuUb0R7ilnW3z/Gx5mmxFKckWioxVxUnAgAuAXU6AEDAAA=
X-CMS-MailID: 20210628065652epcas2p28f39187d9c1519cea42bd99a7e9dd75d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20210628065652epcas2p28f39187d9c1519cea42bd99a7e9dd75d
References: <162461316120108@kroah.com>
        <CGME20210628065652epcas2p28f39187d9c1519cea42bd99a7e9dd75d@epcas2p2.samsung.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bumyong Lee <bumyong.lee@samsung.com>

commit 5f89468e2f060031cd89fd4287298e0eaf246bf6 upstream.
(Backported as different form due to absence of below patch series
https://lore.kernel.org/linux-iommu/20210301074436.919889-1-hch@lst.de/)

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
2.32.0


