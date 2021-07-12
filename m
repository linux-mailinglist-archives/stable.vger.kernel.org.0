Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D50D53C5247
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:49:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345791AbhGLHpW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:45:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:51092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346549AbhGLHme (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:42:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 934DA61152;
        Mon, 12 Jul 2021 07:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075581;
        bh=+CKdp58e9357ToKj3WythrtuJo8PN4o3J5fRdkvJG4A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=penfDWPZFVGlJCk/LcTDQ3HBnkICpeujGc8XYi6DZNePe65wC/bwzAZfJ2oalSRG9
         M75+7a2WY/bGR68xI5jyjC0DWfff/eEE/ptYqBxk2ELhvBYI2cJ+3zPb/RXTq6Czoi
         lg4xDn0tb9tpILhox1k4jOcvuBb569V3gQpQsRoY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 274/800] crypto: ixp4xx - update IV after requests
Date:   Mon, 12 Jul 2021 08:04:57 +0200
Message-Id: <20210712060953.451809278@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Corentin Labbe <clabbe@baylibre.com>

[ Upstream commit e8acf011f2e7e21a7e2fae47cbaa06598e533d40 ]

Crypto selftests fail on ixp4xx since it do not update IV after skcipher
requests.

Fixes: 81bef0150074 ("crypto: ixp4xx - Hardware crypto support for IXP4xx CPUs")
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ixp4xx_crypto.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_crypto.c
index ed3deaa5ed2b..f577ee4afd06 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -149,6 +149,8 @@ struct crypt_ctl {
 struct ablk_ctx {
 	struct buffer_desc *src;
 	struct buffer_desc *dst;
+	u8 iv[MAX_IVLEN];
+	bool encrypt;
 };
 
 struct aead_ctx {
@@ -381,6 +383,20 @@ static void one_packet(dma_addr_t phys)
 	case CTL_FLAG_PERFORM_ABLK: {
 		struct skcipher_request *req = crypt->data.ablk_req;
 		struct ablk_ctx *req_ctx = skcipher_request_ctx(req);
+		struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+		unsigned int ivsize = crypto_skcipher_ivsize(tfm);
+		unsigned int offset;
+
+		if (ivsize > 0) {
+			offset = req->cryptlen - ivsize;
+			if (req_ctx->encrypt) {
+				scatterwalk_map_and_copy(req->iv, req->dst,
+							 offset, ivsize, 0);
+			} else {
+				memcpy(req->iv, req_ctx->iv, ivsize);
+				memzero_explicit(req_ctx->iv, ivsize);
+			}
+		}
 
 		if (req_ctx->dst) {
 			free_buf_chain(dev, req_ctx->dst, crypt->dst_buf);
@@ -876,6 +892,7 @@ static int ablk_perform(struct skcipher_request *req, int encrypt)
 	struct ablk_ctx *req_ctx = skcipher_request_ctx(req);
 	struct buffer_desc src_hook;
 	struct device *dev = &pdev->dev;
+	unsigned int offset;
 	gfp_t flags = req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ?
 				GFP_KERNEL : GFP_ATOMIC;
 
@@ -885,6 +902,7 @@ static int ablk_perform(struct skcipher_request *req, int encrypt)
 		return -EAGAIN;
 
 	dir = encrypt ? &ctx->encrypt : &ctx->decrypt;
+	req_ctx->encrypt = encrypt;
 
 	crypt = get_crypt_desc();
 	if (!crypt)
@@ -900,6 +918,10 @@ static int ablk_perform(struct skcipher_request *req, int encrypt)
 
 	BUG_ON(ivsize && !req->iv);
 	memcpy(crypt->iv, req->iv, ivsize);
+	if (ivsize > 0 && !encrypt) {
+		offset = req->cryptlen - ivsize;
+		scatterwalk_map_and_copy(req_ctx->iv, req->src, offset, ivsize, 0);
+	}
 	if (req->src != req->dst) {
 		struct buffer_desc dst_hook;
 		crypt->mode |= NPE_OP_NOT_IN_PLACE;
-- 
2.30.2



