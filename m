Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA6381C0A
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729787AbfHENTn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:19:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:55844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728680AbfHENTm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:19:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B01C2147A;
        Mon,  5 Aug 2019 13:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565011181;
        bh=tOO9qAJGqeSgn0fiOnpdtzq6ceY9M1FHtQOBWcqz8tY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Powwxj9xFk78R5sC625F7KeoUAFmELakmbqeRxXHLwxHfzEh5+P0PLUcGZv1wAHpC
         NIq1vNaDJJzbXoghpqgfMp89mEvzzRdajOBjV8f2jCKn/dCD1FUnFbrFescT9FagNH
         CBD9ByLXpiZyrzORH8FHa28V3qbos4Mts4BFlsuo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Suganath Prabu <suganath-prabu.subramani@broadcom.com>,
        Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.19 74/74] scsi: mpt3sas: Use 63-bit DMA addressing on SAS35 HBA
Date:   Mon,  5 Aug 2019 15:03:27 +0200
Message-Id: <20190805124941.760727197@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124935.819068648@linuxfoundation.org>
References: <20190805124935.819068648@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suganath Prabu <suganath-prabu.subramani@broadcom.com>

commit df9a606184bfdb5ae3ca9d226184e9489f5c24f7 upstream.

Although SAS3 & SAS3.5 IT HBA controllers support 64-bit DMA addressing, as
per hardware design, if DMA-able range contains all 64-bits
set (0xFFFFFFFF-FFFFFFFF) then it results in a firmware fault.

E.g. SGE's start address is 0xFFFFFFFF-FFFF000 and data length is 0x1000
bytes. when HBA tries to DMA the data at 0xFFFFFFFF-FFFFFFFF location then
HBA will fault the firmware.

Driver will set 63-bit DMA mask to ensure the above address will not be
used.

Cc: <stable@vger.kernel.org> # 4.19.63
Signed-off-by: Suganath Prabu <suganath-prabu.subramani@broadcom.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/mpt3sas/mpt3sas_base.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -2565,12 +2565,14 @@ _base_config_dma_addressing(struct MPT3S
 {
 	struct sysinfo s;
 	u64 consistent_dma_mask;
+	/* Set 63 bit DMA mask for all SAS3 and SAS35 controllers */
+	int dma_mask = (ioc->hba_mpi_version_belonged > MPI2_VERSION) ? 63 : 64;
 
 	if (ioc->is_mcpu_endpoint)
 		goto try_32bit;
 
 	if (ioc->dma_mask)
-		consistent_dma_mask = DMA_BIT_MASK(64);
+		consistent_dma_mask = DMA_BIT_MASK(dma_mask);
 	else
 		consistent_dma_mask = DMA_BIT_MASK(32);
 
@@ -2578,11 +2580,11 @@ _base_config_dma_addressing(struct MPT3S
 		const uint64_t required_mask =
 		    dma_get_required_mask(&pdev->dev);
 		if ((required_mask > DMA_BIT_MASK(32)) &&
-		    !pci_set_dma_mask(pdev, DMA_BIT_MASK(64)) &&
+		    !pci_set_dma_mask(pdev, DMA_BIT_MASK(dma_mask)) &&
 		    !pci_set_consistent_dma_mask(pdev, consistent_dma_mask)) {
 			ioc->base_add_sg_single = &_base_add_sg_single_64;
 			ioc->sge_size = sizeof(Mpi2SGESimple64_t);
-			ioc->dma_mask = 64;
+			ioc->dma_mask = dma_mask;
 			goto out;
 		}
 	}
@@ -2609,7 +2611,7 @@ static int
 _base_change_consistent_dma_mask(struct MPT3SAS_ADAPTER *ioc,
 				      struct pci_dev *pdev)
 {
-	if (pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64))) {
+	if (pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(ioc->dma_mask))) {
 		if (pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32)))
 			return -ENODEV;
 	}
@@ -4545,7 +4547,7 @@ _base_allocate_memory_pools(struct MPT3S
 		total_sz += sz;
 	} while (ioc->rdpq_array_enable && (++i < ioc->reply_queue_count));
 
-	if (ioc->dma_mask == 64) {
+	if (ioc->dma_mask > 32) {
 		if (_base_change_consistent_dma_mask(ioc, ioc->pdev) != 0) {
 			pr_warn(MPT3SAS_FMT
 			    "no suitable consistent DMA mask for %s\n",


