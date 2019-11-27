Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A6F610B8CE
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 21:48:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728005AbfK0UrC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:47:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:59382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729945AbfK0Uq6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:46:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C01082182A;
        Wed, 27 Nov 2019 20:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887617;
        bh=QcODrW0g2h0eVNaS81B9LTAQCEmFSlUp4VTfBNQ8rU8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x3N69S6+wL02fwYnvhaP9W2vJgE/R9c4FCm1gABNXY7krMCV2/uXOY9xhF1gFJAyd
         UTCH2UU/RnFnM3JCV6CC/pYlVUzhqawDOB5LbuSR3YZttlRHhZWI4LWx4xJwJmTqi+
         p6BbqJjPOx3LG6i/rC7kz3yPn22lQBv/t528L5fQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Carl Huang <cjhuang@codeaurora.org>,
        Brian Norris <briannorris@chomium.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 028/211] ath10k: allocate small size dma memory in ath10k_pci_diag_write_mem
Date:   Wed, 27 Nov 2019 21:29:21 +0100
Message-Id: <20191127203053.892519794@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203049.431810767@linuxfoundation.org>
References: <20191127203049.431810767@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Carl Huang <cjhuang@codeaurora.org>

[ Upstream commit 0738b4998c6d1caf9ca2447b946709a7278c70f1 ]

ath10k_pci_diag_write_mem may allocate big size of the dma memory
based on the parameter nbytes. Take firmware diag download as
example, the biggest size is about 500K. In some systems, the
allocation is likely to fail because it can't acquire such a large
contiguous dma memory.

The fix is to allocate a small size dma memory. In the loop,
driver copies the data to the allocated dma memory and writes to
the destination until all the data is written.

Tested with QCA6174 PCI with
firmware-6.bin_WLAN.RM.4.4.1-00119-QCARMSWP-1, this also affects
QCA9377 PCI.

Signed-off-by: Carl Huang <cjhuang@codeaurora.org>
Reviewed-by: Brian Norris <briannorris@chomium.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/pci.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 27ab3eb47534f..0298ddc1ff060 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1039,10 +1039,9 @@ int ath10k_pci_diag_write_mem(struct ath10k *ar, u32 address,
 	struct ath10k_ce *ce = ath10k_ce_priv(ar);
 	int ret = 0;
 	u32 *buf;
-	unsigned int completed_nbytes, orig_nbytes, remaining_bytes;
+	unsigned int completed_nbytes, alloc_nbytes, remaining_bytes;
 	struct ath10k_ce_pipe *ce_diag;
 	void *data_buf = NULL;
-	u32 ce_data;	/* Host buffer address in CE space */
 	dma_addr_t ce_data_base = 0;
 	int i;
 
@@ -1056,9 +1055,10 @@ int ath10k_pci_diag_write_mem(struct ath10k *ar, u32 address,
 	 *   1) 4-byte alignment
 	 *   2) Buffer in DMA-able space
 	 */
-	orig_nbytes = nbytes;
+	alloc_nbytes = min_t(unsigned int, nbytes, DIAG_TRANSFER_LIMIT);
+
 	data_buf = (unsigned char *)dma_alloc_coherent(ar->dev,
-						       orig_nbytes,
+						       alloc_nbytes,
 						       &ce_data_base,
 						       GFP_ATOMIC);
 	if (!data_buf) {
@@ -1066,9 +1066,6 @@ int ath10k_pci_diag_write_mem(struct ath10k *ar, u32 address,
 		goto done;
 	}
 
-	/* Copy caller's data to allocated DMA buf */
-	memcpy(data_buf, data, orig_nbytes);
-
 	/*
 	 * The address supplied by the caller is in the
 	 * Target CPU virtual address space.
@@ -1081,12 +1078,14 @@ int ath10k_pci_diag_write_mem(struct ath10k *ar, u32 address,
 	 */
 	address = ath10k_pci_targ_cpu_to_ce_addr(ar, address);
 
-	remaining_bytes = orig_nbytes;
-	ce_data = ce_data_base;
+	remaining_bytes = nbytes;
 	while (remaining_bytes) {
 		/* FIXME: check cast */
 		nbytes = min_t(int, remaining_bytes, DIAG_TRANSFER_LIMIT);
 
+		/* Copy caller's data to allocated DMA buf */
+		memcpy(data_buf, data, nbytes);
+
 		/* Set up to receive directly into Target(!) address */
 		ret = __ath10k_ce_rx_post_buf(ce_diag, &address, address);
 		if (ret != 0)
@@ -1096,7 +1095,7 @@ int ath10k_pci_diag_write_mem(struct ath10k *ar, u32 address,
 		 * Request CE to send caller-supplied data that
 		 * was copied to bounce buffer to Target(!) address.
 		 */
-		ret = ath10k_ce_send_nolock(ce_diag, NULL, (u32)ce_data,
+		ret = ath10k_ce_send_nolock(ce_diag, NULL, ce_data_base,
 					    nbytes, 0, 0);
 		if (ret != 0)
 			goto done;
@@ -1137,12 +1136,12 @@ int ath10k_pci_diag_write_mem(struct ath10k *ar, u32 address,
 
 		remaining_bytes -= nbytes;
 		address += nbytes;
-		ce_data += nbytes;
+		data += nbytes;
 	}
 
 done:
 	if (data_buf) {
-		dma_free_coherent(ar->dev, orig_nbytes, data_buf,
+		dma_free_coherent(ar->dev, alloc_nbytes, data_buf,
 				  ce_data_base);
 	}
 
-- 
2.20.1



