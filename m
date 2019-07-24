Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9894F73ECE
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388867AbfGXTfq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:35:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:33538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389254AbfGXTfn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:35:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73EAF21951;
        Wed, 24 Jul 2019 19:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563996942;
        bh=R2uVoCl7+JtEDoVTkZtGlMieRUdPFOP57pNTsyFkbTg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qdTJeqE66PUyIsmqaJX3QS63FGRP0o71zqQCA+3x61ngklzEuWRjwfte178lxHVUA
         gSIJNfVyChvqLFsp5GZPLcsBlc0ZgOou1YdvJ+BrFlF2cZ2qAJO5OeeUh0wsDK5VGs
         sm2NuFewgZfmDBpqV9FTQWmfFunXriHI5fp7JRhU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>,
        Christian Lamparter <chunkeey@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.2 270/413] crypto: crypto4xx - fix blocksize for cfb and ofb
Date:   Wed, 24 Jul 2019 21:19:21 +0200
Message-Id: <20190724191755.539307524@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
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
@@ -1222,7 +1222,7 @@ static struct crypto4xx_alg_common crypt
 			.cra_priority = CRYPTO4XX_CRYPTO_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
 				CRYPTO_ALG_KERN_DRIVER_ONLY,
-			.cra_blocksize = AES_BLOCK_SIZE,
+			.cra_blocksize = 1,
 			.cra_ctxsize = sizeof(struct crypto4xx_ctx),
 			.cra_module = THIS_MODULE,
 		},
@@ -1302,7 +1302,7 @@ static struct crypto4xx_alg_common crypt
 			.cra_priority = CRYPTO4XX_CRYPTO_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
 				CRYPTO_ALG_KERN_DRIVER_ONLY,
-			.cra_blocksize = AES_BLOCK_SIZE,
+			.cra_blocksize = 1,
 			.cra_ctxsize = sizeof(struct crypto4xx_ctx),
 			.cra_module = THIS_MODULE,
 		},


