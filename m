Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8035D23797
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 15:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732270AbfETMwO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:52:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:60144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387769AbfETMS4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:18:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BBD1C21019;
        Mon, 20 May 2019 12:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558354735;
        bh=W6/X+FsS7lgY0ci9ipL3DN72hdu/rw1yHfoWA9Ns1Uk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hd9zbMUYtBD66HNLPonM5N85hDP7a8hQgD8Fq2uYgCEQDZVkJ/PeXpXYO0zY+q6GY
         SmB9XdDZODG80e02iGCeNCg9WvEIFI4QvrbFqP+Abs7c2kApfdCIC7n2VrRPhSzutz
         NuB+K4hW4ioi0AZZEWWdFXsNtFAf0AeULxhVf+/0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Zhang Zhijie <zhangzj@rock-chips.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.14 23/63] crypto: rockchip - update IV buffer to contain the next IV
Date:   Mon, 20 May 2019 14:14:02 +0200
Message-Id: <20190520115233.577744541@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115231.137981521@linuxfoundation.org>
References: <20190520115231.137981521@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Zhijie <zhangzj@rock-chips.com>

commit f0cfd57b43fec65761ca61d3892b983a71515f23 upstream.

The Kernel Crypto API request output the next IV data to
IV buffer for CBC implementation. So the last block data of
ciphertext should be copid into assigned IV buffer.

Reported-by: Eric Biggers <ebiggers@google.com>
Fixes: 433cd2c617bf ("crypto: rockchip - add crypto driver for rk3288")
Cc: <stable@vger.kernel.org> # v4.5+
Signed-off-by: Zhang Zhijie <zhangzj@rock-chips.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c |   25 +++++++++++++++------
 1 file changed, 18 insertions(+), 7 deletions(-)

--- a/drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c
+++ b/drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c
@@ -250,9 +250,14 @@ static int rk_set_data_start(struct rk_c
 	u8 *src_last_blk = page_address(sg_page(dev->sg_src)) +
 		dev->sg_src->offset + dev->sg_src->length - ivsize;
 
-	/* store the iv that need to be updated in chain mode */
-	if (ctx->mode & RK_CRYPTO_DEC)
+	/* Store the iv that need to be updated in chain mode.
+	 * And update the IV buffer to contain the next IV for decryption mode.
+	 */
+	if (ctx->mode & RK_CRYPTO_DEC) {
 		memcpy(ctx->iv, src_last_blk, ivsize);
+		sg_pcopy_to_buffer(dev->first, dev->src_nents, req->info,
+				   ivsize, dev->total - ivsize);
+	}
 
 	err = dev->load_data(dev, dev->sg_src, dev->sg_dst);
 	if (!err)
@@ -288,13 +293,19 @@ static void rk_iv_copyback(struct rk_cry
 	struct ablkcipher_request *req =
 		ablkcipher_request_cast(dev->async_req);
 	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(req);
+	struct rk_cipher_ctx *ctx = crypto_ablkcipher_ctx(tfm);
 	u32 ivsize = crypto_ablkcipher_ivsize(tfm);
 
-	if (ivsize == DES_BLOCK_SIZE)
-		memcpy_fromio(req->info, dev->reg + RK_CRYPTO_TDES_IV_0,
-			      ivsize);
-	else if (ivsize == AES_BLOCK_SIZE)
-		memcpy_fromio(req->info, dev->reg + RK_CRYPTO_AES_IV_0, ivsize);
+	/* Update the IV buffer to contain the next IV for encryption mode. */
+	if (!(ctx->mode & RK_CRYPTO_DEC)) {
+		if (dev->aligned) {
+			memcpy(req->info, sg_virt(dev->sg_dst) +
+				dev->sg_dst->length - ivsize, ivsize);
+		} else {
+			memcpy(req->info, dev->addr_vir +
+				dev->count - ivsize, ivsize);
+		}
+	}
 }
 
 static void rk_update_iv(struct rk_crypto_info *dev)


