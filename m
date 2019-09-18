Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 723DFB5BF3
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729040AbfIRGVQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:21:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:40578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729030AbfIRGVQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:21:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 184AA21927;
        Wed, 18 Sep 2019 06:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568787675;
        bh=PlwrvsatXtzITkWbZGl9RAV0pa378UmdtOmot4gk1mM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F636wQXmh+OqwEEHf+afj0iqXb7os9q1tiloS3pSLvG1+PgacVwbRby5VGF3LGM2K
         LybubnQdZs/X8szA831v5fSR4hbIW0RpUixi/OUra36gYQ4bPTn7rONeul9OGg4Lea
         hXbFBI5RdydlnF16D69qiUUN0ewkPWrszeo8/T3Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christophe Leroy <christophe.leroy@c-s.fr>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.14 36/45] crypto: talitos - check data blocksize in ablkcipher.
Date:   Wed, 18 Sep 2019 08:19:14 +0200
Message-Id: <20190918061227.295699631@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190918061222.854132812@linuxfoundation.org>
References: <20190918061222.854132812@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@c-s.fr>

commit ee483d32ee1a1a7f7d7e918fbc350c790a5af64a upstream.

When data size is not a multiple of the alg's block size,
the SEC generates an error interrupt and dumps the registers.
And for NULL size, the SEC does just nothing and the interrupt
is awaited forever.

This patch ensures the data size is correct before submitting
the request to the SEC engine.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Fixes: 4de9d0b547b9 ("crypto: talitos - Add ablkcipher algorithms")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/talitos.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -1668,6 +1668,14 @@ static int ablkcipher_encrypt(struct abl
 	struct crypto_ablkcipher *cipher = crypto_ablkcipher_reqtfm(areq);
 	struct talitos_ctx *ctx = crypto_ablkcipher_ctx(cipher);
 	struct talitos_edesc *edesc;
+	unsigned int blocksize =
+			crypto_tfm_alg_blocksize(crypto_ablkcipher_tfm(cipher));
+
+	if (!areq->nbytes)
+		return 0;
+
+	if (areq->nbytes % blocksize)
+		return -EINVAL;
 
 	/* allocate extended descriptor */
 	edesc = ablkcipher_edesc_alloc(areq, true);
@@ -1685,6 +1693,14 @@ static int ablkcipher_decrypt(struct abl
 	struct crypto_ablkcipher *cipher = crypto_ablkcipher_reqtfm(areq);
 	struct talitos_ctx *ctx = crypto_ablkcipher_ctx(cipher);
 	struct talitos_edesc *edesc;
+	unsigned int blocksize =
+			crypto_tfm_alg_blocksize(crypto_ablkcipher_tfm(cipher));
+
+	if (!areq->nbytes)
+		return 0;
+
+	if (areq->nbytes % blocksize)
+		return -EINVAL;
 
 	/* allocate extended descriptor */
 	edesc = ablkcipher_edesc_alloc(areq, false);


