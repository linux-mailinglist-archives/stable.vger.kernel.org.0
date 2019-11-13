Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63057FA280
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:04:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728300AbfKMCEA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 21:04:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:58880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729839AbfKMCCW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 21:02:22 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8756204EC;
        Wed, 13 Nov 2019 02:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610541;
        bh=VG3DgUL0//crMwuAkysXJ4eawFrx3m9fdLNPZBJZAF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N91UGOFD7VTdHYL8nqbdjQWzKDJ/2fWqg8egCfjs/Bp36W7PTixnnNxF11M+8ba91
         pUEC7b4wEyr4LVPuEIYsiW6gC1xOkBSuJKTMltvrdFxTAx6lWWzH6j0EYxCup08xRe
         BQHJSbDw7D9UmkQOEGZBL3xtUJXA6xdyvNPGicFA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Radu Solea <radu.solea@nxp.com>,
        Franck LENORMAND <franck.lenormand@nxp.com>,
        Leonard Crestez <leonard.crestez@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 30/48] crypto: mxs-dcp - Fix AES issues
Date:   Tue, 12 Nov 2019 21:01:13 -0500
Message-Id: <20191113020131.13356-30-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113020131.13356-1-sashal@kernel.org>
References: <20191113020131.13356-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Radu Solea <radu.solea@nxp.com>

[ Upstream commit fadd7a6e616b89c7f4f7bfa7b824f290bab32c3c ]

The DCP driver does not obey cryptlen, when doing android CTS this
results in passing to hardware input stream lengths which are not
multiple of block size.

Add a check to prevent future erroneous stream lengths from reaching the
hardware and adjust the scatterlist walking code to obey cryptlen.

Also properly copy-out the IV for chaining.

Signed-off-by: Radu Solea <radu.solea@nxp.com>
Signed-off-by: Franck LENORMAND <franck.lenormand@nxp.com>
Signed-off-by: Leonard Crestez <leonard.crestez@nxp.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/mxs-dcp.c | 33 +++++++++++++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
index 38c5dd8891138..4b82cf9da0ba7 100644
--- a/drivers/crypto/mxs-dcp.c
+++ b/drivers/crypto/mxs-dcp.c
@@ -225,6 +225,12 @@ static int mxs_dcp_run_aes(struct dcp_async_ctx *actx,
 	dma_addr_t dst_phys = dma_map_single(sdcp->dev, sdcp->coh->aes_out_buf,
 					     DCP_BUF_SZ, DMA_FROM_DEVICE);
 
+	if (actx->fill % AES_BLOCK_SIZE) {
+		dev_err(sdcp->dev, "Invalid block size!\n");
+		ret = -EINVAL;
+		goto aes_done_run;
+	}
+
 	/* Fill in the DMA descriptor. */
 	desc->control0 = MXS_DCP_CONTROL0_DECR_SEMAPHORE |
 		    MXS_DCP_CONTROL0_INTERRUPT |
@@ -254,6 +260,7 @@ static int mxs_dcp_run_aes(struct dcp_async_ctx *actx,
 
 	ret = mxs_dcp_start_dma(actx);
 
+aes_done_run:
 	dma_unmap_single(sdcp->dev, key_phys, 2 * AES_KEYSIZE_128,
 			 DMA_TO_DEVICE);
 	dma_unmap_single(sdcp->dev, src_phys, DCP_BUF_SZ, DMA_TO_DEVICE);
@@ -280,13 +287,15 @@ static int mxs_dcp_aes_block_crypt(struct crypto_async_request *arq)
 
 	uint8_t *out_tmp, *src_buf, *dst_buf = NULL;
 	uint32_t dst_off = 0;
+	uint32_t last_out_len = 0;
 
 	uint8_t *key = sdcp->coh->aes_key;
 
 	int ret = 0;
 	int split = 0;
-	unsigned int i, len, clen, rem = 0;
+	unsigned int i, len, clen, rem = 0, tlen = 0;
 	int init = 0;
+	bool limit_hit = false;
 
 	actx->fill = 0;
 
@@ -305,6 +314,11 @@ static int mxs_dcp_aes_block_crypt(struct crypto_async_request *arq)
 	for_each_sg(req->src, src, nents, i) {
 		src_buf = sg_virt(src);
 		len = sg_dma_len(src);
+		tlen += len;
+		limit_hit = tlen > req->nbytes;
+
+		if (limit_hit)
+			len = req->nbytes - (tlen - len);
 
 		do {
 			if (actx->fill + len > out_off)
@@ -321,13 +335,15 @@ static int mxs_dcp_aes_block_crypt(struct crypto_async_request *arq)
 			 * If we filled the buffer or this is the last SG,
 			 * submit the buffer.
 			 */
-			if (actx->fill == out_off || sg_is_last(src)) {
+			if (actx->fill == out_off || sg_is_last(src) ||
+				limit_hit) {
 				ret = mxs_dcp_run_aes(actx, req, init);
 				if (ret)
 					return ret;
 				init = 0;
 
 				out_tmp = out_buf;
+				last_out_len = actx->fill;
 				while (dst && actx->fill) {
 					if (!split) {
 						dst_buf = sg_virt(dst);
@@ -350,6 +366,19 @@ static int mxs_dcp_aes_block_crypt(struct crypto_async_request *arq)
 				}
 			}
 		} while (len);
+
+		if (limit_hit)
+			break;
+	}
+
+	/* Copy the IV for CBC for chaining */
+	if (!rctx->ecb) {
+		if (rctx->enc)
+			memcpy(req->info, out_buf+(last_out_len-AES_BLOCK_SIZE),
+				AES_BLOCK_SIZE);
+		else
+			memcpy(req->info, in_buf+(last_out_len-AES_BLOCK_SIZE),
+				AES_BLOCK_SIZE);
 	}
 
 	return ret;
-- 
2.20.1

