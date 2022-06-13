Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0BD45492D8
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358448AbiFMMAF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:00:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357288AbiFML4u (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:56:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CDA84D9DF;
        Mon, 13 Jun 2022 03:56:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0BA0261347;
        Mon, 13 Jun 2022 10:56:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16CAAC3411C;
        Mon, 13 Jun 2022 10:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655117774;
        bh=e9Upjv2UjuVKFm0ao7tdajLsppKQwhgrBqFX6MFyU+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J4ynSbfUWgPXO5PwdTFLljAaW924bTGM5kPqrS5dIaTYODDkDlBrjlzAC/V9QK8mC
         Bht5H6wBOYYDozYAC9hUmUztO9BIng9V87kk69DySmb16II/qXO7rhn6SW7K01lSxL
         cZ1C+BfdpnnGzeLK7o9OZLI34UfrK6WurFbZUl/Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 115/287] crypto: marvell/cesa - ECB does not IV
Date:   Mon, 13 Jun 2022 12:08:59 +0200
Message-Id: <20220613094927.365926335@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094923.832156175@linuxfoundation.org>
References: <20220613094923.832156175@linuxfoundation.org>
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
 drivers/crypto/marvell/cipher.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/marvell/cipher.c b/drivers/crypto/marvell/cipher.c
index 0ae84ec9e21c..c9b905efc448 100644
--- a/drivers/crypto/marvell/cipher.c
+++ b/drivers/crypto/marvell/cipher.c
@@ -625,7 +625,6 @@ struct skcipher_alg mv_cesa_ecb_des3_ede_alg = {
 	.decrypt = mv_cesa_ecb_des3_ede_decrypt,
 	.min_keysize = DES3_EDE_KEY_SIZE,
 	.max_keysize = DES3_EDE_KEY_SIZE,
-	.ivsize = DES3_EDE_BLOCK_SIZE,
 	.base = {
 		.cra_name = "ecb(des3_ede)",
 		.cra_driver_name = "mv-ecb-des3-ede",
-- 
2.35.1



