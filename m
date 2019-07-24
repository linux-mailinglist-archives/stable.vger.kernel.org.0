Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18B477456B
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 07:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390831AbfGYFm1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 01:42:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:57394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390847AbfGYFm1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 01:42:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A67022BEB;
        Thu, 25 Jul 2019 05:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564033346;
        bh=hw2uRw21RGEKo558VPfLuqeeQP2hTeyB602HS4SPkQE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YlDUBWafiGjv97ZuXeotIDflPkulIv5r8eXl4BQbzqRtCouiQzG9O5GeFjysHxE05
         eHc5VcSPWg6MxyJ977bozYJdWS+p9l6DVpawK0GRreX/WgJrnTIQdkpqP4wn9WR565
         sqTZL7Yi1NiwNmT18t2yZeR5yNcLl4Ito+WSWDrI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christian Lamparter <chunkeey@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.19 177/271] crypto: crypto4xx - fix AES CTR blocksize value
Date:   Wed, 24 Jul 2019 21:20:46 +0200
Message-Id: <20190724191710.320031701@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191655.268628197@linuxfoundation.org>
References: <20190724191655.268628197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Lamparter <chunkeey@gmail.com>

commit bfa2ba7d9e6b20aca82b99e6842fe18842ae3a0f upstream.

This patch fixes a issue with crypto4xx's ctr(aes) that was
discovered by libcapi's kcapi-enc-test.sh test.

The some of the ctr(aes) encryptions test were failing on the
non-power-of-two test:

kcapi-enc - Error: encryption failed with error 0
kcapi-enc - Error: decryption failed with error 0
[FAILED: 32-bit - 5.1.0-rc1+] 15 bytes: STDIN / STDOUT enc test (128 bits):
original file (1d100e..cc96184c) and generated file (e3b0c442..1b7852b855)
[FAILED: 32-bit - 5.1.0-rc1+] 15 bytes: STDIN / STDOUT enc test (128 bits)
(openssl generated CT): original file (e3b0..5) and generated file (3..8e)
[PASSED: 32-bit - 5.1.0-rc1+] 15 bytes: STDIN / STDOUT enc test (128 bits)
(openssl generated PT)
[FAILED: 32-bit - 5.1.0-rc1+] 15 bytes: STDIN / STDOUT enc test (password):
original file (1d1..84c) and generated file (e3b..852b855)

But the 16, 32, 512, 65536 tests always worked.

Thankfully, this isn't a hidden hardware problem like previously,
instead this turned out to be a copy and paste issue.

With this patch, all the tests are passing with and
kcapi-enc-test.sh gives crypto4xx's a clean bill of health:
 "Number of failures: 0" :).

Cc: stable@vger.kernel.org
Fixes: 98e87e3d933b ("crypto: crypto4xx - add aes-ctr support")
Fixes: f2a13e7cba9e ("crypto: crypto4xx - enable AES RFC3686, ECB, CFB and OFB offloads")
Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/amcc/crypto4xx_core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -1186,7 +1186,7 @@ static struct crypto4xx_alg_common crypt
 			.cra_flags = CRYPTO_ALG_NEED_FALLBACK |
 				CRYPTO_ALG_ASYNC |
 				CRYPTO_ALG_KERN_DRIVER_ONLY,
-			.cra_blocksize = AES_BLOCK_SIZE,
+			.cra_blocksize = 1,
 			.cra_ctxsize = sizeof(struct crypto4xx_ctx),
 			.cra_module = THIS_MODULE,
 		},
@@ -1206,7 +1206,7 @@ static struct crypto4xx_alg_common crypt
 			.cra_priority = CRYPTO4XX_CRYPTO_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
 				CRYPTO_ALG_KERN_DRIVER_ONLY,
-			.cra_blocksize = AES_BLOCK_SIZE,
+			.cra_blocksize = 1,
 			.cra_ctxsize = sizeof(struct crypto4xx_ctx),
 			.cra_module = THIS_MODULE,
 		},


