Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EBEA2183C
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 14:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728790AbfEQMhx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 08:37:53 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:34921 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728387AbfEQMhx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 May 2019 08:37:53 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 55575275;
        Fri, 17 May 2019 08:37:52 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 17 May 2019 08:37:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=2tbCj8
        dhTbvz9cU1j/39VAg0E6OUFF9ZE7bqVpGT++Q=; b=UgPzhIgtySxz/iHQMXs8jE
        j248WSIXcvUkYNKh0A0noZM2afLOOB4MFuPxN71c/agkbsUod8IR3viiDwd2WFej
        ZFPXCDvR9+uj5XcJmw3umZR77GLKUCyIR5qAsBUXjDvE0qMuR7XLO5HRm0ujcKh1
        y1Wz5UZ7UrLy85QJDWaF/pT9J+FmoGQpt5JTcen3Ce+6810FwjKNDatl7KRACHZR
        tAyR2z1s7pGaHymGv/LZcGF1dgHJhG+0H6CP0gu0eD4WB+gnJj63cIg6GKN9oGe+
        CTgmAnoXwzeDoEwpDTsMyE62YmGnaVWZoXznxYvukQIvC6KJgKkypGtadPxgER8w
        ==
X-ME-Sender: <xms:H6veXDkkx8x6DhYMu17achWitZEgTsE-oQgrGS1Q5BcKISGhee2IAw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddtvddgheehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepvd
X-ME-Proxy: <xmx:H6veXPreofhJgWWwF6xrVf0GRoNH93vhaAyqmyOpHhCx23p8-SnQ0g>
    <xmx:H6veXP_UITmsi30DEWTd7rV70kEYWEH1xmRgpJ04ObbNua4O7AjwaA>
    <xmx:H6veXCNAZSdhd6JwrtDNDBytu3Ujk_HyVAt0xMVoXoJtvQzKDcl4BQ>
    <xmx:H6veXOspUz3phaoPsFQ9tf9lix2e9HR5M55YPBIvzAPLbKmph_dX8g>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0CA458005B;
        Fri, 17 May 2019 08:37:50 -0400 (EDT)
Subject: FAILED: patch "[PATCH] crypto: rockchip - update IV buffer to contain the next IV" failed to apply to 4.9-stable tree
To:     zhangzj@rock-chips.com, ebiggers@google.com,
        herbert@gondor.apana.org.au, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 17 May 2019 14:37:49 +0200
Message-ID: <155809666934172@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f0cfd57b43fec65761ca61d3892b983a71515f23 Mon Sep 17 00:00:00 2001
From: Zhang Zhijie <zhangzj@rock-chips.com>
Date: Fri, 12 Apr 2019 17:16:33 +0800
Subject: [PATCH] crypto: rockchip - update IV buffer to contain the next IV

The Kernel Crypto API request output the next IV data to
IV buffer for CBC implementation. So the last block data of
ciphertext should be copid into assigned IV buffer.

Reported-by: Eric Biggers <ebiggers@google.com>
Fixes: 433cd2c617bf ("crypto: rockchip - add crypto driver for rk3288")
Cc: <stable@vger.kernel.org> # v4.5+
Signed-off-by: Zhang Zhijie <zhangzj@rock-chips.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c b/drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c
index 7d02c97be18d..313759521a0f 100644
--- a/drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c
+++ b/drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c
@@ -262,9 +262,14 @@ static int rk_set_data_start(struct rk_crypto_info *dev)
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
@@ -300,13 +305,19 @@ static void rk_iv_copyback(struct rk_crypto_info *dev)
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

