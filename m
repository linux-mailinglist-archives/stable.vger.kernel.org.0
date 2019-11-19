Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01475101907
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:12:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727630AbfKSFWE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:22:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:37228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727601AbfKSFWD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:22:03 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56BB622350;
        Tue, 19 Nov 2019 05:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574140922;
        bh=unrCBv+zh/EQ25IBVWT7snwDakuCW+7gLU2XN3eDJsc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kmdaCp5L6MTzXhzMnckyFziJsLPLCrogf/EhHNINPj9qBQzGBHRtRYzsTeF2itUi7
         FpcQXWbrP4Nx6Mg+g0+t9wk1vw7spNHBhs/3RUdshIcJP/JcqW3AHUJa82H9CO/Sys
         FQNhc7ndJb4o66Ej234UgLCIM5Hyn3K30xINIxz8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Kaike Wan <kaike.wan@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Doug Ledford <dledford@redhat.com>
Subject: [PATCH 5.3 31/48] IB/hfi1: Use a common pad buffer for 9B and 16B packets
Date:   Tue, 19 Nov 2019 06:19:51 +0100
Message-Id: <20191119051011.938432841@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119050946.745015350@linuxfoundation.org>
References: <20191119050946.745015350@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn@intel.com>

commit 22bb13653410424d9fce8d447506a41f8292f22f upstream.

There is no reason for a different pad buffer for the two
packet types.

Expand the current buffer allocation to allow for both
packet types.

Fixes: f8195f3b14a0 ("IB/hfi1: Eliminate allocation while atomic")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Kaike Wan <kaike.wan@intel.com>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Link: https://lore.kernel.org/r/20191004204934.26838.13099.stgit@awfm-01.aw.intel.com
Signed-off-by: Doug Ledford <dledford@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/hfi1/sdma.c  |    5 +++--
 drivers/infiniband/hw/hfi1/verbs.c |   10 ++++------
 2 files changed, 7 insertions(+), 8 deletions(-)

--- a/drivers/infiniband/hw/hfi1/sdma.c
+++ b/drivers/infiniband/hw/hfi1/sdma.c
@@ -65,6 +65,7 @@
 #define SDMA_DESCQ_CNT 2048
 #define SDMA_DESC_INTR 64
 #define INVALID_TAIL 0xffff
+#define SDMA_PAD max_t(size_t, MAX_16B_PADDING, sizeof(u32))
 
 static uint sdma_descq_cnt = SDMA_DESCQ_CNT;
 module_param(sdma_descq_cnt, uint, S_IRUGO);
@@ -1296,7 +1297,7 @@ void sdma_clean(struct hfi1_devdata *dd,
 	struct sdma_engine *sde;
 
 	if (dd->sdma_pad_dma) {
-		dma_free_coherent(&dd->pcidev->dev, 4,
+		dma_free_coherent(&dd->pcidev->dev, SDMA_PAD,
 				  (void *)dd->sdma_pad_dma,
 				  dd->sdma_pad_phys);
 		dd->sdma_pad_dma = NULL;
@@ -1491,7 +1492,7 @@ int sdma_init(struct hfi1_devdata *dd, u
 	}
 
 	/* Allocate memory for pad */
-	dd->sdma_pad_dma = dma_alloc_coherent(&dd->pcidev->dev, sizeof(u32),
+	dd->sdma_pad_dma = dma_alloc_coherent(&dd->pcidev->dev, SDMA_PAD,
 					      &dd->sdma_pad_phys, GFP_KERNEL);
 	if (!dd->sdma_pad_dma) {
 		dd_dev_err(dd, "failed to allocate SendDMA pad memory\n");
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -147,9 +147,6 @@ static int pio_wait(struct rvt_qp *qp,
 /* Length of buffer to create verbs txreq cache name */
 #define TXREQ_NAME_LEN 24
 
-/* 16B trailing buffer */
-static const u8 trail_buf[MAX_16B_PADDING];
-
 static uint wss_threshold = 80;
 module_param(wss_threshold, uint, S_IRUGO);
 MODULE_PARM_DESC(wss_threshold, "Percentage (1-100) of LLC to use as a threshold for a cacheless copy");
@@ -820,8 +817,8 @@ static int build_verbs_tx_desc(
 
 	/* add icrc, lt byte, and padding to flit */
 	if (extra_bytes)
-		ret = sdma_txadd_kvaddr(sde->dd, &tx->txreq,
-					(void *)trail_buf, extra_bytes);
+		ret = sdma_txadd_daddr(sde->dd, &tx->txreq,
+				       sde->dd->sdma_pad_phys, extra_bytes);
 
 bail_txadd:
 	return ret;
@@ -1089,7 +1086,8 @@ int hfi1_verbs_send_pio(struct rvt_qp *q
 		}
 		/* add icrc, lt byte, and padding to flit */
 		if (extra_bytes)
-			seg_pio_copy_mid(pbuf, trail_buf, extra_bytes);
+			seg_pio_copy_mid(pbuf, ppd->dd->sdma_pad_dma,
+					 extra_bytes);
 
 		seg_pio_copy_end(pbuf);
 	}


