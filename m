Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31FC3B858E
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:22:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406787AbfISWWV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:22:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:37356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406823AbfISWWV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:22:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F78920678;
        Thu, 19 Sep 2019 22:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568931740;
        bh=qaUzJrbO2krp7v7QjlttN0laWS9gRSk4sJUfpoSVS7o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xFi9XUgxJ77rOgmfL+S352gBiIap28s1twhvkcHPKjZ6qvdNS26NuoBXGFY61Jnpu
         yQIHVi3y4kosciX3e6sAg9rCYI0jRaH7j9Mltegu78gTpmkWDQrF3adQoFZJjxBOoQ
         N64FJkm3v6AbJew0WX/39/JsFDNKCI5rix7Spws0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christophe Leroy <christophe.leroy@c-s.fr>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.4 22/56] crypto: talitos - check AES key size
Date:   Fri, 20 Sep 2019 00:04:03 +0200
Message-Id: <20190919214754.655329061@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214742.483643642@linuxfoundation.org>
References: <20190919214742.483643642@linuxfoundation.org>
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
 drivers/crypto/talitos.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -1426,6 +1426,18 @@ static void unmap_sg_talitos_ptr(struct
 	}
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
@@ -2379,6 +2391,7 @@ static struct talitos_alg_template drive
 				.min_keysize = AES_MIN_KEY_SIZE,
 				.max_keysize = AES_MAX_KEY_SIZE,
 				.ivsize = AES_BLOCK_SIZE,
+				.setkey = ablkcipher_aes_setkey,
 			}
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |


