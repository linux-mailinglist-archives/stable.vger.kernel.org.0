Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC98E5398
	for <lists+stable@lfdr.de>; Fri, 25 Oct 2019 20:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731719AbfJYSHA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Oct 2019 14:07:00 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46568 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731326AbfJYSFk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Oct 2019 14:05:40 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iO3xv-0008OJ-QN; Fri, 25 Oct 2019 19:05:35 +0100
Received: from ben by deadeye with local (Exim 4.92.2)
        (envelope-from <ben@decadent.org.uk>)
        id 1iO3xv-0001i6-1w; Fri, 25 Oct 2019 19:05:35 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Herbert Xu" <herbert@gondor.apana.org.au>,
        "Christophe Leroy" <christophe.leroy@c-s.fr>
Date:   Fri, 25 Oct 2019 19:03:09 +0100
Message-ID: <lsq.1572026582.603165107@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 08/47] crypto: talitos - check AES key size
In-Reply-To: <lsq.1572026581.992411028@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.76-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe Leroy <christophe.leroy@c-s.fr>

commit 1ba34e71e9e56ac29a52e0d42b6290f3dc5bfd90 upstream.

Although the HW accepts any size and silently truncates
it to the correct length, the extra tests expects EINVAL
to be returned when the key size is not valid.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Fixes: 4de9d0b547b9 ("crypto: talitos - Add ablkcipher algorithms")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
[bwh: Backported to 3.16: only cbc(aes) algorithm is supported]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -1335,6 +1335,18 @@ static int ablkcipher_setkey(struct cryp
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
@@ -2170,6 +2182,7 @@ static struct talitos_alg_template drive
 				.min_keysize = AES_MIN_KEY_SIZE,
 				.max_keysize = AES_MAX_KEY_SIZE,
 				.ivsize = AES_BLOCK_SIZE,
+				.setkey = ablkcipher_aes_setkey,
 			}
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |

