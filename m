Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 533133A7FD
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 18:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732877AbfFIQz7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:55:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:58306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732874AbfFIQz6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:55:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59D14205ED;
        Sun,  9 Jun 2019 16:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099357;
        bh=uhh8Vg9x5wvRtl1mwTABIvrWtt1cWlVM/KKhsPkU4vE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MaPrC1yM+97SH8FhD1B4MM23DgOBOlLIdihTG8e3e9NhPPsIpZ0EKvV0T1UwB1iHD
         DR2EZJXcWd1ZyE1tWgmsY46es8kvPaRiK1mEw5ZD/hf2k7KXRrLbrgh2p0jYcDHPYx
         lW2w4nehjKhcWJ4EsWA/AvPSfNCRABg4/ZBBSmfo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tim Chen <tim.c.chen@linux.intel.com>,
        Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.4 006/241] crypto: x86/crct10dif-pcl - fix use via crypto_shash_digest()
Date:   Sun,  9 Jun 2019 18:39:08 +0200
Message-Id: <20190609164147.971147667@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit dec3d0b1071a0f3194e66a83d26ecf4aa8c5910e upstream.

The ->digest() method of crct10dif-pclmul reads the current CRC value
from the shash_desc context.  But this value is uninitialized, causing
crypto_shash_digest() to compute the wrong result.  Fix it.

Probably this wasn't noticed before because lib/crc-t10dif.c only uses
crypto_shash_update(), not crypto_shash_digest().  Likewise,
crypto_shash_digest() is not yet tested by the crypto self-tests because
those only test the ahash API which only uses shash init/update/final.

Fixes: 0b95a7f85718 ("crypto: crct10dif - Glue code to cast accelerated CRCT10DIF assembly as a crypto transform")
Cc: <stable@vger.kernel.org> # v3.11+
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/crypto/crct10dif-pclmul_glue.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/arch/x86/crypto/crct10dif-pclmul_glue.c
+++ b/arch/x86/crypto/crct10dif-pclmul_glue.c
@@ -76,15 +76,14 @@ static int chksum_final(struct shash_des
 	return 0;
 }
 
-static int __chksum_finup(__u16 *crcp, const u8 *data, unsigned int len,
-			u8 *out)
+static int __chksum_finup(__u16 crc, const u8 *data, unsigned int len, u8 *out)
 {
 	if (irq_fpu_usable()) {
 		kernel_fpu_begin();
-		*(__u16 *)out = crc_t10dif_pcl(*crcp, data, len);
+		*(__u16 *)out = crc_t10dif_pcl(crc, data, len);
 		kernel_fpu_end();
 	} else
-		*(__u16 *)out = crc_t10dif_generic(*crcp, data, len);
+		*(__u16 *)out = crc_t10dif_generic(crc, data, len);
 	return 0;
 }
 
@@ -93,15 +92,13 @@ static int chksum_finup(struct shash_des
 {
 	struct chksum_desc_ctx *ctx = shash_desc_ctx(desc);
 
-	return __chksum_finup(&ctx->crc, data, len, out);
+	return __chksum_finup(ctx->crc, data, len, out);
 }
 
 static int chksum_digest(struct shash_desc *desc, const u8 *data,
 			 unsigned int length, u8 *out)
 {
-	struct chksum_desc_ctx *ctx = shash_desc_ctx(desc);
-
-	return __chksum_finup(&ctx->crc, data, length, out);
+	return __chksum_finup(0, data, length, out);
 }
 
 static struct shash_alg alg = {


