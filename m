Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E052AB1F0D
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389667AbfIMNPS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:15:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:41476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389665AbfIMNPR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:15:17 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B196A206A5;
        Fri, 13 Sep 2019 13:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380516;
        bh=Rwe+DJHQQuxCWe7BLO66QXK4G6FkMsj4vn3etY4E/Y4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tv0TP/y6WcgQ8sKI0GehH8Y+7EK9HOepaMr1kSLNGX481JTDq3G0dMDhf4dQpBeXB
         ahnx/RRYiO1a8ZFFiH6dyaIc6HzClR4T9SL6ca2ZbQrrxL4VbQ6EsKSJD4FUmU5sfo
         euQRQaSmLCsHlBu8LJDce4Sgm8gKdfVpf1KO2kpU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 071/190] scsi: megaraid_sas: Use 63-bit DMA addressing
Date:   Fri, 13 Sep 2019 14:05:26 +0100
Message-Id: <20190913130605.302665299@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 894169db12463cea08d0e2a9e35f42b291340e5a ]

Although MegaRAID controllers support 64-bit DMA addressing, as per
hardware design, DMA address with all 64-bits set
(0xFFFFFFFF-FFFFFFFF) results in a firmware fault.

Driver will set 63-bit DMA mask to ensure the above address will not be
used.

Cc: stable@vger.kernel.org
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 749f10146f630..bc37666f998e6 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -6056,13 +6056,13 @@ static int megasas_io_attach(struct megasas_instance *instance)
  * @instance:		Adapter soft state
  * Description:
  *
- * For Ventura, driver/FW will operate in 64bit DMA addresses.
+ * For Ventura, driver/FW will operate in 63bit DMA addresses.
  *
  * For invader-
  *	By default, driver/FW will operate in 32bit DMA addresses
  *	for consistent DMA mapping but if 32 bit consistent
- *	DMA mask fails, driver will try with 64 bit consistent
- *	mask provided FW is true 64bit DMA capable
+ *	DMA mask fails, driver will try with 63 bit consistent
+ *	mask provided FW is true 63bit DMA capable
  *
  * For older controllers(Thunderbolt and MFI based adapters)-
  *	driver/FW will operate in 32 bit consistent DMA addresses.
@@ -6075,15 +6075,15 @@ megasas_set_dma_mask(struct megasas_instance *instance)
 	u32 scratch_pad_2;
 
 	pdev = instance->pdev;
-	consistent_mask = (instance->adapter_type == VENTURA_SERIES) ?
-				DMA_BIT_MASK(64) : DMA_BIT_MASK(32);
+	consistent_mask = (instance->adapter_type >= VENTURA_SERIES) ?
+				DMA_BIT_MASK(63) : DMA_BIT_MASK(32);
 
 	if (IS_DMA64) {
-		if (dma_set_mask(&pdev->dev, DMA_BIT_MASK(64)) &&
+		if (dma_set_mask(&pdev->dev, DMA_BIT_MASK(63)) &&
 		    dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32)))
 			goto fail_set_dma_mask;
 
-		if ((*pdev->dev.dma_mask == DMA_BIT_MASK(64)) &&
+		if ((*pdev->dev.dma_mask == DMA_BIT_MASK(63)) &&
 		    (dma_set_coherent_mask(&pdev->dev, consistent_mask) &&
 		     dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32)))) {
 			/*
@@ -6096,7 +6096,7 @@ megasas_set_dma_mask(struct megasas_instance *instance)
 			if (!(scratch_pad_2 & MR_CAN_HANDLE_64_BIT_DMA_OFFSET))
 				goto fail_set_dma_mask;
 			else if (dma_set_mask_and_coherent(&pdev->dev,
-							   DMA_BIT_MASK(64)))
+							   DMA_BIT_MASK(63)))
 				goto fail_set_dma_mask;
 		}
 	} else if (dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32)))
@@ -6108,8 +6108,8 @@ megasas_set_dma_mask(struct megasas_instance *instance)
 		instance->consistent_mask_64bit = true;
 
 	dev_info(&pdev->dev, "%s bit DMA mask and %s bit consistent mask\n",
-		 ((*pdev->dev.dma_mask == DMA_BIT_MASK(64)) ? "64" : "32"),
-		 (instance->consistent_mask_64bit ? "64" : "32"));
+		 ((*pdev->dev.dma_mask == DMA_BIT_MASK(64)) ? "63" : "32"),
+		 (instance->consistent_mask_64bit ? "63" : "32"));
 
 	return 0;
 
-- 
2.20.1



