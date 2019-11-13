Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C11AFFA1F3
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:00:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730571AbfKMCAr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 21:00:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:56190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730566AbfKMCAq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 21:00:46 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB9D2222C9;
        Wed, 13 Nov 2019 02:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610445;
        bh=2J1mxRa+UGmjHyj449D+d+vcyB70N18KWkkpwLISlyE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qlKXqjvG1Tr0jwmLV+4Vg22t6gHxYLHONjF7LVI2eEDL6mJ6p8mR7pxqmsl9AXYxK
         gWUq+FlkpBPJO74VIvXt9B1qb0/oM8kzhz0Fk8MUL+wiYrLG+qmp5p5luhrXiDzRj1
         km9Mr3qXdmzgat/8V4ZpSNxO7/4SldXn+l/XXzo0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Radu Solea <radu.solea@nxp.com>,
        Leonard Crestez <leonard.crestez@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 42/68] crypto: mxs-dcp - Fix SHA null hashes and output length
Date:   Tue, 12 Nov 2019 20:59:06 -0500
Message-Id: <20191113015932.12655-42-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015932.12655-1-sashal@kernel.org>
References: <20191113015932.12655-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Radu Solea <radu.solea@nxp.com>

[ Upstream commit c709eebaf5c5faa8a0f140355f9cfe67e8f7afb1 ]

DCP writes at least 32 bytes in the output buffer instead of hash length
as documented. Add intermediate buffer to prevent write out of bounds.

When requested to produce null hashes DCP fails to produce valid output.
Add software workaround to bypass hardware and return valid output.

Signed-off-by: Radu Solea <radu.solea@nxp.com>
Signed-off-by: Leonard Crestez <leonard.crestez@nxp.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/mxs-dcp.c | 47 +++++++++++++++++++++++++++++++---------
 1 file changed, 37 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
index decaed448ebbb..7483adf120084 100644
--- a/drivers/crypto/mxs-dcp.c
+++ b/drivers/crypto/mxs-dcp.c
@@ -28,9 +28,24 @@
 
 #define DCP_MAX_CHANS	4
 #define DCP_BUF_SZ	PAGE_SIZE
+#define DCP_SHA_PAY_SZ  64
 
 #define DCP_ALIGNMENT	64
 
+/*
+ * Null hashes to align with hw behavior on imx6sl and ull
+ * these are flipped for consistency with hw output
+ */
+const uint8_t sha1_null_hash[] =
+	"\x09\x07\xd8\xaf\x90\x18\x60\x95\xef\xbf"
+	"\x55\x32\x0d\x4b\x6b\x5e\xee\xa3\x39\xda";
+
+const uint8_t sha256_null_hash[] =
+	"\x55\xb8\x52\x78\x1b\x99\x95\xa4"
+	"\x4c\x93\x9b\x64\xe4\x41\xae\x27"
+	"\x24\xb9\x6f\x99\xc8\xf4\xfb\x9a"
+	"\x14\x1c\xfc\x98\x42\xc4\xb0\xe3";
+
 /* DCP DMA descriptor. */
 struct dcp_dma_desc {
 	uint32_t	next_cmd_addr;
@@ -48,6 +63,7 @@ struct dcp_coherent_block {
 	uint8_t			aes_in_buf[DCP_BUF_SZ];
 	uint8_t			aes_out_buf[DCP_BUF_SZ];
 	uint8_t			sha_in_buf[DCP_BUF_SZ];
+	uint8_t			sha_out_buf[DCP_SHA_PAY_SZ];
 
 	uint8_t			aes_key[2 * AES_KEYSIZE_128];
 
@@ -513,8 +529,6 @@ static int mxs_dcp_run_sha(struct ahash_request *req)
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	struct dcp_async_ctx *actx = crypto_ahash_ctx(tfm);
 	struct dcp_sha_req_ctx *rctx = ahash_request_ctx(req);
-	struct hash_alg_common *halg = crypto_hash_alg_common(tfm);
-
 	struct dcp_dma_desc *desc = &sdcp->coh->desc[actx->chan];
 
 	dma_addr_t digest_phys = 0;
@@ -536,10 +550,23 @@ static int mxs_dcp_run_sha(struct ahash_request *req)
 	desc->payload = 0;
 	desc->status = 0;
 
+	/*
+	 * Align driver with hw behavior when generating null hashes
+	 */
+	if (rctx->init && rctx->fini && desc->size == 0) {
+		struct hash_alg_common *halg = crypto_hash_alg_common(tfm);
+		const uint8_t *sha_buf =
+			(actx->alg == MXS_DCP_CONTROL1_HASH_SELECT_SHA1) ?
+			sha1_null_hash : sha256_null_hash;
+		memcpy(sdcp->coh->sha_out_buf, sha_buf, halg->digestsize);
+		ret = 0;
+		goto done_run;
+	}
+
 	/* Set HASH_TERM bit for last transfer block. */
 	if (rctx->fini) {
-		digest_phys = dma_map_single(sdcp->dev, req->result,
-					     halg->digestsize, DMA_FROM_DEVICE);
+		digest_phys = dma_map_single(sdcp->dev, sdcp->coh->sha_out_buf,
+					     DCP_SHA_PAY_SZ, DMA_FROM_DEVICE);
 		desc->control0 |= MXS_DCP_CONTROL0_HASH_TERM;
 		desc->payload = digest_phys;
 	}
@@ -547,9 +574,10 @@ static int mxs_dcp_run_sha(struct ahash_request *req)
 	ret = mxs_dcp_start_dma(actx);
 
 	if (rctx->fini)
-		dma_unmap_single(sdcp->dev, digest_phys, halg->digestsize,
+		dma_unmap_single(sdcp->dev, digest_phys, DCP_SHA_PAY_SZ,
 				 DMA_FROM_DEVICE);
 
+done_run:
 	dma_unmap_single(sdcp->dev, buf_phys, DCP_BUF_SZ, DMA_TO_DEVICE);
 
 	return ret;
@@ -567,6 +595,7 @@ static int dcp_sha_req_to_buf(struct crypto_async_request *arq)
 	const int nents = sg_nents(req->src);
 
 	uint8_t *in_buf = sdcp->coh->sha_in_buf;
+	uint8_t *out_buf = sdcp->coh->sha_out_buf;
 
 	uint8_t *src_buf;
 
@@ -621,11 +650,9 @@ static int dcp_sha_req_to_buf(struct crypto_async_request *arq)
 
 		actx->fill = 0;
 
-		/* For some reason, the result is flipped. */
-		for (i = 0; i < halg->digestsize / 2; i++) {
-			swap(req->result[i],
-			     req->result[halg->digestsize - i - 1]);
-		}
+		/* For some reason the result is flipped */
+		for (i = 0; i < halg->digestsize; i++)
+			req->result[i] = out_buf[halg->digestsize - i - 1];
 	}
 
 	return 0;
-- 
2.20.1

