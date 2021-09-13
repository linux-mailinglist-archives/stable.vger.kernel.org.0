Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18495408E7F
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241440AbhIMNfj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:35:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:46964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242481AbhIMN3f (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:29:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7ABD6128B;
        Mon, 13 Sep 2021 13:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539445;
        bh=bF2GIdUb07CWPyAMRv26r5PYGGFNnErox+Z3MFI8mhU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1F2o0DYXxSQZ9l14AuPsrqhMbQVzwtyQMdVkePzXKIoMmiO3FhImGcHNiRAgv3Vxr
         PMR4vNAeYytZR9RJKG+dB9Tw8XDrBSlefTEEu4vNpDX2nJVqZ+xIMdy9HfL7BDPAI7
         bT0zkFXuqto4JLZzbWiVa0jZG7bHMHmCM2GiG5cQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Anderson <sean.anderson@seco.com>,
        Richard Weinberger <richard@nod.at>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 004/236] crypto: mxs-dcp - Check for DMA mapping errors
Date:   Mon, 13 Sep 2021 15:11:49 +0200
Message-Id: <20210913131100.468220535@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Anderson <sean.anderson@seco.com>

[ Upstream commit df6313d707e575a679ada3313358289af24454c0 ]

After calling dma_map_single(), we must also call dma_mapping_error().
This fixes the following warning when compiling with CONFIG_DMA_API_DEBUG:

[  311.241478] WARNING: CPU: 0 PID: 428 at kernel/dma/debug.c:1027 check_unmap+0x79c/0x96c
[  311.249547] DMA-API: mxs-dcp 2280000.crypto: device driver failed to check map error[device address=0x00000000860cb080] [size=32 bytes] [mapped as single]

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
Reviewed-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/mxs-dcp.c | 45 +++++++++++++++++++++++++++++++---------
 1 file changed, 35 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
index 909a7eb748e3..7daed8b78ac8 100644
--- a/drivers/crypto/mxs-dcp.c
+++ b/drivers/crypto/mxs-dcp.c
@@ -169,15 +169,19 @@ static struct dcp *global_sdcp;
 
 static int mxs_dcp_start_dma(struct dcp_async_ctx *actx)
 {
+	int dma_err;
 	struct dcp *sdcp = global_sdcp;
 	const int chan = actx->chan;
 	uint32_t stat;
 	unsigned long ret;
 	struct dcp_dma_desc *desc = &sdcp->coh->desc[actx->chan];
-
 	dma_addr_t desc_phys = dma_map_single(sdcp->dev, desc, sizeof(*desc),
 					      DMA_TO_DEVICE);
 
+	dma_err = dma_mapping_error(sdcp->dev, desc_phys);
+	if (dma_err)
+		return dma_err;
+
 	reinit_completion(&sdcp->completion[chan]);
 
 	/* Clear status register. */
@@ -215,18 +219,29 @@ static int mxs_dcp_start_dma(struct dcp_async_ctx *actx)
 static int mxs_dcp_run_aes(struct dcp_async_ctx *actx,
 			   struct skcipher_request *req, int init)
 {
+	dma_addr_t key_phys, src_phys, dst_phys;
 	struct dcp *sdcp = global_sdcp;
 	struct dcp_dma_desc *desc = &sdcp->coh->desc[actx->chan];
 	struct dcp_aes_req_ctx *rctx = skcipher_request_ctx(req);
 	int ret;
 
-	dma_addr_t key_phys = dma_map_single(sdcp->dev, sdcp->coh->aes_key,
-					     2 * AES_KEYSIZE_128,
-					     DMA_TO_DEVICE);
-	dma_addr_t src_phys = dma_map_single(sdcp->dev, sdcp->coh->aes_in_buf,
-					     DCP_BUF_SZ, DMA_TO_DEVICE);
-	dma_addr_t dst_phys = dma_map_single(sdcp->dev, sdcp->coh->aes_out_buf,
-					     DCP_BUF_SZ, DMA_FROM_DEVICE);
+	key_phys = dma_map_single(sdcp->dev, sdcp->coh->aes_key,
+				  2 * AES_KEYSIZE_128, DMA_TO_DEVICE);
+	ret = dma_mapping_error(sdcp->dev, key_phys);
+	if (ret)
+		return ret;
+
+	src_phys = dma_map_single(sdcp->dev, sdcp->coh->aes_in_buf,
+				  DCP_BUF_SZ, DMA_TO_DEVICE);
+	ret = dma_mapping_error(sdcp->dev, src_phys);
+	if (ret)
+		goto err_src;
+
+	dst_phys = dma_map_single(sdcp->dev, sdcp->coh->aes_out_buf,
+				  DCP_BUF_SZ, DMA_FROM_DEVICE);
+	ret = dma_mapping_error(sdcp->dev, dst_phys);
+	if (ret)
+		goto err_dst;
 
 	if (actx->fill % AES_BLOCK_SIZE) {
 		dev_err(sdcp->dev, "Invalid block size!\n");
@@ -264,10 +279,12 @@ static int mxs_dcp_run_aes(struct dcp_async_ctx *actx,
 	ret = mxs_dcp_start_dma(actx);
 
 aes_done_run:
+	dma_unmap_single(sdcp->dev, dst_phys, DCP_BUF_SZ, DMA_FROM_DEVICE);
+err_dst:
+	dma_unmap_single(sdcp->dev, src_phys, DCP_BUF_SZ, DMA_TO_DEVICE);
+err_src:
 	dma_unmap_single(sdcp->dev, key_phys, 2 * AES_KEYSIZE_128,
 			 DMA_TO_DEVICE);
-	dma_unmap_single(sdcp->dev, src_phys, DCP_BUF_SZ, DMA_TO_DEVICE);
-	dma_unmap_single(sdcp->dev, dst_phys, DCP_BUF_SZ, DMA_FROM_DEVICE);
 
 	return ret;
 }
@@ -556,6 +573,10 @@ static int mxs_dcp_run_sha(struct ahash_request *req)
 	dma_addr_t buf_phys = dma_map_single(sdcp->dev, sdcp->coh->sha_in_buf,
 					     DCP_BUF_SZ, DMA_TO_DEVICE);
 
+	ret = dma_mapping_error(sdcp->dev, buf_phys);
+	if (ret)
+		return ret;
+
 	/* Fill in the DMA descriptor. */
 	desc->control0 = MXS_DCP_CONTROL0_DECR_SEMAPHORE |
 		    MXS_DCP_CONTROL0_INTERRUPT |
@@ -588,6 +609,10 @@ static int mxs_dcp_run_sha(struct ahash_request *req)
 	if (rctx->fini) {
 		digest_phys = dma_map_single(sdcp->dev, sdcp->coh->sha_out_buf,
 					     DCP_SHA_PAY_SZ, DMA_FROM_DEVICE);
+		ret = dma_mapping_error(sdcp->dev, digest_phys);
+		if (ret)
+			goto done_run;
+
 		desc->control0 |= MXS_DCP_CONTROL0_HASH_TERM;
 		desc->payload = digest_phys;
 	}
-- 
2.30.2



