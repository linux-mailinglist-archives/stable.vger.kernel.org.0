Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 608EF4996A8
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:19:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232187AbiAXVFi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:05:38 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:55514 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444715AbiAXVBW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:01:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 79F1FB80FA3;
        Mon, 24 Jan 2022 21:01:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F8E5C340E5;
        Mon, 24 Jan 2022 21:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058079;
        bh=QA8+oOIsCW4SEIRGEnJ6v+finhlrCS8bNEytK881OKw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RD1D1JegVhp8qeCr0zIYTs60MzjsvDZj8piRkzbndsQHT1WHRdKFMI+j7iaDhrJnd
         jg7XkQL8BPDAdiShNudVgbgVb0J1lZxcjpNEm4KEljMyVd/+GLBeQr5JoeHZSAZ0tm
         ADuU+s769atr/pFVSloJN3XCL/9DfT5xzDhdcjlg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wolfgang Ocker <weo@reccoware.de>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0157/1039] crypto: atmel-aes - Reestablish the correct tfm context at dequeue
Date:   Mon, 24 Jan 2022 19:32:26 +0100
Message-Id: <20220124184130.453484468@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tudor Ambarus <tudor.ambarus@microchip.com>

[ Upstream commit 6d48de655917a9d782953eba65de4e3db593ddf0 ]

In case there were more requests from different tfms in the crypto
queue, only the context of the last initialized tfm was considered.

Fixes: ec2088b66f7a ("crypto: atmel-aes - Allocate aes dev at tfm init time")
Reported-by: Wolfgang Ocker <weo@reccoware.de>
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/atmel-aes.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 9391ccc03382d..fe05584031914 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -960,6 +960,7 @@ static int atmel_aes_handle_queue(struct atmel_aes_dev *dd,
 	ctx = crypto_tfm_ctx(areq->tfm);
 
 	dd->areq = areq;
+	dd->ctx = ctx;
 	start_async = (areq != new_areq);
 	dd->is_async = start_async;
 
@@ -1274,7 +1275,6 @@ static int atmel_aes_init_tfm(struct crypto_skcipher *tfm)
 
 	crypto_skcipher_set_reqsize(tfm, sizeof(struct atmel_aes_reqctx));
 	ctx->base.dd = dd;
-	ctx->base.dd->ctx = &ctx->base;
 	ctx->base.start = atmel_aes_start;
 
 	return 0;
@@ -1291,7 +1291,6 @@ static int atmel_aes_ctr_init_tfm(struct crypto_skcipher *tfm)
 
 	crypto_skcipher_set_reqsize(tfm, sizeof(struct atmel_aes_reqctx));
 	ctx->base.dd = dd;
-	ctx->base.dd->ctx = &ctx->base;
 	ctx->base.start = atmel_aes_ctr_start;
 
 	return 0;
@@ -1783,7 +1782,6 @@ static int atmel_aes_gcm_init(struct crypto_aead *tfm)
 
 	crypto_aead_set_reqsize(tfm, sizeof(struct atmel_aes_reqctx));
 	ctx->base.dd = dd;
-	ctx->base.dd->ctx = &ctx->base;
 	ctx->base.start = atmel_aes_gcm_start;
 
 	return 0;
@@ -1927,7 +1925,6 @@ static int atmel_aes_xts_init_tfm(struct crypto_skcipher *tfm)
 	crypto_skcipher_set_reqsize(tfm, sizeof(struct atmel_aes_reqctx) +
 				    crypto_skcipher_reqsize(ctx->fallback_tfm));
 	ctx->base.dd = dd;
-	ctx->base.dd->ctx = &ctx->base;
 	ctx->base.start = atmel_aes_xts_start;
 
 	return 0;
@@ -2154,7 +2151,6 @@ static int atmel_aes_authenc_init_tfm(struct crypto_aead *tfm,
 	crypto_aead_set_reqsize(tfm, (sizeof(struct atmel_aes_authenc_reqctx) +
 				      auth_reqsize));
 	ctx->base.dd = dd;
-	ctx->base.dd->ctx = &ctx->base;
 	ctx->base.start = atmel_aes_authenc_start;
 
 	return 0;
-- 
2.34.1



