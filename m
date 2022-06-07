Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D720541516
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355672AbiFGU2q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:28:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359567AbiFGUXD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:23:03 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F076965D3;
        Tue,  7 Jun 2022 11:32:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6DE81CE242B;
        Tue,  7 Jun 2022 18:32:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53A22C385A2;
        Tue,  7 Jun 2022 18:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626726;
        bh=yCzJMVCUlRwnYxLiqzwsBgrMgG0o7TJdZI532aPA9YI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TQI6XFaizjnzW3tcuuS+9Sl45/Sv6pGVEUWvLrsReXUkm7G8FFQ3wXBhU6bxl+dBE
         5vdXTjBiDnk001CVMrtEi/aZH6fKqK/1wYnVZddUgIB7e7STCPj/Q99ZbQfEchDTFZ
         LcTMFK7AmZeidO4brppMCoZcgnavfFBNlprjnlH4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 483/772] crypto: marvell/cesa - ECB does not IV
Date:   Tue,  7 Jun 2022 19:01:15 +0200
Message-Id: <20220607165003.220838347@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Corentin Labbe <clabbe@baylibre.com>

[ Upstream commit 4ffa1763622ae5752961499588f3f8874315f974 ]

The DES3 ECB has an IV size set but ECB does not need one.

Fixes: 4ada483978237 ("crypto: marvell/cesa - add Triple-DES support")
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/marvell/cesa/cipher.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/marvell/cesa/cipher.c b/drivers/crypto/marvell/cesa/cipher.c
index b739d3b873dc..c6f2fa753b7c 100644
--- a/drivers/crypto/marvell/cesa/cipher.c
+++ b/drivers/crypto/marvell/cesa/cipher.c
@@ -624,7 +624,6 @@ struct skcipher_alg mv_cesa_ecb_des3_ede_alg = {
 	.decrypt = mv_cesa_ecb_des3_ede_decrypt,
 	.min_keysize = DES3_EDE_KEY_SIZE,
 	.max_keysize = DES3_EDE_KEY_SIZE,
-	.ivsize = DES3_EDE_BLOCK_SIZE,
 	.base = {
 		.cra_name = "ecb(des3_ede)",
 		.cra_driver_name = "mv-ecb-des3-ede",
-- 
2.35.1



