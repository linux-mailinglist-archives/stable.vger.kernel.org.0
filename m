Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA4E594996
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:14:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245362AbiHOX3P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:29:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244913AbiHOXYj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:24:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB164804BD;
        Mon, 15 Aug 2022 13:05:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B42A56069F;
        Mon, 15 Aug 2022 20:05:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE282C433C1;
        Mon, 15 Aug 2022 20:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593950;
        bh=Qq5+Pd5ZEXH8JI+FXJrqFDMhbWQ9+lFV5YV4MmmrBQo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xHut8VJsBFR2u6ji1Gf2YD88erOT4Cm5EFPpASnjx3S955D8aUdxAER8QRe7QopZE
         t6BqFa2YaLyv/ZadiuxolggDbNEwhB23jeE7KfBy5RU21zRKdLIpUTBvLijddbQuWb
         daKgJ9dFoVac2tZ7X+CEvHvo5EQOqk9Jv55UZUrE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0353/1157] crypto: sun8i-ss - Fix error codes for dma_mapping_error()
Date:   Mon, 15 Aug 2022 19:55:09 +0200
Message-Id: <20220815180453.834444151@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 6cb3f9b25c55928b95a02b9ed8e87ed653b3cce8 ]

If there is a dma_mapping_error() then return negative error codes.
Currently this code returns success.

Fixes: 801b7d572c0a ("crypto: sun8i-ss - add hmac(sha1)")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Tested-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
index ac417a6b39e5..845019bd9591 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
@@ -586,7 +586,8 @@ int sun8i_ss_hash_run(struct crypto_engine *engine, void *breq)
 			rctx->t_dst[k + 1].len = rctx->t_dst[k].len;
 		}
 		addr_xpad = dma_map_single(ss->dev, tfmctx->ipad, bs, DMA_TO_DEVICE);
-		if (dma_mapping_error(ss->dev, addr_xpad)) {
+		err = dma_mapping_error(ss->dev, addr_xpad);
+		if (err) {
 			dev_err(ss->dev, "Fail to create DMA mapping of ipad\n");
 			goto err_dma_xpad;
 		}
@@ -612,7 +613,8 @@ int sun8i_ss_hash_run(struct crypto_engine *engine, void *breq)
 			goto err_dma_result;
 		}
 		addr_xpad = dma_map_single(ss->dev, tfmctx->opad, bs, DMA_TO_DEVICE);
-		if (dma_mapping_error(ss->dev, addr_xpad)) {
+		err = dma_mapping_error(ss->dev, addr_xpad);
+		if (err) {
 			dev_err(ss->dev, "Fail to create DMA mapping of opad\n");
 			goto err_dma_xpad;
 		}
-- 
2.35.1



