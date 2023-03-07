Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8906AEEB2
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:15:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbjCGSO6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:14:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232279AbjCGSO1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:14:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD8829EF62
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:09:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CAE9861537
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:09:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C04D0C433EF;
        Tue,  7 Mar 2023 18:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212596;
        bh=VsRbSgxvou9xvnNpau0YGMN5KrjpoyoKSC8c0ex4ASY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2pOwCo6sF0hmrCjh1oI4CaU1oPOjXWeVwQme2o1KryUl3OnrSb4HyPIXbrgJcrzVJ
         LTEmvDgczSrSijya09qtoRax6L823Ana4ZpzQUPzarX+iXAIyuQePq3/laeWJIM4Zd
         OW6044yd8cSkVwEbPxvdOA64WVj7+wQIuZM0h69A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Herbert Xu <herbert@gondor.apana.org.au>,
        Christian Lamparter <chunkeey@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 234/885] crypto: crypto4xx - Call dma_unmap_page when done
Date:   Tue,  7 Mar 2023 17:52:48 +0100
Message-Id: <20230307170012.181582093@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit bcdda4301bdc4955d45f7e1ffefb6207967b067e ]

In crypto4xx_cipher_done, we should be unmapping the dst page, not
mapping it.

This was flagged by a sparse warning about the unused addr variable.
While we're at it, also fix a sparse warning regarding the unused
ctx variable in crypto4xx_ahash_done (by actually using it).

Fixes: 049359d65527 ("crypto: amcc - Add crypt4xx driver")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Tested-by: Christian Lamparter <chunkeey@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/amcc/crypto4xx_core.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index 280f4b0e71334..50dc783821b69 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -522,7 +522,6 @@ static void crypto4xx_cipher_done(struct crypto4xx_device *dev,
 {
 	struct skcipher_request *req;
 	struct scatterlist *dst;
-	dma_addr_t addr;
 
 	req = skcipher_request_cast(pd_uinfo->async_req);
 
@@ -531,8 +530,8 @@ static void crypto4xx_cipher_done(struct crypto4xx_device *dev,
 					  req->cryptlen, req->dst);
 	} else {
 		dst = pd_uinfo->dest_va;
-		addr = dma_map_page(dev->core_dev->device, sg_page(dst),
-				    dst->offset, dst->length, DMA_FROM_DEVICE);
+		dma_unmap_page(dev->core_dev->device, pd->dest, dst->length,
+			       DMA_FROM_DEVICE);
 	}
 
 	if (pd_uinfo->sa_va->sa_command_0.bf.save_iv == SA_SAVE_IV) {
@@ -557,10 +556,9 @@ static void crypto4xx_ahash_done(struct crypto4xx_device *dev,
 	struct ahash_request *ahash_req;
 
 	ahash_req = ahash_request_cast(pd_uinfo->async_req);
-	ctx  = crypto_tfm_ctx(ahash_req->base.tfm);
+	ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(ahash_req));
 
-	crypto4xx_copy_digest_to_dst(ahash_req->result, pd_uinfo,
-				     crypto_tfm_ctx(ahash_req->base.tfm));
+	crypto4xx_copy_digest_to_dst(ahash_req->result, pd_uinfo, ctx);
 	crypto4xx_ret_sg_desc(dev, pd_uinfo);
 
 	if (pd_uinfo->state & PD_ENTRY_BUSY)
-- 
2.39.2



