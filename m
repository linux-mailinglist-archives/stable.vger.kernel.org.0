Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB63594025
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244098AbiHOU4s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346931AbiHOU4C (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:56:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE8E24F196;
        Mon, 15 Aug 2022 12:11:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78886B810A3;
        Mon, 15 Aug 2022 19:11:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE827C433B5;
        Mon, 15 Aug 2022 19:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590695;
        bh=65ljVjHidvP03ijUNO/zjfxop07YULtw68E7rTTUr9s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=daz7cqvfAvSkCXJ6qB38vPUZuKa4t0T54BL66TewtDr1IhCks1sQtnCe4B38IM9tG
         4yp6oKfwHyVYE33GZv5cFB7a1qccPp25vZ+qbSadg5NS4Cnjm3RmoWAXZvMZLYYsTN
         UcwpV03+xDhPkP6CT35x90qReQ88/7o3TysNK/LQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0342/1095] crypto: sun8i-ss - fix infinite loop in sun8i_ss_setup_ivs()
Date:   Mon, 15 Aug 2022 19:55:41 +0200
Message-Id: <20220815180443.950668835@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: Alexey Khoroshilov <khoroshilov@ispras.ru>

[ Upstream commit d61a7b3decf7f0cf4121a7204303deefd2c7151b ]

There is no i decrement in while (i >= 0) loop.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Fixes: 359e893e8af4 ("crypto: sun8i-ss - rework handling of IV")
Acked-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Tested-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
index 70e2e6e37389..3c46ad8c3a1c 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
@@ -151,6 +151,7 @@ static int sun8i_ss_setup_ivs(struct skcipher_request *areq)
 	while (i >= 0) {
 		dma_unmap_single(ss->dev, rctx->p_iv[i], ivsize, DMA_TO_DEVICE);
 		memzero_explicit(sf->iv[i], ivsize);
+		i--;
 	}
 	return err;
 }
-- 
2.35.1



