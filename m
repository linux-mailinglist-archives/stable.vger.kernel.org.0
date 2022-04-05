Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 581CF4F2CC0
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347556AbiDEJ1b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:27:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244084AbiDEIvi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:51:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E29FD3714;
        Tue,  5 Apr 2022 01:40:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B17DB614F9;
        Tue,  5 Apr 2022 08:40:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C093DC385A0;
        Tue,  5 Apr 2022 08:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148022;
        bh=4indgIxOVeCiK3xftlvX5TxwsieTy/0NnuibO7kTWwg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bqy9O7F93/8gMCa4ESIptYeLlauw671wqwOR2CuIbZv+/ztHeALKKacMKQE17SO5h
         ceDFzZqXpHmjJEZ2FghjamdF20+5J1kQURyoDszhovhRpxpzj9F+i8a6SOty9mPD47
         9H9463TXWIy0FzJ7xqqSvY6Rr0mB/XkI/64cZ/RA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0206/1017] crypto: sun8i-ss - really disable hash on A80
Date:   Tue,  5 Apr 2022 09:18:39 +0200
Message-Id: <20220405070400.365649141@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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

[ Upstream commit 881fc7fba6c3e7d77d608b9a50b01a89d5e0c61b ]

When adding hashes support to sun8i-ss, I have added them only on A83T.
But I forgot that 0 is a valid algorithm ID, so hashes are enabled on A80 but
with an incorrect ID.
Anyway, even with correct IDs, hashes do not work on A80 and I cannot
find why.
So let's disable all of them on A80.

Fixes: d9b45418a917 ("crypto: sun8i-ss - support hash algorithms")
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
index 80e89066dbd1..319fe3279a71 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
@@ -30,6 +30,8 @@
 static const struct ss_variant ss_a80_variant = {
 	.alg_cipher = { SS_ALG_AES, SS_ALG_DES, SS_ALG_3DES,
 	},
+	.alg_hash = { SS_ID_NOTSUPP, SS_ID_NOTSUPP, SS_ID_NOTSUPP, SS_ID_NOTSUPP,
+	},
 	.op_mode = { SS_OP_ECB, SS_OP_CBC,
 	},
 	.ss_clks = {
-- 
2.34.1



