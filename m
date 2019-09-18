Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4976B5CFE
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:31:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729792AbfIRGYM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:24:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:44588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727898AbfIRGYL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:24:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51E1621920;
        Wed, 18 Sep 2019 06:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568787850;
        bh=KpG27z8qyjIzkETdoVwHuerL4Qj7YTrZv6XUUnfjGhc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YHfF8Oot8/ufJQqA4GSNyIQDz2Oto7oi8MR92i2IeNyu1KRkXhto+Gm6wEksQ4cr4
         t+hRvhX2zUAOeL+HQDCZPQfT6Cpe7lHA6cpALZPkHRyNYwLDohYtgLnjk8wbJ/4hop
         XpEs4gYMoRaL0GZkS2etwPodkLUtiMhBHr9eTXGw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christophe Leroy <christophe.leroy@c-s.fr>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.19 34/50] crypto: talitos - check AES key size
Date:   Wed, 18 Sep 2019 08:19:17 +0200
Message-Id: <20190918061227.187874847@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190918061223.116178343@linuxfoundation.org>
References: <20190918061223.116178343@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@c-s.fr>

commit 1ba34e71e9e56ac29a52e0d42b6290f3dc5bfd90 upstream.

Although the HW accepts any size and silently truncates
it to the correct length, the extra tests expects EINVAL
to be returned when the key size is not valid.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Fixes: 4de9d0b547b9 ("crypto: talitos - Add ablkcipher algorithms")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/talitos.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -1538,6 +1538,18 @@ static int ablkcipher_setkey(struct cryp
 	return 0;
 }
 
+static int ablkcipher_aes_setkey(struct crypto_ablkcipher *cipher,
+				  const u8 *key, unsigned int keylen)
+{
+	if (keylen == AES_KEYSIZE_128 || keylen == AES_KEYSIZE_192 ||
+	    keylen == AES_KEYSIZE_256)
+		return ablkcipher_setkey(cipher, key, keylen);
+
+	crypto_ablkcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
+
+	return -EINVAL;
+}
+
 static void common_nonsnoop_unmap(struct device *dev,
 				  struct talitos_edesc *edesc,
 				  struct ablkcipher_request *areq)
@@ -2705,6 +2717,7 @@ static struct talitos_alg_template drive
 				.min_keysize = AES_MIN_KEY_SIZE,
 				.max_keysize = AES_MAX_KEY_SIZE,
 				.ivsize = AES_BLOCK_SIZE,
+				.setkey = ablkcipher_aes_setkey,
 			}
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
@@ -2722,6 +2735,7 @@ static struct talitos_alg_template drive
 				.min_keysize = AES_MIN_KEY_SIZE,
 				.max_keysize = AES_MAX_KEY_SIZE,
 				.ivsize = AES_BLOCK_SIZE,
+				.setkey = ablkcipher_aes_setkey,
 			}
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_AESU_CTR_NONSNOOP |


