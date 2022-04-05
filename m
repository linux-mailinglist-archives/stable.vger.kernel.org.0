Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8B24F2622
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:52:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232486AbiDEHym (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:54:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232546AbiDEHxX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:53:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A4541D338;
        Tue,  5 Apr 2022 00:49:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC26DB81B90;
        Tue,  5 Apr 2022 07:48:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B65FC340EE;
        Tue,  5 Apr 2022 07:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144937;
        bh=dXBza7TD+YoPMa9zfIkCunjP9xDZ6gtzlNfgpEIYRcc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fMGn25a9eZXF/mwHJa+uwZQL3I/BL5Cpt4TMjThR5FEYuAKovPzCl/r6wuH+Xaxax
         eLoPMgj5TZn91NGZVzStAf80O0Ou2bUx6WAWko/byYCaj3zfph1346Ys5b7zfiljCn
         qeTGh5m3MdelR9NBPJ78WjQGLGrUzmc7vbWb2N7U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0226/1126] crypto: rockchip - ECB does not need IV
Date:   Tue,  5 Apr 2022 09:16:13 +0200
Message-Id: <20220405070414.242876601@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Corentin Labbe <clabbe@baylibre.com>

[ Upstream commit 973d74e93820d99d8ea203882631c76edab699c9 ]

When loading rockchip crypto module, testmgr complains that ivsize of ecb-des3-ede-rk
is not the same than generic implementation.
In fact ECB does not use an IV.

Fixes: ce0183cb6464b ("crypto: rockchip - switch to skcipher API")
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/rockchip/rk3288_crypto_skcipher.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/rockchip/rk3288_crypto_skcipher.c b/drivers/crypto/rockchip/rk3288_crypto_skcipher.c
index 1cece1a7d3f0..5bbf0d2722e1 100644
--- a/drivers/crypto/rockchip/rk3288_crypto_skcipher.c
+++ b/drivers/crypto/rockchip/rk3288_crypto_skcipher.c
@@ -506,7 +506,6 @@ struct rk_crypto_tmp rk_ecb_des3_ede_alg = {
 		.exit			= rk_ablk_exit_tfm,
 		.min_keysize		= DES3_EDE_KEY_SIZE,
 		.max_keysize		= DES3_EDE_KEY_SIZE,
-		.ivsize			= DES_BLOCK_SIZE,
 		.setkey			= rk_tdes_setkey,
 		.encrypt		= rk_des3_ede_ecb_encrypt,
 		.decrypt		= rk_des3_ede_ecb_decrypt,
-- 
2.34.1



