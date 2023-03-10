Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A6EB6B4551
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:33:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232535AbjCJOdI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:33:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232500AbjCJOcr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:32:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1D81121B4A
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:31:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81253B822BB
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:31:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8B0CC433D2;
        Fri, 10 Mar 2023 14:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678458710;
        bh=7Cg1bECawHhejIcuF5pyK6fST64kR74Y8J70PcItwzI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=toOWXhnWNoGWax0u0F9vGc2dmPC4XloBgTjiPgJE2Pwv7JyyP1mFlrODky7MeDaHT
         zQ7Cb3vlqTNG0DZH3yhlkyPFj8Fw9aY6+TnR2UgV31mGE/ypOSONR12sBYtuLoYVqu
         rq1C4fqLn20afinDLQtkzjCIRfr8cz2jCbdbIMdw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Herbert Xu <herbert@gondor.apana.org.au>,
        Christian Lamparter <chunkeey@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 088/357] crypto: crypto4xx - Call dma_unmap_page when done
Date:   Fri, 10 Mar 2023 14:36:17 +0100
Message-Id: <20230310133737.877228067@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
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
index 230e8902c727c..b58f21dd3fed6 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -521,7 +521,6 @@ static void crypto4xx_cipher_done(struct crypto4xx_device *dev,
 {
 	struct skcipher_request *req;
 	struct scatterlist *dst;
-	dma_addr_t addr;
 
 	req = skcipher_request_cast(pd_uinfo->async_req);
 
@@ -530,8 +529,8 @@ static void crypto4xx_cipher_done(struct crypto4xx_device *dev,
 					  req->cryptlen, req->dst);
 	} else {
 		dst = pd_uinfo->dest_va;
-		addr = dma_map_page(dev->core_dev->device, sg_page(dst),
-				    dst->offset, dst->length, DMA_FROM_DEVICE);
+		dma_unmap_page(dev->core_dev->device, pd->dest, dst->length,
+			       DMA_FROM_DEVICE);
 	}
 
 	if (pd_uinfo->sa_va->sa_command_0.bf.save_iv == SA_SAVE_IV) {
@@ -556,10 +555,9 @@ static void crypto4xx_ahash_done(struct crypto4xx_device *dev,
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



