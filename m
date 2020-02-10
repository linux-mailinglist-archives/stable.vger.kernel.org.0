Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D43D157661
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:53:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730200AbgBJMmQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:42:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:46294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728791AbgBJMmP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:42:15 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC0E724649;
        Mon, 10 Feb 2020 12:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338534;
        bh=+E7je+NFtmGn49WxnLROcZktH8h8z2zuomszzMDNbuE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QiiO/ePcI+F9ORfT1UR8s9akTPO6oTO+qH5hTdf5eVgcNLVSriQC3sFTHKpmmqPHf
         mmmC/2reghecS7t1W/K0/gqSvleV9gOfySwPdujm+ag2GQulOiWxNFCvX3hQKi+ZYv
         /QImsTuXf6FQScWkitYmpDFlTnfQOM8gBkCT0cdY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 362/367] crypto: atmel-{aes,tdes} - Do not save IV for ECB mode
Date:   Mon, 10 Feb 2020 04:34:35 -0800
Message-Id: <20200210122455.765754809@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tudor Ambarus <tudor.ambarus@microchip.com>

[ Upstream commit c65d123742a7bf2a5bc9fa8398e1fd2376eb4c43 ]

ECB mode does not use IV.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/atmel-aes.c  | 9 +++++++--
 drivers/crypto/atmel-tdes.c | 7 +++++--
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 24f1fba6513ef..7b7079db2e860 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -515,6 +515,9 @@ static void atmel_aes_set_iv_as_last_ciphertext_block(struct atmel_aes_dev *dd)
 
 static inline int atmel_aes_complete(struct atmel_aes_dev *dd, int err)
 {
+	struct skcipher_request *req = skcipher_request_cast(dd->areq);
+	struct atmel_aes_reqctx *rctx = skcipher_request_ctx(req);
+
 #if IS_ENABLED(CONFIG_CRYPTO_DEV_ATMEL_AUTHENC)
 	if (dd->ctx->is_aead)
 		atmel_aes_authenc_complete(dd, err);
@@ -523,7 +526,8 @@ static inline int atmel_aes_complete(struct atmel_aes_dev *dd, int err)
 	clk_disable(dd->iclk);
 	dd->flags &= ~AES_FLAGS_BUSY;
 
-	if (!dd->ctx->is_aead)
+	if (!dd->ctx->is_aead &&
+	    (rctx->mode & AES_FLAGS_OPMODE_MASK) != AES_FLAGS_ECB)
 		atmel_aes_set_iv_as_last_ciphertext_block(dd);
 
 	if (dd->is_async)
@@ -1121,7 +1125,8 @@ static int atmel_aes_crypt(struct skcipher_request *req, unsigned long mode)
 	rctx = skcipher_request_ctx(req);
 	rctx->mode = mode;
 
-	if (!(mode & AES_FLAGS_ENCRYPT) && (req->src == req->dst)) {
+	if ((mode & AES_FLAGS_OPMODE_MASK) != AES_FLAGS_ECB &&
+	    !(mode & AES_FLAGS_ENCRYPT) && req->src == req->dst) {
 		unsigned int ivsize = crypto_skcipher_ivsize(skcipher);
 
 		if (req->cryptlen >= ivsize)
diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index 0c1f79b30fc1b..eaa14a80d40ce 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -600,12 +600,14 @@ atmel_tdes_set_iv_as_last_ciphertext_block(struct atmel_tdes_dev *dd)
 static void atmel_tdes_finish_req(struct atmel_tdes_dev *dd, int err)
 {
 	struct skcipher_request *req = dd->req;
+	struct atmel_tdes_reqctx *rctx = skcipher_request_ctx(req);
 
 	clk_disable_unprepare(dd->iclk);
 
 	dd->flags &= ~TDES_FLAGS_BUSY;
 
-	atmel_tdes_set_iv_as_last_ciphertext_block(dd);
+	if ((rctx->mode & TDES_FLAGS_OPMODE_MASK) != TDES_FLAGS_ECB)
+		atmel_tdes_set_iv_as_last_ciphertext_block(dd);
 
 	req->base.complete(&req->base, err);
 }
@@ -727,7 +729,8 @@ static int atmel_tdes_crypt(struct skcipher_request *req, unsigned long mode)
 
 	rctx->mode = mode;
 
-	if (!(mode & TDES_FLAGS_ENCRYPT) && req->src == req->dst) {
+	if ((mode & TDES_FLAGS_OPMODE_MASK) != TDES_FLAGS_ECB &&
+	    !(mode & TDES_FLAGS_ENCRYPT) && req->src == req->dst) {
 		unsigned int ivsize = crypto_skcipher_ivsize(skcipher);
 
 		if (req->cryptlen >= ivsize)
-- 
2.20.1



