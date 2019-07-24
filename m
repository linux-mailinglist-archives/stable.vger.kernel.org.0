Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB0673CFB
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390313AbfGXTzI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:55:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:38512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404500AbfGXTzH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:55:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4CD1F205C9;
        Wed, 24 Jul 2019 19:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563998106;
        bh=sghNofyIJYB7e9nU2RNpnFjVAzbMBw3oAZS1EYiVxSY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ceCkNeJfxfHFK1q7bLRYPBY5B5DqFfTxO1wFcfKqXpq4Qq8Fk3jhSLK1rHWeOCgFM
         PguSuM4RILJU4bn3mMH3T5E1RKBmPD+gO1qVsoMupb8gwyUDnAs/tR/Dzu21+8QfHE
         tA22/nIoYy7wYBa3tiFqKZgUCgLPfq+uBNlBf9z8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>,
        Christian Lamparter <chunkeey@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.1 246/371] crypto: crypto4xx - fix blocksize for cfb and ofb
Date:   Wed, 24 Jul 2019 21:19:58 +0200
Message-Id: <20190724191743.235970087@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Lamparter <chunkeey@gmail.com>

commit 70c4997f34b6c6888b3ac157adec49e01d0df2d5 upstream.

While the hardware consider them to be blockciphers, the
reference implementation defines them as streamciphers.

Do the right thing and set the blocksize to 1. This
was found by CONFIG_CRYPTO_MANAGER_EXTRA_TESTS.

This fixes the following issues:
skcipher: blocksize for ofb-aes-ppc4xx (16) doesn't match generic impl (1)
skcipher: blocksize for cfb-aes-ppc4xx (16) doesn't match generic impl (1)

Cc: Eric Biggers <ebiggers@kernel.org>
Cc: stable@vger.kernel.org
Fixes: f2a13e7cba9e ("crypto: crypto4xx - enable AES RFC3686, ECB, CFB and OFB offloads")
Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/amcc/crypto4xx_core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -1238,7 +1238,7 @@ static struct crypto4xx_alg_common crypt
 			.cra_priority = CRYPTO4XX_CRYPTO_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
 				CRYPTO_ALG_KERN_DRIVER_ONLY,
-			.cra_blocksize = AES_BLOCK_SIZE,
+			.cra_blocksize = 1,
 			.cra_ctxsize = sizeof(struct crypto4xx_ctx),
 			.cra_module = THIS_MODULE,
 		},
@@ -1318,7 +1318,7 @@ static struct crypto4xx_alg_common crypt
 			.cra_priority = CRYPTO4XX_CRYPTO_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
 				CRYPTO_ALG_KERN_DRIVER_ONLY,
-			.cra_blocksize = AES_BLOCK_SIZE,
+			.cra_blocksize = 1,
 			.cra_ctxsize = sizeof(struct crypto4xx_ctx),
 			.cra_module = THIS_MODULE,
 		},


