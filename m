Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C13399CEE
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404198AbfHVRY3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:24:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:45978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404190AbfHVRY2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:24:28 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BED6A2341C;
        Thu, 22 Aug 2019 17:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494667;
        bh=Wsok8OsWznXqpVagTU4wYuVU5f0nXcDy7uQN6BLopQE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V8e13iI5yYV/K9vkOg9C14CpsAac35RtowwwzhlzsoYFph7mhdfhRb/dNMTXjdgax
         GSwVwcKxoug0qjO727am9uye8E2SBxOil77CKI9jHaVaXgpUHCFaK9yJIazlj9YHXm
         j3f2U481QC6eloyk39r1fwhApOzz0tR/PUoRmaHw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Suganath Prabu <suganath-prabu.subramani@broadcom.com>,
        Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.14 01/71] scsi: mpt3sas: Use 63-bit DMA addressing on SAS35 HBA
Date:   Thu, 22 Aug 2019 10:18:36 -0700
Message-Id: <20190822171726.193519670@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171726.131957995@linuxfoundation.org>
References: <20190822171726.131957995@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
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

Cc: <stable@vger.kernel.org> # 5.1.20+
Signed-off-by: Suganath Prabu <suganath-prabu.subramani@broadcom.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/scsi/mpt3sas/mpt3sas_base.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -1724,9 +1724,11 @@ _base_config_dma_addressing(struct MPT3S
 {
 	struct sysinfo s;
 	u64 consistent_dma_mask;
+	/* Set 63 bit DMA mask for all SAS3 and SAS35 controllers */
+	int dma_mask = (ioc->hba_mpi_version_belonged > MPI2_VERSION) ? 63 : 64;
 
 	if (ioc->dma_mask)
-		consistent_dma_mask = DMA_BIT_MASK(64);
+		consistent_dma_mask = DMA_BIT_MASK(dma_mask);
 	else
 		consistent_dma_mask = DMA_BIT_MASK(32);
 
@@ -1734,11 +1736,11 @@ _base_config_dma_addressing(struct MPT3S
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
@@ -1764,7 +1766,7 @@ static int
 _base_change_consistent_dma_mask(struct MPT3SAS_ADAPTER *ioc,
 				      struct pci_dev *pdev)
 {
-	if (pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64))) {
+	if (pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(ioc->dma_mask))) {
 		if (pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32)))
 			return -ENODEV;
 	}
@@ -3477,7 +3479,7 @@ _base_allocate_memory_pools(struct MPT3S
 		total_sz += sz;
 	} while (ioc->rdpq_array_enable && (++i < ioc->reply_queue_count));
 
-	if (ioc->dma_mask == 64) {
+	if (ioc->dma_mask > 32) {
 		if (_base_change_consistent_dma_mask(ioc, ioc->pdev) != 0) {
 			pr_warn(MPT3SAS_FMT
 			    "no suitable consistent DMA mask for %s\n",


