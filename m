Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40A203B5AC2
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 10:58:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231698AbhF1JAb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 05:00:31 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:48711 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230256AbhF1JA3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Jun 2021 05:00:29 -0400
Received: from epcas3p2.samsung.com (unknown [182.195.41.20])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210628085802epoutp049ff1c80ce69ad1c90876ef0555212fe9~Ms0bunOJ91606216062epoutp047
        for <stable@vger.kernel.org>; Mon, 28 Jun 2021 08:58:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210628085802epoutp049ff1c80ce69ad1c90876ef0555212fe9~Ms0bunOJ91606216062epoutp047
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1624870682;
        bh=bCN4eBh6FB3KwbBdcmUAMw2xJOLoC5gC7ShigegBltI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K6eYIfeG5JI3eDSs6QOvdtXD10nNwjOKNCquIu8wrSFCIk75p81Ida4b/WsCsAved
         9OkpbHhKE7nhCB8w5vEHAEaSjmjZUPhBUA/5o0OInU7p9QY8neCaT851gapbPWIoZB
         mlU4R5Iieb51hQ2nFs9sUKFbLIpTgCx+vxb+WjTg=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas3p2.samsung.com (KnoxPortal) with ESMTP id
        20210628085802epcas3p28497138ef6af0cbeb58ffd2020255ac0~Ms0bRXg-j1336013360epcas3p2j;
        Mon, 28 Jun 2021 08:58:02 +0000 (GMT)
Received: from epcpadp4 (unknown [182.195.40.18]) by epsnrtp1.localdomain
        (Postfix) with ESMTP id 4GD1j61BVfz4x9Q2; Mon, 28 Jun 2021 08:58:02 +0000
        (GMT)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20210628065823epcas2p19305f8b888a7fc0e883ec51db61e3bae~MrL9cXK3r0284702847epcas2p15;
        Mon, 28 Jun 2021 06:58:23 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210628065823epsmtrp277064e27d81d28d0dfdc87dccafbdb54~MrL9bn7gR2657726577epsmtrp2W;
        Mon, 28 Jun 2021 06:58:23 +0000 (GMT)
X-AuditID: b6c32a29-5f1ff700000020ca-d6-60d9730f506f
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        3F.46.08394.F0379D06; Mon, 28 Jun 2021 15:58:23 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210628065823epsmtip21b00e496ad9054d8598dede5e54ee5cd~MrL9O-OwX2748927489epsmtip2J;
        Mon, 28 Jun 2021 06:58:23 +0000 (GMT)
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
Date:   Mon, 28 Jun 2021 15:59:16 +0900
Message-Id: <513700442.21624870682149.JavaMail.epsvc@epcpadp4>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <16246131632380@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLLMWRmVeSWpSXmKPExsWy7bCSvC5/8c0Eg2WrxS32nrawuLxf2+Ll
        IU2L1QecLJoXr2ezWLn6KJPFh/OHmSyWLX7KaLFg4yNGB06PzubFTB77565h99h9s4HNY+O7
        HUweH5/eYvHo27KK0ePzJrkA9igum5TUnMyy1CJ9uwSujCtnXjAWPFKumL9tJ3MDY6tMFyMn
        h4SAicSpCdfYQGwhgd2MErMOS0HEZSWevdvBDmELS9xvOcLaxcgFVPOeUWLlkT4WkASbgK7E
        luevGEFsEQE5iSe3/zCDFDEL7GSS+N96hxUkISzgLnH27iewIhYBVYnfP7aBNfMK2Em0X7nO
        CrFBXuLUsoNMIDangLpE/7ZeRoiL1CQ+zV3GCFEvKHFy5hOgXg6gBeoS6+cJgYSZgVqbt85m
        nsAoOAtJ1SyEqllIqhYwMq9ilEwtKM5Nzy02LDDMSy3XK07MLS7NS9dLzs/dxAiOES3NHYzb
        V33QO8TIxMF4iFGCg1lJhFes6lqCEG9KYmVValF+fFFpTmrxIUZpDhYlcd4LXSfjhQTSE0tS
        s1NTC1KLYLJMHJxSDUyJy45nLFoxy4qLMUBA+nVs2kOlbfGpdeXn30wIjdrfafqnivFl5qKW
        QF7OiGtMm57aTo41fS0jdHaN8AP+13UJ3/1Yqp4Ht+au5Hi2qDX7eXHjQ+ccc1l5XTV/+zWZ
        rkpr1vy8XXLof970rnlCZQf0NmalXWDdI3MxfWmNToGMd9+yV4q98ufllG8Erci4kGL/X2rF
        /IAf/ZErJywu/OjX/4Q/SN921VzRco6WpZUcp1JvKTGv25ot1qRQIXn7t/ZU/6r1BTb56vNW
        m+1q6mzy3rg8b+pPt1WdF+atDfv5T+qMwqFJnLd3cAkvnz+V7fFzlW0W4hHmyWtXTbfb8KXQ
        OiHyn5nB19eByzi/yCixFGckGmoxFxUnAgCWwR9RAAMAAA==
X-CMS-MailID: 20210628065823epcas2p19305f8b888a7fc0e883ec51db61e3bae
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20210628065823epcas2p19305f8b888a7fc0e883ec51db61e3bae
References: <16246131632380@kroah.com>
        <CGME20210628065823epcas2p19305f8b888a7fc0e883ec51db61e3bae@epcas2p1.samsung.com>
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
 kernel/dma/swiotlb.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index fe4c01c14ab2..e96f3808e431 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -724,11 +724,17 @@ void swiotlb_tbl_sync_single(struct device *hwdev, phys_addr_t tlb_addr,
 	int index = (tlb_addr - io_tlb_start) >> IO_TLB_SHIFT;
 	size_t orig_size = io_tlb_orig_size[index];
 	phys_addr_t orig_addr = io_tlb_orig_addr[index];
+	unsigned int tlb_offset;
 
 	if (orig_addr == INVALID_PHYS_ADDR)
 		return;
 
-	validate_sync_size_and_truncate(hwdev, orig_size, &size);
+	tlb_offset = (tlb_addr & (IO_TLB_SIZE - 1)) -
+		     swiotlb_align_offset(hwdev, orig_addr);
+
+	orig_addr += tlb_offset;
+
+	validate_sync_size_and_truncate(hwdev, orig_size - tlb_offset, &size);
 
 	switch (target) {
 	case SYNC_FOR_CPU:
-- 
2.32.0


