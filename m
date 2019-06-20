Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E291B4D5DC
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbfFTSBo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:01:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:51548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727314AbfFTSBn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:01:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39B7620B1F;
        Thu, 20 Jun 2019 18:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561053702;
        bh=5ku35xL2IOm1lfhHw1d7/RAla0NL9v23eKstzeDFCP8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bwe0L3h35ajm0tnsBU3DfR+sGoAC2Z6ZoPA9bMmSzTzJlg8bCWIAxlAxT8vH9jBOS
         4JSsMDId9X/RVpX2+wIN05QthUCFrkFeV60A60HA9PfB8rs4uxTiI6sZ+WARySXfhy
         ZPySVrp4DGMfvhP9cXh6XC7jUvqal3HuplCvD4pw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
        Christian Lamparter <chunkeey@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 82/84] Revert "crypto: crypto4xx - properly set IV after de- and encrypt"
Date:   Thu, 20 Jun 2019 19:57:19 +0200
Message-Id: <20190620174349.254260381@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174337.538228162@linuxfoundation.org>
References: <20190620174337.538228162@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit e9a60ab1609a7d975922adad1bf9c46ac6954584 which is
commit fc340115ffb8235c1bbd200c28855e6373d0dd1a upstream.

Hauke writes that this breaks the build and should be reverted.

Reported-by: Hauke Mehrtens <hauke@hauke-m.de>
Cc: Christian Lamparter <chunkeey@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/amcc/crypto4xx_alg.c  |    3 +--
 drivers/crypto/amcc/crypto4xx_core.c |    9 ---------
 2 files changed, 1 insertion(+), 11 deletions(-)

--- a/drivers/crypto/amcc/crypto4xx_alg.c
+++ b/drivers/crypto/amcc/crypto4xx_alg.c
@@ -138,8 +138,7 @@ static int crypto4xx_setkey_aes(struct c
 	sa = (struct dynamic_sa_ctl *) ctx->sa_in;
 	ctx->hash_final = 0;
 
-	set_dynamic_sa_command_0(sa, SA_NOT_SAVE_HASH, (cm == CRYPTO_MODE_CBC ?
-				 SA_SAVE_IV : SA_NOT_SAVE_IV),
+	set_dynamic_sa_command_0(sa, SA_NOT_SAVE_HASH, SA_NOT_SAVE_IV,
 				 SA_LOAD_HASH_FROM_SA, SA_LOAD_IV_FROM_STATE,
 				 SA_NO_HEADER_PROC, SA_HASH_ALG_NULL,
 				 SA_CIPHER_ALG_AES, SA_PAD_TYPE_ZERO,
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -645,15 +645,6 @@ static u32 crypto4xx_ablkcipher_done(str
 		addr = dma_map_page(dev->core_dev->device, sg_page(dst),
 				    dst->offset, dst->length, DMA_FROM_DEVICE);
 	}
-
-	if (pd_uinfo->sa_va->sa_command_0.bf.save_iv == SA_SAVE_IV) {
-		struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
-
-		crypto4xx_memcpy_from_le32((u32 *)req->iv,
-			pd_uinfo->sr_va->save_iv,
-			crypto_skcipher_ivsize(skcipher));
-	}
-
 	crypto4xx_ret_sg_desc(dev, pd_uinfo);
 	if (ablk_req->base.complete != NULL)
 		ablk_req->base.complete(&ablk_req->base, 0);


