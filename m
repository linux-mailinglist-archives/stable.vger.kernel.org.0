Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6D1015C3AF
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:44:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728763AbgBMPng (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:43:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:53140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728412AbgBMP1x (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:27:53 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9757F218AC;
        Thu, 13 Feb 2020 15:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607672;
        bh=Y7tj7PSZoyNOv58hg+6UOtynPKMg5y4iPeSa/ueM9To=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WSceo7h8Un/a+AD7PCxqjK/1O8WftM0lGth5g+ui7/pVK3mBADqKsY2GScIdlilYW
         GdT8k9CvKgkkJDKyHZTZwN2vnXOvKyGLAgYhIr7ZOualdMyvDvVrQGw9YNIuSU+8Qk
         gxORHny6QgunwH//Vl8A6nsGbtrReAohgnrBZfhw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Eric Biggers <ebiggers@google.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.4 79/96] crypto: atmel-sha - fix error handling when setting hmac key
Date:   Thu, 13 Feb 2020 07:21:26 -0800
Message-Id: <20200213151908.944131584@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151839.156309910@linuxfoundation.org>
References: <20200213151839.156309910@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit b529f1983b2dcc46354f311feda92e07b6e9e2da upstream.

HMAC keys can be of any length, and atmel_sha_hmac_key_set() can only
fail due to -ENOMEM.  But atmel_sha_hmac_setkey() incorrectly treated
any error as a "bad key length" error.  Fix it to correctly propagate
the -ENOMEM error code and not set any tfm result flags.

Fixes: 81d8750b2b59 ("crypto: atmel-sha - add support to hmac(shaX)")
Cc: Nicolas Ferre <nicolas.ferre@microchip.com>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc: Ludovic Desroches <ludovic.desroches@microchip.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/atmel-sha.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -1918,12 +1918,7 @@ static int atmel_sha_hmac_setkey(struct
 {
 	struct atmel_sha_hmac_ctx *hmac = crypto_ahash_ctx(tfm);
 
-	if (atmel_sha_hmac_key_set(&hmac->hkey, key, keylen)) {
-		crypto_ahash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
-		return -EINVAL;
-	}
-
-	return 0;
+	return atmel_sha_hmac_key_set(&hmac->hkey, key, keylen);
 }
 
 static int atmel_sha_hmac_init(struct ahash_request *req)


